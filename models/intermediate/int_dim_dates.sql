with
    salesorderheaders as (
        select *
        from {{ ref('stg_postgres__salesorderheader') }}
    )

    , bounds as (
        select
            make_date(year(min(salesorderheaders.orderdate)), 1, 1) as start_date
            , make_date(year(max(salesorderheaders.orderdate)), 12, 31) as end_date
        from salesorderheaders
    )

    , days as (
        select explode(sequence(bounds.start_date, bounds.end_date, interval 1 day)) as pk_date
        from bounds
    )

    , calendar as (
        select
            days.pk_date
            , year(days.pk_date) as calendar_year
            , quarter(days.pk_date) as calendar_quarter
            , month(days.pk_date) as calendar_month
            , date_format(days.pk_date, 'MMMM') as month_name
            , date_format(days.pk_date, 'yyyy-MM') as year_month
            , day(days.pk_date) as day_of_month
            , date_format(days.pk_date, 'EEEE') as weekday_name
            , dayofweek(days.pk_date) as weekday_number
        from days
    )

select *
from calendar
