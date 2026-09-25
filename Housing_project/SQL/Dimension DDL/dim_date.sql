CREATE TABLE IF NOT EXISTS dim.date
(
    dim_date_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    full_date date,
    day integer,
    month integer,
    month_name text COLLATE pg_catalog."default",
    quarter integer,
    year integer,
    day_of_week integer,
    is_weekend boolean,
    CONSTRAINT date_pkey PRIMARY KEY (dim_date_id),
    CONSTRAINT dim_date_full_date_key UNIQUE (full_date)
)

TABLESPACE pg_default;

ALTER TABLE dim.date
    OWNER to housing_etl;