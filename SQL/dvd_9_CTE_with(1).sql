--문제1번) dvd 대여를 제일 많이한 고객 이름은?   (with 문 활용)
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


--문제2번) 영화 시간 유형 (length_type)에 대한 영화 수를 구하세요.
--영화 상영 시간 유형의 정의는 다음과 같습니다.
--영화 길이 (length) 은 60분 이하 short , 61분 이상 120분 이하 middle , 121 분이상 long 으로 한다.

-- 기본 풀이
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

-- grouping sets 활용해서 Total 넣기
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


--문제3번) 약어로 표현되어 있는 영화등급(rating) 을 영문명, 한글명과 같이 표현해 주세요. (with 문 활용)
--G        ? General Audiences (모든 연령대 시청가능)
--PG      ? Parental Guidance Suggested. (모든 연령대 시청가능하나, 부모의 지도가 필요)
--PG-13 ? Parents Strongly Cautioned (13세 미만의 아동에게 부적절 할 수 있으며, 부모의 주의를 요함)
--R         ? Restricted. (17세 또는 그이상의 성인)
--NC-17 ? No One 17 and Under Admitted.  (17세 이하 시청 불가)

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
	CASE WHEN rating = 'G' THEN '모든 연령대 시청 가능'
		WHEN rating = 'PG' THEN '모든 연령대 시청 가능하나, 부모의 지도가 필요'
		WHEN rating = 'PG-13' THEN '13세 미만의 아동에게 부적절 할 수 있으며, 부모의 주의를 요함'
		WHEN rating = 'R' THEN '17세 또는 그 이상의 성인'
		WHEN rating = 'NC-17' THEN '17세 이하 시청 불가'
		END AS "Korean"
FROM tmp



--문제4번) 고객 등급별 고객 수를 구하세요. (대여 횟수에 따라 고객 등급을 나누고 조건은 아래와 같습니다.)
--A 등급은 31회 이상
--B 등급은 21회 이상 30회 이하
--C 등급은 11회 이상 20회 이하
--D 등급은 10회 이하

-- 내 풀이
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


-- 답안
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

--문제5번) 고객 이름 별로 , flag  를 붙여서 보여주세요.
--- 고객의 first_name 이름의 첫번째 글자가, A, B,C 에 해당 하는 사람은 각 A,B,C 로 flag 를 붙여주시고
--A,B,C 에 해당하지 않는 인원에 대해서는 Others 라는 flag 로 붙여주세요.


-- 방법 1
SELECT c.first_name, 
	CASE 
		WHEN first_name ILIKE 'A%' THEN 'A'
		WHEN first_name ILIKE 'B%' THEN 'B'
		WHEN first_name ILIKE 'C%' THEN 'C'
		ELSE 'Others'
		END AS "flag"
FROM customer c 


-- 방법 2 substring 활용
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
		

--문제6번) payment 테이블을 기준으로,  2007년 1월~ 3월 까지의 결제일에 해당하며,  staff2번 인원에게 결제를 진행한  결제건에 대해서는, Y 로
--그 외에 대해서는 N 으로 표기해주세요. with 절을 이용해주세요.



--문제7번) Payement 테이블을 기준으로,  결제에 대한 Quarter 분기를 함께 표기해주세요.
--with 절을 활용해서 풀이해주세요.
--1~월의 경우 Q1
--4~6월 의 경우 Q2
--7~9월의 경우 Q3
--10~12월의 경우 Q4



--문제8번) Rental 테이블을 기준으로,  회수일자에 대한 Quater 분기를 함께 표기해주세요.
--with 절을 활용해서 풀이해주세요.
--1~월의 경우 Q1
--4~6월 의 경우 Q2
--7~9월의 경우 Q3
--10~12월의 경우 Q4 로 함께 보여주세요.



--문제9번) 직원이이  월별  대여를 진행 한  대여 갯수가 어떻게 되는 지 알려주세요.
--대여 수량이   아래에 해당 하는 경우에 대해서, 각 flag 를 알려주세요 .
--0~ 500개 의 경우  under_500
--501~ 3000 개의 경우  under_3000
--3001 ~ 99999 개의 경우  over_3001



--문제10번) 직원의 현재 패스워드에 대해서, 새로이  패스워드를 지정하려고 합니다.
--직원1의 새로운 패스워드는 12345  ,  직원2의 새로운 패스워드는 54321입니다.
--해당의 경우, 직원별로 과거 패스워드와 현재 새로이 업데이트할 패스워드를
--함께 보여주세요.
--with 절을 활용하여  새로운 패스워드 정보를 저장 후 , 알려주세요.