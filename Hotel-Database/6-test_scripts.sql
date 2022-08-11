use HotelDatabase;


select * from Bill
select * from Room

-- View giving information about Employees, their salary and what hotel they work in
create view EmployeeInfo as
  select h.Name as HotelName, concat(e.FirstName, ' ', e.LastName) as EmployeeName, jt.MontlySalary
  from Hotel as h
    join Employee as e
      on h.HotelID = e.HotelID
    join JobType as jt
      on e.JobTypeID = jt.JobTypeID

drop view EmployeeInfo;

select * from EmployeeInfo

create table test (Type varchar(10), Num int)

insert into test values (null, null), (2, null); 
select * from test

select Type * + 
from test