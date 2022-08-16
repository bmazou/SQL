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
drop trigger aft_ins_Res_chk_enough_capacity;

--* Procedures and fuctions
drop procedure ProjectedExpenditure;
drop procedure ChangeReservationBoard
drop procedure CreateReservation;
drop procedure ChangeReservationRoom;
drop procedure ChangeReservationDates;
drop procedure DeleteReservation;

drop function bill_total


--* Indexes
drop index IDX_EmployeeHotelID
on Employee;

drop index IDX_EmployeeJobTypeID
on Employee;

drop index IDX_RoomHotelID
on Room;

drop index IDX_RoomRoomTypeID
on Room;

drop index IDX_ReservationRoomID
on Reservation;

drop index IDX_ReservationGuestID
on Reservation;

drop index IDX_ReservationBoardID
on Reservation;

drop index IDX_BillReservationID
on Bill;

drop index IDX_GuestFullName
on Guest;

drop index IDX_EmployeeFullName
on Employee;

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





