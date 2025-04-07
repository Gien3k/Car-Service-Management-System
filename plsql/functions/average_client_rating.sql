CREATE OR REPLACE FUNCTION average_client_rating (
    p_customer_id IN NUMBER
) RETURN NUMBER AS
    v_average NUMBER := 0;
BEGIN
    SELECT AVG(rating)
    INTO v_average
    FROM customer_reviews
    WHERE customer_id = p_customer_id;

    RETURN NVL(v_average, 0); -- Returns 0 if no ratings exist
END average_client_rating;
/
