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
            salesorderheaders.pk_salesorderid
            , salesorderheaders.fk_territoryid
            , salesorderheaders.fk_billtoaddressid
            , salesorderheaders.fk_shiptoaddressid
            , salesorderheaders.revisionnumber
            , salesorderheaders.orderdate
            , salesorderheaders.duedate
            , salesorderheaders.shipdate
            , salesorderheaders.status
            , salesorderheaders.onlineorderflag
            , salesorderheaders.purchaseordernumber
            , salesorderheaders.accountnumber
            , salesorderheaders.creditcardapprovalcode
            , salesorderheaders.subtotal
            , salesorderheaders.taxamt
            , salesorderheaders.freight
            , salesorderheaders.totaldue
            , salesorderheaders.comment
            , salesorderdetails.fk_productid
            , salesorderdetails.fk_specialofferid
            , salesorderdetails.carriertrackingnumber
            , salesorderdetails.orderqty
            , salesorderdetails.unitprice
            , salesorderdetails.unitpricediscount
        from salesorderheaders
        left join salesorderdetails on salesorderheaders.pk_salesorderid = salesorderdetails.fk_salesorderid
    )

select *
from joined