CREATE TABLE IF NOT EXISTS dim.geography
(
    dim_geography_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zip_code text COLLATE pg_catalog."default",
    city text COLLATE pg_catalog."default",
    county text COLLATE pg_catalog."default",
    state_code text COLLATE pg_catalog."default",
    CONSTRAINT geography_pkey PRIMARY KEY (dim_geography_id),
    CONSTRAINT uq_zip_city_county UNIQUE (zip_code, city, county)
)

TABLESPACE pg_default;

ALTER TABLE dim.geography
    OWNER to housing_etl;