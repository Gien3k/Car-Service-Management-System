CREATE OR REPLACE PROCEDURE add_promotion (
    p_name IN VARCHAR2,
    p_description IN VARCHAR2,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_discount_percent IN NUMBER,
    p_service_id IN NUMBER DEFAULT NULL -- Make service optional
) AS
BEGIN
    IF p_start_date >= p_end_date THEN
         RAISE_APPLICATION_ERROR(-20020, 'Promotion end date must be after start date.');
    END IF;
    IF p_discount_percent <= 0 OR p_discount_percent > 100 THEN
         RAISE_APPLICATION_ERROR(-20021, 'Discount percent must be between 0 and 100.');
    END IF;

    INSERT INTO promotions (promotion_id, name, description, start_date, end_date, discount_percent, service_id)
    VALUES (seq_promotions.NEXTVAL, p_name, p_description, p_start_date, p_end_date, p_discount_percent, p_service_id);

    COMMIT;
END add_promotion;
/
