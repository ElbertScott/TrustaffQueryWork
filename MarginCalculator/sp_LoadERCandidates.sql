USE [erecruit_TRUSTAFF]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadCandidates]    Script Date: 1/3/2021 11:06:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_LoadERCandidates]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	delete from src.CANDIDATE
	where ISNUMERIC(CandidateERecruitID) <> 1

	MERGE [MarginCalculator].[dbo].[Candidates] t
		Using [erecruit_TRUSTAFF].[src].[CANDIDATE] s
	ON t.CandidateERecruitID = s.CandidateERecruitID and ISNUMERIC(s.CandidateERecruitID) = 1
	WHEN MATCHED THEN 
		UPDATE SET
			t.[CandidateFirstName] = s.[CandidateFirstName]
			,t.[CandidateLastName] = s.[CandidateLastName]
			,t.[CandidateAddress] = s.[CandidateAddress]
			,t.[CandidateCity] = s.[CandidateCity]
			,t.[CandidateState] = s.[CandidateState]
			,t.[CandidateZip] = s.[CandidateZip]
			,t.[CandidateEmail] = s.[CandidateEmail]
			,t.[CandidatePhone] = s.[CandidatePhone]
			,t.[CandidateNotes] = s.[Notes]
			,t.[CandidateIsActive] = 1
			,t.[IsCandidateDNU] = s.[IsCandidateDNU]
			,t.[CandidateUpdateDate] = GETDATE()
			,t.[CandidateUpdateBy] = SYSTEM_USER
			,t.[CandidateStatus] = s.[CandidateStatus]
	WHEN NOT MATCHED THEN 
		INSERT([CandidateERecruitID]
				,[CandidateFirstName]
				,[CandidateLastName]
				,[CandidateAddress]
				,[CandidateCity]
				,[CandidateState]
				,[CandidateZip]
				,[CandidateEmail]
				,[CandidatePhone]
				,[CandidateNotes]
				,[CandidateIsActive]
				,[IsCandidateDNU]
				,[CandidateCreateDate]
				,[CandidateCreateBy]
				,[CandidateUpdateDate]
				,[CandidateUpdateBy]
				,[CandidateStatus])
		VALUES(s.[CandidateERecruitID]
				,s.[CandidateFirstName]
				,s.[CandidateLastName]
				,s.[CandidateAddress]
				,s.[CandidateCity]
				,s.[CandidateState]
				,s.[CandidateZip]
				,s.[CandidateEmail]
				,s.[CandidatePhone]
				,s.[Notes]
				,1
				,s.[IsCandidateDNU]
				,GETDATE()
				,SYSTEM_USER
				,GETDATE()
				,SYSTEM_USER
				,s.[CandidateStatus])
	OUTPUT $action, inserted.*; 
	
END
GO

