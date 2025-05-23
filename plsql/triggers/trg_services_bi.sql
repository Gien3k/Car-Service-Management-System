CREATE OR REPLACE TRIGGER trg_services_bi
BEFORE INSERT ON SERVICES
FOR EACH ROW
BEGIN
    IF :NEW.SERVICE_ID IS NULL THEN
        SELECT seq_services.NEXTVAL INTO :NEW.SERVICE_ID FROM DUAL;
    END IF;
    IF :NEW.price < 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Service price cannot be negative.');
     END IF;
END;
/
ALTER TRIGGER trg_services_bi ENABLE;
