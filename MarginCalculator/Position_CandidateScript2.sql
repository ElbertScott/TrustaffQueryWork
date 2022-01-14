USE erecruit_Trustaff

--Search for Candidate Profile History that have been in a position at a facility
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
FROM dbo.Match m	
JOIN dbo.CANDIDATE c ON	m.CANDIDATE_ID = c.CANDIDATE_ID
JOIN dbo.POSITION p	ON m.POSITION_ID = p.POSITION_ID	
JOIN dbo.CONTACT co ON p.CONTACT_ID = co.CONTACT_ID
JOIN dbo.COMPANY cy ON co.COMPANY_ID = cy.COMPANY_ID
left join [dbo].[PENDING_DESC] pd on m.PENDING_STATUS = pd.PENDING_STATUS and pd.PENDING_DESC = 'Full Placement'
left join dbo.NewNotes n on m.LastNoteID = n.NoteID
WHERE 1 = 1
and c.FIRST_NAME = 'Anthony' --Tracey Stant, Jonathan Green, Anthony Stephens, Lori Carter
and c.LAST_NAME = 'Stephens'
--and cy.COMPANY_ID = 1251 
--and cy.NAME = 'King's Daughters Medical Center / KY'    --Kings Daughters Medical Center in Ashland Kentucky
order by m.START_DATE desc



--Search for Postions by Company
--positionid, open or closed, matches(count), full placement(count), and candidates
--match in full placement
--last 12 months - Update using Samuel's screen shot.
USE erecruit_TRUSTAFF

select	x.Position
		,x.Facility
		,x.PositionStatus
		,sum(x.TotalMatches) as TotalMatches
		,sum(x.FullPlacement) as FullPlacement
from 
(
	--positions and Facilities, Open or Closed
	select	main.POSITION_ID
			,main.Position
			,main.Facility
			,main.PositionStatus
			,mc.TotalMatches
			,fp.FullPlacement
	from 
	(
		select  DISTINCT p.POSITION_ID
				, RTRIM(LTRIM(p.POSITION_TITLE)) as Position
				, c.NAME as Facility
				, pd.PENDING_DESC as PositionStatus
		
		from dbo.POSITION p
		left join dbo.Match m on p.POSITION_ID = m.POSITION_ID
		left join dbo.CONTACT ct on p.CONTACT_ID = ct.CONTACT_ID
		left join dbo.COMPANY c on ct.COMPANY_ID = c.COMPANY_ID
		left join dbo.PENDING_DESC pd on m.PENDING_STATUS = pd.PENDING_STATUS
		where 1=1 
		--and p.STATUS_ID in (0,3)
		and p.DATE_ENTERED >= DATEADD(m,-12, getdate())
	) main
	left join
	(
		--Position total matches
		select POSITION_ID, count(*) as TotalMatches
		from Match
		group by POSITION_ID
	) mc on main.POSITION_ID = mc.POSITION_ID
	left join
	(
		--position full placement
		select POSITION_ID, count(*) as FullPlacement
		from Match m
		where m.PENDING_STATUS = 120 --Full Placement
		and m.DATE_ENTERED >= DATEADD(m,-12, getdate())
		group by POSITION_ID
	) fp on main.POSITION_ID = fp.POSITION_ID
) x
where 1=1
--and Position = '' and Facility = ''
group by Position, Facility, PositionStatus
order by Position, Facility, PositionStatus

--Position History - Updated
select	p.POSITION_ID
		,p.POSITION_TITLE
		,c.NAME as Facility
		,p.DATE_ENTERED
		,p.DATE_LAST_OPENED
		,p.STATUS_ID --position status
		,ps.STATUS_DESC as PositionStatus
		,pd.PENDING_DESC as MatchStatus
		,ca.FIRST_NAME
		,ca.LAST_NAME
		,ca.FullName
		,ca.FullNameReversed
		,m.EndedEarly --bit 1=Yes, 0=No
		,m.EndReasonComment --nvarchar(max)
from dbo.POSITION p
left join dbo.POSITION_STATUS ps on p.STATUS_ID = ps.STATUS_ID
left join dbo.CONTACT ct on p.CONTACT_ID = ct.CONTACT_ID
left join dbo.COMPANY c on ct.COMPANY_ID = c.COMPANY_ID
left join dbo.Match m on p.POSITION_ID = m.POSITION_ID
left join dbo.PENDING_DESC pd on m.PENDING_STATUS = pd.PENDING_STATUS
left join dbo.CANDIDATE ca on m.CANDIDATE_ID = ca.CANDIDATE_ID
where 1=1 
and p.DATE_ENTERED >= DATEADD(m,-12, getdate())
order by p.POSITION_ID, p.DATE_ENTERED


--Candidate Search
select	c.CANDIDATE_ID
		,cy.NAME as Factility
		,p.POSITION_TITLE, c.FIRST_NAME, c.LAST_NAME
		,c.FirstNameLastName as Name
		,pd.PENDING_DESC as CandidateStatus
		,c.EMAIL
		,c.PrimaryPhone as Phone
from dbo.Match m
join dbo.POSITION p on m.POSITION_ID = p.POSITION_ID
join dbo.CANDIDATE c on m.CANDIDATE_ID = c.CANDIDATE_ID
join dbo.CONTACT ct on p.CONTACT_ID = ct.CONTACT_ID
join dbo.COMPANY cy on ct.COMPANY_ID = cy.COMPANY_ID
left join dbo.PENDING_DESC pd on m.PENDING_STATUS = pd.PENDING_STATUS
where 1=1
and c.FIRST_NAME = '' and c.LAST_NAME = ''

