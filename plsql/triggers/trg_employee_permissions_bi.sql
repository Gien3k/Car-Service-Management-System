CREATE OR REPLACE TRIGGER trg_employee_permissions_bi
BEFORE INSERT ON EMPLOYEE_PERMISSIONS
FOR EACH ROW
BEGIN
    IF :NEW.PERMISSION_ID IS NULL THEN
        SELECT seq_employee_permissions.NEXTVAL INTO :NEW.PERMISSION_ID FROM DUAL;
    END IF;
END;
/
ALTER TRIGGER trg_employee_permissions_bi ENABLE;
