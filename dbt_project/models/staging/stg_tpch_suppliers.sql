with source as (

    select *
    from {{ source('tpch', 'SUPPLIER') }}

),

renamed as (

    select
        S_SUPPKEY::number as supplier_id,
        {{ clean_string('S_NAME') }} as supplier_name,
        {{ clean_string('S_ADDRESS') }} as supplier_address,
        S_NATIONKEY::number as nation_id,
        {{ clean_string('S_PHONE') }} as supplier_phone,
        S_ACCTBAL::number(18,2) as account_balance,
        {{ clean_string('S_COMMENT') }} as supplier_comment
    from source

)

select * from renamed