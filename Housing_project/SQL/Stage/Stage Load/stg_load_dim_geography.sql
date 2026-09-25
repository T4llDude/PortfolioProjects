CREATE OR REPLACE PROCEDURE stg.load_dim_geography()
LANGUAGE plpgsql
AS $$
/****************************************************************************
** Proc: stg.load_dim_geography
** Desc: Loads distinct geographic data from stg.listings into dim.geography.
**          Deduplicates on (zip_code, city, county) using stg.normalize_geography()
**          for all NULL/placeholder cleanup. Processes only the most recent batch.
** Author: CCieri + Claude
** Created: 2026-06-09
** Usage: CALL stg.load_dim_geography()
*****************************************************************************/

BEGIN
    -- #1. CREATE TEMP TABLE from most recent batch, normalizing zip/city/county/state
    DROP TABLE IF EXISTS temp_geography;

    CREATE TEMP TABLE temp_geography AS
    SELECT DISTINCT
        n.zip_code,
        n.city,
        n.county,
        n.state
    FROM stg.listings s
    CROSS JOIN LATERAL stg.normalize_geography(s.zip_code, s.city, s.county, s.state) AS n
    WHERE s.batch_id = (SELECT MAX(batch_id) FROM stg.batch);

    -- #2. INSERT into dim.geography (equivalent of SQL Server MERGE).
    INSERT INTO dim.geography (zip_code, city, county, state_code)
    SELECT DISTINCT
        zip_code,
        city,
        county,
        state AS state_code
    FROM temp_geography
    ON CONFLICT (zip_code, city, county) DO NOTHING;

    -- #3. Drop Temp
    DROP TABLE temp_geography;

END;
$$;