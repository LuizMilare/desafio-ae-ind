with
    addresses as (
        select *
        from {{ ref('stg_postgres__address') }}
    )

    , stateprovinces as (
        select *
        from {{ ref('stg_postgres__stateprovince') }}
    )

    , countryregions as (
        select *
        from {{ ref('stg_postgres__countryregion') }}
    )

    , joined as (
        select
            addresses.pk_addressid
            , addresses.city
            , stateprovinces.stateprovincecode
            , stateprovinces.countryregioncode
            , stateprovinces.stateprovince_name
            , countryregions.name as countryregion_name
        from addresses
        left join stateprovinces on addresses.fk_stateprovinceid = stateprovinces.pk_stateprovinceid
        left join countryregions on stateprovinces.countryregioncode = countryregions.countryregioncode
    )

select *
from joined
