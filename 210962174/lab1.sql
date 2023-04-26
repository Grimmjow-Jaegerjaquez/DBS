create table employee(
    emp_id number(5),
    emp_name varchar(20),
    emp_address varchar(50)
);

insert into employee values (1, 'n1', 'MANIPAL');
insert into employee values (2, 'n2', 'MANIPAL');
insert into employee values (3, 'n3', 'MANGALORE');
insert into employee values (4, 'n4', 'MANIPAL');
insert into employee values (5, 'n5', 'MANGALORE');

select emp_name from employee;

select * from employee where emp_address='MANIPAL';

alter table employee add(salary number(6));

update employee set salary=5000;

describe employee;

delete from employee where emp_address='MANGALORE';

rename employee to employee1;

drop table employee1;

