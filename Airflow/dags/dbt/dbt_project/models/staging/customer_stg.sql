SELECT
    CustomerID,
    FirstName,
    LastName,
    Email,
    Phone,
    Address,
    City,
    State,
    ZipCode,
    Updated_at,
    CONCAT(FirstName, ' ', LastName) AS CustomerName
FROM {{ source('l1_landing', 'customers') }}
WHERE file_date = '{{ macros.ds_add(macros.ds(), -1) }}'