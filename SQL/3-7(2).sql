--문제1번) 대여점(store)별 영화 재고(inventory) 수량과 전체 영화 재고 수량은? (grouping set)
SELECT COALESCE (store_id::TEXT , 'total') as store_id , count(film_id)
FROM inventory i 
GROUP BY GROUPING SETs ((store_id),())

SELECT store_id::TEXT , count(film_id)
FROM inventory i 
GROUP BY store_id 
UNION ALL 
SELECT 'total', count(film_id)
FROM inventory i  

--문제2번) 대여점(store)별 영화 재고(inventory) 수량과 전체 영화 재고 수량은? (rollup)
SELECT COALESCE (store_id::TEXT , 'total') as store_id , count(film_id)
FROM inventory i 
GROUP BY ROLLUP (store_id)


--문제3번) 국가(country)별 도시(city)별 매출액, 국가(country)매출액 소계 그리고 전체 매출액을 구하세요. (grouping set)
SELECT COALESCE (country::TEXT, '__TOTAL__') AS country, COALESCE (city::TEXT, 'CITY_TOTAL') AS city, sum(amount)
FROM payment p 
LEFT JOIN customer c USING (customer_id)
LEFT JOIN address a USING (address_id)
LEFT JOIN city c2 USING (city_id)
LEFT JOIN country c3 USING (country_id)
GROUP BY GROUPING SETS (country, city), (country), ()
ORDER BY 
	CASE 
		WHEN COALESCE (country::TEXT, '__TOTAL__') = '__TOTAL__' THEN 0
	END, 
	country, 
	CASE 
		WHEN COALESCE (city::TEXT, 'COUNTRY_TOTAL') = 'CITY_TOTAL' THEN 0
	END, 
	city

--문제4번) 국가(country)별 도시(city)별 매출액, 국가(country)매출액 소계 그리고 전체 매출액을 구하세요. (rollup)
SELECT COALESCE (country::TEXT, 'COUNTRY_TOTAL') AS country, COALESCE (city::TEXT, 'CITY_TOTAL') AS city, sum(amount)
FROM payment p 
LEFT JOIN customer c USING (customer_id)
LEFT JOIN address a USING (address_id)
LEFT JOIN city c2 USING (city_id)
LEFT JOIN country c3 USING (country_id)
GROUP BY ROLLUP (country, city), ()
ORDER BY 
	CASE 
		WHEN COALESCE (country::TEXT, 'COUNTRY_TOTAL') = 'COUNTRY_TOTAL' THEN 0
	END, 
	country, 
	CASE 
		WHEN COALESCE (city::TEXT, 'CITY_TOTAL') = 'CITY_TOTAL' THEN 0
	END, 
	city

--문제5번) 영화배우별로  출연한 영화 count 수 와,   모든 배우의 전체 출연 영화 수를 합산 해서 함께 보여주세요.

SELECT COALESCE (actor_id::TEXT, 'TOTAL') AS actor_id, count(film_id)
FROM film_actor fa 
GROUP BY ROLLUP (actor_id)
ORDER BY 
	CASE 
		WHEN COALESCE (actor_id::TEXT, 'TOTAL') = 'TOTAL' THEN 0
		ELSE actor_id 
	END 
	
	 
SELECT actor_id::TEXT , count(film_id)
FROM film_actor fa 
GROUP BY actor_id
UNION ALL 
SELECT 'TOTAL', sum(count)
FROM (
	SELECT actor_id, count(film_id)
	FROM film_actor fa 
	GROUP BY actor_id
	) AS tmp

--문제6번) 국가 (Country)별, 도시(City)별  고객의 수와 ,  전체 국가별 고객의 수를 함께 보여주세요. (grouping sets)
SELECT COALESCE (country::TEXT, 'COUNTRY_TOTAL') AS country, COALESCE (city::TEXT, 'CITY_TOTAL') AS city, count (customer_id)
FROM country c 
LEFT JOIN city c2 USING (country_id)
LEFT JOIN address a USING (city_id)
LEFT JOIN customer c3 USING (address_id)
GROUP BY GROUPING SETS (country, city), (country)
ORDER BY country 


--문제7번) 영화에서 사용한 언어와  영화 개봉 연도 에 대한 영화  갯수와  , 영화 개봉 연도에 대한 영화 갯수를 함께 보여주세요.
-- 문제가 뭘 원하는 건지 잘 모르겠다 ;;
SELECT film_id, l.name AS "language_name", release_year, tmp.movies_in_year 
FROM film f 
LEFT JOIN "language" l USING (language_id)
LEFT JOIN (
	SELECT release_year, count(film_id) AS movies_in_year
	FROM film f 
	GROUP BY f.release_year
	) AS tmp USING (release_year)

-- 답안...?
select language_id , release_year , count(film_id)
from film
group by grouping sets ((language_id, release_year), (release_year))


--문제8번) 연도별, 일별 결제  수량과,  연도별 결제 수량을 함께 보여주세요.
--- 결제수량은 결제 의 id 갯수 를 의미합니다.

SELECT to_char(payment_date, 'YYYY') AS "Year", COALESCE (to_char(payment_date, 'MM-DD'), 'Total') AS "Date", count(payment_id)
FROM payment
GROUP BY GROUPING SETS (to_char(payment_date, 'YYYY'), to_char(payment_date, 'MM-DD')), (to_char(payment_date, 'YYYY'))
ORDER BY to_char(payment_date, 'MM-DD')


SELECT extract(YEAR FROM payment_date) AS "Year", COALESCE(EXTRACT(MONTH FROM payment_date) || '-' ||EXTRACT(DAY FROM payment_date), 'Total') AS "Date", count(payment_id)
FROM payment
GROUP BY GROUPING SETS (extract(YEAR FROM payment_date), EXTRACT(MONTH FROM payment_date) || '-' ||EXTRACT(DAY FROM payment_date)), (extract(YEAR FROM payment_date))
ORDER BY EXTRACT(MONTH FROM payment_date) || '-' ||EXTRACT(DAY FROM payment_date)


--문제9번) 지점 별,  active 고객의 수와 ,   active 고객 수 를  함께 보여주세요.
--지점과, active 여부에 대해서는 customer 테이블을 이용하여 보여주세요.
--- grouping sets 를 이용해서 풀이해주세요.

SELECT COALESCE (store_id::TEXT , 'Total') AS "store", active, count(customer_id) AS actovie_user_count
FROM customer
GROUP BY GROUPING SETS (store_id, active), (active)
HAVING active = 1
ORDER BY store_id

--문제10번) 지점 별,  active 고객의 수와 ,   active 고객 수 를  함께 보여주세요.
--지점과, active 여부에 대해서는 customer 테이블을 이용하여 보여주세요.
--- roll up으로 풀이해보면서, grouping sets 과의 차이를 확인해보세요.

SELECT COALESCE (store_id::TEXT , 'Total') AS "store", active,  count(customer_id) AS actovie_user_count
FROM customer
LEFT JOIN store s USING (store_id)
GROUP BY ROLLUP (store_id), (active)
HAVING active = 1
ORDER BY store_id

SELECT COALESCE (store_id::TEXT , 'Total') AS "store", active,  count(customer_id) AS actovie_user_count
FROM customer
LEFT JOIN store s USING (store_id)
GROUP BY ROLLUP (store_id, active)
HAVING active = 1
ORDER BY store_id