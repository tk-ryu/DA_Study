-- Binary Tree Nodes
-- You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
-- Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
-- Root: If node is root node.
-- Leaf: If node is leaf node.
-- Inner: If node is neither root nor leaf node.
select N, case
    when P is null then 'Root'
    when N not in (select distinct P from BST where P is not null) then 'Leaf'
    else 'Inner' 
    end
from BST
order by N






-- New Companies
-- https://www.hackerrank.com/challenges/the-company/problem?isFullScreen=true
-- 답 1. 첫번째 방법
select c.company_code, c.founder, lm.lm_count, sm.sm_count, m.m_count, e.e_count
from company c
join (
    select company_code, count(distinct(lead_manager_code)) as lm_count
    from lead_manager
    group by company_code
) as lm on lm.company_code = c.company_code
join (
    select company_code, count(distinct(senior_manager_code)) as sm_count
    from senior_manager
    group by company_code
) as sm on sm.company_code = c.company_code
join (
    select company_code, count(distinct(manager_code)) as m_count
    from manager
    group by company_code
) as m on m.company_code = c.company_code
join (
    select company_code, count(distinct(employee_code)) as e_count
    from employee
    group by company_code
) as e on e.company_code = c.company_code
order by c.company_code

-- 답 2. 좀 더 깔끔한 방법
select c.company_code, c.founder, count(distinct(lm.lead_manager_code)), count(distinct(sm.senior_manager_code)), count(distinct(m.manager_code)), count(distinct(e.employee_code))
from company c
join lead_manager lm on lm.company_code = c.company_code
join senior_manager sm on sm.lead_manager_code = lm.lead_manager_code
join manager m on m.senior_manager_code = sm.senior_manager_code
join employee e on e.manager_code = m.manager_code
group by c.company_code, c.founder
order by company_code