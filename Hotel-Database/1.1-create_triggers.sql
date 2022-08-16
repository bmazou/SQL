use HotelDatabase;

--TODO Checknout ať ty error čísla dávaj smysl nebo jestli je to jedno


-- Trigger on Bill calculating, how much will the room 
-- and the board cost (for the entire stay)
create trigger aft_ins_Bill_calculate_charge 
  on Bill 
    for insert, update
as
  declare @RoomCharge decimal(11,2)
  declare @BoardCharge decimal(11,2)
  declare @BillID bigint
  declare @ReservationID bigint

  declare BillCursor cursor for
  select BillID, ReservationID
  from Inserted

  open BillCursor
  fetch next from BillCursor into @BillID, @ReservationID

  while @@FETCH_STATUS = 0
  begin
    -- For clarity, the selects and updates are separated
    --TODO Můžu ty dva statementy dát do jednoho

    -- Calculate how much the room will cost for the entire stay
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

select * from Bill;
select * from Reservation;


-- Trigger creates a Bill for each new reservation
create trigger aft_ins_Reservation_create_bill  
  on Reservation  
    for insert, update
as
  declare @InsertedReservationID bigint

  declare MyCursor cursor for 
  select ReservationID
  from Inserted

  open MyCursor 
  fetch next from MyCursor into @InsertedReservationID

  while @@FETCH_STATUS = 0
  begin
    -- If this triggers after an update, we need to replace the existing bill
    -- For that, first delete the existing bill with current ReservationID
    delete from Bill where 
    ReservationID = @InsertedReservationID

    -- Create new bill, with current Reservations ID and current_timestamp
    insert into Bill
    (ReservationID, PaymentDate) values
    (@InsertedReservationID, CURRENT_TIMESTAMP)


    fetch next from MyCursor into @InsertedReservationID
  end

  close MyCursor
go;


-- Trigger will check whether the reserved room is free during the reserving dates
create trigger aft_ins_Res_chk_room_free
  on Reservation
    for insert, update
as
  declare @StartDate date
  declare @EndDate date
  declare @InsertedReservationID bigint
  declare @InsertedRoomID int
  declare @InsertedStartDate date
  declare @InsertedEndDate date
  declare @ConflictingReservationID bigint

  declare ReservationCursor cursor for
  select ReservationID, RoomID, StartDate, EndDate
  from Inserted

  open ReservationCursor
  fetch next from ReservationCursor into @InsertedReservationID, @InsertedRoomID, @InsertedStartDate, @InsertedEndDate

  while @@FETCH_STATUS = 0
  begin
    if exists (
      -- Looks at reservations reserving same room as inserted reservation
      -- If reservation dates conflict, it selects
      select *
      from Reservation
      where ReservationID <> @InsertedReservationID and -- Not the same resarvation 
        RoomID = @InsertedRoomID and ( -- Same room 
        @InsertedStartDate between StartDate and EndDate or -- InsertedStartDate is between dates of some reservation 
        @InsertedEndDate between StartDate and EndDate or -- InsertedEndDate is between dates of some reservation 
        (@InsertedStartDate < StartDate and @InsertedEndDate > EndDate) -- Some reservation is between InsertedDates
        )
    )
    begin
      ROLLBACK TRANSACTION
      declare @ErrorMessage nvarchar(255)
      set @ErrorMessage = N'Error at reservation: ' + cast(@InsertedReservationID as varchar(12)) + '. Room is already reserved during desired time'
      ;THROW 60000, @ErrorMessage, 0
    end

    fetch next from ReservationCursor into @InsertedReservationID, @InsertedRoomID, @InsertedStartDate, @InsertedEndDate;
  end

  close ReservationCursor
go;

select * from Reservation;


-- Check that the number of guests in a reservation doesn't exceed the room capacity
create trigger aft_ins_Res_chk_enough_capacity
  on Reservation
    for insert, update
as
  declare @InsertedReservationID bigint
  declare @InsertedNumOfGuests int
  declare @RoomCapacity int

  -- Select ReservationIDs, how many guests are expected, and what 
  -- the capacity of the room is
  declare MyCursor cursor for 
  select i.ReservationID, i.NumOfGuests, rt.capacity
  from Inserted as i
    join Room as r
      on r.RoomID = i.RoomID
    join RoomType as rt
      on r.RoomTypeID = rt.RoomTypeID

  open MyCursor
  fetch next from MyCursor into @InsertedReservationID, @InsertedNumOfGuests, @RoomCapacity

  while @@FETCH_STATUS = 0
  begin
    if @InsertedNumOfGuests > @RoomCapacity
    begin
      ROLLBACK TRANSACTION
      declare @ErrorMessage nvarchar(255)
      set @ErrorMessage = N'Error at reservation: ' + cast(@InsertedReservationID as varchar(12)) + '. Number of guests is ' + cast(@InsertedNumOfGuests as varchar(12)) + ', but maximum room capacity is ' + cast(@RoomCapacity as varchar(12));
      THROW 60000, @ErrorMessage, 0;
    end

  fetch next from MyCursor into @InsertedReservationID, @InsertedNumOfGuests, @RoomCapacity
  end

  close MyCursor
go;

drop trigger aft_ins_Res_chk_enough_capacity;

