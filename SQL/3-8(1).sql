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
--
--����7��) �뿩���� ���� ������ ���ϼ���.
--
--����8��) ���󺰷� ���� �뿩�� ������ �� TOP 5�� ���ϼ���.
--
--����9��) ��ȭ ī�װ� (Category) ���� �뿩�� ���� ���� �� ��ȭ TOP 5�� ���ϼ���
--
--����10��) ������ ���� ���� ��ȭ ī�װ��� ������ ���� ���� ��ȭ ī�װ��� ���ϼ���. (first_value, last_value)