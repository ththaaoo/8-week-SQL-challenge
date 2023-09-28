# Solutions

### 1. How many customers has Foodie-Fi ever had?

### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
#### SQL query
```sql
select 
	date_trunc('month', start_date)::date as start_month,
	count(plan_id)
from subscriptions
where plan_id = 0
group by start_month
```
#### Result
<img src=https://github.com/ththaaoo/8-week-SQL-challenge/assets/130723296/c1394dec-b9bf-41c4-8bc3-0a72045b9716 width="300">

### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.
#### SQL query
```sql
select 
	plan_name,
	count(*) as count_after_2020
from subscriptions s
	join plans p on s.plan_id = p.plan_id
where extract('year' from start_date) > 2020
group by plan_name
```
#### Result
<img src=https://github.com/ththaaoo/8-week-SQL-challenge/assets/130723296/3a962edc-0cd1-47a1-a115-d518d9b0c7b2 width="350">

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
#### SQL query
```sql
select
	count(distinct customer_id),
	sum(case when plan_id = 4 then 1 else 0 end) as churn_count,
	round(cast(sum(case when plan_id = 4 then 1 else 0 end) as numeric)/
			   count(distinct customer_id)*100,1) as churn_percentage
from subscriptions
```
#### Result
<img src=https://github.com/ththaaoo/8-week-SQL-challenge/assets/130723296/a467b2bf-a79b-4d6c-a892-c230f4339656 width="400">

### 5. How many customers have churned straight after their initial free trial? What percentage is this rounded to the nearest whole number?
#### SQL query
```sql
with churn_cte as(
	select
		*,
		lead(plan_id,1) over(partition by customer_id order by start_date asc) as next_plan_id
	from subscriptions)

select
	count(distinct customer_id) as straight_churn_count,
	(cast(count(distinct customer_id) as float) / 
		(select count(distinct customer_id) from subscriptions)) * 100 as straight_churn_rate
from churn_cte
where plan_id = 0 and next_plan_id = 4
```
#### Result
<img src=https://github.com/ththaaoo/8-week-SQL-challenge/assets/130723296/62f2aac0-f733-4d65-8165-7efabb0776de width="400">

### 6. What is the number and percentage of customer plans after their initial free trial?
#### SQL query
```sql
with churn_cte as(
	select
		*,
		lead(plan_id,1) over(partition by customer_id order by start_date asc) as next_plan_id
	from subscriptions)
	
select 
	next_plan_id,
	count(next_plan_id) as next_plan_count,
	round((count(next_plan_id)::numeric/
		(select count(distinct customer_id)::numeric from subscriptions) * 100),1) as next_plan_percentage
from churn_cte
where plan_id = 0 
group by next_plan_id
```
#### Result
<img src=https://github.com/ththaaoo/8-week-SQL-challenge/assets/130723296/25e2a2a8-b55e-4259-97ed-46f9d3096850 width="400">

### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
#### SQL query
```sql
with churn_cte as(
	select
		*,
		lead(plan_id,1) over(partition by customer_id order by start_date asc) as next_plan_id
	from subscriptions
	where start_date <= '2020-12-31' )

select 
	plan_name,
	count(distinct customer_id) as plan_count,
	round(count(c.plan_id)::numeric/
		(select count(distinct customer_id)::numeric from subscriptions) * 100,1) as plan_percentage
from churn_cte c
	join plans p on c.plan_id = p.plan_id
where next_plan_id is null
group by plan_name
```
#### Result
<img src=https://github.com/ththaaoo/8-week-SQL-challenge/assets/130723296/c378ac26-7b98-48eb-a214-785e0f8c814d width="400">

### 8. How many customers have upgraded to an annual plan in 2020?
#### SQL query
```sql
select 
	count(distinct customer_id) as annual_plan_count_2020
from subscriptions
where plan_id = 3 and extract(year from start_date) = '2020'
```
#### Result
<img src=https://github.com/ththaaoo/8-week-SQL-challenge/assets/130723296/2223802b-7ec7-4e32-a7a4-63accec8dee8 width="300">

### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
#### SQL query
```sql
with trial_cte as (
	select 
		customer_id,
		start_date as trial_date
	from subscriptions
	where plan_id = 0),
	
annual_cte as (
	select 
		customer_id,
		start_date as annual_date
	from subscriptions
	where plan_id = 3)

select 
	round(avg(annual_date - trial_date),1) as average_switching_days
from annual_cte a
	join trial_cte t on a.customer_id = t.customer_id
```
#### Result
<img src=https://github.com/ththaaoo/8-week-SQL-challenge/assets/130723296/4d89d2f5-edba-4fb2-83d7-27c62b998b11 width="300">
