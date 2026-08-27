with
    fonte_stateprovince as (
        select *
        from {{ source('postgres', 'stateprovince') }}
    )
    
    , renomeado as (
        select
            cast(stateprovinceid as int) as pk_stateprovinceid
            , cast(territoryid as int) as fk_territoryid
            , cast(stateprovincecode as string) as stateprovincecode
            , cast(countryregioncode as string) as countryregioncode
            , cast(isonlystateprovinceflag as boolean) as isonlystateprovinceflag
            , cast(name as string) as name
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_stateprovince
    )

select *
from renomeado