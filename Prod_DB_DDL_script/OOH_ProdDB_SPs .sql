/************************************ StoredProcedure [Append_Control_Report_SP] *************************************/

-- =============================================
-- Author:      <Shubhodeep Mukherjee>
-- Create Date: <25-August-2022>
-- Description: <Procedure is to populate control table for AP OOH>
-- =============================================
CREATE PROCEDURE [dbo].[Append_Control_Report_SP]
(
       @ReportWriter_Is_Executed bit = null,
	   @ReportWriter_Execution_Date datetime = null,
       @ReportWriter_Exception varchar(500) = null,
       @ETL_Is_Executed bit = null,
       @ETL_Execution_Date datetime = null,
       @ETL_Exception varchar(500) = null,
       @PaidUnpaid_Refresh_Is_Executed bit = null,
       @PaidUnpaid_Refresh_Execution_Date datetime = null,
       @PaidUnpaid_Refresh_Exception varchar(500) = null,
       @InvExt_Is_Executed bit = null,
       @InvExt_Execution_Date datetime = null,
       @InvExt_Exception varchar(500) = null,
       @InvRecon_Is_Executed bit = null,
       @InvRecon_Execution_Date datetime = null,
       @InvRecon_Exception varchar(500) = null,
       @S9_Is_Executed bit = null,
       @S9_Execution_Date datetime = null,
       @S9_Exception varchar(500) = null,
	   @Msg nvarchar(MAX)=null OUTPUT
)
AS
		
			


BEGIN TRY

			DECLARE @CTRL_ID int = null
			DECLARE @date datetime = getdate()
			
			/* Checking whether row exsists for today's date, else creating an entry for today's execution date */

			select  TOP 1
				@CTRL_ID = ctrl_id
			FROM [dbo].[OOH_Control_Rpt]
			WHERE convert(varchar(10),[Ctrl_Execution_Date],23) = convert(varchar(10),GETDATE(),23);

			IF @@ROWCOUNT = 0
					INSERT INTO [dbo].[OOH_Control_Rpt]
					([Ctrl_Execution_Date],[Ctrl_ReportWriter_Is_Executed],[Ctrl_ETL_Is_Executed],[Ctrl_PaidUnpaid_Refresh_Is_Executed],[Ctrl_InvExt_Is_Executed],[Ctrl_InvRecon_Is_Executed],[Ctrl_S9_Is_Executed])
					VALUES
					(@date,0,0,0,0,0,0);					
				
			
			
			/* Main logic for updating table with passed values */

			select  TOP 1
				@CTRL_ID = ctrl_id
			FROM [dbo].[OOH_Control_Rpt]
			WHERE convert(varchar(10),[Ctrl_Execution_Date],23) = convert(varchar(10),GETDATE(),23);

			
			IF @ReportWriter_Is_Executed <> 0
				UPDATE [dbo].[OOH_Control_Rpt]
				SET 
				[Ctrl_ReportWriter_Is_Executed] = @ReportWriter_Is_Executed,
				[Ctrl_ReportWriter_Execution_Date] = @ReportWriter_Execution_Date,
				[Ctrl_ReportWriter_Exception] = @ReportWriter_Exception
				WHERE [CTRL_ID] = @CTRL_ID;


			IF @ETL_Is_Executed <> 0
				UPDATE [dbo].[OOH_Control_Rpt]
				SET 
				[Ctrl_ETL_Is_Executed] = @ETL_Is_Executed,
				[Ctrl_ETL_Execution_Date] = @ETL_Execution_Date,
				[Ctrl_ETL_Exception] = @ETL_Exception
				WHERE [CTRL_ID] = @CTRL_ID;


			IF @PaidUnpaid_Refresh_Is_Executed <> 0
				UPDATE [dbo].[OOH_Control_Rpt]
				SET 
				[Ctrl_PaidUnpaid_Refresh_Is_Executed] = @PaidUnpaid_Refresh_Is_Executed,
				[Ctrl_PaidUnpaid_Refresh_Execution_Date] = @PaidUnpaid_Refresh_Execution_Date,
				[Ctrl_PaidUnpaid_Refresh_Exception] = @PaidUnpaid_Refresh_Exception
				WHERE [CTRL_ID] = @CTRL_ID;


			IF @InvExt_Is_Executed <> 0
				UPDATE [dbo].[OOH_Control_Rpt]
				SET 
				[Ctrl_InvExt_Is_Executed] = @InvExt_Is_Executed,
				[Ctrl_InvExt_Execution_Date] = @InvExt_Execution_Date,
				[Ctrl_InvExt_Exception] = @InvExt_Exception
				WHERE [CTRL_ID] = @CTRL_ID;


			IF @InvRecon_Is_Executed <> 0
				UPDATE [dbo].[OOH_Control_Rpt]
				SET 
				[Ctrl_InvRecon_Is_Executed] = @InvRecon_Is_Executed,
				[Ctrl_InvRecon_Execution_Date] = @InvRecon_Execution_Date,
				[Ctrl_InvRecon_Exception] = @InvRecon_Exception				
				WHERE [CTRL_ID] = @CTRL_ID;


			IF @S9_Is_Executed <> 0
				UPDATE [dbo].[OOH_Control_Rpt]
				SET 
				[Ctrl_S9_Is_Executed] = @S9_Is_Executed,
				[Ctrl_S9_Execution_Date] = @S9_Execution_Date,
				[Ctrl_S9_Exception] = @S9_Exception
				WHERE [CTRL_ID] = @CTRL_ID;

			


END TRY

BEGIN CATCH

    SET @Msg=ERROR_MESSAGE()

END CATCH
GO



/************************************ StoredProcedure [Clear_Paid-Unpaid_Staging_SP] *************************************/


-- =============================================
-- Author:      <Shubhodeep Mukherjee>
-- Create Date: <26-August-2022>
-- Description: <Procedure is to clear Paid and Unpaid tables for AP OOH- Used by ADF>
-- =============================================
CREATE PROCEDURE [dbo].[Clear_Paid-Unpaid_Staging_SP]
(
      
	   @Msg nvarchar(MAX)=null OUTPUT
)
AS
		
			


BEGIN TRY

			DELETE FROM [dbo].[OOH_Paid_Stg];

			DELETE FROM [dbo].[OOH_Unpaid_Stg];

			


END TRY

BEGIN CATCH

    SET @Msg=ERROR_MESSAGE()

END CATCH
GO




/************************************ StoredProcedure [GetUnpaidBuys]  *************************************/



CREATE PROCEDURE [dbo].[GetUnpaidBuys] @fa nvarchar(100), @from nvarchar(50), @to nvarchar(50)
AS

