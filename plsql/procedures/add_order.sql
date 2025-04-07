CREATE OR REPLACE PROCEDURE add_order (
    p_vehicle_id IN NUMBER,
    p_employee_id IN NUMBER,
    p_service_id IN NUMBER,
    -- p_status IN VARCHAR2, -- Status should likely default to 'New'
    p_notes IN VARCHAR2 DEFAULT NULL
) AS
    v_exists NUMBER := 0;
    v_order_id NUMBER;
    v_service_cost NUMBER;
BEGIN
    -- Validation
    SELECT COUNT(*) INTO v_exists FROM vehicles WHERE vehicle_id = p_vehicle_id;
    IF v_exists = 0 THEN RAISE_APPLICATION_ERROR(-20004, 'Vehicle with specified ID does not exist.'); END IF;

    SELECT COUNT(*) INTO v_exists FROM employees WHERE employee_id = p_employee_id;
    IF v_exists = 0 THEN RAISE_APPLICATION_ERROR(-20005, 'Employee with specified ID does not exist.'); END IF;

    BEGIN
      SELECT price INTO v_service_cost FROM services WHERE service_id = p_service_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20006, 'Service with specified ID does not exist.');
    END;

    -- Insert Order Header
    INSERT INTO orders (order_id, vehicle_id, employee_id, service_id, status, acceptance_date, notes)
    VALUES (seq_orders.NEXTVAL, p_vehicle_id, p_employee_id, p_service_id, 'New', SYSDATE, p_notes)
    RETURNING order_id INTO v_order_id;

     -- Insert Order Detail
    INSERT INTO order_details (detail_id, order_id, service_id, quantity, cost)
    VALUES (seq_order_details.NEXTVAL, v_order_id, p_service_id, 1, v_service_cost);


    COMMIT;
    DBMS_OUTPUT.PUT_LINE('New order added with ID: ' || v_order_id || ' for vehicle ID: ' || p_vehicle_id);
END add_order;
/
