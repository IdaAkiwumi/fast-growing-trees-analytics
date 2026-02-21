
-- Step 1: Create the data source
CREATE OR REPLACE TABLE fastgrowingtrees_input AS 
SELECT * FROM read_csv_auto('fast-growing-trees-analytics/data/fastgrowingtrees_input.csv');

-- Step 2: Run the full analysis 
WITH monthlysales AS (
    SELECT
      SKU,
      SUM("Units Sold") FILTER (WHERE EXTRACT(MONTH FROM "Order Date"::DATE) = 1) AS jan_sales,
      SUM("Units Sold") FILTER (WHERE EXTRACT(MONTH FROM "Order Date"::DATE) = 2) AS feb_sales,
      SUM("Units Sold") FILTER (WHERE EXTRACT(MONTH FROM "Order Date"::DATE) = 3) AS mar_sales
    FROM fastgrowingtrees_input
    GROUP BY SKU
),
q1totals AS (
    SELECT
      *,
      (jan_sales + feb_sales + mar_sales) AS q1_unit_sales,
      SUM(jan_sales) OVER () AS total_jan,
      SUM(feb_sales) OVER () AS total_feb,
      SUM(mar_sales) OVER () AS total_mar,
      SUM(jan_sales + feb_sales + mar_sales) OVER () AS total_q1
    FROM monthlysales
)
-- Final Output 

SELECT
  SKU,
  -- Add commas as thousands separation
  printf('%,d', jan_sales::INT) AS "Jan Unit Sales",
  printf('%,d', feb_sales::INT) AS "Feb Unit Sales",
  printf('%,d', mar_sales::INT) AS "Mar Unit Sales",
  printf('%,d', q1_unit_sales::INT) AS "Q1 Unit Sales",
  -- Calculate Shares and Rank
  CASE 
    WHEN total_jan = 0 THEN '0%' 
    ELSE (ROUND((jan_sales::DOUBLE / total_jan) * 100))::INT::VARCHAR || '%' 
  END AS "Jan Unit Sales Share",
  CASE 
    WHEN total_feb = 0 THEN '0%' 
    ELSE (ROUND((feb_sales::DOUBLE / total_feb) * 100))::INT::VARCHAR || '%' 
  END AS "Feb Unit Sales Share",
  CASE 
    WHEN total_mar = 0 THEN '0%' 
    ELSE (ROUND((mar_sales::DOUBLE / total_mar) * 100))::INT::VARCHAR || '%' 
  END AS "Mar Unit Sales Share",
  CASE 
    WHEN total_q1 = 0 THEN '0%' 
    ELSE (ROUND((q1_unit_sales::DOUBLE / total_q1) * 100))::INT::VARCHAR || '%' 
  END AS "Q1 Unit Sales Share",
  RANK() OVER (ORDER BY q1_unit_sales DESC) AS Rank
FROM q1totals
ORDER BY Rank ASC;