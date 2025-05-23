ALTER TABLE "PARTS_USED" ADD FOREIGN KEY ("ORDER_ID") REFERENCES "ORDERS" ("ORDER_ID") ON DELETE CASCADE ENABLE;
ALTER TABLE "PARTS_USED" ADD FOREIGN KEY ("PART_ID") REFERENCES "INVENTORY" ("PART_ID") ON DELETE CASCADE ENABLE;

ALTER TABLE "INVOICES" ADD FOREIGN KEY ("ORDER_ID") REFERENCES "ORDERS" ("ORDER_ID") ON DELETE CASCADE ENABLE;

-- Foreign Keys for WORK_SCHEDULES
ALTER TABLE "WORK_SCHEDULES" ADD FOREIGN KEY ("ORDER_ID") REFERENCES "ORDERS" ("ORDER_ID") ON DELETE CASCADE ENABLE;

ALTER TABLE "WORK_SCHEDULES" ADD FOREIGN KEY ("EMPLOYEE_ID") REFERENCES "EMPLOYEES" ("EMPLOYEE_ID") ENABLE;

-- Foreign Keys for REPAIR_HISTORY
ALTER TABLE "REPAIR_HISTORY" ADD CONSTRAINT "FK_HISTORY_CUSTOMER" FOREIGN KEY ("CUSTOMER_ID") REFERENCES "CUSTOMERS" ("CUSTOMER_ID") ENABLE;

ALTER TABLE "REPAIR_HISTORY" ADD CONSTRAINT "FK_HISTORY_SERVICE" FOREIGN KEY ("SERVICE_ID") REFERENCES "SERVICES" ("SERVICE_ID") ENABLE;
ALTER TABLE "REPAIR_HISTORY" ADD FOREIGN KEY ("VEHICLE_ID") REFERENCES "VEHICLES" ("VEHICLE_ID") ON DELETE CASCADE ENABLE;

ALTER TABLE "REPAIR_HISTORY" ADD FOREIGN KEY ("ORDER_ID") REFERENCES "ORDERS" ("ORDER_ID") ENABLE;

-- Foreign Keys for CUSTOMER_PROMOTIONS
ALTER TABLE "CUSTOMER_PROMOTIONS" ADD FOREIGN KEY ("CUSTOMER_ID") REFERENCES "CUSTOMERS" ("CUSTOMER_ID") ON DELETE CASCADE ENABLE;

ALTER TABLE "CUSTOMER_PROMOTIONS" ADD FOREIGN KEY ("PROMOTION_ID") REFERENCES "PROMOTIONS" ("PROMOTION_ID") ON DELETE CASCADE ENABLE;

-- Foreign Keys for INVENTORY
ALTER TABLE "INVENTORY" ADD FOREIGN KEY ("SUPPLIER_ID") REFERENCES "SUPPLIERS" ("SUPPLIER_ID") ENABLE;

ALTER TABLE "CUSTOMER_REVIEWS" ADD FOREIGN KEY ("CUSTOMER_ID") REFERENCES "CUSTOMERS" ("CUSTOMER_ID") ON DELETE CASCADE ENABLE;

-- Foreign Keys for PAYMENTS
ALTER TABLE "PAYMENTS" ADD FOREIGN KEY ("INVOICE_ID") REFERENCES "INVOICES" ("INVOICE_ID") ON DELETE CASCADE ENABLE;

ALTER TABLE "VEHICLES" ADD FOREIGN KEY ("CUSTOMER_ID") REFERENCES "CUSTOMERS" ("CUSTOMER_ID") ON DELETE CASCADE ENABLE;

-- Foreign Keys for PROMOTIONS
ALTER TABLE "PROMOTIONS" ADD CONSTRAINT "FK_PROMOTIONS_SERVICES" FOREIGN KEY ("SERVICE_ID") REFERENCES "SERVICES" ("SERVICE_ID") ENABLE;

ALTER TABLE "SUPPLY_ORDER_DETAILS" ADD FOREIGN KEY ("SUPPLY_ORDER_ID") REFERENCES "SUPPLY_ORDERS" ("SUPPLY_ORDER_ID") ON DELETE CASCADE ENABLE;
ALTER TABLE "SUPPLY_ORDER_DETAILS" ADD FOREIGN KEY ("PART_ID") REFERENCES "INVENTORY" ("PART_ID") ENABLE;

ALTER TABLE "ORDER_DETAILS" ADD FOREIGN KEY ("ORDER_ID") REFERENCES "ORDERS" ("ORDER_ID") ON DELETE CASCADE ENABLE;
ALTER TABLE "ORDER_DETAILS" ADD FOREIGN KEY ("SERVICE_ID") REFERENCES "SERVICES" ("SERVICE_ID") ON DELETE CASCADE ENABLE;

ALTER TABLE "EMPLOYEE_PERMISSIONS" ADD FOREIGN KEY ("EMPLOYEE_ID") REFERENCES "EMPLOYEES" ("EMPLOYEE_ID") ON DELETE CASCADE ENABLE;
ALTER TABLE "EMPLOYEE_PERMISSIONS" ADD FOREIGN KEY ("ROLE_ID") REFERENCES "EMPLOYEE_ROLES" ("ROLE_ID") ON DELETE CASCADE ENABLE;

ALTER TABLE "REQUIRED_PARTS" ADD FOREIGN KEY ("SERVICE_ID") REFERENCES "SERVICES" ("SERVICE_ID") ENABLE;
ALTER TABLE "REQUIRED_PARTS" ADD FOREIGN KEY ("PART_ID") REFERENCES "INVENTORY" ("PART_ID") ENABLE;

ALTER TABLE "SUPPLY_ORDERS" ADD FOREIGN KEY ("SUPPLIER_ID") REFERENCES "SUPPLIERS" ("SUPPLIER_ID") ENABLE;

-- Foreign Keys for ORDERS
ALTER TABLE "ORDERS" ADD CONSTRAINT "FK_ORDERS_SERVICE_ID" FOREIGN KEY ("SERVICE_ID") REFERENCES "SERVICES" ("SERVICE_ID") ENABLE; -- Verify if needed
ALTER TABLE "ORDERS" ADD FOREIGN KEY ("VEHICLE_ID") REFERENCES "VEHICLES" ("VEHICLE_ID") ON DELETE CASCADE ENABLE;

ALTER TABLE "ORDERS" ADD FOREIGN KEY ("EMPLOYEE_ID") REFERENCES "EMPLOYEES" ("EMPLOYEE_ID") ENABLE;

-- Indexes for CUSTOMERS
CREATE UNIQUE INDEX "IDX_CUSTOMERS_PK" ON "CUSTOMERS" ("CUSTOMER_ID");
