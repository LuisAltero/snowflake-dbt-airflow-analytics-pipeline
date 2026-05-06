with orders as (

    select * from {{ ref('stg_tpch_orders') }}

),

line_items as (

    select * from {{ ref('stg_tpch_line_items') }}

),

final as (

    select
        {{ generate_surrogate_key([
            'line_items.order_id',
            'line_items.line_number'
        ]) }} as order_item_sk,

        line_items.order_id,
        orders.customer_id,
        line_items.part_id,
        line_items.supplier_id,
        line_items.line_number,

        orders.order_date,
        line_items.ship_date,
        line_items.commit_date,
        line_items.receipt_date,

        orders.order_status,
        orders.order_priority,
        line_items.return_flag,
        line_items.line_status,
        line_items.ship_mode,

        line_items.quantity,
        line_items.extended_price,
        line_items.discount,
        line_items.tax,

        line_items.extended_price * (1 - line_items.discount) as gross_revenue,
        line_items.extended_price * (1 - line_items.discount) * (1 + line_items.tax) as net_revenue,

        case
            when line_items.receipt_date > line_items.commit_date then true
            else false
        end as is_late_delivery,

        datediff(day, line_items.commit_date, line_items.receipt_date) as delivery_delay_days

    from line_items
    inner join orders
        on line_items.order_id = orders.order_id

)

select * from final