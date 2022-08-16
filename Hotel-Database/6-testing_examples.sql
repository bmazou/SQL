use HotelDatabase;


--* Trigger testing

-- Test trigger - insert reservation with 5 guests and room with capacity of 2
insert into Reservation
(RoomID, GuestID, BoardID, StartDate, EndDate, NumOfGuests) values 
(3, 1, 1, '2100-09-05', '2100-09-10', 5);

-- Test trigger - insert reservation of room during already reserved time
insert into Reservation
(RoomID, GuestID, BoardID, StartDate, EndDate, NumOfGuests) values 
(4, 1, 1, '2022-02-01', '2022-02-09', 1);



--* Procedure and function testing

-- Calculate how much money the hotel will spend on employees in 54 days
exec ProjectedExpenditure 54;

-- Correct use
exec CreateReservation 1, 2, 1, '2023-09-05', '2023-09-10', 1
-- Possible exceptions are handled by triggers:
exec CreateReservation 1, 2, 1, '2023-09-05', '2023-09-10', 21

-- Nonexistent ReservationID
exec DeleteReservation 98347;
-- Correct use
exec DeleteReservation 5;

-- Nonexistent ReservationID
exec ChangeReservationBoard 23908, 'Full';
-- Nonexistent BoardType
exec ChangeReservationBoard 1, 'Nooone';
-- Correct use
exec ChangeReservationBoard 2, 'All Inclusive';

-- Nonexistent ReservationID
exec ChangeReservationRoom 23908, 1;
-- Nonexistent RoomID
exec ChangeReservationRoom 2, 9843;
-- Change shouldn't pass because of date overlap with other reservations (handled by a trigger)
exec ChangeReservationRoom 6, 1
-- Correct use
exec ChangeReservationRoom 6, 4

-- Change doesn't pass - date overlap with other reservation
exec ChangeReservationDates 3, '2021-09-02', '2021-09-12'
-- Correct use
exec ChangeReservationDates 5, '2023-09-08', '2023-11-23'


-- Print the total cost of bill 5
print dbo.bill_total(3)

