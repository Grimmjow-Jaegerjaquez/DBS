-- Q1
create table employee(
    emp_no number(5),
    emp_name varchar(20) not null,
    gender char(1) not null,
    salary number(8, 2) not null,
    address varchar(20) not null,
    DNo integer,
    check(gender in ('M', 'F')),
    primary key(emp_no)
);

-- Q2
create table departments(
    DeptNo number(5) primary key,
    DeptName varchar(20) unique,
    Location varchar(20)
);

-- Q3

alter table employee
    add constraint dno foreign key (DNo) references departments(DeptNo);

-- Q4
insert into departments values (1, 'd1', 'l1');
insert into departments values (2, 'd2', 'l1');
insert into departments values (3, 'd3', 'l2');

insert into employee values (1, 'e1', 'M', 5000, 'l1', 1);
insert into employee values (2, 'e2', 'F', 5000, 'l1', 2);

--Q5
insert into employee values (2, 'e3', 'F', 5000, 'l1', 2);

-- Q6
delete from departments where DeptNo=1;

-- Q7
alter table employee
    drop constraint dno;

alter table employee
    add constraint dno foreign key (DNo) references departments(DeptNo) on delete cascade;

-- Q8
alter table employee
    drop column salary;
alter table employee
    add constraint sal salary number(8, 2) default 10000;

-- Q9
select name, dept_name
from student

-- Q10
select *
from instructor
where instructor.dept_name='Comp. Sci.';

-- Q11
select *
from course
where course.credits=3

-- Q12
select takes.course_id, course.title
from takes, course
where id=12345 and course.course_id = takes.course_id;

-- Q13
select *
from instructor
where salary between 40000 and 90000;

-- Q14
select distinct id
from instructor
minus
select distinct id
from teaches;

-- Q15
select name, title, year
from student natural join takes natural join course natural join section
where room_number = 514;

-- Q16
select name, title as c_name
from student natural join takes natural join course
where year = 2009;

-- Q17
select distinct T.name, T.salary as inst_salary
from instructor T, instructor S
where T.salary > S.salary and S.dept_name = 'Comp. Sci.';

-- Q18
select name
from instructor
where dept_name like '%Co%';

-- Q19
select name, length(name) as len
from student;

-- Q20
select dept_name, substr(dept_name, 3, 3)
from department;

-- Q21
select upper(name)
from instructor;

-- Q22
select id, course_id, nvl(grade, 0)
from takes;

-- Q23
select salary, round(salary/3, -2)
from instructor;

-- Q24
alter table employee
add dob date default TO_DATE('12-09-2014', 'DD-MM-YYYY');

select dob, TO_CHAR(dob, 'DD-MON-YYYY'), TO_CHAR(dob, 'DD-MON-YY'), TO_CHAR(dob, 'DD-MM-YY')
from employee;

-- Q25
select emp_name, TO_CHAR(dob, 'YEAR'),  TO_CHAR(dob, 'Year'),  TO_CHAR(dob, 'year')
from employee;

-- Q25
select emp_name, TO_CHAR(dob, 'DAY'),  TO_CHAR(dob, 'Day')
from employee;

-- Q25
select emp_name, TO_CHAR(dob, 'MONTH'),  TO_CHAR(dob, 'Month'),  TO_CHAR(dob, 'year')
from employee;