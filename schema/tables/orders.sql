CREATE TABLE "ORDERS" (
    "ORDER_ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE NOKEEP NOSCALE NOT NULL ENABLE,
    "VEHICLE_ID" NUMBER NOT NULL ENABLE,
    "EMPLOYEE_ID" NUMBER NOT NULL ENABLE,
    "ACCEPTANCE_DATE" DATE DEFAULT sysdate,
    "COMPLETION_DATE" DATE,
    "STATUS" VARCHAR2(20) DEFAULT 'New', -- 'New', 'In Progress', 'Completed'
    "NOTES" VARCHAR2(500),
    "SERVICE_ID" NUMBER, -- Consider if this column is still needed if details are in ORDER_DETAILS
    PRIMARY KEY ("ORDER_ID") USING INDEX ENABLE
);
