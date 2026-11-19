with
    customers as (
        select *
        from {{ ref('stg_postgres__customer') }}
    )

    , persons as (
        select *
        from {{ ref('stg_postgres__person') }}
    )

    , stores as (
        select *
        from {{ ref('stg_postgres__store') }}
    )

    , joined as (
        select
            customers.pk_customerid
            , case
                when stores.pk_businessentityid is not null then 'Store'
                else 'Individual'
            end as customer_type
            , coalesce(
                stores.store_name
                , trim(concat_ws(' ', persons.firstname, persons.lastname))
            ) as customer_name
            , persons.firstname
            , persons.lastname
            , stores.store_name
        from customers
        left join persons on customers.fk_personid = persons.pk_businessentityid
        left join stores on customers.fk_storeid = stores.pk_businessentityid
    )

select *
from joined
