use HotelDatabase;

-- Foreign keys

create index IDX_EmployeeHotelID  
on Employee(HotelID);

create index IDX_EmployeeJobTypeID  
on Employee(JobTypeID); 

create index IDX_RoomHotelID  
on Room(HotelID);

create index IDX_EmployeeRoomTypeID 
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
on Guest(FirstName, LastName);

create index IDX_EmployeeFullName
on Employee(FirstName, LastName);