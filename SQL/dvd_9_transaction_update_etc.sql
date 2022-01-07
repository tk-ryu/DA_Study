--����1��) dvd �뿩�� ���� ������ �� �̸���?   (with �� Ȱ��)
WITH tmp AS (
	SELECT c.first_name , c.last_name , count(rental_id)
	FROM customer c 
	LEFT JOIN rental r USING (customer_id)
	GROUP BY c.first_name , c.last_name 
	)
SELECT concat(first_name, ' ', last_name), "count"
FROM tmp
ORDER BY "count" DESC 
LIMIT 1


--����2��) ��ȭ �ð� ���� (length_type)�� ���� ��ȭ ���� ���ϼ���.
--��ȭ �� �ð� ������ ���Ǵ� ������ �����ϴ�.
--��ȭ ���� (length) �� 60�� ���� short , 61�� �̻� 120�� ���� middle , 121 ���̻� long ���� �Ѵ�.

-- �⺻ Ǯ��
WITH tmp AS (
	SELECT CASE 
		WHEN length <= 60 THEN 'short' 
		WHEN length > 60 AND length <= 120 THEN 'middle'
		WHEN length > 120 THEN 'long'
		END AS length_type
	FROM film f 
	)
SELECT length_type, count(length_type)
FROM tmp
GROUP BY length_type
ORDER BY CASE length_type 
	WHEN 'short' THEN 1 
	WHEN 'middle' THEN 2
	WHEN 'long' THEN 3 
	END 
	

SELECT 'g' AS rating, 'b' AS rating

-- grouping sets Ȱ���ؼ� Total �ֱ�
WITH tmp AS (
	SELECT CASE 
		WHEN length <= 60 THEN 'short' 
		WHEN length > 60 AND length <= 120 THEN 'middle'
		WHEN length > 120 THEN 'long'
		END AS length_type
	FROM film f 
	)
SELECT COALESCE (length_type, 'Total'), count(length_type)
FROM tmp
GROUP BY GROUPING SETS (length_type,())
ORDER BY CASE length_type 
	WHEN 'short' THEN 1 
	WHEN 'middle' THEN 2
	WHEN 'long' THEN 3
	WHEN 'Total' THEN 4
	END 				


--����3��) ���� ǥ���Ǿ� �ִ� ��ȭ���(rating) �� ������, �ѱ۸�� ���� ǥ���� �ּ���. (with �� Ȱ��)
--G        ? General Audiences (��� ���ɴ� ��û����)
--PG      ? Parental Guidance Suggested. (��� ���ɴ� ��û�����ϳ�, �θ��� ������ �ʿ�)
--PG-13 ? Parents Strongly Cautioned (13�� �̸��� �Ƶ����� ������ �� �� ������, �θ��� ���Ǹ� ����)
--R         ? Restricted. (17�� �Ǵ� ���̻��� ����)
--NC-17 ? No One 17 and Under Admitted.  (17�� ���� ��û �Ұ�)

WITH tmp AS (
	SELECT DISTINCT rating 
	FROM film 
	)
SELECT rating, 
	CASE WHEN rating = 'G' THEN 'General Audiences'
		WHEN rating = 'PG' THEN 'Parental Guidance Suggested'
		WHEN rating = 'PG-13' THEN 'Parents Strongly Cautioned'
		WHEN rating = 'R' THEN 'Restricted'
		WHEN rating = 'NC-17' THEN 'No One 17 and Under Admitted'
		END AS "English",
	CASE WHEN rating = 'G' THEN '��� ���ɴ� ��û ����'
		WHEN rating = 'PG' THEN '��� ���ɴ� ��û �����ϳ�, �θ��� ������ �ʿ�'
		WHEN rating = 'PG-13' THEN '13�� �̸��� �Ƶ����� ������ �� �� ������, �θ��� ���Ǹ� ����'
		WHEN rating = 'R' THEN '17�� �Ǵ� �� �̻��� ����'
		WHEN rating = 'NC-17' THEN '17�� ���� ��û �Ұ�'
		END AS "Korean"
FROM tmp



--����4��) �� ��޺� �� ���� ���ϼ���. (�뿩 Ƚ���� ���� �� ����� ������ ������ �Ʒ��� �����ϴ�.)
--A ����� 31ȸ �̻�
--B ����� 21ȸ �̻� 30ȸ ����
--C ����� 11ȸ �̻� 20ȸ ����
--D ����� 10ȸ ����

-- �� Ǯ��
WITH tmp AS (
	SELECT customer_id, 
			count(rental_id) AS cnt,
			CASE WHEN count(rental_id) > 30 THEN 'A'
				WHEN count(rental_id) > 20 AND count(rental_id) <= 30 THEN 'B'
				WHEN count(rental_id) > 10 AND count(rental_id) <= 20 THEN 'C'
				ELSE 'D'
				END AS grade
	FROM customer c 
	LEFT JOIN rental r USING (customer_id)
	GROUP BY customer_id
	)
