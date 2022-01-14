USE [MarginCalculator]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadGMCandidates]    Script Date: 10/18/2021 2:56:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE   PROCEDURE [dbo].[sp_LoadGMCandidates]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	MERGE [MarginCalculator].[dbo].[Candidates] t
	USING 
	(
		--Candidates - GoldMine without an application
		select	c.id as GoldMineID
				,cl.ErecruitId
				,SUBSTRING(c.CONTACT, 1 ,
					case when  CHARINDEX(' ', c.CONTACT) = 0 then LEN(c.CONTACT) 
					else CHARINDEX(' ', c.CONTACT) -1 end) as FirstName
				,c.LASTNAME
				,c.ADDRESS1
				,c.CITY
				,c.STATE
				,c.ZIP
				,(select TOP 1 CONTSUPREF from [192.168.0.9].Trustaff_Med.dbo.contsupp where CONTACT = 'E-mail Address' and c.AccountNO = ACCOUNTNO order by recid desc) as Email
				,c.PHONE1
		from [192.168.0.9].Trustaff_Med.dbo.contact1 c
		left join [192.168.0.9].Trustaff_Med.dbo.CandidateLink cl on c.id = cl.candidateID
		where ((c.CREATEON >= getdate() - 2) or (c.LASTDATE >= getdate() - 2))
		and c.KEY1 <> 'Facility'
	) as s
	on t.CandidateGoldMineID = s.GoldMineID --and t.CandidateERecruitID IS NULL
	WHEN MATCHED THEN 
		UPDATE SET
			t.[CandidateFirstName] = s.[FirstName]
			,t.[CandidateLastName] = s.[LASTNAME]
			,t.[CandidateAddress] = s.[ADDRESS1]
			,t.[CandidateCity] = s.[CITY]
			,t.[CandidateState] = SUBSTRING(s.[STATE],1,2) 
			,t.[CandidateZip] = SUBSTRING(s.[ZIP],1,5)
			,t.[CandidateEmail] = s.[Email]
			,t.[CandidatePhone] = s.[PHONE1]
			,t.[CandidateNotes] = NULL
			,t.[CandidateIsActive] = 1
			,t.[IsCandidateDNU] = 0
			,t.[CandidateFullName] = CONCAT(s.[FirstName], ' ',s.[LASTNAME])
			,t.[CandidateUpdateDate] = GETDATE()
			,t.[CandidateUpdateBy] = SYSTEM_USER
			,t.[CandidateStatus] = 'GM'
			,t.CandidateERecruitID = s.[ErecruitId]
	WHEN NOT MATCHED THEN 
		INSERT([CandidateGoldMineID]
				,[CandidateERecruitID]
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
				,[CandidateFullName]
				,[CandidateCreateDate]
				,[CandidateCreateBy]
				,[CandidateUpdateDate]
				,[CandidateUpdateBy]
				,[CandidateStatus])
		VALUES(s.[GoldMineID]
				,s.[ErecruitId]
				,s.[FirstName]
				,s.[LASTNAME]
				,s.[ADDRESS1]
				,s.[CITY]
				,SUBSTRING(s.[STATE],1,2) 
				,SUBSTRING(s.[ZIP],1,5)
				,s.[Email]
				,s.[PHONE1]
				,NULL
				,1
				,0
				,CONCAT(s.[FirstName], ' ',s.[LASTNAME])
				,GETDATE()
				,SYSTEM_USER
				,GETDATE()
				,SYSTEM_USER
				,'GM')
	OUTPUT $action, inserted.*; 
		


END
GO


