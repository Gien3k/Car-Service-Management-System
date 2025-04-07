CREATE OR REPLACE TRIGGER trg_inventory_bi
BEFORE INSERT ON INVENTORY
FOR EACH ROW
BEGIN
    IF :NEW.PART_ID IS NULL THEN
        SELECT seq_inventory.NEXTVAL INTO :NEW.PART_ID FROM DUAL;
    END IF;
     IF :NEW.quantity < 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Inventory quantity cannot be negative.');
     END IF;
      IF :NEW.price < 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Inventory price cannot be negative.');
     END IF;
END;
/
ALTER TRIGGER trg_inventory_bi ENABLE;
