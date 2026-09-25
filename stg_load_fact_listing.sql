CREATE OR REPLACE PROCEDURE stg.load_fact_listing()
LANGUAGE plpgsql
AS $$
/****************************************************************************
** Proc: stg.load_fact_listing()
** Desc: Loads distinct property data from stg.listings into fact.listing.
**          Updates on property_id using most recent last_update_date.
**          Processes only the most recent batch.
** Author: CCieri + Claude
** Created: 2026-06-29
** Usage: CALL stg.load_fact_listing()
*****************************************************************************/

BEGIN  

-- Create the temp table to store Fact values alongside Dim_ids/keys
CREATE TEMP TABLE temp_fact_listing AS 
SELECT DISTINCT ON (property_id)
 property_id
,0 as dim_property_id  
,0 as dim_geography_id 
,zip_code 
,city 
,county
,"state"
,status 
,CAST(list_price AS NUMERIC) 
,CAST(list_date AS DATE)
,CAST(pending_date AS DATE)
,CAST(days_on_mls AS INT4) 
,CAST(sold_price AS NUMERIC)
,CAST(last_sold_date AS DATE)
,CAST(last_sold_price AS NUMERIC)
,CAST(price_per_sqft AS NUMERIC)
,CAST(hoa_fee AS NUMERIC)
,CAST(last_status_change_date AS DATE)
,CAST(last_update_date AS TIMESTAMPTZ) 
FROM stg.listings stg 
WHERE batch_id = (SELECT MAX(batch_id) FROM stg.batch)
    ORDER BY property_id, last_update_date DESC;

/* Update Dim_property_id */
UPDATE temp_fact_listing
SET dim_property_id = dp.dim_property_id
FROM dim.property dp 
WHERE 
dp.property_id = temp_fact_listing.property_id;

-- Validate Dim_Property_id
IF EXISTS (
    SELECT 1 FROM temp_fact_listing WHERE dim_property_id = 0
) THEN
    RAISE EXCEPTION 'load_fact_listing: dim.property lookup failed. Unresolved property_ids exist in temp_fact_listing.';
END IF;

/* Update Dim_geography_id */
UPDATE temp_fact_listing
SET dim_geography_id = dg.dim_geography_id
FROM dim.geography dg 
WHERE 
dg.zip_code = temp_fact_listing.zip_code 
    AND dg.city = temp_fact_listing.city 
        AND dg.county = temp_fact_listing.county 
            AND dg.state_code = temp_fact_listing."state";

-- Validate Dim_geography_id
IF EXISTS (
    SELECT 1 FROM temp_fact_listing WHERE dim_geography_id = 0
) THEN
    RAISE EXCEPTION 'load_fact_listing: dim.geography lookup failed. Unresolved geography_ids exist in temp_fact_listing.';
END IF;

/* Insert to fact.listing */
INSERT INTO fact.listing (
     property_id
    ,dim_property_id
    ,dim_geography_id
    ,status
    ,list_price
    ,list_date
    ,pending_date
    ,days_on_mls
    ,sold_price
    ,last_sold_date
    ,last_sold_price
    ,price_per_sqft
    ,hoa_fee
    ,last_status_change_date
    ,last_update_date
)
SELECT
     property_id
    ,dim_property_id
    ,dim_geography_id
    ,status
    ,list_price
    ,list_date
    ,pending_date
    ,days_on_mls
    ,sold_price
    ,last_sold_date
    ,last_sold_price
    ,price_per_sqft
    ,hoa_fee
    ,last_status_change_date
    ,last_update_date
FROM temp_fact_listing
ON CONFLICT (property_id)
DO UPDATE SET
     dim_property_id = EXCLUDED.dim_property_id
    ,dim_geography_id = EXCLUDED.dim_geography_id
    ,status = EXCLUDED.status
    ,list_price = EXCLUDED.list_price
    ,list_date = EXCLUDED.list_date 
    ,pending_date = EXCLUDED.pending_date 
    ,days_on_mls = EXCLUDED.days_on_mls
    ,sold_price = EXCLUDED.sold_price
    ,last_sold_date = EXCLUDED.last_sold_date
    ,last_sold_price = EXCLUDED.last_sold_price
    ,price_per_sqft = EXCLUDED.price_per_sqft
    ,hoa_fee = EXCLUDED.hoa_fee
    ,last_status_change_date = EXCLUDED.last_status_change_date
    ,last_update_date = EXCLUDED.last_update_date;


    -- #3. Drop Temp 
    DROP TABLE temp_fact_listing;


END  
$$;