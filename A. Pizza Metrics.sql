-- 1. How many pizzas were ordered?
select 
	count(*) as total_ordered_pizzas
from customer_orders_temp;

-- 2. How many unique customer orders were made?
select count(distinct customer_id) as total_unique_orders
from customer_orders_temp;

-- 3. How many successful orders were delivered by each runner?
select 
	runner_id,
    count(*)
from runner_orders_temp
where cancellation is null
group by runner_id;

-- 4. How many of each type of pizza was delivered?
select
	pizza_name,
    count(c.order_id) as total_delivered
from customer_orders_temp c
	join pizza_names p on c.pizza_id = p.pizza_id
    join runner_orders_temp r on c.order_id = r.order_id
where cancellation is null
group by pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
select
	customer_id,
	pizza_name,
    count(c.order_id) as total_delivered
from customer_orders_temp c
	join pizza_names p on c.pizza_id = p.pizza_id
group by pizza_name, customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
select 
	c.order_id,
    count(pizza_id) as pizzas_delivered
from customer_orders_temp c
    join runner_orders_temp r on c.order_id = r.order_id
where cancellation is null
group by order_id 
order by count(pizza_id) desc
limit 1;
    
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

with change_cte as(
	select
		customer_id,
        order_id,
        case 
			when exclusions is null and extras is null then 'Yes'
            else 'No' end as changes
	from customer_orders_temp)

select 
	customer_id,
    changes,
    count(c.order_id) as total_delivered_pizzas
from change_cte c
	join runner_orders r on c.order_id = r.order_id
where cancellation is null
group by customer_id, changes;

-- 8. How many pizzas were delivered that had both exclusions and extras?
select 
	count(c.order_id) as delivered_pizzas_with_both_changes
from customer_orders_temp c
	join runner_orders r on c.order_id = r.order_id
where 
	exclusions is not null and extras is not null
    and cancellation is not null;
    
-- 9. What was the total volume of pizzas ordered for each hour of the day?
select * from runner_orders;
select * from customer_orders_temp;
select * from pizza_names;

select 
	hour(order_time) as hour_of_day,
    count(order_id) as total_pizzas_ordered
from customer_orders_temp
group by hour(order_time)
order by hour(order_time) asc;

-- What was the volume of orders for each day of the week?
