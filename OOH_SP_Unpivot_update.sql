
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Apurva Kundale>
-- Create Date: <27-Sept-2022>
-- Description: <Procedure to update data from lookup to Database>
-- =============================================


ALTER procedure [dbo].[SP_Lookup_Reimport]
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
