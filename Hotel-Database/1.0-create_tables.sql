-- Bedřich Mazourek, LS 2021/22

use HotelDatabase;


/*
For reference, the schema is drawn out in the 'schema.jpg' file.

The database is of a hotel chain, currently starting with a single small hotel, trying to expand and add more locations in the future.

Each Hotel has its Employees, that have their JobType (i.e. receptionist, room service etc.).

Each Hotel also has Rooms, that also have their RoomType (maximum capacity and how much they cost).

Guests can make Reservations and choose want Room they want,  want type of Board they want (none, half, full, all-inclusive), the time range of their stay, and how many people are coming.

Guests need to be registered in the database before making a reservation.

The database checks, whether the chosen Room is free during desired period of the stay. It also checks that the number of guests coming doesn't exceed the rooms capacity.

After a Reservation is created, the database automatically generates a Bill linked to the Reservation, while calculating how much the total stay will cost, depending on the length of stay, chosen Room, and chosen Board.
Guests can also delete or change their reservations.
*/


create table Hotel (
  HotelID int identity(1,1) 
    constraint Hotel_PK primary key,
  Name nvarchar(50) not null 
    constraint Hotel_U_Name unique,
  Address nvarchar(100) not null,
  PostCode varchar(50) not null,
  City nvarchar(50) not null,
  Country nvarchar(50) not null,
  StarRating smallint not null
    constraint Hotel_CHK_StarRating 
      check (StarRating in (1,2,3,4,5)),
  -- Two hotels can't be at the same location
  constraint Hotel_U_Address unique (Address, PostCode, City, Country) 
);

select * from Hotel;


create table JobType (
  JobTypeID int identity(1,1)
    constraint JobType_PK primary key,
  Name nvarchar(50) not null,
  MonthlySalary decimal(11,2) not null  
);

select * from JobType;


create table Employee (
  EmployeeID int identity(1,1) 
    constraint Employee_PK primary key,
  HotelID int not null
    constraint Employee_FK_Hotel references Hotel(HotelID)
      on delete cascade,
  JobTypeID int not null
    constraint Employee_FK_JobType references JobType(JobTypeID)
      on delete cascade,
  FirstName nvarchar(50) not null,
  LastName nvarchar(50) not null,
  Gender char(1) not null
    constraint Employee_CHK_Gender 
      check (Gender in ('M','F','O')), -- Male/Female/Other 
  Started date not null
);

select * from Employee;


create table RoomType (
  RoomTypeID int identity(1,1)
    constraint RoomType_PK primary key,
  Capacity smallint not null,
  PricePerNight Decimal(10,2) not null
);

select * from RoomType;


create table Room (
  RoomID int identity(1,1)
    constraint Room_PK primary key,
  HotelID int not null
    constraint Room_FK_Hotel references Hotel(HotelID)
      on delete cascade,
  RoomTypeID int not null
    constraint Room_FK_RoomType references RoomType(RoomTypeID)
      on delete cascade,
);

select * from Room;



create table Guest (
  GuestID int identity(1,1)
    constraint Guest_PK primary key,
  FirstName nvarchar(50) not null,
  LastName nvarchar(50) not null,
  Email nvarchar(50)
    constraint Guest_CHK_Email
      check (Email like '_%@%_.%_'), 
  Phone char(9)
    constraint Guest_CHK_Phone 
      check (Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  constraint Guest_NN_EmailPhone 
    check (Email is not null or Phone is not null)
);

select * from Guest;


create table Board (
  BoardID int identity(1,1)
    constraint Board_PK primary key,
  Type varchar(13) not null
    constraint Board_U_Type unique
    constraint Board_CHK_Type
      check (Type in ('Full', 'Half', 'None', 'All Inclusive')),
  PricePerDay decimal(10,2) not null
);

select * from Board;


create table Reservation (
  ReservationID bigint identity(1,1)
    constraint Reservation_PK primary key,
  RoomID int not null
    constraint Reservation_FK_Room references Room(RoomID)
      on delete cascade,
  GuestID int not null
    constraint Reservation_FK_Guest references Guest(GuestID)
     on delete cascade,
  BoardID int not null
    constraint Reservation_FK_Board references Board(BoardID)
      on delete cascade,
  StartDate date not null,
  EndDate date not null,
  NumOfGuests smallint not null,
  constraint Reservation_CHK_StartBeforeEnd
    check (StartDate < EndDate)
);

select * from Reservation;


create table Bill (
  BillID bigint identity(1,1)
    constraint Bill_PK primary key,
  ReservationID bigint not null
    constraint Bill_FK_Reservation references Reservation(ReservationID)
      on delete cascade,
  PaymentDate datetime,   -- if null, the bill hasn't been payed yet
  RoomCharge decimal(11,2),  -- How much the room costs
  BoardCharge decimal(11,2)  -- How much the board costs
);  

select * from Bill
