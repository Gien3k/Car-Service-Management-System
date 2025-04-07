CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_PENDING_ORDERS" (
    "ORDER_ID",
    "CUSTOMER_NAME",
    "VEHICLE",
    "ACCEPTANCE_DATE",
    "STATUS"
) AS
SELECT
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    v.make || ' ' || v.model AS vehicle,
    o.acceptance_date,
    o.status
FROM
    orders o
JOIN vehicles v ON o.vehicle_id = v.vehicle_id
JOIN customers c ON v.customer_id = c.customer_id
WHERE
    o.status IN ('New', 'In Progress')
ORDER BY
    o.acceptance_date;
