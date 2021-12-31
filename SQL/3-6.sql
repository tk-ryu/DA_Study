--����1��) ������ ���� ���� �ø� dvd �� �̸���? (subquery Ȱ��)
SELECT c.first_name || ' ' || c.last_name AS name
FROM customer c 
WHERE c.customer_id IN (SELECT p.customer_id
FROM payment p 
GROUP BY p.customer_id 
ORDER BY sum(p.amount) DESC 
LIMIT 1
)


--����2��) �뿩�� �ѹ����̶� �� ��ȭ ī�� �� �̸��� �˷��ּ���. (������, Exists������ �̿��Ͽ� Ǯ��ô�)
SELECT c."name" 
FROM category c 
WHERE EXISTS (
	SELECT *
	FROM rental r 
	JOIN inventory i USING (inventory_id)
	JOIN film_category fc USING (film_id)
	WHERE fc.category_id = c.category_id 
	)

--����. 1�� �̻� �뿩�� ��ȭ 
--	WHERE EXISTS ���
SELECT title 
FROM film f 
WHERE EXISTS (
	SELECT *
	FROM rental r 
	JOIN inventory i USING (inventory_id)
	WHERE i.film_id = f.film_id 
	)
	
--	ó�� ������ ���
SELECT film_id, title, count(rental_id) AS cnt
FROM film f 
LEFT JOIN inventory i USING (film_id)
LEFT JOIN rental r USING (inventory_id)
GROUP BY film_id, title 
HAVING count(rental_id) >= 1
ORDER BY film_id


--����3��) �뿩�� �ѹ����̶� �� ��ȭ ī�� �� �̸��� �˷��ּ���. (������, Any ������ �̿��Ͽ� Ǯ��ô�)
SELECT c."name" 
FROM category c 
WHERE c.category_id =ANY (
	SELECT fc.category_id 
	FROM rental r 
	JOIN inventory i USING (inventory_id)
	JOIN film_category fc USING (film_id)
	)

--����4��) �뿩�� ���� ���� ����� ī�װ��� �����ΰ���? (Any, All ���� �� �ϳ��� ����Ͽ� Ǯ��ô�)
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


--����5��) dvd �뿩�� ���� ������ �� �̸���? (subquery Ȱ��)

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


--����6��) ��ȭ ī�װ����� �������� �ʴ� ��ȭ�� �ֳ���?
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