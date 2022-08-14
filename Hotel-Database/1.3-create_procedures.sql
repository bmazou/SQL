use HotelDatabase;

-- Changes PaymentDate in BIll table of BillID row, to current timestamp
-- If Bill is already payed or desired row doesn't exist, it throws an error
create procedure PayBill
  @BillID int
as 
  -- Check if the row, where bill isn't yet payed, exists
  declare @ChangedRow bit = 0;
  if exists (
      select * from Bill 
      where BillID = @BillID and PaymentDate is null
    )
  begin 
    set @ChangedRow = 1;
  end

  update Bill set PaymentDate = CURRENT_TIMESTAMP
  where BillID = @BillID and PaymentDate is null

  -- If no row was changed, throw an error
  if @ChangedRow = 0
  begin
    declare @ErrorMessage nvarchar(255)
    set @ErrorMessage = N'Error, the bill with ID ' + cast(@BillID as varchar(9)) + ' does not exist or it has already been payed';
    throw 51000, @ErrorMessage, 0;
  end
go;


select * from Bill; 
where PaymentDate is null;

update Bill set PaymentDate = null
where BillID = 1;
exec PayBill @BillID = 1;



update Bill set PaymentDate = CURRENT_TIMESTAMP
where PaymentDate = NULL;