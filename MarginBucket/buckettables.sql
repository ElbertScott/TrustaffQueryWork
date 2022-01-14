

CREATE TABLE [dbo].[ColorDefinition](
	[ColorDefinitionID] [int] NOT NULL,
	[SubmissionStatusID] [int] NULL,
	[ColorValue] [varchar](20) NULL,
	[IsSystemColor] [bit] NULL,
	[isDefault] [bit] NULL,
	[ColorDefinitionInsertDate] [datetime] NULL,
	[ColorDefinitionInsertBy] [varchar](30) NULL,
	[ColorDefinitionUpdateDate] [datetime] NULL,
	[ColorDefinitionUpdateBy] [varchar](30) NULL,
	[ColorType] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ColorDefinitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[BucketAdministration](
	[BucketAdministrationID] [int] NOT NULL,
	[HRUserID] [int] NULL,
	[ColorDefinitionID] [int] NULL,
	[SubmissionStatusID] [int] NULL,
	[BucketAdministrationInsertDate] [datetime] NULL,
	[BucketAdministationInsertBy] [varchar](30) NULL,
	[BucketAdministrationUpdateDate] [datetime] NULL,
	[BucketAdministationUpdateBy] [varchar](30) NULL,
	[FontColorDefinitionID] [int] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[BucketAdministrationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BucketAdministration] ADD  DEFAULT ((1)) FOR [isActive]
GO


CREATE TABLE [dbo].[BucketAudit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[FacPacketId] [int] NULL,
	[SubmitStatus] [varchar](100) NULL,
	[CreateBy] [varchar](40) NULL,
	[CreateDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UserPreferences](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[UserEsigID] [int] NULL,
	[PaginationLimit] [int] NULL,
	[FontSize] [int] NULL,
	[SortColumn] [varchar](30) NULL,
	[OrderBy] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

