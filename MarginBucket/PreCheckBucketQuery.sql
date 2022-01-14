
select x.*
from
(
	SELECT
	C1.COMPANY AS Facility,
	fp.FacPacketID,
	fp.DateStart,
	SubmittalPrecheckStatusID,
	SubmittalPrecheckUserID,
    IsReturned,
    InsertDate,
	(select Ugrade from CONTACT2 where ACCOUNTNO = c1.ACCOUNTNO) as Tier,
	CASE
	WHEN (JR1.fk_ProfessionID = '1') AND (JR1.fk_DivisionID = '2')  THEN C1.KEY4
	ELSE C1.KEY4
	END as AM,
	JS.SpecialtyName AS Specialty,
	C2.CONTACT AS Nurse,
	abi.MPhone as NursePhone,
	abi.Email as NurseEmail,
	C2.KEY4 AS Recruiter,
	ISNULL(Fe.FrontEnd,'None') as FrontEnd,
	Fe.frontEndEmail,
	FP.RegistryPrivateID as JobID,
	FP.AMDate as LastUpdated,
	fp.RequestDate,
	FP.RequestDate as Submitted,
	CASE WHEN fp.submitDate = '1900-01-01' THEN '' ELSE fp.submitDate END as submitdate,
	fp.DateSubmitted,
	LV.ShortDesc AS SubmitStatus,
	FP.Notes,
	fp.BillRate,
	C2.KEY2 as GMStatus,
	C1.CONTACT AS PrimaryContact,
	(select TOP 1 CONTSUPREF from dbo.CONTSUPP where ACCOUNTNO = C1.ACCOUNTNO and CONTACT = 'E-mail Address' and ADDRESS2 = C1.CONTACT order by recid desc) as ContactEmail,
	FP.AMNotes,
	FP.FacilityID,
	FP.CandidateID,
	cL.ErecruitId,
	FP.fired,
	FP.Cancelled,
	FP.Highlight,
	FP.SubmittedBy,  --New
    FP.NLAPOS,
	FP.requestid,
	CASE ISNULL(T.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as SubmittedElse,
	ISNULL(CN.CandidateiD, 0) as RedFlag,
	CASE ISNULL(NAO.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as NurseAcceptedOffer,
	CASE ISNULL(CNLA.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as CandidateNoLongerAvailable
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
	LEFT JOIN
	(
		select FacPacketID, SubmittalPrecheckStatusID, IsReturned, InsertDate, AssignedDate, ResolutionDate, SubmittalPrecheckUserID
		from
		(
			select SubmittalPreCheckID, FacPacketID, SubmittalPrecheckStatusID, IsReturned, InsertDate, AssignedDate, ResolutionDate, SubmittalPrecheckUserID,
					ROW_NUMBER() OVER(Partition by FacPacketID order by SubmittalPreCheckID desc) as row
			from [SQLAZUPROD01].[MarginBucket].dbo.SubmittalPrecheck
			where SubmittalPrecheckStatusID is NULL
		) as x
		where row = 1
	) as precheck
	 on FP.FacPacketID = precheck.FacPacketID	
	JOIN dbo.LookupValue (nolock) LV ON FP.SubmitStatus = LV.LookupValueID
	LEFT JOIN dbo.UserList (nolock) UL ON C2.U_KEY4 = UL.GM_Username
	JOIN dbo.JobSpecialty (nolock) JS ON FP.Specialty = JS.pk_SpecialtyID
	LEFT JOIN dbo.JobRequests (nolock) as JR1 ON C1.id = JR1.fk_ClientID AND JR1.pk_JobRequestID = FP.requestid
	LEFT JOIN dbo.CandidateLink cL on FP.CandidateID = cL.candidateID
  --left join [MarginBucket].[dbo].[SubmittalPrecheck].FacPacketID
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
		AND dbo.FacPackets.ClosedDate > GETDATE() - 7
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
		and ClosedDate > GETDATE() - 7
		GROUP BY CandidateID, SubmitStatus	
	) as NAO
		on FP.CandidateID = NAO.CandidateID
	LEFT JOIN
	(
		select CandidateID, SubmitStatus
		from dbo.FacPackets
		where 1=1
		and SubmitStatus = 670
		and ClosedDate > GETDATE() - 7
		GROUP BY CandidateID, SubmitStatus		
	) as CNLA
		on FP.CandidateID = CNLA.CandidateID
	WHERE 1=1
	AND (FP.SubmitStatus IN (671)
	or (FP.SubmitStatus = 670 and precheck.FacPacketID=FP.FacPacketID and(precheck.SubmittalPrecheckStatusID is null or precheck.SubmittalPrecheckStatusID in (3, 4))))
	AND FP.trustaffCompany_ID != 9
	AND fp.RequestDate > GETDATE() - 365
) as x
order by InsertDate desc