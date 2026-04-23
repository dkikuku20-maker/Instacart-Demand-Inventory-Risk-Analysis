-- lets check which 20 products have the highest total unit sAleS
-- this helps to understand the data 
-- We need to do some joins so that it helps to know which products exactly are on top
-- we will use inner join because it will keep only matching rows --> only products thats were ordered
SELECT TOP 20
    p.product_name,
    COUNT(*) AS total_units
FROM order_products_prior op
INNER JOIN products p
    ON op.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units DESC;

-- Top-selling products are dominated by fresh and organic produce , indicating strong demand for perishable goods.
-- This requires efiecientr inventory turnover and accurate demand forecasting to mininmize spoilage while preventing stockouts 
-- Bananas rank as the top-selling product due ro their low price, high purchase frequency, and universal consumption across households.

-- Now we neeed to check which departmenets generate the most orders
--NOTE: a department can appear multiple times in the same order if a customer buys several items from that department


SELECT
    d.department,
    COUNT(DISTINCT op.order_id) AS total_orders
FROM order_products_prior op
INNER JOIN products p
    ON op.product_id = p.product_id
INNER JOIN departments d
    ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY total_orders DESC;

-- The top 2 were produce and dairy eggs , these are high frequency essentials-> people buy them every weekand sometimes multiple times as day 

-- now lets check whats the average number of items per order?

SELECT 
    AVG(items_in_order) AS avg_items_per_order
FROM (
    SELECT 
        order_id,
        COUNT(*) AS items_in_order
    FROM order_products_prior
    GROUP BY order_id
) t;

-- We get 10 on average meaning that customers are doing full grocery shopping not just quick 1-2 items purchased 

-- we move to the next task: which aisles have products that are rarely ordered like the bottom 10%


WITH product_sales AS (
    SELECT
        op.product_id,
        COUNT(*) AS total_units
    FROM order_products_prior op
    GROUP BY op.product_id
),
ranked_products AS (
    SELECT
        ps.product_id,
        ps.total_units,
        NTILE(10) OVER (ORDER BY ps.total_units ASC) AS sales_tile
    FROM product_sales ps
)
SELECT
    a.aisle,
    COUNT(*) AS low_volume_products
FROM ranked_products rp
INNER JOIN products p
    ON rp.product_id = p.product_id
INNER JOIN aisles a
    ON p.aisle_id = a.aisle_id
WHERE rp.sales_tile = 1
GROUP BY a.aisle
ORDER BY low_volume_products DESC;


-- The next question we will look at is : whats the reorder rate by department?
--  we have  column 0 or 1 meaning 1 = customer bought it again , 0 first time purchase 

SELECT
    d.department,
    SUM(op.reordered) * 1.0 / COUNT(*) AS reorder_rate
FROM order_products_prior op
INNER JOIN products p
    ON op.product_id = p.product_id
INNER JOIN departments d
    ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY reorder_rate DESC;

-- We see that roughly 67% of the diary eggs items are reordered
--departmentys such as diary, bevergages, and produce exhibit the highest reorder rates, meaning strong habit-driven consumptin and frequent repurchase behavior. 
-- these categories are critical for maining customer retention and require consistent availability t prevent stockouts.