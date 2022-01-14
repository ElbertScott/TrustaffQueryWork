USE Trustaff_Med --Gold Mine DB

http://margins.trustaff.com/?JobReqId=530239

http://margins.trustaff.com/?JobReqId=525293

http://margins.trustaff.com/?JobReqId=525314

http://margins.trustaff.com/blankCalculator

http://tru-vweb2dev:8000/JobBoard.aspx

https://www.mssqltips.com/sqlservertip/5082/synchronize-table-data-using-a-merge-join-in-ssis/

https://esig.trustaff.com/trustaffportal/submittals/submittalBucketAM_TimRemote.aspx?actmgr=JENDRES

Tbl_GM_facilityLink


--Facility - eRecruit
SELECT	c.COMPANY_ID AS eRecruitID
		,c.NAME AS FacilityName
		,c.ADDRESS_LINE1 AS FacilityAddress1
		,c.CITY AS FacilityCity
		,c.[STATE] AS FacilityState
		,c.POSTAL_CODE AS FacilityZip
		,ct.FullName
		--,hashbytes('SHA2_512',concat(c.NAME,'|',c.ADDRESS_LINE1,'|',c.CITY,'|',c.STATE,'|',c.POSTAL_CODE))
FROM dbo.COMPANY c
join dbo.CONTACT ct on c.DefaultContactID = ct.CONTACT_ID
WHERE c.StatusID not in (select StatusID from CompanyStatus where Name in ('Do Not Staff','Inactive'))

USE Trustaff_Med

--Facility - Gold Mine
SELECT	DISTINCT 
		c.id AS GoldMineID
		,c.COMPANY AS FacilityName
		,c.ADDRESS1 AS FacilityAddress1
		,c.ADDRESS2 AS FacilityAddress2
		,c.ADDRESS3 AS FacilityAddress3
		,c.CITY AS FacilityCity
		,c.[STATE] AS FacilityState
		,c.ZIP AS FacilityZip
		,c.CONTACT
FROM dbo.CONTACT1 c
where c.id in ( select distinct fk_ClientID from dbo.JobRequests where dateCreated >= DATEADD(yy,-1,getdate()))
order by c.COMPANY

--tbl_Gm_facilityLink
select *
from tbl_Gm_facilityLink

--Recruiter - GoldMine
SELECT ul.EsigID, ul.Name, ul.User_Email, ul.Active, ul.DATEADDED, ul.DateModified, ul.ModifiedBy
FROM dbo.UserList ul
WHERE ul.Recruiter = 1

--Recruiter - eRecruit
SELECT	hr.HR_REP_ID as ErecruitID
		,hr.FIRST_NAME
		,hr.LAST_NAME
		,hr.EMAIL
		--,hashbytes('SHA2_512',concat(hr.FIRST_NAME,'|',hr.LAST_NAME,'|',hr.EMAIL))
FROM dbo.HR_REPRESENTATIVE hr
WHERE hr.RECRUITER = 1
and END_DATE is NULL



--Candidates - GoldMine
SELECT id, cl.candidateID, cl.ApplicationID, cl.ErecruitId,
		abi.FName, abi.LName, abi.Address, abi.FullAddress,
		abi.City, abi.[State], abi.Zip, abi.Email, abi.MPhone
FROM dbo.CandidateLink cl
LEFT JOIN dbo.appBasicInfo abi ON cl.ApplicationID = abi.ApplicationID

--Candidate - eRecruit
SELECT	c.CANDIDATE_ID AS CandidateERecruitID
		,c.FIRST_NAME AS CandidateFirstName
		,c.LAST_NAME AS CandidateLastName
		,c.CURRENT_ADDRESS1 AS CandidateAddress
		,c.CURRENT_CITY AS CandidateCity
		,c.CURRENT_STATE AS CandidateState
		,c.CURRENT_POSTAL_CODE AS CandidateZip
		,'trustaffedw@ctipartners.co' AS CandidateEmail  --c.EMAIL AS CandidateEmail
		,c.PrimaryPhone AS CandidatePhone
		,cs.STATUS_DESC as CanddidateStatus
		,CASE WHEN c.STATUS_ID = 3 THEN 1 ELSE 0 END AS isCandidateDNU
		,n.Body as Notes
		--,hashbytes('SHA2_512',concat(c.FIRST_NAME,'|',c.LAST_NAME,'|',c.CURRENT_ADDRESS1,'|',c.CURRENT_CITY,
		--			'|',c.CURRENT_STATE,'|',c.CURRENT_POSTAL_CODE,'|',c.EMAIL,'|',c.PrimaryPhone,'|',c.STATUS_ID,
		--			'|',SUBSTRING(n.Body,1,100000)))
FROM dbo.CANDIDATE c 
left join dbo.NewNotes n on c.LastNoteID = n.NoteID
left join dbo.CANDIDATE_STATUS cs on c.STATUS_ID = cs.STATUS_ID


--Candidate Search --OLD DO NOT USE
select	DISTINCT p.POSITION_ID
		,c.CANDIDATE_ID
		,cy.NAME as Factility
		,p.POSITION_TITLE, c.FIRST_NAME, c.LAST_NAME
		,c.FirstNameLastName as Name
		,pd.PENDING_DESC as CandidateStatus
		,c.EMAIL
		,c.PrimaryPhone as Phone
from ER.Match m
join ER.POSITION p on m.POSITION_ID = p.POSITION_ID
join ER.CANDIDATE c on m.CANDIDATE_ID = c.CANDIDATE_ID
join ER.CONTACT ct on p.CONTACT_ID = ct.CONTACT_ID
join ER.COMPANY cy on ct.COMPANY_ID = cy.COMPANY_ID
left join ER.PENDING_DESC pd on m.PENDING_STATUS = pd.PENDING_STATUS
where 1=1
--and c.FIRST_NAME = 'Kelli' and c.LAST_NAME = 'Jones' 
