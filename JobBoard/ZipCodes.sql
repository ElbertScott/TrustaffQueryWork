CREATE TABLE [dbo].[ZipCodes]
(
	[Zip_ID] [int] IDENTITY(1,1) NOT NULL,
	[Zip_Code] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Latitude] [numeric](38, 15) NULL,
	[Longitude] [numeric](38, 15) NULL,
 CONSTRAINT [PK_Zip_Codes] PRIMARY KEY CLUSTERED 
(
	[Zip_ID] ASC
)
)