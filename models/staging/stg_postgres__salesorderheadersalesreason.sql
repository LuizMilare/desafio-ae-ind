with
    fonte_salesorderheadersalesreason as (
        select *
        from {{ source('postgres', 'salesorderheadersalesreason') }}
    )
    
    , renomeado as (
        select
            cast(salesorderid as int) as pk_salesorderid
            , cast(salesreasonid as int) as fk_salesreasonid 
            , cast(modifieddate as timestamp) as modifieddate 
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_salesorderheadersalesreason
    )

select *
from renomeado