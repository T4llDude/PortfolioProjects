CREATE TABLE IF NOT EXISTS stg.batch
(
    batch_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    batch_start_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    batch_end_date timestamp without time zone,
    batch_status text COLLATE pg_catalog."default",
    is_test BOOLEAN DEFAULT FALSE,
    CONSTRAINT batch_pkey PRIMARY KEY (batch_id),
    CONSTRAINT batch_batch_status_check CHECK (batch_status = ANY (ARRAY['started'::text, 'complete'::text, 'failed'::text]))
)

TABLESPACE pg_default;

ALTER TABLE stg.batch
    OWNER to housing_etl;