select Unpaid_Ref_Invoice_Number as [AB INV#], Unpaid_Ref_Invoice_Dollar as [ABINV DOLLARS], Unpaid_Ref_Payable_Net as [PAYABLE NET],
Unpaid_Ref_Paid_Net as [PAID NET], Unpaid_Ref_Invoice_Comment as [AB INV COMM], Unpaid_Ref_TS_Received AS [TS RECEIVED],
Unpaid_Ref_IDesk_Recon_Status AS [IDESK], Unpaid_Ref_CLI_Acc_Off AS [CLI],Unpaid_Ref_Client_Code AS [CLIENT CODE],Unpaid_Ref_Client_Name AS [CLIENT NAME],
Unpaid_Ref_Product_Code AS [PRODUCT CODE], Unpaid_Ref_Product_Name AS [PRODUCT NAME],Unpaid_Ref_EST_Code AS [EST#],
Unpaid_Ref_Publication_Name AS [PUBNAME], Unpaid_Ref_Publication_Code AS [PUBNUM],Unpaid_Ref_Insertion_Date AS [INSDATE],
Unpaid_Ref_Insertion_MOS_Month AS [INSMON], Unpaid_Ref_Contract_ID AS [CONTRACT ID], Unpaid_Ref_Insertion_Order_Comment AS [INSERTION ORDER COMMENT1],
Unpaid_Ref_Insertion_Order_Comment_4 AS [INSERTION ORDER COMMENT2], Unpaid_Ref_Insertion_Order_Comment_2 AS [INSERTION ORDER COMMENT3], Unpaid_Ref_Pay_Address as [PAY ADDRESS]
from OOH_FA_Unpaidbuys where [finance associate] like '%'+@fa+'%'
and convert(date,@to,3) >= convert(date,'01/'+Unpaid_Ref_Insertion_MOS_Month,3) and convert(date,@from,3) <= convert(date,'01/'+Unpaid_Ref_Insertion_MOS_Month,3) 
order by convert(date,'01/'+Unpaid_Ref_Insertion_MOS_Month,3) desc

GO





/************************************ StoredProcedure[GetUntaggedCount]  *************************************/


CREATE PROCEDURE [dbo].[GetUntaggedCount] @fa nvarchar(100), @from nvarchar(50), @to nvarchar(50), @agency nvarchar(50) = null
AS
if @fa like 'All' or @fa like 'null' or @fa like NULL
BEGIN
select count(*) from OOH_Log_TXN_VIEW where convert(date,@to) >= convert(date,Log_Insertion_Date) and convert(date,@from) <= convert(date,Log_Insertion_Date) 
and Log_FA_Action_Status is Null and Log_Record_Type = 'new' and Agency_name like '%'+@agency+'%'
END
ELSE
BEGIN
select count(*) from OOH_Log_TXN_VIEW where FA_NAME like '%'+@fa+'%'
and convert(date,@to) >= convert(date,log_insertion_date) and convert(date,@from) <= convert(date,Log_Insertion_Date) 
and Log_FA_Action_Status is Null and Log_Record_Type = 'new' and Agency_Name like '%'+@agency+'%'
END

GO





/************************************ StoredProcedure [SP_FA_UnpaidBuys]  *************************************/



CREATE procedure [dbo].[SP_FA_UnpaidBuys]
@agency varchar(400),
@vendor varchar(400)=null,
@fa varchar(400)
as
begin
declare @sql varchar(max)
--select @agency,@vendor,@fa
set @sql=
'
Insert  into OOH_FA_UnpaidBuys 
select '''+@fa+''' as [Finance Associate],
  *
from
   OOH_Unpaid_Ref 
where 
   unpaid_ref_publication_name '
   set   @sql=@sql + case
         when
            @vendor is not null 
            
         then
    'like ''%'+@vendor+'%''' 
	else '= publication_name'
	end
 
  

 
--select @sql

exec(@sql)

            
end
GO



/************************************ StoredProcedure  [SP_FA_Unpivot_Table] *************************************/




CREATE procedure [dbo].[SP_FA_Unpivot_Table]
as
begin
drop table if exists  temp_fa_pivot

--match unpaid buys in paid_unpaid_data table with agency and vendor combination using fa_unpivot table which contains FA name

;with cte as (
select ROW_NUMBER() over (partition by (select null) order by agency) as rn,rtrim(agency) as agency,
rtrim(replace(iif(vendor= 'NO VENDOR', 'NO VENDOR', (left(vendor,charindex('(',vendor)-1))),'''','')) as vendor,fa  
from fa_unpivot_view)
select * into temp_fa_pivot from cte

declare @count int,
@rn int=1
select @count=count(*) from  temp_fa_pivot

truncate table OOH_FA_UnpaidBuys

while @rn<>@count+1
begin
declare @agency varchar(200),
@vendor varchar(200),
@fa varchar(200)

select @agency=agency, @vendor=vendor, @fa=fa from temp_fa_pivot where rn=@rn
--select @agency,@vendor, @fa

exec SP_FA_UnpaidBuys @agency=@agency,@vendor=@vendor,@fa=@fa

set @rn=@rn+1
end

--drop table if exists  temp_fa_pivot
end
GO




/************************************ StoredProcedure  [SP_Lookup_Reimport] *************************************/


-- =============================================
-- Author:      <Apurva Kundale>
-- Create Date: <27-Sept-2022>
-- Description: <Procedure to update data from lookup to Database>
-- =============================================


CREATE procedure [dbo].[SP_Lookup_Reimport]
( @Msg nvarchar(MAX)=null OUTPUT)
AS

BEGIN TRY
	--Declaring variable
	DECLARE @Lookup_RepCode VARCHAR(200)
	DECLARE @Lookup_PubCode VARCHAR(200)
	DECLARE @Lookup_Publication VARCHAR(200)
	DECLARE @lookup_SenderEmail VARCHAR(1000)
	DECLARE @lookup_TeamMember VARCHAR(500)
	DECLARE @lookup_TeamMemberEmail VARCHAR(500)
	DECLARE @Vendor_Name VARCHAR(200)
	DECLARE @Vendor_ID int
	DECLARE @Vendor_Sender_Email VARCHAR(500)
	DECLARE @Vendor_PubCode VARCHAR(200)
	DECLARE @Vendor_Publication VARCHAR(200)
	DECLARE @FA_ID int
	DECLARE @Map_FA_ID int
	
	
	-- DECLARE Cursor 
	DECLARE db_cursor CURSOR FOR 
	-- input is the OOH_FA_lookup_stg table. Need to populate the newly made changes in the VendorMaster, FAmaster and FA_mapping_Ref table
		select [FA_Lookup_PayRep],[FA_Lookup_PubCode],[FA_Lookup_Publication],[FA_Lookup_SenderEmail],[FA_Lookup_TeamMember],[FA_Lookup_TeamMemberEmail]
		 from [dbo].[OOH_FA_Lookup_Stg] where FA_Lookup_PubCode is NOT NULL

	-- Open the Cursor
	OPEN db_cursor

	-- Fetch the next record from the cursor
	FETCH NEXT FROM db_cursor INTO @Lookup_RepCode,@Lookup_PubCode,@Lookup_Publication,@lookup_SenderEmail,@lookup_TeamMember,@lookup_TeamMemberEmail

	-- Set the status for the cursor
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
	--  Begin the custom business logic
		
			SET @FA_ID = NULL
			SET @Vendor_ID = NULL
			SET @Map_FA_ID = NULL
			
			-- getting FAid from FA_Master
			SELECT @FA_ID = FA_ID from [dbo].[OOH_FA_Master] where FA_Name = Trim(@lookup_TeamMember)
			-- IF FA not found in OOH_FA_Master insert the value
			IF @FA_ID is NULL
			BEGIN
				SET @lookup_TeamMember = Trim(@lookup_TeamMember)
				SET @lookup_TeamMemberEmail = Trim(@lookup_TeamMemberEmail)
				INSERT INTO [dbo].[OOH_FA_Master] (FA_Name,FA_Email_ID,FA_Insertion_Date) values (@lookup_TeamMember,@lookup_TeamMemberEmail,getdate())
				Select @FA_ID = FA_ID from [dbo].[OOH_FA_Master] where FA_Name = Trim(@lookup_TeamMember)
			END

			-- setting REP_CODE if 'N/A' then insert as NULL in DB
			SET @Lookup_RepCode=iif(@Lookup_RepCode='N/A*',null,CAST(Trim(@Lookup_RepCode) as INT))
			SET @Lookup_PubCode= Trim(@Lookup_PubCode)
			SET @Lookup_Publication = Trim(@Lookup_Publication)
			SET @lookup_SenderEmail=iif(@lookup_SenderEmail='NULL',null,Trim(@lookup_SenderEmail))

			--Check if vendor is present in OOH_Vendor_Master using Publication code for matching 
			SELECT @Vendor_ID=Vendor_ID,@Vendor_Name=Vendor_Name,@Vendor_Sender_Email=Vendor_Sender_Email,@Vendor_Publication=Vendor_Pub_Name, @Vendor_PubCode=Vendor_Pub_code
			from [dbo].[OOH_Vendor_Master] where Vendor_Pub_Code = Trim(@Lookup_PubCode)
			
			-- IF vendor not found in OOH_Vendor_Master insert new value
			IF @Vendor_ID is NULL
			BEGIN 	
				INSERT INTO  [dbo].[OOH_Vendor_Master] (Vendor_Name,Vendor_Rep_Code,Vendor_Sender_Email,Vendor_Pub_Name,Vendor_Pub_code,Vendor_Insertion_Date)
				VALUES(@Lookup_Publication+' ('+@Lookup_PubCode+')',@Lookup_RepCode,@lookup_SenderEmail,@Lookup_Publication,@Lookup_PubCode,getdate())
				-- get id of newly entered vendor 
				
				
				SELECT @Vendor_ID=Vendor_ID from [dbo].[OOH_Vendor_Master] where Vendor_Pub_Code = Trim(@Lookup_PubCode)
				-- Inserting into mapping table
				INSERT INTO  [dbo].[OOH_FA_Mapping_Ref] (FA_Map_Vendor_ID,FA_Map_Agency_ID,FA_Map_FA_ID,FA_Map_Insertion_Date)
				VALUES(@Vendor_ID,1,@FA_ID,getdate())
			END
			ELSE
			BEGIN
					SELECT @Map_FA_ID = FA_Map_FA_ID from [dbo].[OOH_FA_Mapping_Ref] where FA_Map_Vendor_ID = @Vendor_ID
			
					IF (@lookup_SenderEmail <> TRIM(@Vendor_Sender_Email) OR @Vendor_Sender_Email IS NULL)
					BEGIN
						UPDATE [dbo].[OOH_Vendor_Master] SET Vendor_Sender_Email = @lookup_SenderEmail where Vendor_Id = @Vendor_ID
					END

					--- Id Publication name is updated 
					IF @Vendor_Publication <> @Lookup_Publication
					BEGIN
						UPDATE [dbo].[OOH_Vendor_Master] SET Vendor_Pub_Name = @Lookup_Publication where Vendor_Id = @Vendor_ID
					END

					-- Check if assigned FA has changed
					IF @Map_FA_ID <> @FA_ID
					BEGIN
						UPDATE [dbo].[OOH_FA_Mapping_Ref] set FA_Map_FA_ID = @FA_ID where FA_Map_Vendor_ID = @Vendor_ID	
					END

				
			END

	-- Fetch the next record from the cursor
 	FETCH NEXT FROM db_cursor INTO @Lookup_RepCode,@Lookup_PubCode,@Lookup_Publication,@lookup_SenderEmail,@lookup_TeamMember,@lookup_TeamMemberEmail 
	END		

	--  Close the cursor
	CLOSE db_cursor  

	-- Deallocate the cursor
	DEALLOCATE db_cursor 

	SET @Msg='SUCCESS'
 END TRY
 BEGIN CATCH

    SET @Msg=ERROR_MESSAGE()

END CATCH
GO




/************************************ StoredProcedure [SP_OOH_Matching] *************************************/


CREATE procedure [dbo].[SP_OOH_Matching]
 @Msg nvarchar(MAX)=null OUTPUT
 

as
BEGIN TRY
declare   @is_executed bit = null,
  @ctrdate datetime = getdate();

Declare @log_ID varchar(500);
declare @C varchar(500);
declare @P varchar(500);
declare @E varchar(500);
declare @found varchar(500);
declare @vendorId varchar(500);
declare @vendorName varchar(500);
declare @contractNo varchar(500);
declare @vendorNameFull varchar(500);
declare @date varchar(500);
declare @log_paid_unpaid varchar(500);
declare @log_insertion_month varchar(500);
declare @log_client_name varchar(500);
declare @log_publication_code varchar(500);
declare @log_publication_name varchar(500);
declare @log_product_name varchar(500);
declare @log_ismatched varchar(500);
declare @log_matched_to varchar(500);
declare @log_matched_to_id varchar(500);
--declare @cur1 cursor;
	DECLARE @is_set bit;
DECLARE @inv_date varchar(500);
DECLARE @mos varchar(500);
set @date=format(getdate(),'yyyy-dd-MM 00:00:00')

 declare cur1 scroll cursor for
	--set @cur1= cursor   for 

	select  Log_ID from [dbo].[OOH_Log_Txn] where Log_FA_Update_date is null 
	-- where Log_Insertion_Date='2022-08-05 00:00:00.000'
	-- select  Log_ID from [dbo].[OOH_Log_Txn] where Log_Insertion_Date=@date
	print 'one time'
	set @is_executed=1
	open cur1 

	fetch next  from cur1 into @log_ID

	--while 1=1
	while @@fetch_status=0
	begin
	
	print 'ID near fetch' +@log_ID

	--here

set @is_set=0

if(select  case when isdate(log_invoice_date)=1
and log_invoice_date like '[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
then 1 else 0 end from [dbo].[ooh_log_txn] as format where Log_id=@log_ID  )=1
begin
set @is_set=1
set @inv_date=( select log_invoice_date from [dbo].[ooh_log_txn] where  log_id=@log_ID)
print @inv_date
set @mos=(select left (convert(varchar,@inv_date,112), 7))
print @mos
	update [dbo].[OOH_Log_Txn] set Log_Invoice_MOS=@mos
	where Log_ID=@log_ID and Log_FA_Update_date is null 
end


--end
	--fetch  cur1 into @log_ID
	--if  @@fetch_status<>0
	print 'ID after this' 
	--begin
    print 'ID 2' 
	select @contractNo=Log_Invoice_ContractNumber from [dbo].[OOH_Log_Txn] where Log_ID=@log_ID
	if(
		select count(*) from [dbo].[OOH_Paid_Master] where Paid_Master_Contract_ID=@contractNo and paid_master_cease_Date is null)>0
		
		begin
		print 'ID' +@log_ID + @contractNo
		select top(1) @log_matched_to_id=paid_master_id,@C=Paid_Master_Client_Code,@P=Paid_Master_Product_Code,@E=Paid_Master_Est_Code,@vendorName=Paid_Master_Publication_Name ,
		@log_paid_unpaid='Paid',@log_insertion_month=paid_master_insertion_MOS_Month,@log_client_name=paid_master_client_name,@log_publication_code=paid_master_publication_code,@log_product_name=paid_master_product_name

	 ,@log_ismatched=1,@log_matched_to='Paid' 

		from [dbo].[OOH_Paid_Master] where Paid_Master_Contract_ID=@contractNo 
		Set @found='Yes' 
		select @vendorId=vendor_id,@vendorNameFull=vendor_name from [dbo].[OOH_Vendor_Master] where vendor_Pub_Name=@vendorName
		print 'ID' +@log_ID + @contractNo
		print 'in paid' +@C +@P+ @E +@vendorNameFull +@log_ID+ @vendorId +@log_paid_unpaid+@log_insertion_month+@log_client_name+@log_publication_code+@log_product_name+@vendorName+@log_matched_to+@log_matched_to_id+@log_ismatched
	update [dbo].[OOH_Log_Txn] set log_validated_c=@C,log_validated_p=@P,log_validated_e=@E ,
	log_paid_unpaid=@log_paid_unpaid,log_insertion_month=@log_insertion_month,log_client_name=@log_client_name,log_publication_code=@log_publication_code,log_publication_name=@vendorName,log_product_name=@log_product_name,
	log_matched_to=@log_matched_to,log_matched_to_id=@log_matched_to_id,log_ismatched=@log_ismatched
	where Log_ID=@log_ID and Log_FA_Update_date is null 
		end;

 if(select count(*) from [dbo].[OOH_Unpaid_Ref] where Unpaid_Ref_Contract_ID=@contractNo)>0 
   begin
   print 'ID' +@log_ID + @contractNo
   select top(1) @log_matched_to_id=unpaid_ref_id, @C=Unpaid_Ref_Client_Code,@P=Unpaid_Ref_Product_Code,@E=Unpaid_Ref_Est_Code,@vendorName=Unpaid_Ref_Publication_Name,
   @log_paid_unpaid='Unpaid',@log_insertion_month=unpaid_ref_insertion_MOS_Month,@log_client_name=unpaid_ref_client_name,@log_publication_code=unpaid_ref_publication_code,@log_product_name=unpaid_ref_product_name
    ,@log_ismatched=1,@log_matched_to='Unpaid' 
    from [dbo].[OOH_Unpaid_Ref] where (Unpaid_Ref_Contract_ID = @contractNo and Unpaid_Ref_Invoice_Number is  null) or    (Unpaid_Ref_Contract_ID = @contractNo and Unpaid_Ref_Invoice_Number='') order by convert(date,'01/'+unpaid_ref_insertion_mos_month) desc

   Set @found='Yes' 
   select @vendorId=vendor_id,@vendorNameFull=vendor_name from [dbo].[OOH_Vendor_Master] where vendor_Pub_Name=@vendorName
   print 'ID' +@log_ID + @contractNo
   	print 'in unpaid' +@C +@P+ @E +@vendorNameFull +@log_ID+@vendorId +@log_paid_unpaid+@log_insertion_month+@log_client_name+@log_publication_code+@log_product_name+@vendorName+@log_matched_to+@log_matched_to_id+@log_ismatched
	update [dbo].[OOH_Log_Txn] set log_validated_c=@C,log_validated_p=@P,log_validated_e=@E, 
	
	log_paid_unpaid=@log_paid_unpaid,log_insertion_month=@log_insertion_month,log_client_name=@log_client_name,log_publication_code=@log_publication_code,log_publication_name=@vendorName,log_product_name=@log_product_name
	,log_matched_to=@log_matched_to,log_matched_to_id=@log_matched_to_id,log_ismatched=@log_ismatched
	where Log_ID=@log_ID and Log_FA_Update_date is null 
   end;
	print 'ID 3' 
	
	 	
	fetch next  from cur1 into @log_ID
	if (@found='Yes')
	begin
	set @C='' 
	set @P=''
	 set @E='' 
	 set @vendorNameFull=''
	 set @vendorName=''
	 set @vendorId=''
	set @log_paid_unpaid=''
set @log_insertion_month =''
set @log_client_name =''
set @log_publication_code='' 
set @log_publication_name =''
set @log_product_name =''
set @log_ismatched ='';
set @log_matched_to ='';
set @log_matched_to_id ='';
	 end
	end;
	
	close cur1;
deallocate cur1;
 set @Msg='SUCCESS'
  END TRY

BEGIN CATCH

    SET @Msg=ERROR_MESSAGE()

END CATCH
  exec [dbo].[Append_Control_Report_SP]  @InvRecon_Is_Executed= @is_executed,@InvRecon_Execution_Date  = @ctrdate,@InvRecon_Exception  = @Msg
GO





/************************************ StoredProcedure [SP_OOH_PredictionGrid] *************************************/


-- =============================================
-- Author:      <Apurva Kundale>
-- Create Date: <02-Nov-2022>
-- Description: <Procedure to populate prediction grid with unpaid buys from Unpaid table for records for Log_txn 
-- whose FA action status is null >
-- =============================================


CREATE procedure [dbo].[SP_OOH_PredictionGrid]
( @Msg nvarchar(MAX)=null OUTPUT)
AS
BEGIN TRY
	
	--Variable Declaration
	DECLARE @Count INT
	DECLARE @RowNumber INT=1 --For iterating throuh loop
	DECLARE @Log_ID INT
	DECLARE @ClientCode VARCHAR(50) 
	DECLARE @ProductCode VARCHAR(50) 
	DECLARE @ESTCode VARCHAR(10) 
	DECLARE @PubCode VARCHAR(100) 
	DECLARE @ContractID VARCHAR(100)
	DECLARE @Extracted_MOS VARCHAR(100)
	DECLARE @MCode VARCHAR(10) = 'O'
	DECLARE @MatchCountInUnpaidRef INT

	--Truncating Temp table 
    TRUNCATE TABLE OOH_Temp_Log_Txn
	
	-- Truncating predictions table 
	TRUNCATE TABLE [dbo].[OOH_Predictions_Mview]

	--Getting records from OOH_Log_Txn : rcords having FA action status as NUL or blank, record type NEW 
	-- Date Range - One month back from current date

	;with CTE_Log_txn AS (
	SELECT 
	ROW_NUMBER () OVER (PARTITION BY (SELECT NULL) ORDER BY Log_ID) as RowNumber,
	[Log_ID],
	[Log_Validated_C],
	[Log_Validated_P],
	[Log_Validated_E],
	[Log_Invoice_ContractNumber],
	[Vendor_Pub_Code],
	[Log_Invoice_MOS]
	FROM OOH_Log_Txn LogT JOIN OOH_Vendor_Master VendorM ON 
	LogT.Log_Vendor_ID = VendorM.Vendor_ID
	where
	(LogT.Log_FA_Action_Status like '' or LogT.Log_FA_Action_Status is NULL ) 
	AND LogT.Log_Record_Type = 'NEW'
	--AND LogT.Log_Insertion_Date >= convert(date,dateadd(DAY,-30,getdate()))

	)

	-- Inserting Data from CTE into Temp table - OOH_Temp_Log_Txn
	INSERT INTO OOH_Prediction_Record_Stg ([PRecord_Row_Number],
	[PRecord_Log_ID],[PRecord_Log_C],[PRecord_Log_P],[PRecord_Log_E],[PRecord_Log_Contract_Number],[PRecord_Log_Publication_Code],[PRecord_Log_MOS])
	SELECT RowNumber,[Log_ID],
	[Log_Validated_C],
	[Log_Validated_P],
	[Log_Validated_E],
	[Log_Invoice_ContractNumber],
	[Vendor_Pub_Code],
	[Log_Invoice_MOS]
	FROM CTE_Log_txn

	--Getting count of records in Temp table - OOH_Temp_Log_Txn
	select @Count=count(*) from  OOH_Prediction_Record_Stg

	--Looping through the Temp Table 
	WHILE @RowNumber <> @Count+1
	BEGIN
		--Extract the details required from current record
		Select @Log_ID=PRecord_Log_ID ,@ClientCode =PRecord_Log_C, @ProductCode=PRecord_Log_P, @ESTCode =PRecord_Log_E,
		@ContractID = PRecord_Log_Contract_Number,@PubCode =PRecord_Log_Publication_Code, @Extracted_MOS = PRecord_Log_MOS
		FROM OOH_Prediction_Record_Stg
		WHERE PRecord_Row_Number = @RowNumber

		Select @Log_ID

		-- Checking in UnpaidRef table for possible buys based on C,P,Contract Id, Publication Code match
		-- CHecking for number of rows matched for a record
		SELECT @MatchCountInUnpaidRef = count(*) FROM OOH_Unpaid_Ref 
		WHERE
			 Unpaid_Ref_Publication_Code = @PubCode
		AND (Unpaid_Ref_Contract_ID LIKE
				CASE WHEN (@ContractID is NULL OR @ContractID = '') THEN
					'%%'
				ELSE
					Trim(@ContractID) 
				END)
		AND (Unpaid_Ref_Client_Code LIKE
				CASE WHEN (@ClientCode is NULL OR @ClientCode = '') THEN
					'%%'
				ELSE
					Trim(@ClientCode) 
				END)
		AND  (Unpaid_Ref_Product_Code LIKE
				CASE WHEN (@ProductCode is NULL OR @ProductCode= '') THEN
					'%%'
				ELSE
					Trim(@ProductCode) 
				END)
		

		IF @MatchCountInUnpaidRef >0
		BEGIN
			--Insert into Predictions table
			INSERT INTO [dbo].[OOH_Predictions_Mview]
			([Prediction_Log_ID],
			[Prediction_Rank],
			[Prediction_M],
			[Prediction_C],
			[Prediction_P],
			[Prediction_E],
			[Prediction_MOS],
			[Prediction_Unpaid_Insertion_Date],
			[Prediction_Unpaid_Contract_Id],
			[Prediction_Unpaid_IDesk_Recon],
			[Prediction_Unpaid_Net_Payable],
			[Prediction_Unpaid_Net_Paid],
			[Prediction_Unpaid_Pay_Address],
			[Prediction_Publication_Code],
			[Prediction_Publication])
			SELECT  @Log_ID,
					--Rank 
					CASE WHEN  @Extracted_MOS is NULL or @Extracted_MOS ='' THEN DENSE_RANK () over ( PARTITION BY (SELECT NULL)ORDER BY [unpaid_ref_Insertion_MOS_Month] DESC) 
						 WHEN DATEDIFF(MONTH,CONVERT(DATETIME, CONCAT('01/',unpaid_ref_Insertion_MOS_Month),3),TRY_CAST (concat(@Extracted_MOS,'-01') AS DATETIME)) = 0 THEN 1
						 WHEN DATEDIFF(MONTH,CONVERT(DATETIME, CONCAT('01/',unpaid_ref_Insertion_MOS_Month),3),TRY_CAST (concat(@Extracted_MOS,'-01') AS DATETIME)) > 0 THEN 2
						ELSE 3
					END,
					@MCode,
					Unpaid_Ref_Client_Code,
					Unpaid_Ref_Product_Code,
					Unpaid_Ref_EST_Code,
					Unpaid_Ref_Insertion_MOS_Month,
					Unpaid_Ref_Insertion_Date,
					Unpaid_Ref_Contract_ID,
					Unpaid_Ref_IDesk_Recon_Status,
					Unpaid_Ref_Payable_Net,
					Unpaid_Ref_Paid_Net, 
					Unpaid_Ref_Pay_Address, 
					Unpaid_Ref_Publication_Code,
					CONCAT(Unpaid_Ref_Publication_Name,' (',Unpaid_Ref_Publication_Code,')')
			FROM OOH_Unpaid_Ref 
			WHERE
				 Unpaid_Ref_Publication_Code = @PubCode
			AND (Unpaid_Ref_Contract_ID LIKE
					CASE WHEN (@ContractID is NULL OR @ContractID = '') THEN
						'%%'
					ELSE
						Trim(@ContractID) 
					END)
			AND (Unpaid_Ref_Client_Code LIKE
					CASE WHEN (@ClientCode is NULL OR @ClientCode = '') THEN
						'%%'
					ELSE
						Trim(@ClientCode) 
					END)
			AND  (Unpaid_Ref_Product_Code LIKE
					CASE WHEN (@ProductCode is NULL OR @ProductCode= '') THEN
						'%%'
					ELSE
						Trim(@ProductCode) 
					END)
			ORDER BY Unpaid_Ref_Insertion_MOS_Month DESC,Unpaid_Ref_EST_Code DESC
		END

		
		-- Setting Variables to NULL 
		SET @Log_ID = NULL
		SET @ClientCode = NULL
		SET @ProductCode = NULL
		SET @ESTCode = NULL
		SET @ContractID =NULL
		SET @PubCode =NULL
		SET @MatchCountInUnpaidRef = NULL
		SET @Extracted_MOS = NULL
		

	SET @RowNumber=@RowNumber+1
	END

END TRY
BEGIN CATCH

    SET @Msg=ERROR_MESSAGE()
	Print @mSG
END CATCH
GO






/************************************ StoredProcedure  [SP_paid_update] *************************************/


CREATE procedure [dbo].[SP_paid_update]

 @Msg nvarchar(MAX)=null OUTPUT

as
BEGIN TRY
declare   @is_executed bit = null,
 @date datetime = getdate()

INSERT into [dbo].[OOH_Paid_Master] 
( Paid_Master_CLI_Acc_Off,	
Paid_Master_Office,
Paid_Master_Client_Code,
Paid_Master_Client_Name,
Paid_Master_Product_Code,
Paid_Master_Product_Name,
Paid_Master_EST_Code,
Paid_Master_Paying_Rep,
Paid_Master_Publication_Code,
Paid_Master_Publication_Name,
Paid_Master_Insertion_Date,
Paid_Master_Insertion_MOS_Month,
Paid_Master_Contract_ID,
Paid_Master_Insertion_Order_Comment,
Paid_Master_Insertion_Order_Comment_4,
Paid_Master_Insertion_Order_Comment_2,
Paid_Master_Ordered_Net,
Paid_Master_Payable_Net,
Paid_Master_Paid_Net,
Paid_Master_Invoice_Number,
Paid_Master_Invoice_Dollar,
Paid_Master_Invoice_Comment,
Paid_Master_TS_Received,
Paid_Master_IDesk_Recon_Status,
Paid_Master_Special_Remittance_Comment,
Paid_Master_Pay_Address,
Paid_Master_Upload_ID,
Paid_Master_Insertion_Order_Comment_3,
Paid_Master_Deal_ID
	   ) 
select 
Paid_CLI_Acc_Off,	
Paid_Office,
Paid_Client_Code,
Paid_Client_Name,
Paid_Product_Code,
Paid_Product_Name,
Paid_EST_Code,
Paid_Paying_Rep,
Paid_Publication_Code,
Paid_Publication_Name,
Paid_Insertion_Date,
Paid_Insertion_MOS_Month,
Paid_Contract_ID,
replace(replace(Paid_Insertion_Order_Comment,'''',''),',',''),
replace(replace(Paid_Insertion_Order_Comment_4,'''',''),',',''),
replace(replace(Paid_Insertion_Order_Comment_2,'''',''),',',''),
replace(Paid_Ordered_Net,',',''),                                 
replace(Paid_Payable_Net,',',''),
replace(Paid_Paid_Net,',',''),
Paid_Invoice_Number,
replace(Paid_Invoice_Dollar,',',''),
replace(replace(Paid_Invoice_Comment,'''',''),',',''),
Paid_TS_Received,
Paid_IDesk_Recon_Status,
replace(replace(Paid_Special_Remittance_Comment,'''',''),',','')	,
Paid_Pay_Address,
Paid_Upload_ID,
Paid_Insertion_Order_Comment_3,
Paid_Deal_ID
                  	    	      				          	        	         	       	     	           	                     
from [dbo].[OOH_Paid_Stg]
where NOT exists
(select Paid_Master_CLI_Acc_Off,	
Paid_Master_Office,
Paid_Master_Client_Code,
Paid_Master_Client_Name,
Paid_Master_Product_Code,
Paid_Master_Product_Name,
Paid_Master_EST_Code,
Paid_Master_Paying_Rep,
Paid_Publication_Code,
Paid_Master_Publication_Name,
Paid_Master_Insertion_Date,
Paid_Master_Insertion_MOS_Month,
Paid_Master_Contract_ID,
Paid_Master_Insertion_Order_Comment,
Paid_Master_Insertion_Order_Comment_4,
Paid_Master_Insertion_Order_Comment_2,
Paid_Master_Ordered_Net,                                 
Paid_Master_Payable_Net,
Paid_Master_Paid_Net,
Paid_Master_Invoice_Number,
Paid_Master_Invoice_Dollar,
Paid_Master_Invoice_Comment,
Paid_Master_TS_Received,
Paid_Master_IDesk_Recon_Status,
Paid_Master_Special_Remittance_Comment,
Paid_Master_Pay_Address,
Paid_Master_Upload_ID,
Paid_Master_Insertion_Order_Comment_3,
Paid_Master_Deal_ID

	from [dbo].[OOH_Paid_Master]
	where

[dbo].[OOH_Paid_Stg].Paid_CLI_Acc_Off=[OOH_Paid_Master].Paid_Master_CLI_Acc_Off AND 
[dbo].[OOH_Paid_Stg].Paid_Office=[OOH_Paid_Master].Paid_Master_Office AND 
[dbo].[OOH_Paid_Stg].Paid_Client_Code=[OOH_Paid_Master].Paid_Master_Client_Code AND 
[dbo].[OOH_Paid_Stg].Paid_Client_Name=[OOH_Paid_Master].Paid_Master_Client_Name AND 
[dbo].[OOH_Paid_Stg].Paid_Product_Code=[OOH_Paid_Master].Paid_Master_Product_Code AND 
[dbo].[OOH_Paid_Stg].Paid_Product_Name=[OOH_Paid_Master].Paid_Master_Product_Name AND 
[dbo].[OOH_Paid_Stg].Paid_EST_Code=[OOH_Paid_Master].Paid_Master_EST_Code AND 
[dbo].[OOH_Paid_Stg].Paid_Paying_Rep=[OOH_Paid_Master].Paid_Master_Paying_Rep AND 
[dbo].[OOH_Paid_Stg].Paid_Publication_Code=[OOH_Paid_Master].Paid_Master_Publication_Code AND 
[dbo].[OOH_Paid_Stg].Paid_Publication_Name=[OOH_Paid_Master].Paid_Master_Publication_Name AND 
[dbo].[OOH_Paid_Stg].Paid_Insertion_Date=[OOH_Paid_Master].Paid_Master_Insertion_Date AND 
[dbo].[OOH_Paid_Stg].Paid_Insertion_MOS_Month=[OOH_Paid_Master].Paid_Master_Insertion_MOS_Month AND 
[dbo].[OOH_Paid_Stg].Paid_Contract_ID=[OOH_Paid_Master].Paid_Master_Contract_ID AND 
replace(replace([dbo].[OOH_Paid_Stg].Paid_Insertion_Order_Comment,'''',''),',','')=[OOH_Paid_Master].Paid_Master_Insertion_Order_Comment AND 
replace(replace([dbo].[OOH_Paid_Stg].Paid_Insertion_Order_Comment_4,'''',''),',','')=[OOH_Paid_Master].Paid_Master_Insertion_Order_Comment_4 AND 
replace(replace([dbo].[OOH_Paid_Stg].Paid_Insertion_Order_Comment_2,'''',''),',','')=[OOH_Paid_Master].Paid_Master_Insertion_Order_Comment_2 AND 
replace([dbo].[OOH_Paid_Stg].Paid_Ordered_Net,',','')=[OOH_Paid_Master].Paid_Master_Ordered_Net AND 
replace([dbo].[OOH_Paid_Stg].Paid_Payable_Net,',','')=[OOH_Paid_Master].Paid_Master_Payable_Net AND 
replace([dbo].[OOH_Paid_Stg].Paid_Paid_Net,',','')=[OOH_Paid_Master].Paid_Master_Paid_Net AND 
[dbo].[OOH_Paid_Stg].Paid_Invoice_Number=[OOH_Paid_Master].Paid_Master_Invoice_Number AND 
replace([dbo].[OOH_Paid_Stg].Paid_Invoice_Dollar,',','')=[OOH_Paid_Master].Paid_Master_Invoice_Dollar AND 
replace(replace([dbo].[OOH_Paid_Stg].Paid_Invoice_Comment,'''',''),',','')=[OOH_Paid_Master].Paid_Master_Invoice_Comment AND 
[dbo].[OOH_Paid_Stg].Paid_TS_Received=[OOH_Paid_Master].Paid_Master_TS_Received AND 
[dbo].[OOH_Paid_Stg].Paid_IDesk_Recon_Status=[OOH_Paid_Master].Paid_Master_IDesk_Recon_Status AND 
replace(replace([dbo].[OOH_Paid_Stg].Paid_Special_Remittance_Comment,'''',''),',','')=[OOH_Paid_Master].Paid_Master_Special_Remittance_Comment  AND
[dbo].[OOH_Paid_Stg].Paid_Pay_Address = [OOH_Paid_Master].Paid_Master_Pay_Address AND
[dbo].[OOH_Paid_Stg].Paid_Upload_ID=[OOH_Paid_Master].Paid_Master_Upload_ID AND
replace(replace([dbo].[OOH_Paid_Stg].Paid_Insertion_Order_Comment_3,'''',''),',','')=[OOH_Paid_Master].Paid_Master_Insertion_Order_Comment_3 AND 
[dbo].[OOH_Paid_Stg].Paid_Deal_ID=[OOH_Paid_Master].Paid_Master_Deal_ID 
)

 set @Msg='SUCCESS'
 END TRY

BEGIN CATCH

    SET @Msg=ERROR_MESSAGE()

END CATCH
exec [dbo].[Append_Control_Report_SP]  @PaidUnpaid_Refresh_Is_Executed= @is_executed,@PaidUnpaid_Refresh_Execution_Date  = @date,@PaidUnpaid_Refresh_Exception  = @Msg
GO





/************************************ StoredProcedure [SP_SaveUpdate] *************************************/



CREATE procedure [dbo].[SP_SaveUpdate] @ContractID varchar(500) ,@log_ID_Input varchar(500)
as


Declare @log_ID varchar(500);
declare @C varchar(500);
declare @P varchar(500);
declare @E varchar(500);
declare @found varchar(500);
declare @vendorId varchar(500);
declare @vendorName varchar(500);
declare @contractNo varchar(500);
declare @vendorNameFull varchar(500);
declare @date varchar(500);
declare @log_paid_unpaid varchar(500);
declare @log_insertion_month varchar(500);
declare @log_client_name varchar(500);
declare @log_publication_code varchar(500);
declare @log_publication_name varchar(500);
declare @log_product_name varchar(500);
declare @log_ismatched varchar(500);
declare @log_matched_to varchar(500);
declare @log_matched_to_id varchar(500);
set @found = 'No'
set @date = format(getdate(), 'yyyy-dd-MM 00:00:00')
--set @contractNo = '77973'
set @contractNo=@ContractID
set @log_ID=@log_ID_Input
select @log_ID = Log_ID
from [dbo].[OOH_Log_Txn]
where Log_Invoice_ContractNumber = @contractNo and log_ID=@log_ID
print 'ID near fetch' + @log_ID
if
(
    select count(*)
    from [dbo].[OOH_Paid_Master]
    where Paid_Master_Contract_ID = @contractNo
	
         
) > 0
begin
    print 'ID' + @log_ID + @contractNo
	print 'in if 1'
    select top (1)
        @log_matched_to_id = paid_master_id,
        @C  = Paid_Master_Client_Code,
        @P  = Paid_Master_Product_Code,
        @E  = Paid_Master_Est_Code,
        @vendorName = Paid_Master_Publication_Name,
        @log_paid_unpaid = 'Paid',
        @log_insertion_month = paid_master_insertion_MOS_Month,
        @log_client_name = paid_master_client_name,
        @log_publication_code = paid_master_publication_code,
        @log_product_name = paid_master_product_name,
        @log_ismatched = 1,
        @log_matched_to = 'Paid'
    from [dbo].[OOH_Paid_Master]
    where Paid_Master_Contract_ID = @contractNo
    Set @found = 'Yes'
    select @vendorId = vendor_id,
           @vendorNameFull = vendor_name
    from [dbo].[OOH_Vendor_Master]
    where vendor_Pub_Name = @vendorName
	print 'in if 1'
    print 'ID' + @log_ID + @contractNo
    print 'in paid' + @C + @P + @E + @vendorNameFull + @log_ID + @vendorId + @log_paid_unpaid + @log_insertion_month
          + @log_client_name + @log_publication_code + @log_product_name + @vendorName + @log_matched_to
          + @log_matched_to_id + @log_ismatched
    update [dbo].[OOH_Log_Txn]
    set --log_vendor_id = @vendorId,
        log_validated_c = @C,
        log_validated_p = @P,
        log_validated_e = @E,
        log_paid_unpaid = @log_paid_unpaid,
        log_insertion_month = @log_insertion_month,
        log_client_name = @log_client_name,
        log_publication_code = @log_publication_code,
        log_publication_name = @vendorName,
        log_product_name = @log_product_name,
        log_matched_to = @log_matched_to,
        log_matched_to_id = @log_matched_to_id,
        log_ismatched = @log_ismatched
    where Log_ID = @log_ID

end;

if
(
    select count(*)
    from [dbo].[OOH_Unpaid_Ref]
    where Unpaid_Ref_Contract_ID = @contractNo
) > 0
begin
    print 'ID' + @log_ID + @contractNo
	print 'in if 2'
    select top (1)
        @log_matched_to_id = unpaid_ref_id,
        @C  = Unpaid_Ref_Client_Code,
        @P  = Unpaid_Ref_Product_Code,
        @E  = Unpaid_Ref_Est_Code,
        @vendorName = Unpaid_Ref_Publication_Name,
        @log_paid_unpaid = 'Unpaid',
        @log_insertion_month = unpaid_ref_insertion_MOS_Month,
        @log_client_name = unpaid_ref_client_name,
        @log_publication_code = unpaid_ref_publication_code,
        @log_product_name = unpaid_ref_product_name,
        @log_ismatched = 1,
        @log_matched_to = 'Unpaid'
    from [dbo].[OOH_Unpaid_Ref]
    where(Unpaid_Ref_Contract_ID = @contractNo and Unpaid_Ref_Invoice_Number is  null) or    (Unpaid_Ref_Contract_ID = @contractNo and Unpaid_Ref_Invoice_Number='') or (Unpaid_Ref_Contract_ID = @contractNo and Unpaid_Ref_Invoice_Number=0)order by convert(date,'01/'+unpaid_ref_insertion_mos_month) desc
    Set @found = 'Yes'
    select @vendorId = vendor_id,
           @vendorNameFull = vendor_name
    from [dbo].[OOH_Vendor_Master]
    where vendor_Pub_Name = @vendorName
    print 'ID' + @log_ID + @contractNo
	 print 'in unpaid' + @found + @C + @P + @E + @vendorNameFull + @log_ID + @vendorId + @log_paid_unpaid
          + @log_insertion_month + @log_client_name + @log_publication_code + @log_product_name + @vendorName
          + @log_matched_to + @log_matched_to_id + @log_ismatched
		  print 'in if 2'
    update [dbo].[OOH_Log_Txn]
    set log_vendor_id = @vendorId,
        log_validated_c = @C,
        log_validated_p = @P,
        log_validated_e = @E,
        log_paid_unpaid = @log_paid_unpaid,
        log_insertion_month = @log_insertion_month,
        log_client_name = @log_client_name,
        log_publication_code = @log_publication_code,
        log_publication_name = @vendorName,
        log_product_name = @log_product_name,
        log_matched_to = @log_matched_to,
        log_matched_to_id = @log_matched_to_id,
        log_ismatched = @log_ismatched
    where Log_ID = @log_ID 
end;
print 'ID 3'

if (@found = 'No')
begin
    set @C = ''
    set @P = ''
    set @E = ''
    set @vendorNameFull = ''
    set @vendorName = ''
    set @vendorId = ''
    set @log_paid_unpaid = ''
    set @log_insertion_month = ''
    set @log_client_name = ''
    set @log_publication_code = ''
    set @log_publication_name = ''
    set @log_product_name = ''
    set @log_ismatched = '';
    set @log_matched_to = '';
    set @log_matched_to_id = '';
    print 'not found' + @C + @P + @E + @vendorNameFull + @log_ID + @vendorId + @log_paid_unpaid + @log_insertion_month
          + @log_client_name + @log_publication_code + @log_product_name + @vendorName + @log_matched_to
          + @log_matched_to_id + @log_ismatched;

   /* update [dbo].[OOH_Log_Txn]
    set log_vendor_id = @vendorId,
        log_validated_c = @C,
        log_validated_p = @P,
        log_validated_e = @E,
        log_paid_unpaid = @log_paid_unpaid,
        log_insertion_month = @log_insertion_month,
        log_client_name = @log_client_name,
        log_publication_code = @log_publication_code,
        log_publication_name = @vendorName,
        log_product_name = @log_product_name,
        log_matched_to = @log_matched_to,
        log_matched_to_id = @log_matched_to_id,
        log_ismatched = @log_ismatched
    where Log_ID = @log_ID */
end

GO





/************************************ StoredProcedure [SP_Unpaid_Refresh] *************************************/

-- StoredProcedure [SP_Unpaid_Refresh]



CREATE procedure [dbo].[SP_Unpaid_Refresh]
 @Msg nvarchar(MAX)=null OUTPUT
 

as
BEGIN TRY
declare   @is_executed bit = null,
  @date datetime = getdate()
 --set @date=format(getdate(),'yyyy-dd-MM hh:mm:ss')
truncate table [dbo].[OOH_Unpaid_Ref]
set @is_executed=1
Insert into [dbo].[OOH_Unpaid_Ref]
(
Unpaid_Ref_CLI_Acc_Off,	
Unpaid_Ref_Office,
Unpaid_Ref_Client_Code,
Unpaid_Ref_Client_Name,
Unpaid_Ref_Product_Code,
Unpaid_Ref_Product_Name,
Unpaid_Ref_EST_Code,
Unpaid_Ref_Paying_Rep,
Unpaid_Ref_Publication_Code,
Unpaid_Ref_Publication_Name,
Unpaid_Ref_Insertion_Date,
Unpaid_Ref_Insertion_MOS_Month,
Unpaid_Ref_Contract_ID,
Unpaid_Ref_Insertion_Order_Comment,
Unpaid_Ref_Insertion_Order_Comment_4,
Unpaid_Ref_Insertion_Order_Comment_2,
Unpaid_Ref_Ordered_Net,
Unpaid_Ref_Payable_Net,
Unpaid_Ref_Paid_Net,
Unpaid_Ref_Invoice_Number,
Unpaid_Ref_Invoice_Dollar,
Unpaid_Ref_Invoice_Comment,
Unpaid_Ref_TS_Received,
Unpaid_Ref_IDesk_Recon_Status,
Unpaid_Ref_Special_Remittance_Comment,
Unpaid_Ref_Pay_Address,
Unpaid_Ref_Upload_UniqueID,
Unpaid_Ref_Insertion_Order_Comment_3,
Unpaid_Ref_Deal_ID
)

select 
Unpaid_CLI_Acc_Off,	
Unpaid_Office,
Unpaid_Client_Code,
Unpaid_Client_Name,
Unpaid_Product_Code,
Unpaid_Product_Name,
Unpaid_EST_Code,
Unpaid_Paying_Rep,
Unpiad_Publication_Code,
Unpaid_Publication_Name,
Unpaid_Insertion_Date,
Unpaid_Insertion_MOS_Month,
Unpaid_Contract_ID,
replace(replace(Unpaid_Insertion_Order_Comment,'''',''),',',''),
replace(replace(Unpaid_Insertion_Order_Comment_4,'''',''),',',''),
replace(replace(Unpaid_Insertion_Order_Comment_2,'''',''),',',''),
replace(Unpaid_Ordered_Net,',',''),                                 
replace(Unpaid_Payable_Net,',',''),
replace(Unpaid_Paid_Net,',',''),
Unpaid_Invoice_Number,
replace(Unpaid_Invoice_Dollar,',',''),
replace(replace(Unpaid_Invoice_Comment,'''',''),',',''),
Unpaid_TS_Received,
Unpaid_IDesk_Recon_Status,
replace(replace(Unpaid_Special_Remittance_Comment,'''',''),',',''),
Unpaid_Pay_Address,
Unpaid_Upload_UniqueID,
Unpaid_Insertion_Order_Comment_3,
Unpaid_Deal_ID

 from [dbo].[OOH_Unpaid_Stg]

 set @Msg='SUCCESS'

 END TRY

BEGIN CATCH

    SET @Msg=ERROR_MESSAGE()

END CATCH
  exec [dbo].[Append_Control_Report_SP]  @PaidUnpaid_Refresh_Is_Executed= @is_executed,@PaidUnpaid_Refresh_Execution_Date  = @date,@PaidUnpaid_Refresh_Exception  = @Msg
GO





/************************************ StoredProcedure [Update_FA_By_Vendor_SP] *************************************/

-- StoredProcedure [Update_FA_By_Vendor_SP]



CREATE PROCEDURE [dbo].[Update_FA_By_Vendor_SP] (@VendorId_In  VARCHAR(500),
                                         @log_ID_Input VARCHAR(500),
                                         @FA_ID_In     VARCHAR(500)=NULL)
AS
    DECLARE @log_ID VARCHAR(500);
    DECLARE @found VARCHAR(500);
    DECLARE @vendorId VARCHAR(500);
    DECLARE @FA_Id VARCHAR(500);
    DECLARE @date VARCHAR(500);
	DECLARE @is_set bit;

    --declare @VendorId_In varchar(500)='38'
    --declare @log_ID_Input varchar(500)='50'
    --declare @FA_ID_In varchar(500);
    SET @vendorId = @VendorId_In
    SET @log_ID=@log_ID_Input

    IF @FA_ID_In=0
      BEGIN
          PRINT'in fa id input null provided'
               + @VendorId_In + @vendorId

          SELECT TOP(1) @FA_Id = [fa_map_fa_id]
          FROM   [dbo].[ooh_fa_mapping_ref]
          WHERE  [fa_map_vendor_id] = @vendorId

          PRINT + @FA_Id
                + 'found for vendor and lo id provided'

          IF @FA_Id IS NOT NULL
            BEGIN
                PRINT 'ID' + @log_ID + @FA_Id + 'updating'

                UPDATE [dbo].[ooh_log_txn]
                SET    log_vendor_id = @vendorId,
                       log_fa_id = @FA_Id
                WHERE  log_id = @log_ID
            END;

          IF @FA_Id IS NULL
            BEGIN
                PRINT 'ID' + @log_ID + @FA_Id + 'updating'

                UPDATE [dbo].[ooh_log_txn]
                SET    log_vendor_id = @vendorId,
                       log_fa_id = 5
                WHERE  log_id = @log_ID

                PRINT
'set fa id to 5- review vendor -- elsse of no fa found for vendor provided'
END;
END;

    IF @FA_ID_In not in (0)
      BEGIN
          PRINT 'in provided fa id is there'

          IF (SELECT Count(*)
              FROM   [dbo].[ooh_fa_mapping_ref]
              WHERE  [fa_map_vendor_id] = @vendorId
                     AND [fa_map_fa_id] = @FA_ID_In) > 0
            BEGIN
                PRINT 'update fa id to' + @FA_ID_In
                      + 'for vendor in log tx ' + @vendorId

                UPDATE [dbo].[ooh_log_txn]
                SET    log_vendor_id = @vendorId,
                       log_fa_id = @FA_ID_In
                WHERE  log_id = @log_ID
				set @is_set=1
            

          IF @is_set IS NULL
            BEGIN
                UPDATE [dbo].[ooh_log_txn]
                SET    log_vendor_id = @vendorId,
                       log_fa_id = 5
                WHERE  log_id = @log_ID

                PRINT
'set fa id to 5- review vendor -- elsse of no fa found for fa selected fa id provided'
END;
end;
END;

GO


