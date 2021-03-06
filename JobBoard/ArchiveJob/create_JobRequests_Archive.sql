USE [Trustaff_Med]
GO


CREATE TABLE [dbo].[JobRequests_Archive]
(
	[pk_JobRequestID] [int] NOT NULL,
	[fk_ClientID] [int] NOT NULL,
	[fk_ProfessionID] [smallint] NOT NULL,
	[fk_SpecialtyID] [int] NOT NULL,
	[fk_DivisionID] [smallint] NOT NULL,
	[fk_StatusID] [smallint] NOT NULL,
	[dateUpdated] [smalldatetime] NULL,
	[dateCreated] [smalldatetime] NULL,
	[Description] [nvarchar](max) NULL,
	[Guarantee] [int] NULL,
	[Shift] [int] NULL,
	[NumOpenings] [int] NULL,
	[Duration] [int] NULL,
	[Weekends] [bit] NULL,
	[dateNeeded] [smalldatetime] NULL,
	[Setting] [nvarchar](150) NULL,
	[InternalDescription] [nvarchar](max) NULL,
	[Reloc] [bit] NULL,
	[Scripts] [int] NULL,
	[Hours] [char](50) NULL,
	[NumOther] [char](50) NULL,
	[NumPhar] [char](50) NULL,
	[NumTech] [char](50) NULL,
	[OnCall] [char](50) NULL,
	[Interviewer] [char](50) NULL,
	[InterviewProcess] [char](50) NULL,
	[InterviewTimes] [char](50) NULL,
	[AllInclusivePayRate] [money] NULL,
	[EstimatedExpenses] [money] NULL,
	[OvertimePayRate] [money] NULL,
	[TaxAdvPayRateTax] [money] NULL,
	[TaxAdvPayRateNoTax] [money] NULL,
	[StandardPayRate] [money] NULL,
	[Salary] [money] NULL,
	[SignOn] [money] NULL,
	[Pension] [bit] NULL,
	[YearsExp] [int] NULL,
	[YearsTravelExp] [int] NULL,
	[certBLS] [bit] NULL,
	[certACLS] [bit] NULL,
	[certPALS] [bit] NULL,
	[certNALS] [bit] NULL,
	[certCCRN] [bit] NULL,
	[certCEN] [bit] NULL,
	[certChemo] [bit] NULL,
	[certCNOR] [bit] NULL,
	[certOCN] [bit] NULL,
	[courseCriticalCare] [bit] NULL,
	[courseTrauma] [bit] NULL,
	[disableExports] [bit] NOT NULL,
	[MktgPosting] [bit] NOT NULL,
	[RegistryID] [int] NULL,
	[RegistryPrivateID] [nvarchar](255) NULL,
	[MCState] [varchar](20) NULL,
	[MCCity] [varchar](30) NULL,
	[MCFacilityID] [varbinary](10) NULL,
	[CreatedBy] [char](50) NULL,
	[AcctManager] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[SolutionsPosting] [bit] NOT NULL,
	[ApplyURL] [nvarchar](255) NULL,
	[fk_SettingID] [int] NULL,
	[InternalUserGroup] [smallint] NOT NULL,
	[PayRange] [varchar](255) NULL,
	[DoNotRerate] [bit] NOT NULL,
	[NewRateAvail] [bit] NOT NULL,
	[AccuratePay] [bit] NULL,
	[Bill] [money] NULL,
	[BlindJob] [int] NULL
) 



