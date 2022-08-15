use HotelDatabase;



-- Test trigger - insert reservation with 5 guests and room with capacity of 2
insert into Reservation
(RoomID, GuestID, BoardID, StartDate, EndDate, NumOfGuests) values 
(3, 1, 1, '2100-09-05', '2100-09-10', 5);


-- Pay bill at ID 3
select * from Bill;
exec PayBill @BillID = 3;
select * from Bill;
-- Try to pay bill with nonexistent id
exec PayBill @BillID = 12098;
-- Try to pay already payed bill
exec PayBill @BillID = 1;