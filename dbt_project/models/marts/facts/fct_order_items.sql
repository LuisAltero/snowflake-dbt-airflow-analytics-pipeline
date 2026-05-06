with order_items as (

    select * from {{ ref('int_order_items') }}

)

select
    order_item_sk,
    order_id,
    customer_id,
    part_id,
    supplier_id,
    line_number,

    order_date,
    ship_date,
    commit_date,
    receipt_date,

    order_status,
    order_priority,
    return_flag,
    line_status,
    ship_mode,

    quantity,
    extended_price,
    discount,
    tax,
    gross_revenue,
    net_revenue,

    is_late_delivery,
    delivery_delay_days,

    current_timestamp() as loaded_at

from order_items

{% if is_incremental() %}
    where order_date >= (
        select coalesce(dateadd(day, -7, max(order_date)), '1900-01-01')
        from {{ this }}
    )
{% endif %}