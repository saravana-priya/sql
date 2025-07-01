-- 1. Sales trend over time (by month)
SELECT
  FORMAT_TIMESTAMP('%Y-%m', created_at) AS order_month,
  COUNT(order_id) AS total_orders,
  ROUND(SUM(sale_price), 2) AS total_sales
FROM `bigquery-public-data.thelook_ecommerce.order_items`
GROUP BY order_month
ORDER BY order_month;

-- 2. Top 10 selling products
SELECT
  product_id,
  name,
  COUNT(order_id) AS total_sold,
  ROUND(SUM(sale_price), 2) AS total_sales
FROM `bigquery-public-data.thelook_ecommerce.order_items` o join `bigquery-public-data.thelook_ecommerce.products` p on o.product_id=p.id
GROUP BY product_id, name
ORDER BY total_sold DESC
LIMIT 10;

-- 3. New vs Returning Customers
WITH first_order AS (
  SELECT user_id, MIN(created_at) AS first_order_date
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  GROUP BY user_id
)
SELECT
  FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS order_month,
  COUNT(DISTINCT CASE WHEN o.created_at = f.first_order_date THEN o.user_id END) AS new_customers,
  COUNT(DISTINCT CASE WHEN o.created_at > f.first_order_date THEN o.user_id END) AS returning_customers
FROM `bigquery-public-data.thelook_ecommerce.orders` o
JOIN first_order f ON o.user_id = f.user_id
GROUP BY order_month
ORDER BY order_month;

-- 7. Sales by Category
SELECT
  p.category,
  COUNT(oi.id) AS total_items_sold,
  ROUND(SUM(oi.sale_price), 2) AS total_sales
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
GROUP BY category
ORDER BY total_sales DESC;
