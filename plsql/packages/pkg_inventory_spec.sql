CREATE OR REPLACE PACKAGE pkg_inventory AS
    -- Procedures
    PROCEDURE restock_inventory(p_part_id IN NUMBER, p_quantity IN NUMBER);
    PROCEDURE use_part_for_order(p_order_id IN NUMBER, p_part_id IN NUMBER, p_quantity_used IN NUMBER); -- Modified to take quantity
    PROCEDURE add_promotion(p_name IN VARCHAR2, p_description IN VARCHAR2, p_start_date IN DATE, p_end_date IN DATE, p_discount_percent IN NUMBER, p_service_id IN NUMBER DEFAULT NULL); -- Made service optional
    PROCEDURE assign_promotion_to_customer(p_customer_id IN NUMBER, p_promotion_id IN NUMBER);

    -- Functions (Some already exist standalone, decide if duplication is desired or refactor)
    FUNCTION check_part_availability(p_part_id IN NUMBER) RETURN VARCHAR2;
    FUNCTION is_promotion_active(p_promotion_id IN NUMBER) RETURN VARCHAR2;
    FUNCTION promotion_duration_days(p_promotion_id IN NUMBER) RETURN NUMBER;
    FUNCTION average_customer_rating(p_customer_id IN NUMBER) RETURN NUMBER; -- Renamed from client

END pkg_inventory;
/
