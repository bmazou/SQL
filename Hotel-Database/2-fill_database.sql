use HotelDatabase;

insert into Hotel values ('Creaky Cabin', 'Legion Rd 24', '47006', 'Ballstown, Indiana', 'USA', 2);

insert into JobType values('Reception', 2500);
insert into JobType values('Janitor', 1800);
insert into JobType values('Room Service', 2200);
insert into JobType values('Bartender', 2700);

insert into Employee values (1, 1, 'Johnny', 'Mark', 'M', '2008-11-11')

insert into RoomType values (3, 49.9)
insert into RoomType values (2, 38)
insert into RoomType values (5, 80)

insert into Room values (1,1);
insert into Room values (1,1);
insert into Room values (1,2);
insert into Room values (1,3);

select * from room

insert into Guest values ('Jasmine', 'Maurice', 'JM@gmail.com', null)
insert into Guest values ('Jana', 'Ratu', null, '908312322')

insert into Reservation values (1,1, '2022-02-02', '2022-02-05', 3);
insert into Reservation values (3,2, '2022-03-09', '2022-03-14', 5);


delete from Reservation 
select * from Reservation

insert into Bill
(ReservationID, PaymentType, PaymentDate) values 
(3, 'Card', '2022-01-28 19:23'),
(4, 'Cash', '2022-02-01 13:23');

insert into Bill
(ReservationID, PaymentType, PaymentDate) values 
(4, 'Cash', '2022-02-01 13:23');


select * from Bill

delete from Bill




