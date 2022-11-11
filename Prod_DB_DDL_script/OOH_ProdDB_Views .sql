/*************************************** View [OOH_Log_TXN_VIEW] *****************************************************/



 CREATE VIEW [dbo].[OOH_Log_TXN_VIEW] 
 As
 SELECT   
	[Log_ID],
	mst.[Log_Vendor_ID] AS Vendor_ID,
	[Vendor_Name],
	mst.[Log_Agency_ID] AS Agency_ID,
	[Agency_name],
	mst.[Log_FA_ID] AS FA_ID,
	[FA_NAME], 
	[FA_Email_ID],
	[Inv_Cat_label], 
	[Log_Record_Type],
	[Log_Paid_Unpaid] ,
	Case ISDATE([Log_Invoice_Date])   
	WHEN 0 THEN NULL
	ELSE CONVERT(DATE, CONVERT(DATE,[Log_Invoice_Date]), 20) 
	END AS [Log_Invoice_Date],  --- Added on 26th Aug to avoid bad extraction
	--CONVERT(DATE, convert(date,REPLACE([Log_Invoice_Date],'',NULL)), 20) AS [Log_Invoice_Date] ,
	--[Log_Invoice_Date],
	[Log_Insertion_Date] ,
	[Log_Invoice_FileName] ,
	[Log_Invoice_Number] ,
	[Log_Invoice_RemittanceAddress] ,
	[Log_Remittance_Pass] ,
	[Log_Invoice_Amount] ,
	[Log_Invoice_ExtractedTax] ,
	[Log_Invoice_ExtractedTotal] ,
	[Log_Invoice_ExtractedSubTotal] ,
	[Log_Invoice_ContractNumber] ,
	[Log_Invoice_Advertiser_Name] ,
	[Log_Invoice_Media_ID],
	[Log_Invoice_MOS] ,
	[Log_Buy_Amount] ,
	[Log_Tax_Amount] ,
	[Log_Buy_Tax] ,
	[Log_Invoice_CPE] ,
	[Log_Validated_C] ,
	[Log_Validated_P] ,
	[Log_Validated_E] ,
	[Log_Insertion_Month] ,
	[Log_Campaign_ID_Match] ,
	[Log_Insertion_Order_Ext_Match] ,
	[Log_Invoice_Sender_Name] ,
	[Log_Invoice_Sender_Email] ,
	[Log_Invoice_Sender_GUID] ,
	[Log_Invoice_Sender_EmailDate] ,
	[Log_Invoice_PageCount],
	[Log_Invoice_ConfidenceScore],
	[Log_Client_Name] ,
	[Log_Publication_Code] ,
	[Log_Publication_Name] ,
	[Log_Product_Name] ,
	[Log_UUID] ,
	[Log_SP_FilePath] ,
	[Log_VM_FilePath] ,
	[Log_IsMatched] ,
	[Log_Matched_To] ,
	[Log_Matched_To_ID],
	[Log_Embargo_Flag] ,
	[Log_Embargo_Reason] ,
	[Log_IsZipped] ,
	[Log_CompilationStatus] ,
	[Log_InFolder] ,
	[Log_Manual_Override] ,
	[Log_Manual_Override_Date] ,
	[Log_FA_Interface_Ready] ,
	[Log_FA_Action_Status] ,
	[Log_FA_Update_Date] ,
	[Log_FA_Interface_Log_Status] ,
	[Log_FA_P_Desc_NR],
	S9.[Log_S9_Run_Date] as Log_S9_Run_Date,
    CONVERT(INT, REPLACE(SUBSTRING(CONVERT(VARCHAR, convert(DATE,[Log_Insertion_Date]), 23), 1, 10),'-','')) As Log_InvoiceDateAsInt,
	CONVERT(INT, REPLACE(SUBSTRING(CONVERT(VARCHAR, convert(DATE,[Log_S9_Run_Date]), 23), 1, 10),'-','')) As Log_S9ProcessDateAsInt,
	convert(decimal(18,2),Trim(REPLACE(REPLACE(CASE WHEN [Log_Invoice_Amount] is null THEN '0'  WHEN [Log_Invoice_Amount] like '' 
	THEN '0' ELSE Log_Invoice_Amount END,'$',''),',',''))) As Log_InvoiceAmountAsFlt,	
	CASE WHEN [Log_IsMatched] = 1 THEN 'Yes' ELSE 'No' END AS Log_IsMatched_YesNo
 FROM [dbo].[OOH_Log_Txn] mst
	LEFT JOIN  [dbo].[OOH_Vendor_Master] vendor
 ON mst.Log_Vendor_ID = vendor.Vendor_id
	LEFT JOIN [dbo].[OOH_Agency_Master] agency
 ON mst.Log_Agency_ID = agency.Agency_id
	LEFT JOIN [dbo].[OOH_FA_Master] FA
 ON mst.Log_FA_ID = FA.FA_ID
	LEFT JOIN [dbo].[OOH_Invoice_Category_Ref] cat
 ON mst.log_Inv_cat_id = cat.Inv_Cat_ID
	LEFT JOIN [dbo].[OOH_S9_Txn] S9
 ON mst.Log_ID = S9.S9_Log_ID
 
 
GO




/*************************************** View [vw_DistinctMOSUnpaid] **************************************************/


CREATE view [dbo].[vw_DistinctMOSUnpaid] 
 As
 select distinct([Unpaid_ref_Insertion_MOS_Month]),convert(int, concat(RIGHT([Unpaid_ref_Insertion_MOS_Month],2),LEFT([Unpaid_ref_Insertion_MOS_Month],2))) As [Unpaid_ref_Insertion_MOS_Month_As_INT]
 FROM [dbo].[OOH_Unpaid_Ref]
GO



/*************************************** View [fa_unpivot_view] **************************************************/



CREATE view [dbo].[fa_unpivot_view] as
select a.FA_Email_ID as fa, b.Vendor_Name as vendor, c.Agency_Name as agency  from OOH_FA_Master a, OOH_Vendor_Master b, OOH_Agency_Master c, OOH_FA_Mapping_Ref d 
where a.FA_ID = d.FA_Map_FA_ID and b.Vendor_ID = d.FA_Map_Vendor_ID and c.Agency_ID = d.FA_Map_Agency_ID
GO
