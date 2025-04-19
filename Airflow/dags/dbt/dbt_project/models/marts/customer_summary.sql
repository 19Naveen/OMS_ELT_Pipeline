{{ config(
    materialized='incremental',
    unique_key='CustomerID',
    incremental_strategy='merge'
) }}

SELECT 
    os.CustomerID,
    c.CustomerName,
    c.City,
    c.State,
    SUM(os.OrderCount) AS OrderCount,
    SUM(os.Revenue) AS Revenue,
    MAX(c.Updated_at) AS Updated_at
FROM 
    {{ ref('orders_fact') }} os
JOIN 
    {{ ref('stg_customers') }} c 
    ON os.CustomerID = c.CustomerID

{% if is_incremental() %}
WHERE c.Updated_at >= (SELECT MAX(Updated_at) FROM {{ this }})
{% endif %}
GROUP BY 
    os.CustomerID,
    c.CustomerName,
    c.City,
    c.State
