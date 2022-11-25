
-- OOH_Agency_Master table 

CREATE TABLE [dbo].[OOH_Agency_Master](
	[Agency_ID] [int] IDENTITY(1,1) NOT NULL,
	[Agency_Name] [varchar](100) NULL,
	[Agency_Email] [varchar](200) NULL,
	[Agency_VM_Details] [varchar](100) NULL,
	[Agency_Prisma_CLI_Code] [varchar](20) NULL,
	[Agency_Office_Codes] [varchar](20) NULL,
	[Agency_Internal_Rule_Flag] [bit] NULL,
	[Agency_Attachment_Flag] [bit] NULL,
	[Agency_Forward_Flag] [bit] NULL,
	[Agency_XaxisRule_Flag] [bit] NULL,
	[Agency_Rules_URL] [varchar](500) NULL,
	[Agency_Insertion_Date] [datetime] NULL,
	[Agency_Cease_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Agency_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_Vendor_Master
CREATE TABLE [dbo].[OOH_Vendor_Master](
	[Vendor_ID] [int] IDENTITY(1,1) NOT NULL,
	[Vendor_Name] [varchar](200) NULL,
	[Vendor_Rep_Code] [int] NULL,
	[Vendor_Sender_Email] [varchar](500) NULL,
	[Vendor_Pub_Name] [varchar](200) NULL,
	[Vendor_Pub_Code] [varchar](100) NULL,
	[Vendor_Source_Type] [varchar](100) NULL,
	[Vendor_Insertion_Date] [datetime] NULL,
	[Vendor_Cease_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Vendor_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--OOH_Control_Rpt table
CREATE TABLE [dbo].[OOH_Control_Rpt](
	[Ctrl_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ctrl_ReportWriter_Is_Executed] [bit] NULL,
	[Ctrl_ReportWriter_Execution_Date] [datetime] NULL,
	[Ctrl_ReportWriter_Exception] [varchar](500) NULL,
	[Ctrl_ETL_Is_Executed] [bit] NULL,
	[Ctrl_ETL_Execution_Date] [datetime] NULL,
	[Ctrl_ETL_Exception] [varchar](500) NULL,
	[Ctrl_PaidUnpaid_Refresh_Is_Executed] [bit] NULL,
	[Ctrl_PaidUnpaid_Refresh_Execution_Date] [datetime] NULL,
	[Ctrl_PaidUnpaid_Refresh_Exception] [varchar](500) NULL,
	[Ctrl_InvExt_Is_Executed] [bit] NULL,
	[Ctrl_InvExt_Execution_Date] [datetime] NULL,
	[Ctrl_InvExt_Exception] [varchar](500) NULL,
	[Ctrl_InvRecon_Is_Executed] [bit] NULL,
	[Ctrl_InvRecon_Execution_Date] [datetime] NULL,
	[Ctrl_InvRecon_Exception] [varchar](500) NULL,
	[Ctrl_S9_Is_Executed] [bit] NULL,
	[Ctrl_S9_Execution_Date] [datetime] NULL,
	[Ctrl_S9_Exception] [varchar](500) NULL,
	[Ctrl_Execution_Date] [datetime] NULL,
	[Ctrl_Lookup_Reimport_Is_Executed] [bit] NULL,
	[Ctrl_Lookup_Reimport_Execution_Date] [datetime] NULL,
	[Ctrl_Lookup_Reimport_Exception] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Ctrl_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_FA_Lookup_Stg table 
CREATE TABLE [dbo].[OOH_FA_Lookup_Stg](
	[FA_Lookup_ID] [int] IDENTITY(1,1) NOT NULL,
	[FA_Lookup_No] [varchar](100) NULL,
	[FA_Lookup_PayRep] [varchar](200) NULL,
	[FA_Lookup_PubCode] [varchar](200) NULL,
	[FA_Lookup_Publication] [varchar](200) NULL,
	[FA_Lookup_PublicationName_Zone] [varchar](1000) NULL,
	[FA_Lookup_SenderEmail] [varchar](1000) NULL,
	[FA_Lookup_TeamMember] [varchar](500) NULL,
	[FA_Lookup_TeamMemberEmail] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[FA_Lookup_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- OOH_FA_Master
CREATE TABLE [dbo].[OOH_FA_Master](
	[FA_ID] [int] IDENTITY(1,1) NOT NULL,
	[FA_Name] [varchar](200) NULL,
	[FA_Email_ID] [varchar](500) NULL,
	[FA_Region] [varchar](200) NULL,
	[FA_Country] [varchar](200) NULL,
	[FA_Business_Team] [varchar](200) NULL,
	[FA_Insertion_Date] [datetime] NULL,
	[FA_Cease_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[FA_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_FA_Mapping_Ref
CREATE TABLE [dbo].[OOH_FA_Mapping_Ref](
	[FA_Map_ID] [int] IDENTITY(1,1) NOT NULL,
	[FA_Map_Vendor_ID] [int] NULL,
	[FA_Map_Agency_ID] [int] NULL,
	[FA_Map_FA_ID] [int] NULL,
	[FA_Map_Insertion_Date] [datetime] NULL,
	[FA_Map_Cease_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[FA_Map_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [FA_Map_UniqueCombination] UNIQUE NONCLUSTERED 
(
	[FA_Map_Vendor_ID] ASC,
	[FA_Map_Agency_ID] ASC,
	[FA_Map_FA_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OOH_FA_Mapping_Ref]  WITH CHECK ADD  CONSTRAINT [FK_FA_Mapping_Agency] FOREIGN KEY([FA_Map_Agency_ID])
REFERENCES [dbo].[OOH_Agency_Master] ([Agency_ID])
GO

ALTER TABLE [dbo].[OOH_FA_Mapping_Ref] CHECK CONSTRAINT [FK_FA_Mapping_Agency]
GO

ALTER TABLE [dbo].[OOH_FA_Mapping_Ref]  WITH CHECK ADD  CONSTRAINT [FK_FA_Mapping_FA] FOREIGN KEY([FA_Map_FA_ID])
REFERENCES [dbo].[OOH_FA_Master] ([FA_ID])
GO

ALTER TABLE [dbo].[OOH_FA_Mapping_Ref] CHECK CONSTRAINT [FK_FA_Mapping_FA]
GO

ALTER TABLE [dbo].[OOH_FA_Mapping_Ref]  WITH CHECK ADD  CONSTRAINT [FK_FA_Mapping_Vendor] FOREIGN KEY([FA_Map_Vendor_ID])
REFERENCES [dbo].[OOH_Vendor_Master] ([Vendor_ID])
GO

ALTER TABLE [dbo].[OOH_FA_Mapping_Ref] CHECK CONSTRAINT [FK_FA_Mapping_Vendor]
GO



--OOH_Source_Ref
CREATE TABLE [dbo].[OOH_Source_Ref](
	[Source_ID] [int] IDENTITY(1,1) NOT NULL,
	[Source_Type] [varchar](200) NULL,
	[Source_Value] [varchar](500) NULL,
	[Source_Vendor_ID] [int] NULL,
	[Source_Agency_ID] [int] NULL,
	[Source_Insertion_Date] [datetime] NULL,
	[Source_Cease_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OOH_Source_Ref]  WITH CHECK ADD  CONSTRAINT [FK_Source_Agency] FOREIGN KEY([Source_Agency_ID])
REFERENCES [dbo].[OOH_Agency_Master] ([Agency_ID])
GO

ALTER TABLE [dbo].[OOH_Source_Ref] CHECK CONSTRAINT [FK_Source_Agency]
GO

ALTER TABLE [dbo].[OOH_Source_Ref]  WITH CHECK ADD  CONSTRAINT [FK_Source_Vendor] FOREIGN KEY([Source_Vendor_ID])
REFERENCES [dbo].[OOH_Vendor_Master] ([Vendor_ID])
GO

ALTER TABLE [dbo].[OOH_Source_Ref] CHECK CONSTRAINT [FK_Source_Vendor]
GO


--OOH_FA_UnpaidBuys
CREATE TABLE [dbo].[OOH_FA_UnpaidBuys](
	[Finance Associate] [varchar](255) NULL,
	[Unpaid_Ref_ID] [int] NOT NULL,
	[Unpaid_Ref_CLI_Acc_Off] [varchar](100) NULL,
	[Unpaid_Ref_Office] [varchar](100) NULL,
	[Unpaid_Ref_Client_Code] [varchar](10) NULL,
	[Unpaid_Ref_Client_Name] [varchar](200) NULL,
	[Unpaid_Ref_Product_Code] [varchar](10) NULL,
	[Unpaid_Ref_Product_Name] [varchar](100) NULL,
	[Unpaid_Ref_EST_Code] [varchar](10) NULL,
	[Unpaid_Ref_Paying_Rep] [varchar](100) NULL,
	[Unpaid_Ref_Publication_Code] [varchar](100) NULL,
	[Unpaid_Ref_Publication_Name] [varchar](200) NULL,
	[Unpaid_Ref_Insertion_Date] [varchar](100) NULL,
	[Unpaid_Ref_Insertion_MOS_Month] [varchar](100) NULL,
	[Unpaid_Ref_Contract_ID] [varchar](100) NULL,
	[Unpaid_Ref_Insertion_Order_Comment] [varchar](500) NULL,
	[Unpaid_Ref_Insertion_Order_Comment_4] [varchar](500) NULL,
	[Unpaid_Ref_Insertion_Order_Comment_2] [varchar](500) NULL,
	[Unpaid_Ref_Ordered_Net] [varchar](100) NULL,
	[Unpaid_Ref_Payable_Net] [varchar](100) NULL,
	[Unpaid_Ref_Paid_Net] [varchar](100) NULL,
	[Unpaid_Ref_Invoice_Number] [varchar](200) NULL,
	[Unpaid_Ref_Invoice_Dollar] [varchar](100) NULL,
	[Unpaid_Ref_Invoice_Comment] [varchar](200) NULL,
	[Unpaid_Ref_TS_Received] [varchar](100) NULL,
	[Unpaid_Ref_IDesk_Recon_Status] [varchar](100) NULL,
	[Unpaid_Ref_Special_Remittance_Comment] [varchar](200) NULL,
	[Unpaid_Ref_Cease_Date] [datetime] NULL,
	[Unpaid_Ref_Pay_Address] [varchar](500) NULL
) ON [PRIMARY]
GO

--OOH_FormRec_Txn
CREATE TABLE [dbo].[OOH_FormRec_Txn](
	[FR_ID] [int] IDENTITY(1,1) NOT NULL,
	[FR_Log_ID] [int] NULL,
	[FR_Result_ID] [varchar](200) NULL,
	[FR_TaxFormRec] [decimal](18, 0) NULL,
	[FR_Insertion_Date] [datetime] NULL,
	[FR_Description] [varchar](200) NULL,
	[FR_Client_Name] [varchar](200) NULL,
	[FR_Word_Where] [varchar](200) NULL,
	[FR_Agency_Name] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[FR_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_Invoice_Category_Ref
CREATE TABLE [dbo].[OOH_Invoice_Category_Ref](
	[Inv_Cat_ID] [int] IDENTITY(1,1) NOT NULL,
	[Inv_Cat_Name] [varchar](100) NULL,
	[Inv_Cat_Term] [varchar](100) NULL,
	[Inv_Cat_Label] [varchar](100) NULL,
	[Inv_Cat_USA_Flag] [bit] NULL,
	[Inv_Cat_CAN_Flag] [bit] NULL,
	[Inv_Cat_Insertion_Date] [datetime] NULL,
	[Inv_Cat_Cease_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Inv_Cat_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_Invoice_Master
CREATE TABLE [dbo].[OOH_Invoice_Master](
	[Invoice_ID] [int] IDENTITY(1,1) NOT NULL,
	[Invoice_Number] [varchar](100) NULL,
	[Invoice_Amount] [varchar](100) NULL,
	[Invoice_Date] [varchar](100) NULL,
	[Invoice_File_Name] [varchar](2000) NULL,
	[Invoice_Vendor_ID] [int] NULL,
	[Invoice_Agency_ID] [int] NULL,
	[Invoice_Insertion_Date] [datetime] NULL,
	[Invoice_Cease_Date] [datetime] NULL,
	[Invoice_Sender_Email] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Invoice_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OOH_Invoice_Master]  WITH CHECK ADD  CONSTRAINT [FK_Invoice_Agency] FOREIGN KEY([Invoice_Agency_ID])
REFERENCES [dbo].[OOH_Agency_Master] ([Agency_ID])
GO

ALTER TABLE [dbo].[OOH_Invoice_Master] CHECK CONSTRAINT [FK_Invoice_Agency]
GO

ALTER TABLE [dbo].[OOH_Invoice_Master]  WITH CHECK ADD  CONSTRAINT [FK_Invoice_Vendor] FOREIGN KEY([Invoice_Vendor_ID])
REFERENCES [dbo].[OOH_Vendor_Master] ([Vendor_ID])
GO

ALTER TABLE [dbo].[OOH_Invoice_Master] CHECK CONSTRAINT [FK_Invoice_Vendor]
GO

-- OOH_QA_Update_Reason_Master

CREATE TABLE [dbo].[OOH_QA_Update_Reason_Master](
	[MU_Reason_ID] [int] IDENTITY(1,1) NOT NULL,
	[MU_Reason_Code] [varchar](50) NULL,
	[MU_Reason_Descirption] [varchar](200) NULL,
	[MU_Reason_Category] [varchar](100) NULL,
	[MU_Reason_Insertion_Date] [datetime] NULL,
	[MU_Reason_Cease_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MU_Reason_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--OOH_NoExtraction_Txn

CREATE TABLE [dbo].[OOH_NoExtraction_Txn](
	[NoExt_ID] [int] IDENTITY(1,1) NOT NULL,
	[NoExt_Failure_Stage] [varchar](500) NULL,
	[NoExt_Advertiser_Name] [varchar](500) NULL,
	[NoExt_Amount_Due] [varchar](500) NULL,
	[NoExt_Contract_Number] [varchar](500) NULL,
	[NoExt_Description] [varchar](500) NULL,
	[NoExt_Email_Id] [varchar](500) NULL,
	[NoExt_Email_Metadata] [varchar](500) NULL,
	[NoExt_File_Name] [varchar](500) NULL,
	[NoExt_Invoice_Amount] [varchar](500) NULL,
	[NoExt_Invoice_Date] [varchar](500) NULL,
	[NoExt_Invoice_Number] [varchar](500) NULL,
	[NoExt_Number_of_Attachment] [varchar](500) NULL,
	[NoExt_Pop_Combined] [varchar](500) NULL,
	[NoExt_Record_Type] [varchar](500) NULL,
	[NoExt_Remittance_Address] [varchar](500) NULL,
	[NoExt_Send_Date] [varchar](500) NULL,
	[NoExt_Sender_Mail] [varchar](500) NULL,
	[NoExt_Sink_with_CSV] [varchar](500) NULL,
	[NoExt_Tax_Amount] [varchar](500) NULL,
	[NoExt_To_Address] [varchar](500) NULL,
	[NoExt_Total_Pages] [varchar](500) NULL,
	[NoExt_Vendor_Name] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[NoExt_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_Paid_Master

CREATE TABLE [dbo].[OOH_Paid_Master](
	[Paid_Master_ID] [int] IDENTITY(1,1) NOT NULL,
	[Paid_Master_CLI_Acc_Off] [varchar](100) NULL,
	[Paid_Master_Office] [varchar](100) NULL,
	[Paid_Master_Client_Code] [varchar](10) NULL,
	[Paid_Master_Client_Name] [varchar](200) NULL,
	[Paid_Master_Product_Code] [varchar](10) NULL,
	[Paid_Master_Product_Name] [varchar](100) NULL,
	[Paid_Master_EST_Code] [varchar](10) NULL,
	[Paid_Master_Paying_Rep] [varchar](100) NULL,
	[Paid_Master_Publication_Code] [varchar](100) NULL,
	[Paid_Master_Publication_Name] [varchar](100) NULL,
	[Paid_Master_Insertion_Date] [varchar](100) NULL,
	[Paid_Master_Insertion_MOS_Month] [varchar](100) NULL,
	[Paid_Master_Contract_ID] [varchar](100) NULL,
	[Paid_Master_Insertion_Order_Comment] [varchar](500) NULL,
	[Paid_Master_Insertion_Order_Comment_4] [varchar](500) NULL,
	[Paid_Master_Insertion_Order_Comment_2] [varchar](500) NULL,
	[Paid_Master_Ordered_Net] [varchar](500) NULL,
	[Paid_Master_Payable_Net] [varchar](500) NULL,
	[Paid_Master_Paid_Net] [varchar](500) NULL,
	[Paid_Master_Invoice_Number] [varchar](200) NULL,
	[Paid_Master_Invoice_Dollar] [varchar](500) NULL,
	[Paid_Master_Invoice_Comment] [varchar](200) NULL,
	[Paid_Master_TS_Received] [varchar](500) NULL,
	[Paid_Master_IDesk_Recon_Status] [varchar](100) NULL,
	[Paid_Master_Special_Remittance_Comment] [varchar](200) NULL,
	[Paid_Master_Cease_Date] [datetime] NULL,
	[Paid_Master_Pay_Address] [varchar](500) NULL,
	[Paid_Master_Upload_ID] [varchar](100) NULL,
	[Paid_Master_Insertion_Order_Comment_3] [varchar](500) NULL,
	[Paid_Master_Deal_ID] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Paid_Master_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_Paid_Stg

CREATE TABLE [dbo].[OOH_Paid_Stg](
	[Paid_ID] [int] IDENTITY(1,1) NOT NULL,
	[Paid_Media] [varchar](100) NULL,
	[Paid_CLI_Acc_Off] [varchar](100) NULL,
	[Paid_Office] [varchar](100) NULL,
	[Paid_Client_Code] [varchar](10) NULL,
	[Paid_Client_Name] [varchar](200) NULL,
	[Paid_Product_Code] [varchar](10) NULL,
	[Paid_Product_Name] [varchar](100) NULL,
	[Paid_EST_Code] [varchar](10) NULL,
	[Paid_Paying_Rep] [varchar](100) NULL,
	[Paid_Publication_Code] [varchar](100) NULL,
	[Paid_Publication_Name] [varchar](200) NULL,
	[Paid_Insertion_Date] [varchar](100) NULL,
	[Paid_Insertion_MOS_Month] [varchar](100) NULL,
	[Paid_Contract_ID] [varchar](100) NULL,
	[Paid_Insertion_Order_Comment] [varchar](500) NULL,
	[Paid_Insertion_Order_Comment_4] [varchar](500) NULL,
	[Paid_Insertion_Order_Comment_2] [varchar](500) NULL,
	[Paid_Ordered_Net] [varchar](100) NULL,
	[Paid_Payable_Net] [varchar](100) NULL,
	[Paid_Paid_Net] [varchar](100) NULL,
	[Paid_Invoice_Number] [varchar](200) NULL,
	[Paid_Invoice_Dollar] [varchar](100) NULL,
	[Paid_Invoice_Comment] [varchar](200) NULL,
	[Paid_TS_Received] [varchar](100) NULL,
	[Paid_IDesk_Recon_Status] [varchar](100) NULL,
	[Paid_Special_Remittance_Comment] [varchar](200) NULL,
	[Paid_Upload_ID] [varchar](100) NULL,
	[Paid_Pay_Address] [varchar](1000) NULL,
	[Paid_Insertion_Order_Comment_3] [nvarchar](500) NULL,
	[Paid_Deal_ID] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Paid_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_Unpaid_Ref
CREATE TABLE [dbo].[OOH_Unpaid_Ref](
	[Unpaid_Ref_ID] [int] IDENTITY(1,1) NOT NULL,
	[Unpaid_Ref_CLI_Acc_Off] [varchar](100) NULL,
	[Unpaid_Ref_Office] [varchar](100) NULL,
	[Unpaid_Ref_Client_Code] [varchar](10) NULL,
	[Unpaid_Ref_Client_Name] [varchar](200) NULL,
	[Unpaid_Ref_Product_Code] [varchar](10) NULL,
	[Unpaid_Ref_Product_Name] [varchar](100) NULL,
	[Unpaid_Ref_EST_Code] [varchar](10) NULL,
	[Unpaid_Ref_Paying_Rep] [varchar](100) NULL,
	[Unpaid_Ref_Publication_Code] [varchar](100) NULL,
	[Unpaid_Ref_Publication_Name] [varchar](100) NULL,
	[Unpaid_Ref_Insertion_Date] [varchar](100) NULL,
	[Unpaid_Ref_Insertion_MOS_Month] [varchar](100) NULL,
	[Unpaid_Ref_Contract_ID] [varchar](100) NULL,
	[Unpaid_Ref_Insertion_Order_Comment] [varchar](500) NULL,
	[Unpaid_Ref_Insertion_Order_Comment_4] [varchar](500) NULL,
	[Unpaid_Ref_Insertion_Order_Comment_2] [varchar](500) NULL,
	[Unpaid_Ref_Ordered_Net] [varchar](500) NULL,
	[Unpaid_Ref_Payable_Net] [varchar](500) NULL,
	[Unpaid_Ref_Paid_Net] [varchar](500) NULL,
	[Unpaid_Ref_Invoice_Number] [varchar](200) NULL,
	[Unpaid_Ref_Invoice_Dollar] [varchar](500) NULL,
	[Unpaid_Ref_Invoice_Comment] [varchar](200) NULL,
	[Unpaid_Ref_TS_Received] [varchar](500) NULL,
	[Unpaid_Ref_IDesk_Recon_Status] [varchar](100) NULL,
	[Unpaid_Ref_Special_Remittance_Comment] [varchar](200) NULL,
	[Unpaid_Ref_Cease_Date] [datetime] NULL,
	[Unpaid_Ref_Pay_Address] [varchar](500) NULL,
	[Unpaid_Ref_Upload_UniqueID] [varchar](200) NULL,
	[Unpaid_Ref_Insertion_Order_Comment_3] [varchar](500) NULL,
	[Unpaid_Ref_Deal_ID] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Unpaid_Ref_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--OOH_Unpaid_Stg
CREATE TABLE [dbo].[OOH_Unpaid_Stg](
	[Unpaid_ID] [int] IDENTITY(1,1) NOT NULL,
	[Unpaid_Media_Code] [varchar](100) NULL,
	[Unpaid_CLI_Acc_Off] [varchar](100) NULL,
	[Unpaid_Office] [varchar](100) NULL,
	[Unpaid_Client_Code] [varchar](10) NULL,
	[Unpaid_Client_Name] [varchar](200) NULL,
	[Unpaid_Product_Code] [varchar](10) NULL,
	[Unpaid_Product_Name] [varchar](100) NULL,
	[Unpaid_EST_Code] [varchar](10) NULL,
	[Unpaid_Paying_Rep] [varchar](100) NULL,
	[Unpiad_Publication_Code] [varchar](100) NULL,
	[Unpaid_Publication_Name] [varchar](200) NULL,
	[Unpaid_Insertion_Date] [varchar](100) NULL,
	[Unpaid_Insertion_MOS_Month] [varchar](100) NULL,
	[Unpaid_Contract_ID] [varchar](100) NULL,
	[Unpaid_Insertion_Order_Comment] [varchar](500) NULL,
	[Unpaid_Insertion_Order_Comment_4] [varchar](500) NULL,
	[Unpaid_Insertion_Order_Comment_2] [varchar](500) NULL,
	[Unpaid_Ordered_Net] [varchar](100) NULL,
	[Unpaid_Payable_Net] [varchar](100) NULL,
	[Unpaid_Paid_Net] [varchar](100) NULL,
	[Unpaid_Invoice_Number] [varchar](200) NULL,
	[Unpaid_Invoice_Dollar] [varchar](100) NULL,
	[Unpaid_Invoice_Comment] [varchar](200) NULL,
	[Unpaid_TS_Received] [varchar](100) NULL,
	[Unpaid_IDesk_Recon_Status] [varchar](100) NULL,
	[Unpaid_Special_Remittance_Comment] [varchar](200) NULL,
	[Unpaid_Upload_UniqueID] [varchar](200) NULL,
	[Unpaid_Pay_Address] [varchar](1000) NULL,
	[Unpaid_Insertion_Order_Comment_3] [nvarchar](500) NULL,
	[Unpaid_Deal_ID] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Unpaid_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- OOH_Log_TXn table

CREATE TABLE [dbo].[OOH_Log_Txn](
	[Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[Log_Vendor_ID] [int] NOT NULL,
	[Log_Agency_ID] [int] NOT NULL,
	[Log_FA_ID] [int] NOT NULL,
	[Log_Inv_Cat_ID] [int] NULL,
	[Log_Record_Type] [varchar](20) NULL,
	[Log_Paid_Unpaid] [varchar](20) NULL,
	[Log_Invoice_Date] [varchar](200) NULL,
	[Log_Insertion_Date] [datetime] NULL,
	[Log_Invoice_FileName] [varchar](200) NULL,
	[Log_Invoice_Number] [varchar](200) NULL,
	[Log_Invoice_RemittanceAddress] [varchar](200) NULL,
	[Log_Remittance_Pass] [bit] NULL,
	[Log_Invoice_Amount] [varchar](200) NULL,
	[Log_Invoice_ExtractedTax] [decimal](18, 0) NULL,
	[Log_Invoice_ExtractedTotal] [decimal](18, 0) NULL,
	[Log_Invoice_ExtractedSubTotal] [decimal](18, 0) NULL,
	[Log_Invoice_ContractNumber] [varchar](200) NULL,
	[Log_Invoice_Advertiser_Name] [varchar](200) NULL,
	[Log_Invoice_Media_ID] [int] NULL,
	[Log_Invoice_MOS] [varchar](200) NULL,
	[Log_Buy_Amount] [decimal](18, 0) NULL,
	[Log_Tax_Amount] [decimal](18, 0) NULL,
	[Log_Buy_Tax] [decimal](18, 0) NULL,
	[Log_Invoice_CPE] [varchar](200) NULL,
	[Log_Validated_C] [varchar](10) NULL,
	[Log_Validated_P] [varchar](10) NULL,
	[Log_Validated_E] [varchar](10) NULL,
	[Log_Insertion_Month] [varchar](200) NULL,
	[Log_Campaign_ID_Match] [varchar](200) NULL,
	[Log_Insertion_Order_Ext_Match] [varchar](200) NULL,
	[Log_Invoice_Sender_Name] [varchar](200) NULL,
	[Log_Invoice_Sender_Email] [varchar](200) NULL,
	[Log_Invoice_Sender_GUID] [varchar](200) NULL,
	[Log_Invoice_Sender_EmailDate] [varchar](200) NULL,
	[Log_Invoice_PageCount] [int] NULL,
	[Log_Invoice_ConfidenceScore] [int] NULL,
	[Log_Client_Name] [varchar](200) NULL,
	[Log_Publication_Code] [varchar](100) NULL,
	[Log_Publication_Name] [varchar](200) NULL,
	[Log_Product_Name] [varchar](200) NULL,
	[Log_UUID] [varchar](200) NULL,
	[Log_SP_FilePath] [varchar](2000) NULL,
	[Log_VM_FilePath] [varchar](500) NULL,
	[Log_IsMatched] [bit] NULL,
	[Log_Matched_To] [varchar](100) NULL,
	[Log_Matched_To_ID] [int] NULL,
	[Log_Embargo_Flag] [bit] NULL,
	[Log_Embargo_Reason] [varchar](200) NULL,
	[Log_IsZipped] [bit] NULL,
	[Log_CompilationStatus] [bit] NULL,
	[Log_InFolder] [varchar](20) NULL,
	[Log_Manual_Override] [bit] NULL,
	[Log_Manual_Override_Date] [datetime] NULL,
	[Log_FA_Interface_Ready] [bit] NULL,
	[Log_FA_Action_Status] [varchar](100) NULL,
	[Log_FA_Update_Date] [datetime] NULL,
	[Log_FA_Interface_Log_Status] [varchar](200) NULL,
	[Log_FA_P_Desc_NR] [varchar](200) NULL,
	[Log_FA_Interface_Comment] [varchar](500) NULL,
	[Log_FA_UpdateBy_ID] [int] NULL,
	[Log_Manual_Override_Reason_ID] [int] NULL,
	[Log_Recipe_Job_ID] [nchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[Log_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OOH_Log_Txn] ADD  DEFAULT (NULL) FOR [Log_Matched_To_ID]
GO

ALTER TABLE [dbo].[OOH_Log_Txn]  WITH CHECK ADD  CONSTRAINT [FK_Log_Agency] FOREIGN KEY([Log_Agency_ID])
REFERENCES [dbo].[OOH_Agency_Master] ([Agency_ID])
GO

ALTER TABLE [dbo].[OOH_Log_Txn] CHECK CONSTRAINT [FK_Log_Agency]
GO

ALTER TABLE [dbo].[OOH_Log_Txn]  WITH CHECK ADD  CONSTRAINT [FK_Log_FA] FOREIGN KEY([Log_FA_ID])
REFERENCES [dbo].[OOH_FA_Mapping_Ref] ([FA_Map_ID])
GO

ALTER TABLE [dbo].[OOH_Log_Txn] CHECK CONSTRAINT [FK_Log_FA]
GO

ALTER TABLE [dbo].[OOH_Log_Txn]  WITH CHECK ADD  CONSTRAINT [FK_Log_Inv_CAT] FOREIGN KEY([Log_Inv_Cat_ID])
REFERENCES [dbo].[OOH_Invoice_Category_Ref] ([Inv_Cat_ID])
GO

ALTER TABLE [dbo].[OOH_Log_Txn] CHECK CONSTRAINT [FK_Log_Inv_CAT]
GO

ALTER TABLE [dbo].[OOH_Log_Txn]  WITH CHECK ADD  CONSTRAINT [FK_Log_Inv_Media] FOREIGN KEY([Log_Invoice_Media_ID])
REFERENCES [dbo].[OOH_Media_Ref] ([Media_ID])
GO

ALTER TABLE [dbo].[OOH_Log_Txn] CHECK CONSTRAINT [FK_Log_Inv_Media]
GO

ALTER TABLE [dbo].[OOH_Log_Txn]  WITH CHECK ADD  CONSTRAINT [FK_Log_ManualUpdate] FOREIGN KEY([Log_Manual_Override_Reason_ID])
REFERENCES [dbo].[OOH_QA_Update_Reason_Master] ([MU_Reason_ID])
GO

ALTER TABLE [dbo].[OOH_Log_Txn] CHECK CONSTRAINT [FK_Log_ManualUpdate]
GO

ALTER TABLE [dbo].[OOH_Log_Txn]  WITH CHECK ADD  CONSTRAINT [FK_Log_Vendor] FOREIGN KEY([Log_Vendor_ID])
REFERENCES [dbo].[OOH_Vendor_Master] ([Vendor_ID])
GO

ALTER TABLE [dbo].[OOH_Log_Txn] CHECK CONSTRAINT [FK_Log_Vendor]
GO




-- OOH_PBT_Txn
CREATE TABLE [dbo].[OOH_PBT_Txn](
	[PBT_ID] [int] IDENTITY(1,1) NOT NULL,
	[PBT_Log_ID] [int] NULL,
	[PBT_Is_MultiInvoice] [bit] NULL,
	[PBT_MultiInv_Leading_InvoiceNumber] [varchar](200) NULL,
	[PBT_MultiInv_Invoice_Amount_Sum] [decimal](18, 2) NULL,
	[PBT_MultiInv_Tax_Amount_Sum] [decimal](18, 2) NULL,
	[PBT_MultiInv_Batch_Details] [varchar](max) NULL,
	[PBT_MultiInv_Leading_Invoice_Flag] [bit] NULL,
	[PBT_Is_Recon] [bit] NULL,
	[PBT_TS_Received] [varchar](500) NULL,
	[PBT_Recon_Status] [varchar](100) NULL,
	[PBT_Recon_Comment] [varchar](max) NULL,
	[PBT_Is_Segement] [bit] NULL,
	[PBT_Segment_Insertion_Date] [varchar](100) NULL,
	[PBT_Segment_Comment] [varchar](max) NULL,
	[PBT_Segment_BuyAmount] [decimal](18, 2) NULL,
	[PBT_Segment_InvoiceAmount] [decimal](18, 2) NULL,
	[PBT_Segment_UnpaidRef_IDesk_Recon] [varchar](500) NULL,
	[PBT_Segment_UnpaidRef_ContractID] [varchar](200) NULL,
	[PBT_Tagged] [bit] NULL,
	[PBT_Tag_Status] [varchar](200) NULL,
	[PBT_Tag_Date] [datetime] NULL,
	[PBT_Tag_Comment] [varchar](max) NULL,
	[PBT_Screenshot_Link] [varchar](200) NULL,
	[PBT_Stamp_Comment] [varchar](200) NULL,
	[PBT_Insertion_Date] [datetime] NULL,
	[PBT_Update_Date] [datetime] NULL,
	[PBT_FA_UpdatedBy_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PBT_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[OOH_PBT_Txn]  WITH CHECK ADD  CONSTRAINT [FK_PBT_Log_ID] FOREIGN KEY([PBT_Log_ID])
REFERENCES [dbo].[OOH_Log_Txn] ([Log_ID])
GO

ALTER TABLE [dbo].[OOH_PBT_Txn] CHECK CONSTRAINT [FK_PBT_Log_ID]
GO

ALTER TABLE [dbo].[OOH_PBT_Txn]  WITH CHECK ADD  CONSTRAINT [FK_PBT_UpdateRecord_ByFA] FOREIGN KEY([PBT_FA_UpdatedBy_ID])
REFERENCES [dbo].[OOH_FA_Master] ([FA_ID])
GO

ALTER TABLE [dbo].[OOH_PBT_Txn] CHECK CONSTRAINT [FK_PBT_UpdateRecord_ByFA]
GO

--OOH_Predictions_Mview

CREATE TABLE [dbo].[OOH_Predictions_Mview](
	[Prediction_ID] [int] IDENTITY(1,1) NOT NULL,
	[Prediction_Log_ID] [int] NULL,
	[Prediction_Rank] [int] NULL,
	[Prediction_M] [varchar](10) NULL,
	[Prediction_C] [varchar](10) NULL,
	[Prediction_P] [varchar](10) NULL,
	[Prediction_E] [varchar](10) NULL,
	[Prediction_MOS] [varchar](200) NULL,
	[Prediction_Unpaid_Insertion_Date] [varchar](100) NULL,
	[Prediction_Unpaid_Contract_Id] [varchar](100) NULL,
	[Prediction_Unpaid_IDesk_Recon] [varchar](100) NULL,
	[Prediction_Unpaid_Net_Payable] [varchar](500) NULL,
	[Prediction_Unpaid_Net_Paid] [varchar](500) NULL,
	[Prediction_Unpaid_Pay_Address] [varchar](500) NULL,
	[Prediction_Publication_Code] [varchar](100) NULL,
	[Prediction_Publication] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Prediction_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OOH_Predictions_Mview]  WITH CHECK ADD  CONSTRAINT [FK_Predictions_Log_ID] FOREIGN KEY([Prediction_Log_ID])
REFERENCES [dbo].[OOH_Log_Txn] ([Log_ID])
GO

ALTER TABLE [dbo].[OOH_Predictions_Mview] CHECK CONSTRAINT [FK_Predictions_Log_ID]
GO


-- OOH_S9_Txn
CREATE TABLE [dbo].[OOH_S9_Txn](
	[S9_ID] [int] IDENTITY(1,1) NOT NULL,
	[S9_Log_ID] [int] NULL,
	[Log_S9_HasRun] [bit] NULL,
	[Log_S9_Stamp_Comment] [varchar](200) NULL,
	[Log_S9_Status] [varchar](100) NULL,
	[Log_S9_Run_Date] [datetime] NULL,
	[Log_S9_ReProcessed] [varchar](100) NULL,
	[Log_S9_RetryCounter] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[S9_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
 
-- OOH_Prediction_Record_Stg

CREATE TABLE [dbo].[OOH_Prediction_Record_Stg](
	[PRecord_ID] [int] IDENTITY(1,1) NOT NULL,
	[PRecord_Row_Number] [int] NULL,
	[PRecord_Log_ID] [int] NULL,
	[PRecord_Log_C] [varchar](10) NULL,
	[PRecord_Log_P] [varchar](10) NULL,
	[PRecord_Log_E] [varchar](10) NULL,
	[PRecord_Log_Contract_Number] [varchar](100) NULL,
	[PRecord_Log_Publication_Code] [varchar](100) NULL,
	[PRecord_Log_MOS] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[PRecord_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OOH_Prediction_Record_Stg]  WITH CHECK ADD  CONSTRAINT [FK_PR_Log_ID] FOREIGN KEY([PRecord_Log_ID])
REFERENCES [dbo].[OOH_Log_Txn] ([Log_ID])
GO

ALTER TABLE [dbo].[OOH_Prediction_Record_Stg] CHECK CONSTRAINT [FK_PR_Log_ID]
GO


--OOH_FormRec_ModelTraining_Master

CREATE TABLE [dbo].[OOH_FormRec_ModelTraining_Master](
	[FR_Model_Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[FR_Model_ID] [varchar](100) NULL,
	[FR_Model_Description] [varchar](100) NULL,
	[FR_Model_InvNum_Accuracy] [decimal](10, 2) NULL,
	[FR_Model_InvAmt_Accuracy] [decimal](10, 2) NULL,
	[FR_Model_InvDate_Accuracy] [decimal](10, 2) NULL,
	[FR_Model_InvContID_Accuracy] [decimal](10, 2) NULL,
	[FR_Model_Insertion_Date] [datetime] NULL,
	[FR_Model_Is_Active] [bit] NULL,
	[FR_Model_Cease_Date] [datetime] NULL,
	[FR_Model_UpdatedBy] [varchar](100) NULL,
	[FR_Comment] [nchar](250) NULL
) ON [PRIMARY]
GO




