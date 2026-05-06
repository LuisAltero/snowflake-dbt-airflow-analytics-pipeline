with source as (

    select *
    from {{ source('tpch', 'REGION') }}

),

renamed as (

    select
        R_REGIONKEY::number as region_id,
        {{ clean_string('R_NAME') }} as region_name,
        {{ clean_string('R_COMMENT') }} as region_comment
    from source

)

select * from renamed