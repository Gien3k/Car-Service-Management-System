CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_PART_AVAILABILITY" (
    "PART_ID",
    "PART_NAME",
    "AVAILABLE_QUANTITY",
    "PRICE_PER_UNIT"
) AS
SELECT
    i.part_id,
    i.part_name,
    i.quantity AS available_quantity,
    i.price AS price_per_unit
FROM
    inventory i
ORDER BY
    i.part_name;