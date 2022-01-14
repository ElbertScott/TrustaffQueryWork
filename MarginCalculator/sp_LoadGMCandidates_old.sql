USE [MarginCalculator]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadGMCandidates]    Script Date: 9/8/2021 7:43:08 PM ******/
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
		--Candidates - GoldMine
		SELECT	cl.candidateID as GoldMineID
				,cl.ErecruitId
				,abi.FName
				,ISNULL(c.LASTNAME, abi.LName) as LName
				,ISNULL(c.ADDRESS1, abi.FullAddress) as FullAddress 
				,ISNULL(c.CITY, abi.City) as City
				,ISNULL(c.STATE, abi.[State]) as State
				,ISNULL(c.ZIP, abi.Zip) as Zip 
				,abi.Email as Email --'trustaffedw@ctipartners.co'
				,ISNULL(c.PHONE1 ,abi.MPhone) as MPhone
		FROM [192.168.0.9].Trustaff_Med.dbo.CandidateLink cl
		LEFT JOIN [192.168.0.9].Trustaff_Med.dbo.CONTACT1 c on cl.candidateID = c.id
		LEFT JOIN [192.168.0.9].Trustaff_Med.dbo.appBasicInfo abi ON cl.ApplicationID = abi.ApplicationID
		where 1=1 --cl.ErecruitId < 1
		and cl.candidateID is NOT NULL
		and (abi.FName is NOT NULL and abi.LName is NOT NULL)
	) as s
	on t.CandidateGoldMineID = s.GoldMineID --and t.CandidateERecruitID IS NULL
	WHEN MATCHED THEN 
		UPDATE SET
			t.[CandidateFirstName] = s.[FName]
			,t.[CandidateLastName] = s.[LName]
			,t.[CandidateAddress] = s.[FullAddress]
			,t.[CandidateCity] = s.[City]
			,t.[CandidateState] = SUBSTRING(s.[State],1,2)  
			,t.[CandidateZip] = SUBSTRING(s.[Zip],1,5)
			,t.[CandidateEmail] = s.[Email]
			,t.[CandidatePhone] = s.[MPhone]
			,t.[CandidateNotes] = NULL
			,t.[CandidateIsActive] = 1
			,t.[IsCandidateDNU] = 0
			,t.[CandidateFullName] = CONCAT(s.[FName], ' ',s.[LName])
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
				,s.[FName]
				,s.[LName]
				,s.[FullAddress]
				,s.[City]
				,SUBSTRING(s.[State],1,2)  
				,SUBSTRING(s.[Zip],1,5)
				,s.[Email]
				,s.[MPhone]
				,NULL
				,1
				,0
				,CONCAT(s.[FName], ' ',s.[LName])
				,GETDATE()
				,SYSTEM_USER
				,GETDATE()
				,SYSTEM_USER
				,'GM')
	OUTPUT $action, inserted.*; 


	MERGE [MarginCalculator].[dbo].[Candidates] t
	USING 
	(
		--Candidates - GoldMine without an application
		select	cl.candidateID as GoldMineID
				,cl.ErecruitId
				,SUBSTRING(c.CONTACT, 1 ,
					case when  CHARINDEX(' ', c.CONTACT) = 0 then LEN(c.CONTACT) 
					else CHARINDEX(' ', c.CONTACT) -1 end) as FirstName
				,c.LASTNAME
				,c.ADDRESS1
				,c.CITY
				,c.STATE
				,c.ZIP
				,cl.Email
				,c.PHONE1
		from [192.168.0.9].Trustaff_Med.dbo.CandidateLink cl
		join [192.168.0.9].Trustaff_Med.dbo.CONTACT1 c on cl.candidateID = c.id
		where cl.ApplicationID is NULL
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


