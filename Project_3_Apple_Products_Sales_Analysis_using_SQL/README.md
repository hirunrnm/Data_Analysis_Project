# Apple Products Sales 2024 Data Analysis
![R733](https://github.com/user-attachments/assets/4c06892e-6a31-450d-9f72-5750b648d9db)
## Table of Contents
1. [Overview](#overview)
2. [Table Structure](#table-structure)
3. [Data Cleaning](#data-cleaning)
4. [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
   - [General Insights](#general-insights)
   - [Sales Aggregations](#sales-aggregations)
   - [Ranking & Correlation Analysis](#ranking--correlation-analysis)
   - [Country-Specific Analysis](#country-specific-analysis)
5. [Key SQL Techniques Used](#key-sql-techniques-used)
6. [Insight Analysis](#insight-analysis)
7. [Summary](#summary)

## Overview
This project involves data cleaning and exploratory data analysis (EDA) on Apple's sales data using SQL. The dataset includes sales figures for iPhones, iPads, Macs, wearables, and services revenue across different countries and continents. The analysis provides insights into sales performance, product trends, and correlations among different product categories.

## Table Structure
The `applesales` table consists of the following columns:
- `country`: The country where sales were recorded (previously `location`)
- `continent`: The continent associated with the country
- `iphone_sales`: Sales in billion units figures for iPhones
- `ipad_sales`: Sales in billion units figures for iPads
- `mac_sales`: Sales in billion units figures for Mac computers
- `wearables`: Sales in billion units figures for Apple wearable devices such as Apple Watch
- `services_revenue`: Revenue in billion generated from Apple services

## Data Cleaning
- **Duplicate Check**: Identified duplicate rows based on all columns except for unique row identifiers.
```sql
WITH row_num_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY country, continent, iphone_sales, ipad_sales, mac_sales, wearables, services_revenue) AS row_num
FROM applesales
)
SELECT *
FROM row_num_cte
WHERE row_num > 1
;
```
- **Null Check**: Checked for missing values in all columns.
```sql
SELECT *
FROM applesales
WHERE country IS NULL
   OR continent IS NULL
   OR iphone_sales IS NULL
   OR ipad_sales IS NULL
   OR mac_sales IS NULL
   OR wearables IS NULL
   OR services_revenue IS NULL;
```
- **Renamed Columns**: Changed `location` to `country` for clarity.
```sql
ALTER TABLE applesales RENAME COLUMN location TO country;
```
- **Standardized Country Names**: Replaced city names (e.g., Beijing, Shanghai) with their corresponding country names (e.g., China, United States, United Kingdom).
```sql
UPDATE applesales
SET country = CASE 
                     WHEN country = 'Chongqing' THEN 'China'
                     WHEN country = 'Shanghai' THEN 'China'
					 WHEN country = 'Beijing' THEN 'China'
					 WHEN country = 'Shenzhen' THEN 'China'
					 WHEN country = 'UK' THEN 'United Kingdom'
                     WHEN country = 'New York' THEN 'United States'
                     WHEN country = 'Texas' THEN 'United States'
					 WHEN country = 'California' THEN 'United States'
					 WHEN country = 'Florida' THEN 'United States'
					 WHEN country = 'Illinois' THEN 'United States'
                     ELSE country
                 END;
```

## Exploratory Data Analysis (EDA)
### General Insights
- **Total Records & Distinct Values**:
  - Counted total records in `applesales`.
    
    ![Screen Shot 2025-02-09 at 4 45 10 PM](https://github.com/user-attachments/assets/3a572935-9ec5-4cb9-bee7-daf4afc699b0)
  
  - Listed distinct values for `country` and `continent`.

    ![Screen Shot 2025-02-09 at 4 50 36 PM](https://github.com/user-attachments/assets/450e4e41-d708-4e88-96a1-6a8160814c4b) ![Screen Shot 2025-02-09 at 4 50 55 PM](https://github.com/user-attachments/assets/aaea89c2-0803-4ba4-aeef-5a6f102b8231)

- **iPhone Sales Statistics**:
  - Calculated max, min, and average sales for iPhones.

    ![Screen Shot 2025-02-09 at 4 53 46 PM](https://github.com/user-attachments/assets/555c0ed3-0bce-4fd2-8839-7b658729e780)

### Sales Aggregations
1. **Total Sales by Continent**: Aggregated sales for each product category per continent.
```sql
SELECT continent, 
       SUM(iphone_sales) AS total_iphone_sales, 
       SUM(ipad_sales) AS total_ipad_sales,
       SUM(mac_sales) AS total_mac_sales, 
       SUM(wearables) AS total_wearables,
       SUM(services_revenue) AS total_services_revenue
FROM applesales
GROUP BY continent
ORDER BY 1 ASC;
```
![Screen Shot 2025-02-09 at 4 55 11 PM](https://github.com/user-attachments/assets/5cc615ce-4730-404f-95c4-ccb3a61bb348)

2. **Total Sales by Country**: Aggregated sales for each product category per country.
```sql
SELECT country, 
       SUM(iphone_sales) AS total_iphone_sales, 
       SUM(ipad_sales) AS total_ipad_sales,
       SUM(mac_sales) AS total_mac_sales, 
       SUM(wearables) AS total_wearables,
       SUM(services_revenue) AS total_services_revenue
FROM applesales
GROUP BY country
ORDER BY 1;
```
![Screen Shot 2025-02-09 at 4 56 56 PM](https://github.com/user-attachments/assets/b74b5709-e694-444e-b64f-0867fd455323)

3. **High-Performing Countries**: Identified countries with total sales exceeding 500 billion units and services revenue exceeding $1000 billion.
```sql
SELECT country, 
       SUM(iphone_sales) AS total_iphone_sales, 
       SUM(ipad_sales) AS total_ipad_sales,
       SUM(mac_sales) AS total_mac_sales, 
       SUM(wearables) AS total_wearables,
       SUM(services_revenue) AS total_services_revenue
FROM applesales
GROUP BY country
HAVING SUM(iphone_sales) > 500
	AND SUM(ipad_sales) > 500
	AND SUM(mac_sales) > 500 
	AND SUM(wearables) > 500
	AND SUM(services_revenue) > 1000
ORDER BY 1;
```
![Screen Shot 2025-02-09 at 4 58 32 PM](https://github.com/user-attachments/assets/9aa7af73-376f-4d5f-8eb4-b693d3676307)

4. **Sales Percentage by Continent**: Calculated the percentage of each product category's sales contribution per continent.
```sql
SELECT continent, 
       ROUND(SUM(iphone_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS iphone_sales_percentage, 
       ROUND(SUM(ipad_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS ipad_sales_percentage,
       ROUND(SUM(mac_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS mac_sales_percentage,
       ROUND(SUM(wearables) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS wearables_percentage
FROM applesales
GROUP BY continent;
```
![Screen Shot 2025-02-09 at 5 01 09 PM](https://github.com/user-attachments/assets/2a7e5c60-78f8-4cd0-9b1f-f99489513fac)

5. **Sales Percentage by Country**: Calculated the percentage of each product category's sales contribution per country.
```sql
SELECT country, 
       ROUND(SUM(iphone_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS iphone_sales_percentage, 
       ROUND(SUM(ipad_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS ipad_sales_percentage,
       ROUND(SUM(mac_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS mac_sales_percentage,
       ROUND(SUM(wearables) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS wearables_percentage
FROM applesales
GROUP BY country;
```
![Screen Shot 2025-02-09 at 5 02 19 PM](https://github.com/user-attachments/assets/ddc0ccf5-d791-4b5b-b55b-f3cf6b64208b)

### Ranking & Correlation Analysis
6. **Top 10 iPhone Sales by Country**: Used `DENSE_RANK()` to rank the top 10 countries based on iPhone sales.
```sql
SELECT DENSE_RANK() OVER (ORDER BY total_iphone_sales DESC) AS rank,
	   country, 
	   total_iphone_sales
FROM (
	SELECT country,SUM(iphone_sales) AS total_iphone_sales
	FROM applesales
	GROUP BY country
	) AS sum_iphonesales
LIMIT 10;
```
![Screen Shot 2025-02-09 at 5 05 20 PM](https://github.com/user-attachments/assets/a62f083b-c7e5-4cba-9d49-333a21ee262d)

![Screen Shot 2025-02-15 at 4 01 20 PM](https://github.com/user-attachments/assets/786ab2dc-6e33-4252-a297-8ae277cfe86d)

7. **Top 10 iPad Sales by Country**: Ranked the top 10 countries based on iPad sales.
```sql
SELECT DENSE_RANK() OVER (ORDER BY total_ipad_sales DESC) AS rank, 
	   country, 
	   total_ipad_sales
FROM (
	SELECT country,SUM(ipad_sales) AS total_ipad_sales
	FROM applesales
	GROUP BY country
	) AS sum_ipadsales
LIMIT 10;
```
![Screen Shot 2025-02-09 at 5 06 53 PM](https://github.com/user-attachments/assets/8c56d154-c950-4642-8d67-f62b644517c8)

8. **Top 10 Services Revenue by Country**: Ranked the top 10 countries based on services revenue.
```sql
SELECT DENSE_RANK() OVER (ORDER BY total_services_revenue DESC) AS rank,
	   country, 
	   total_services_revenue
FROM (
	SELECT country,SUM(services_revenue) AS total_services_revenue
	FROM applesales
	GROUP BY country
	) AS sum_services_revenue
LIMIT 10;
```
![Screen Shot 2025-02-09 at 5 08 56 PM](https://github.com/user-attachments/assets/a0338ca9-87e9-409c-b5b1-533f998a5d47)

9. **Product Correlation Analysis**: Used the `CORR()` function to analyze the relationship between iPhone sales and other products (Wearables, iPads, Macs).
```sql
SELECT ROUND(CORR(iphone_sales, wearables)::NUMERIC,2) AS corr_iphone_wearables,
	   ROUND(CORR(iphone_sales, ipad_sales)::NUMERIC,2) AS corr_iphone_ipad,
	   ROUND(CORR(iphone_sales, mac_sales)::NUMERIC,2) AS corr_iphone_mac
FROM applesales;
```
![Screen Shot 2025-02-09 at 5 09 46 PM](https://github.com/user-attachments/assets/e5da7ab4-b021-4f98-9101-532e9f28c748)

### Country-Specific Analysis
10. **Thailand's iPhone Sales Percentage**: Calculated Thailand's iPhone sales as a percentage of total iPhone sales worldwide.
```sql
WITH thailand_sales_cte AS 
(
SELECT country,SUM(iphone_sales) AS thailand_iphone_sales
FROM applesales
WHERE country = 'Thailand'
GROUP BY country
), total_sales_cte AS
(
SELECT SUM(iphone_sales) AS total_sales
FROM applesales
) 
SELECT thailand_sales_cte.country,
	   ROUND((thailand_sales_cte.thailand_iphone_sales / total_sales_cte.total_sales * 100)::NUMERIC,2) AS thailand_iphone_sales_percentage
FROM thailand_sales_cte,total_sales_cte;
```
![Screen Shot 2025-02-09 at 5 17 30 PM](https://github.com/user-attachments/assets/0ba0d677-0d0c-4260-95db-112af64a3d2d)

11. **Above Average iPhone Sales**: Identified countries with above average iPhone sales compared to the global average.
```sql
SELECT country,
	   ROUND(AVG(iphone_sales)::NUMERIC,2) AS AVG_iPhone_sales
FROM applesales
GROUP BY country
HAVING ROUND(AVG(iphone_sales)::NUMERIC,2) > 
	   (
		SELECT AVG(iphone_sales)
		FROM applesales
	   )
ORDER BY AVG_iPhone_sales DESC;
```
![Screen Shot 2025-02-09 at 5 18 55 PM](https://github.com/user-attachments/assets/40c2ab37-a3f3-4dad-b869-2d46d2d95e78)

## Key SQL Techniques Used
- `ALTER TABLE` & `UPDATE` for data cleaning and transformation
- `ROW_NUMBER()` for identifying duplicates
- `GROUP BY` & `HAVING` for aggregations and filtering
- `DENSE_RANK()` for ranking countries by sales
- `CORR()` for correlation analysis
- `WITH` (Common Table Expressions) for structured queries
- `Subqueries` for breaking down complex calculations, such as:
  - Ranking top 10 sales using a subquery to aggregate data before applying `DENSE_RANK()`
  - Calculating Thailand’s iPhone sales percentage by first determining Thailand’s total sales in a subquery
  - Identifying above-average iPhone sales by comparing each country’s average sales with the overall average in a subquery

## Insight Analysis
1. **China and the United States are dominant markets**: Both countries have the highest sales for iPhones, iPads, Macs, and services revenue, reflecting their large consumer bases and strong Apple market penetration.
2. **Correlation between iPhone sales and wearables is weak**: The calculated correlation (`corr_iphone_wearable = -0.06`) suggests a negligible negative relationship, meaning iPhone sales do not strongly influence wearables sales.
3. **Correlation between iPhone sales and iPads is weakly positive**: A correlation of `corr_iphone_ipad = 0.04` indicates a minimal positive relationship, meaning iPhone and iPad sales do not significantly impact each other.
4. **Correlation between iPhone sales and Macs is weakly negative**: A correlation of `corr_iphone_mac = -0.03` suggests a slight inverse relationship, but it is not statistically strong.
5. **Services revenue is a key growth area**: Countries with high Apple device sales also tend to have high services revenue, reinforcing Apple's strategy to expand its digital services.
6. **Thailand’s iPhone sales percentage is relatively small**: Compared to global sales, Thailand’s contribution is modest, suggesting potential for market expansion.
7. **Above-average iPhone sales are concentrated in developed markets**: High-income countries tend to have iPhone sales well above average, aligning with Apple's premium pricing strategy.

## Summary
This SQL-based analysis provides a comprehensive view of Apple's sales data across different markets. It highlights key sales trends, identifies high-performing countries, and explores relationships between product categories. The findings can be useful for making data-driven business decisions regarding Apple's global sales strategy.
