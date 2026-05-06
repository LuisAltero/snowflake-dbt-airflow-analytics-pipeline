with source as (

    select *
    from {{ source('tpch', 'NATION') }}

),

renamed as (

    select
        N_NATIONKEY::number as nation_id,
        {{ clean_string('N_NAME') }} as nation_name,
        N_REGIONKEY::number as region_id,
        {{ clean_string('N_COMMENT') }} as nation_comment
    from source

)

select * from renamed