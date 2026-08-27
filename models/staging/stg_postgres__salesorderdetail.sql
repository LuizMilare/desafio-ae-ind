with
    fonte_salesorderdetail as (
        select *
        from {{ source('postgres', 'salesorderdetail') }}
    )
    
    , renomeado as (
        select
            cast(salesorderdetailid as int) as pk_salesorderdetailid
            , cast(salesorderid as int) as fk_salesorderid
            , cast(productid as int) as fk_productid
            , cast(specialofferid as int) as fk_specialofferid
            , cast(carriertrackingnumber as string) as carriertrackingnumber
            , cast(orderqty as int) as orderqty
            , cast(unitprice as float) as unitprice
            , cast(unitpricediscount as float) as unitpricediscount
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_salesorderdetail
    )

select *
from renomeado