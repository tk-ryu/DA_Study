--����1��) dvd �뿩�� ���� ������ �� �̸���? (analytic funtion Ȱ��)

-- ��� 1
SELECT first_name || ' ' || last_name AS "name", count(rental_id), rank() OVER (ORDER BY count(rental_id) DESC)
FROM customer c 
LEFT JOIN rental r USING (customer_id)
GROUP BY customer_id, first_name , last_name 
ORDER BY "rank"
LIMIT 1

-- ��� 2
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

-- ��� 3 (rank Ȱ�� ����)
SELECT first_name || ' ' || last_name AS "name", count(rental_id)
FROM customer c 
LEFT JOIN rental r USING (customer_id)
GROUP BY customer_id, first_name , last_name 
ORDER BY "count" DESC 
LIMIT 1

-- row_number vs rank ��
--row_number : ���� �ߺ� �ȵ�
SELECT customer_id, count(rental_id), row_number() OVER (ORDER BY count(rental_id) DESC)
FROM rental r 
GROUP BY customer_id

-- rank : ���� �ߺ� ����
SELECT customer_id, count(rental_id), RANK() OVER (ORDER BY count(rental_id) DESC)
FROM rental r 
GROUP BY customer_id 



--����2��) ������ ���� ���� �ø� dvd �� �̸���? (analytic funtion Ȱ��)
SELECT first_name || ' ' || last_name AS "name", sum(amount), rank() OVER (ORDER BY sum(amount) DESC)
FROM customer c 
LEFT JOIN payment p USING (customer_id)
GROUP BY customer_id, first_name , last_name 
ORDER BY "rank"
LIMIT 1

--����3��) dvd �뿩�� ���� ���� ���ô�? (anlytic funtion)

SELECT city, count(r.rental_id), RANK() OVER (ORDER BY count(rental_id) ASC)
FROM city c 
LEFT JOIN address a USING (city_id)
LEFT JOIN customer c2 USING (address_id)
LEFT JOIN rental r USING (customer_id)
GROUP BY city 


--����4��) ������ ���� �ȳ����� ���ô�? (anlytic funtion)
-- sum �Լ��� null���� �ִ� ��� null�� ó���ϰ� �Ǵ�, coalesce�� Ȱ���� 0���� �ٲ��� ��
SELECT city, COALESCE(sum(amount), 0), RANK() OVER (ORDER BY COALESCE(sum(amount), 0) ASC)
FROM city c 
LEFT JOIN address a USING (city_id)
LEFT JOIN customer c2 USING (address_id)
LEFT JOIN payment p USING (customer_id)
GROUP BY city 


--����5��) ���� ������� ���ϰ� ���� ������ ������� �پ�� ���� ���ϼ���. (���ڴ� payment_date ����)
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


--����6��) ���ú� dvd �뿩 ���� ������ ���ϼ���.
SELECT city, COALESCE(sum(amount), 0) AS amount, RANK() OVER (ORDER BY COALESCE(sum(amount), 0) DESC)
FROM city c 
	LEFT JOIN address a USING (city_id)
	LEFT JOIN customer c2 USING (address_id)
	LEFT JOIN payment p USING (customer_id)
GROUP BY city  


--����7��) �뿩���� ���� ������ ���ϼ���.
SELECT store_id, COALESCE(sum(amount), 0) AS amount, RANK() OVER (ORDER BY COALESCE(sum(amount), 0) DESC)
FROM store s 
LEFT JOIN customer c2 USING (store_id)
LEFT JOIN payment p USING (customer_id)
GROUP BY store_id

--����8��) ���󺰷� ���� �뿩�� ������ �� TOP 5�� ���ϼ���.
WITH tmp AS (
	SELECT country , customer_id, sum(amount), rank() OVER (PARTITION BY country ORDER BY COALESCE (sum(amount), 0) DESC)
	FROM country c 
	LEFT JOIN city c2 USING (country_id)
	LEFT JOIN address a USING (city_id)
	LEFT JOIN customer c3 USING (address_id)
	LEFT JOIN payment p USING (customer_id)
	GROUP BY country , customer_id
	)
SELECT *
FROM tmp
WHERE RANK <= 5


--����9��) ��ȭ ī�װ� (Category) ���� �뿩�� ���� ���� �� ��ȭ TOP 5�� ���ϼ���
WITH tmp AS (
	SELECT "name" , title, count(rental_id), rank() OVER (PARTITION BY "name" ORDER BY count(rental_id) DESC)
	FROM category c 
	LEFT JOIN film_category fc USING (category_id)
	LEFT JOIN film f USING (film_id)
	LEFT JOIN inventory i USING (film_id)
	LEFT JOIN rental r USING (inventory_id)
	GROUP BY "name" , title
)
SELECT *
FROM tmp
WHERE RANK <=5


--����10��) ������ ���� ���� ��ȭ ī�װ��� ������ ���� ���� ��ȭ ī�װ��� ���ϼ���. (first_value, last_value)
-- �� Ǯ��
SELECT FIRST_VALUE("name") OVER (ORDER BY sum(amount) DESC) AS first_category, 
	FIRST_VALUE(sum(amount)) OVER (ORDER BY sum(amount) DESC),
	LAST_VALUE("name") OVER (ORDER BY sum(amount) ASC) AS last_category,
	LAST_VALUE(sum(amount)) OVER (ORDER BY sum(amount) ASC)
FROM category c 
	LEFT JOIN film_category fc USING (category_id)
	LEFT JOIN inventory i USING (film_id)
	LEFT JOIN rental r USING (inventory_id)
	LEFT JOIN payment USING (rental_id)
GROUP BY c.name
LIMIT 1

-- ���
select *
from
(
select c.name as category_name  , sum(p.amount) rental_aoumnt ,
          first_value( c.name ) over (order by sum(p.amount) ) min_rental_amount_catagory ,
          last_value( c.name)   over (order by sum(p.amount) range between unbounded preceding  and unbounded following ) max_rental_amount_catagory
from rental  r
       inner join payment p on r.rental_id = p.rental_id
       inner join inventory i on i.inventory_id = r.inventory_id
       inner join film_category fc on fc.film_id = i.film_id
       inner join category      c  on c.category_id = fc.category_id
group by c.name
) c
where c.category_name in ( min_rental_amount_catagory , max_rental_amount_catagory )
;