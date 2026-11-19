with
    fonte_customer as (
        select *
        from {{ source('postgres', 'customer') }}
    )

    , renomeado as (
        select
            cast(customerid as int) as pk_customerid
            , cast(personid as int) as fk_personid
            , cast(storeid as int) as fk_storeid
            , cast(territoryid as int) as fk_territoryid
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_customer
    )

select *
from renomeado
