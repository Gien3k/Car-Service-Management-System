CREATE OR REPLACE TRIGGER trg_order_details_bi
BEFORE INSERT ON ORDER_DETAILS
FOR EACH ROW
BEGIN
    IF :NEW.DETAIL_ID IS NULL THEN
        SELECT seq_order_details.NEXTVAL INTO :NEW.DETAIL_ID FROM DUAL;
    END IF;
END;
/
ALTER TRIGGER trg_order_details_bi ENABLE;
