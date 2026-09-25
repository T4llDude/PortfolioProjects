from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import os
from datetime import date, timedelta
from extract import get_property_dataframe
import pandas as pd
import logging 

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
log = logging.getLogger(__name__)

# Import environment variables
load_dotenv()

# get_property_dataframe variables
from_date = date.today() - timedelta(days=3) #3 days before today
to_date = date.today()

# Create Engine
engine = create_engine(os.getenv("DB_URL"))

# declare batch_id
batch_id = None

# Check connection 
try:
    with engine.connect() as conn:
        log.info("Connection success!")

        # Pull dataframe from extract.py
        log.info("Extracting data from homeharvest...")
        df = get_property_dataframe(from_date, to_date)
        log.info(f"Extract complete. {len(df)} rows retrieved.")

        # Grab specific columns for table
        log.info("Subsetting columns...")
        listings_df = df[['property_id', 'status', 'style', 'full_street_line', 'street', 'unit', 'city', 'state', 'zip_code', 'beds', 'full_baths', 'half_baths', 'sqft', 'year_built', 'days_on_mls', 'list_price', 'list_date', 'pending_date', 'sold_price', 'last_sold_date', 'last_sold_price', 'last_status_change_date', 'last_update_date', 'new_construction', 'lot_sqft', 'price_per_sqft', 'latitude', 'longitude', 'county', 'stories', 'hoa_fee', 'parking_garage']].copy()

        # Insert to stg.batch, retrieve recent batch_id
        log.info("Inserting batch record...")
        result = conn.execute(text("""
            INSERT INTO stg.batch (batch_status, is_test)
            VALUES ('started', TRUE)
            RETURNING batch_id
        """))
        batch_id = result.scalar()
        conn.commit()
        log.info(f"Batch record created. batch_id: {batch_id}")

        # Grab batchKey and include as new column on df
        listings_df['batch_id'] = batch_id

        # Check column output to 33
        print(listings_df.shape)


        # Insert stg.listings
        log.info("Loading data to stg.listings...")
        listings_df.to_sql('listings', con=engine, schema='stg', if_exists='append', index=False)
        log.info(f"{len(listings_df)} rows loaded to stg.listings.")

        # Update batch table with success
        log.info("Updating batch record to complete...")
        conn.execute(text("""
                    UPDATE stg.batch 
                    SET batch_status = 'complete',
                          batch_end_date = CURRENT_TIMESTAMP  
                    WHERE batch_id = :batch_id                      
                    """),  {"batch_id": batch_id})
        conn.commit()
        log.info("Pipeline complete!")
        
except Exception as error:
    log.error(f"Pipeline failure occurred: {error}", exc_info=True)
    if batch_id is not None:
        try:
            with engine.connect() as fail_conn:
                fail_conn.execute(text("""
                    UPDATE stg.batch 
                    SET batch_status = 'failed',
                        batch_end_date = CURRENT_TIMESTAMP
                    WHERE batch_id = :batch_id
                """), {"batch_id": batch_id})
                fail_conn.commit()
        except Exception as update_error:
            log.error(f"Failed to update batch status: {update_error}")