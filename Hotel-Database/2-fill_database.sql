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
(1, 1, 'Johnny', 'Mark', 'M', '2008-11-11');


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

insert into Reservation
(RoomID, GuestID, BoardID, StartDate, EndDate, NumOfGuests) values 
(1, 2, 3, '2022-09-08', '2022-09-13', 1),
(1, 1, 1, '2022-02-02', '2022-02-05', 3),
(3, 2, 2,'2022-03-09', '2022-03-14', 5),
(2, 1, 4, '2022-04-12', '2022-04-22', 2);

select * from Reservation

insert into Bill
(ReservationID, PaymentType, PaymentDate) values 
(1, 'Card', '2022-04-10 12:00'),
(2, 'Card', '2022-01-28 19:23'),
(3, 'Cash', '2022-02-01 13:23');

select * from Bill
delete from Bill





