with
    dates as (
        select *
        from {{ ref('int_dim_dates') }}
    )

select *
from dates