SELECT COALESCE (grade, 'Total'), count(customer_id)
FROM tmp
GROUP BY GROUPING SETS (grade, ())
ORDER BY grade


-- ���
with  tbl as (
select 0  as chk1 , 10 as chk2   , 'D' as grade union all
select 11 as chk1 , 20 as chk2   , 'C' as grade union all
select 21 as chk1 , 30 as chk2   , 'B' as grade union all
select 31 as chk1 , 99 as chk2   , 'A' as grade
)
select tbl.grade,  count(customer_id) as  cnt
from
        (
         select customer_id , count(*) rental_cnt
           from rental r
          group by customer_id
          order by rental_cnt desc
        ) r
        left outer join tbl on r.rental_cnt between  tbl.chk1 and tbl.chk2
group by tbl.grade
;

--����5��) �� �̸� ���� , flag  �� �ٿ��� �����ּ���.
--- ���� first_name �̸��� ù��° ���ڰ�, A, B,C �� �ش� �ϴ� ����� �� A,B,C �� flag �� �ٿ��ֽð�
--A,B,C �� �ش����� �ʴ� �ο��� ���ؼ��� Others ��� flag �� �ٿ��ּ���.


-- ��� 1
SELECT c.first_name, 
	CASE 
		WHEN first_name ILIKE 'A%' THEN 'A'
		WHEN first_name ILIKE 'B%' THEN 'B'
		WHEN first_name ILIKE 'C%' THEN 'C'
		ELSE 'Others'
		END AS "flag"
FROM customer c 


-- ��� 2 substring Ȱ��
WITH tmp AS (
	SELECT first_name, substring(first_name, 1, 1)
	FROM customer c
	)
SELECT first_name, 
	CASE 
		WHEN substring IN ('A', 'B', 'C') THEN substring
		ELSE 'Others'
		END AS flag
FROM tmp
		

--����6��) payment ���̺��� ��������,  2007�� 1��~ 3�� ������ �����Ͽ� �ش��ϸ�,  staff2�� �ο����� ������ ������  �����ǿ� ���ؼ���, Y ��
--�� �ܿ� ���ؼ��� N ���� ǥ�����ּ���. with ���� �̿����ּ���.

SELECT payment_id, staff_id, payment_date ,
	CASE 
		WHEN staff_id = 2 THEN 'Y'
		ELSE 'N'
		END AS flag
FROM payment p 
WHERE payment_date BETWEEN date('2007-01-01') AND date ('2007-03-31')


WITH tmp AS (
	SELECT 2 AS staff_id, 'Y' AS flag UNION ALL  
	SELECT 1 AS staff_id, 'N' AS flag
	)
SELECT payment_id, payment_date, staff_id , flag
FROM payment
LEFT JOIN tmp USING (staff_id)
WHERE payment_date BETWEEN date('2007-01-01') AND date ('2007-03-31')

--����7��) Payement ���̺��� ��������,  ������ ���� Quarter �б⸦ �Բ� ǥ�����ּ���.
--with ���� Ȱ���ؼ� Ǯ�����ּ���.
--1~���� ��� Q1
--4~6�� �� ��� Q2
--7~9���� ��� Q3
--10~12���� ��� Q4
WITH tmp AS (
	SELECT 'Q1' AS Q, 1 AS month_1, 3 AS month_2 UNION ALL
	SELECT 'Q2' AS Q, 4 AS month_1, 6 AS month_2 UNION ALL
	SELECT 'Q3' AS Q, 7 AS month_1, 9 AS month_2 UNION ALL
	SELECT 'Q4' AS Q, 10 AS month_1, 12 AS month_2
	)
SELECT p.payment_id , p.payment_date , tmp.q 
FROM payment p
LEFT JOIN tmp ON EXTRACT('Month' FROM p.payment_date) BETWEEN tmp.month_1 AND tmp.month_2


--����8��) Rental ���̺��� ��������,  ȸ�����ڿ� ���� Quater �б⸦ �Բ� ǥ�����ּ���.
--with ���� Ȱ���ؼ� Ǯ�����ּ���.
--1~���� ��� Q1
--4~6�� �� ��� Q2
--7~9���� ��� Q3
--10~12���� ��� Q4 �� �Բ� �����ּ���.
WITH tmp AS (
	SELECT 'Q1' AS Q, 1 AS month_1, 3 AS month_2 UNION ALL
	SELECT 'Q2' AS Q, 4 AS month_1, 6 AS month_2 UNION ALL
	SELECT 'Q3' AS Q, 7 AS month_1, 9 AS month_2 UNION ALL
	SELECT 'Q4' AS Q, 10 AS month_1, 12 AS month_2
	)
