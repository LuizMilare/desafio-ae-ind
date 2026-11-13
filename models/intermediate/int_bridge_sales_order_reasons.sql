with
    orderreasons as (
        select *
        from {{ ref('stg_postgres__salesorderheadersalesreason') }}
    )

    , selected as (
        select
            orderreasons.pk_salesorderid as fk_salesorderid
            , orderreasons.fk_salesreasonid
        from orderreasons
    )

select *
from selected
