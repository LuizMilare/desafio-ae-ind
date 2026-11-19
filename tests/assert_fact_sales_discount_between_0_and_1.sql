select
    pk_salesorderdetailid
    , unitpricediscount
from {{ ref('fact_sales') }}
where unitpricediscount < 0
    or unitpricediscount > 1
