{{ config(
    materialized='incremental',
    unique_key='OrderID',
    incremental_strategy='merge'
) }}

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
    {{ ref('stg_orders') }} o
JOIN 
    {{ ref('stg_orderitems') }} oi ON o.OrderID = oi.OrderID

{% if is_incremental() %}
WHERE o.Updated_at >= (SELECT MAX(Updated_at) FROM {{ this }})
{% endif %}

GROUP BY
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    o.EmployeeID,
    o.StoreID,
    o.Status,
    o.Updated_at
