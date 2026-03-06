--ORACLE FreeSQL

--Question 1

select b.*,
       count(*) over (
         partition by shape
       ) bricks_per_shape,
       median ( weight ) over (
         partition by shape
       ) median_weight_per_shape
from   bricks b
order  by shape, weight, brick_id;


--Question 2

select b.brick_id, b.weight,
       round ( avg ( weight ) over (
         order by BRICK_ID ASC
       ), 2 ) running_average_weight
from   bricks b
order  by brick_id;

--Question 3

select b.*,
       min ( colour ) over (
         order by brick_id
         rows between 2 preceding and 1 preceding
       ) first_colour_two_prev,
       count (*) over (
         order by weight
         range between current row and 1 following
       ) count_values_this_and_next
from   bricks b
order  by weight;

--Question 4
with totals as (
  select b.*,
         sum ( weight ) over (
           partition by shape
         ) weight_per_shape,
         sum ( weight ) over (
           order by b.BRICK_ID
         ) running_weight_by_id
  from   bricks b
)
select * from totals
where  weight_per_shape > 4 AND running_weight_by_id > 4
order  by brick_id

--DataLemut

--Question 1

with salary as (
    SELECT *,
        DENSE_RANK() over (
        PARTITION by department_id ORDER BY salary DESC) as ranking
    FROM employee
)

SELECT  d.department_name, s.name, s.salary
FROM salary as s

Inner JOIN department as d
  ON s.department_id = d.department_id

where ranking <= 3
ORDER BY d.department_name ASC, s.salary DESC, s.name ASC;



