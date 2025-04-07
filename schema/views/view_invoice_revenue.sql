CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_INVOICE_REVENUE" (
    "STATUS",
    "INVOICE_COUNT",
    "TOTAL_REVENUE"
) AS
SELECT
    i.status,
    count(i.invoice_id) AS invoice_count,
    sum(i.total_amount) AS total_revenue
FROM
    invoices i
GROUP BY
    i.status
ORDER BY
    i.status;
