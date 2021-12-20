--����1��) film ���̺��� Ȱ���Ͽ�,  film ���̺���  100���� row �� Ȯ���غ�����.
--100�� ����
SELECT *
FROM film f
LIMIT 100

--film_id�� top 100
SELECT *
FROM film f
ORDER BY film_id
LIMIT 100


--����2��) actor �� ��(last_name) ��  Jo �� �����ϴ� ����� id ���� ���� ���� ��� �ѻ���� ���Ͽ�, �����  id ����  �̸�, �� �� �˷��ּ���.

SELECT a.actor_id , a.first_name , a.last_name 
FROM actor a 
WHERE a.last_name LIKE 'Jo%'



-- �� : like�� ��ҹ��� ����
SELECT*
FROM actor a 
WHERE a.last_name LIKE 'jo%'

-- �� : ilike�� ��ҹ��� ���� ���� 
SELECT*
FROM actor a 
WHERE a.last_name ILIKE 'jo%'

--�� : %�� ���ϵ� ī�� (0, 1 Ȥ�� �ټ��� ���� ��� ����)
SELECT*
FROM actor a 
WHERE a.first_name ILIKE 'gre%'

-- �� : _�� �� ���ڸ� 
SELECT*
FROM actor a 
WHERE a.first_name ILIKE 'gre_'

-- �� : �ɺ� ���
SELECT*
FROM actor a 
WHERE a.first_name ~~* 'gre%'

--~~ symbol for LIKE,
--!~~ symbol for NOT LIKE,
--~~* symbol for ILIKE and 
--!~~* symbol for NOT ILIKE.


--����3��)film ���̺��� �̿��Ͽ�, film ���̺��� ���̵��� 1~10 ���̿� �ִ� ��� �÷��� Ȯ�����ּ���.

SELECT *
FROM film f 
WHERE f.film_id < 11

SELECT *
FROM film f 
WHERE f.film_id <=10

SELECT *
FROM film f 
WHERE f.film_id BETWEEN 1 AND 10


--����4��) country ���̺��� �̿��Ͽ�, country �̸��� A �� �����ϴ� country �� Ȯ�����ּ���.

SELECT *
FROM country c 
WHERE c.country LIKE 'A%'


--����5��) country ���̺��� �̿��Ͽ�, country �̸��� s �� ������ country �� Ȯ�����ּ���.

SELECT *
FROM country c 
WHERE c.country LIKE '%s'

--����6��) address ���̺��� �̿��Ͽ�, �����ȣ(postal_code) ���� 77�� �����ϴ�  �ּҿ� ���Ͽ�, address_id, address, district ,postal_code  �÷��� Ȯ�����ּ���.

SELECT a.address_id , a.address , a.district , a.postal_code 
FROM address a 
WHERE a.postal_code ~~ '77%'

--����7��) address ���̺��� �̿��Ͽ�, �����ȣ(postal_code) ����  �ι�°���ڰ� 1�� �����ȣ��  address_id, address, district ,postal_code  �÷��� Ȯ�����ּ���.

SELECT a.address_id , a.address , a.district , a.postal_code 
FROM address a 
WHERE a.postal_code LIKE '_1%'


--����8��) payment ���̺��� �̿��Ͽ�,  ����ȣ�� 341�� �ش� �ϴ� ����� ������ 2007�� 2�� 15~16�� ���̿� �� ��� ���������� Ȯ�����ּ���.

SELECT *
FROM payment p 
WHERE p.customer_id = 341 AND date(p.payment_date) BETWEEN date('2007-02-15') AND date('2007-02-16')

SELECT *
FROM payment p 
WHERE p.customer_id = 341 AND p.payment_date::date BETWEEN date('2007-02-15') AND date('2007-02-16')

SELECT *
FROM payment p 
WHERE p.customer_id = 341 AND p.payment_date::date BETWEEN '2007-02-15'::date AND '2007-02-16'::date



--����9��) payment ���̺��� �̿��Ͽ�, ����ȣ�� 355�� �ش� �ϴ� ����� ���� �ݾ��� 1~3�� ���̿� �ش��ϴ� ��� ���� ������ Ȯ�����ּ���.
SELECT *
FROM payment p 
WHERE p.customer_id = 355
AND p.amount BETWEEN 1 AND 3


--����10��) customer ���̺��� �̿��Ͽ�, ���� �̸��� Maria, Lisa, Mike �� �ش��ϴ� ����� id, �̸�, ���� Ȯ�����ּ���.
SELECT c.customer_id , c.first_name , c.last_name 
FROM customer c 
WHERE c.first_name  LIKE 'Maria' or c.first_name LIKE 'Lisa' OR c.first_name LIKE 'Mike'


--����11��) film ���̺��� �̿��Ͽ�,  film�� ���̰�  100~120 �� �ش��ϰų� �Ǵ� rental �뿩�Ⱓ�� 3~5�Ͽ� �ش��ϴ� film �� ��� ������ Ȯ�����ּ���.
SELECT *
FROM film f 
WHERE f.length BETWEEN 100 AND 120
OR f.rental_duration BETWEEN 3 AND 5


--����12��) address ���̺��� �̿��Ͽ�, postal_code ����  ����('') �̰ų� 35200, 17886 �� �ش��ϴ� address �� ��� ������ Ȯ�����ּ���.
SELECT *
FROM address a 
WHERE a.postal_code = ''
OR a.postal_code = '35200'
OR a.postal_code = '17886'

--����13��) address ���̺��� �̿��Ͽ�,  address �� ���ּ�(=address2) ����  �������� �ʴ� ��� �����͸� Ȯ���Ͽ� �ּ���.
SELECT *
FROM address a 
WHERE a.address2 = ''

SELECT *
FROM address a 
WHERE a.address2 IS NULL 

SELECT *
FROM address a 
WHERE a.address2 IS NULL 
OR a.address2 = ''

--����14��) staff ���̺��� �̿��Ͽ�, staff ��  picture  ������ ���� �ִ�  ������  id, �̸�,���� Ȯ�����ּ���.  �� �̸��� ����  �ϳ��� �÷����� �̸�, �������·�  ���ο� �÷� name �÷����� �������ּ���.
SELECT s.staff_id , concat(s.first_name, ' ', s.last_name) AS name
FROM staff s 
WHERE s.picture IS NOT NULL 

--����15��) rental ���̺��� �̿��Ͽ�,  �뿩�������� ���� �ݳ� ����� ���� �뿩���� ��� ������ Ȯ�����ּ���.
SELECT *
FROM rental r 
WHERE r.rental_date IS NOT NULL  AND r.return_date IS NULL

--����16��) address ���̺��� �̿��Ͽ�, postal_code ����  �� ��(NULL) �̰ų� 35200, 17886 �� �ش��ϴ� address �� ��� ������ Ȯ�����ּ���.
SELECT *
FROM address a 
WHERE a.postal_code IS NULL
OR a.postal_code = ''
OR a.postal_code = '35200'
OR a.postal_code = '17886'

--����17��) ���� ���� John �̶�� �ܾ ����, ���� �̸��� ���� ��� ã���ּ���.
SELECT c.first_name , c.last_name 
FROM customer c 
WHERE c.last_name LIKE '%John%'

--����18��) �ּ� ���̺���, address2 ���� null ���� row ��ü�� Ȯ���غ����?
SELECT *
FROM address a 
WHERE a.address2 IS null