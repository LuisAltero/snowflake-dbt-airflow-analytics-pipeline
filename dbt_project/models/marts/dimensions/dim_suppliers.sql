select
    supplier_id,
    supplier_name,
    supplier_address,
    supplier_phone,
    account_balance,
    nation_id,
    nation_name,
    region_id,
    region_name
from {{ ref('int_supplier_enriched') }}