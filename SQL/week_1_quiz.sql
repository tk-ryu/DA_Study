
--����1��)  �� ��ǰ ������ 5 % ���̷��� ��� �ؾ� �ұ��?
SELECT retailprice, retailprice * 0.95 AS price_lower_5p
FROM products

--����2��)  ���� �ֹ��� ����� �ֹ� ���ڷ� �������� �����ؼ� �����ּ���.
SELECT *
FROM orders o 
ORDER BY orderdate DESC 

--����3��)  employees ���̺��� �̿��Ͽ�, 705 ���̵� ���� ������ , �̸�, ����  �ش� ������  �¾ �ظ� Ȯ�����ּ���.
SELECT e.employeeid , e.empfirstname , e.emplastname , date_part('year', e.empbirthdate) AS birth_year
FROM employees e 
WHERE e.employeeid = 705

SELECT e.employeeid , e.empfirstname , e.emplastname , extract('year' from e.empbirthdate) AS birth_year
FROM employees e 
WHERE e.employeeid = 705

--����4��)  customers ���̺��� �̿��Ͽ�,  ���� �̸��� ���� �ϳ��� �÷����� ��ü �̸��� �����ּ��� (�̸�, �� �� ���·�  full_name �̶�� �̸����� �����ּ���)
SELECT c.custfirstname || ' '|| c.custlastname AS full_name
FROM customers c 

--����5��) orders ���̺��� Ȱ���Ͽ�, ����ȣ�� 1001 �� �ش��ϴ� ����� employeeid �� 707�� �������κ���  �� �ֹ��� id �� �ֹ� ��¥�� �˷��ּ���.
--* �ֹ����� ���������� �����Ͽ�, �����ּ���.
SELECT o.ordernumber , o.orderdate , o.customerid , o.employeeid 
FROM orders o 
WHERE o.customerid = 1001
AND employeeid = 707
ORDER BY o.orderdate ASC

--����6��)  vendors ���̺��� �̿��Ͽ�, ������ ��ġ�� state �ְ� ��� �Ǵ���, Ȯ���غ�����.  �ߺ��� �ְ� �ִٸ�, �ߺ����� �Ŀ� �˷��ּ���.
SELECT DISTINCT (v.vendstate)
FROM vendors v

--����7��) �ֹ����ڰ�  2017-09-02~ 09-03�� ���̿� �ش��ϴ� �ֹ� ��ȣ�� �˷��ּ���.
SELECT o.ordernumber, o.orderdate 
FROM orders o 
WHERE o.orderdate BETWEEN date('2017-09-02') AND date('2017-09-03')

--����8��) products ���̺��� Ȱ���Ͽ�, productdescription�� ��ǰ �� ���� ���� ����  ��ǰ �����͸� ��� �˷��ּ���.
SELECT *
FROM products p 
WHERE p.productdescription IS NULL 

--����9 ��) vendors ���̺��� �̿��Ͽ�, vendor�� State ������ NY �Ǵ� WA �� ��ü�� �̸��� �˷��ּ���.
SELECT v.vendname , v.vendstate 
FROM vendors v 
WHERE v.vendstate = 'NY' OR v.vendstate = 'WA'

--����10��)  customers ���̺��� �̿��Ͽ�, ���� id ����,  custstate ���� �� WA ������ ��� �����  WA �� �ƴ� ������ ��� ����� �����ؼ�  �����ּ���.
--- customerid ��, newstate_flag �÷����� �������ּ��� .
--- newstate_flag �÷��� WA �� OTHERS �� �������ֽø� �˴ϴ�.
SELECT c.customerid , 
	CASE WHEN c.custstate = 'WA' THEN 'WA'
		ELSE 'OTHERS' END AS newstate_flag
FROM customers c 
