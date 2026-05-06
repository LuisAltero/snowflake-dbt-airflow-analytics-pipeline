with source as (

    select *
    from {{ source('tpch', 'ORDERS') }}

),

renamed as (

    select
        O_ORDERKEY::number as order_id,
        O_CUSTKEY::number as customer_id,
        {{ clean_string('O_ORDERSTATUS') }} as order_status,
        O_TOTALPRICE::number(18,2) as total_price,
        O_ORDERDATE::date as order_date,
        {{ clean_string('O_ORDERPRIORITY') }} as order_priority,
        {{ clean_string('O_CLERK') }} as clerk,
        O_SHIPPRIORITY::number as ship_priority,
        {{ clean_string('O_COMMENT') }} as order_comment
    from source

)

select * from renamed