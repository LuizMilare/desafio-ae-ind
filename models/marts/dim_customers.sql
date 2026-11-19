with
    customers as (
        select *
        from {{ ref('int_dim_customers') }}
    )

select *
from customers
