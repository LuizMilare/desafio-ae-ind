with
    fonte_salesorderheader as (
        select *
        from {{ source('postgres', 'salesorderheader') }}
    )
    
    , renomeado as (
        select
            cast(salesorderid as int) as pk_salesorderid            
            , cast(customerid as int) as fk_customerid
            , cast(salespersonid as int) as fk_salespersonid
            , cast(territoryid as int) as fk_territoryid
            , cast(billtoaddressid as int) as fk_billtoaddressid 
            , cast(shiptoaddressid as int) as fk_shiptoaddressid
            , cast(shipmethodid as int) as fk_shipmethodid
            , cast(creditcardid as int) as fk_creditcardid
            , cast(currencyrateid as int) as fk_currencyrateid
            , cast(revisionnumber as int) as revisionnumber
            , cast(orderdate as date) as orderdate
            , cast(duedate as date) as duedate
            , cast(shipdate as date) as shipdate
            , cast(status as int) as status
            , cast(onlineorderflag as boolean) as onlineorderflag
            , cast(purchaseordernumber as string) as purchaseordernumber 
            , cast(accountnumber as string) as accountnumber
            , cast(creditcardapprovalcode as string) as creditcardapprovalcode
            , cast(subtotal as float) as subtotal
            , cast(taxamt as float) as taxamt
            , cast(freight as float) as freight
            , cast(totaldue as float) as totaldue
            , cast(comment as string) as comment
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_salesorderheader
    )

select *
from renomeado