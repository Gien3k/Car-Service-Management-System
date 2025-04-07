CREATE OR REPLACE PROCEDURE fulfill_supply_order(
    p_supply_order_id IN NUMBER
) AS
   v_status VARCHAR2(50);
BEGIN

    SELECT status INTO v_status
    FROM supply_orders
    WHERE supply_order_id = p_supply_order_id;

    IF v_status = 'Fulfilled' THEN
        RAISE_APPLICATION_ERROR(-20030, 'Supply order already fulfilled.');
    END IF;

    -- Add parts to inventory using MERGE
    MERGE INTO inventory i
    USING (
        SELECT sod.part_id, sod.quantity
        FROM supply_order_details sod
        WHERE sod.supply_order_id = p_supply_order_id
    ) src
    ON (i.part_id = src.part_id)
    WHEN MATCHED THEN
        UPDATE SET i.quantity = i.quantity + src.quantity
    WHEN NOT MATCHED THEN
        -- This case shouldn't happen if parts always exist, but handle defensively
        INSERT (part_id, part_name, quantity, price, supplier_id) -- Need more info for insert
        VALUES (src.part_id, 'UNKNOWN - ADD MANUALLY', src.quantity, 0, -- Cannot insert without name/price/supplier
                (SELECT supplier_id FROM supply_orders WHERE supply_order_id=p_supply_order_id));

    -- Update supply order status
    UPDATE supply_orders
    SET status = 'Fulfilled'
    WHERE supply_order_id = p_supply_order_id;

     IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20031, 'Supply order not found.');
     END IF;

    COMMIT;
     DBMS_OUTPUT.PUT_LINE('Supply order ' || p_supply_order_id || ' fulfilled.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20031, 'Supply order not found.');

END fulfill_supply_order;
/
