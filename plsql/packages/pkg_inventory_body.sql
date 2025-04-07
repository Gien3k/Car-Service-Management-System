CREATE OR REPLACE PACKAGE BODY pkg_inventory AS

    PROCEDURE restock_inventory(p_part_id IN NUMBER, p_quantity IN NUMBER) AS
    BEGIN
        UPDATE inventory
        SET quantity = quantity + p_quantity
        WHERE part_id = p_part_id;
        -- Add error handling if part doesn't exist?
        COMMIT;
    END restock_inventory;

    PROCEDURE use_part_for_order(p_order_id IN NUMBER, p_part_id IN NUMBER, p_quantity_used IN NUMBER) AS
        v_current_quantity NUMBER;
        v_part_cost NUMBER;
    BEGIN
        -- Lock the row for update
        SELECT quantity, price
        INTO v_current_quantity, v_part_cost
        FROM inventory
        WHERE part_id = p_part_id
        FOR UPDATE;

        IF v_current_quantity >= p_quantity_used THEN
            UPDATE inventory
            SET quantity = quantity - p_quantity_used
            WHERE part_id = p_part_id;

            INSERT INTO parts_used (
                part_used_id, order_id, part_id, quantity, cost
            ) VALUES (
                seq_parts_used.NEXTVAL, p_order_id, p_part_id, p_quantity_used, v_part_cost * p_quantity_used -- Calculate cost
            );
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock for part ID: ' || p_part_id);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Part ID not found: ' || p_part_id);
    END use_part_for_order;

    PROCEDURE add_promotion(
        p_name IN VARCHAR2,
        p_description IN VARCHAR2,
        p_start_date IN DATE,
        p_end_date IN DATE,
        p_discount_percent IN NUMBER,
        p_service_id IN NUMBER DEFAULT NULL
    ) AS
    BEGIN
        INSERT INTO promotions (
            promotion_id, name, description, start_date, end_date, discount_percent, service_id
        ) VALUES (
            seq_promotions.NEXTVAL, p_name, p_description, p_start_date, p_end_date, p_discount_percent, p_service_id
        );
        COMMIT;
    END add_promotion;

    PROCEDURE assign_promotion_to_customer(p_customer_id IN NUMBER, p_promotion_id IN NUMBER) AS
    BEGIN
        INSERT INTO customer_promotions (
            customer_promotion_id, customer_id, promotion_id, assignment_date
        ) VALUES (
            seq_customer_promotions.NEXTVAL, p_customer_id, p_promotion_id, sysdate
        );
        COMMIT;
        -- Add checks if customer or promotion exist?
    END assign_promotion_to_customer;

    FUNCTION check_part_availability(p_part_id IN NUMBER) RETURN VARCHAR2 AS
        v_quantity NUMBER;
    BEGIN
        SELECT quantity
        INTO v_quantity
        FROM inventory
        WHERE part_id = p_part_id;

        IF v_quantity > 0 THEN
            RETURN 'Available';
        ELSE
            RETURN 'Out of Stock';
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Part Not Found';
    END check_part_availability;

    FUNCTION is_promotion_active(p_promotion_id IN NUMBER) RETURN VARCHAR2 AS
        v_active NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_active
        FROM promotions
        WHERE promotion_id = p_promotion_id
          AND sysdate BETWEEN start_date AND end_date;

        IF v_active > 0 THEN
            RETURN 'YES';
        ELSE
            RETURN 'NO';
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'NO';
    END is_promotion_active;

    FUNCTION promotion_duration_days(p_promotion_id IN NUMBER) RETURN NUMBER AS
        v_days NUMBER;
    BEGIN
        SELECT end_date - start_date
        INTO v_days
        FROM promotions
        WHERE promotion_id = p_promotion_id;

        RETURN NVL(v_days, 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END promotion_duration_days;

    FUNCTION average_customer_rating(p_customer_id IN NUMBER) RETURN NUMBER AS
        v_average NUMBER;
    BEGIN
        SELECT AVG(rating)
        INTO v_average
        FROM customer_reviews
        WHERE customer_id = p_customer_id;

        RETURN NVL(v_average, 0);
    END average_customer_rating;

END pkg_inventory;
/
