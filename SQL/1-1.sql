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
