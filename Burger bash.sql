use casestudy

select * from customer_orders
select * from burger_runner_orders
select * from burger_name
select * from burger_runner

-- .1 How many burgers were ordered?
select count(*) as Total_Number_of_burger from burger_runner_orders

-- 2. How many unique customer orders were made?
select count( distinct customer_id) as unique_customer_orders from customer_orders


-- 3. How many successful orders were delivered by each runner?

select runner_id , count(distinct order_id) as successful_orders from burger_runner_orders
where cancellation IS NULL  or cancellation = ''
group by runner_id

-- 4. How many of each type of burger was delivered?

select burger_name , count(*) as delivered_burger_count from burger_name b_n
inner join customer_orders co
on b_n.burger_id = co.burger_id 
inner join burger_runner_orders brn
on co.order_id = brn.order_id
where distance != 0
group by burger_name

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id,
SUM(CASE WHEN p.burger_name LIKE '%Vegetarian%' THEN 1 ELSE 0 END) AS vegetarian_orders,
SUM(CASE WHEN p.burger_name LIKE '%Meatlovers%' THEN 1 ELSE 0 END) AS meatlovers_orders
FROM customer_orders AS c
JOIN burger_name AS p 
ON c.burger_id = p.burger_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 6. What was the maximum number of burgers delivered in a single order?
WITH burger_count_cte AS
(
 SELECT c.order_id, COUNT(c.burger_id) AS burger_per_order
 FROM customer_orders AS c
 JOIN burger_runner_orders AS r
  ON c.order_id = r.order_id
 WHERE r.distance != 0
 GROUP BY c.order_id
)
SELECT MAX(burger_per_order) AS burger_count
FROM burger_count_cte;

-- 7. For each customer, how many delivered burgers had at least 1 change and how many had no changes?
SELECT c.customer_id,
 SUM(CASE 
  WHEN c.exclusions <> '' OR c.extras <> '' THEN 1
  ELSE 0
  END) AS at_least_1_change,
 SUM(CASE 
  WHEN c.exclusions = '' AND c.extras = '' THEN 1 
  ELSE 0
  END) AS no_change
FROM customer_orders AS c
JOIN burger_runner_orders AS r
 ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 8. What was the total volume of burgers ordered for each hour of the day?

SELECT EXTRACT(HOUR from order_time) AS hour_of_day, 
 COUNT(order_id) AS burger_count
FROM customer_orders
GROUP BY EXTRACT(HOUR from order_time);


-- 9. How many runners signed up for each 1 week period?

SELECT EXTRACT(WEEK from registration_date) AS registration_week,
COUNT(runner_id) AS runner_signup
FROM burger_runner
GROUP BY EXTRACT(WEEK from registration_date);

-- 10. What was the average distance travelled for each customer?
SELECT c.customer_id, AVG(r.distance) AS avg_distance
FROM customer_orders AS c
JOIN burger_runner_orders AS r
 ON c.order_id = r.order_id
WHERE r.duration != 0
GROUP BY c.customer_id;




