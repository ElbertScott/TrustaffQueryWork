USE Trustaff_Med

--Admin Bucket
select x.*
from
(
	SELECT 
	FacPacketID,
	C1.COMPANY AS Facility, 
	(select UVMSMSP from CONTACT2 where ACCOUNTNO = c1.ACCOUNTNO) as VMSPortal, 
	(select UHLTHSYS from CONTACT2 where ACCOUNTNO = c1.ACCOUNTNO) as HealthSystem, 
	CASE WHEN JR1.[MCState] IS NOT NULL THEN JR1.[MCState] ELSE c1.[STATE] END AS STATE, 
	(select Ugrade from CONTACT2 where ACCOUNTNO = c1.ACCOUNTNO) as Tier, 
	CASE  
	WHEN (JR1.fk_ProfessionID = '1') AND (JR1.fk_DivisionID = '2')  THEN C1.KEY4    
	ELSE C1.KEY4
	END as AM, 
	JS.SpecialtyName AS Specialty, 
	C2.CONTACT AS Nurse, 
	C2.KEY4 AS Recruiter, 
	FP.RequestID, 
	fp.AssocJobID, 
	FP.RegistryPrivateID as JobID,
	FP.RequestDate as Submitted,
	LV.ShortDesc AS SubmitStatus, 
	FP.Notes, 
	fp.BillRate, 
	C2.KEY2 as GMStatus, 
	FP.AMNotes,
	FP.FacilityID,
	FP.CandidateID,
	cL.ErecruitId,
	FP.fired,
	FP.Cancelled,
	FP.Highlight,
	CASE ISNULL(T.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as SubmittedElse,
	ISNULL(CN.CandidateiD, 0) as RedFlag,
	CASE ISNULL(NAO.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as NurseAcceptedOffer

	FROM dbo.FacPackets (nolock) FP
	JOIN dbo.CONTACT1 (nolock) C1 ON FP.FacilityID = C1.id
	JOIN dbo.CONTACT1 (nolock) C2 ON FP.CandidateID = C2.id
	LEFT JOIN
	(
		select candidateID, mPhone, Email
		from 
		(
			select applicationID, candidateID, MPhone, Email, ROW_NUMBER() OVER(Partition by CandidateID ORDER BY ApplicationID desc) AS Row
			from dbo.appBasicInfo (nolock)
		) as x
		where row = 1
	) as abi
		on FP.CandidateID = abi.CandidateID
	JOIN dbo.LookupValue (nolock) LV ON FP.SubmitStatus = LV.LookupValueID
	LEFT JOIN dbo.UserList (nolock) UL ON C2.U_KEY4 = UL.GM_Username
	JOIN dbo.JobSpecialty (nolock) JS ON FP.Specialty = JS.pk_SpecialtyID
	LEFT JOIN dbo.JobRequests (nolock) as JR1 ON C1.id = JR1.fk_ClientID AND JR1.pk_JobRequestID = FP.requestid
	LEFT JOIN dbo.CandidateLink cL on FP.CandidateID = cL.candidateID
	LEFT JOIN
	(
		SELECT CONTACT1_1.id ,ISNULL(C2.U_GENER13,'None') as FrontEnd,UL.User_Email as frontEndEmail
		FROM  dbo.CONTACT1 AS CONTACT1_1
		JOIN dbo.CONTACT2 C2 ON C2.ACCOUNTNO = CONTACT1_1.ACCOUNTNO
		JOIN  dbo.UserList ON SUBSTRING(CONTACT1_1.KEY4,0,9) = SUBSTRING(dbo.UserList.GM_Username,0,9)
		JOIN  dbo.UserList as UL ON SUBSTRING(c2.U_GENER13,0,9) = SUBSTRING(UL.GM_Username,0,9)
		WHERE (C2.U_GENER13 != NULL or U_GENER13 !='')
		GROUP BY CONTACT1_1.id,C2.U_GENER13,UL.User_Email
	) as fe
		on c2.id = fe.id
	LEFT JOIN
	(
		SELECT dbo.FacPackets.CandidateID
		FROM  dbo.FacPackets 
		JOIN  dbo.CONTACT1 ON dbo.FacPackets.FacilityID = dbo.CONTACT1.id 
		JOIN  dbo.CONTACT1 AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id 
		JOIN  dbo.LookupValue AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID 
		JOIN  dbo.UserList ON CONTACT1_1.KEY4 = SUBSTRING(dbo.UserList.GM_Username,0,9)
		JOIN  dbo.JobSpecialty ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID 
		WHERE dbo.FacPackets.SubmitStatus IN (576,578) 
		AND dbo.FacPackets.AcctManager IS NULL 
		AND dbo.FacPackets.ClosedDate > GETDATE() - 1
		GROUP BY FacPackets.CandidateID
	) as T
		on FP.candidateID = T.CandidateID
	LEFT JOIN
	(
		select distinct x.candidateID
		from
		(
			Select COUNT(Nurse_ID) total,Cancellation_Status,Nurse_ID,candidateID 
			from Esig.dbo.Documents
			JOIN dbo.candidatelink on CandidateLink.NurseID = Documents.Nurse_ID
			where Status_ID = 8 
			and Cancellation_Date >='5/1/2017'
			AND Cancellation_Status in ('Fired','Quit')
			GROUP BY Cancellation_Status ,Nurse_ID,candidateID
			Having COUNT(Nurse_ID) >=3
		) as x
	) as CN
		on FP.CandidateID = CN.CandidateID
	LEFT JOIN
	(
		select CandidateID, SubmitStatus
		from dbo.FacPackets
		where 1=1
		and SubmitStatus = 578
		and ClosedDate > GETDATE() - 1
		GROUP BY CandidateID, SubmitStatus	
	) as NAO
		on FP.CandidateID = NAO.CandidateID
		
	WHERE 1=1 
	AND (FP.SubmitStatus = 411)
	AND FP.trustaffCompany_ID != 9
	AND fp.RequestDate > GETDATE() - 365 
) as x
where 1=1
and (x.FacPacketID NOT IN (select SubmittalID from dbo.ADMINSUBS)
	OR
	x.FacPacketID IN (select SubmittalID from dbo.ADMINSUBS where AdminRep = 515 and DATEADDED > GETDATE() - 365)	--Pass in Admin's Esig ID from UserList table, i.e. 515
	)
order by Facility