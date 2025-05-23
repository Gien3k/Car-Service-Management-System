CREATE OR REPLACE TRIGGER trg_supply_orders_bi
BEFORE INSERT ON SUPPLY_ORDERS
FOR EACH ROW
BEGIN
    IF :NEW.SUPPLY_ORDER_ID IS NULL THEN
        SELECT seq_supply_orders.NEXTVAL INTO :NEW.SUPPLY_ORDER_ID FROM DUAL;
    END IF;
END;
/
ALTER TRIGGER trg_supply_orders_bi ENABLE;
