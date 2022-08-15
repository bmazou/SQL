use HotelDatabase;

insert into Hotel values ('Creaky Cabin', 'Legion Rd 24', '47006', 'Ballstown, Indiana', 'USA', 2);

insert into JobType 
(Name, MontlySalary) values
('Reception', 2500),
('Janitor', 1800),
('Room Service', 2200),
('Bartender', 2700);

insert into Employee 
(HotelID, JobTypeID, FirstName, LastName, Gender, Started) values 
(1, 1, 'Johnny', 'Mark', 'M', '2021-11-11'),
(1, 2, 'Guy', 'Manson', 'M', '2021-11-13'),
(1, 3, 'Jennifer', 'Lawful', 'F', '2021-12-11'),
(1, 4, 'Stephanie', 'Smith', 'M', '2021-11-01'),
(1, 1, 'Pamela', 'Beasley', 'F', '2022-01-04');

select * from Employee
-- delete from Employee
-- DBCC CHECKIDENT ('Employee', reseed, 0);

insert into RoomType
(Capacity, PricePerNight) values 
(3, 49.9),
(2, 38),
(5, 80);


insert into Room 
(HotelID, RoomTypeID) values 
(1,1),
(1,1),
(1,2),
(1,3);

select * from Room;

insert into Guest
(FirstName, LastName, Email, Phone) values 
('Jasmine', 'Maurice', 'JM@gmail.com', null),
('Jana', 'Ratu', null, '908312322');

select * from Guest

insert into Board
(Type, PricePerDay) values
('None', 0),
('Half', 11),
('Full', 15),
('All Inclusive', 22);

select * from Board;

-- Room capacity is 3,
insert into Reservation
(RoomID, GuestID, BoardID, StartDate, EndDate, NumOfGuests) values 
(1, 2, 1, '2021-09-05', '2021-09-10', 2),
(4, 1, 1, '2022-02-02', '2022-02-05', 3),
(1, 2, 3, '2022-09-08', '2022-09-13', 1),
(3, 2, 2,'2022-03-09', '2022-03-14', 2),
(2, 1, 4, '2022-04-12', '2022-04-22', 2),
(2, 1, 4, '2022-09-08', '2022-09-22', 1);

select * from Reservation
delete from Reservation
DBCC CHECKIDENT ('Reservation', reseed, 0);

insert into Bill
(ReservationID, PaymentType, PaymentDate) values 
(1, 'Card', '2021-04-10 12:00'),
(2, 'Card', '2022-01-28 19:23'),
(3, 'Cash', null),
(4, 'Card', '2022-02-28 13:23'),
(5, 'Cash', '2022-03-12 13:23');

select * from Bill
-- delete from Bill



select * from Reservation

update Reservation
set BoardID = 20
where ReservationID = 18

