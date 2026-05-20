--What is the average customer age by vehicle category?
with av as(		
select v.vehicle_category,
round(avg(c.age),0) as average_age
from orders o
join customers c
using (customer_id)
join vehicles v 
using(vehicle_id)
where o.order_status='Delivered'
group by 1
)
select*from av;

--Which income groups buy premium vehicles?
select  
c.income_group,
v.segment,
count(o.order_id) as total_count
from orders o 
join customers c  
using(customer_id)
join vehicles v 
using(vehicle_id)
where v.segment='Premium'  and o.order_status='Delivered'
group by 1,2
order by total_count desc 
limit 1;

--Repeat customer analysis 
select count(*) from(
select 
customer_id as repeated_customer_id
from orders 
where order_status='Delivered'
group by 1
having count(order_id)>1) t
;


--Customer Lifetime Value (CLV) (High Value Customer)
with reb as(		
select customer_id ,
round(sum(final_price),0) as total_revenue
from orders
where order_status='Delivered'
group by 1
)
select customer_id,customer_name,city ,total_revenue from(
select c.customer_id,c.customer_name,c.city,
r.total_revenue,
dense_rank() over(order by total_revenue desc) as ranking
from reb r 
join customers c
using(customer_id) ) t
where ranking<=10;

--Urban vs Rural customer analysis
select 
c.customer_type,
count(o.order_id) as count_orders,
sum(o.final_price) as total_revenue
from customers  c
join orders o
using(customer_id) 
where o.order_status='Delivered'
and c.customer_type in('Rural','Urban')
group by 1;