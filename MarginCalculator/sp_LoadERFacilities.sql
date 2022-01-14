USE [erecruit_TRUSTAFF]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadERFacilities]    Script Date: 12/30/2020 7:32:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_LoadERFacilities]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

	MERGE [MarginCalculator].[dbo].[Facility] t
		Using [erecruit_TRUSTAFF].[src].[COMPANY] s
	ON t.ERecruitID = s.ERecruitID
	WHEN MATCHED THEN 
		UPDATE SET
			t.[ERecruitID] = s.[eRecruitID]
			,t.[FacilityName] = s.[FacilityName]
			,t.[FacilityAddress1] = s.[FacilityAddress1]
			,t.[FacilityCity] = s.[FacilityCity]
			,t.[FacilityState] = s.[FacilityState]
			,t.[FacilityZip] = s.[FacilityZip]
			,t.[FacilityContact] = s.[FullName]
			,t.[FacilityUpdateDate] = GETDATE()
			,t.[FacilityUpdateBy] = SYSTEM_USER
	WHEN NOT MATCHED THEN 
		INSERT ([ERecruitID]
				,[FacilityName]
				,[FacilityAddress1]
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
			s.[eRecruitID]
			,s.[FacilityName]
			,s.[FacilityAddress1]
			,s.[FacilityCity]
			,s.[FacilityState]
			,s.[FacilityZip]
			,s.[FullName]
			,GETDATE()
			,SYSTEM_USER
			,GETDATE()
			,SYSTEM_USER	
		)
	OUTPUT $action, inserted.*; 

END
GO


