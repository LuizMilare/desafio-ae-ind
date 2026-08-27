with
    products as (
        select *
        from {{ ref('int_dim_products') }}
    )

select *
from products