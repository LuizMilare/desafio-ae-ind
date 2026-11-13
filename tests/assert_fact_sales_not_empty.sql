select count(*) as row_count
from {{ ref('fact_sales') }}
having count(*) = 0
