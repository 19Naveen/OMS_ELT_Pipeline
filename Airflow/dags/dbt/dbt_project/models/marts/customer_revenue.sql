SELECT 
    OS.CustomerID,
    C.CustomerName,
    C.City,
    C.State,
    SUM(OS.OrderCount) AS OrderCount,
    SUM(OS.Revenue) AS Revenue
FROM 
    {{ ref('orders_fact') }} OS
JOIN 
    {{ ref('customer_stg') }} C 
    ON OS.CustomerID = C.CustomerID
GROUP BY 
    OS.CustomerID,
    C.CustomerName,
    C.City,
    C.State
