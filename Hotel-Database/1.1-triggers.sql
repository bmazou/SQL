use HotelDatabase;


-- Trigger calculating price of stay
create trigger aft_ins_Bill_calculate_charge 
  on Bill 
    for insert, update
as
  declare @RoomCharge decimal(11,2)
  declare @BoardCharge decimal(11,2)
  declare @BillID int
  declare @ReservationID int

  declare BillCursor cursor for
  select BillID, ReservationID
  from Inserted

  open BillCursor
  fetch next from BillCursor into @BillID, @ReservationID

  while @@FETCH_STATUS = 0
  begin
    -- Calculate how much the room will cost
    select @RoomCharge = datediff(day, res.StartDate, res.EndDate) * rt.PricePerNight
    from Reservation as res
      join Room as r
        on res.RoomID = r.RoomID
      join RoomType as rt
        on r.RoomTypeID = rt.RoomTypeID
    where res.ReservationID = @ReservationID

    update Bill
    set RoomCharge = @RoomCharge
    where BillID = @BillID

    -- Calculate how much the Board will cost, depending on its type, number of people and length of stay
    select @BoardCharge = datediff(day, res.StartDate, res.EndDate) * b.PricePerDay * res.NumOfGuests 
    from Reservation as res
      join Board as b
        on b.BoardID = res.BoardID
    where res.ReservationID = @ReservationID

    update Bill
    set BoardCharge = @BoardCharge
    where BillID = @BillID

    fetch next from BillCursor into @BillID, @ReservationID
  end
  
  close BillCursor
go;

select * from Board
drop trigger aft_ins_Bill_calculate_charge;


-- Trigger will check whether the reserved room is free during the reserving dates
--TODO Teď jen udělat, že pokud je to mezi kterymkoliv s těch datů, tak rollbacknout
create trigger bef_ins_Res_chk_room_free
  on Reservation
    after insert, update
as
  declare @StartDate date
  declare @EndDate date
  declare @ReservationID int

  declare ReservationCursor cursor for
  select ReservationID
  from Inserted

  open ReservationCursor
  fetch next from ReservationCursor into @ReservationID

  while @@FETCH_STATUS = 0
  begin
    select @StartDate = res.StartDate, 
          @EndDate = res.EndDate
    from Inserted as i
      join Reservation as res
        on res.RoomID = i.RoomID
    where res.ReservationID = @ReservationID

    if (Inserted.StartDate between @StartDate and @EndDate)       -- StartDate is during reserved time
    or (Inserted.EndDate between @StartDate and @EndDate)         -- EndDate is during reserved time
    or (Inserted.StartDate < @StartDate and Inserted.EndDate > @EndDate)  -- Room already reserved during desired time
    begin
    ROLLBACK TRANSACTION
    THROW 60000, 'Room is already reserved during desired time', 0
    end

    insert into TestDate values (@ReservationID, @StartDate, @EndDate)

    fetch next from ReservationCursor into @ReservationID
  end
  
  close ReservationCursor
      
go;

drop trigger bef_ins_Res_chk_room_free;
select * from Reservation;
insert into TestDate values (@StartDate);



create table TestDate (ReservationID int, StartDate date, EndDate date);
delete from TestDate;
select * from TestDate
drop table TestDate












create TRIGGER Kategorie_Dve_Urovne ON Kategorie AFTER INSERT, UPDATE AS
  if (exists (select *
      from inserted
      left join Kategorie on inserted.IdNadrazenaKategorie = Kategorie.Id
      where Kategorie.IdNadrazenaKategorie IS NOT NULL)) -- nad�azen� kategorie je u� podkategorie
    OR (exists (select *
          from inserted
          where inserted.IdNadrazenaKategorie is not null
              and exists(select * from Kategorie where IdNadrazenaKategorie = inserted.Id))) -- kategorie m� podkategorii i nadkategorii
  BEGIN
    ROLLBACK TRANSACTION;
    THROW 60000, 'Kategorie musi byt maximalne dvouurovnove.', 0;
  END;
GO



-- select b.PaymentType, res.StartDate, res.EndDate, rt.PricePerNight, DATEDIFF(day, res.StartDate, res.EndDate) * rt.PricePerNight  AS DateDiff
-- from Bill as b
--   join Reservation as res
--     on b.ReservationID = res.ReservationID
--   join Room as r
--     on res.RoomID = r.RoomID
--   join RoomType as rt
--     on r.RoomTypeID = rt.RoomTypeID




-- select p.BusinessEntityID, p.FirstName, p.LastName, bea.BusinessEntityID, bea.AddressID
-- from Person.Person as p 
--     right join Person.BusinessEntityAddress as bea
--         on p.BusinessEntityID = bea.BusinessEntityID
