{{ config(
    materialized='incremental',
    unique_key='CustomerID',
    incremental_strategy='merge'
) }}

SELECT 
    CustomerID,
    COUNT(DISTINCT OrderID) AS OrderCount,
    SUM(Revenue) AS Revenue,
    MAX(Updated_at) AS Updated_at
FROM 
    {{ ref('int_orders_agg') }}

{% if is_incremental() %}
WHERE Updated_at >= (SELECT MAX(Updated_at) FROM {{ this }})
{% endif %}

GROUP BY CustomerID
