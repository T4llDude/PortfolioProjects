CREATE TABLE IF NOT EXISTS dim.property
(
    dim_property_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    property_id text COLLATE pg_catalog."default",
    style text COLLATE pg_catalog."default",
    full_street_line text COLLATE pg_catalog."default",
    street text COLLATE pg_catalog."default",
    unit text COLLATE pg_catalog."default",
    beds numeric,
    full_baths numeric,
    half_baths numeric,
    sqft numeric,
    year_built numeric,
    new_construction boolean,
    lot_sqft numeric,
    stories numeric,
    parking_garage numeric,
    latitude numeric,
    longitude numeric,
    CONSTRAINT property_pkey PRIMARY KEY (dim_property_id),
    CONSTRAINT uq_property_id UNIQUE (property_id)
)

TABLESPACE pg_default;

ALTER TABLE dim.property
    OWNER to housing_etl;