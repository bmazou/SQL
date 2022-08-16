use HotelDatabase;



-- Takes number of days as input, and returns how much the hotel will spend on employees during that timeframe
create procedure ProjectedExpenditure
  @Days int
as 
  select sum(JobTotalExpenditure)/30.41 as DailyExpenditure, @Days as Days, sum(JobTotalExpenditure) /30.41  * @Days as TotalExpenditure
  from vwHotelEmployeeExpenditure
go;

select * from Reservation;


create procedure CreateReservation
  @RoomID int,
  @GuestID int,
  @BoardID int,
  @StartDate date,
  @EndDate date,
  @NumOfGuests int
as
  insert into Reservation
  (RoomID, GuestID, BoardID, StartDate, EndDate, NumOfGuests) values 
  (@RoomID, @GuestID, @BoardID, @StartDate, @EndDate, @NumOfGuests)

go;

create procedure DeleteReservation
  @ReservationID bigint
as
  declare @ErrorMessage nvarchar(255)

  if @ReservationID not in (
    select ReservationID 
    from Reservation)
  begin
    set @ErrorMessage = N'Error, the Reservation with ID ' + cast(@ReservationID as varchar(10)) + ' does not exist'
    ;throw 51000, @ErrorMessage, 0
  end

  delete 
  from Reservation 
  where ReservationID = @ReservationID
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
  @ReservationID bigint,
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
  @ReservationID bigint,
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

