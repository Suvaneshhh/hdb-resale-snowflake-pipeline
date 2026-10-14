-- Establishing Data Types

CREATE WAREHOUSE hdb_wh WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
CREATE DATABASE hdb_db;
CREATE SCHEMA hdb_db.raw;
SHOW WAREHOUSES;
SHOW SCHEMAS IN DATABASE hdb_db;
CREATE TABLE hdb_db.raw.resale_flats(
month VARCHAR,
town VARCHAR,
flat_type VARCHAR,
block VARCHAR,
street_name VARCHAR,
storey_range VARCHAR,
floor_area_sqm NUMBER,
flat_model VARCHAR,
lease_commence_date NUMBER,
remaining_lease VARCHAR,
resale_price NUMBER
);
DESCRIBE TABLE hdb_db.raw.resale_flats;
SELECT COUNT(*) FROM hdb_db.raw.resale_flats;
SELECT * FROM hdb_db.raw.resale_flats LIMIT 5;
