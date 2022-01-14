--����1��) 4���̻��� ��ü���� �Ǹ��ϴ� ��ǰ��ȣ�� �������� �˷��ּ���.

SELECT productnumber, count(vendorid)
FROM product_vendors pv 
GROUP BY productnumber 
HAVING count(vendorid) >= 4

--����2��) �ֹ����ں�, ���� ���̵𺰷�, �ֹ���ȣ�� �ش��ϴ� �ֹ� �ݾ��� ���ΰ���?

-- �� Ǯ��
SELECT orderdate, ordernumber, customerid, sum(quotedprice * quantityordered)
FROM orders o 
LEFT JOIN customers c USING (customerid)
LEFT JOIN order_details od USING (ordernumber)
GROUP BY orderdate, ordernumber, customerid 
ORDER BY orderdate, ordernumber

-- ��� (�� Ǯ�̿� �� ������ �ٸ�)
select orderdate, customerid, ordernumber,sum(prices) as order_price
from (
        select o.orderdate, o.customerid, o.ordernumber, od.productnumber,
                        od.quotedprice * od.quantityordered as prices
        from orders as o
             join order_details as od on o.ordernumber = od.ordernumber
) as db  
group by orderdate, customerid , ordernumber

-- ��� : orders���� ������, order_details���� ������ ���� �ֹ��� ����.
SELECT *
FROM orders o 
LEFT JOIN order_details od USING (ordernumber)
WHERE quotedprice IS NULL 


--����3��) ���� �̸���, ������ ������ �ϳ��� �̸� ������ �����ּ���.
--- �� �̸��� Ÿ������ �÷��� �����Ͽ� Ÿ���� ��/������ Ÿ�Կ� ���� ���� customer, staff���� ���� �־��ּ���.

SELECT concat(custfirstname, ' ', custlastname) AS name, 'customer' AS "type"
FROM customers c 
UNION ALL
SELECT concat(empfirstname, ' ', emplastname) AS name, 'staff' AS "type"
FROM employees e 
ORDER BY "name"


--����4��) 1�� �ֹ� ��ȣ�� ���ؼ�, ��ǰ��, �ֹ� �ݾװ� 1�� �ֹ� �ݾ׿� ���� �� ���űݾ��� �Բ� �����ּ���.

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


--����5��) ����� �ֹ��� ��� ���� �����Ÿ� �ֹ��� ��� ���� �����ϼ���. (Union Ȱ��) ���� �����Ŵ� Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.

-- Ǯ�� 1. ���� �ƴ϶� � �������� �󸶳� �����ߴ������� ǥ���غ��� 
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

-- Ǯ�� 2. ���� �״�� productname�� �̿��ϸ� �������� ����� �ɷ��� �� ����. (e.g. 'bike helmet' �̶� �������� �����ſ� ����ε�, �����ſ� ��� ��� ī��Ʈ ��)
-- ������ category�� �̿��� ������ �߰��غ� 
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


--����6��) ���� ���� ��ǰ�� ������, ��� ��ǰ �Ҹ� ���ݺ��� ���� ��ǰ�� �̸��� ��ȣ�� �˷��ּ���.
-- ���� ���ذ� �� �ȵǾ�, �ϴ� ���� ���ϴ� �� ��ȸ�غ�
-- 1. �ҸŰ� ���� ���� �� ���(�ֹ�) -> ����
SELECT ordernumber, productnumber, productname, quotedprice, retailprice
FROM order_details od 
LEFT JOIN products p USING (productnumber)
WHERE od.quotedprice > p.retailprice

-- 2. ��� ���԰� ���� ���� �� ���(�ֹ�)
SELECT ordernumber, productnumber, productname, quotedprice, retailprice, "avg"
FROM order_details od 
JOIN (SELECT productnumber, avg(quotedprice), count(productnumber)
FROM order_details od 
GROUP BY productnumber) AS av USING (productnumber)
JOIN products p USING (productnumber)
WHERE quotedprice > "avg"

-- 3. 2�� ������ ��ǰ���� �׷�ȭ
WITH tmp AS (
	SELECT ordernumber, productnumber, productname, quotedprice, retailprice, "avg"
	FROM order_details od 
	JOIN (SELECT productnumber, avg(quotedprice), count(productnumber)
	FROM order_details od 
	GROUP BY productnumber) AS av USING (productnumber)
	JOIN products p USING (productnumber)
	WHERE quotedprice > "avg"
	)
SELECT productnumber, productname, retailprice, "avg", count(ordernumber), string_agg(ordernumber::TEXT , ', ' ORDER BY ordernumber) AS orders
FROM tmp
GROUP BY productnumber, productname, retailprice, "avg"


-- Ǯ��. ��ü ��ǰ �ҸŰ��� ��պ��� ���� ��ǰ�� ã�� �ſ���..?
select distinct od.productnumber, p.productname , od.quotedprice
from order_details as od 
      join products as p on od.productnumber = p.productnumber
where od.quotedprice > (select avg(p.retailprice) as avg_p
                                from products  as p )



--����7��) �ֹ����ڰ� 2017/09/01 ~ 2017/09/30 �Ͽ� �ش��ϴ� �ֹ��� ���ؼ�
--�ֹ����ڿ� ������ �ֹ� ���� Ȯ�����ּ���.
--���� ���� �ֹ� ���� �Բ� �˷��ּ���.

