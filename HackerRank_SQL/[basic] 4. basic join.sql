-- Population Census 
-- Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.
-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
select sum(c.population)
from city c
left join country c2 on c.countrycode = c2.code
where c2.continent = 'Asia'

-- African Cities
-- Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.
-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
select c.name
from city c
left join country c2 on c.countrycode = c2.code
where c2.continent = 'Africa'

-- Average Population of Each Continent
-- Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.
-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
-- continent가 아메리카는 null로 되어 있어서 left join 사용하면 틀렸다고 나옴
select continent, floor(avg(c.population))
from city c
join country c2 on c.countrycode = c2.code
group by c2.continent