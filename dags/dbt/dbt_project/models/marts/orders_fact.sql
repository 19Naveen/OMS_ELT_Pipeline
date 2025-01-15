SELECT
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    o.EmployeeID,
    o.StoreID,
    o.Status,
    o.Updated_at,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    SUM(oi.TotalPrice) AS Revenue
FROM
    {{ ref('orders_stg') }} o
JOIN
    {{ ref('orderitems_stg') }} oi
    ON o.OrderID = oi.OrderID
GROUP BY
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    o.EmployeeID,
    o.StoreID,
    o.Status,
    o.Updated_at
