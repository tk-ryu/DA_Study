--문제1번) dvd 렌탈 업체의  dvd 대여가 있었던 날짜를 확인해주세요.

SELECT rental_date
FROM rental r 

--DISTINCT는 중복제거
SELECT DISTINCT rental_date
FROM rental

--date는 연-월-일만 반환
SELECT DATE(rental_date)
FROM rental 

SELECT DISTINCT DATE(rental_date)
FROM rental 


--문제2번) 영화길이가 120분 이상이면서, 대여기간이 4일 이상이 가능한, 영화제목을 알려주세요.

SELECT title 
FROM film f 
WHERE f.length > 120 AND f.rental_duration >= 4



--문제3번) 직원의 id 가 2 번인  직원의  id, 이름, 성을 알려주세요
SELECT staff_id, first_name, last_name 
FROM staff s 
WHERE s.staff_id = 2 


--문제4번) 지불 내역 중에서,   지불 내역 번호가 17510 에 해당하는  ,  고객의 지출 내역 (amount ) 는 얼마인가요?
SELECT amount
FROM payment p 
WHERE payment_id = 17510


--문제5번) 영화 카테고리 중에서 ,Sci-Fi  카테고리의  카테고리 번호는 몇번인가요?
SELECT *
FROM category c 
WHERE name = 'Sci-Fi'

--문제6번) film 테이블을 활용하여, rating  등급(?) 에 대해서, 몇개의 등급이 있는지 확인해보세요.
-- distinct로 rating 종류 확인
SELECT DISTINCT rating 
FROM film f 

-- count로 rating 개수 출력
SELECT count(DISTINCT rating) 
FROM film f 


--문제7번) 대여 기간이 (회수 - 대여일) 10일 이상이였던 rental 테이블에 대한 모든 정보를 알려주세요.
--단 , 대여기간은  대여일자부터 대여기간으로 포함하여 계산합니다.




--문제8번) 고객의 id 가  50,100,150 ..등 50번의 배수에 해당하는 고객들에 대해서,
--회원 가입 감사 이벤트를 진행하려고합니다.
--고객 아이디가 50번 배수인 아이디와, 고객의 이름 (성, 이름)과 이메일에 대해서
--확인해주세요.
--
--문제9번) 영화 제목의 길이가 8글자인, 영화 제목 리스트를 나열해주세요.
--
--문제10번)	city 테이블의 city 갯수는 몇개인가요?