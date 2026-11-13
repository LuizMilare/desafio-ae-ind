with
    fonte_creditcard as (
        select *
        from {{ source('postgres', 'creditcard') }}
    )

    , renomeado as (
        select
            cast(creditcardid as int) as pk_creditcardid
            , cast(cardtype as string) as cardtype
            , cast(expmonth as int) as expmonth
            , cast(expyear as int) as expyear
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_creditcard
    )

select *
from renomeado
