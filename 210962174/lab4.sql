-- Q1
select  course_id, count(id)
from takes
group by course_id;

-- Q2
select dept_name
from takes natural join course
group by dept_name
having count(id) > 10;

-- Q3
select dept_name, count(distinct course_id)
from course
group by dept_name;

-- Q4
select dept_name, avg(salary)
from instructor
group by dept_name
having avg(salary) > 42000;

-- Q5
select id, sec_id
from takes natural join section
where year=2009 and semester='Spring';

-- Q6
select course_id
from prereq
order by course_id;

-- Q7
select *
from instructor
order by salary desc;

-- Q8
select dept_name, sum(salary)
from instructor
group by dept_name
having sum(salary) >= all(select sum(salary) from instructor group by dept_name);

-- Q9
select dept_name, avg(salary)
from instructor
group by dept_name
having avg(salary) > 42000;

-- Q10
select sec_id, count(distinct id)
from takes
where year=2010 and semester='Spring'
group by sec_id
having count(distinct id) >= all(
    select count(distinct id)
    from takes
    where year=2010 and semester='Spring'
    group by sec_id
);

-- Q11
select name
from instructor I
where not exists (
    select distinct id
    from takes natural join course
    where dept_name = 'Comp. Sci.'
    minus
    select distinct TA.id
    from teaches T, takes TA
    where T.course_id = TA.course_id and T.year = TA.year and T.semester = TA.semester and T.id = I.id
);

-- Q12
select dept_name, avg(salary)
from instructor
group by dept_name
having avg(salary) > 50000 and count(distinct id) > 5;

-- Q13
with temp(value) as (
    select max(budget)
    from department
)
select dept_name, budget
from department, temp
where budget >= temp.value;

-- Q14
with tot_sal(dept_name, val) as (
    select dept_name, sum(salary)
    from instructor
    group by dept_name
)
select dept_name, val
from tot_sal
where val > (select avg(val) from tot_sal);

-- Q17
savepoint s1;
delete from instructor where dept_name='Comp. Sci.';
rollback to s1;

-- Q18
savepoint s2;
delete from course where dept_name='Comp. Sci.';
rollback to s2;