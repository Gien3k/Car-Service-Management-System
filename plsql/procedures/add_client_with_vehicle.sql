CREATE OR REPLACE PROCEDURE add_client_with_vehicle (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN VARCHAR2,
    p_address IN VARCHAR2,
    p_registration_number IN VARCHAR2,
    p_make IN VARCHAR2,
    p_model IN VARCHAR2,
    p_production_year IN NUMBER,
    p_vin IN VARCHAR2
) AS
    v_customer_id NUMBER;
    v_count_vin NUMBER;
    v_count_reg NUMBER;
    v_count_phone NUMBER;
BEGIN
    -- Validate uniqueness constraints before inserting
    SELECT COUNT(*) INTO v_count_vin FROM vehicles WHERE UPPER(vin) = UPPER(p_vin);
    IF v_count_vin > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Vehicle with VIN "' || p_vin || '" already exists.');
    END IF;

    SELECT COUNT(*) INTO v_count_reg FROM vehicles WHERE UPPER(registration_number) = UPPER(p_registration_number);
     IF v_count_reg > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Vehicle with Registration Number "' || p_registration_number || '" already exists.');
    END IF;

    SELECT COUNT(*) INTO v_count_phone FROM customers WHERE phone = p_phone;
     IF v_count_phone > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Customer with Phone Number "' || p_phone || '" already exists.');
    END IF;


    -- Add customer
    INSERT INTO customers (customer_id, first_name, last_name, phone, email, address, creation_date)
    VALUES (seq_customers.NEXTVAL, p_first_name, p_last_name, p_phone, p_email, p_address, sysdate)
    RETURNING customer_id INTO v_customer_id;

    -- Add vehicle
    INSERT INTO vehicles (vehicle_id, customer_id, registration_number, make, model, production_year, vin, add_date)
    VALUES (seq_vehicles.NEXTVAL, v_customer_id, UPPER(p_registration_number), p_make, p_model, p_production_year, UPPER(p_vin), sysdate);

    COMMIT;
     DBMS_OUTPUT.PUT_LINE('Customer ' || v_customer_id || ' and vehicle added.');
END add_client_with_vehicle;
/
