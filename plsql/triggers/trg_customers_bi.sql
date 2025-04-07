CREATE OR REPLACE TRIGGER trg_customers_bi
BEFORE INSERT ON CUSTOMERS
FOR EACH ROW
BEGIN
    IF :NEW.CUSTOMER_ID IS NULL THEN
        SELECT SEQ_CUSTOMERS.NEXTVAL INTO :NEW.CUSTOMER_ID FROM DUAL;
    END IF;
     -- Optionally enforce data format or case consistency
     :NEW.email := LOWER(:NEW.email);
     :NEW.first_name := INITCAP(:NEW.first_name);
     :NEW.last_name := INITCAP(:NEW.last_name);
END;
/
ALTER TRIGGER trg_customers_bi ENABLE;
