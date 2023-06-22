-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner
-- How would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

create table ratings (
order_id integer,
order_rating integer);

insert into 
	ratings (order_id, order_rating)
value 
(1, 5),
(2, 4),
(3, 4);

select * from ratings

    