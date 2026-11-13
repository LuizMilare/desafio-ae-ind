with
    salesreasons as (
        select *
        from {{ ref('int_dim_sales_reasons') }}
    )

select *
from salesreasons
