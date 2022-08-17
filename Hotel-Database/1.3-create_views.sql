use HotelDatabase;



-- View giving information about Employees, their salary and what hotel they work in
create view vwEmployeeInfo as
  select h.Name as HotelName, concat(e.FirstName, ' ', e.LastName) as EmployeeFullName, jt.MonthlySalary
  from Hotel as h
    join Employee as e
      on h.HotelID = e.HotelID
    join JobType as jt
      on e.JobTypeID = jt.JobTypeID;



-- View showing guests, how many reservations they made, 
-- and how much they spent in total
create view vwGuestSpendeture as
  select g.GuestID as GuestID, Concat(g.FirstName, ' ', g.LastName) as FullName, Count(1) as TotalReservations, Sum(b.RoomCharge) + Sum(b.BoardCharge) as TotalPayed
  from Guest as g
    join Reservation as res
      on g.GuestID = res.GuestID
    join Bill as b
      on res.ReservationID = b.ReservationID
  group by g.GuestID, Concat(g.FirstName, ' ', g.LastName);



-- View showing how many employees of a given type the hotel chain has,
-- and much it spends on each category
create view vwHotelEmployeeExpenditure as
  select jt.Name as JobName, avg(jt.MonthlySalary) as JobMonthlySalary, Count(1) as NumberOfEmployees, sum(jt.MonthlySalary) as JobTotalExpenditure
  from JobType as jt
    join Employee as e
      on e.JobTypeID = jt.JobTypeID
  group by jt.Name;


-- Show how much each hotel spends on employees per month
  -- (Currently only 1 hotel in the database)
create view vwExpenditureByHotel as
  select h.Name, Sum(jt.MonthlySalary) as MonthlyExpenditure
  from Employee as e
    left join JobType as jt
      on e.JobTypeID = jt.JobTypeID
    join Hotel as h
      on e.HotelID = h.HotelID
  group by h.Name;



-- View showing information about types of rooms and how much each type is used
create view vwRoomTypeUsage as
  select rt.*, Count(1) as NumberOfReservations
  from Reservation as res
    join room as r 
      on res.RoomID = r.RoomID
    join RoomType as rt
      on r.RoomTypeID = rt.RoomTypeID
  group by rt.RoomTypeID, rt.Capacity, rt.PricePerNight


-- Show how many times each board type has been taken (per guest * how long they stayed)
create view vwBoardPopularity as
  select b.*, sum(res.NumOfGuests*DATEDIFF(day, res.StartDate, res.EndDate)) as DaysTaken
  from Board as b
    join Reservation as res
      on res.BoardID = b.BoardID
  group by b.BoardID, b.Type, b.PricePerDay

drop view vwBoardPopularity

select * from Reservation
