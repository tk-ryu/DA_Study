--����1��) store ���� staff�� ����� �ִ��� Ȯ�����ּ���.
SELECT store_id , count(manager_staff_id) AS number_of_staffs
FROM store
GROUP BY store_id 

--����2��) ��ȭ���(rating) ���� � ��ȭfilm�� ������ �ִ��� Ȯ�����ּ���.
SELECT rating , count(*)
FROM film f 
GROUP BY f.rating 

--����3��) ������ ��ȭ���(actor)��  10�� �ʰ��� ��ȭ���� �����ΰ���?
SELECT fa.film_id, f.title , count(actor_id)
FROM film_actor fa 
LEFT OUTER JOIN film f ON f.film_id = fa.film_id
GROUP BY fa.film_id, f.title 
HAVING count(actor_id) > 10

--����4��) ��ȭ ���(actor)���� �⿬�� ��ȭ�� ���� �� ���ΰ���?
--- ��ȭ ����� �̸� , �� �� �Բ� �⿬ ��ȭ ���� �˷��ּ���.
SELECT a.first_name , a.last_name , count(film_id)
FROM film_actor fa 
LEFT OUTER JOIN actor a ON a.actor_id = fa.actor_id 
GROUP BY fa.actor_id , a.first_name , a.last_name 

--����5��) ����(country)�� ��(customer) �� ����ΰ���?
SELECT c3.country ,count(c.customer_id)
FROM customer c 
LEFT OUTER JOIN address a ON a.address_id = c.address_id 
LEFT OUTER JOIN city c2 ON c2.city_id = a.city_id 
LEFT OUTER JOIN country c3 ON c3.country_id = c2.country_id 
GROUP BY c3.country 

--����6��) ��ȭ ��� (inventory) ������ 3�� �̻��� ��ȭ(film) ��?
--- store�� ��� ���� Ȯ�����ּ���.
SELECT i.film_id, f.film_id,  count(i.inventory_id)
FROM inventory i 
LEFT OUTER JOIN film f ON f.film_id = i.film_id 
GROUP BY i.film_id, f.film_id
HAVING count(i.inventory_id) >= 3


--����7��) dvd �뿩�� ���� ������ �� �̸���?
SELECT r.customer_id , c.first_name, c.last_name, count(r.rental_id)
FROM rental r 
LEFT OUTER JOIN customer c ON c.customer_id = r.customer_id 
GROUP BY r.customer_id, c.first_name, c.last_name 
ORDER BY count DESC 
LIMIT 1

--����8��) rental ���̺���  ��������,   2005�� 5��26�Ͽ� �뿩�� ����� �� ��, �Ϸ翡 2�� �̻� �뿩�� �� ���� ID ���� Ȯ�����ּ���.
SELECT r.customer_id, date(r.rental_date) ,count(r.rental_id)
FROM rental r 
WHERE date(r.rental_date ) = date('2005-05-26')
GROUP BY date(r.rental_date), r.customer_id 
HAVING count(r.rental_id) >= 2

--����9��) film_actor ���̺��� ��������, ������ ��ȭ�� ���� ����  5���� actor_id �� , ������ ��ȭ �� �� �˷��ּ���.
SELECT fa.actor_id , count(fa.film_id)
FROM film_actor fa 
GROUP BY fa.actor_id 
ORDER BY count DESC 
LIMIT 5

--����10��) payment ���̺��� ��������,  �������ڰ� 2007��2��15�Ͽ� �ش� �ϴ� �ֹ� �߿���  ,  �Ϸ翡 2�� �̻� �ֹ��� ����  �� ���� �ݾ��� 10�޷� �̻��� ���� ���ؼ� �˷��ּ���.
--(���� id,  �ֹ��Ǽ� , �� ���� �ݾױ��� �˷��ּ���)
SELECT p.customer_id , count(p.payment_id), sum(p.amount)
FROM payment p 
WHERE date(p.payment_date) = date('2007-02-15')
GROUP BY p.customer_id 
HAVING count(p.payment_id) >= 2 
AND sum(p.amount) >= 10
ORDER BY count DESC 

--����11��) ���Ǵ� �� ��ȭ ����?
SELECT l.name, count(f.film_id)
FROM "language" l 
LEFT OUTER JOIN film f ON f.language_id = l.language_id 
GROUP BY l."name" 

SELECT *
FROM film f 
WHERE f.language_id != 1

SELECT *
FROM "language" l 

--����12��) 40�� �̻� �⿬�� ��ȭ ���(actor) �� �����ΰ���?
SELECT a.name, count(fa.film_id) AS film_count
FROM (select actor_id, first_name || ' ' || last_name AS name
FROM actor a) AS a
LEFT OUTER JOIN film_actor fa ON fa.actor_id = a.actor_id 
GROUP BY a.name 

--����13��) �� ��޺� �� ���� ���ϼ���. (�뿩 �ݾ� Ȥ�� �����  �� ���� �� ����� ������ ������ �Ʒ��� �����ϴ�.)
/*
A ����� 151 �̻�
B ����� 101 �̻� 150 ����
C �����   51 �̻� 100 ����
D �����   50 ����

- �뿩 �ݾ��� �Ҽ����� �ݿø� �ϼ���.

HINT
�ݿø� �ϴ� �Լ��� ROUND �Դϴ�.	
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


