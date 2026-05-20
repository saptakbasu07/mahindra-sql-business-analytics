--Monthly growth rate
--(2025)
with revenue as(
select 
extract('month'from order_date) as month_2025,
sum(final_price) as total_revenue_month_2025
from orders 
where order_status='Delivered' and extract('Year' from order_date)=2025
group by 1
)
select 
month_2025,
total_revenue_month_2025,
lag(total_revenue_month_2025) over(order by month_2025 ) as previous_month_revenue_2025,
round((total_revenue_month_2025-lag(total_revenue_month_2025) over(order by month_2025 ))::decimal/lag(total_revenue_month_2025) over(order by month_2025)*100,1)
as monthly_percentage_difference_2025
from revenue;


--Top 3 vehicles per state
with revenue as(
select c.state,
v.model_name,
round(sum(o.final_price)::numeric,1) as total_revenue
from orders o 
join customers c 
using(customer_id)
join vehicles v 
using(vehicle_id)
where o.order_status='Delivered'
group by 1,2
)
select*from(
select*,
dense_rank() over(partition by state order by total_revenue desc) as ranking
from revenue) t
where ranking<=3;


--Cohort retention analysis
--monthly
with cohort as(		
select customer_id,
min(order_date) as first_purchase,
date_trunc('month',min(order_date )) as cohort_month
from orders
where order_status='Delivered' and extract('YEAR' from order_date)= 2024
group by 1
),
dated as(
select 
c.customer_id,
c.first_purchase,
c.cohort_month,
o.order_date,
(
            EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', o.order_date),
                                  c.cohort_month)) * 12
            +
            EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', o.order_date),
                                   c.cohort_month))
        ) AS months_since_cohort
from orders o 
join cohort c
using(customer_id)
)
select to_char(cohort_month,'MM-YYYY') as COHORT_MONTH,
months_since_cohort,
count(distinct customer_id) as retained_customer
from dated
where months_since_cohort>0
group by 1,2
order by 1,2
;


--Running cumulative revenue
select 
extract('month'from order_date)as month,
sum(final_price) as total_revenue,
sum(sum(final_price)) over (order by extract('month'from order_date)) as cumulative_revenue
from orders 
group by 1;


--Contribution analysis
--KPI
--Revenue Contribution %
--
--Example:
--
--Which 20% models drive 80% revenue?
with total as(
select vehicle_id,
sum(final_price) as revenue,
round(
(sum(final_Price))*100/
(select  
sum(final_price) as total_revenue
from orders 
where order_status ='Delivered'),2) as vehicle_contribution_percentage
from orders 
where order_status='Delivered'
group by 1
order by revenue desc),
cumulative as(
select 
revenue,
vehicle_contribution_percentage,
sum(revenue) over(order by revenue desc) as running_total,
round(sum(revenue) over(order by revenue desc)*100/(sum(revenue) over()),2) as revenue_percentage
from total)
select vehicle_contribution_percentage,revenue,running_total ,revenue_percentage 
from cumulative
where revenue_percentage<=80
order by revenue desc;


--EV adoption growth analysis
with rev as(	
select 
extract('Year' from o.order_date) as year,
count(o.order_id) as total_yearly_sales_this
from orders o
join vehicles v 
using(vehicle_id)
where o.order_status='Delivered' and v.vehicle_category='EV'
group by 1
order by 1
)
select year,
total_yearly_sales_this,
nullif(lag(total_yearly_sales_this) over(order by year),0) as ev_sales_previous_year,
round((total_yearly_sales_this-lag(total_yearly_sales_this) over(order by year))::decimal
/nullif(lag(total_yearly_sales_this) over(order by year),0)*100,1) as growth_percentage_of_ev
from rev;


