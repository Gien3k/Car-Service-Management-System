CREATE OR REPLACE TRIGGER trg_payments_bi
BEFORE INSERT ON PAYMENTS
FOR EACH ROW
DECLARE
    v_invoice_status VARCHAR2(20);
BEGIN
    IF :NEW.PAYMENT_ID IS NULL THEN
        SELECT seq_payments.NEXTVAL INTO :NEW.PAYMENT_ID FROM DUAL;
    END IF;

    -- Optionally, update invoice status upon payment insertion
    IF :NEW.invoice_id IS NOT NULL THEN
      UPDATE invoices
      SET status = 'Paid'
      WHERE invoice_id = :NEW.invoice_id
      AND status = 'Unpaid'; -- Only update if it was unpaid
    END IF;
END;
/
ALTER TRIGGER trg_payments_bi ENABLE;
