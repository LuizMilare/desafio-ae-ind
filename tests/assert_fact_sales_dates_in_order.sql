select
    pk_salesorderdetailid
    , orderdate
    , duedate
    , shipdate
from {{ ref('fact_sales') }}
where duedate < orderdate
    or shipdate < orderdate
