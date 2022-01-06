--문제1번) 고객의 기본 정보인, 고객 id, 이름, 성, 이메일과 함께 고객의 주소 address, district, postal_code, phone 번호를 함께 보여주세요.
--null값 있는지 확인
SELECT *
FROM customer c 
WHERE c.address_id IS NULL 

--null값 없으니 inner join 
SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.postal_code , a.phone 
FROM customer c 
JOIN address a ON a.address_id = c.address_id 

SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.postal_code , a.phone 
FROM customer c 
LEFT OUTER JOIN address a ON a.address_id = c.address_id 


--문제2번) 고객의  기본 정보인, 고객 id, 이름, 성, 이메일과 함께 고객의 주소 address, district, postal_code, phone , city 를 함께 알려주세요.
--address.city_id null값 여부 확인
SELECT *
FROM address a 
WHERE a.city_id IS NULL 

--null값 없으니 INNER join
SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.postal_code , a.phone , c2.city
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 

--문제3번) Lima City에 사는 고객의 이름과, 성, 이메일, phonenumber에 대해서 알려주세요.
SELECT first_name , last_name , email , phone
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id  
WHERE c2.city ~~* 'lima'

--문제4번) rental 정보에 추가로, 고객의 이름과, 직원의 이름을 함께 보여주세요.
--- 고객의 이름, 직원 이름은 이름과 성을 fullname 컬럼으로만들어서 직원이름/고객이름 2개의 컬럼으로 확인해주세요.
SELECT r.*, concat(c.first_name, ' ', c.last_name ) AS "customer name" , concat(s.first_name, ' ', s.last_name ) AS "staff name"
FROM rental r 
JOIN customer c ON c.customer_id = r.customer_id 
JOIN staff s ON s.staff_id = r.staff_id 

--문제5번) [seth.hannon@sakilacustomer.org](mailto:seth.hannon@sakilacustomer.org) 이메일 주소를 가진 고객의  주소 address, address2, postal_code, phone, city 주소를 알려주세요.
SELECT a.address , a.address2 , a.postal_code , a.phone , c2.city 
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
WHERE email ILIKE 'seth.hannon@sakilacustomer.org'

--문제6번) Jon Stephens 직원을 통해 dvd대여를 한 payment 기록 정보를  확인하려고 합니다.
--- payment_id,  고객 이름 과 성,  rental_id, amount, staff 이름과 성을 알려주세요.
SELECT p.payment_id , concat(c.first_name, ' ', c.last_name) AS customer , r.rental_id , p.amount , concat(s.first_name, ' ', s.last_name)
FROM payment p 
JOIN staff s ON s.staff_id = p.staff_id 
JOIN rental r ON r.rental_id = p.rental_id 
JOIN customer c ON c.customer_id = p.customer_id 
WHERE s.first_name = 'Jon' AND s.last_name = 'Stephens'



--문제7번) 배우가 출연하지 않는 영화의 film_id, title, release_year, rental_rate, length 를 알려주세요.
SELECT f.film_id , f.title , f.release_year , f.rental_rate , f.length 
FROM film f 
LEFT OUTER JOIN film_actor fa ON fa.film_id = f.film_id 
WHERE fa.actor_id IS NULL 

--문제8번) store 상점 id별 주소 (address, address2, distict) 와 해당 상점이 위치한 city 주소를 알려주세요.
SELECT a.address , a.address2 , a.district , c.city 
FROM store s 
JOIN address a ON a.address_id = s.address_id 
JOIN city c ON c.city_id = a.city_id 

--문제9번) 고객의 id 별로 고객의 이름 (first_name, last_name), 이메일, 고객의 주소 (address, district), phone번호, city, country 를 알려주세요.
SELECT c.customer_id , c.first_name , c.last_name , c.email , a.address , a.district , a.phone , c2.city, c3.country 
FROM customer c 
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON a.city_id = c2.city_id 
JOIN country c3 ON c3.country_id = c2.country_id 

--문제10번) country 가 china 가 아닌 지역에 사는, 고객의 이름(first_name, last_name)과 , email, phonenumber, country, city 를 알려주세요
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

--문제11번) Horror 카테고리 장르에 해당하는 영화의 이름과 description 에 대해서 알려주세요
SELECT f.description , c.name AS "category"
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id 
JOIN category c ON c.category_id = fc.category_id 
WHERE c."name" ~~* 'horror'

--문제12번) Music 장르이면서, 영화길이가 60~180분 사이에 해당하는 영화의 title, description, length 를 알려주세요.
--- 영화 길이가 짧은 순으로 정렬해서 알려주세요.
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


--문제13번) actor 테이블을 이용하여,  배우의 ID, 이름, 성 컬럼에 추가로    'Angels Life' 영화에 나온 영화 배우 여부를 Y , N 으로 컬럼을 추가 표기해주세요.  해당 컬럼은 angelslife_flag로 만들어주세요.
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

--문제14번) 대여일자가 2005-06-01~ 14일에 해당하는 주문 중에서 , 직원의 이름(이름 성) = 'Mike Hillyer' 이거나  고객의 이름이 (이름 성) ='Gloria Cook'  에 해당 하는 rental 의 모든 정보를 알려주세요.
--- 추가로 직원이름과, 고객이름에 대해서도 fullname 으로 구성해서 알려주세요.
SELECT r.*, concat(s.first_name, ' ', s.last_name) AS staff_name, concat(c.first_name, ' ', c.last_name) AS customer_name
FROM rental r 
LEFT OUTER JOIN customer c ON c.customer_id = r.customer_id 
LEFT OUTER JOIN staff s ON s.staff_id = r.staff_id 
WHERE r.rental_date::date BETWEEN date('2005-06-01') AND date('2005-06-14')
AND concat(s.first_name, ' ', s.last_name) = 'Mike Hillyer'
OR concat(c.first_name, ' ', c.last_name) = 'Gloria Cook'

--문제15번) 대여일자가 2005-06-01~ 14일에 해당하는 주문 중에서 , 직원의 이름(이름 성) = 'Mike Hillyer' 에 해당 하는 직원에게  구매하지 않은  rental 의 모든 정보를 알려주세요.
--- 추가로 직원이름과, 고객이름에 대해서도 fullname 으로 구성해서 알려주세요.
SELECT r.*, concat(s.first_name, ' ', s.last_name) AS staff_name, concat(c.first_name, ' ', c.last_name) AS customer_name
FROM rental r 
LEFT OUTER JOIN customer c ON c.customer_id = r.customer_id 
LEFT OUTER JOIN staff s ON s.staff_id = r.staff_id 
WHERE r.rental_date::date BETWEEN date('2005-06-01') AND date('2005-06-14')
AND concat(s.first_name, ' ', s.last_name) != 'Mike Hillyer'
