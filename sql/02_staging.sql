-- Staging Process

CREATE SCHEMA hdb_db.staging;
SELECT DISTINCT flat_type FROM hdb_db.raw.resale_flats;

-- Convert month format
SELECT month,
TO_DATE(month || '-01') AS month_date
FROM hdb_db.raw.resale_flats
LIMIT 5;

-- Obtain price per square meter
SELECT resale_price, floor_area_sqm, resale_price/floor_area_sqm AS price_per_sqm
FROM hdb_db.raw.resale_flats
LIMIT 5;

--Create Permanent Staging Table
CREATE OR REPLACE TABLE hdb_db.staging.stg_resale_flats AS
SELECT TO_DATE(month || '-01') AS month_date,
town,
flat_type,
floor_area_sqm,
resale_price,
resale_price/floor_area_sqm AS price_per_sqm
FROM hdb_db.raw.resale_flats;

-- Reconciling row counts between layers
SELECT * FROM hdb_db.staging.stg_resale_flats
LIMIT 5;
SELECT COUNT(*) FROM hdb_db.staging.stg_resale_flats;
SELECT COUNT(*) FROM hdb_db.raw.resale_flats;

-- Compute price per sqm by town
SELECT town, AVG(price_per_sqm) AS avg_price_per_sqm
FROM hdb_db.staging.stg_resale_flats
GROUP BY town
ORDER BY avg_price_per_sqm DESC;

-- Compute price over time with no decimal places
SELECT YEAR(month_date) AS year, ROUND(AVG(price_per_sqm),0) AS avg_price_per_sqm
FROM hdb_db.staging.stg_resale_flats
GROUP BY year
ORDER BY year ASC;
