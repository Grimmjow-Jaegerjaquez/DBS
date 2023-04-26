-- Q1a
select bdate, address
from employee
where fname='John' and minit='B' and lname='Smith';

-- Q1b
select fname, minit, lname
from employee, department
where Dno=Dnumber and Dno=5;

-- Q2
select Pnumber, Dnum, lname, address, bdate
from project, employee, department
where project.Dnum = department.Dnumber and department.Mgr_ssn = employee.Ssn and Plocation = 'Stafford';

-- Q3
select distinct Salary
from employee;

-- Q4
select A.fname as fname, A.lname as lname, B.fname as sup_fname, B.lname as sup_lname
from employee A, employee B
where B.Ssn = A.Super_ssn;

-- Q5
select Pno
from works_on, employee
where works_on.Essn = employee.Ssn and employee.Lname = 'Smith'
union
select Pnumber
from project, department, employee
where project.Dnum = department.Dnumber and department.Mgr_ssn = employee.Ssn and employee.Lname='Smith';

-- Q6
select * from employee
where address like '%Houston%TX';

-- Q7
select employee.Salary * 1.10 as New_Salary
from works_on, employee
where works_on.Pno = 1 and works_on.Essn = employee.Ssn;

-- Q8
select * from employee
where employee.Dno=5 and employee.Salary between 30000 and 40000;

-- Q9
select Dname, Lname, Fname, Pname 
from employee, works_on, project, department
where works_on.Essn = employee.Ssn and works_on.Pno = project.Pnumber and employee.Dno = department.Dnumber
order by Dname, employee.Lname, employee.Fname;

-- Q10
select * from employee
where Super_ssn is null;

-- Q11
select * from dependent, employee
where dependent.Essn = employee.Ssn and employee.Fname = dependent.Dependent_name and employee.Sex = dependent.Sex;

-- Q12
select * from employee
where employee.Ssn not in (select Essn from dependent);

-- Q13
select * from employee
where 
    employee.Ssn in (select distinct Mgr_ssn from department) and
    employee.Ssn in (select distinct Essn from dependent);

-- Q14
select distinct Essn
from works_on
where Pno in (1, 2, 3);

-- Q15
select Sum(Salary), Max(Salary), Min(Salary), avg(salary)
from employee;

-- Q16
select Sum(Salary), Max(Salary), Min(Salary), avg(salary)
from employee, department
where Dno=Dnumber and Dnumber=5;

-- Q17
select Pno, Pname, count(Essn)
from works_on, project
where works_on.Pno = project.Pnumber
group by Pno, Pname;

-- Q18
select Pno, Pname, count(Essn)
from works_on, project
where works_on.Pno = project.Pnumber
group by Pno, Pname
having count(Essn) > 2;