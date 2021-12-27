--����1��) ��ȭ ��찡,  ��ȭ 180�� �̻��� ���� �� ��ȭ�� �⿬�ϰų�, ��ȭ�� rating �� R �� ��޿� �ش��ϴ� ��ȭ�� �⿬��  ��ȭ ��쿡 ���ؼ�,  ��ȭ ��� ID �� (180���̻� / R��޿�ȭ)�� ���� Flag �÷��� �˷��ּ���.
--- film_actor ���̺�� film ���̺��� �̿��ϼ���.
--- union, unionall, intersect, except �� ��Ȳ�� �°� ������ּ���.
--- actor_id �� ������ flag �� �� ������ ������ �ʵ��� ���ּ���.

SELECT a.actor_id, 'length' AS flag
FROM actor a 
LEFT OUTER JOIN film_actor fa ON fa.actor_id = a.actor_id 
LEFT OUTER JOIN film f ON f.film_id = fa.film_id 
WHERE f.length >=180
UNION 
SELECT a.actor_id, 'rating' AS flag 
FROM actor a 
LEFT OUTER JOIN film_actor fa ON fa.actor_id = a.actor_id 
LEFT OUTER JOIN film f ON f.film_id = fa.film_id 
WHERE f.rating = 'R'


select actor_id  , 'length_over_180' as flag
from film_actor fa
where film_id  in (
select film_id
from film
where length  >=180
)
union
select   actor_id  , 'rating_R' as flag
from film_actor fa
where film_id  in (
select film_id
from film
where rating ='R'
)

--����2��) R����� ��ȭ�� �⿬�ߴ� ����̸鼭, ���ÿ�, Alone Trip�� ��ȭ�� �⿬��  ��ȭ����� ID �� Ȯ�����ּ���.
--- film_actor ���̺�� film ���̺��� �̿��ϼ���.
--- union, unionall, intersect, except �� ��Ȳ�� �°� ������ּ���.

SELECT fa.actor_id 
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'R')
INTERSECT 
SELECT fa.actor_id
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.title ILIKE 'alone trip')



--����3��) G ��޿� �ش��ϴ� �ʸ��� �������,   ��ȭ�� 20���̻� ���� ���� ��ȭ����� ID �� Ȯ�����ּ���.
--- film_actor ���̺�� film ���̺��� �̿��ϼ���.
--- union, unionall, intersect, except �� ��Ȳ�� �°� ������ּ���.
SELECT actor_id 
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'G')
INTERSECT 
SELECT actor_id
FROM film_actor fa 
GROUP BY fa.actor_id 
HAVING count(fa.actor_id) < 20

--��� : WHERE �������� ���͸��� ������ �߿��� GROUP BY�� �ϱ� ������ �ǵ��� �ٸ��� ����
SELECT actor_id, count(fa.actor_id)
FROM film_actor fa 
WHERE fa.film_id IN (SELECT film_id FROM film f WHERE f.rating = 'G')
GROUP BY fa.actor_id 
HAVING count(fa.actor_id) < 20

--����4��) �ʸ� �߿���,  �ʸ� ī�װ��� Action, Animation, Horror �� �ش����� �ʴ� �ʸ� ���̵� �˷��ּ���.
--- category ���̺��� �̿��ؼ� �˷��ּ���.
SELECT fc.film_id 
FROM film_category fc  
WHERE fc.category_id IN (SELECT c.category_id FROM category c WHERE c.name NOT IN ('Action', 'Animation', 'Horror'))

select film_id
from film
except
select film_id
from film_category fc
where category_id  in (
select  category_id
from category c
where name  in ('Action','Animation','Horror')
)


SELECT fc.category_id, STRING_AGG (fc.film_id ::TEXT , ',' ORDER BY fc.film_id) films
FROM film_category fc 
GROUP BY fc.category_id 
HAVING fc.category_id IN (SELECT c.category_id FROM category c WHERE c.name NOT IN ('Action', 'Animation', 'Horror'))



--����5��) Staff  ��  id , �̸�, �� �� ���� �����Ϳ� , Customer �� id, �̸� , ���� ���� �����͸�  �ϳ���  �����ͼ��� ���·� �����ּ���.
--- �÷� ���� : id, �̸� , ��, flag (����/������) �� �������ּ���.
--
--
--����6��) ������  ���� �̸��� ������ ����� Ȥ�� �ֳ���? �ִٸ�, �ش� ����� �̸��� ���� �˷��ּ���.
--
--
--����7��) �ݳ��� ���� ���� �뿩��(store)�� ��ȭ ��� (inventory)�� ��ü ��ȭ ��� ���� ���ϼ���. (union all)
--
--
--����8��) ����(country)�� ����(city)�� �����, ����(country)����� �Ұ� �׸��� ��ü ������� ���ϼ���. (union all)