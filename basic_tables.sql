create table VarCharTest (word varchar(50));
create table NvarCharTest (word nvarchar(50));

create table PK
    (
        PK int identity, 
        name nvarchar(50)
    );

drop table PK
insert into PK values ('Jake')

select * from PK

insert into NvarCharTest values (N'訓練');
insert into VarCharTest values (N'訓練');

select *from NvarCharTest;
select *from VarCharTest;

delimiter $$;
