--Which vehicle models require most servicing?
select v.model_name,
count(vs.service_id) as total_service
from vehicle_service vs 
join vehicles v 
using(vehicle_id)
group by 1
order by total_service desc
limit 1;

--Average service cost by model
select v.model_name,
round(avg(vc.service_cost)::numeric,1) as average
from vehicle_service vc
join vehicles v 
using(vehicle_id)
group by 1
order by average desc;


--Which dealerships have lowest satisfaction scores?
with deal as(		
select dealer_id,
satisfaction_score
from vehicle_service vs 
)
select dealer_id ,satisfaction_score from(
select*,
dense_rank() over(order by satisfaction_score) as ranking
from deal) t
where ranking=1;

--Customer retention through servicing
with retained as (
select customer_id
from vehicle_service vs 
group by 1
having count(service_id)>1
)
select 
round((count(*)::decimal/(select count(distinct customer_id)from vehicle_service ))*100,1) as retained_percentage
from retained;