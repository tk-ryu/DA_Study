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
--
--문제7번) 대여점별 매출 순위를 구하세요.
--
--문제8번) 나라별로 가장 대여를 많이한 고객 TOP 5를 구하세요.
--
--문제9번) 영화 카테고리 (Category) 별로 대여가 가장 많이 된 영화 TOP 5를 구하세요
--
--문제10번) 매출이 가장 많은 영화 카테고리와 매출이 가장 작은 영화 카테고리를 구하세요. (first_value, last_value)