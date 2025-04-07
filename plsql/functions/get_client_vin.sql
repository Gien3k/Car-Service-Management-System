CREATE OR REPLACE FUNCTION get_client_vin (
    p_customer_id IN NUMBER
) RETURN VARCHAR2 AS
    v_vin VARCHAR2(17);
BEGIN
    SELECT vin
    INTO v_vin
    FROM vehicles
    WHERE customer_id = p_customer_id
      AND ROWNUM = 1; -- Returns VIN of the first vehicle found for the customer

    RETURN v_vin;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No vehicle found for customer';
END get_client_vin;
/
