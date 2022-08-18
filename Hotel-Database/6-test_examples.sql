-- Bedřich Mazourek, LS 2021/22

use HotelDatabase;


--* Trigger testing

-- Test trigger - try to insert reservation with 5 guests and room with capacity of 2
insert into Reservation
(RoomID, GuestID, BoardID, PaymentType, StartDate, EndDate, NumOfGuests) values 
(3, 1, 1, 'Card', '2100-09-05', '2100-09-10', 5);

-- Test trigger - try to insert reservation during already reserved time
insert into Reservation
(RoomID, GuestID, BoardID, PaymentType, StartDate, EndDate, NumOfGuests) values 
(4, 1, 1, 'Card', '2022-02-01', '2022-02-09', 1);



--* Procedure and function testing

-- Calculate how much money the hotel will spend on employees in 54 days
exec ProjectedExpenditure 54;

-- Correct use
exec CreateReservation 1, 2, 1, 'Cash','2023-09-05', '2023-09-10', 1
-- Possible exceptions are handled by triggers:
exec CreateReservation 1, 2, 1, 'Card', '2023-09-05', '2023-09-10', 21

-- Nonexistent ReservationID
exec DeleteReservation 98347;
-- Correct use
exec DeleteReservation 5;


-- Nonexistent ReservationID
exec ChangeReservationBoard 23908, 'Full';
-- Nonexistent BoardType
exec ChangeReservationBoard 1, 'Nooone';

-- Correct use: change from Board 'None' to 'All Inclusive'
-- Also check that the Bill with ReservationID 9 recalculated its BoardCharge
select BoardCharge
from Bill
where ReservationID = 9;

exec ChangeReservationBoard 9, 'All Inclusive';

select BoardCharge
from Bill
where ReservationID = 9;


-- Nonexistent ReservationID
exec ChangeReservationRoom 23908, 1;
-- Nonexistent RoomID
exec ChangeReservationRoom 2, 9843;
-- Change shouldn't pass because of date overlap with other reservations (handled by a trigger)
exec ChangeReservationRoom 6, 1;

-- Correct use, + check whether RoomCharge in bill was updated
select RoomCharge
from Bill
where ReservationID = 6

exec ChangeReservationRoom 6, 7;

select RoomCharge
from Bill
where ReservationID = 6


-- Change doesn't pass - date overlap with other reservation
exec ChangeReservationDates 3, '2021-09-02', '2021-09-12';

-- Correct use
select RoomCharge
from Bill
where ReservationID = 4

exec ChangeReservationDates 4, '2023-09-08', '2023-11-23';

select RoomCharge
from Bill
where ReservationID = 4


-- Changing number of guests coming
exec ChangeReservationNumOfGuests 4, 1;

-- Try to pay bill that has already been payed 
exec PayBill 5;

-- Correct use
exec PayBill 8;

-- Inserting new guest
exec NewGuest 'Andrew', 'Green', null, '123456789';


-- Print the total cost of bill 4
print dbo.bill_total(4);


--* Try out different views
select * from vwEmployeeInfo;

select * 
from vwGuestSpendeture 
order by TotalPayed desc;

select * 
from vwHotelEmployeeExpenditure
order by JobTotalExpenditure;

select * from vwExpenditureByHotel; 

select * 
from vwRoomTypeUsage
order by NumberOfReservations desc;

select * 
from vwBoardPopularity
order by DaysTaken desc;
