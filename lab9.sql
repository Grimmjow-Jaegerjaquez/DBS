-- Q1
set serveroutput on;

DECLARE 
dname instructor.dept_name%TYPE;
cursor c(test instructor.dept_name%TYPE) is select * from instructor where dept_name = test;

BEGIN
dname := '&dname';
for instructor in c(dname) LOOP
    insert into salary_raise values (instructor.ID, SYSDATE, instructor.salary * 0.05);
    UPDATE Instructor SET salary = salary * 1.05 WHERE current of c;
END LOOP;
END;
/

create table salary_raise(
    instructor_id VARCHAR(5),
    raise_date date,
    raise_amt number(8, 2)
);

-- Q2
set serveroutput on;

DECLARE
cursor c is select * from student order by tot_cred;

BEGIN
for stud in c LOOP
    if c%rowcount < 10 then
        dbms_output.put_line('ID: ' || stud.ID || ', Name: ' || stud.name || ', Dept: ' || stud.dept_name || ', Tot Cred: ' || stud.tot_cred);
    end if;
end loop;
end;
/

-- Q3
set serveroutput on;

DECLARE
cursor c is select * from course;

co number;
i_name instructor.name%TYPE;
sec section%ROWTYPE;

BEGIN
for i in c LOOP
    select count(*) into co from takes group by course_id having course_id = i.course_id;
    select name into i_name from instructor natural join teaches where course_id = i.course_id;
    select * into sec from section where course_id = i.course_id;

    dbms_output.put_line(
        'ID: ' || i.course_id || 
        ', Title: ' || i.title || 
        ', Dept: ' || i.dept_name || 
        ', Credits: ' || i.credits || 
        ', Instructor: ' || i_name || 
        ', Building: ' || sec.building || 
        ', Room: ' || sec.room_number || 
        ', Time-Slot-Id: ' || sec.time_slot_id ||
        ', Count: ' || co
    );
end loop;
end;
/

-- Q4
declare
cursor c is select id from takes natural join student where course_id = 'CS101' and tot_cred < 30;

begin
  for i in c loop
    delete from takes where course_id = 'CS101' and id = i.id;
end loop;
end;
/

-- Q5
declare
    cursor c is select * from StudentTable for update;
    stu_gpa StudentTable.GPA%type;
    grade varchar(2);
begin
    for i in c loop
    stu_gpa:=i.GPA;
    if stu_gpa<4 then grade:='F';
        elsif stu_gpa<5 then grade:='E';
        elsif stu_gpa<6 then grade:='D';
        elsif stu_gpa<7 then grade:='C';
        elsif stu_gpa<8 then grade:='B';
        elsif stu_gpa<9 then grade:='A';
        else grade:='A+';
    end if;
    update StudentTable set LetterGrade=grade where current of c;
end loop;
   end;
/

-- Q6
set serveroutput ON

declare
cor course.course_id%TYPE;
cursor c(cid course.course_id%TYPE) is select name from instructor natural join teaches where course_id = cid; 

begin
cor := '&cor';
for i in c(cor) loop
    dbms_output.put_line('Name: ' || i.name);
end loop;
end;
/

-- Q7
set serveroutput ON

declare
cursor c is select * from advisor;
cursor d is select teaches.id as i_id, takes.id as s_id from teaches, takes where teaches.course_id = takes.course_id;

BEGIN
for i in c loop
    for j in d loop
        if i.s_id = j.s_id and i.i_id = j.i_id then
            dbms_output.put_line('Student: ' || i.s_id || ', Taught By: ' || i.i_id);
        end if;
    end loop;
end loop;
end;
/

-- Q8
set serveroutput on;
declare
    bud number(12, 2);
    sal number(12, 2);
    cursor c is select * from instructor where dept_name='Biology';

begin
commit;

for ins in c loop
    update instructor set salary=salary*1.2 where id=ins.id;
end loop;

select sum(salary) into sal from instructor where dept_name='Biology';
select budget into bud from department where dept_name='Biology';

if bud > sal then
    dbms_output.put_line('Successfully updated salaries with raise of 20 percent.');
else
    rollback;
    dbms_output.put_line('Department Budget not enough to support raise.');
end if;

end;
/