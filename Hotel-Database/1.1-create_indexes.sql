-- Bedřich Mazourek, LS 2021/22

use HotelDatabase;


-- Foreign keys

create index IDX_EmployeeHotelID  
on Employee(HotelID);

create index IDX_EmployeeJobTypeID  
on Employee(JobTypeID); 

create index IDX_RoomHotelID  
on Room(HotelID);

create index IDX_RoomRoomTypeID 
on Room(RoomTypeID);

create index IDX_ReservationRoomID  
on Reservation(RoomID);

create index IDX_ReservationGuestID  
on Reservation(GuestID);

create index IDX_ReservationBoardID  
on Reservation(BoardID);

create index IDX_BillReservationID  
on Bill(ReservationID);


-- Indexes on names, when searching for specific guest or employee by full name
create index IDX_GuestFullName
on Guest(LastName, FirstName);

create index IDX_EmployeeFullName
on Employee(LastName, FirstName);


-- Index for searching for the daterange of reservations
create index IDX_ReservationDates
on Reservation(StartDate, EndDate);

-- Index on rounded datetime, so it doesn't have to account for minutes, seconds, and milliseconds
create index IDX_BillPaymentDate
on Bill(PaymentDateRounded);

