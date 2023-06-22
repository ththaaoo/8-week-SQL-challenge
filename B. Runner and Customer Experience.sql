-- 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select datepart(week, registration_date) 
from runners;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select
	runner_id,
	round(avg(timestampdiff(minute, order_time, pickup_time))) as average_pickup_time
from runner_orders_temp r
	join customer_orders_temp c on r.order_id = c.order_id
group by runner_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
select 
	c.order_id,
    count(pizza_id),
    round(avg(timestampdiff(minute, order_time, pickup_time)),1) as average_pickup_time
from customer_orders_temp c
	join runner_orders_temp r on c.order_id = r.order_id
group by(c.order_id);
    
-- 4. What was the average distance travelled for each customer?
select
	customer_id,
    round(avg(distance),1) as average_distance
from customer_orders_temp c 
	join runner_orders_temp r on c.order_id = r.order_id
group by customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
select max(duration) - min(duration) as delivery_time_difference
from runner_orders_temp;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
select
	runner_id,
    order_id,
    round(distance/duration,1) as avg_speed
from runner_orders_temp
order by runner_id asc;

-- 7. What is the successful delivery percentage for each runner?
select * from runner_orders_temp;

with successful_cte as (
select 
	runner_id,
    case 
		when cancellation is null then 1
        else 0 end as cancellation_count
from runner_orders_temp)

select 
	runner_id,
    round(sum(cancellation_count) / count(*),2) as successful_percentage
from successful_cte
group by runner_id
