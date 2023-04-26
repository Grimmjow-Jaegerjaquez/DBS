-- Q1
create or replace procedure q1 as
begin dbms_output.print('Good Day to You'); end;
/

set serveroutput on
begin q1; end;
/

-- Q2
create or replace procedure q2(dept instructor.dept_name%TYPE) as
cursor c1 is select name from instructor where dept_name=dept;
cursor c2 is select title from course where dept_name=dept;
begin
dbms_output.put_line('INSTRUCTORS');
for i in c1 loop
    dbms_output.put_line(i.name);
end loop;
dbms_output.put_line('COURSES');
for i in c2 loop
    dbms_output.put_line(i.title);
end loop;
end;
/

declare dept instructor.dept_name%TYPE;
begin
dept := '&dept';
q2(dept);
end;
/

-- Q3
create or replace procedure course_popular(dept course.dept_name%TYPE) as
cursor c is 
    select title -- into most_popular
    from course natural join takes
    where dept_name=dept
    group by course_id, title
    having count(id) >= all(select count(id) from course natural join takes where dept_name=dept group by course_id);

begin
dbms_output.put_line(chr(10));
dbms_output.put_line('Dept: ' || dept);
dbms_output.put_line('Courses: ');
for i in c loop
    dbms_output.put_line(i.title);
end loop;
end;
/

create or replace procedure q3 as
cursor c is select unique dept_name from department;
begin
for i in c loop
    course_popular(i.dept_name);
end loop;
end;
/

begin q3; end;
/

-- Q4
create or replace procedure q4(dept instructor.dept_name%TYPE) as
cursor c1 is select unique name from course natural join takes natural join student where dept_name=dept;
cursor c2 is select title from course where dept_name=dept;
begin
dbms_output.put_line('STUDENTS');
for i in c1 loop
    dbms_output.put_line(i.name);
end loop;
dbms_output.put_line('COURSES');
for i in c2 loop
    dbms_output.put_line(i.title);
end loop;
end;
/

declare dept instructor.dept_name%TYPE;
begin
dept := '&dept';
q4(dept);
end;
/

-- Q5
create or replace function square(num number) return number as
sq number;
begin
sq := num * num;
return sq;
end;
/

begin
    dbms_output.put_line(square(5));
end;
/

-- Q6
create or replace function department_highest(dept department.dept_name%TYPE) RETURN instructor.name%TYPE as
ans instructor.name%TYPE;
begin
    select name into ans-- into most_popular
    from instructor
    where dept_name=dept and salary >= all(select salary from instructor where dept_name=dept);
    return ans;
end;
/

create or replace procedure q6 as
cursor c is select unique dept_name from department;
begin
for i in c loop
    dbms_output.put_line('Dept: ' || i.dept_name || ', Highest: ' || department_highest(i.dept_name));
end loop;
end;
/

begin q6; end;
/

-- Additional Q6
create or replace function hike_budget(dept department.dept_name%TYPE, budget in out department.budget%TYPE) 
return  department.budget%TYPE as
begin
budget := budget * 1.1;
return budget;
end;
/

create or replace procedure aq6(dept department.dept_name%TYPE) as
old_budget department.budget%TYPE;
budget department.budget%TYPE;
begin
select budget into budget from department where department.dept_name=dept;
old_budget := budget;
dbms_output.put_line('Dept: ' || dept || ', Old Budget: ' || old_budget || ', New Budget: ' || hike_budget(dept, budget));
end;
/

begin aq6('Comp. Sci.'); end;
/