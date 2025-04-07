CREATE TABLE "PARTS_USED" (
    "PART_USED_ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE NOKEEP NOSCALE NOT NULL ENABLE,
    "ORDER_ID" NUMBER NOT NULL ENABLE,
    "PART_ID" NUMBER NOT NULL ENABLE,
    "QUANTITY" NUMBER(5, 0) NOT NULL ENABLE,
    "COST" NUMBER(10, 2),
    PRIMARY KEY ("PART_USED_ID") USING INDEX ENABLE
);
