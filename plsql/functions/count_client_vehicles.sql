CREATE OR REPLACE FUNCTION count_client_vehicles (
    p_customer_id IN NUMBER
) RETURN NUMBER AS
    v_vehicle_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_vehicle_count
    FROM vehicles
    WHERE customer_id = p_customer_id;

    RETURN v_vehicle_count;
END count_client_vehicles;
/
