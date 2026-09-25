-- =============================================================================
-- Functions: stg.normalize_text / stg.normalize_geography
-- Description: Utilizes two functions to replace NULL or place-holder values 
--              with the same default 'Unknown' values. 
-- Usage:
-- 1. load_dim_geography()
-- SELECT s.property_id, n.zip_code, n.city, n.county, n.state
-- FROM stg.listings s
-- CROSS JOIN LATERAL stg.normalize_geography(s.zip_code, s.city, s.county, s.state) AS n;

-- 2. load_fact_listing()
-- UPDATE temp_fact_listing t
-- SET geography_id = g.geography_id
-- FROM stg.normalize_geography(t.raw_zip_code, t.raw_city, t.raw_county, t.raw_state) AS n
-- JOIN dim.geography g
--   ON g.zip_code = n.zip_code AND g.city = n.city AND g.county = n.county
-- WHERE ...;
-- =============================================================================

-- Single-field cleanup, reusable across geography and (per the project's own
-- convention) any future dimension that needs the same NULL/placeholder rules.
CREATE OR REPLACE FUNCTION stg.normalize_text(p_value text)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    v_trimmed text;
BEGIN
    v_trimmed := TRIM(p_value);

    IF v_trimmed IS NULL OR v_trimmed = '' THEN
        RETURN 'Unknown';
    END IF;

    IF UPPER(v_trimmed) IN ('CALL LISTING AGENT', 'N/A', 'NONE', 'NULL', 'UNKNOWN') THEN
        RETURN 'Unknown';
    END IF;

    RETURN v_trimmed;
END;
$$;

-- Geography-specific wrapper: takes the four raw fields, returns the four
-- normalized fields as a table function (one row in, one row out).
CREATE OR REPLACE FUNCTION stg.normalize_geography(
    p_zip_code text,
    p_city     text,
    p_county   text,
    p_state    text
)
RETURNS TABLE (
    zip_code text,
    city     text,
    county   text,
    state    text
)
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
    RETURN QUERY
    SELECT
        stg.normalize_text(p_zip_code),
        stg.normalize_text(p_city),
        stg.normalize_text(p_county),
        stg.normalize_text(p_state);
END;
$$;