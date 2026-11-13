with
    creditcards as (
        select *
        from {{ ref('int_dim_credit_cards') }}
    )

select *
from creditcards
