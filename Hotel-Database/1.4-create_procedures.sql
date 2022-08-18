-- Bedřich Mazourek, LS 2021/22

use HotelDatabase;



-- Takes number of days as input, and shows how much the hotel will spend on employees during that timeframe
create procedure ProjectedExpenditure
  @Days int
as 
  select sum(JobTotalExpenditure)/30.41 as DailyExpenditure, @Days as Days, sum(JobTotalExpenditure) /30.41  * @Days as TotalExpenditure
  from vwHotelEmployeeExpenditure
go;


create procedure PayBill
  @BillID bigint
as
  if (select res.PaymentType 
      from Bill as b
        join Reservation as res
          on b.ReservationID = res.ReservationID
      where BillID = @BillID) = 'Card'
  begin 
    declare @ErrorMessage nvarchar(255)
    set @ErrorMessage = N'Error, the Bill with ID ' + cast(@BillID as varchar(10)) + ' has already been payed'
    ;throw 51000, @ErrorMessage, 0
  end

  declare @TimePayed datetime
  declare @TimePayedRounded datetime
  set @TimePayed = CURRENT_TIMESTAMP
  set @TimePayedRounded = dateadd(hour, datediff(hour, 0, @TimePayed), 0) -- Round

  update Bill
  set PaymentDate = @TimePayed, PaymentDateRounded = @TimePayedRounded
  where BillID = @BillID

go;



create procedure CreateReservation
  @RoomID int,
  @GuestID int,
  @BoardID int,
  @PaymentType char(4),
  @StartDate date,
  @EndDate date,
  @NumOfGuests int
as
  insert into Reservation
  (RoomID, GuestID, BoardID, PaymentType, StartDate, EndDate, NumOfGuests) values 
  (@RoomID, @GuestID, @BoardID, @PaymentType, @StartDate, @EndDate, @NumOfGuests)

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

  if @DesiredBoardType not in ('Full', 'Half', 'None', 'All Inclusive') -- Only 4 types of board
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


create procedure ChangeReservationNumOfGuests
  @ReservationID bigint,
  @NumOfGuests int
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
  set NumOfGuests = @NumOfGuests
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


create procedure NewGuest
  @FirstName nvarchar(50),
  @LastName nvarchar(50),
  @Email nvarchar(50),
  @Phone char(9)
as
  insert into Guest 
  (FirstName, LastName, Email, Phone) values
  (@FirstName, @LastName, @Email, @Phone)
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

