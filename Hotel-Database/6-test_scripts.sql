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
      on e.JobTypeID = jt.JobTypeID;

select * from EmployeeInfo
drop view EmployeeInfo;

create view CustomerSpendeture as
  select g.GuestID as GuestID, Concat(g.FirstName, ' ', g.LastName) as FullName, Count(*) as TotalReservations, Sum(b.RoomCharge) + Sum(b.BoardCharge) as TotalPayed
  from Guest as g
    join Reservation as res
      on g.GuestID = res.GuestID
    join Bill as b
      on res.ReservationID = b.ReservationID
  group by g.GuestID, Concat(g.FirstName, ' ', g.LastName);

select * from CustomerSpendeture;
drop view CustomerSpendeture;

create view HotelEmployeeExpenditure as
  select jt.Name as JobName, Count(1) as NumberOfEmployees, sum(jt.MontlySalary) as TotalExpenditure
  from JobType as jt
    join Employee as e
      on e.JobTypeID = jt.JobTypeID
  group by jt.Name;


select * from HotelEmployeeExpenditure;
drop view HotelEmployeeExpenditure;


create table test (Type varchar(10), Num int)

insert into test values (null, null), (2, null); 
select * from test

select Type * + 
from test