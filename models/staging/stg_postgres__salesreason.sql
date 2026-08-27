with
    fonte_salesreason as (
        select *
        from {{ source('postgres', 'salesreason') }}
    )
    
    , renomeado as (
        select
            cast(salesreasonid as int) as pk_salesreasonid
            , cast(name as string) as name
            , cast(reasontype as string) as reasontype
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_salesreason
    )

select *
from renomeado