
--Main Page. Use USE Trustaff_Med_bucket
--new bucket is 10.240.3.36
--old bucket is https://esig.trustaff.com/trustaffportal/submittals/submittalBucketAM_TimRemote.aspx?actmgr=SFRASER

--Bucket Query
USE Trustaff_Med

--Nurse Accepted Offer - 578
--Facility Declined Offer - 422 
--Submittal Pulled - 451


select x.*
from
(
	SELECT 
	C1.COMPANY AS Facility,
	FacPacketID,
	(select Ugrade from CONTACT2 where ACCOUNTNO = c1.ACCOUNTNO) as Tier,
	CASE  
	WHEN (JR1.fk_ProfessionID = '1') AND (JR1.fk_DivisionID = '2')  THEN C1.KEY4    
	ELSE C1.KEY4
	END as AM,
	JS.SpecialtyName AS Specialty,
	C2.CONTACT AS Nurse,
	C2.PHONE1 as NursePhone,  --new --abi.MPhone as NursePhone,
	(select TOP 1 CONTSUPREF from dbo.CONTSUPP where ACCOUNTNO = C2.ACCOUNTNO and CONTACT = 'E-mail Address' order by recid desc) as NurseEmail, --new   --abi.Email as NurseEmail,
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
	CASE ISNULL(T.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as SubmittedElse,
	ISNULL(CN.CandidateiD, 0) as RedFlag,
	CASE ISNULL(NAO.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as NurseAcceptedOffer,
	CASE ISNULL(CNLA.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as CandidateNoLongerAvailable

	FROM dbo.FacPackets (nolock) FP
	JOIN dbo.CONTACT1 (nolock) C1 ON FP.FacilityID = C1.id
	JOIN dbo.CONTACT1 (nolock) C2 ON FP.CandidateID = C2.id
	--Remove derived table below
	--LEFT JOIN
	--(
	--	select candidateID, mPhone, Email
	--	from 
	--	(
	--		select applicationID, candidateID, MPhone, Email, ROW_NUMBER() OVER(Partition by CandidateID ORDER BY ApplicationID desc) AS Row
	--		from dbo.appBasicInfo (nolock)
	--	) as x
	--	where row = 1
	--) as abi
	--	on FP.CandidateID = abi.CandidateID
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
		AND dbo.FacPackets.ClosedDate > GETDATE() - 7  --246
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
		and ClosedDate > GETDATE() - 7 --246
		GROUP BY CandidateID, SubmitStatus	
	) as NAO
		on FP.CandidateID = NAO.CandidateID
	LEFT JOIN
	(
		select CandidateID, SubmitStatus
		from dbo.FacPackets 
		where 1=1
		and SubmitStatus = 670
		and ClosedDate > GETDATE() - 7 --246
		GROUP BY CandidateID, SubmitStatus		
	) as CNLA
		on FP.CandidateID = CNLA.CandidateID
		
	WHERE 1=1 
	AND (FP.SubmitStatus IN (411,414,423,426,567,568,576,579,601,602,619,623,638,639,422,451,578))  --422,451,578
	AND FP.trustaffCompany_ID != 9
	AND fp.RequestDate > GETDATE() - 365 
) as x
where 1=1
and (SUBSTRING(Recruiter,0,9)) = 'RSLANDZI' OR SubmittedBy = 'RSLANDZI' --Add Account Mgr parameter here
order by Facility


--Account Manager List/Search
USE Trustaff_Med_bucket

select EsigID,
		GM_Username,
		Name,
		User_Email
from dbo.UserList (nolock)
where ActMgr = 1
and Active = 1



--Candidate Credentials Query. 
--USE erecruit_TRUSTAFF_bucket
select oreq.[RecordID]
	   ,Can.CANDIDATE_ID
	   ,can.FullName AS Candidate_Name
	   ,can.FIRST_NAME
	   ,can.LAST_NAME
       ,r.[Name] as [RequirementName]
	   ,oreq.[ExpirationDate]
	   ,reqstat.Name AS STATUS
	   ,oreq.ConfirmedDate
from dbo.ObjectRequirements (nolock) oreq
join [dbo].[Requirements] (nolock) r on r.[RequirementID] = oreq.[RequirementID]
Join dbo.RequirementTypes (nolock) Reqt on r.TypeID = Reqt.TypeID
JOIN dbo.RequirementStatusDefinitions (nolock) AS reqstat ON reqstat.StatusID = oreq.StatusID 
join dbo.CANDIDATE (nolock) can on oreq.ReferenceID = can.CANDIDATE_ID
LEFT JOIN dbo.HR_REPRESENTATIVE (nolock) AS hr_own ON hr_own.UserID = can.OwnerUserID
where 1=1 
and oreq.AboutTypeID in (5,6) --5 = Match, 6 = Candidate
and can.CANDIDATE_ID = 11419  --Pass int Candidate eRecruit ID
order by r.Name


--Search for Candidate Profile History that have been in a position at a facility - Good
--Please use Margic Calculator version of this query if it has changed.
--Use erecruit_TRUSTAFF_bucket
SELECT	m.MATCH_ID
		--, m.TYPE_ID
		--, m.POSITION_ID
		--, m.CANDIDATE_ID
		, m.START_DATE  --same format other dates
		, isnull(m.[CNTR_END_DATE], m.[EstimatedEndDate]) as [EndDate] --same format as other dates
		, cy.NAME as Facility  --varchar(250)
		, pd.PENDING_DESC  --varchar55)
		, p.POSITION_TITLE --varchar(250)
		, m.EndedEarly --bit 1=Yes, 0=No
		, m.EndReasonComment --nvarchar(max)
		--,cy.COMPANY_ID
		--,p.POSITION_ID
		--,c.CANDIDATE_ID
		, c.FIRST_NAME --varchar(25)
		, c.LAST_NAME --varchar(25)
		, n.Body as Notes --varchar(max)
FROM dbo.Match (nolock) m	
JOIN dbo.CANDIDATE (nolock) c ON	m.CANDIDATE_ID = c.CANDIDATE_ID
JOIN dbo.POSITION (nolock) p	ON m.POSITION_ID = p.POSITION_ID	
JOIN dbo.CONTACT (nolock) co ON p.CONTACT_ID = co.CONTACT_ID
JOIN dbo.COMPANY (nolock) cy ON co.COMPANY_ID = cy.COMPANY_ID
left join dbo.[PENDING_DESC] (nolock) pd on m.PENDING_STATUS = pd.PENDING_STATUS and pd.PENDING_DESC = 'Full Placement'
left join dbo.NewNotes (nolock) n on m.LastNoteID = n.NoteID
WHERE 1 = 1
and c.FIRST_NAME = 'Anthony' --Tracey Stant, Jonathan Green, Anthony Stephens, Lori Carter
and c.LAST_NAME = 'Stephens' --Filter list using candidate first and last name
--and cy.COMPANY_ID = 1251 
--and cy.NAME = 'King's Daughters Medical Center / KY'    --Kings Daughters Medical Center in Ashland Kentucky
order by m.START_DATE desc




USE Trustaff_Med_bucket

update dbo.FacPackets
set Notes = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
	AMNotes = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'