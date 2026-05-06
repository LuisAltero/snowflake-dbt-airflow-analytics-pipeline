with suppliers as (

    select * from {{ ref('stg_tpch_suppliers') }}

),

nations as (

    select * from {{ ref('stg_tpch_nations') }}

),

regions as (

    select * from {{ ref('stg_tpch_regions') }}

),

final as (

    select
        suppliers.supplier_id,
        suppliers.supplier_name,
        suppliers.supplier_address,
        suppliers.supplier_phone,
        suppliers.account_balance,
        nations.nation_id,
        nations.nation_name,
        regions.region_id,
        regions.region_name
    from suppliers
    left join nations
        on suppliers.nation_id = nations.nation_id
    left join regions
        on nations.region_id = regions.region_id

)

select * from final