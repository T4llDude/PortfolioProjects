CREATE TABLE IF NOT EXISTS fact.listing
(
    fact_listing_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    dim_property_id integer NOT NULL,
    dim_geography_id integer NOT NULL,
    property_id text COLLATE pg_catalog."default",
    status text COLLATE pg_catalog."default",
    list_price numeric,
    list_date date,
    pending_date date,
    days_on_mls integer,
    sold_price numeric,
    last_sold_date date,
    last_sold_price numeric,
    price_per_sqft numeric,
    hoa_fee numeric,
    last_status_change_date date,
    last_update_date timestamp with time zone,
    CONSTRAINT listing_pkey PRIMARY KEY (fact_listing_id),
    CONSTRAINT fact_listing_property_id_key UNIQUE (property_id),
    CONSTRAINT listing_dim_geography_id_fkey FOREIGN KEY (dim_geography_id)
        REFERENCES dim.geography (dim_geography_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT listing_dim_property_id_fkey FOREIGN KEY (dim_property_id)
        REFERENCES dim.property (dim_property_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE fact.listing
    OWNER to housing_etl;