--����1��) ���� �⺻ ������, �� id, �̸�, ��, �̸��ϰ� �Բ� ���� �ּ� address, district, postal_code, phone ��ȣ�� �Բ� �����ּ���.
--null�� �ִ��� Ȯ��
SELECT *
FROM customer c 
WHERE c.address_id IS NULL 

--null�� ������ inner join 
SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.postal_code , a.phone 
FROM customer c 
JOIN address a ON a.address_id = c.address_id 

SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.postal_code , a.phone 
FROM customer c 
LEFT OUTER JOIN address a ON a.address_id = c.address_id 


--����2��) ����  �⺻ ������, �� id, �̸�, ��, �̸��ϰ� �Բ� ���� �ּ� address, district, postal_code, phone , city �� �Բ� �˷��ּ���.
--address.city_id null�� ���� Ȯ��
SELECT *
FROM address a 
WHERE a.city_id IS NULL 

--null�� ������ INNER join
SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.postal_code , a.phone , c2.city
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 

--����3��) Lima City�� ��� ���� �̸���, ��, �̸���, phonenumber�� ���ؼ� �˷��ּ���.
SELECT first_name , last_name , email , phone
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id  
WHERE c2.city ~~* 'lima'

--����4��) rental ������ �߰���, ���� �̸���, ������ �̸��� �Բ� �����ּ���.
--- ���� �̸�, ���� �̸��� �̸��� ���� fullname �÷����θ��� �����̸�/���̸� 2���� �÷����� Ȯ�����ּ���.
SELECT r.*, concat(c.first_name, ' ', c.last_name ) AS "customer name" , concat(s.first_name, ' ', s.last_name ) AS "staff name"
FROM rental r 
JOIN customer c ON c.customer_id = r.customer_id 
JOIN staff s ON s.staff_id = r.staff_id 

--����5��) [seth.hannon@sakilacustomer.org](mailto:seth.hannon@sakilacustomer.org) �̸��� �ּҸ� ���� ����  �ּ� address, address2, postal_code, phone, city �ּҸ� �˷��ּ���.
SELECT a.address , a.address2 , a.postal_code , a.phone , c2.city 
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
WHERE email ILIKE 'seth.hannon@sakilacustomer.org'

--����6��) Jon Stephens ������ ���� dvd�뿩�� �� payment ��� ������  Ȯ���Ϸ��� �մϴ�.
--- payment_id,  �� �̸� �� ��,  rental_id, amount, staff �̸��� ���� �˷��ּ���.
SELECT p.payment_id , concat(c.first_name, ' ', c.last_name) AS customer , r.rental_id , p.amount , concat(s.first_name, ' ', s.last_name)
FROM payment p 
JOIN staff s ON s.staff_id = p.staff_id 
JOIN rental r ON r.rental_id = p.rental_id 
JOIN customer c ON c.customer_id = p.customer_id 
WHERE s.first_name = 'Jon' AND s.last_name = 'Stephens'



--����7��) ��찡 �⿬���� �ʴ� ��ȭ�� film_id, title, release_year, rental_rate, length �� �˷��ּ���.
SELECT f.film_id , f.title , f.release_year , f.rental_rate , f.length 
FROM film f 
LEFT OUTER JOIN film_actor fa ON fa.film_id = f.film_id 
WHERE fa.actor_id IS NULL 

--����8��) store ���� id�� �ּ� (address, address2, distict) �� �ش� ������ ��ġ�� city �ּҸ� �˷��ּ���.
SELECT a.address , a.address2 , a.district , c.city 
FROM store s 
JOIN address a ON a.address_id = s.address_id 
JOIN city c ON c.city_id = a.city_id 

--����9��) ���� id ���� ���� �̸� (first_name, last_name), �̸���, ���� �ּ� (address, district), phone��ȣ, city, country �� �˷��ּ���.
SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.phone , c2.city, c3.country 
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c3.country_id = c2.country_id 

--����10��) country �� china �� �ƴ� ������ ���, ���� �̸�(first_name, last_name)�� , email, phonenumber, country, city �� �˷��ּ���
SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.phone , c2.city, c3.country 
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c3.country_id = c2.country_id 
WHERE c3.country != 'China'

SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.phone , c2.city, c3.country 
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c3.country_id = c2.country_id 
WHERE c3.country !~~* 'china'

--����11��) Horror ī�װ� �帣�� �ش��ϴ� ��ȭ�� �̸��� description �� ���ؼ� �˷��ּ���
SELECT f.description , c.name AS "category"
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id 
JOIN category c ON c.category_id = fc.category_id 
WHERE c."name" ~~* 'horror'

--����12��) Music �帣�̸鼭, ��ȭ���̰� 60~180�� ���̿� �ش��ϴ� ��ȭ�� title, description, length �� �˷��ּ���.
--- ��ȭ ���̰� ª�� ������ �����ؼ� �˷��ּ���.
SELECT f.title , f.description , f.length , c.name AS "category"
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id 
JOIN category c ON c.category_id = fc.category_id 
WHERE c."name" ~~* 'music'
AND f.length BETWEEN 60 AND 180
ORDER BY f.length ASC 

SELECT f.title , f.description , f.length , c.name AS "category"
FROM film f 
LEFT OUTER JOIN film_category fc ON fc.film_id = f.film_id 
LEFT OUTER JOIN category c ON c.category_id = fc.category_id 
WHERE c."name" ~~* 'music'
AND f.length BETWEEN 60 AND 180
ORDER BY f.length ASC 


--����13��) actor ���̺��� �̿��Ͽ�,  ����� ID, �̸�, �� �÷��� �߰���    'Angels Life' ��ȭ�� ���� ��ȭ ��� ���θ� Y , N ���� �÷��� �߰� ǥ�����ּ���.  �ش� �÷��� angelslife_flag�� ������ּ���.
SELECT * ,
	(CASE WHEN a.actor_id IN 
		(SELECT actor_id
		FROM film f 
		JOIN film_actor fa ON fa.film_id = f.film_id 
		WHERE f.title = 'Angels like')
	THEN 'Y'
	ELSE 'N'
	END) AS "angelslife_flag"
FROM actor a 

--����14��) �뿩���ڰ� 2005-06-01~ 14�Ͽ� �ش��ϴ� �ֹ� �߿��� , ������ �̸�(�̸� ��) = 'Mike Hillyer' �̰ų�  ���� �̸��� (�̸� ��) ='Gloria Cook'  �� �ش� �ϴ� rental �� ��� ������ �˷��ּ���.
--- �߰��� �����̸���, ���̸��� ���ؼ��� fullname ���� �����ؼ� �˷��ּ���.
SELECT r.*, concat(s.first_name, ' ', s.last_name) AS staff_name, concat(c.first_name, ' ', c.last_name) AS customer_name
FROM rental r 
LEFT OUTER JOIN customer c ON c.customer_id = r.customer_id 
LEFT OUTER JOIN staff s ON s.staff_id = r.staff_id 
WHERE r.rental_date::date BETWEEN date('2005-06-01') AND date('2005-06-14')
AND concat(s.first_name, ' ', s.last_name) = 'Mike Hillyer'
OR concat(c.first_name, ' ', c.last_name) = 'Gloria Cook'

--����15��) �뿩���ڰ� 2005-06-01~ 14�Ͽ� �ش��ϴ� �ֹ� �߿��� , ������ �̸�(�̸� ��) = 'Mike Hillyer' �� �ش� �ϴ� ��������  �������� ����  rental �� ��� ������ �˷��ּ���.
--- �߰��� �����̸���, ���̸��� ���ؼ��� fullname ���� �����ؼ� �˷��ּ���.
SELECT r.*, concat(s.first_name, ' ', s.last_name) AS staff_name, concat(c.first_name, ' ', c.last_name) AS customer_name
FROM rental r 
LEFT OUTER JOIN customer c ON c.customer_id = r.customer_id 
LEFT OUTER JOIN staff s ON s.staff_id = r.staff_id 
WHERE r.rental_date::date BETWEEN date('2005-06-01') AND date('2005-06-14')
AND concat(s.first_name, ' ', s.last_name) != 'Mike Hillyer'
