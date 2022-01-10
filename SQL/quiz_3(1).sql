--문제1번) 4개이상의 업체에서 판매하는 상품번호가 무엇인지 알려주세요.

SELECT productnumber, count(vendorid)
FROM product_vendors pv 
GROUP BY productnumber 
HAVING count(vendorid) >= 4

--문제2번) 주문일자별, 고객의 아이디별로, 주문번호에 해당하는 주문 금액은 얼마인가요?

-- 내 풀이
SELECT orderdate, ordernumber, customerid, sum(quotedprice * quantityordered)
FROM orders o 
LEFT JOIN customers c USING (customerid)
LEFT JOIN order_details od USING (ordernumber)
GROUP BY orderdate, ordernumber, customerid 
ORDER BY orderdate, ordernumber

-- 답안 (내 풀이와 행 개수가 다름)
select orderdate, customerid, ordernumber,sum(prices) as order_price
from (
        select o.orderdate, o.customerid, o.ordernumber, od.productnumber,
                        od.quotedprice * od.quantityordered as prices
        from orders as o
             join order_details as od on o.ordernumber = od.ordernumber
) as db  
group by orderdate, customerid , ordernumber

-- 비고 : orders에는 있으나, order_details에는 정보가 없는 주문이 있음.
SELECT *
FROM orders o 
LEFT JOIN order_details od USING (ordernumber)
WHERE quotedprice IS NULL 


--문제3번) 고객의 이름과, 직원의 정보를 하나의 이름 정보로 보여주세요.
--- 단 이름과 타입으로 컬럼을 구성하여 타입은 고객/직원의 타입에 따라 각각 customer, staff으로 값을 넣어주세요.

SELECT concat(custfirstname, ' ', custlastname) AS name, 'customer' AS "type"
FROM customers c 
UNION ALL
SELECT concat(empfirstname, ' ', emplastname) AS name, 'staff' AS "type"
FROM employees e 
ORDER BY "name"


--문제4번) 1번 주문 번호에 대해서, 상품명, 주문 금액과 1번 주문 금액에 대한 총 구매금액을 함께 보여주세요.

WITH tmp AS (
	SELECT ordernumber, productname, quotedprice * quantityordered AS order_price
	FROM orders o 
	LEFT JOIN order_details od USING (ordernumber)
	LEFT JOIN products p USING (productnumber)
	WHERE ordernumber = 1
	)
SELECT *
FROM tmp
UNION ALL
SELECT ordernumber, 'TOTAL', sum(order_price)
FROM tmp
GROUP BY ordernumber


--문제5번) 헬멧을 주문한 모든 고객과 자전거를 주문한 모든 고객을 나열하세요. (Union 활용) 헬멧과 자전거는 Products 테이블의 productname 컬럼을 이용해서 확인해주세요.

-- 풀이 1. 고객뿐 아니라 어떤 아이템을 얼마나 구매했는지까지 표시해보기 
WITH helmet AS (
	SELECT customerid, 'helmet' AS item, count(productname) AS helmet_cnt, string_agg(productname, ',') AS product , string_agg(ordernumber::TEXT, ',') AS ordernumbers
	FROM orders o 
	LEFT JOIN customers c USING (customerid)
	LEFT JOIN order_details od USING (ordernumber)
	LEFT JOIN products p USING (productnumber)
	WHERE p.productname ILIKE '%helmet%'
	GROUP BY customerid 
	),
	bike AS (	
	SELECT customerid, 'bike' AS item, count(productname) AS bike_cnt, string_agg(productname, ',') AS product , string_agg(ordernumber::TEXT, ',') AS ordernumbers
	FROM orders o 
	LEFT JOIN customers c USING (customerid)
	LEFT JOIN order_details od USING (ordernumber)
	LEFT JOIN products p USING (productnumber)
	WHERE p.productname ILIKE '%bike%'
	GROUP BY customerid  
	)
SELECT customerid, string_agg(item, ',' ORDER BY item DESC) AS item, string_agg(helmet_cnt::TEXT, ',' ORDER BY helmet_cnt DESC) AS cnt
FROM (
	SELECT customerid, item, helmet_cnt
	FROM helmet
	UNION ALL
	SELECT customerid, item, bike_cnt
	FROM bike
	) AS tmp
GROUP BY customerid
ORDER BY customerid

-- 풀이 2. 문제 그대로 productname만 이용하면 아이템을 제대로 걸러낼 수 없음. (e.g. 'bike helmet' 이란 아이템은 자전거용 헬멧인데, 자전거와 헬멧 모두 카운트 됨)
-- 때문에 category를 이용한 조건을 추가해봄 
SELECT *
FROM categories

WITH helmet AS (
	SELECT customerid, 'helmet' AS item, count(productname) AS helmet_cnt, string_agg(productname, ',') AS product , string_agg(ordernumber::TEXT, ',') AS ordernumbers
	FROM orders o 
	LEFT JOIN customers c USING (customerid)
	LEFT JOIN order_details od USING (ordernumber)
	LEFT JOIN products p USING (productnumber)
	WHERE p.productname ILIKE '%helmet%'
	 AND p.categoryid = 1
	GROUP BY customerid 
	),
	bike AS (	
	SELECT customerid, 'bike' AS item, count(productname) AS bike_cnt, string_agg(productname, ',') AS product , string_agg(ordernumber::TEXT, ',') AS ordernumbers
	FROM orders o 
	LEFT JOIN customers c USING (customerid)
	LEFT JOIN order_details od USING (ordernumber)
	LEFT JOIN products p USING (productnumber)
	WHERE p.productname ILIKE '%bike%'
		AND p.categoryid = 2
	GROUP BY customerid  
	)
SELECT customerid, string_agg(item, ',' ORDER BY item DESC) AS item, string_agg(helmet_cnt::TEXT, ',' ORDER BY helmet_cnt DESC) AS cnt
FROM (
	SELECT customerid, item, helmet_cnt
	FROM helmet
	UNION ALL
	SELECT customerid, item, bike_cnt
	FROM bike
	) AS tmp
GROUP BY customerid
ORDER BY customerid


--문제6번) 고객이 구매 제품의 가격이, 평균 제품 소매 가격보다 높은 제품의 이름과 번호를 알려주세요.
--
--문제7번) 주문일자가 2017/09/01 ~ 2017/09/30 일에 해당하는 주문에 대해서
--주문일자와 고객별로 주문 수를 확인해주세요.
--또한 고객별 주문 수도 함께 알려주세요.
--
--
--
--
--문제8번) 주문일자가 2017/09/01 ~ 2017/09/30일에 해당하는 주문에 대해서,
--주문일자와 고객별로 주문 수를 확인해주세요.
--또한 주문일자별 주문 수도 함께 알려주시고, 전체 주문 수도 함께 알려주세요.
--
--
--
--
--문제9번) 2017년도의 주문일 별 주문 금액과, 월별 주문 총 금액을 함께 보여주세요.
--동시에 일별 주문 금액이 월별 주문 금액에 해당하는 비율을 같이 보여주세요. (analytic function 활용)
--
--
--
--문제10번) 주문을 많이 한 고객 순서 대로 순위를 매겨 나열하세요. (analytic function 활용)
--- 같은 주문 수치 일 때, 같은 등수로 보여주세요.