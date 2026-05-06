with partsupp as (

    select
        PS_PARTKEY::number as part_id,
        PS_SUPPKEY::number as supplier_id,
        PS_AVAILQTY::number as available_quantity,
        PS_SUPPLYCOST::number(18,2) as supply_cost,
        PS_COMMENT::varchar as part_supplier_comment
    from {{ source('tpch', 'PARTSUPP') }}

),

parts as (

    select * from {{ ref('stg_tpch_parts') }}

),

suppliers as (

    select * from {{ ref('int_supplier_enriched') }}

),

final as (

    select
        {{ generate_surrogate_key([
            'partsupp.part_id',
            'partsupp.supplier_id'
        ]) }} as part_supplier_sk,

        partsupp.part_id,
        partsupp.supplier_id,
        parts.part_name,
        parts.brand,
        parts.manufacturer,
        parts.part_type,
        parts.retail_price,
        partsupp.available_quantity,
        partsupp.supply_cost,
        suppliers.supplier_name,
        suppliers.nation_name as supplier_nation,
        suppliers.region_name as supplier_region
    from partsupp
    left join parts
        on partsupp.part_id = parts.part_id
    left join suppliers
        on partsupp.supplier_id = suppliers.supplier_id

)

select * from final