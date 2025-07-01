-- 1. Top-Selling Product per Category (using RANK())
SELECT
  category,
  product_name,
  ROUND(SUM(sale_price), 2) AS total_sales,
  RANK() OVER (PARTITION BY category ORDER BY SUM(sale_price) DESC) AS rank_in_category
FROM `mydatapipelineproject.dpl.sales_denormalized`
GROUP BY category, product_name
ORDER BY category, rank_in_category;

-- 2. First Product Sold per Day (using ROW_NUMBER())
  SELECT
    sale_date,
    order_id,
    product_name,
    sale_price,
    ROW_NUMBER() OVER (PARTITION BY sale_date ORDER BY sale_date, sales_id) AS row_num
  FROM `mydatapipelineproject.dpl.sales_denormalized`
QUALIFY row_num = 1
ORDER BY sale_date;

-- 3. Revenue by Year with YoY Growth (%)


  
WITH yearly_sales AS (
  SELECT
    EXTRACT(YEAR FROM sale_date) AS sales_year,
    ROUND(SUM(sale_price), 2) AS total_sales
  FROM `mydatapipelineproject.dpl.sales_denormalized`
  GROUP BY sales_year
),
sales_with_lag AS (
  SELECT
    sales_year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_year) AS prev_year_sales
  FROM yearly_sales
)
SELECT
  sales_year,
  total_sales,
  prev_year_sales,
  ROUND((total_sales - prev_year_sales) / prev_year_sales * 100, 2) AS yoy_growth_percent
FROM sales_with_lag
WHERE prev_year_sales IS NOT NULL
ORDER BY sales_year;


-- 4. Monthly Revenue with Previous Month Comparison

WITH monthly_sales AS (
  SELECT
    year_month,
    ROUND(SUM(sale_price), 2) AS total_sales
  FROM `mydatapipelineproject.dpl.sales_denormalized`
  GROUP BY year_month
)
SELECT
  year_month,
  total_sales,
  LEAD(total_sales) OVER (ORDER BY year_month) AS next_month_sales,
  LAG(total_sales) OVER (ORDER BY year_month) AS prev_month_sales
FROM monthly_sales
ORDER BY year_month;
