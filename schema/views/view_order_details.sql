CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_ORDER_DETAILS" (
    "ORDER_ID",
    "ACCEPTANCE_DATE",
    "STATUS",
    "CUSTOMER_NAME",
    "VEHICLE",
    "REGISTRATION_NUMBER",
    "EMPLOYEE_NAME",
    "SERVICE_NAME",
    "SERVICE_COST",
    "TOTAL_ORDER_COST" -- This needs recalculation logic, perhaps call the function
) AS
SELECT
    o.order_id,
    o.acceptance_date,
    o.status,
    c.first_name || ' ' || c.last_name AS customer_name,
    v.make || ' ' || v.model AS vehicle,
    v.registration_number,
    e.first_name || ' ' || e.last_name AS employee_name,
    s.service_name,
    s.price AS service_cost,
    (SELECT calc_order_cost(o.order_id) FROM dual) AS total_order_cost -- Assuming calc_order_cost exists
    -- od.cost AS cost_from_order_details -- Original logic seemed to pull cost from details
FROM
    orders o
JOIN vehicles v ON o.vehicle_id = v.vehicle_id
JOIN customers c ON v.customer_id = c.customer_id
JOIN employees e ON o.employee_id = e.employee_id
JOIN order_details od ON o.order_id = od.order_id -- Assumes one detail per order based on original view
JOIN services s ON od.service_id = s.service_id;
