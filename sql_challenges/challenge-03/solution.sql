--SQLBOT 10

--Question 1
SELECT *, MAX(Years_employed) FROM employees;

--Question 2
SELECT ROLE, AVG(Years_employed) FROM employees GROUP BY Role;

--Question 3
SELECT *, SUM(Years_employed) FROM employees GROUP BY Building;

--SQLBOT 11

--Question 1
SELECT  COUNT(*) FROM employees WHERE Role="Artist";

--Question 2
SELECT  Role, COUNT(*) FROM employees GROUP BY Role;

--Question 3
SELECT  Role, SUM(Years_employed) FROM employees WHERE Role="Engineer" GROUP BY Role;

--ORACLE

--Question 1

select count(distinct shape) as number_of_shapes,
stddev(distinct weight) as distinct_weight_stddev
from   bricks;
--Question 2

select shape,
       sum(weight) as shape_weight
from   bricks
group by shape;

--Question 3
select shape,
       sum(weight)
from   bricks
group  by shape
having sum(weight) < 4;