with source as (

    select *
    from {{ source('tpch', 'PART') }}

),

renamed as (

    select
        P_PARTKEY::number as part_id,
        {{ clean_string('P_NAME') }} as part_name,
        {{ clean_string('P_MFGR') }} as manufacturer,
        {{ clean_string('P_BRAND') }} as brand,
        {{ clean_string('P_TYPE') }} as part_type,
        P_SIZE::number as part_size,
        {{ clean_string('P_CONTAINER') }} as container,
        P_RETAILPRICE::number(18,2) as retail_price,
        {{ clean_string('P_COMMENT') }} as part_comment
    from source

)

select * from renamed