CREATE OR REPLACE TRIGGER trg_vehicles_bi
BEFORE INSERT ON VEHICLES
FOR EACH ROW
BEGIN
    IF :NEW.VEHICLE_ID IS NULL THEN
        SELECT seq_vehicles.NEXTVAL INTO :NEW.VEHICLE_ID FROM DUAL;
    END IF;
     :NEW.vin := UPPER(:NEW.vin);
     :NEW.registration_number := UPPER(:NEW.registration_number);
END;
/
ALTER TRIGGER trg_vehicles_bi ENABLE;
