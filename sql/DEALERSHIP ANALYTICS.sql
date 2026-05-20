--Which dealers generate highest revenue?
with rev as(		
select dealer_id,
round(sum(final_price),1) as total_revenue
from orders 
where order_status='Delivered'
group by 1
)
select dealer_id,dealer_name,total_revenue from(		
select d.dealer_id,d.dealer_name,r.total_revenue,
row_number() over(order by r.total_revenue desc)as ranking
from rev r
left join  dealerships d 
using(dealer_id)
) t
where ranking=1;


--Dealer-wise delivery delay analysis
with dated as(
select dealer_id,
date(order_date) as orders,
date(delivery_date) as delivery,
(date(delivery_date)-date(order_date)) as delivery_difference
from orders
where order_status='Delivered'),
avera as(		
select dealer_id,orders,
delivery,
avg(delivery_difference) as average_delivery_day
from dated 
group by 1,2,3
)
select dealer_id,
average_delivery_day
from avera
where average_delivery_day>=30
order by average_delivery_day desc; 



--Which cities have highest cancellation rates?
with total as(
select c.city,
count(case when o.order_status='Cancelled' then order_id end) as total_cancelled,
count(o.order_id) as total_orders,
round((count(case when o.order_status='Cancelled' then 1 end)::decimal/count(o.order_id))*100,1) as cancellation_percentage
from orders o
left join customers c
using(customer_id)
group by 1)
select 
city,total_cancelled ,total_orders,
cancellation_percentage from(
select *,
dense_rank() over(order by cancellation_percentage desc) as ranking
from total) t
where ranking=1;



--Dealer target achievement analysis
with total as(		
select dealer_id,
count(order_id) as total_orders
from orders 
where order_status='Delivered'
group by 1
)
select dealer_id,d.sales_target,t.total_orders,
case when t.total_orders>=d.sales_target then 'YES' else 'No' end as sales_update
from total t 
join dealerships d 
using(dealer_id)
order by t.total_orders desc;  

