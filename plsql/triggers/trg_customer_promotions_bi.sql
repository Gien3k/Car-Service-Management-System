CREATE OR REPLACE TRIGGER trg_customer_promotions_bi
BEFORE INSERT ON CUSTOMER_PROMOTIONS
FOR EACH ROW
BEGIN
    IF :NEW.CUSTOMER_PROMOTION_ID IS NULL THEN
        SELECT seq_customer_promotions.NEXTVAL INTO :NEW.CUSTOMER_PROMOTION_ID FROM DUAL;
    END IF;
END;
/
ALTER TRIGGER trg_customer_promotions_bi ENABLE;
