with
    fonte_address as (
        select *
        from {{ source('postgres', 'address') }}
    )
    
    , renomeado as (
        select
            cast(addressid as int) as pk_addressid
            , cast(stateprovinceid as int) as fk_stateprovinceid
            , cast(city as string) as city
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_address
    )

select *
from renomeado