-- Bedřich Mazourek, LS 2021/22

use HotelDatabase;


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



-- Trigger creates a Bill for linked to a new reservation
create trigger aft_ins_Reservation_create_bill  
  on Reservation  
    for insert, update
as
  declare @InsertedReservationID bigint
  declare @InsertedPaymentType char(4)

  declare MyCursor cursor for 
  select ReservationID, PaymentType
  from Inserted

  open MyCursor 
  fetch next from MyCursor into @InsertedReservationID, @InsertedPaymentType

  while @@FETCH_STATUS = 0
  begin
    -- If triggered by an update, we also have to update the coresponding bill
    -- For that, we can update the bill (and change nothing), to set of its trigger
    -- The trigger then recalculates possible changes to Room, Board, or Dates made to its reservation
    if exists (select * from deleted)  -- Detect an update
    begin
      update Bill
      set ReservationID = ReservationID
      where ReservationID = @InsertedReservationID
    end

    else
    begin
      -- New reservation was created, so we need to create a new bill for it
      declare @TimePayed datetime
      
      -- If payed by card (during the reservation), insert current time
      -- into the PaymentDate column inside Bill
      set @TimePayed = CURRENT_TIMESTAMP
      
      -- If PaymentType is cash, insert null, indicating it hasn't been payed yet
      if @InsertedPaymentType = 'Cash'
      begin
        set @TimePayed = null
      end

      declare @TimePayedRounded datetime
      set @TimePayedRounded = dateadd(hour, datediff(hour, 0, @TimePayed), 0) -- Round down to the hour
      
      insert into Bill
      (ReservationID, PaymentDate, PaymentDateRounded) values
      (@InsertedReservationID, @TimePayed, @TimePayedRounded)
    end

    fetch next from MyCursor into @InsertedReservationID, @InsertedPaymentType
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
      -- Looks at reservations that reserve same room as the inserted reservation
      -- If reservation dates conflict, it triggers, and we can rollback the transaction
      select *
      from Reservation
      where ReservationID <> @InsertedReservationID and -- Not the same resarvation 
        RoomID = @InsertedRoomID and ( -- Same room 
        @InsertedStartDate between StartDate and EndDate or -- InsertedStartDate is between dates of some reservation 
        @InsertedEndDate between StartDate and EndDate or -- InsertedEndDate is between dates of some reservation 
        (@InsertedStartDate < StartDate and @InsertedEndDate > EndDate) -- Some reservation is between the InsertedDates
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
    -- If more guests are coming than can be fit in a room, rollback
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


