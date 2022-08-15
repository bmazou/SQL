use HotelDatabase;


--* Trigger testing

-- Test trigger - insert reservation with 5 guests and room with capacity of 2
insert into Reservation
(RoomID, GuestID, BoardID, StartDate, EndDate, NumOfGuests) values 
(3, 1, 1, '2100-09-05', '2100-09-10', 5);


--* Procedure and function testing


-- Try to pay bill with nonexistent id
exec PayBill 12098;

-- Try to pay already payed bill
exec PayBill 1;

-- Correct use - pay bill at ID 3
exec PayBill 3;


-- Calculate how much money the hotel will spend on employees in 54 days
exec ProjectedExpenditure 54;

-- Nonexistent ReservationID
exec ChangeReservationBoard 23908, 'Full';

-- Nonexistent BoardType
exec ChangeReservationBoard 1, 'Nooone';

-- Correct use
exec ChangeReservationBoard 1, 'All Inclusive';

select b.*
from Reservation as res
  join Bill as b
    on b.ReservationID = res.ReservationID;
-- Nonexistent ReservationID
exec ChangeReservationRoom 23908, 1;

-- Nonexistent RoomID
exec ChangeReservationRoom 1, 9843;

-- Change shouldn't pass because of date overlap with other reservations (handled by a trigger)
exec ChangeReservationRoom 6, 1

-- Correct use
exec ChangeReservationRoom 6, 4


-- Change doesn't pass - date overlap with other reservation
exec ChangeReservationDates 3, '2021-09-02', '2021-09-12'

-- Correct use
exec ChangeReservationDates 5, '2023-09-08', '2023-11-23'

-- Print the total cost of bill 5
print dbo.bill_total(5)