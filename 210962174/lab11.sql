-- Q1

create table takes_changes
(ID			varchar(5), 
 course_id		varchar(8),
 sec_id		varchar(8), 
 semester		varchar(6),
 year			numeric(4,0),
 grade		varchar(2),
 time   timestamp(2),
 primary key (ID, course_id, sec_id, semester, year)
);

create or replace trigger q1
after update on takes
for each row
begin
insert into takes_changes values (:New.id, :New.course_id, :New.sec_id, :New.semester, :New.year, :New.grade, CURRENT_TIMESTAMP);
end;
/

update takes
set grade='A' where id=45678 and course_id='CS-319';

-- Q2
create table old_data_instructor
(ID			varchar(5), 
 name			varchar(20) not null, 
 dept_name		varchar(20), 
 salary	numeric(8,2) check (salary > 29000),
 primary key (ID)
);

create or replace trigger q2
before update of salary on instructor
for each row
begin
insert into old_data_instructor values (:Old.id, :Old.name, :Old.dept_name, :Old.salary);
end;
/

update instructor
set salary=100000 where id=12121;

-- Q3
create or replace trigger instructor_check
before insert or update on Instructor
for each row
declare
  dept_budget number;
begin
  if not regexp_like(:New.Name, '^[A-Za-z]+$') then
    raise_application_error(-20001, 'Invalid instructor name. Name must contain only alphabets.');
  end if;
  
  if :New.Salary <= 0 then
    raise_application_error(-20002, 'Salary must be a positive non-zero value.');
  end if;
  
  select Budget into dept_budget from Department where dept_name = :New.dept_name;
  if :New.Salary > dept_budget then
    raise_application_error(-20003, 'Salary exceeds department budget.');
  end if;
end;
/

-- Q4
create table client_master (
  client_no number(10) not null primary key,
  name varchar2(50) not null,
  address varchar2(100) not null,
  bal_due number(10,2) not null
);

create table auditclient (
  client_no number(10) not null,
  name varchar2(50) not null,
  bal_due number(10,2) not null,
  operation varchar2(10) not null,
  opdate date not null
);

create or replace trigger client_audit
before delete or update on client_master
for each row
declare
  op varchar(10);
begin
  if deleting then
    op := 'delete';
    insert into auditclient (client_no, name, bal_due, operation, opdate)
    values (:old.client_no, :old.name, :old.bal_due, op, sysdate);
  else
    op := 'update';
    insert into auditclient (client_no, name, bal_due, operation, opdate)
    values (:old.client_no, :old.name, :old.bal_due, op, sysdate);
  end if;
end;
/

-- Q5
create view Advisor_Student as
select distinct a.i_id as Advisor_ID, s.ID as Student_ID
from Advisor a join Student s on a.s_id = s.ID join Instructor i on a.i_id = i.ID;

create or replace trigger delete_advisor_student
instead of delete on Advisor_Student
for each row
begin
  delete from Advisor where s_id = :old.Student_ID and i_id = :old.Advisor_ID;
end;
/