CREATE OR REPLACE PACKAGE BODY pkg_orders AS

    PROCEDURE add_order(
        p_vehicle_id IN NUMBER,
        p_employee_id IN NUMBER,
        p_service_id IN NUMBER,
        p_notes IN VARCHAR2 DEFAULT NULL
    ) AS
        v_order_id NUMBER;
        v_service_cost NUMBER;
        v_exists NUMBER;
    BEGIN
        -- Validate inputs
        SELECT COUNT(*) INTO v_exists FROM vehicles WHERE vehicle_id = p_vehicle_id;
        IF v_exists = 0 THEN RAISE_APPLICATION_ERROR(-20101, 'Vehicle not found.'); END IF;
        SELECT COUNT(*) INTO v_exists FROM employees WHERE employee_id = p_employee_id;
        IF v_exists = 0 THEN RAISE_APPLICATION_ERROR(-20102, 'Employee not found.'); END IF;
        SELECT price INTO v_service_cost FROM services WHERE service_id = p_service_id; -- Raises NO_DATA_FOUND if invalid

        -- Insert order header
        INSERT INTO orders (
            order_id, vehicle_id, employee_id, acceptance_date, status, notes, service_id -- Keep service_id here if needed for header info
        ) VALUES (
            seq_orders.NEXTVAL, p_vehicle_id, p_employee_id, SYSDATE, 'New', p_notes, p_service_id
        ) RETURNING order_id INTO v_order_id;

        -- Insert initial order detail for the main service
        INSERT INTO order_details (
            detail_id, order_id, service_id, quantity, cost
        ) VALUES (
            seq_order_details.NEXTVAL, v_order_id, p_service_id, 1, v_service_cost
        );

        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20103, 'Service not found.');
    END add_order;

    PROCEDURE add_order_detail(
        p_order_id IN NUMBER,
        p_service_id IN NUMBER,
        p_quantity IN NUMBER DEFAULT 1
    ) AS
      v_service_cost NUMBER;
    BEGIN
       SELECT price INTO v_service_cost FROM services WHERE service_id = p_service_id; -- Validate service

        INSERT INTO order_details (
            detail_id, order_id, service_id, quantity, cost
        ) VALUES (
            seq_order_details.NEXTVAL, p_order_id, p_service_id, p_quantity, v_service_cost * p_quantity -- Calculate cost
        );
        COMMIT;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20103, 'Service not found.');
        WHEN DUP_VAL_ON_INDEX THEN -- Or handle appropriately if duplicates are allowed/expected differently
             RAISE_APPLICATION_ERROR(-20104, 'Service detail already exists for this order.');
    END add_order_detail;


    PROCEDURE complete_order(
        p_order_id IN NUMBER
    ) AS
        v_status VARCHAR2(20);
        v_vehicle_id NUMBER;
        v_customer_id NUMBER;
        v_total_cost NUMBER;
        CURSOR c_required_parts IS
            SELECT rp.part_id, SUM(rp.quantity * od.quantity) as total_quantity -- Sum quantity needed based on service quantity in details
            FROM required_parts rp
            JOIN order_details od ON rp.service_id = od.service_id
            WHERE od.order_id = p_order_id
            GROUP BY rp.part_id;
    BEGIN
        -- Check status
        SELECT status, vehicle_id INTO v_status, v_vehicle_id
        FROM orders WHERE order_id = p_order_id;

        IF v_status = 'Completed' THEN
            RAISE_APPLICATION_ERROR(-20105, 'Order is already completed.');
        END IF;

        -- Update order status
        UPDATE orders
        SET status = 'Completed',
            completion_date = SYSDATE
        WHERE order_id = p_order_id;

        -- Deduct parts from inventory and add to parts_used
        FOR rec IN c_required_parts LOOP
            pkg_inventory.use_part_for_order(p_order_id, rec.part_id, rec.total_quantity);
        END LOOP;

        -- Calculate final cost
        v_total_cost := calculate_order_cost(p_order_id);

        -- Generate invoice
        INSERT INTO invoices (
            invoice_id, order_id, invoice_date, total_amount, status
        ) VALUES (
            seq_invoices.NEXTVAL, p_order_id, SYSDATE, v_total_cost, 'Unpaid'
        );

        -- Add to repair history
        SELECT customer_id INTO v_customer_id FROM vehicles WHERE vehicle_id = v_vehicle_id;

        -- Insert a consolidated history record or one per service detail
        -- This adds one main record based on the service_id in the orders table header
        INSERT INTO repair_history (history_id, order_id, vehicle_id, repair_date, service_id, customer_id)
        SELECT seq_repair_history.NEXTVAL, order_id, vehicle_id, completion_date, service_id, v_customer_id
        FROM orders
        WHERE order_id = p_order_id;

        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20106, 'Order not found.');
    END complete_order;

    PROCEDURE update_order_status(
        p_order_id IN NUMBER,
        p_status IN VARCHAR2
    ) AS
      v_allowed_statuses CONSTANT VARCHAR2(100) := 'New,In Progress,Completed,Cancelled'; -- Define allowed statuses
    BEGIN
        IF INSTR(v_allowed_statuses, p_status) = 0 THEN
            RAISE_APPLICATION_ERROR(-20107, 'Invalid status: ' || p_status);
        END IF;

        UPDATE orders
        SET status = p_status
        WHERE order_id = p_order_id;

        IF SQL%NOTFOUND THEN
             RAISE_APPLICATION_ERROR(-20106, 'Order not found.');
        END IF;

        COMMIT;
    END update_order_status;

    FUNCTION calculate_order_cost(
        p_order_id IN NUMBER
    ) RETURN NUMBER AS
        v_service_cost NUMBER := 0;
        v_parts_cost NUMBER := 0;
    BEGIN
        -- Cost from services in details
        SELECT NVL(SUM(cost), 0)
        INTO v_service_cost
        FROM order_details
        WHERE order_id = p_order_id;

        -- Cost from used parts
        SELECT NVL(SUM(cost), 0)
        INTO v_parts_cost
        FROM parts_used
        WHERE order_id = p_order_id;

        RETURN v_service_cost + v_parts_cost;
    END calculate_order_cost;

    FUNCTION get_last_order_date_for_vehicle(
        p_vehicle_id IN NUMBER
    ) RETURN DATE AS
        v_date DATE;
    BEGIN
        SELECT MAX(acceptance_date)
        INTO v_date
        FROM orders
        WHERE vehicle_id = p_vehicle_id;
        RETURN v_date;
    END get_last_order_date_for_vehicle;

    FUNCTION count_orders_for_employee(
        p_employee_id IN NUMBER,
        p_include_completed IN BOOLEAN DEFAULT FALSE
    ) RETURN NUMBER AS
        v_count NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM orders
        WHERE employee_id = p_employee_id
          AND (status != 'Completed' OR p_include_completed = TRUE);
        RETURN v_count;
    END count_orders_for_employee;

END pkg_orders;
/
