--����1��) ��ȭ ��찡,  ��ȭ 180�� �̻��� ���� �� ��ȭ�� �⿬�ϰų�, ��ȭ�� rating �� R �� ��޿� �ش��ϴ� ��ȭ�� �⿬��  ��ȭ ��쿡 ���ؼ�,  ��ȭ ��� ID �� (180���̻� / R��޿�ȭ)�� ���� Flag �÷��� �˷��ּ���.
--- film_actor ���̺�� film ���̺��� �̿��ϼ���.
--- union, unionall, intersect, except �� ��Ȳ�� �°� ������ּ���.
--- actor_id �� ������ flag �� �� ������ ������ �ʵ��� ���ּ���.

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

--����2��) R����� ��ȭ�� �⿬�ߴ� ����̸鼭, ���ÿ�, Alone Trip�� ��ȭ�� �⿬��  ��ȭ����� ID �� Ȯ�����ּ���.
--- film_actor ���̺�� film ���̺��� �̿��ϼ���.
--- union, unionall, intersect, except �� ��Ȳ�� �°� ������ּ���.

SELECT fa.actor_id 
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'R')
INTERSECT 
SELECT fa.actor_id
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.title ILIKE 'alone trip')



--����3��) G ��޿� �ش��ϴ� �ʸ��� �������,   ��ȭ�� 20���̻� ���� ���� ��ȭ����� ID �� Ȯ�����ּ���.
--- film_actor ���̺�� film ���̺��� �̿��ϼ���.
--- union, unionall, intersect, except �� ��Ȳ�� �°� ������ּ���.
SELECT actor_id 
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'G')
INTERSECT 
SELECT actor_id
FROM film_actor fa 
GROUP BY fa.actor_id 
HAVING count(fa.actor_id) < 20

--��� : WHERE �������� ���͸��� ������ �߿��� GROUP BY�� �ϱ� ������ �ǵ��� �ٸ��� ����
SELECT actor_id, count(fa.actor_id)
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'G')
GROUP BY fa.actor_id 
HAVING count(fa.actor_id) < 20

--����4��) �ʸ� �߿���,  �ʸ� ī�װ��� Action, Animation, Horror �� �ش����� �ʴ� �ʸ� ���̵� �˷��ּ���.
--- category ���̺��� �̿��ؼ� �˷��ּ���.
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



--����5��) Staff  ��  id , �̸�, �� �� ���� �����Ϳ� , Customer �� id, �̸� , ���� ���� �����͸�  �ϳ���  �����ͼ��� ���·� �����ּ���.
--- �÷� ���� : id, �̸� , ��, flag (����/������) �� �������ּ���.

SELECT s.staff_id id, s.first_name , s.last_name , 'staff' AS flag
FROM staff s 
UNION ALL 
SELECT c.customer_id , c.first_name , c.last_name , 'customer' AS flag
FROM customer c 

--����6��) ������  ���� �̸��� ������ ����� Ȥ�� �ֳ���? �ִٸ�, �ش� ����� �̸��� ���� �˷��ּ���.

SELECT s.first_name || ' ' || s.last_name AS name
FROM staff s 
WHERE s.first_name IN (SELECT c.first_name FROM customer c)
AND s.last_name IN (SELECT c.last_name FROM customer c)


--����7��) �ݳ��� ���� ���� �뿩��(store)�� ��ȭ ��� (inventory)�� ��ü ��ȭ ��� ���� ���ϼ���. (union all)

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


--����8��) ����(country)�� ����(city)�� �����, ����(country)����� �Ұ� �׸��� ��ü ������� ���ϼ���. (union all)
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
