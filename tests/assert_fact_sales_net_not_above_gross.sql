select
    pk_salesorderdetailid
    , salesorderdetailsubtotal
    , salesorderdetaildiscount
    , salesorderdetailnetsubtotal
from {{ ref('fact_sales') }}
where salesorderdetailnetsubtotal > salesorderdetailsubtotal
    or abs(salesorderdetailsubtotal - salesorderdetaildiscount - salesorderdetailnetsubtotal) > 0.0001
