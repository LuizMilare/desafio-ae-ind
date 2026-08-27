with
    fonte_countryregion as (
        select *
        from {{ source('postgres', 'countryregion') }}
    )
    
    , renomeado as (
        select
            cast(countryregioncode as string) as countryregioncode
            , cast(name as string) as name
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_countryregion
    )

select *
from renomeado