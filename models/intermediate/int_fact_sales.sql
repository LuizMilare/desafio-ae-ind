with
    salesorderheaders as (
        select *
        from {{ ref('stg_postgres__salesorderheader') }}
    )

    , salesorderdetails as (
        select *
        from {{ ref('stg_postgres__salesorderdetail') }}
    )

    , joined as (
        select
            salesorderheaders.pk_salesorderid as fk_salesorderid
            , salesorderdetails.pk_salesorderdetailid
            , salesorderheaders.fk_customerid
            , salesorderheaders.fk_creditcardid
            , salesorderheaders.fk_territoryid
            , salesorderheaders.fk_billtoaddressid
            , salesorderheaders.fk_shiptoaddressid
            , salesorderdetails.fk_productid
            , salesorderheaders.revisionnumber
            , salesorderheaders.orderdate
            , salesorderheaders.duedate
            , salesorderheaders.shipdate
            , salesorderheaders.status
            , salesorderheaders.onlineorderflag
            , salesorderheaders.purchaseordernumber
            , salesorderheaders.subtotal
            , salesorderheaders.taxamt
            , salesorderheaders.freight
            , salesorderheaders.totaldue
            , salesorderheaders.comment
            , salesorderdetails.orderqty
            , salesorderdetails.unitprice
            , salesorderdetails.unitpricediscount
            , salesorderdetails.orderqty * salesorderdetails.unitprice as salesorderdetailsubtotal
            , salesorderdetails.orderqty * salesorderdetails.unitprice * salesorderdetails.unitpricediscount as salesorderdetaildiscount
            , salesorderdetails.orderqty * salesorderdetails.unitprice * (1 - salesorderdetails.unitpricediscount) as salesorderdetailnetsubtotal
        from salesorderheaders
        left join salesorderdetails on salesorderheaders.pk_salesorderid = salesorderdetails.fk_salesorderid
    )

select *
from joined