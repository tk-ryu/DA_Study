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
--
--����7��) �ֹ����ڰ� 2017/09/01 ~ 2017/09/30 �Ͽ� �ش��ϴ� �ֹ��� ���ؼ�
--�ֹ����ڿ� ������ �ֹ� ���� Ȯ�����ּ���.
--���� ���� �ֹ� ���� �Բ� �˷��ּ���.
--
--
--
--
--����8��) �ֹ����ڰ� 2017/09/01 ~ 2017/09/30�Ͽ� �ش��ϴ� �ֹ��� ���ؼ�,
--�ֹ����ڿ� ������ �ֹ� ���� Ȯ�����ּ���.
--���� �ֹ����ں� �ֹ� ���� �Բ� �˷��ֽð�, ��ü �ֹ� ���� �Բ� �˷��ּ���.
--
--
--
--
--����9��) 2017�⵵�� �ֹ��� �� �ֹ� �ݾװ�, ���� �ֹ� �� �ݾ��� �Բ� �����ּ���.
--���ÿ� �Ϻ� �ֹ� �ݾ��� ���� �ֹ� �ݾ׿� �ش��ϴ� ������ ���� �����ּ���. (analytic function Ȱ��)
--
--
--
--����10��) �ֹ��� ���� �� �� ���� ��� ������ �Ű� �����ϼ���. (analytic function Ȱ��)
--- ���� �ֹ� ��ġ �� ��, ���� ����� �����ּ���.