drop database Hotel;

create table JobType (
  JobTypeID int identity(1,1)
    constraint JobType_PK primary key,
  Name nvarchar(50) not null,
  MontlySalary decimal(11,2) not null  
);

drop table JobType;
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

drop table Hotel;

select * from Hotel;

insert into Hotel values ('Creaky Cabin', 'Legion Rd 24', '47006', 'Ballstown, Indiana', 'USA', 2);


create table Employee (
  EmployeeID int identity(1,1) 
    constraint Employee_PK primary key,
  HotelID int not null
    constraint Employee_FK_Hotel references Hotel(HotelID)
      on delete cascade,
  JobTypeID int not null
    constraint Employee_FK_JobType references JobType(JobTypeID)
      on delete cascade,
  Name nvarchar(50) not null,
  Gender char(1) not null
    constraint Employee_MFO check (Gender in ('M','F','O')), 
  Started date not null
);

select * from Employee;
drop table Employee;


create table RoomType (
  RoomTypeID int identity(1,1)
    constraint RoomType_PK primary key,
  Capacity smallint not null,
  PricePerNight Decimal(10,2) not null
);

select * from RoomType;

