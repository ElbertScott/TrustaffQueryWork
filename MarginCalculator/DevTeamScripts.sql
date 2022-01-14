--Job Board Data is staged in dbo.JobBoard.  Use pk_JobRequestID to get job details for a specific job.
--Data from the first query is loaded in dbo.JobBoard.
--MC_001, MC_002, MC_003, MC_005, MC_007, MC_011
--Load Position Data From Job board
USE Trustaff_Med_Bucket

select	jr.pk_JobRequestID --int
		--,fp.FacPacketID
		,jr.guarantee --int
		,lv.ShortDesc AS Duration --nvarchar(125)
		,js.SpecialtyName --varchar(50)
		,c.id AS GoldMineID --int
		,c.Company as Facility --varchar(100)
		,c.ADDRESS1 --varchar(40)
		,c.CITY --varchar(30)
		,SUBSTRING(c.ZIP,1,5) AS ZIP --varchar(10)
		,c.[STATE] --varchar(20)
		,CAST(COALESCE(jr.Bill,r.Rate) AS decimal) as BillRate --decimal
		,CAST(fo.OnCallBillRate as decimal) as OnCallBillRate --decimal
		,CAST(fo.OtBillRate as decimal) as OtBillRate --decimal 
		,fo.startDate --date
		,fo.Enddate --date
		,fo.WeekStart --varchar(255)
		,fo.WeekEnd --varchar(255)
		,fo.ComplianceDueDate --date
		,fo.AcctMgrNotes  --varchar(500)
		,fo.FacilityTestinglocation --varchar(255)
		,fo.FacilityLocation --varchar(255)
		,fo.V_M_services --varchar(255)
		,fo.RequestedTimeOff --varchar(255)
		,fo.UnitName as PrimaryUnit --varchar(255)
		,UL.Name as AccountManager --varchar(255)
		--,fo.RecruiterID
		--,fo.candidateID
		--,cl.candidateID
		--,cl.ErecruitId
		,CASE	WHEN jr.Shift = 172 THEN 12 --int
				WHEN jr.Shift = 173 THEN 12
				WHEN jr.Shift = 174 THEN 12
				WHEN jr.Shift = 175 THEN 8
				WHEN jr.Shift = 176 THEN 8
				WHEN jr.Shift = 177 THEN 8
				WHEN jr.Shift = 178 THEN 12
				WHEN jr.Shift = 179 THEN 12
				WHEN jr.Shift = 180 THEN 12
				WHEN jr.Shift = 181 THEN 12
				WHEN jr.Shift = 296 THEN 12
				WHEN jr.Shift = 297 THEN 12
				WHEN jr.Shift = 298 THEN 8
				WHEN jr.Shift = 299 THEN 12
				WHEN jr.Shift = 300 THEN 10
		END AS HrShift
		,CASE	WHEN jr.Shift = 172 THEN '12 HR AM' 
				WHEN jr.Shift = 173 THEN '12 HR PM'
				WHEN jr.Shift = 174 THEN '12 HR Rotate'
				WHEN jr.Shift = 175 THEN '8 HR Days'
				WHEN jr.Shift = 176 THEN '8 HR Evenings'
				WHEN jr.Shift = 177 THEN '8 HR Nights'
				WHEN jr.Shift = 178 THEN '11AM - 11PM'
				WHEN jr.Shift = 179 THEN '11PM - 11AM'
				WHEN jr.Shift = 180 THEN '3PM - 3AM'
				WHEN jr.Shift = 181 THEN '3AM - 3PM'
				WHEN jr.Shift = 296 THEN '7a - 7p'
				WHEN jr.Shift = 297 THEN '7p - 7a'
				WHEN jr.Shift = 298 THEN '8 HR'
				WHEN jr.Shift = 299 THEN '12 HR'
				WHEN jr.Shift = 300 THEN '10 HR'
		END AS Shift
		,jr.RegistryPrivateID --varchar(255)
		,jr.RegistryID --int 
		c2.UHLTHSYS AS HEALTH_SYSTEM,  --New
		rjs.Name AS Portal --New
