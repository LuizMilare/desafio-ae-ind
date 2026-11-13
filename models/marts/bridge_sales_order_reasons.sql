with
    orderreasons as (
        select *
        from {{ ref('int_bridge_sales_order_reasons') }}
    )

select *
from orderreasons
