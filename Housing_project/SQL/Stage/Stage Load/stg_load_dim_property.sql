CREATE OR REPLACE PROCEDURE stg.load_dim_property()
LANGUAGE plpgsql
AS $$
/****************************************************************************
** Proc: stg.load_dim_property()
** Desc: Loads distinct property data from stg.listings into dim.property.
**          Deduplicates on property_id using most recent last_update_date.
**          Processes only the most recent batch.
** Author: CCieri + Claude
** Created: 2026-06-09
** Usage: CALL stg.load_dim_property()
*****************************************************************************/

BEGIN
    -- #1. CREATE TEMP TABLE with DISTINCT property_id from most recent batch
    CREATE TEMP TABLE temp_property AS 
    SELECT DISTINCT ON (property_id)
       property_id,
       style,
       full_street_line,
       street,
       unit,
       CAST(beds as NUMERIC),
       CAST(full_baths as NUMERIC),
       CAST(half_baths as NUMERIC),
       CAST(sqft as NUMERIC),
       CAST(year_built as NUMERIC),
       CAST(new_construction as BOOLEAN),
       CAST(lot_sqft as NUMERIC),
       CAST(stories as NUMERIC),
       CAST(parking_garage as NUMERIC),
       CAST(latitude as NUMERIC),
       CAST(longitude as NUMERIC) 
    FROM stg.listings 
    WHERE batch_id = (SELECT MAX(batch_id) FROM stg.batch)
    ORDER BY property_id, last_update_date DESC;

    -- #2. UPSERT into dim.property (Equivalent of SQL Server MERGE)
    INSERT INTO dim.property 
    (property_id, style, 
    full_street_line, street, unit, 
    beds, full_baths, half_baths, 
    sqft, year_built, new_construction, lot_sqft, stories, parking_garage, 
    latitude, longitude
    )
    SELECT 
    property_id, style, 
    full_street_line, street, unit, 
    beds, full_baths, half_baths, 
    sqft, year_built, new_construction, lot_sqft, stories, parking_garage, 
    latitude, longitude
    FROM temp_property
    ON CONFLICT (property_id)
    DO UPDATE SET
    style = EXCLUDED.style,
    full_street_line = EXCLUDED.full_street_line,
    street = EXCLUDED.street,
    unit = EXCLUDED.unit,
    beds = EXCLUDED.beds,
    full_baths = EXCLUDED.full_baths,
    half_baths = EXCLUDED.half_baths,
    sqft = EXCLUDED.sqft,
    year_built = EXCLUDED.year_built,
    new_construction = EXCLUDED.new_construction,
    lot_sqft = EXCLUDED.lot_sqft,
    stories = EXCLUDED.stories,
    parking_garage = EXCLUDED.parking_garage,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

    -- #3. Drop Temp 
    DROP TABLE temp_property;

END;
$$;