from dbo.jobrequests (nolock) jr
left join dbo.contact1 (nolock) c on jr.fk_ClientID = c.id
left join dbo.RPAJobListing (nolock) r on jr.RegistryPrivateID = r.PrivateId	AND jr.RegistryID = r.SiteId
LEFT JOIN dbo.RPAJobSite AS rjs WITH (NOLOCK) ON rjs.ID = jr.RegistryID --New
LEFT JOIN dbo.JobSpecialty (nolock) js ON jr.fk_SpecialtyID  = js.pk_SpecialtyID	
--LEFT JOIN dbo.FacPackets fp	ON jr.pk_JobRequestID = fp.RequestID
LEFT JOIN dbo.FacilityOffer (nolock) fo	ON fo.SubmittalID = (select max(FacPacketID) as FacPacketID from dbo.FacPackets (nolock) where RequestID = jr.pk_JobRequestID)
LEFT JOIN dbo.LookupValue (nolock) lv	ON jr.Duration = lv.LookupValueID
left JOIN dbo.UserList (nolock) ul on fo.AMID = ul.EsigID
where 1=1
--and fo.startDate >= '2020-01-01'
--and (fo.startDate >= '2020-01-01' or fo.startDate is NULL)
and pk_JobRequestID = 561608
order by jr.pk_JobRequestID desc


--Search for Candidate Profile History that have been in a position at a facility - Good
USE erecruit_TRUSTAFF_bucket

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
JOIN dbo.POSITION (nolock) p ON m.POSITION_ID = p.POSITION_ID	
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


--Candidate Search --New
USE erecruit_TRUSTAFF_bucket

select	DISTINCT c.CANDIDATE_ID
		,c.FIRST_NAME
		,c.LAST_NAME
		,c.FirstNameLastName as Name
		,cs.STATUS_DESC as CandidateStatus
		,c.EMAIL
		,c.PrimaryPhone as Phone
from dbo.CANDIDATE (nolock) c
join dbo.CANDIDATE_STATUS (nolock) cs on c.STATUS_ID = cs.STATUS_ID
where 1=1 
and cs.STATUS_ID in (1,2,4,6,14,15,16)
--and c.FIRST_NAME = 'Kelli' and c.LAST_NAME = 'Jones' 


--Position History 
USE erecruit_TRUSTAFF_bucket

select	p.POSITION_ID
		,p.POSITION_TITLE
		,c.NAME as Facility
		,p.DATE_ENTERED
		,p.DATE_LAST_OPENED 
		,p.STATUS_ID 
		,ps.STATUS_DESC as PositionStatus 
		,pd.PENDING_DESC as MatchStatus
		,m.START_DATE --Need to add to Match in Margin Calculator DB
		,isnull(m.[CNTR_END_DATE], m.[EstimatedEndDate]) as [EndDate]
		,ca.FIRST_NAME
		,ca.LAST_NAME 
		,m.EndedEarly 
		,m.EndReasonComment 
from dbo.POSITION (nolock) p
left join dbo.POSITION_STATUS (nolock) ps on p.STATUS_ID = ps.STATUS_ID 
left join dbo.CONTACT (nolock) ct on p.CONTACT_ID = ct.CONTACT_ID
left join dbo.COMPANY (nolock) c on ct.COMPANY_ID = c.COMPANY_ID
left join dbo.Match (nolock) m on p.POSITION_ID = m.POSITION_ID
left join dbo.PENDING_DESC (nolock) pd on m.PENDING_STATUS = pd.PENDING_STATUS
left join dbo.CANDIDATE (nolock) ca on m.CANDIDATE_ID = ca.CANDIDATE_ID
where 1=1 
--List can be filted using Facility Name and/or Position
and p.DATE_ENTERED >= DATEADD(m,-6, getdate())
order by p.POSITION_ID, p.DATE_ENTERED