with
    creditcards as (
        select *
        from {{ ref('stg_postgres__creditcard') }}
    )

    , selected as (
        select
            creditcards.pk_creditcardid
            , creditcards.cardtype
        from creditcards
    )

select *
from selected
