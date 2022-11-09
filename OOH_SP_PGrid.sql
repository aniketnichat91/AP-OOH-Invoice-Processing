SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Apurva Kundale>
-- Create Date: <02-Nov-2022>
-- Description: <Procedure to populate prediction grid with unpaid buys from Unpaid table for records for Log_txn 
-- whose FA action status is null >
-- =============================================


ALTER procedure [dbo].[SP_OOH_PredictionGrid]
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
	[Log_Publication_Code],
	[Log_Invoice_MOS]
	FROM OOH_Log_Txn 
	where
	(Log_FA_Action_Status like '' or Log_FA_Action_Status is NULL ) 
	AND Log_Record_Type = 'NEW'
	--AND Log_Insertion_Date >= convert(date,dateadd(DAY,-30,getdate()))

	)

	-- Inserting Data from CTE into Temp table - OOH_Temp_Log_Txn
	INSERT INTO OOH_Temp_Log_Txn (Temp_Row_Number,
	Temp_Log_ID,Temp_Log_C,Temp_Log_P,Temp_Log_E,Temp_Log_Contract_Number,Temp_Log_Publication_Code,Temp_Log_MOS)
	SELECT RowNumber,[Log_ID],
	[Log_Validated_C],
	[Log_Validated_P],
	[Log_Validated_E],
	[Log_Invoice_ContractNumber],
	[Log_Publication_Code],
	[Log_Invoice_MOS]
	FROM CTE_Log_txn

	--Getting count of records in Temp table - OOH_Temp_Log_Txn
	select @Count=count(*) from  OOH_Temp_Log_Txn

	--Looping through the Temp Table 
	WHILE @RowNumber <> @Count+1
	BEGIN
		--Extract the details required from current record
		Select @Log_ID=Temp_Log_ID ,@ClientCode =Temp_Log_C, @ProductCode=Temp_Log_P, @ESTCode =Temp_Log_E,
		@ContractID =Temp_Log_Contract_Number ,@PubCode =Temp_Log_Publication_Code, @Extracted_MOS = Temp_Log_MOS
		FROM OOH_Temp_Log_Txn
		WHERE Temp_Row_Number = @RowNumber

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
			[Prediction_Publication_Code] )
			SELECT  @Log_ID,
					 -- rank pending
					--Rank() over (partition by (select null) order by Unpaid_Ref_Insertion_MOS_Month DESC,Unpaid_Ref_EST_Code DESC),
					DENSE_RANK () OVER ( 
					PARTITION BY --unpaid_ref_Insertion_MOS_Month
					CASE WHEN 
							dateDiff(month,convert(dateTime, concat('01/',unpaid_ref_Insertion_MOS_Month),3),TRY_CAST (@Extracted_MOS AS DATETIME)) = 0 THEN 1
					END 
					ORDER BY [unpaid_ref_Insertion_MOS_Month] ),
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
					Unpaid_Ref_Publication_Code
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