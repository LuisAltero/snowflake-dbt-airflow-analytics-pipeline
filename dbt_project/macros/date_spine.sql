{% macro date_spine(start_date, end_date) %}

with date_spine as (

    select
        dateadd(day, seq4(), {{ start_date }}) as date_day
    from table(generator(rowcount => 10000))

),

filtered as (

    select *
    from date_spine
    where date_day <= {{ end_date }}

)

select * from filtered

{% endmacro %}