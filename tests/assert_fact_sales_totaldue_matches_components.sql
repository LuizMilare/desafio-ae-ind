select distinct
    fk_salesorderid
    , subtotal
    , taxamt
    , freight
    , totaldue
from {{ ref('fact_sales') }}
where abs(totaldue - (subtotal + taxamt + freight)) > 0.01
