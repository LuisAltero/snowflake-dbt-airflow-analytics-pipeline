with customers as (

    select * from {{ ref('stg_tpch_customers') }}

),

nations as (

    select * from {{ ref('stg_tpch_nations') }}

),

regions as (

    select * from {{ ref('stg_tpch_regions') }}

),

final as (

    select
        customers.customer_id,
        customers.customer_name,
        customers.customer_address,
        customers.customer_phone,
        customers.account_balance,
        customers.market_segment,
        nations.nation_id,
        nations.nation_name,
        regions.region_id,
        regions.region_name
    from customers
    left join nations
        on customers.nation_id = nations.nation_id
    left join regions
        on nations.region_id = regions.region_id

)

select * from final