-- Type of Triangle 
-- Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:
-- Equilateral: It's a triangle with  sides of equal length.
-- Isosceles: It's a triangle with  sides of equal length.
-- Scalene: It's a triangle with  sides of differing lengths.
-- Not A Triangle: The given values of A, B, and C don't form a triangle.

select case 
        when A >= B+C or B >= A+C or C >= A+B then 'Not A Triangle'
        when A = B and A = C then 'Equilateral'
        when A = B and A != C then 'Isosceles'
        when A != B and A = C then 'Isosceles'
        when A != B and B = C then 'Isosceles'
        when A != B and A != C and B != C then 'Scalene'
        end
from triangles

---

select case 
        when A >= B+C or B >= A+C or C >= A+B then 'Not A Triangle'
        when A = B and A = C then 'Equilateral'
        when A = B or A = C or B = C then 'Isosceles'
        else 'Scalene'
        end
from triangles

-- The PADS
-- Generate the following two result sets:
-- 1. Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
-- 2. Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:
-- There are a total of [occupation_count] [occupation]s.
-- where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.
-- Note: There will be at least two entries in the table for each type of occupation.

select concat(name , '(' , substr(occupation, 1, 1) , ')')
from occupations o
order by name;

select concat('There are a total of ', count(occupation), ' ', lower(occupation), 's.')
from occupations
group by occupation
order by count(occupation), occupation;


-- union 사용시 각 서브쿼리마다 order by 적용이 불가능하다 
select t1.*
from (select concat(name , '(' , substr(occupation, 1, 1) , ')')
    from occupations o
    order by name) as t1
union all
select t2.*
from (select concat('There are a total of ', count(occupation), ' ', lower(occupation), 's.')
    from occupations
    group by occupation
    order by count(occupation), occupation) as t2
    
-- Occupations
-- Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
-- Note: Print NULL when there are no more names corresponding to an occupation.
select  
    max(case when occupation = 'Doctor' then name end) 'Doctor',
    max(case when occupation = 'Professor' then name end) 'Professor',
    max(case when occupation = 'Singer' then name end) 'Singer',
    max(case when occupation = 'Actor' then name end) 'Actor'
from (
  select *, row_number() over (partition by occupation order by name) rn
  from occupations
) t
group by rn