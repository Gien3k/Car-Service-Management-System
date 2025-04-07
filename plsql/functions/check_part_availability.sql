CREATE OR REPLACE FUNCTION check_part_availability (
    p_part_id IN NUMBER
) RETURN VARCHAR2 AS
    v_quantity NUMBER := 0;
BEGIN
    SELECT quantity
    INTO v_quantity
    FROM inventory
    WHERE part_id = p_part_id;

    IF v_quantity > 0 THEN
        RETURN 'Available';
    ELSE
        RETURN 'Out of Stock';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Part Not Found';
END check_part_availability;
/
