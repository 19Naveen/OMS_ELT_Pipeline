SELECT
    OrderID,
    OrderDate,
    CustomerID,
    EmployeeID,
    StoreID,
    Status,
    Updated_at
FROM {{ source('l1_landing', 'orders') }}
WHERE file_date = '{{ macros.ds() }}'
WHERE file_date = '{{ macros.ds_add(macros.ds(), -1) }}'