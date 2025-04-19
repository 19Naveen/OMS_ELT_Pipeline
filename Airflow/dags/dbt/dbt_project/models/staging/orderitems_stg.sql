SELECT
    OrderItemID,
    OrderID,
    ProductID,
    Quantity,
    UnitPrice,
    Quantity * UnitPrice AS TotalPrice,
    Updated_at
FROM {{ source('l1_landing', 'orderitems') }}
WHERE file_date = '{{ macros.ds_add(macros.ds(), -1) }}'