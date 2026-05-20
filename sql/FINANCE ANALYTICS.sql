--Financing penetration analysis
--Business Problem
--
--How many customers use loans?
select 
count(case when payment_type='Loan' then order_id end ) as loan_payment_count,
count(*) as total_orders,
round(
(count(case when payment_type='Loan' then order_id end )::decimal/count(*)
)
*100,2
) as loan_payment_percenatge
from orders 
where order_status='Delivered' ;


--Loan default analysis
select 
count(case when default_flag=1 then 1 end ) as loan_default_count,
count(loan_id ) as total_loan_count,
round((count(case when default_flag=1 then 1 end)::decimal/count(loan_id))*100,1) as loan_default_percentage
from financing;

--Average EMI by vehicle category
SELECT 
   v.vehicle_category,
    ROUND(AVG(f.emi_amount)::numeric, 0) AS average_emi
FROM orders o
JOIN financing f USING(order_id)
JOIN vehicles v USING(vehicle_id)
WHERE o.order_status = 'Delivered'
  AND f.loan_status = 'Active'
GROUP BY v.vehicle_category
ORDER BY average_emi DESC;


--Which vehicle categories have highest loan dependency?
select v.vehicle_category,
round((sum(f.loan_amount)::decimal/sum(o.final_price))*100,1) as loan_dependency_percentage
from orders o
join financing f 
using(order_id)
join vehicles v 
using(vehicle_id)
where o.order_status='Delivered'
group by 1
order by loan_dependency_percentage desc;


