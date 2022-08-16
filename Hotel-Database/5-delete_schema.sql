use HotelDatabase

--* Views
drop view vwEmployeeInfo;
drop view vwGuestSpendeture;
drop view vwHotelEmployeeExpenditure;
drop view vwRoomUsage;  
drop view vwBoardPopularity;
drop view vwExpenditureByHotel;


--* Triggers
drop trigger aft_ins_Bill_calculate_charge;
drop trigger aft_ins_Res_chk_room_free
drop trigger aft_ins_Reservation_create_bill;

--* Procedures and fuctions
drop procedure ProjectedExpenditure;
drop procedure ChangeReservationBoard
drop procedure CreateReservation;
drop procedure ChangeReservationRoom;
drop procedure ChangeReservationDates;

drop function bill_total



--* Tables
drop table Employee;
drop table JobType;

drop table Bill;
drop table Reservation;
drop table Guest;
drop table Board;

drop table Room;
drop table RoomType;

drop table Hotel;





