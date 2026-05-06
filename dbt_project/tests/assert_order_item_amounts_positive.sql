select *
from {{ ref('fct_order_items') }}
where
    quantity < 0
    or extended_price < 0
    or gross_revenue < 0
    or net_revenue < 0