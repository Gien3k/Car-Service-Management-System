CREATE OR REPLACE PACKAGE pkg_orders AS

    -- Procedures
    PROCEDURE add_order(
        p_vehicle_id IN NUMBER,
        p_employee_id IN NUMBER,
        p_service_id IN NUMBER, -- Assuming one primary service for the order header
        p_notes IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE add_order_detail( -- Add detail separately if multiple services/parts per order
        p_order_id IN NUMBER,
        p_service_id IN NUMBER,
        p_quantity IN NUMBER DEFAULT 1
    );

    PROCEDURE complete_order(
        p_order_id IN NUMBER
    );

    -- PROCEDURE remove_order( -- Dangerous operation, maybe disable or add checks
    --  p_order_id IN NUMBER
    -- );

    PROCEDURE update_order_status(
        p_order_id IN NUMBER,
        p_status IN VARCHAR2
    );

    -- Functions (Some already exist standalone)
    FUNCTION calculate_order_cost( -- Renamed
        p_order_id IN NUMBER
    ) RETURN NUMBER;

    FUNCTION get_last_order_date_for_vehicle( -- Renamed
        p_vehicle_id IN NUMBER
    ) RETURN DATE;

    FUNCTION count_orders_for_employee( -- Renamed
        p_employee_id IN NUMBER,
        p_include_completed IN BOOLEAN DEFAULT FALSE
    ) RETURN NUMBER;

    -- FUNCTION get_order_data( -- Might be too broad, consider specific data needs
    --  p_order_id IN NUMBER
    -- ) RETURN VARCHAR2; -- Or return a record/cursor

END pkg_orders;
/
