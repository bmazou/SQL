-- Bedřich Mazourek, LS 2021/22

use HotelDatabase;


insert into Hotel 
(Name, Address, PostCode, City, Country, StarRating) values 
('Creaky Cabin', 'Legion Rd 24', '47006', 'Ballstown, Indiana', 'USA', 2);

insert into JobType 
(Name, MonthlySalary) values
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


insert into RoomType
(Capacity, PricePerNight) values 
(3, 49.9),
(2, 38),
(5, 80);


insert into Room 
(HotelID, RoomTypeID) values 
(1,1),
(1,1),
(1,1),
(1,2),
(1,2),
(1,2),
(1,3);

select * from Room;


insert into Guest
(FirstName, LastName, Email, Phone) values 
('Jasmine', 'Maurice', 'JM@gmail.com', null),
('Jana', 'Ratu', null, '908312322'),
('Jacob', 'Mountainous', 'jacomou@gmail.com', null),
('Simon', 'Morveer', null, '312049298'),
('Caul', 'Shivers', null, '558133132');

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
(RoomID, GuestID, BoardID, PaymentType, StartDate, EndDate, NumOfGuests) values 
(1, 2, 1, 'Cash', '2021-09-05', '2021-09-10', 2),
(4, 1, 1, 'Cash', '2022-02-02', '2022-02-05', 2),
(1, 2, 3, 'Card', '2022-09-08', '2022-09-13', 1),
(3, 2, 2, 'Cash', '2022-03-09', '2022-03-14', 2),
(2, 1, 4, 'Card', '2022-04-12', '2022-04-22', 2),
(2, 1, 4, 'Card', '2022-09-08', '2022-09-22', 1),
(5, 3, 3, 'Card', '2022-09-08', '2022-09-09', 2),
(6, 3, 3, 'Cash', '2022-10-18', '2022-10-19', 2),
(6, 4, 1, 'Card', '2022-09-08', '2022-09-22', 1),
(7, 1, 4, 'Cash', '2022-02-02', '2022-02-05', 5),
(7, 5, 2, 'Cash', '2022-12-02', '2022-12-09', 5),
(4, 5, 3, 'Cash', '2022-08-08', '2022-08-09', 2),
(5, 3, 3, 'Card', '2022-09-18', '2022-09-29', 2),
(1, 2, 2, 'Card', '2022-12-02', '2022-12-09', 2),
(2, 3, 2, 'Cash', '2022-12-02', '2022-12-09', 2),
(3, 4, 2, 'Cash', '2022-12-02', '2022-12-09', 2),
(4, 5, 2, 'Card', '2022-12-02', '2022-12-09', 1);

select * from Reservation;
select * from Bill;
