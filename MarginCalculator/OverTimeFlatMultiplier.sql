USE [MarginCalculator]
GO
/****** Object:  Table [dbo].[OverTimeFlatMultiplier]    Script Date: 12/17/2020 9:44:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OverTimeFlatMultiplier](
	[OverTimeFlatMultiplierID] [int] IDENTITY(1,1) NOT NULL,
	[MultiplierValue] [decimal](3, 2) NULL,
	[OverTimeFlatMultiplerCreateDate] [datetime] NULL,
	[OverTimeFlatMultiplierCreateBy] [varchar](100) NULL,
	[OverTimeFlatMultiplerUpdateDate] [datetime] NULL,
	[OverTimeFlatMultiplierUpdateBy] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[OverTimeFlatMultiplierID] ASC
)
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[OverTimeFlatMultiplier] ON 
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (1, CAST(1.50 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (2, CAST(1.75 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (3, CAST(2.00 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (4, CAST(2.25 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (5, CAST(2.50 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (6, CAST(2.75 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (7, CAST(3.00 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (8, CAST(3.25 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (9, CAST(3.50 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (10, CAST(3.75 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (11, CAST(4.00 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (12, CAST(4.25 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
INSERT [dbo].[OverTimeFlatMultiplier] ([OverTimeFlatMultiplierID], [MultiplierValue], [OverTimeFlatMultiplerCreateDate], [OverTimeFlatMultiplierCreateBy], [OverTimeFlatMultiplerUpdateDate], [OverTimeFlatMultiplierUpdateBy]) VALUES (13, CAST(4.50 AS Decimal(3, 2)), CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load', CAST(N'2020-10-08T22:54:18.953' AS DateTime), N'Initial Load')
GO
SET IDENTITY_INSERT [dbo].[OverTimeFlatMultiplier] OFF
GO
