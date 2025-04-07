CREATE OR REPLACE FUNCTION count_employee_active_orders (
    p_employee_id IN NUMBER
) RETURN NUMBER AS
    v_order_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_order_count
    FROM orders
    WHERE employee_id = p_employee_id
      AND status IN ('New', 'In Progress');

    RETURN v_order_count;
END count_employee_active_orders;
/
