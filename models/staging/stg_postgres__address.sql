with
    fonte_address as (
        select *
        from {{ source('postgres', 'address') }}
    )
    
    , renomeado as (
        select
            cast(addressid as int) as pk_addressid
            , cast(stateprovinceid as int) as fk_stateprovinceid
            , cast(addressline1 as string) as addressline1
            , cast(addressline2 as string) as addressline2
            , cast(city as string) as city
            , cast(postalcode as string) as postalcode
            , cast(spatiallocation as string) as spatiallocation
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_address
    )

select *
from renomeado