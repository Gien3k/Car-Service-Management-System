-- Trigger for sequence usually not needed for composite PK table without its own sequence
CREATE OR REPLACE TRIGGER trg_required_parts_bi
BEFORE INSERT ON REQUIRED_PARTS
FOR EACH ROW
BEGIN
    -- Check if IDs are provided (already handled by NOT NULL constraint potentially)
    IF :NEW.SERVICE_ID IS NULL OR :NEW.PART_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'SERVICE_ID and PART_ID must be provided for REQUIRED_PARTS.');
    END IF;
     IF :NEW.quantity <= 0 THEN
        RAISE_APPLICATION_ERROR(-20014, 'Required parts quantity must be positive.');
     END IF;
END;
/
ALTER TRIGGER trg_required_parts_bi ENABLE;
