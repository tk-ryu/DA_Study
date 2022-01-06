--문제1번) 매출을 가장 많이 올린 dvd 고객 이름은? (subquery 활용)
SELECT c.first_name || ' ' || c.last_name AS name
FROM customer c 
WHERE c.customer_id IN (SELECT p.customer_id
FROM payment p 
GROUP BY p.customer_id 
ORDER BY sum(p.amount) DESC 
LIMIT 1
)


--문제2번) 대여가 한번도이라도 된 영화 카테 고리 이름을 알려주세요. (쿼리는, Exists조건을 이용하여 풀어봅시다)
SELECT c."name" 
FROM category c 
WHERE EXISTS (
	SELECT *
	FROM rental r 
	JOIN inventory i USING (inventory_id)
	JOIN film_category fc USING (film_id)
	WHERE fc.category_id = c.category_id 
	)

--연습. 1번 이상 대여된 영화 
--	WHERE EXISTS 사용
SELECT title 
FROM film f 
WHERE EXISTS (
	SELECT *
	FROM rental r 
	JOIN inventory i USING (inventory_id)
	WHERE i.film_id = f.film_id 
	)
	
--	처음 생각한 방법
SELECT film_id, title, count(rental_id) AS cnt
FROM film f 
LEFT JOIN inventory i USING (film_id)
LEFT JOIN rental r USING (inventory_id)
GROUP BY film_id, title 
HAVING count(rental_id) >= 1
ORDER BY film_id


--문제3번) 대여가 한번도이라도 된 영화 카테 고리 이름을 알려주세요. (쿼리는, Any 조건을 이용하여 풀어봅시다)
SELECT c."name" 
FROM category c 
WHERE c.category_id =ANY (
	SELECT fc.category_id 
	FROM rental r 
	JOIN inventory i USING (inventory_id)
	JOIN film_category fc USING (film_id)
	)

--문제4번) 대여가 가장 많이 진행된 카테고리는 무엇인가요? (Any, All 조건 중 하나를 사용하여 풀어봅시다)
SELECT c."name" 
FROM category c 
WHERE c.category_id =ANY (
	SELECT fc.category_id 
	FROM rental r 
	JOIN inventory i USING (inventory_id)
	JOIN film_category fc USING (film_id)
	GROUP BY category_id 
	ORDER BY count(rental_id) DESC 
	LIMIT 1
	)

SELECT name, count(rental_id)
FROM category c 
LEFT JOIN film_category fc USING (category_id)
LEFT JOIN inventory i USING (film_id)
LEFT JOIN rental USING (inventory_id)
GROUP BY c."name" 
ORDER BY count(rental_id) DESC 


--문제5번) dvd 대여를 제일 많이한 고객 이름은? (subquery 활용)

SELECT concat (c.first_name, ' ', c.last_name) AS full_name
FROM customer c 
WHERE c.customer_id IN (
	SELECT customer_id
	FROM rental r 
	GROUP BY customer_id 
	ORDER BY count(rental_id) DESC 
	LIMIT 1
	)

SELECT concat (c.first_name, ' ', c.last_name ) AS full_name, count(rental_id)
FROM customer c 
LEFT JOIN rental r USING (customer_id)
GROUP BY c.customer_id, c.first_name , c.last_name 
ORDER BY count(rental_id) DESC 


--문제6번) 영화 카테고리값이 존재하지 않는 영화가 있나요?
SELECT *
FROM film f 
LEFT JOIN film_category fc USING (film_id)
WHERE category_id IS NULL 

SELECT *
FROM film f 
WHERE NOT EXISTS (
	SELECT *
	FROM film_category AS fc 
	WHERE f.film_id = fc.film_id 
	)
