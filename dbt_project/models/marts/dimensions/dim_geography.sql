with nations as (

    select * from {{ ref('stg_tpch_nations') }}

),

regions as (

    select * from {{ ref('stg_tpch_regions') }}

),

final as (

    select
        nations.nation_id,
        nations.nation_name,
        regions.region_id,
        regions.region_name
    from nations
    left join regions
        on nations.region_id = regions.region_id

)

select * from final