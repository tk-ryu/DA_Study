--문제1번) store 별로 staff는 몇명이 있는지 확인해주세요.
SELECT store_id , count(manager_staff_id) AS number_of_staffs
FROM store
GROUP BY store_id 

--문제2번) 영화등급(rating) 별로 몇개 영화film을 가지고 있는지 확인해주세요.
SELECT rating , count(*)
FROM film f 
GROUP BY f.rating 

--문제3번) 출현한 영화배우(actor)가  10명 초과한 영화명은 무엇인가요?
SELECT fa.film_id, f.title , count(actor_id)
FROM film_actor fa 
LEFT OUTER JOIN film f ON f.film_id = fa.film_id
GROUP BY fa.film_id, f.title 
HAVING count(actor_id) > 10

--문제4번) 영화 배우(actor)들이 출연한 영화는 각각 몇 편인가요?
--- 영화 배우의 이름 , 성 과 함께 출연 영화 수를 알려주세요.
SELECT a.first_name , a.last_name , count(film_id)
FROM film_actor fa 
LEFT OUTER JOIN actor a ON a.actor_id = fa.actor_id 
GROUP BY fa.actor_id , a.first_name , a.last_name 

--문제5번) 국가(country)별 고객(customer) 는 몇명인가요?
SELECT c3.country ,count(c.customer_id)
FROM customer c 
LEFT OUTER JOIN address a ON a.address_id = c.address_id 
LEFT OUTER JOIN city c2 ON c2.city_id = a.city_id 
LEFT OUTER JOIN country c3 ON c3.country_id = c2.country_id 
GROUP BY c3.country 

--문제6번) 영화 재고 (inventory) 수량이 3개 이상인 영화(film) 는?
--- store는 상관 없이 확인해주세요.
SELECT i.film_id, f.film_id,  count(i.inventory_id)
FROM inventory i 
LEFT OUTER JOIN film f ON f.film_id = i.film_id 
GROUP BY i.film_id, f.film_id
HAVING count(i.inventory_id) >= 3


--문제7번) dvd 대여를 제일 많이한 고객 이름은?
SELECT r.customer_id , c.first_name, c.last_name, count(r.rental_id)
FROM rental r 
LEFT OUTER JOIN customer c ON c.customer_id = r.customer_id 
GROUP BY r.customer_id, c.first_name, c.last_name 
ORDER BY count DESC 
LIMIT 1

--문제8번) rental 테이블을  기준으로,   2005년 5월26일에 대여를 기록한 고객 중, 하루에 2번 이상 대여를 한 고객의 ID 값을 확인해주세요.
SELECT r.customer_id, date(r.rental_date) ,count(r.rental_id)
FROM rental r 
WHERE date(r.rental_date ) = date('2005-05-26')
GROUP BY date(r.rental_date), r.customer_id 
HAVING count(r.rental_id) >= 2

--문제9번) film_actor 테이블을 기준으로, 출현한 영화의 수가 많은  5명의 actor_id 와 , 출현한 영화 수 를 알려주세요.
SELECT fa.actor_id , count(fa.film_id)
FROM film_actor fa 
GROUP BY fa.actor_id 
ORDER BY count DESC 
LIMIT 5

--문제10번) payment 테이블을 기준으로,  결제일자가 2007년2월15일에 해당 하는 주문 중에서  ,  하루에 2건 이상 주문한 고객의  총 결제 금액이 10달러 이상인 고객에 대해서 알려주세요.
--(고객의 id,  주문건수 , 총 결제 금액까지 알려주세요)
SELECT p.customer_id , count(p.payment_id), sum(p.amount)
FROM payment p 
WHERE date(p.payment_date) = date('2007-02-15')
GROUP BY p.customer_id 
HAVING count(p.payment_id) >= 2 
AND sum(p.amount) >= 10
ORDER BY count DESC 

--문제11번) 사용되는 언어별 영화 수는?
SELECT l.name, count(f.film_id)
FROM "language" l 
LEFT OUTER JOIN film f ON f.language_id = l.language_id 
GROUP BY l."name" 

SELECT *
FROM film f 
WHERE f.language_id != 1

SELECT *
FROM "language" l 

--문제12번) 40편 이상 출연한 영화 배우(actor) 는 누구인가요?
SELECT a.name, count(fa.film_id) AS film_count
FROM (select actor_id, first_name || ' ' || last_name AS name
FROM actor a) AS a
LEFT OUTER JOIN film_actor fa ON fa.actor_id = a.actor_id 
GROUP BY a.name 

--문제13번) 고객 등급별 고객 수를 구하세요. (대여 금액 혹은 매출액  에 따라 고객 등급을 나누고 조건은 아래와 같습니다.)
/*
A 등급은 151 이상
B 등급은 101 이상 150 이하
C 등급은   51 이상 100 이하
D 등급은   50 이하

- 대여 금액의 소수점은 반올림 하세요.

HINT
반올림 하는 함수는 ROUND 입니다.	
*/

SELECT grade, count(customer_grade.customer_id)
FROM (
SELECT c.customer_id , round(sum(p.amount)) AS total, 
	CASE WHEN round(sum(p.amount)) >= 151 THEN 'A' 
		WHEN round(sum(p.amount)) >= 101 AND round(sum(p.amount)) <= 150 THEN 'B' 
		WHEN round(sum(p.amount)) >= 51 AND round(sum(p.amount)) <= 100 THEN 'C'
		ELSE 'D'
		END AS grade
FROM customer c 
LEFT OUTER JOIN payment p ON p.customer_id = c.customer_id 
GROUP BY c.customer_id 
) AS customer_grade
GROUP BY customer_grade.grade
ORDER BY customer_grade.grade ASC 




SELECT c.customer_id , round(sum(p.amount)) AS total
FROM customer c 
LEFT OUTER JOIN payment p ON p.customer_id = c.customer_id 
GROUP BY c.customer_id 

SELECT c.customer_id , round(sum(p.amount)) AS total, 
	CASE WHEN round(sum(p.amount)) >= 151 THEN 'A' 
		WHEN round(sum(p.amount)) >= 101 AND round(sum(p.amount)) <= 150 THEN 'B' 
		WHEN round(sum(p.amount)) >= 51 AND round(sum(p.amount)) <= 100 THEN 'C'
		ELSE 'D'
		END AS grade
FROM customer c 
LEFT OUTER JOIN payment p ON p.customer_id = c.customer_id 
GROUP BY c.customer_id 


