--What is the total business revenue?
select 
round(sum(final_price),0) as total_business_revenue
from orders
where order_status='Delivered';

--How many vehicles were sold?
select 
COUNT(order_id) as total_vehicle_sold
from orders 
where order_status='Delivered';

--Which vehicle models generate the highest revenue?
with reb as(		
select vehicle_id ,
round(sum(final_price),0) as total_revenue
from orders
where order_status='Delivered'
group by 1
)
select model_name,total_revenue from( 
select 
v.model_name,
r.total_revenue,
dense_rank() over(order by r.total_revenue desc) as ranking
from vehicles v 
join reb r
using(vehicle_id)) t
where t.ranking=1;

--Which vehicle category sells the most?
with reb as(		
select vehicle_id ,
round(sum(final_price),0) as total_revenue
from orders
where order_status='Delivered'
group by 1
)
select vehicle_category,total_revenue from( 
select 
v.vehicle_category,
r.total_revenue,
dense_rank() over(order by r.total_revenue desc) as ranking
from vehicles v 
join reb r
using(vehicle_id)) t
where t.ranking=1;

--Monthly revenue trend analysis
with rev as( 
select 
date_trunc('month',order_date) as month,
round(sum(final_price),0) as total_revenue_month
from orders 
group by 1
)
select  
to_char(month,'MM-YYYY') as monthly,
total_revenue_month,
lag(total_revenue_month ) over(order by  to_char(month,'MM-YYYY')) as previous_month_revenue,
(total_revenue_month -lag(total_revenue_month ) over(order by  to_char(month,'MM-YYYY'))) as difference,
round((total_revenue_month -lag(total_revenue_month ) over(order by  to_char(month,'MM-YYYY')))/(lag(total_revenue_month ) over(order by  to_char(month,'MM-YYYY')))*100.0,1)as monthly_difference_percentage
from rev;

--Which states generate the highest revenue?
with reb as(		
select c.state ,
round(sum(o.final_price),0) as total_revenue
from orders o
join customers c
using(customer_id)
where order_status='Delivered'
group by 1
)
select state,total_revenue from(
select state,
total_revenue,
dense_rank() over(order by total_revenue desc) as ranking
from reb) t
where ranking=1;