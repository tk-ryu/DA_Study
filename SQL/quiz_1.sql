
--문제1번)  각 제품 가격을 5 % 줄이려면 어떻게 해야 할까요?
SELECT retailprice, retailprice * 0.95 AS price_lower_5p
FROM products

--문제2번)  고객이 주문한 목록을 주문 일자로 내림차순 정렬해서 보여주세요.
SELECT *
FROM orders o 
ORDER BY orderdate DESC 

--문제3번)  employees 테이블을 이용하여, 705 아이디를 가진 직원의 , 이름, 성과  해당 직원의  태어난 해를 확인해주세요.
SELECT e.employeeid , e.empfirstname , e.emplastname , date_part('year', e.empbirthdate) AS birth_year
FROM employees e 
WHERE e.employeeid = 705

SELECT e.employeeid , e.empfirstname , e.emplastname , extract('year' from e.empbirthdate) AS birth_year
FROM employees e 
WHERE e.employeeid = 705

--문제4번)  customers 테이블을 이용하여,  고객의 이름과 성을 하나의 컬럼으로 전체 이름을 보여주세요 (이름, 성 의 형태로  full_name 이라는 이름으로 보여주세요)
SELECT c.custfirstname || ' '|| c.custlastname AS full_name
FROM customers c 

--문제5번) orders 테이블을 활용하여, 고객번호가 1001 에 해당하는 사람이 employeeid 가 707인 직원으로부터  산 주문의 id 와 주문 날짜를 알려주세요.
--* 주문일자 빠른순으로 정렬하여, 보여주세요.
SELECT o.ordernumber , o.orderdate , o.customerid , o.employeeid 
FROM orders o 
WHERE o.customerid = 1001
AND employeeid = 707
ORDER BY o.orderdate ASC

--문제6번)  vendors 테이블을 이용하여, 벤더가 위치한 state 주가 어떻게 되는지, 확인해보세요.  중복된 주가 있다면, 중복제거 후에 알려주세요.
SELECT DISTINCT (v.vendstate)
FROM vendors v

--문제7번) 주문일자가  2017-09-02~ 09-03일 사이에 해당하는 주문 번호를 알려주세요.
SELECT o.ordernumber, o.orderdate 
FROM orders o 
WHERE o.orderdate BETWEEN date('2017-09-02') AND date('2017-09-03')

--문제8번) products 테이블을 활용하여, productdescription에 상품 상세 설명 값이 없는  상품 데이터를 모두 알려주세요.
SELECT *
FROM products p 
WHERE p.productdescription IS NULL 

--문제9 번) vendors 테이블을 이용하여, vendor의 State 지역이 NY 또는 WA 인 업체의 이름을 알려주세요.
SELECT v.vendname , v.vendstate 
FROM vendors v 
WHERE v.vendstate = 'NY' OR v.vendstate = 'WA'

--문제10번)  customers 테이블을 이용하여, 고객의 id 별로,  custstate 지역 중 WA 지역에 사는 사람과  WA 가 아닌 지역에 사는 사람을 구분해서  보여주세요.
--- customerid 와, newstate_flag 컬럼으로 구성해주세요 .
--- newstate_flag 컬럼은 WA 와 OTHERS 로 노출해주시면 됩니다.
SELECT c.customerid , 
	CASE WHEN c.custstate = 'WA' THEN 'WA'
		ELSE 'OTHERS' END AS newstate_flag
FROM customers c 
