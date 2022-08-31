-- use AdventureWorks2019;

-- select DISTINCT City
-- from Person.Address;

-- select SubTotal, TaxAmt, SubTotal + TaxAmt as Suma
-- from Purchasing.PurchaseOrderHeader
-- where SubTotal + TaxAmt > 250;

-- select *
-- from HUmanResources.Employee
-- where BusinessEntityID between 40 and 45 or JobTitle in ('Design Engineer', 'Research and Development Manager')

-- select * 
-- from Person.StateProvince
-- where Name like 'A%'

-- select City, PostalCode
-- from Person.Address
-- order by city desc

-- select SalesOrderID, count(UnitPrice)  --* sum,avg,count,max,min
-- from sales.salesorderdetail
-- group by SalesOrderID;

-- left(str, int), right(str, int), substring(str, int, int) --> prvních/posledních x písmen, x písmen začínajících na y pozici

-- select CURRENT_TIMESTAMP

-- select PurchaseOrderID, EmployeeID
-- from Purchasing.PurchaseOrderHeader
-- where PurchaseOrderID in (
--     select PurchaseOrderID
--     from Purchasing.PurchaseOrderDetail
--     where PurchaseOrderDetailID <= 5
-- );


-- select BusinessEntityID 
-- from HumanResources.Employee
--     union all       -- union all nechává duplikáty
-- select BusinessEntityID
-- from Person.Person

select pod.PurchaseOrderID, pod. PurchaseOrderDetailId, poh.OrderDate
from Purchasing.PurchaseOrderDetail pod
    inner join Purchasing.PurchaseOrderHeader poh
        on pod.PurchaseOrderID = poh.PurchaseOrderID


delete from Employee
DBCC CHECKIDENT ('Employee', reseed, 0);

delete from Guest
DBCC CHECKIDENT ('Guest', reseed, 0);


-- delete from Reservation
-- DBCC CHECKIDENT ('Reservation', reseed, 0);

-- delete from Bill
-- DBCC CHECKIDENT ('Bill', reseed, 0);