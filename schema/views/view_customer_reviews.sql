CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_CUSTOMER_REVIEWS" (
    "REVIEW_ID",
    "CUSTOMER_NAME",
    "RATING",
    "COMMENT_TEXT",
    "REVIEW_DATE"
) AS
SELECT
    cr.review_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    cr.rating,
    cr.comment_text,
    cr.review_date
FROM
    customer_reviews cr
JOIN customers c ON cr.customer_id = c.customer_id
ORDER BY
    cr.review_date DESC;
