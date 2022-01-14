USE [MarginCalculator]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadGMFacilities]    Script Date: 10/18/2021 3:02:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_LoadGMFacilities]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	MERGE [MarginCalculator].[dbo].[Facility] t
		Using (	SELECT	DISTINCT 
						c.id AS GoldMineID
						,lk.facility_Code as ERecruitID
						,c.COMPANY AS FacilityName
						,c.ADDRESS1 AS FacilityAddress1
						,c.ADDRESS2 AS FacilityAddress2
						,c.ADDRESS3 AS FacilityAddress3
						,c.CITY AS FacilityCity
						,c.[STATE] AS FacilityState
						,c.ZIP AS FacilityZip
						,c.CONTACT
				FROM [192.168.0.9].Trustaff_Med.dbo.CONTACT1 c
				LEFT JOIN [192.168.0.9].Trustaff_Med.dbo.tbl_GM_Facilitylink lk
					on c.id = lk.GMID
				where ((c.CREATEON >= getdate() - 2) or (c.LASTDATE >= getdate() - 2))
				and c.KEY1 = 'Facility'
				) s
	ON t.GoldMineID = s.GoldMineID
	WHEN MATCHED THEN 
		UPDATE SET
			t.[GoldMineID] = s.[GoldMineID]
			,t.[ERecruitID] = s.[ERecruitID]
			,t.[FacilityName] = s.[FacilityName]
			,t.[FacilityAddress1] = s.[FacilityAddress1]
			,t.[FacilityAddress2] = s.[FacilityAddress2]
			,t.[FacilityAddress3] = s.[FacilityAddress3]
			,t.[FacilityCity] = s.[FacilityCity]
			,t.[FacilityState] = SUBSTRING(s.[FacilityState],1,2)
			,t.[FacilityZip] = SUBSTRING(s.[FacilityZip],1,5)
			,t.[FacilityContact] = s.[CONTACT]
			,t.[FacilityUpdateDate] = GETDATE()
			,t.[FacilityUpdateBy] = SYSTEM_USER
	WHEN NOT MATCHED THEN 
		INSERT ([GoldMineID]
				,[ERecruitID]
				,[FacilityName]
				,[FacilityAddress1]
				,[FacilityAddress2]
				,[FacilityAddress3]
				,[FacilityCity]
				,[FacilityState]
				,[FacilityZip]
				,[FacilityContact]
				,[FacilityCreateDate]
				,[FacilityCreateBy]
				,[FacilityUpdateDate]
				,[FacilityUpdateBy])
		VALUES
		(
			s.[GoldMineID]
			,s.[ERecruitID]
			,s.[FacilityName]
			,s.[FacilityAddress1]
			,s.[FacilityAddress2]
			,s.[FacilityAddress3]
			,s.[FacilityCity]
			,SUBSTRING(s.[FacilityState],1,2)
			,SUBSTRING(s.[FacilityZip],1,5)
			,s.[CONTACT]
			,GETDATE()
			,SYSTEM_USER
			,GETDATE()
			,SYSTEM_USER	
		)
	OUTPUT $action, inserted.*; 


END
GO


