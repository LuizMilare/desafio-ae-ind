select
    fk_salesorderid
    , fk_salesreasonid
    , count(*) as row_count
from {{ ref('bridge_sales_order_reasons') }}
group by fk_salesorderid, fk_salesreasonid
having count(*) > 1
