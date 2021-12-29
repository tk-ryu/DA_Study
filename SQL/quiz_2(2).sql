--1.주문일이 2017-09-02 일에 해당 하는 주문건에 대해서,? 어떤 고객이, 어떠한 상품에 대해서 얼마를 지불하여? 상품을 구매했는지 확인해주세요.

SELECT orderdate, custfirstname|| ' ' || custlastname AS name, productname, retailprice
FROM orders o 
LEFT OUTER JOIN customers c USING (customerid)
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE orderdate = date('2017-09-02')


--2.헬멧을 주문한 적 없는 고객을 보여주세요.
--- 헬맷은, Products 테이블의 productname 컬럼을 이용해서 확인해주세요.

WITH helmet_orders AS (
SELECT custfirstname || ' ' || custlastname AS full_name
FROM customers c 
RIGHT OUTER JOIN orders o USING (customerid)
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE productname ILIKE '%helmet%'
ORDER BY ordernumber)
SELECT custfirstname || ' ' || custlastname AS full_name
FROM customers 
WHERE custfirstname || ' ' || custlastname NOT IN (SELECT full_name FROM helmet_orders)


--3.모든 제품 과 주문 일자를 나열하세요. (주문되지 않은 제품도 포함해서 보여주세요.)

SELECT p.productname, string_agg(o.orderdate::TEXT , ',' ORDER BY o.orderdate) 
FROM products p 
LEFT OUTER JOIN order_details od USING (productnumber)
LEFT OUTER JOIN orders o USING (ordernumber)
GROUP BY p.productname 

SELECT p.productname, o.orderdate
FROM products p 
LEFT OUTER JOIN order_details od USING (productnumber)
LEFT OUTER JOIN orders o USING (ordernumber)


--4.캘리포니아 주와 캘리포니아 주가 아닌 STATS 로 구분하여 각 주문량을 알려주세요. (CASE문 사용)

WITH tmp AS (
SELECT 
	CASE WHEN c.custstate = 'CA' THEN 'CA'
	ELSE 'Others' 
	END AS State,
	count (ordernumber) AS order_count
FROM customers c 
LEFT OUTER JOIN orders o USING (customerid)
GROUP BY c.custstate 
)
SELECT state, sum(order_count) order_count
FROM tmp
GROUP BY state


--5.공급 업체 와 판매 제품 수를 나열하세요. 단 판매 제품수가 2개 이상인 곳만 보여주세요.

SELECT v.vendorid, v.vendname , count(p.productnumber)
FROM vendors v 
LEFT OUTER JOIN product_vendors pv USING (vendorid)
LEFT OUTER JOIN products p USING (productnumber)
GROUP BY v.vendorid , v.vendname 
HAVING count(p.productnumber) >= 2

--6. 가장 높은 주문 금액을 산 고객은 누구인가요?
--- 주문일자별, 고객의 아이디별로, 주문번호, 주문 금액도 함께 알려주세요.

WITH tmp as(
SELECT od.ordernumber , od.quotedprice * od.quantityordered AS order_price
FROM order_details od
)
SELECT orderdate, customerid, ordernumber, sum(order_price) AS total_order_price
FROM orders o
JOIN tmp USING (ordernumber)
GROUP BY o.orderdate , o.customerid , o.ordernumber
ORDER BY total_order_price DESC 
LIMIT 1



--7.주문일자별로, 주문 갯수와,? 고객수를 알려주세요.
--- ex) 하루에 한 고객이 주문을 2번이상했다고 가정했을때 -> 해당의 경우는 고객수는 1명으로 계산해야합니다.

SELECT orderdate, count(ordernumber) AS order_cnt, count(DISTINCT customerid) AS customer_cnt
FROM orders o 
GROUP BY orderdate 
ORDER BY orderdate 


--8번 생략
--
--9.타이어과 헬멧을 모두 산적이 있는 고객의 ID 를 알려주세요.
--- 타이어와 헬멧에 대해서는 , Products 테이블의 productname 컬럼을 이용해서 확인해주세요.
SELECT customerid
FROM orders o 
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE productname ILIKE '%tire%'
GROUP BY customerid 
INTERSECT
SELECT customerid
FROM orders o 
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE productname ILIKE '%helmet%'
GROUP BY customerid


WITH tire AS (
SELECT customerid, 'tire' AS item, count(productname), string_agg (productname, ',')
FROM orders o 
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE productname ILIKE '%tire%'
GROUP BY customerid 
) , helmet as(
SELECT customerid, 'helmet' AS item, count(productname), string_agg (productname, ',')
FROM orders o 
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE productname ILIKE '%helmet%'
GROUP BY customerid)
SELECT t.customerid, t.item, t.count, h.item, h.count
FROM tire t 
INNER JOIN helmet h ON h.customerid = t.customerid


--10. 타이어는 샀지만, 헬멧을 사지 않은 고객의 ID 를 알려주세요. Except 조건을 사용하여, 풀이 해주세요.
--- 타이어, 헬멧에 대해서는, Products 테이블의 productname 컬럼을 이용해서 확인해주세요.
SELECT customerid
FROM orders o 
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE productname ILIKE '%tire%'
GROUP BY customerid 
EXCEPT 
SELECT customerid
FROM orders o 
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE productname ILIKE '%helmet%'
GROUP BY customerid


WITH tire AS (
	SELECT customerid, 'tire' AS item, count(productname), string_agg (productname, ',')
	FROM orders o 
	LEFT OUTER JOIN order_details od USING (ordernumber)
	LEFT OUTER JOIN products p USING (productnumber)
	WHERE productname ILIKE '%tire%'
	GROUP BY customerid 
) , 
helmet as(
	SELECT customerid, 'helmet' AS item, count(productname), string_agg (productname, ',')
	FROM orders o 
	LEFT OUTER JOIN order_details od USING (ordernumber)
	LEFT OUTER JOIN products p USING (productnumber)
	WHERE productname ILIKE '%helmet%'
	GROUP BY customerid
)
SELECT t.customerid, t.item, t.count, h.item, h.count
FROM tire t 
LEFT JOIN helmet h ON h.customerid = t.customerid
WHERE h.item IS NULL 