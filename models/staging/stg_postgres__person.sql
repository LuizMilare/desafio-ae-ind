with
    fonte_person as (
        select *
        from {{ source('postgres', 'person') }}
    )

    , renomeado as (
        select
            cast(businessentityid as int) as pk_businessentityid
            , cast(persontype as string) as persontype
            , cast(title as string) as title
            , cast(firstname as string) as firstname
            , cast(middlename as string) as middlename
            , cast(lastname as string) as lastname
            , cast(suffix as string) as suffix
            , cast(emailpromotion as int) as emailpromotion
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_person
    )

select *
from renomeado
