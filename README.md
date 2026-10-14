\# HDB Resale Prices: An End-to-end analytics pipeline using Snowflake, Power BI, Git \& Github



A layered SQL pipeline in Snowflake (RAW → STAGING → DATA\_MART) over Singapore HDB resale flat transactions from Jan 2017 to Oct 2026, with a Power BI dashboard on price per square metre by year, town and flat type.



> Personal portfolio project built on a Snowflake trial account. The data load is manual (see "How to reproduce"); nothing here runs on a schedule.



\## Overview



The source is the public "Resale flat prices based on registration date from Jan-2017 onwards" dataset published by HDB on data.gov.sg (https://data.gov.sg/datasets?query=hdb+resale\&resultId=d\_8b84c4ee58e3cfc0ece0d773c8ca6abc). The raw CSV is loaded into Snowflake, cleaned and typed in a staging layer, and summarised into data mart tables that Power BI reads.



\## Questions answered



1\. How has the average resale price per square metre changed since 2017, and which towns are the most expensive?

2\. How does price per square metre vary by town and flat type?



\## Architecture



```

CSV (data.gov.sg)

&#x20;  │  manual load via Snowsight

&#x20;  ▼

RAW        hdb\_db.raw.resale\_flats           source data, untouched

&#x20;  │  cast types, derive month\_date and price\_per\_sqm

&#x20;  ▼

STAGING    hdb\_db.staging.stg\_resale\_flats   cleaned, typed

&#x20;  │  aggregate with GROUP BY

&#x20;  ▼

DATA\_MART  avg\_price\_by\_year

&#x20;          avg\_price\_by\_town

&#x20;          avg\_price\_by\_town\_flat\_type       (includes number\_of\_sales)

&#x20;  │  Power BI (Import mode)

&#x20;  ▼

Dashboard  dashboard/hdb\_dashboard.pbix

```



\## Tech stack



Snowflake (warehouse, schemas, SQL), SQL, Power BI Desktop, Git and GitHub.



\## Repository structure



```

sql/

&#x20; 01\_setup\_and\_raw.sql     warehouse, database, raw schema and table

&#x20; 02\_staging.sql           staging schema and cleaned table

&#x20; 03\_data\_mart.sql         data mart schema and summary tables

dashboard/

&#x20; hdb\_dashboard.pbix       Power BI dashboard

docs/screenshots/          dashboard and Snowsight screenshots

data/                      (not committed) local copy of the CSV

```



\## How to reproduce



1\. Create a free Snowflake trial account and open Snowsight.

2\. Download the CSV from the source link above and place it in a local `data/` folder.

3\. Run `sql/01\_setup\_and\_raw.sql`. It creates the warehouse, database, `raw` schema and the empty raw table.

4\. Load the CSV into `hdb\_db.raw.resale\_flats` with Snowsight's \*\*Load data\*\* option. This step is manual and is not scripted in SQL.

5\. Run `sql/02\_staging.sql`, then `sql/03\_data\_mart.sql`.

6\. Open `dashboard/hdb\_dashboard.pbix` in Power BI Desktop and point its data source to your own Snowflake account (Transform data → Data source settings).



\## Key findings



\- Average resale price per sqm in was about $4579 in 2017 and $6954 in 2025.

\- Central Area, Queenstown and Bukit Merah rank highest on average price per sqm across all years and flat types. Choa Chu Kang, Woodlands and Jurong West rank lowest.

\- The town ranking changes by flat type, so the flat type page shows one flat type at a time.





\## Caveats



\- 2026 is a partial year (January to October), so its average rests on fewer months.

\- Town and year averages combine all flat types. Averaging flat type averages would weight each type equally regardless of sales volume, so the flat type page uses a single-select filter.

\- Some town and flat type combinations have very few sales (as few as 2). The tooltip shows `number\_of\_sales` so readers can judge reliability.

\- Prices are nominal, with no inflation adjustment.

\- Price per sqm ignores remaining lease, storey and flat model. Those factors are not controlled for, so differences between towns are not purely location effects.

\- Remaining lease was not analysed and is a natural extension.

