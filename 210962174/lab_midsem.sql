-- Table Creations
create table Donor(
	did	number(4) primary key,
	name varchar(20) not null,
	bloodType varchar(3),
	check( bloodType in ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);

create table Donation(
	id	number(2),
	did number(4),
	city	varchar(10),
	state	varchar(20),
	constraint did_ref foreign key (did) references Donor(did)
);

-- Insertions
insert into Donor values (1000, 'Nanda', 'A+');
insert into Donor values (2000, 'Gopal', 'A+');
insert into Donor values (3000, 'Bala', 'B-');
insert into Donor values (4000, 'Guru', 'AB+');
insert into Donor values (5000, 'Swamy', 'B+');

insert into Donation values (10, 1000, 'MANIPAL', 'KARNATAKA');
insert into Donation values (40, 2000, 'MANIPAL', 'KARNATAKA');
insert into Donation values (30, 2000, 'UDUPI', 'KARNATAKA');
insert into Donation values (30, 3000, 'UDUPI', 'KARNATAKA');
insert into Donation values (10, 4000, 'UDUPI', 'KARNATAKA');
insert into Donation values (40, 4000, 'MANIPAL', 'KARNATAKA');

-- Q2A
select name
from Donor natural join Donation
where bloodType like 'A%' and city='MANIPAL';

-- Q2B
with max_bloodtype(value) as (
	select bloodType
	from Donor
	group by bloodType
	having count(did) >= all(
		select count(did)
		from Donor
		group by bloodType
	)
)
select name
from Donor, max_bloodtype
where bloodType = max_bloodtype.value;