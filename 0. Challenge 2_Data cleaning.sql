create temporary table customer_orders_temp as
SELECT 
	order_id, 
    customer_id,
    pizza_id, 
	CASE WHEN exclusions = '' OR exclusions = 'null' THEN NULL
		ELSE exclusions END AS exclusions,
	CASE WHEN extras = '' OR extras = 'null' or extras = 'NaN' THEN NULL
		ELSE extras END AS extras, 
    order_time
FROM customer_orders;

create temporary table runner_orders_temp as
SELECT
	order_id, 
	runner_id,
	CASE 
          WHEN pickup_time = 'null' THEN NULL
          ELSE pickup_time END AS pickup_time,
	CASE 
          WHEN distance = 'null' THEN NULL
          ELSE CAST(regexp_replace(distance, '[a-z]', '') AS FLOAT) 
	END AS distance,
	CASE 
          WHEN duration = 'null' THEN NULL 
          ELSE cast(regexp_replace(duration, '[a-z]', '') as float) END AS duration,
	CASE 
		WHEN cancellation = 'null' or cancellation = '' or cancellation = 'NaN' THEN NULL
          ELSE cancellation END AS cancellation
from runner_orders;

-- Check data types
SELECT
	column_name,
    DATA_TYPE from INFORMATION_SCHEMA.COLUMNS 
where
	table_schema = 'pizza_runner' and table_name = 'pizza_recipes';
    
-- Change data types
alter table runner_orders_temp
modify column pickup_time datetime,
modify column cancellation text;

alter table pizza_recipes
modify toppings varchar(255);
