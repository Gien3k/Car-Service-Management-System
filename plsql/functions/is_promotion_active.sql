CREATE OR REPLACE FUNCTION is_promotion_active (
    p_promotion_id IN NUMBER
) RETURN VARCHAR2 AS
    v_active NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_active
    FROM promotions
    WHERE promotion_id = p_promotion_id
      AND sysdate BETWEEN start_date AND end_date;

    IF v_active > 0 THEN
        RETURN 'YES';
    ELSE
        RETURN 'NO';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'NO'; -- Promotion doesn't exist
END is_promotion_active;
/
