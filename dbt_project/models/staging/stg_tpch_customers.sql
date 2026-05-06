with source as (

    select *
    from {{ source('tpch', 'CUSTOMER') }}

),

renamed as (

    select
        C_CUSTKEY::number as customer_id,
        {{ clean_string('C_NAME') }} as customer_name,
        {{ clean_string('C_ADDRESS') }} as customer_address,
        C_NATIONKEY::number as nation_id,
        {{ clean_string('C_PHONE') }} as customer_phone,
        C_ACCTBAL::number(18,2) as account_balance,
        {{ clean_string('C_MKTSEGMENT') }} as market_segment,
        {{ clean_string('C_COMMENT') }} as customer_comment
    from source

)

select * from renamed