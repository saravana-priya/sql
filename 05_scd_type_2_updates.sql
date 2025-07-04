-- generate a scd type 2 for dim_products
CREATE OR REPLACE TABLE `mydatapipelineproject.dpl.dim_products_scd`
AS (SELECT
  product_id,
  product_name,
  brand,
  category,
  department,
  distribution_center_id,
  cost,
  retail_price,
  CURRENT_DATE() AS scd_start_date,
  CAST(NULL AS DATE) AS scd_end_date,
  TRUE AS scd_is_current
FROM
  `mydatapipelineproject.dpl.dim_products`);



  -- Assume incoming updated product data (e.g., new category or retail_price)
CREATE OR REPLACE TABLE `mydatapipelineproject.dpl.stg_products_update` AS
SELECT * FROM UNNEST([
  STRUCT(13844 AS product_id, '(ONE) 1 Satin Headband' AS product_name, 'Funny Girl Designs' AS brand, 'Hair Accessories' AS category, 'Women' AS department,7 AS distribution_center_id, 2.7680398976188529 AS cost, 6.9899997711181641 AS retail_price)
]);

-- SCD Type 2 Merge Logic
MERGE `mydatapipelineproject.dpl.dim_products_scd` d
USING `mydatapipelineproject.dpl.stg_products_update` s
ON d.product_id = s.product_id AND d.is_current = TRUE

WHEN MATCHED AND (
  s.brand IS DISTINCT FROM d.brand OR
  s.category IS DISTINCT FROM d.category OR
  s.retail_price IS DISTINCT FROM d.retail_price
)
THEN
  -- Expire the old version
  UPDATE SET d.valid_to = CURRENT_DATE(), d.is_current = FALSE

WHEN NOT MATCHED BY TARGET THEN
  -- Insert new record if not exists
  INSERT (
    product_id, product_name, brand, category, department,distribution_center_id, cost, retail_price,
    valid_from, valid_to, is_current
  )
  VALUES (
    s.product_id, s.product_name, s.brand, s.category, s.department, s.distribution_center_id,s.cost, s.retail_price,
    CURRENT_DATE(), NULL, TRUE
  );

--Now insert new version of the record if expired in above update
INSERT INTO `mydatapipelineproject.dpl.dim_products_scd` (
  product_id, product_name, brand, category, department, cost, retail_price,
  valid_from, valid_to, is_current
)
SELECT
  s.product_id, s.product_name, s.brand, s.category, s.department, s.cost, s.retail_price,
  CURRENT_DATE(), NULL, TRUE
FROM `mydatapipelineproject.dpl.stg_products_update` s
JOIN `mydatapipelineproject.dpl.dim_products_scd` d
  ON s.product_id = d.product_id
WHERE d.valid_to = CURRENT_DATE() AND d.is_current = FALSE;
