--����1��) dvd ��Ż ��ü��  dvd �뿩�� �־��� ��¥�� Ȯ�����ּ���.

SELECT rental_date
FROM rental r 

--DISTINCT�� �ߺ�����
SELECT DISTINCT rental_date
FROM rental

--date�� ��-��-�ϸ� ��ȯ
SELECT DATE(rental_date)
FROM rental 

SELECT DISTINCT DATE(rental_date)
FROM rental 


--����2��) ��ȭ���̰� 120�� �̻��̸鼭, �뿩�Ⱓ�� 4�� �̻��� ������, ��ȭ������ �˷��ּ���.

SELECT title 
FROM film f 
WHERE f.length > 120 AND f.rental_duration >= 4



--����3��) ������ id �� 2 ����  ������  id, �̸�, ���� �˷��ּ���
SELECT staff_id, first_name, last_name 
FROM staff s 
WHERE s.staff_id = 2 


--����4��) ���� ���� �߿���,   ���� ���� ��ȣ�� 17510 �� �ش��ϴ�  ,  ���� ���� ���� (amount ) �� ���ΰ���?
SELECT amount
FROM payment p 
WHERE payment_id = 17510


--����5��) ��ȭ ī�װ� �߿��� ,Sci-Fi  ī�װ���  ī�װ� ��ȣ�� ����ΰ���?
SELECT *
FROM category c 
WHERE name = 'Sci-Fi'

--����6��) film ���̺��� Ȱ���Ͽ�, rating  ���(?) �� ���ؼ�, ��� ����� �ִ��� Ȯ���غ�����.
-- distinct�� rating ���� Ȯ��
SELECT DISTINCT rating 
FROM film f 

-- count�� rating ���� ���
SELECT count(DISTINCT rating) 
FROM film f 


--����7��) �뿩 �Ⱓ�� (ȸ�� - �뿩��) 10�� �̻��̿��� rental ���̺� ���� ��� ������ �˷��ּ���.
--�� , �뿩�Ⱓ��  �뿩���ں��� �뿩�Ⱓ���� �����Ͽ� ����մϴ�.




--����8��) ���� id ��  50,100,150 ..�� 50���� ����� �ش��ϴ� ���鿡 ���ؼ�,
--ȸ�� ���� ���� �̺�Ʈ�� �����Ϸ����մϴ�.
--�� ���̵� 50�� ����� ���̵��, ���� �̸� (��, �̸�)�� �̸��Ͽ� ���ؼ�
--Ȯ�����ּ���.
--
--����9��) ��ȭ ������ ���̰� 8������, ��ȭ ���� ����Ʈ�� �������ּ���.
--
--����10��)	city ���̺��� city ������ ��ΰ���?