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



--����7��) Payement ���̺��� ��������,  ������ ���� Quarter �б⸦ �Բ� ǥ�����ּ���.
--with ���� Ȱ���ؼ� Ǯ�����ּ���.
--1~���� ��� Q1
--4~6�� �� ��� Q2
--7~9���� ��� Q3
--10~12���� ��� Q4



--����8��) Rental ���̺��� ��������,  ȸ�����ڿ� ���� Quater �б⸦ �Բ� ǥ�����ּ���.
--with ���� Ȱ���ؼ� Ǯ�����ּ���.
--1~���� ��� Q1
--4~6�� �� ��� Q2
--7~9���� ��� Q3
--10~12���� ��� Q4 �� �Բ� �����ּ���.



--����9��) ��������  ����  �뿩�� ���� ��  �뿩 ������ ��� �Ǵ� �� �˷��ּ���.
--�뿩 ������   �Ʒ��� �ش� �ϴ� ��쿡 ���ؼ�, �� flag �� �˷��ּ��� .
--0~ 500�� �� ���  under_500
--501~ 3000 ���� ���  under_3000
--3001 ~ 99999 ���� ���  over_3001



--����10��) ������ ���� �н����忡 ���ؼ�, ������  �н����带 �����Ϸ��� �մϴ�.
--����1�� ���ο� �н������ 12345  ,  ����2�� ���ο� �н������ 54321�Դϴ�.
--�ش��� ���, �������� ���� �н������ ���� ������ ������Ʈ�� �н����带
--�Բ� �����ּ���.
--with ���� Ȱ���Ͽ�  ���ο� �н����� ������ ���� �� , �˷��ּ���.