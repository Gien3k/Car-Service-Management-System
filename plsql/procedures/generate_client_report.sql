CREATE OR REPLACE PROCEDURE generate_client_report (
    p_customer_id IN NUMBER
) AS
    v_total_amount NUMBER := 0;
    v_repair_count NUMBER := 0;
    v_most_frequent_service VARCHAR2(100) := 'N/A';
    v_most_frequent_part VARCHAR2(100) := 'N/A';
    v_last_order_id NUMBER := NULL;
    v_last_date DATE := NULL;
    v_customer_exists NUMBER;
BEGIN
    -- Validate customer ID
    IF p_customer_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer ID cannot be NULL.');
    END IF;

    SELECT COUNT(*) INTO v_customer_exists FROM customers WHERE customer_id = p_customer_id;
    IF v_customer_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Customer with the specified ID does not exist.');
    END IF;

    -- Calculate repair count
    SELECT COUNT(DISTINCT o.order_id) -- Count distinct orders linked to the customer's vehicles
    INTO v_repair_count
    FROM orders o
    JOIN vehicles v ON o.vehicle_id = v.vehicle_id
    WHERE v.customer_id = p_customer_id;

    -- Calculate total amount spent
    SELECT NVL(SUM(i.total_amount), 0)
    INTO v_total_amount
    FROM invoices i
    JOIN orders o ON i.order_id = o.order_id
    JOIN vehicles v ON o.vehicle_id = v.vehicle_id
    WHERE v.customer_id = p_customer_id;

    -- Find most frequent service
    BEGIN
        SELECT s.service_name
        INTO v_most_frequent_service
        FROM order_details od
        JOIN services s ON od.service_id = s.service_id
        JOIN orders o ON od.order_id = o.order_id
        JOIN vehicles v ON o.vehicle_id = v.vehicle_id
        WHERE v.customer_id = p_customer_id
        GROUP BY s.service_name
        ORDER BY COUNT(*) DESC
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_most_frequent_service := 'N/A';
    END;

    -- Find most frequent part used
    BEGIN
        SELECT i.part_name
        INTO v_most_frequent_part
        FROM parts_used pu
        JOIN inventory i ON pu.part_id = i.part_id
        JOIN orders o ON pu.order_id = o.order_id
        JOIN vehicles v ON o.vehicle_id = v.vehicle_id
        WHERE v.customer_id = p_customer_id
        GROUP BY i.part_name
        ORDER BY SUM(pu.quantity) DESC -- Order by total quantity used
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_most_frequent_part := 'N/A';
    END;

    -- Get last order details
    BEGIN
        SELECT o.order_id, o.acceptance_date
        INTO v_last_order_id, v_last_date
        FROM orders o
        JOIN vehicles v ON o.vehicle_id = v.vehicle_id
        WHERE v.customer_id = p_customer_id
        ORDER BY o.acceptance_date DESC
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_last_order_id := NULL;
            v_last_date := NULL;
    END;

    -- Insert or update report data
    MERGE INTO statistical_reports sr
    USING (SELECT p_customer_id AS customer_id FROM dual) src ON (sr.customer_id = src.customer_id)
    WHEN MATCHED THEN
        UPDATE SET
            repair_count = v_repair_count,
            total_amount = v_total_amount,
            most_frequent_service = v_most_frequent_service,
            most_frequent_part = v_most_frequent_part,
            last_order_id = v_last_order_id,
            last_date = v_last_date,
            creation_date = SYSDATE -- Update report generation date
    WHEN NOT MATCHED THEN
        INSERT (report_id, customer_id, repair_count, total_amount, most_frequent_service, most_frequent_part, last_order_id, last_date, creation_date)
        VALUES (seq_statistical_reports.NEXTVAL, p_customer_id, v_repair_count, v_total_amount, v_most_frequent_service, v_most_frequent_part, v_last_order_id, v_last_date, SYSDATE);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Report for customer ' || p_customer_id || ' has been generated/updated.');
END generate_client_report;
/
