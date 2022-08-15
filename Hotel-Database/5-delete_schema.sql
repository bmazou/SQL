use HotelDatabase

--* Views
drop view EmployeeInfo;
drop view CustomerSpendeture;
drop view HotelEmployeeExpenditure;


--* Triggers
drop trigger aft_ins_Bill_calculate_charge;
drop trigger aft_ins_Res_chk_room_free

--* Procedures
drop procedure PayBill;
drop procedure ProjectedExpenditure;
drop procedure ChangeReservationBoard
--TODO drop tu funcki


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





