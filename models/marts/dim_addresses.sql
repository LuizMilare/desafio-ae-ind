with
    addresses as (
        select *
        from {{ ref('int_dim_address') }}
    )

select *
from addresses