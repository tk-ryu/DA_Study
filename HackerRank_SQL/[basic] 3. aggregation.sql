-- Revising Aggregations - The Count Function 
-- Query a count of the number of cities in CITY having a Population larger than .
select count(id)
from city c
where population > 100000

-- Revising Aggregations - The Sum Function
-- Query the total population of all cities in CITY where District is California.
select sum(population)
from city c
where c.district = 'California'

-- Revising Aggregations - Averages
-- Query the average population of all cities in CITY where District is California.
select avg(population)
from city c
where c.district = 'California'

-- Average Population
-- Query the average population for all cities in CITY, rounded down to the nearest integer.
select floor(avg(population))
from city

select truncate(avg(population), 0)
from city

-- Japan Population
-- Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
select sum(population)
from city
where countrycode = 'JPN'

-- Population Density Difference
-- Query the difference between the maximum and minimum populations in CITY.
select max(population) - min(population)
from city

-- The Blunder
-- Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's  key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.
-- Write a query calculating the amount of error (i.e.:  average monthly salaries), and round it up to the next integer.
select ceil(avg(salary) - avg(replace(convert(salary, char), '0', '')))
from employees

-- Top Earners
-- We define an employee's total earnings to be their monthly  worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as  space-separated integers.
select (months * salary) as earnings, count(*)
from employee
group by earnings 
order by earnings desc 
limit 1

-- Weather Observation Station 2
-- Query the following two values from the STATION table:
-- 1. The sum of all values in LAT_N rounded to a scale of  decimal places.
-- 2. The sum of all values in LONG_W rounded to a scale of  decimal places.
select round(sum(lat_n), 2), round(sum(long_w), 2)
from station

-- Weather Observation Station 13
-- Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.234. Truncate your answer to 4 decimal places.
select truncate(sum(lat_n), 4)
from station
where lat_n > 38.7880 and lat_n < 137.2345

-- Weather Observation Station 14
-- Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.
select truncate(max(lat_n), 4)
from station
where lat_n < 137.2345

-- Weather Observation Station 15
-- Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345. Round your answer to 4 decimal places.
select round(long_w, 4)
from station
where lat_n < 137.2345
order by lat_n desc
limit 1

-- Weather Observation Station 16
-- Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. Round your answer to 4 decimal places.
select round(lat_n, 4)
from station
where lat_n > 38.7780
order by lat_n 
limit 1

-- Weather Observation Station 17
-- Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7780. Round your answer to 4 decimal places.
select round(long_w, 4)
from station
where lat_n > 38.7780
order by lat_n 
limit 1

-- Weather Observation Station 18
-- Consider P1(a,b) and P2(c,d) to be two points on a 2D plane.
 -- a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
 -- b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
 -- c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
 -- d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
-- Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.
select round(max(lat_n)- min(lat_n) + max(long_w) - min(long_w), 4)
from station

-- Weather Observation Station 19
-- Consider p1(a,c) and p2(b,d) to be two points on a 2D plane where (a,b) are the respective minimum and maximum values of Northern Latitude (LAT_N) and (c,d) are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.
-- Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits.
select truncate(sqrt(pow((max(lat_n) - min(lat_n)), 2) + pow((max(long_w)-min(long_w)), 2)), 4)
from station

