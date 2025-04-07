CREATE OR REPLACE PROCEDURE automatic_supply_order AS
    CURSOR low_stock_parts IS
        SELECT part_id, part_name, quantity, supplier_id
        FROM inventory
        WHERE quantity < 10 AND supplier_id IS NOT NULL;

    v_supply_order_id NUMBER;
    v_pending_order_exists NUMBER;
    v_part_price NUMBER;
    v_quantity_to_order NUMBER;
BEGIN
    FOR rec IN low_stock_parts LOOP
        -- Check if a pending order for this part already exists
        SELECT COUNT(*)
        INTO v_pending_order_exists
        FROM supply_orders so
        JOIN supply_order_details sod ON so.supply_order_id = sod.supply_order_id
        WHERE sod.part_id = rec.part_id AND so.status = 'Pending';

        IF v_pending_order_exists = 0 THEN
            -- Determine quantity to order (e.g., restock up to 20)
            v_quantity_to_order := GREATEST(1, 20 - rec.quantity); -- Order at least 1, up to 20 total

            -- Get part price for the order detail
            SELECT price INTO v_part_price FROM inventory WHERE part_id = rec.part_id;

            -- Create a new supply order header
            INSERT INTO supply_orders (supply_order_id, supplier_id, order_date, status)
            VALUES (seq_supply_orders.NEXTVAL, rec.supplier_id, SYSDATE, 'Pending')
            RETURNING supply_order_id INTO v_supply_order_id;

            -- Add supply order detail
            INSERT INTO supply_order_details (detail_id, supply_order_id, part_id, quantity, price)
            VALUES (
                seq_supply_order_details.NEXTVAL,
                v_supply_order_id,
                rec.part_id,
                v_quantity_to_order,
                v_part_price -- Use current price for reference, actual cost might differ on fulfillment
            );

            DBMS_OUTPUT.PUT_LINE('Supply order ' || v_supply_order_id || ' generated for part: ' || rec.part_name);
        ELSE
             DBMS_OUTPUT.PUT_LINE('Skipping part ' || rec.part_name || ' - Pending order exists.');
        END IF;
    END LOOP;

    COMMIT;
END automatic_supply_order;
/
