--1.�ֹ����� 2017-09-02 �Ͽ� �ش� �ϴ� �ֹ��ǿ� ���ؼ�,? � ����, ��� ��ǰ�� ���ؼ� �󸶸� �����Ͽ�? ��ǰ�� �����ߴ��� Ȯ�����ּ���.

SELECT orderdate, custfirstname|| ' ' || custlastname AS name, productname, retailprice
FROM orders o 
LEFT OUTER JOIN customers c USING (customerid)
LEFT OUTER JOIN order_details od USING (ordernumber)
LEFT OUTER JOIN products p USING (productnumber)
WHERE orderdate = date('2017-09-02')


--2.����� �ֹ��� �� ���� ���� �����ּ���.
--- �����, Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.

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


--3.��� ��ǰ �� �ֹ� ���ڸ� �����ϼ���. (�ֹ����� ���� ��ǰ�� �����ؼ� �����ּ���.)

SELECT p.productname, string_agg(o.orderdate::TEXT , ',' ORDER BY o.orderdate) 
FROM products p 
LEFT OUTER JOIN order_details od USING (productnumber)
LEFT OUTER JOIN orders o USING (ordernumber)
GROUP BY p.productname 

SELECT p.productname, o.orderdate
FROM products p 
LEFT OUTER JOIN order_details od USING (productnumber)
LEFT OUTER JOIN orders o USING (ordernumber)


--4.Ķ�����Ͼ� �ֿ� Ķ�����Ͼ� �ְ� �ƴ� STATS �� �����Ͽ� �� �ֹ����� �˷��ּ���. (CASE�� ���)

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


--5.���� ��ü �� �Ǹ� ��ǰ ���� �����ϼ���. �� �Ǹ� ��ǰ���� 2�� �̻��� ���� �����ּ���.

SELECT v.vendorid, v.vendname , count(p.productnumber)
FROM vendors v 
LEFT OUTER JOIN product_vendors pv USING (vendorid)
LEFT OUTER JOIN products p USING (productnumber)
GROUP BY v.vendorid , v.vendname 
HAVING count(p.productnumber) >= 2

--6. ���� ���� �ֹ� �ݾ��� �� ���� �����ΰ���?
--- �ֹ����ں�, ���� ���̵𺰷�, �ֹ���ȣ, �ֹ� �ݾ׵� �Բ� �˷��ּ���.
--
--
--7.�ֹ����ں���, �ֹ� ������,? ������ �˷��ּ���.
--- ex) �Ϸ翡 �� ���� �ֹ��� 2���̻��ߴٰ� ���������� -> �ش��� ���� ������ 1������ ����ؾ��մϴ�.
--
--8�� ����
--
--9.Ÿ�̾�� ����� ��� ������ �ִ� ���� ID �� �˷��ּ���.
--
--- Ÿ�̾�� ��信 ���ؼ��� , Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.
--
--
--10. Ÿ�̾�� ������, ����� ���� ���� ���� ID �� �˷��ּ���. Except ������ ����Ͽ�, Ǯ�� ���ּ���.
--- Ÿ�̾�, ��信 ���ؼ���, Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.