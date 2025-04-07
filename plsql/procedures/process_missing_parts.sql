CREATE OR REPLACE PROCEDURE process_missing_parts AS
    CURSOR missing_parts_cursor IS
        SELECT part_id, quantity AS current_quantity -- Quantity here is the low level that triggered logging
        FROM temp_missing_parts;

    v_supply_order_id NUMBER;
    v_supplier_id NUMBER;
    v_part_price NUMBER;
    v_quantity_to_order NUMBER;
BEGIN
    FOR rec IN missing_parts_cursor LOOP
        -- Get supplier and price for the part
        BEGIN
          SELECT supplier_id, price
          INTO v_supplier_id, v_part_price
          FROM inventory
          WHERE part_id = rec.part_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Skipping part ID ' || rec.part_id || ': Not found in inventory.');
                DELETE FROM temp_missing_parts WHERE part_id = rec.part_id; -- Clean up temp table
                CONTINUE; -- Skip to next part
        END;


        IF v_supplier_id IS NULL THEN
             DBMS_OUTPUT.PUT_LINE('Skipping part ID ' || rec.part_id || ': No supplier assigned.');
             DELETE FROM temp_missing_parts WHERE part_id = rec.part_id; -- Clean up temp table
             CONTINUE; -- Skip to next part
        END IF;

         -- Determine quantity to order (e.g., restock up to 20)
         v_quantity_to_order := GREATEST(1, 20 - rec.current_quantity);

        -- Create supply order (Consider merging if an open order for the supplier exists?)
        INSERT INTO supply_orders (supply_order_id, supplier_id, order_date, status)
        VALUES (seq_supply_orders.NEXTVAL, v_supplier_id, SYSDATE, 'Pending')
        RETURNING supply_order_id INTO v_supply_order_id;

        -- Add order detail
        INSERT INTO supply_order_details (detail_id, supply_order_id, part_id, quantity, price)
        VALUES (
            seq_supply_order_details.NEXTVAL,
            v_supply_order_id,
            rec.part_id,
            v_quantity_to_order,
            v_part_price
        );

        -- Remove processed record from temp table
        DELETE FROM temp_missing_parts
        WHERE part_id = rec.part_id;

         DBMS_OUTPUT.PUT_LINE('Order created from temp table for part ID: ' || rec.part_id);

    END LOOP;

    COMMIT;
END process_missing_parts;
/