SELECT rental_id , rental_date , tmp.q
FROM rental r 
LEFT JOIN tmp ON extract('Month' FROM r.rental_date) BETWEEN tmp.month_1 AND tmp.month_2



--����9��) ��������  ����  �뿩�� ���� ��  �뿩 ������ ��� �Ǵ� �� �˷��ּ���.
--�뿩 ������   �Ʒ��� �ش� �ϴ� ��쿡 ���ؼ�, �� flag �� �˷��ּ��� .
--0~ 500�� �� ���  under_500
--501~ 3000 ���� ���  under_3000
--3001 ~ 99999 ���� ���  over_3001
WITH tmp1 AS (
	SELECT 'under_500' AS flag, 0 AS "min", 500 AS "max" UNION ALL
	SELECT 'under_3000' AS flag, 501 AS "min", 3000 AS "max" UNION ALL 
	SELECT 'over_3001' AS flag, 3001 AS "min", 99999 AS "max" 
	),
	tmp2 AS (
	SELECT staff_id, EXTRACT('Month' FROM rental_date), count(rental_id)
	FROM rental r
	GROUP BY (staff_id), (EXTRACT('Month' FROM rental_date))
	ORDER BY EXTRACT('Month' FROM rental_date), staff_id
	)
SELECT staff_id, date_part, count, flag 
FROM tmp2
LEFT JOIN tmp1 ON tmp2.count BETWEEN tmp1.min AND tmp1.max


--����10��) ������ ���� �н����忡 ���ؼ�, ������  �н����带 �����Ϸ��� �մϴ�.
--����1�� ���ο� �н������ 12345  ,  ����2�� ���ο� �н������ 54321�Դϴ�.
--�ش��� ���, �������� ���� �н������ ���� ������ ������Ʈ�� �н����带
--�Բ� �����ּ���.
--with ���� Ȱ���Ͽ�  ���ο� �н����� ������ ���� �� , �˷��ּ���.

SELECT *
FROM staff

-- ���ο� ���� �����ؼ� �غ��� 
-- �������� ���� ��, �ʿ��� ������ �ֱ�
ALTER TABLE public.staff ALTER COLUMN first_name DROP NOT NULL;
ALTER TABLE public.staff ALTER COLUMN last_name DROP NOT NULL;
ALTER TABLE public.staff ALTER COLUMN address_id DROP NOT NULL;
ALTER TABLE public.staff ALTER COLUMN store_id DROP NOT NULL;
ALTER TABLE public.staff ALTER COLUMN active DROP NOT NULL;
ALTER TABLE public.staff ALTER COLUMN username DROP NOT NULL;
ALTER TABLE public.staff ALTER COLUMN last_update DROP NOT NULL;

INSERT INTO staff 
	(staff_id, first_name, last_name, password) 
VALUES 
	(3, 'john', 'smith', 11111),
	(4, 'john', 'black', 22222)
	
DELETE FROM staff 
WHERE staff_id = 3

-- Ʈ����� �� ���� 
BEGIN;
SELECT * FROM staff s; 
SAVEPOINT my_savepoint;
DELETE FROM staff WHERE staff_id = 4;
SELECT * FROM staff s;
ROLLBACK TO my_savepoint;
SELECT * FROM staff s;
DELETE FROM staff WHERE staff_id = 3;
SELECT * FROM staff s;
COMMIT; 


-- ��� ���̺� ����
CREATE TABLE backup AS SELECT * FROM staff;
DELETE FROM backup WHERE staff_id IN (1,2,3,4);
SELECT * FROM backup;
INSERT INTO backup SELECT * FROM staff;


-- ������Ʈ �ϸ鼭 ���� ������ backup ���̺� �־�� ������ �ϴ� ����
WITH prev AS (
	UPDATE staff 
	SET 
		"password" = 
			CASE 
				WHEN staff_id = 3 THEN 12345
				WHEN staff_id = 4 THEN 54321
				END 
	RETURNING *
	)
INSERT INTO backup SELECT * FROM prev

SELECT * FROM staff;
SELECT * FROM backup;



-- password �缳��
UPDATE staff 
	SET 
		"password" = 
			CASE 
				WHEN staff_id = 3 THEN 11111
				WHEN staff_id = 4 THEN 22222
				END 
	RETURNING *
	
-- ��� ���̺�
INSERT INTO backup SELECT * FROM staff;

-- ��й�ȣ ����
UPDATE staff 
	SET 
		"password" = 
			CASE 
				WHEN staff_id = 3 THEN 12345
				WHEN staff_id = 4 THEN 54321
				END 
	RETURNING *

-- �ٲ� ��й�ȣ Ȯ��
SELECT staff_id, s."password" AS "new_password", b."password" AS "previous_password"
FROM staff s
LEFT JOIN backup b using(staff_id)
WHERE staff_id IN (3, 4)
