select
    customer_id,
    customer_name,
    customer_address,
    customer_phone,
    account_balance,
    market_segment,
    nation_id,
    nation_name,
    region_id,
    region_name
from {{ ref('int_customer_enriched') }}