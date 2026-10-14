--Create Data Mart
CREATE SCHEMA hdb_db.data_mart;
CREATE OR REPLACE TABLE hdb_db.data_mart.avg_price_by_town AS
SELECT town, ROUND(AVG(price_per_sqm), 0) AS avg_price_per_sqm
FROM hdb_db.staging.stg_resale_flats
GROUP BY town
ORDER BY avg_price_per_sqm DESC;

CREATE OR REPLACE TABLE hdb_db.data_mart.avg_price_by_year AS
SELECT YEAR(month_date) as year, ROUND(AVG(price_per_sqm), 0) AS avg_price_per_sqm
FROM hdb_db.staging.stg_resale_flats
GROUP BY year
ORDER BY year;

SELECT * FROM hdb_db.data_mart.avg_price_by_town LIMIT 5;
SELECT * FROM hdb_db.data_mart.avg_price_by_year LIMIT 5;

--Verify Timeline
SELECT MIN(month_date), MAX(month_date) 
FROM hdb_db.staging.stg_resale_flats;

--Obtain Price per sqm of each flat type belonging to each town
SELECT town, flat_type, ROUND(AVG(price_per_sqm),0) AS avg_price_per_sqm
FROM hdb_db.staging.stg_resale_flats
GROUP BY town, flat_type
ORDER BY town DESC;


--Verify why there are only 131 rows, if each town does not have all flat types
SELECT flat_type, COUNT(DISTINCT town)
FROM hdb_db.staging.stg_resale_flats
GROUP BY flat_type;
--Found that each flat type did not cover all the towns

--Compute average price per sqm for each town's flat types
--Include number of sales per town's flat type to assess weight of each average
SELECT town, flat_type, COUNT(*) AS number_of_sales, ROUND(AVG(price_per_sqm),0)
FROM hdb_db.staging.stg_resale_flats
GROUP BY town, flat_type
ORDER BY town, flat_type;

--Create Permanent table for the data mart
CREATE OR REPLACE TABLE hdb_db.data_mart.avg_price_by_town_flat_type AS
SELECT town, flat_type, COUNT(*) AS number_of_sales, ROUND(AVG(price_per_sqm),0) AS avg_price_per_sqm
FROM hdb_db.staging.stg_resale_flats
GROUP BY town,flat_type
ORDER BY town,flat_type;

SELECT * FROM hdb_db.data_mart.avg_price_by_town_flat_type