select sum(salesorderdetailsubtotal) as sum_subtotal_2011
from {{ ref('fact_sales') }}
where orderdate between '2011-01-01' and '2011-12-31'
having sum_subtotal_2011 <> 12646112.1607