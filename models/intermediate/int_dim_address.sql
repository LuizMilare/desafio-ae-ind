with
    addresses as (
        select *
        from {{ ref('stg_postgres__address') }}
    )

    , stateprovinces as (
        select *
        from {{ ref('stg_postgres__stateprovince') }}
    )

    , joined as (
        select 
            addresses.pk_addressid
            , addresses.addressline1
            , addresses.addressline2
            , addresses.city
            , addresses.postalcode
            , addresses.spatiallocation
            , stateprovinces.stateprovincecode
            , stateprovinces.countryregioncode
            , stateprovinces.stateprovince_name
        from addresses
        left join stateprovinces on addresses.fk_stateprovinceid = stateprovinces.pk_stateprovinceid
    )

select *
from joined
