--문제1번) 영화 배우가,  영화 180분 이상의 길이 의 영화에 출연하거나, 영화의 rating 이 R 인 등급에 해당하는 영화에 출연한  영화 배우에 대해서,  영화 배우 ID 와 (180분이상 / R등급영화)에 대한 Flag 컬럼을 알려주세요.
--- film_actor 테이블와 film 테이블을 이용하세요.
--- union, unionall, intersect, except 중 상황에 맞게 사용해주세요.
--- actor_id 가 동일한 flag 값 이 여러개 나오지 않도록 해주세요.

SELECT a.actor_id, 'length' AS flag
FROM actor a 
LEFT OUTER JOIN film_actor fa ON fa.actor_id = a.actor_id 
LEFT OUTER JOIN film f ON f.film_id = fa.film_id 
WHERE f.length >=180
UNION 
SELECT a.actor_id, 'rating' AS flag 
FROM actor a 
LEFT OUTER JOIN film_actor fa ON fa.actor_id = a.actor_id 
LEFT OUTER JOIN film f ON f.film_id = fa.film_id 
WHERE f.rating = 'R'


select actor_id  , 'length_over_180' as flag
from film_actor fa
where film_id  in (
select film_id
from film
where length  >=180
)
union
select   actor_id  , 'rating_R' as flag
from film_actor fa
where film_id  in (
select film_id
from film
where rating ='R'
)

--문제2번) R등급의 영화에 출연했던 배우이면서, 동시에, Alone Trip의 영화에 출연한  영화배우의 ID 를 확인해주세요.
--- film_actor 테이블와 film 테이블을 이용하세요.
--- union, unionall, intersect, except 중 상황에 맞게 사용해주세요.

SELECT fa.actor_id 
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'R')
INTERSECT 
SELECT fa.actor_id
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.title ILIKE 'alone trip')



--문제3번) G 등급에 해당하는 필름을 찍었으나,   영화를 20편이상 찍지 않은 영화배우의 ID 를 확인해주세요.
--- film_actor 테이블와 film 테이블을 이용하세요.
--- union, unionall, intersect, except 중 상황에 맞게 사용해주세요.
SELECT actor_id 
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'G')
INTERSECT 
SELECT actor_id
FROM film_actor fa 
GROUP BY fa.actor_id 
HAVING count(fa.film_id) < 20

SELECT actor_id 
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'G')
EXCEPT 
SELECT actor_id
FROM film_actor fa 
GROUP BY fa.actor_id 
HAVING count(fa.film_id) >= 20

--비고 : WHERE 조건절로 필터링한 데이터 중에서 GROUP BY를 하기 때문에 의도와 다르게 나옴
SELECT actor_id, count(fa.actor_id)
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'G')
GROUP BY fa.actor_id 
HAVING count(fa.actor_id) < 20

--문제4번) 필름 중에서,  필름 카테고리가 Action, Animation, Horror 에 해당하지 않는 필름 아이디를 알려주세요.
--- category 테이블을 이용해서 알려주세요.
SELECT fc.film_id 
FROM film_category fc  
WHERE fc.category_id IN (SELECT c.category_id FROM category c WHERE c.name NOT IN ('Action', 'Animation', 'Horror'))

select film_id
from film
except
select film_id
from film_category fc
where category_id  in (
select  category_id
from category c
where name  in ('Action','Animation','Horror')
)


SELECT fc.category_id, STRING_AGG (fc.film_id ::TEXT , ',' ORDER BY fc.film_id) films
FROM film_category fc 
GROUP BY fc.category_id 
HAVING fc.category_id IN (SELECT c.category_id FROM category c WHERE c.name NOT IN ('Action', 'Animation', 'Horror'))



--문제5번) Staff  의  id , 이름, 성 에 대한 데이터와 , Customer 의 id, 이름 , 성에 대한 데이터를  하나의  데이터셋의 형태로 보여주세요.
--- 컬럼 구성 : id, 이름 , 성, flag (직원/고객여부) 로 구성해주세요.

SELECT s.staff_id id, s.first_name , s.last_name , 'staff' AS flag
FROM staff s 
UNION ALL 
SELECT c.customer_id , c.first_name , c.last_name , 'customer' AS flag
FROM customer c 

--문제6번) 직원과  고객의 이름이 동일한 사람이 혹시 있나요? 있다면, 해당 사람의 이름과 성을 알려주세요.

SELECT s.first_name || ' ' || s.last_name AS name
FROM staff s 
WHERE s.first_name IN (SELECT c.first_name FROM customer c)
AND s.last_name IN (SELECT c.last_name FROM customer c)


--문제7번) 반납이 되지 않은 대여점(store)별 영화 재고 (inventory)와 전체 영화 재고를 같이 구하세요. (union all)

WITH ttl AS (
SELECT i.store_id , count(*) total
FROM inventory i
GROUP BY i.store_id),
per_store AS (
SELECT i.store_id , count(*) not_returned
FROM rental r
LEFT OUTER JOIN inventory i USING (inventory_id)
WHERE r.rental_date IS NOT NULL 
AND r.return_date IS NULL
GROUP BY i.store_id)
SELECT store_id::TEXT, total, not_returned
FROM ttl
LEFT OUTER JOIN per_store USING (store_id)
UNION all
SELECT 'Total', sum(total) total, sum(not_returned) not_returned
FROM ttl
LEFT OUTER JOIN per_store USING (store_id)


--문제8번) 국가(country)별 도시(city)별 매출액, 국가(country)매출액 소계 그리고 전체 매출액을 구하세요. (union all)
SELECT country, city, sum(p.amount)
FROM payment p 
LEFT OUTER JOIN customer c USING (customer_id)
LEFT OUTER JOIN address a USING (address_id)
LEFT OUTER JOIN city c2 USING (city_id)
LEFT OUTER JOIN country c3 USING (country_id)
GROUP BY country, city  
UNION ALL 
SELECT country, '_Country_total', sum(p.amount)
FROM payment p 
LEFT OUTER JOIN customer c USING (customer_id)
LEFT OUTER JOIN address a USING (address_id)
LEFT OUTER JOIN city c2 USING (city_id)
LEFT OUTER JOIN country c3 USING (country_id)
GROUP BY country
UNION ALL 
SELECT 'total', 'total', sum(p.amount)
FROM payment p
ORDER BY country, city
