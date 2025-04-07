CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_REPAIR_HISTORY" (
    "HISTORY_ID",
    "VEHICLE",
    "REGISTRATION_NUMBER",
    "OWNER",
    "REPAIR_DATE",
    "SERVICE_NAME",
    "PERFORMED_BY"
) AS
SELECT
    rh.history_id,
    v.make || ' ' || v.model AS vehicle,
    v.registration_number,
    c.first_name || ' ' || c.last_name AS owner,
    rh.repair_date,
    s.service_name, -- Assuming service_id links to services table
    e.first_name || ' ' || e.last_name AS performed_by
FROM
    repair_history rh
JOIN vehicles v ON rh.vehicle_id = v.vehicle_id
JOIN customers c ON v.customer_id = c.customer_id
JOIN orders o ON rh.order_id = o.order_id
JOIN employees e ON o.employee_id = e.employee_id
LEFT JOIN services s ON rh.service_id = s.service_id; -- Left join in case service is optional

-- view_client_promotions.sql
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
