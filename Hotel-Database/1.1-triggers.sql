use HotelDatabase;

-- create trigger aft_ins_Bill_calculate_charge 
--   on Bill 
--     for insert
-- as
--   declare @RoomCharge decimal(11,2)

--   select @RoomCharge = datediff(day, res.StartDate, res.EndDate) * rt.PricePerNight
--   from Inserted as i
--     join Reservation as res
--       on i.ReservationID = res.ReservationID
--     join Room as r
--       on res.RoomID = r.RoomID
--     join RoomType as rt
--       on r.RoomTypeID = rt.RoomTypeID


--   update Bill
--   set RoomCharge = @RoomCharge
--   where BillID = (select BillID from inserted);
-- go;

create trigger aft_ins_Bill_calculate_charge 
  on Bill 
    for insert
as
  declare @RoomCharge decimal(11,2)
  declare @BillID int
  declare @ReservationID int

  declare BillCursor cursor for
  select BillID, ReservationID
  from Inserted

  open BillCursor
  fetch next from BillCursor into @BillID, @ReservationID

  while @@FETCH_STATUS = 0
  begin
    select @RoomCharge = datediff(day, res.StartDate, res.EndDate) * rt.PricePerNight
    from Reservation as res
      join Room as r
        on res.RoomID = r.RoomID
      join RoomType as rt
        on r.RoomTypeID = rt.RoomTypeID
    where res.ReservationID = @ReservationID

    update Bill
    set RoomCharge = @RoomCharge
    where BillID = @BillID;

    fetch next from BillCursor into @BillID, @ReservationID
  end
  
  close BillCursor
go;


drop trigger aft_ins_Bill_calculate_charge;

select b.PaymentType, res.StartDate, res.EndDate, rt.PricePerNight, DATEDIFF(day, res.StartDate, res.EndDate) * rt.PricePerNight  AS DateDiff
from Bill as b
  join Reservation as res
    on b.ReservationID = res.ReservationID
  join Room as r
    on res.RoomID = r.RoomID
  join RoomType as rt
    on r.RoomTypeID = rt.RoomTypeID




-- select p.BusinessEntityID, p.FirstName, p.LastName, bea.BusinessEntityID, bea.AddressID
-- from Person.Person as p 
--     right join Person.BusinessEntityAddress as bea
--         on p.BusinessEntityID = bea.BusinessEntityID
