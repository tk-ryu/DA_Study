--문제1번) dvd 대여를 제일 많이한 고객 이름은? (analytic funtion 활용)

-- 방법 1
SELECT first_name || ' ' || last_name AS "name", count(rental_id), rank() OVER (ORDER BY count(rental_id) DESC)
FROM customer c 
LEFT JOIN rental r USING (customer_id)
GROUP BY customer_id, first_name , last_name 
ORDER BY "rank"
LIMIT 1

-- 방법 2
SELECT first_name || ' ' || last_name AS "name" , "count", "rank"
FROM customer c 
LEFT JOIN (
	SELECT customer_id, count(rental_id), RANK() OVER (ORDER BY count(rental_id) DESC)
	FROM rental r 
	GROUP BY customer_id
	) AS rank_by_rental 
	USING (customer_id)
ORDER BY "rank"
LIMIT 1

-- 방법 3 (rank 활용 없이)
SELECT first_name || ' ' || last_name AS "name", count(rental_id)
FROM customer c 
LEFT JOIN rental r USING (customer_id)
GROUP BY customer_id, first_name , last_name 
ORDER BY "count" DESC 
LIMIT 1

-- row_number vs rank 비교
--row_number : 순위 중복 안됨
SELECT customer_id, count(rental_id), row_number() OVER (ORDER BY count(rental_id) DESC)
FROM rental r 
GROUP BY customer_id

-- rank : 순위 중복 가능
SELECT customer_id, count(rental_id), RANK() OVER (ORDER BY count(rental_id) DESC)
FROM rental r 
GROUP BY customer_id 



--문제2번) 매출을 가장 많이 올린 dvd 고객 이름은? (analytic funtion 활용)
SELECT first_name || ' ' || last_name AS "name", sum(amount), rank() OVER (ORDER BY sum(amount) DESC)
FROM customer c 
LEFT JOIN payment p USING (customer_id)
GROUP BY customer_id, first_name , last_name 
ORDER BY "rank"
LIMIT 1

--문제3번) dvd 대여가 가장 적은 도시는? (anlytic funtion)

SELECT city, count(r.rental_id), RANK() OVER (ORDER BY count(rental_id) ASC)
FROM city c 
LEFT JOIN address a USING (city_id)
LEFT JOIN customer c2 USING (address_id)
LEFT JOIN rental r USING (customer_id)
GROUP BY city 


--문제4번) 매출이 가장 안나오는 도시는? (anlytic funtion)
-- sum 함수는 null값이 있는 경우 null로 처리하게 되니, coalesce를 활용해 0으로 바꿔줄 것
SELECT city, COALESCE(sum(amount), 0), RANK() OVER (ORDER BY COALESCE(sum(amount), 0) ASC)
FROM city c 
LEFT JOIN address a USING (city_id)
LEFT JOIN customer c2 USING (address_id)
LEFT JOIN payment p USING (customer_id)
GROUP BY city 


--문제5번) 월별 매출액을 구하고 이전 월보다 매출액이 줄어든 월을 구하세요. (일자는 payment_date 기준)
WITH tmp as(
	SELECT EXTRACT(YEAR FROM payment_date) AS "Year"
		, EXTRACT(month FROM payment_date) AS "Month"
		, sum(amount)
		, lag(sum(amount)) over (order by extract(month from payment_date)) AS "Previous_Month"
	    , sum(amount) - lag(sum(amount)) over (order by extract(month from payment_date)) AS "Gap"
	FROM payment p 
	GROUP BY EXTRACT(YEAR FROM payment_date), EXTRACT(month FROM payment_date)
	ORDER BY "Month"
)
SELECT *
FROM tmp AS t
WHERE "Gap" < 0


--문제6번) 도시별 dvd 대여 매출 순위를 구하세요.
SELECT city, COALESCE(sum(amount), 0) AS amount, RANK() OVER (ORDER BY COALESCE(sum(amount), 0) DESC)
FROM city c 
	LEFT JOIN address a USING (city_id)
	LEFT JOIN customer c2 USING (address_id)
	LEFT JOIN payment p USING (customer_id)
GROUP BY city  


--문제7번) 대여점별 매출 순위를 구하세요.
SELECT store_id, COALESCE(sum(amount), 0) AS amount, RANK() OVER (ORDER BY COALESCE(sum(amount), 0) DESC)
FROM store s 
LEFT JOIN customer c2 USING (store_id)
LEFT JOIN payment p USING (customer_id)
GROUP BY store_id

--문제8번) 나라별로 가장 대여를 많이한 고객 TOP 5를 구하세요.
WITH tmp AS (
	SELECT country , customer_id, sum(amount), rank() OVER (PARTITION BY country ORDER BY COALESCE (sum(amount), 0) DESC)
	FROM country c 
	LEFT JOIN city c2 USING (country_id)
	LEFT JOIN address a USING (city_id)
	LEFT JOIN customer c3 USING (address_id)
	LEFT JOIN payment p USING (customer_id)
	GROUP BY country , customer_id
	)
SELECT *
FROM tmp
WHERE RANK <= 5


--문제9번) 영화 카테고리 (Category) 별로 대여가 가장 많이 된 영화 TOP 5를 구하세요
WITH tmp AS (
	SELECT "name" , title, count(rental_id), rank() OVER (PARTITION BY "name" ORDER BY count(rental_id) DESC)
	FROM category c 
	LEFT JOIN film_category fc USING (category_id)
	LEFT JOIN film f USING (film_id)
	LEFT JOIN inventory i USING (film_id)
	LEFT JOIN rental r USING (inventory_id)
	GROUP BY "name" , title
)
SELECT *
FROM tmp
WHERE RANK <=5


--문제10번) 매출이 가장 많은 영화 카테고리와 매출이 가장 작은 영화 카테고리를 구하세요. (first_value, last_value)
-- 내 풀이
SELECT FIRST_VALUE("name") OVER (ORDER BY sum(amount) DESC) AS first_category, 
	FIRST_VALUE(sum(amount)) OVER (ORDER BY sum(amount) DESC),
	LAST_VALUE("name") OVER (ORDER BY sum(amount) ASC) AS last_category,
	LAST_VALUE(sum(amount)) OVER (ORDER BY sum(amount) ASC)
FROM category c 
	LEFT JOIN film_category fc USING (category_id)
	LEFT JOIN inventory i USING (film_id)
	LEFT JOIN rental r USING (inventory_id)
	LEFT JOIN payment USING (rental_id)
GROUP BY c.name
LIMIT 1

-- 답안
select *
from
(
select c.name as category_name  , sum(p.amount) rental_aoumnt ,
          first_value( c.name ) over (order by sum(p.amount) ) min_rental_amount_catagory ,
          last_value( c.name)   over (order by sum(p.amount) range between unbounded preceding  and unbounded following ) max_rental_amount_catagory
from rental  r
       inner join payment p on r.rental_id = p.rental_id
       inner join inventory i on i.inventory_id = r.inventory_id
       inner join film_category fc on fc.film_id = i.film_id
       inner join category      c  on c.category_id = fc.category_id
group by c.name
) c
where c.category_name in ( min_rental_amount_catagory , max_rental_amount_catagory )
;
