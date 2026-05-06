with source as (

    select *
    from {{ source('tpch', 'LINEITEM') }}

),

renamed as (

    select
        L_ORDERKEY::number as order_id,
        L_PARTKEY::number as part_id,
        L_SUPPKEY::number as supplier_id,
        L_LINENUMBER::number as line_number,
        L_QUANTITY::number(18,2) as quantity,
        L_EXTENDEDPRICE::number(18,2) as extended_price,
        L_DISCOUNT::number(18,4) as discount,
        L_TAX::number(18,4) as tax,
        {{ clean_string('L_RETURNFLAG') }} as return_flag,
        {{ clean_string('L_LINESTATUS') }} as line_status,
        L_SHIPDATE::date as ship_date,
        L_COMMITDATE::date as commit_date,
        L_RECEIPTDATE::date as receipt_date,
        {{ clean_string('L_SHIPINSTRUCT') }} as ship_instructions,
        {{ clean_string('L_SHIPMODE') }} as ship_mode,
        {{ clean_string('L_COMMENT') }} as line_comment
    from source

)

select * from renamed