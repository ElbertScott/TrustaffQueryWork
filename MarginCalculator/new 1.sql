USE MarginCalculator

--Facility - eRecruit
SELECT	c.COMPANY_ID AS eRecruitID
		,c.NAME AS FacilityName
		,c.ADDRESS_LINE1 AS FacilityAddress1
		,c.CITY AS FacilityCity
		,c.[STATE] AS FacilityState
		,c.POSTAL_CODE AS FacilityZip
		,ct.FullName
FROM [192.168.0.125].erecruit_TRUSTAFF.dbo.COMPANY c
join [192.168.0.125].erecruit_TRUSTAFF.dbo.CONTACT ct on c.DefaultContactID = ct.CONTACT_ID
WHERE c.StatusID not in (select StatusID from [192.168.0.125].erecruit_TRUSTAFF.dbo.CompanyStatus where Name in ('Do Not Staff','Inactive'))


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
FROM [192.168.0.125].erecruit_TRUSTAFF.dbo.CANDIDATE c 
left join [192.168.0.125].erecruit_TRUSTAFF.dbo.NewNotes n on c.LastNoteID = n.NoteID
left join [192.168.0.125].erecruit_TRUSTAFF.dbo.CANDIDATE_STATUS cs on c.STATUS_ID = cs.STATUS_ID

USE MarginCalculator


alter table dbo.PositionDetail
	add RegistryPrivateID varchar(100),
		RegistryID varchar(100)

alter table dbo.Calculator
	add SubmittalID int,
		RegistryPrivateID varchar(100),
		RegistryID varchar(100)		