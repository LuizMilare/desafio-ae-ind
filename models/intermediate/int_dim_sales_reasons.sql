with
    salesreasons as (
        select *
        from {{ ref('stg_postgres__salesreason') }}
    )

    , selected as (
        select
            salesreasons.pk_salesreasonid
            , salesreasons.name as salesreason_name
            , salesreasons.reasontype
        from salesreasons
    )

select *
from selected
