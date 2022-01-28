-- Query all columns for a city in CITY with the ID 1661.
select *
from city c
where c.id = 1661


-- Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.
select *
from city c
where c.countrycode = 'JPN'

-- Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.
select c.name
from city c
where c.countrycode = 'JPN'

-- Weather Observation Station 
-- 1. Query a list of CITY and STATE from the STATION table.
select s.city, s.state
from station s

-- 3. Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
select distinct s.city
from station s
where mod(s.id, 2) = 0

-- 4. Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
select count(s.city) - count(distinct s.city)
from station s

-- 5. Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
(select s.city, length(s.city)
    from station s
    order by length(s.city) asc, s.city asc
    limit 1)
union all
(select s.city, length(s.city)
    from station s
    order by length(s.city) desc, s.city asc
    limit 1)
    
-- 6. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
select distinct s.city
from station s
where substring(s.city, 1,1) in ('a', 'e', 'i','o','u')

-- 7. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
select distinct s.city
from station s
where substring(s.city, -1,1) in ('a', 'e', 'i','o','u')

-- 8. Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
select distinct s.city
from station s
where substring(s.city, 1,1) in ('a', 'e', 'i','o','u')
and substring(s.city, -1,1) in ('a', 'e', 'i','o','u')

-- 9. Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
select distinct s.city
from station s
where substring(s.city, 1,1) NOT in ('a', 'e', 'i','o','u')

-- 10. Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
select distinct s.city
from station s
where substring(s.city, -1,1) NOT in ('a', 'e', 'i','o','u')

-- 11. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
select distinct s.city
from station s
where substring(s.city, 1,1) not in ('a', 'e', 'i','o','u')
or substring(s.city, -1,1) not in ('a', 'e', 'i','o','u')

-- 12. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
select distinct s.city
from station s
where substring(s.city, 1,1) not in ('a', 'e', 'i','o','u')
and substring(s.city, -1,1) not in ('a', 'e', 'i','o','u')

-- Higher than 75 marks 
-- Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
SELECT s.Name
FROM STUDENTS s
WHERE Marks > 75
ORDER BY substr(s.name, -3), s.id

-- Employee Names
-- Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
select e.name
from employee e
order by e.name 

-- Employee Salaries
-- Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than  per month who have been employees for less than  months. Sort your result by ascending employee_id.
select e.name
from employee e
where e.salary > 2000
and e.months < 10
