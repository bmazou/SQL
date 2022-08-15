use HotelDatabase;

-- Changes PaymentDate in Bill table of BillID row, to current timestamp
-- If Bill is already payed or desired row doesn't exist, it throws an error
create procedure PayBill
  @BillID int
as 
  declare @ErrorMessage nvarchar(255)
  -- Check if the row, where bill isn't yet payed, exists
  declare @ChangedRow bit = 0;
  if exists (
      select * from Bill 
      where BillID = @BillID and PaymentDate is null
    )
  begin 
    set @ChangedRow = 1;
  end

  update Bill set PaymentDate = CURRENT_TIMESTAMP
  where BillID = @BillID and PaymentDate is null

  -- If no row was changed, throw an error
  if @ChangedRow = 0
  begin
    set @ErrorMessage = N'Error, the bill with ID ' + cast(@BillID as varchar(10)) + ' does not exist or it has already been payed'
    ;throw 51000, @ErrorMessage, 0
  end
go;


-- Takes number of days as input, and returns how much the hotel will spend on employees during that timeframe
create procedure ProjectedExpenditure
  @Days int
as 
  select sum(JobTotalExpenditure)/30.41 as DailyExpenditure, @Days as Days, sum(JobTotalExpenditure) /30.41  * @Days as TotalExpenditure
  from HotelEmployeeExpenditure
go;


create procedure ChangeReservationBoard
  @ReservationID int,
  @DesiredBoardType nvarchar(255)
as
  declare @ErrorMessage nvarchar(255)
  declare @DesiredBoardID int

  if @ReservationID not in (
    select ReservationID 
    from Reservation)
  begin
    set @ErrorMessage = N'Error, the Reservation with ID ' + cast(@ReservationID as varchar(10)) + ' does not exist'
    ;throw 51000, @ErrorMessage, 0;
  end

  if @DesiredBoardType not in ('Full', 'Half', 'None', 'All Inclusive')
  begin
    set @ErrorMessage = N'The board type must be either None, Half, Full or All Inclunsive'
    ;throw 51000, @ErrorMessage, 0;
  end

  select @DesiredBoardID = BoardID 
  from Board
  where Type = @DesiredBoardType

  update Reservation
  set BoardID = @DesiredBoardID
  where ReservationID = @ReservationID
go;


create procedure ChangeReservationRoom
  @ReservationID int,
  @DesiredRoomID int
as
  declare @ErrorMessage nvarchar(255)

  if @ReservationID not in (
    select ReservationID 
    from Reservation)
  begin
    set @ErrorMessage = N'Error, the Reservation with ID ' + cast(@ReservationID as varchar(10)) + ' does not exist'
    ;throw 51000, @ErrorMessage, 0;
  end

  if @DesiredRoomID not in (
    select RoomID
    from Room
  )
  begin
    set @ErrorMessage = N'Error, the Room with ID ' + cast(@DesiredRoomID as varchar(10)) + ' does not exist'
    ;throw 51000, @ErrorMessage, 0;
  end

  update Reservation
  set RoomID = @DesiredRoomID
  where ReservationID = @ReservationID
go;


create procedure ChangeReservationDates
  @ReservationID int,
  @DesiredStartDate date,
  @DesiredEndDate date
as
  declare @ErrorMessage nvarchar(255)

  if @ReservationID not in (
    select ReservationID 
    from Reservation)
  begin
    set @ErrorMessage = N'Error, the Reservation with ID ' + cast(@ReservationID as varchar(10)) + ' does not exist'
    ;throw 51000, @ErrorMessage, 0;
  end
  
  update Reservation
  set StartDate = @DesiredStartDate, EndDate = @DesiredEndDate
  where ReservationID = @ReservationID
go;

select * from Reservation



-- Function calculating total cost of a bill, given a BillID
create function bill_total (@BillID int)
  returns decimal(12,2)
as
  begin
    declare @Sum decimal(12,2);
    select @Sum = RoomCharge + BoardCharge
    from Bill
    where BillID = @BillID

    return @Sum
  end
go;

drop function BillTotal

print dbo.bill_total(5)

select * from Bill