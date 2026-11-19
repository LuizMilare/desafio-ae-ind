select
    pk_salesorderdetailid
    , orderqty
    , unitprice
from {{ ref('fact_sales') }}
where orderqty <= 0
    or unitprice < 0
