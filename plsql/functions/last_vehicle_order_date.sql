CREATE OR REPLACE FUNCTION last_vehicle_order_date (
    p_vehicle_id IN NUMBER
) RETURN DATE AS
    v_date DATE;
BEGIN
    SELECT MAX(acceptance_date)
    INTO v_date
    FROM orders
    WHERE vehicle_id = p_vehicle_id;

    RETURN v_date; -- Returns NULL if no orders exist
END last_vehicle_order_date;
/
