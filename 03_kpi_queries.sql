-- 1. Total Revenue and Orders per Month
SELECT
  year_month,
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(sale_price), 2) AS total_revenue
FROM mydatapipelineproject.dpl.sales_denormalized
GROUP BY year_month
ORDER BY year_month;

-- 2. New vs Returning Customers
WITH first_orders AS (
  SELECT customer_id, MIN(sale_date) AS first_purchase_date
  FROM mydatapipelineproject.dpl.sales_denormalized
  GROUP BY customer_id
)
SELECT
  s.year_month,
  COUNT(DISTINCT CASE WHEN s.sale_date = f.first_purchase_date THEN s.customer_id END) AS new_customers,
  COUNT(DISTINCT CASE WHEN s.sale_date > f.first_purchase_date THEN s.customer_id END) AS returning_customers
FROM mydatapipelineproject.dpl.sales_denormalized s
JOIN first_orders f ON s.customer_id = f.customer_id
GROUP BY s.year_month
ORDER BY s.year_month;

-- 3. Top 10 Products by Revenue
SELECT
  product_id,
  product_name,
  category,
  ROUND(SUM(sale_price), 2) AS total_sales,
  COUNT(*) AS units_sold
FROM mydatapipelineproject.dpl.sales_denormalized
GROUP BY product_id, product_name, category
ORDER BY total_sales DESC
LIMIT 10;

-- 4. Average Order Value (AOV)
SELECT
  year_month,
  ROUND(SUM(sale_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM mydatapipelineproject.dpl.sales_denormalized
GROUP BY year_month
ORDER BY year_month;

-- 5. Customer Lifetime Value (CLTV)
SELECT
  customer_id,
  CONCAT(first_name, ' ', last_name) AS customer_name,
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(sale_price), 2) AS lifetime_value
FROM mydatapipelineproject.dpl.sales_denormalized
GROUP BY customer_id, customer_name
ORDER BY lifetime_value DESC
LIMIT 20;

-- 6. Sales by Product Category (Monthly)
SELECT
  year_month,
  category,
  ROUND(SUM(sale_price), 2) AS total_sales
FROM mydatapipelineproject.dpl.sales_denormalized
GROUP BY year_month, category
ORDER BY year_month, total_sales DESC;

-- 7. Revenue by Country
SELECT
  country,
  ROUND(SUM(sale_price), 2) AS total_revenue,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM mydatapipelineproject.dpl.sales_denormalized
GROUP BY country
ORDER BY total_revenue DESC;
