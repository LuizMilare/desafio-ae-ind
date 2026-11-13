with
    fonte_store as (
        select *
        from {{ source('postgres', 'store') }}
    )

    , renomeado as (
        select
            cast(businessentityid as int) as pk_businessentityid
            , cast(name as string) as store_name
            , cast(salespersonid as int) as fk_salespersonid
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_store
    )

select *
from renomeado
