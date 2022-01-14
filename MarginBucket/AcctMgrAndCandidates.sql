USE Trustaff_Med_bucket

select x.AM, x.Nurse, count(*)
from
(
	SELECT FacPacketID,
	C1.COMPANY                                    AS Facility,
	NULL as Tier,
	CASE  
	WHEN (JR1.fk_ProfessionID = '1') AND (JR1.fk_DivisionID = '2')  THEN C1.KEY4    
	ELSE C1.KEY4
	END as AM,
	JS.SpecialtyName AS Specialty,
	C2.CONTACT AS Nurse,
	abi.MPhone as NursePhone,
	abi.Email as NurseEmail,
	C2.KEY4 AS Recruiter,
	NULL as FrontEnd,
	FP.RequestID as JobID,
	NULL as LastUpdated,
	fp.RequestDate,
	CASE WHEN fp.submitDate = '1900-01-01' THEN '' ELSE fp.submitDate END as submitdate,
	fp.DateSubmitted,
	LV.ShortDesc AS SubmitStatus,
	FP.Notes,
	fp.BillRate,
	C2.KEY2 as GMStatus,
	C1.CONTACT AS PrimaryContact,
	--(select TOP 1 CONTSUPREF from dbo.CONTSUPP where ACCOUNTNO = C1.ACCOUNTNO and CONTACT = 'E-mail Address' order by recid desc) as ContactEmail,
	FP.AMNotes,
	FP.FacilityID,
	FP.CandidateID,
	cL.ErecruitId

	FROM   dbo.FacPackets (nolock) FP
	INNER JOIN dbo.CONTACT1 (nolock) C1 ON FP.FacilityID = C1.id
	INNER JOIN dbo.CONTACT1 (nolock) C2 ON FP.CandidateID = C2.id
	INNER JOIN dbo.appBasicInfo (nolock) abi on FP.CandidateID = abi.CandidateID
	INNER JOIN dbo.LookupValue (nolock) LV ON FP.SubmitStatus = LV.LookupValueID
	INNER JOIN dbo.UserList (nolock) UL ON C2.U_KEY4 = UL.GM_Username
	INNER JOIN dbo.JobSpecialty (nolock) JS ON FP.Specialty = JS.pk_SpecialtyID
	LEFT  JOIN dbo.JobRequests (nolock) as JR1 ON C1.id = JR1.fk_ClientID AND JR1.pk_JobRequestID = FP.requestid
	left join dbo.CandidateLink cL on FP.CandidateID = cL.candidateID
	WHERE  ( FP.SubmitStatus IN (411,414,423,426,567,568,576,579,601,602,623,639,638 ) )
			AND ( FP.AcctManager IS NULL )
			  OR ( FP.SubmitStatus IN ( 421, 577 ) )
				 AND ( FP.ClosedDate > Getdate() - 1 )
	AND fp.RequestDate > GETDATE() - 365
) as x
--where x.AM in ('JENDRES','SHANNONS','SFRASER')
group by x.AM, x.Nurse
order by x.Nurse
