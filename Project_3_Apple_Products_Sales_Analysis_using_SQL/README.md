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
- **iPhone Sales Statistics**:
  - Calculated max, min, and average sales for iPhones.

### Sales Aggregations
1. **Total Sales by Continent**: Aggregated sales for each product category per continent.
2. **Total Sales by Country**: Aggregated sales for each product category per country.
3. **High-Performing Countries**: Identified countries with total sales exceeding 500 billion units and services revenue exceeding $1000 billion.
4. **Sales Percentage by Continent**: Calculated the percentage of each product category's sales contribution per continent.
5. **Sales Percentage by Country**: Calculated the percentage of each product category's sales contribution per country.

### Ranking & Correlation Analysis
6. **Top 10 iPhone Sales by Country**: Used `DENSE_RANK()` to rank the top 10 countries based on iPhone sales.
7. **Top 10 iPad Sales by Country**: Ranked the top 10 countries based on iPad sales.
8. **Top 10 Services Revenue by Country**: Ranked the top 10 countries based on services revenue.
9. **Product Correlation Analysis**: Used the `CORR()` function to analyze the relationship between iPhone sales and other products (iPads, Macs, Wearables).

### Country-Specific Analysis
10. **Thailand's iPhone Sales Percentage**: Calculated Thailand's iPhone sales as a percentage of total iPhone sales worldwide.
11. **Above-Average iPhone Sales**: Identified countries with above-average iPhone sales compared to the global average.

## Key SQL Techniques Used
- `ALTER TABLE` & `UPDATE` for data cleaning and transformation
- `ROW_NUMBER()` for identifying duplicates
- `GROUP BY` & `HAVING` for aggregations and filtering
- `DENSE_RANK()` for ranking countries by sales
- `CORR()` for correlation analysis
- `WITH` (Common Table Expressions) for structured queries

## Insight Analysis
1. **China and the United States are dominant markets**: Both countries have the highest sales for iPhones, iPads, Macs, and services revenue, reflecting their large consumer bases and strong Apple market penetration.
2. **Correlation between iPhone sales and wearables**: A strong positive correlation suggests that consumers who purchase iPhones are likely to buy Apple wearables, indicating cross-selling opportunities.
3. **Services revenue is a key growth area**: Countries with high Apple device sales also tend to have high services revenue, reinforcing Apple's strategy to expand its digital services.
4. **Thailand’s iPhone sales percentage is relatively small**: Compared to global sales, Thailand’s contribution is modest, suggesting potential for market expansion.
5. **Above-average iPhone sales are concentrated in developed markets**: High-income countries tend to have iPhone sales well above average, aligning with Apple's premium pricing strategy.

## Summary
This SQL-based analysis provides a comprehensive view of Apple's sales data across different markets. It highlights key sales trends, identifies high-performing countries, and explores relationships between product categories. The findings can be useful for making data-driven business decisions regarding Apple's global sales strategy.

## Next Steps
- Visualizing key insights using Tableau or Power BI
- Expanding the dataset with additional years of sales data
- Incorporating machine learning models to predict future sales trends
