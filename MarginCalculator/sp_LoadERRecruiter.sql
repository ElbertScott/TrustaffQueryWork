USE [erecruit_TRUSTAFF]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadRecruiter]    Script Date: 1/3/2021 11:07:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_LoadERRecruiter]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	MERGE [MarginCalculator].[dbo].[Recruiter] t
		Using [erecruit_TRUSTAFF].[src].[HR_REPRESENTATIVE] s
	ON t.RecruiterEmail = s.EMAIL
	WHEN MATCHED THEN 
		UPDATE SET
			t.RecruiterFirstName = s.First_Name
			,t.RecruiterLastName = s.Last_Name
			,t.RecruiterERecruitID = s.ErecruitID
			,t.RecruiterUpdateDate = GETDATE()
			,t.RecruiterUpdateBy = SYSTEM_USER
	WHEN NOT MATCHED THEN 
		INSERT ([RecruiterERecruitID]
				,[RecruiterFirstName]
				,[RecruiterLastName]
				,[RecruiterEmail]
				,[RecruiterIsActive]
				,[RecruiterCreateDate]
				,[RecruiterCreateBy]
				,[RecruiterUpdateDate]
				,[RecruiterUpdateBy])
		VALUES (s.[ErecruitID]
				,s.[FIRST_NAME]
				,s.[LAST_NAME]
				,s.[EMAIL]
				,1
				,GETDATE()
				,SYSTEM_USER
				,GETDATE()
				,SYSTEM_USER)
		OUTPUT $action, inserted.*;

END
GO

