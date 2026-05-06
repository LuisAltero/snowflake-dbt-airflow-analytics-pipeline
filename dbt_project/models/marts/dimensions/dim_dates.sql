with min_max_dates as (

    select
        min(order_date) as min_date,
        max(receipt_date) as max_date
    from {{ ref('int_order_items') }}

),

date_spine as (

    select
        dateadd(day, seq4(), min_date) as date_day,
        max_date
    from min_max_dates,
    table(generator(rowcount => 10000))

),

filtered_dates as (

    select
        date_day
    from date_spine
    where date_day <= max_date

),

final as (

    select
        date_day,
        year(date_day) as year,
        quarter(date_day) as quarter,
        month(date_day) as month,
        monthname(date_day) as month_name,
        day(date_day) as day_of_month,
        dayofweek(date_day) as day_of_week,
        dayname(date_day) as day_name,
        weekofyear(date_day) as week_of_year,
        case
            when dayofweek(date_day) in (0, 6) then true
            else false
        end as is_weekend
    from filtered_dates

)

select * from final