with order_items as (

    select * from {{ ref('int_order_items') }}

),

customers as (

    select * from {{ ref('dim_customers') }}

),

final as (

    select
        order_items.order_date,
        customers.region_name,
        customers.nation_name,
        customers.market_segment,
        order_items.order_priority,

        count(distinct order_items.order_id) as total_orders,
        count(*) as total_order_items,
        count(distinct order_items.customer_id) as total_customers,

        sum(order_items.quantity) as total_quantity,
        sum(order_items.gross_revenue) as gross_revenue,
        sum(order_items.net_revenue) as net_revenue,

        avg(order_items.discount) as avg_discount,
        avg(order_items.tax) as avg_tax,

        sum(case when order_items.is_late_delivery then 1 else 0 end) as late_items,
        {{ safe_divide(
            'sum(case when order_items.is_late_delivery then 1 else 0 end)',
            'count(*)'
        ) }} as late_delivery_rate,

        current_timestamp() as loaded_at

    from order_items
    left join customers
        on order_items.customer_id = customers.customer_id

    group by
        order_items.order_date,
        customers.region_name,
        customers.nation_name,
        customers.market_segment,
        order_items.order_priority

)

select * from final

{% if is_incremental() %}
    where order_date >= (
        select coalesce(dateadd(day, -7, max(order_date)), '1900-01-01')
        from {{ this }}
    )
{% endif %}