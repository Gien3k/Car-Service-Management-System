CREATE OR REPLACE TRIGGER trg_orders_bi
BEFORE INSERT ON ORDERS
FOR EACH ROW
BEGIN
    IF :NEW.ORDER_ID IS NULL THEN
        SELECT seq_orders.NEXTVAL INTO :NEW.ORDER_ID FROM DUAL;
    END IF;
    -- Default status and acceptance date are handled by table definition
END;
/
ALTER TRIGGER trg_orders_bi ENABLE;
