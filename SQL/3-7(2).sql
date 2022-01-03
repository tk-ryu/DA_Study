--����1��) �뿩��(store)�� ��ȭ ���(inventory) ������ ��ü ��ȭ ��� ������? (grouping set)
SELECT COALESCE (store_id::TEXT , 'total') as store_id , count(film_id)
FROM inventory i 
GROUP BY GROUPING SETs ((store_id),())

SELECT store_id::TEXT , count(film_id)
FROM inventory i 
GROUP BY store_id 
UNION ALL 
SELECT 'total', count(film_id)
FROM inventory i  

--����2��) �뿩��(store)�� ��ȭ ���(inventory) ������ ��ü ��ȭ ��� ������? (rollup)
SELECT COALESCE (store_id::TEXT , 'total') as store_id , count(film_id)
FROM inventory i 
GROUP BY ROLLUP (store_id)


--����3��) ����(country)�� ����(city)�� �����, ����(country)����� �Ұ� �׸��� ��ü ������� ���ϼ���. (grouping set)
SELECT COALESCE (country::TEXT, '__TOTAL__') AS country, COALESCE (city::TEXT, 'CITY_TOTAL') AS city, sum(amount)
FROM payment p 
LEFT JOIN customer c USING (customer_id)
LEFT JOIN address a USING (address_id)
LEFT JOIN city c2 USING (city_id)
LEFT JOIN country c3 USING (country_id)
GROUP BY GROUPING SETS (country, city), (country), ()
ORDER BY 
	CASE 
		WHEN COALESCE (country::TEXT, '__TOTAL__') = '__TOTAL__' THEN 0
	END, 
	country, 
	CASE 
		WHEN COALESCE (city::TEXT, 'COUNTRY_TOTAL') = 'CITY_TOTAL' THEN 0
	END, 
	city

--����4��) ����(country)�� ����(city)�� �����, ����(country)����� �Ұ� �׸��� ��ü ������� ���ϼ���. (rollup)
SELECT COALESCE (country::TEXT, 'COUNTRY_TOTAL') AS country, COALESCE (city::TEXT, 'CITY_TOTAL') AS city, sum(amount)
FROM payment p 
LEFT JOIN customer c USING (customer_id)
LEFT JOIN address a USING (address_id)
LEFT JOIN city c2 USING (city_id)
LEFT JOIN country c3 USING (country_id)
GROUP BY ROLLUP (country, city), ()
ORDER BY 
	CASE 
		WHEN COALESCE (country::TEXT, 'COUNTRY_TOTAL') = 'COUNTRY_TOTAL' THEN 0
	END, 
	country, 
	CASE 
		WHEN COALESCE (city::TEXT, 'CITY_TOTAL') = 'CITY_TOTAL' THEN 0
	END, 
	city

--����5��) ��ȭ��캰��  �⿬�� ��ȭ count �� ��,   ��� ����� ��ü �⿬ ��ȭ ���� �ջ� �ؼ� �Բ� �����ּ���.

SELECT COALESCE (actor_id::TEXT, 'TOTAL') AS actor_id, count(film_id)
FROM film_actor fa 
GROUP BY ROLLUP (actor_id)
ORDER BY 
	CASE 
		WHEN COALESCE (actor_id::TEXT, 'TOTAL') = 'TOTAL' THEN 0
		ELSE actor_id 
	END 
	
	 
SELECT actor_id::TEXT , count(film_id)
FROM film_actor fa 
GROUP BY actor_id
UNION ALL 
SELECT 'TOTAL', sum(count)
FROM (
	SELECT actor_id, count(film_id)
	FROM film_actor fa 
	GROUP BY actor_id
	) AS tmp

--����6��) ���� (Country)��, ����(City)��  ���� ���� ,  ��ü ������ ���� ���� �Բ� �����ּ���. (grouping sets)
SELECT COALESCE (country::TEXT, 'COUNTRY_TOTAL') AS country, COALESCE (city::TEXT, 'CITY_TOTAL') AS city, count (customer_id)
FROM country c 
LEFT JOIN city c2 USING (country_id)
LEFT JOIN address a USING (city_id)
LEFT JOIN customer c3 USING (address_id)
GROUP BY GROUPING SETS (country, city), (country)
ORDER BY country 


--����7��) ��ȭ���� ����� ����  ��ȭ ���� ���� �� ���� ��ȭ  ������  , ��ȭ ���� ������ ���� ��ȭ ������ �Բ� �����ּ���.
-- ������ �� ���ϴ� ���� �� �𸣰ڴ� ;;
SELECT film_id, l.name AS "language_name", release_year, tmp.movies_in_year 
FROM film f 
LEFT JOIN "language" l USING (language_id)
LEFT JOIN (
	SELECT release_year, count(film_id) AS movies_in_year
	FROM film f 
	GROUP BY f.release_year
	) AS tmp USING (release_year)

-- ���...?
select language_id , release_year , count(film_id)
from film
group by grouping sets ((language_id, release_year), (release_year))


--����8��) ������, �Ϻ� ����  ������,  ������ ���� ������ �Բ� �����ּ���.
--- ���������� ���� �� id ���� �� �ǹ��մϴ�.

SELECT to_char(payment_date, 'YYYY') AS "Year", COALESCE (to_char(payment_date, 'MM-DD'), 'Total') AS "Date", count(payment_id)
FROM payment
GROUP BY GROUPING SETS (to_char(payment_date, 'YYYY'), to_char(payment_date, 'MM-DD')), (to_char(payment_date, 'YYYY'))
ORDER BY to_char(payment_date, 'MM-DD')


SELECT extract(YEAR FROM payment_date) AS "Year", COALESCE(EXTRACT(MONTH FROM payment_date) || '-' ||EXTRACT(DAY FROM payment_date), 'Total') AS "Date", count(payment_id)
FROM payment
GROUP BY GROUPING SETS (extract(YEAR FROM payment_date), EXTRACT(MONTH FROM payment_date) || '-' ||EXTRACT(DAY FROM payment_date)), (extract(YEAR FROM payment_date))
ORDER BY EXTRACT(MONTH FROM payment_date) || '-' ||EXTRACT(DAY FROM payment_date)


--����9��) ���� ��,  active ���� ���� ,   active �� �� ��  �Բ� �����ּ���.
--������, active ���ο� ���ؼ��� customer ���̺��� �̿��Ͽ� �����ּ���.
--- grouping sets �� �̿��ؼ� Ǯ�����ּ���.

SELECT COALESCE (store_id::TEXT , 'Total') AS "store", active, count(customer_id) AS actovie_user_count
FROM customer
GROUP BY GROUPING SETS (store_id, active), (active)
HAVING active = 1
ORDER BY store_id

--����10��) ���� ��,  active ���� ���� ,   active �� �� ��  �Բ� �����ּ���.
--������, active ���ο� ���ؼ��� customer ���̺��� �̿��Ͽ� �����ּ���.
--- roll up���� Ǯ���غ��鼭, grouping sets ���� ���̸� Ȯ���غ�����.

SELECT COALESCE (store_id::TEXT , 'Total') AS "store", active,  count(customer_id) AS actovie_user_count
FROM customer
LEFT JOIN store s USING (store_id)
GROUP BY ROLLUP (store_id), (active)
HAVING active = 1
ORDER BY store_id

SELECT COALESCE (store_id::TEXT , 'Total') AS "store", active,  count(customer_id) AS actovie_user_count
FROM customer
LEFT JOIN store s USING (store_id)
GROUP BY ROLLUP (store_id, active)
HAVING active = 1
ORDER BY store_id