-- University Database Schema: 
-- Student (ID, name,dept-name, tot-cred) 
-- Instructor(ID, name, dept-name, salary) 
-- Course (Course-id, title,dept-name, credits) 
-- Takes (ID, course-id, sec-id, semester, year, grade) 
-- Classroom (building, room-number, capacity) 
-- Department (dept-name, building, budget) 
-- Section (course-id, section-id, semester, year, building, room-number, time-slot-id) 
-- Teaches (id, course-id, section-id, semester, year) 
-- Advisor(s-id, i-id) 
-- Time-slot (time-slot-id, day, start-time, end-time) 
-- Prereq (course-id, prereq-id) 

-- Q1
select course_id
from teaches
where year=2009 and semester='Fall'
union
select course_id
from teaches
where year=2010 and semester='Spring';

-- Q2
select course_id
from teaches
where year=2009 and semester='Fall'
intersect
select course_id
from teaches
where year=2010 and semester='Spring';

-- Q3
select course_id
from teaches
where year=2009 and semester='Fall'
minus
select course_id
from teaches
where year=2010 and semester='Spring';

-- Q4
select course_id
from course
where course_id not in (select distinct course_id from takes);

-- Q5
select distinct course_id
from teaches
where year=2009 and semester='Fall' and course_id in (
    select distinct course_id from teaches where year=2010 and semester='Spring'
);

-- Q6
select count(distinct takes.id)
from takes
where takes.course_id in (select distinct course_id from teaches where id=10101);

-- Q7
select distinct course_id
from takes
where semester='Fall' and year=2009 and course_id not in (
    select distinct course_id
    from takes
    where semester='Spring' and year=2010
);

-- Q8
select distinct name
from student
where name in (select distinct name from instructor);

-- Q9
select distinct name
from instructor
where salary > some(select salary from instructor where dept_name='Biology');

-- Q10
select distinct name
from instructor
where salary > all(select salary from instructor where dept_name='Biology');

-- Q11
select dept_name
from instructor
group by dept_name
having avg(salary) >= all(select avg(salary) from instructor group by dept_name);

-- Q12
select dept_name
from department
where budget < (select avg(salary) from instructor);

-- Q13
select distinct course_id
from takes T
where semester='Fall' and year=2009 and exists(
    select *
    from takes S
    where semester='Spring' and year=2010 and T.course_id=S.course_id
);

-- Q14
select distinct T.id
from takes T
where not exists(
    select course.course_id
    from course, teaches
    where course.course_id = teaches.course_id and course.dept_name='Biology'
    minus
    select A.course_id
    from takes A, course C
    where T.id = A.id and C.course_id = A.course_id and C.dept_name='Biology'
);

-- Q15
select course_id
from section
where year=2009
group by course_id
having count(course_id) <= 1;

-- Q16
select takes.id
from takes, course
where takes.course_id = course.course_id and course.dept_name = 'Comp. Sci.'
group by takes.id
having count(takes.id) >= 2;

-- Q17
select avg(salary)
from(
    select *
    from instructor
    where instructor.dept_name in (select dept_name from instructor group by dept_name having avg(salary) > 42000)
);

-- Q18
create view all_courses as
select section.course_id, building, room_number
from section, course
where semester='Fall' and year = 2009 and section.course_id = course.course_id and course.dept_name='Physics';

-- Q19
select course from all_courses

-- Q20
create view department_total_salary
as select dept_name, sum(salary) sum_sal
from instructor
group by dept_name;