SELECT COALESCE (orderdate::TEXT, 'Customer Total'), customerid, count(ordernumber)
FROM orders o 
WHERE o.orderdate BETWEEN to_date('2017-09-01', 'YYYY/MM/DD') AND to_date('2017-09-30', 'YYYY/MM/DD')
GROUP BY GROUPING SETS (orderdate, customerid), (customerid) 
ORDER BY orderdate 
                               
                                
--����8��) �ֹ����ڰ� 2017/09/01 ~ 2017/09/30�Ͽ� �ش��ϴ� �ֹ��� ���ؼ�,
--�ֹ����ڿ� ������ �ֹ� ���� Ȯ�����ּ���.
--���� �ֹ����ں� �ֹ� ���� �Բ� �˷��ֽð�, ��ü �ֹ� ���� �Բ� �˷��ּ���.

SELECT COALESCE (orderdate::TEXT, 'Total'), COALESCE (customerid::TEXT, 'Day_Total'), count(ordernumber)
FROM orders o 
WHERE o.orderdate BETWEEN to_date('2017-09-01', 'YYYY/MM/DD') AND to_date('2017-09-30', 'YYYY/MM/DD')
GROUP BY ROLLUP (orderdate, customerid)
ORDER BY orderdate 


--����9��) 2017�⵵�� �ֹ��� �� �ֹ� �ݾװ�, ���� �ֹ� �� �ݾ��� �Բ� �����ּ���.
--���ÿ� �Ϻ� �ֹ� �ݾ��� ���� �ֹ� �ݾ׿� �ش��ϴ� ������ ���� �����ּ���. (analytic function Ȱ��)

-- Ǯ�� 1. grouping set Ȱ���ؼ� ���� �Ѿ��� �߰��� ǥ���ϱ� 
-- ratio by month�� ����� �� ������ ����� ��Ÿ���µ� �� �׷��� �𸣰���. �ϴ� *2�� ����.
-- cume_dist�� �������� (����� �ֱ淡 �־)
SELECT EXTRACT('month' FROM o.orderdate) AS "month", 
		coalesce (extract('day' FROM o.orderdate)::TEXT, 'Monthly Total') AS "date", 
		sum(quotedprice * quantityordered) AS "daily sum", 
		sum(quotedprice * quantityordered)/sum(sum(quotedprice * quantityordered)) over(PARTITION BY extract('month' FROM o.orderdate)) * 2 AS "ratio by month",
		cume_dist() OVER(PARTITION BY extract('month' FROM o.orderdate) ORDER BY extract('day' FROM o.orderdate)) AS "cumulative distribution"
FROM orders o 
LEFT JOIN order_details USING (ordernumber)
WHERE extract('year' FROM o.orderdate) = 2017
GROUP BY GROUPING SETS (extract('month' FROM o.orderdate), extract('day' FROM o.orderdate)), extract('month' FROM o.orderdate)

-- Ǯ�� 2. ���� �Ѿ��� Į������ ǥ���� ����
SELECT EXTRACT('month' FROM o.orderdate) AS "month", 
		extract('day' FROM o.orderdate) AS "date", 
		sum(quotedprice * quantityordered) AS "daily sum",
		sum(sum(quotedprice * quantityordered)) over(PARTITION BY extract('month' FROM o.orderdate)) AS "monthly sum",
		sum(quotedprice * quantityordered)/sum(sum(quotedprice * quantityordered)) over(PARTITION BY extract('month' FROM o.orderdate)) AS "ratio by month"
FROM orders o 
LEFT JOIN order_details USING (ordernumber)
WHERE extract('year' FROM o.orderdate) = 2017
GROUP BY extract('month' FROM o.orderdate), extract('day' FROM o.orderdate)


-- ���
select orderdate, 
           sum(product_price) over (partition by orderdate ) as day_price ,
           sum(product_price) over (partition by mm ) as monthly_price,
           sum(product_price) over (partition by orderdate )  / 
           sum(product_price) over (partition by mm )  as perc
from (
       select mm , orderdate , sum(product_price) product_price
       from 
               (
                        select o.ordernumber, orderdate, EXTRACT(month from o.orderdate) as mm, 
                                   od.productnumber, od.quotedprice * od.quantityordered as product_price
                        from orders as o 
                             join order_details as od  on o.ordernumber= od.ordernumber 
                        where o.orderdate between '2017-01-01' and '2017-12-31'
                   ) dt  
                group by mm , orderdate
) as dt 



SELECT *
FROM orders o 
WHERE extract('year' FROM o.orderdate) = 2017

SELECT *
FROM orders o 
WHERE o.orderdate BETWEEN to_date('2017-01-01', 'yyyy/mm/dd') AND to_date('2017-12-31', 'yyyy/mm/dd')

--����10��) �ֹ��� ���� �� �� ���� ��� ������ �Ű� �����ϼ���. (analytic function Ȱ��)
--- ���� �ֹ� ��ġ �� ��, ���� ����� �����ּ���.

SELECT customerid, count(ordernumber), RANK() OVER (ORDER BY count(ordernumber) DESC)
FROM orders o 
GROUP BY customerid 