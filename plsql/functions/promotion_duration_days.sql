CREATE OR REPLACE FUNCTION promotion_duration_days (
    p_promotion_id IN NUMBER
) RETURN NUMBER AS
    v_days NUMBER := 0;
BEGIN
    SELECT end_date - start_date
    INTO v_days
    FROM promotions
    WHERE promotion_id = p_promotion_id;

    RETURN NVL(v_days, 0); -- Returns 0 if dates are null or promotion not found
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END promotion_duration_days;
/
