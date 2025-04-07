CREATE OR REPLACE TRIGGER trg_check_inventory_level
AFTER UPDATE OF quantity ON inventory
FOR EACH ROW
WHEN (NEW.quantity < 10 AND NEW.quantity < OLD.quantity) -- Trigger only when quantity decreases below threshold
BEGIN
    -- Avoid re-inserting if already in temp table and not processed
    MERGE INTO temp_missing_parts tmp
    USING (SELECT :NEW.part_id AS part_id FROM dual) src ON (tmp.part_id = src.part_id)
    WHEN NOT MATCHED THEN
      INSERT (part_id, quantity, report_date)
      VALUES (:NEW.part_id, :NEW.quantity, SYSDATE);
    -- No update needed if matched, it's already logged. Process_missing_parts should delete it.
END;
/
ALTER TRIGGER trg_check_inventory_level ENABLE;
