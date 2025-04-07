CREATE OR REPLACE FUNCTION get_client_data (
    p_customer_id IN NUMBER
) RETURN VARCHAR2 AS
    v_data VARCHAR2(200);
BEGIN
    SELECT first_name || ' ' || last_name || ' (' || email || ')'
    INTO v_data
    FROM customers
    WHERE customer_id = p_customer_id;

    RETURN v_data;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Customer not found';
END get_client_data;
/
