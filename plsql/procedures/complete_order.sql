CREATE OR REPLACE PROCEDURE complete_order (
    p_order_id IN NUMBER
) AS
    v_status VARCHAR2(20);
    v_service_id NUMBER;
    v_vehicle_id NUMBER;
    v_customer_id NUMBER;
    v_service_cost NUMBER := 0;
    v_parts_cost NUMBER := 0;
    v_discount_percent NUMBER := 0;
    v_total_amount NUMBER := 0;
BEGIN
    -- Validate order and get current status
    BEGIN
        SELECT o.status, o.service_id, o.vehicle_id, v.customer_id
        INTO v_status, v_service_id, v_vehicle_id, v_customer_id
        FROM orders o
        JOIN vehicles v ON o.vehicle_id = v.vehicle_id
        WHERE o.order_id = p_order_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Order not found.');
        WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20005, 'Corrupt data: Multiple orders found for ID.');
    END;


    IF v_status = 'Completed' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Order has already been completed.');
    END IF;

    -- Get base service cost (from the primary service on the order header)
    -- More complex logic needed if cost depends on multiple details
    SELECT NVL(price, 0)
    INTO v_service_cost
    FROM services
    WHERE service_id = v_service_id;

    -- Calculate cost of parts used (based on REQUIRED_PARTS for the primary service)
    SELECT NVL(SUM(i.price * rp.quantity), 0)
    INTO v_parts_cost
    FROM inventory i
    JOIN required_parts rp ON i.part_id = rp.part_id
    WHERE rp.service_id = v_service_id;

    -- Apply promotion discount if applicable to the service
    BEGIN
        SELECT discount_percent
        INTO v_discount_percent
        FROM promotions p
        WHERE p.service_id = v_service_id
          AND SYSDATE BETWEEN p.start_date AND p.end_date
          AND ROWNUM = 1 -- Get the first applicable promotion if multiple exist
        ORDER BY p.start_date DESC; -- Prioritize newer promotions? Or highest discount? Define rule.
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_discount_percent := 0;
    END;

    -- Calculate discounted service cost
    IF v_discount_percent > 0 THEN
        v_service_cost := v_service_cost * (1 - v_discount_percent / 100);
    END IF;

    -- Calculate total invoice amount
    v_total_amount := ROUND(v_service_cost + v_parts_cost, 2);

    -- Update order status
    UPDATE orders
    SET status = 'Completed',
        completion_date = SYSDATE
    WHERE order_id = p_order_id;

    -- Create invoice
    INSERT INTO invoices (invoice_id, order_id, invoice_date, total_amount, status)
    VALUES (seq_invoices.NEXTVAL, p_order_id, SYSDATE, v_total_amount, 'Unpaid');

    -- Add record to repair history
    INSERT INTO repair_history (history_id, order_id, vehicle_id, repair_date, service_id, customer_id)
    VALUES (seq_repair_history.NEXTVAL, p_order_id, v_vehicle_id, SYSDATE, v_service_id, v_customer_id);

    -- Deduct parts from inventory (based on required parts for the service)
    FOR rec IN (
        SELECT rp.part_id, rp.quantity
        FROM required_parts rp
        WHERE rp.service_id = v_service_id
    ) LOOP
       BEGIN
           pkg_inventory.use_part_for_order(p_order_id, rec.part_id, rec.quantity);
       EXCEPTION
         WHEN OTHERS THEN
             -- Log error or handle insufficient stock reported by use_part_for_order
             DBMS_OUTPUT.PUT_LINE('Error using part ' || rec.part_id || ' for order ' || p_order_id || ': ' || SQLERRM);
             -- Consider rolling back or setting order status to 'Error'
             RAISE; -- Re-raise the exception
       END;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Order ' || p_order_id || ' completed successfully.');
END complete_order;
/
