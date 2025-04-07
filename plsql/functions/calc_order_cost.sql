CREATE OR REPLACE FUNCTION calc_order_cost (
    p_order_id IN NUMBER
) RETURN NUMBER AS
    v_service_cost NUMBER := 0;
    v_parts_cost NUMBER := 0;
    v_total_cost NUMBER := 0;
BEGIN
    -- Calculate service cost from order details
    SELECT NVL(SUM(cost), 0)
    INTO v_service_cost
    FROM order_details
    WHERE order_id = p_order_id;

    -- Calculate parts cost from parts used
    SELECT NVL(SUM(cost), 0)
    INTO v_parts_cost
    FROM parts_used
    WHERE order_id = p_order_id;

    -- Calculate total cost
    v_total_cost := v_service_cost + v_parts_cost;

    RETURN v_total_cost;
END calc_order_cost;
/
