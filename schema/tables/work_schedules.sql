CREATE TABLE "WORK_SCHEDULES" (
    "SCHEDULE_ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE NOKEEP NOSCALE NOT NULL ENABLE,
    "ORDER_ID" NUMBER NOT NULL ENABLE,
    "EMPLOYEE_ID" NUMBER NOT NULL ENABLE,
    "WORK_DATE" DATE NOT NULL ENABLE,
    "START_TIME" TIMESTAMP(6),
    "END_TIME" TIMESTAMP(6),
    PRIMARY KEY ("SCHEDULE_ID") USING INDEX ENABLE
);
