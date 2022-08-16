use HotelDatabase;

create table JobType (
  JobTypeID int identity(1,1)
    constraint JobType_PK primary key,
  Name nvarchar(50) not null,
  MontlySalary decimal(11,2) not null  
);

select * from JobType;

create table Hotel (
  HotelID int identity(1,1) 
    constraint Hotel_PK primary key,
  Name nvarchar(50) not null 
    constraint Hotel_U_Name unique,
  Address nvarchar(100) not null,
  PostCode varchar(50) not null,
  City nvarchar(50) not null,
  Country nvarchar(50) not null,
  StarRating int not null,
    constraint Hotel_U_Address unique (Address, PostCode, City, Country) 
);


select * from Hotel;

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
      check (Gender in ('M','F','O')), 
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
  ReservationID int not null
    constraint Bill_FK_Reservation references Reservation(ReservationID)
      on delete cascade,
  PaymentDate datetime,   -- if null, the bill hasn't been payed yet
  RoomCharge decimal(11,2),
  BoardCharge decimal(11,2)
);

select * from Bill
