ALTER TABLE customer_orders_temp
ADD record_id INT auto_increment primary key;
SELECT *
FROM customer_orders_temp;
-- 1. What are the standard ingredients for each pizza?
CREATE temporary table recipes as
SELECT
  r.pizza_id,
  SUBSTRING_INDEX(SUBSTRING_INDEX(r.toppings, ',', n.n), ',', -1) AS topping_id
FROM
  pizza_recipes r
CROSS JOIN
  (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7) n
WHERE
  n.n <= 1 + (LENGTH(r.toppings) - LENGTH(REPLACE(r.toppings, ',', '')));

select 
	pizza_name,
    group_concat(topping_name separator ', ') as standard_toppings
from recipes r
left join pizza_names n on r.pizza_id = n.pizza_id
left join pizza_toppings t on r.topping_id = t.topping_id
group by pizza_name;
    
-- What was the most commonly added extra?
select * from customer_orders_temp;

CREATE temporary table extras as
SELECT
  c.order_id,
  c.pizza_id,
  SUBSTRING_INDEX(SUBSTRING_INDEX(c.extras, ',', n.n), ',', -1) AS extra_id
FROM
  customer_orders_temp c
CROSS JOIN
  (SELECT 1 AS n UNION ALL SELECT 2) n
WHERE
  n.n <= 1 + (LENGTH(c.extras) - LENGTH(REPLACE(c.extras, ',', '')));
  
select 
	topping_id,
    topping_name,
    count(*) as topping_count
from toppings t
left join pizza_toppings p on t.extra_id = p.topping_id
group by topping_id, topping_name;

-- What was the most common exclusion?
CREATE temporary table exclusions as
SELECT
  c.order_id,
  SUBSTRING_INDEX(SUBSTRING_INDEX(c.exclusions, ',', n.n), ',', -1) AS exclusion_id
FROM
  customer_orders_temp c
CROSS JOIN
  (SELECT 1 AS n UNION ALL SELECT 2) n
WHERE
  n.n <= 1 + (LENGTH(c.exclusions) - LENGTH(REPLACE(c.exclusions, ',', '')));

-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
select * from exclusions;

	select 
		order_id,
        concat(" - Exclude ", group_concat(topping_name separator ', '))
	from exclusions e
    left join pizza_toppings p on e.exclusion_id = p.topping_id
    group by order_id
        

-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?