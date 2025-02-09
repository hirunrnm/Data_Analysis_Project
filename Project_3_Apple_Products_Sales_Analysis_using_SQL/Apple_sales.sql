-- create table named "applesales"
CREATE TABLE applesales (
    location VARCHAR(255),
    continent VARCHAR(255),
    iphone_sales DECIMAL(10, 2),
    ipad_sales DECIMAL(10, 2),
    mac_sales DECIMAL(10, 2),
    wearables DECIMAL(10, 2),
    services_revenue DECIMAL(10, 2)
);

-- ------------------------
-- Data Cleaning
-- ------------------------

-- Check duplicate value 
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

-- Check null values
SELECT *
FROM applesales
WHERE country IS NULL
   OR continent IS NULL
   OR iphone_sales IS NULL
   OR ipad_sales IS NULL
   OR mac_sales IS NULL
   OR wearables IS NULL
   OR services_revenue IS NULL;

-- Rename column location to country
ALTER TABLE applesales RENAME COLUMN location TO country;

-- Rename city name to country name
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

-- --------------------------
-- Exploratory Data Analysis
-- --------------------------
SELECT *
FROM applesales;

SELECT COUNT(*)
FROM applesales;

SELECT DISTINCT(country)
FROM applesales;

SELECT DISTINCT(continent)
FROM applesales;

SELECT MAX(iphone_sales),
MIN(iphone_sales),
AVG(iphone_sales)
FROM applesales
;

-- 1. Find the total sales of all products for each continent
SELECT continent, 
       SUM(iphone_sales) AS total_iphone_sales, 
       SUM(ipad_sales) AS total_ipad_sales,
       SUM(mac_sales) AS total_mac_sales, 
       SUM(wearables) AS total_wearables,
       SUM(services_revenue) AS total_services_revenue
FROM applesales
GROUP BY continent
ORDER BY 1 ASC;

-- 2. Find the total sales of all products for each country
SELECT country, 
       SUM(iphone_sales) AS total_iphone_sales, 
       SUM(ipad_sales) AS total_ipad_sales,
       SUM(mac_sales) AS total_mac_sales, 
       SUM(wearables) AS total_wearables,
       SUM(services_revenue) AS total_services_revenue
FROM applesales
GROUP BY country
ORDER BY 1;

-- 3. Find the country that have total sales of all product more than 500 billion units and total services revenue more than $1000 billion
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

-- 4. Calculate products sales percentage by continent
SELECT continent, 
       ROUND(SUM(iphone_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS iphone_sales_percentage, 
       ROUND(SUM(ipad_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS ipad_sales_percentage,
       ROUND(SUM(mac_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS mac_sales_percentage,
       ROUND(SUM(wearables) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS wearables_percentage
FROM applesales
GROUP BY continent;

-- 5. Calculate products sales percentage by country
SELECT country, 
       ROUND(SUM(iphone_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS iphone_sales_percentage, 
       ROUND(SUM(ipad_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS ipad_sales_percentage,
       ROUND(SUM(mac_sales) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS mac_sales_percentage,
       ROUND(SUM(wearables) / SUM(iphone_sales + ipad_sales + mac_sales + wearables)::NUMERIC,2) * 100 AS wearables_percentage
FROM applesales
GROUP BY country;

-- 6. Use rank function to find top 10 sales of iPhone by country
SELECT country, 
	   total_iphone_sales,
       DENSE_RANK() OVER (ORDER BY total_iphone_sales DESC) AS rank
FROM (
	SELECT country,SUM(iphone_sales) AS total_iphone_sales
	FROM applesales
	GROUP BY country
	) AS sum_iphonesales
LIMIT 10;

-- 7. Use rank function to find top 10 sales of iPad by country
SELECT country, 
	   total_ipad_sales,
       DENSE_RANK() OVER (ORDER BY total_ipad_sales DESC) AS rank
FROM (
	SELECT country,SUM(ipad_sales) AS total_ipad_sales
	FROM applesales
	GROUP BY country
	) AS sum_ipadsales
LIMIT 10;

-- 8. Use rank function to find top 10 services revenue by country
SELECT country, 
	   total_services_revenue,
       DENSE_RANK() OVER (ORDER BY total_services_revenue DESC) AS rank
FROM (
	SELECT country,SUM(services_revenue) AS total_services_revenue
	FROM applesales
	GROUP BY country
	) AS sum_services_revenue
LIMIT 10;

-- 9. Find the correlation between iPhone sales and other products
SELECT ROUND(CORR(iphone_sales, wearables)::NUMERIC,2) AS corr_iphone_wearables,
	   ROUND(CORR(iphone_sales, ipad_sales)::NUMERIC,2) AS corr_iphone_ipad,
	   ROUND(CORR(iphone_sales, mac_sales)::NUMERIC,2) AS corr_iphone_mac
FROM applesales;


-- 10. Calculate the Thailand iPhone sales percentage of total sales 
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


-- 11.Countries with above average iPhone sales
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









