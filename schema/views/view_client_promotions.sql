CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_CLIENT_PROMOTIONS" (
    "CUSTOMER_ID",
    "CUSTOMER_NAME",
    "PROMOTION_NAME",
    "DISCOUNT_PERCENT",
    "ASSIGNMENT_DATE"
) AS
SELECT
    cp.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    p.name AS promotion_name,
    p.discount_percent AS discount_percent,
    cp.assignment_date
FROM
    customer_promotions cp 
JOIN customers c ON cp.customer_id = c.customer_id 
JOIN promotions p ON cp.promotion_id = p.promotion_id 
ORDER BY
    cp.assignment_date DESC; 