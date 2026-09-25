# Baltimore Housing Market ETL & Dashboard

An end-to-end data pipeline that extracts residential listing data for the Baltimore metro area, transforms and loads it into a normalized PostgreSQL warehouse, and surfaces it through an interactive Power BI dashboard.

## Background

Zillow and Redfin are built for browsing individual listings, not analyzing market trends. I wanted to track pricing patterns, inventory shifts, and listing characteristics across the Baltimore metro area as I evaluated relocation, so I built an ETL pipeline that consolidates and normalizes listing data into a structured warehouse I could actually query and visualize.

## Overview

This project pulls active, single-family listing data via the `homeharvest` library, then runs it through a Python-orchestrated ETL process into PostgreSQL, where SQL stored procedures handle deduplication, normalization, and dimensional loading. The result feeds a Power BI dashboard tracking pricing trends, property characteristics, and geographic distribution across Baltimore City, Baltimore County, and Anne Arundel County.

## Tech Stack

- **Extraction:** Python (`homeharvest`, `pandas`)
- **Loading:** `sqlalchemy`, `psycopg2-binary`, `python-dotenv`
- **Warehouse:** PostgreSQL (staging → dimension/fact star schema, stored procedures)
- **Visualization:** Power BI Desktop
- **Tooling:** VS Code, Git Bash

Listing data sourced via [HomeHarvest](https://github.com/ZacharyHampton/HomeHarvest) (MIT licensed), which retrieves data from Realtor.com.

## Architecture

The warehouse follows a star schema:

- **Staging:** `stg.listings`, `stg.batch` — raw landing zone per pipeline run
- **Dimensions:** `dim.geography`, `dim.property`, `dim.date`
- **Fact:** `fact.listing` — one current-state row per property, keyed on `property_id`

Every load follows the same pattern: land to a temp table, deduplicate, upsert via `ON CONFLICT`, then clean up. Fact loads validate every dimension key resolves before committing — a single unresolved lookup rolls back the entire batch, rather than allowing partial or orphaned fact rows.

## Key Engineering Decisions

- **Composite natural key for geography.** Zip codes in this region aren't unique to a single city/county pair, so `dim.geography` is keyed on `(zip_code, city, county)` rather than zip code alone.
- **Centralized normalization functions.** Reusable SQL functions handle NULL and placeholder cleanup (e.g., `'Call Listing Agent'` → `'Unknown'`) consistently across every dimension and fact load, rather than duplicating logic inline.
- **Native date intelligence.** `dim.date` is marked as a proper Power BI date table rather than relying on auto-generated hierarchies, enabling accurate time-based calculations.

## Dashboard

The Power BI dashboard visualizes:

- Listing status distribution (for sale, pending, contingent)
- Average list vs. sold price
- Property distribution by county
- Bedroom and story counts across the active inventory

## Future Enhancements

- Incremental-load monitoring that flags newly unresolved dimension values rather than requiring manual review
- Integration of supplemental market data (Zillow Research, Redfin Data Center) for broader trend analysis
- Migration of the local environment to Linux Mint

## Skills Demonstrated

Python ETL scripting, PostgreSQL schema design and stored procedures, data normalization strategy, star schema modeling, and Power BI report design.

## Development Note

Developed with Claude (Anthropic) as a pair-programming and code-review collaborator; all schema design, architecture decisions, and trade-off calls are my own.