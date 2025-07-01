-- 1. Create Date Dimension Table
CREATE OR REPLACE TABLE `mydatapipelineproject.dpl.dim_date` AS
SELECT
  DISTINCT DATE(created_at) AS date,
  EXTRACT(YEAR FROM created_at) AS year,
  EXTRACT(MONTH FROM created_at) AS month,
  EXTRACT(DAY FROM created_at) AS day,
  FORMAT_TIMESTAMP('%Y-%m', created_at) AS year_month,
  FORMAT_TIMESTAMP('%A', created_at) AS weekday
FROM `bigquery-public-data.thelook_ecommerce.orders`
WHERE created_at IS NOT NULL;


-- 2. Create Customer Dimension Table
CREATE OR REPLACE TABLE your_project.your_dataset.dim_customers AS
SELECT
  id AS customer_id,
  first_name,
  last_name,
  gender,
  age,
  state,
  country,
  email,
  DATE(created_at) AS signup_date
FROM `bigquery-public-data.thelook_ecommerce.users`
WHERE id IS NOT NULL;



-- 3. Create Product Dimension Table
CREATE OR REPLACE TABLE mydatapipelineproject.dpl.dim_products AS
SELECT
  id AS product_id,
  name AS product_name,
  brand,
  category,
  department,
  distribution_center_id,
  cost,
  retail_price
FROM `bigquery-public-data.thelook_ecommerce.products`
WHERE id IS NOT NULL;


-- 4. Create Fact Sales Table
CREATE OR REPLACE TABLE mydatapipelineproject.dpl.fact_sales AS
SELECT
  oi.id AS sales_id,
  oi.order_id,
  o.user_id AS customer_id,
  oi.product_id,
  DATE(oi.created_at) AS sale_date,
  oi.sale_price,
  oi.status
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON oi.order_id = o.order_id
WHERE oi.sale_price IS NOT NULL;






-- 5. Create Denormalized Sales Table
CREATE OR REPLACE TABLE mydatapipelineproject.dpl.sales_denormalized AS
SELECT
  f.sales_id,
  f.order_id,
  f.sale_date,
  d.year,
  d.month,
  d.year_month,
  d.weekday,
  
  f.customer_id,
  c.first_name,
  c.last_name,
  c.gender,
  c.age,
  c.state,
  c.country,
  c.email,
  c.signup_date,

  f.product_id,
  p.product_name,
  p.brand,
  p.category,
  p.department,
  p.cost,
  p.retail_price,
  
  f.sale_price,
  f.status
FROM mydatapipelineproject.dpl.fact_sales f
LEFT JOIN mydatapipelineproject.dpl.dim_date d
  ON f.sale_date = d.date
LEFT JOIN mydatapipelineproject.dpl.dim_customers c
  ON f.customer_id = c.customer_id
LEFT JOIN mydatapipelineproject.dpl.dim_products p
  ON f.product_id = p.product_id;
