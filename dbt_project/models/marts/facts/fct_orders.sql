with order_items as (

    select * from {{ ref('int_order_items') }}

),

orders as (

    select * from {{ ref('stg_tpch_orders') }}

),

aggregated as (

    select
        order_id,
        customer_id,

        min(order_date) as order_date,
        min(ship_date) as first_ship_date,
        max(receipt_date) as last_receipt_date,

        count(*) as total_items,
        sum(quantity) as total_quantity,
        sum(gross_revenue) as gross_revenue,
        sum(net_revenue) as net_revenue,

        avg(discount) as avg_discount,
        avg(tax) as avg_tax,

        max(case when is_late_delivery then 1 else 0 end)::boolean as has_late_delivery,
        max(delivery_delay_days) as max_delivery_delay_days

    from order_items
    group by
        order_id,
        customer_id

),

final as (

    select
        aggregated.order_id,
        aggregated.customer_id,

        orders.order_status,
        orders.order_priority,
        orders.clerk,

        aggregated.order_date,
        aggregated.first_ship_date,
        aggregated.last_receipt_date,

        aggregated.total_items,
        aggregated.total_quantity,
        aggregated.gross_revenue,
        aggregated.net_revenue,
        aggregated.avg_discount,
        aggregated.avg_tax,

        {{ safe_divide('aggregated.net_revenue', 'aggregated.total_items') }} as avg_revenue_per_item,

        aggregated.has_late_delivery,
        aggregated.max_delivery_delay_days,

        current_timestamp() as loaded_at

    from aggregated
    left join orders
        on aggregated.order_id = orders.order_id

)

select * from final

{% if is_incremental() %}
    where order_date >= (
        select coalesce(dateadd(day, -7, max(order_date)), '1900-01-01')
        from {{ this }}
    )
{% endif %}