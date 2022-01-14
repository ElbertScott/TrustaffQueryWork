USE erecruit_TRUSTAFF


select *
from trustaffExtras.[dbo].[V_Requirements_Expiring]

--Expiring Credentials
--May need to add ConfirmedBy and ConfirmedDate
select oreq.[RecordID]
       ,oreq.[AboutTypeID]
       ,oreq.[ReferenceID]
	   --,m.MATCH_ID
       ,oreq.[RequirementID]
	   --,cy.NAME as Facility
	   ,Can.CANDIDATE_ID
	   ,can.FullName AS Candidate_Name
	   ,can.FIRST_NAME
	   ,can.LAST_NAME
	   ,can.EmailOptOut
	   ,can.EmailOptOutDate
	   ,can.PrimaryEmail
	   ,can.PrimaryPhone
	   ,p.POSITION_TITLE
       ,r.[Name] as [RequirementName]
	   ,oreq.[ExpirationDate]
	   ,reqstat.Name AS STATUS
	   ,oreq.ConfirmedDate
	   ,hr_own.FullName AS CANDIDATE_OWNER
	   ,CASE WHEN oreq.[AboutTypeID] = 5 THEN 'Match'
			 WHEN oreq.[AboutTypeID] = 6 THEN 'Candidate'
		END as Target_Type
	   ,Reqt.Name as [RequirementType]
	   ,oreq.[Note] as [RequirementNote]
	   ,pd.PENDING_DESC AS MATCH_STATUS
	   ,hr_pos.FullName AS POSITION_OWNER
from dbo.ObjectRequirements oreq
join [dbo].[Requirements] r on r.[RequirementID] = oreq.[RequirementID]
Join dbo.RequirementTypes Reqt on r.TypeID = Reqt.TypeID
JOIN erecruit_TRUSTAFF.dbo.RequirementStatusDefinitions AS reqstat ON reqstat.StatusID = oreq.StatusID 
join dbo.CANDIDATE can on oreq.ReferenceID = can.CANDIDATE_ID
LEFT JOIN erecruit_TRUSTAFF.dbo.HR_REPRESENTATIVE AS hr_own ON hr_own.UserID = can.OwnerUserID
JOIN erecruit_TRUSTAFF.dbo.Match AS m ON m.MATCH_ID =
                             (SELECT        MAX(MATCH_ID) AS MyMatchID
                               FROM            erecruit_TRUSTAFF.dbo.Match AS m1
                               WHERE        (CANDIDATE_ID = oreq.ReferenceID)) 
LEFT JOIN erecruit_TRUSTAFF.dbo.PENDING_DESC AS pd ON pd.PENDING_STATUS = m.PENDING_STATUS 
LEFT JOIN erecruit_TRUSTAFF.dbo.HR_REPRESENTATIVE AS hr_pos ON hr_pos.UserID = m.PositionOwnerID
LEFT JOIN dbo.POSITION p on m.POSITION_ID = p.POSITION_ID
where oreq.AboutTypeID in (5,6) --5 = Match, 6 = Candidate
and oreq.ExpirationDate is not NULL
and oreq.ExpirationDate between getdate() and DATEADD(dd,31,getdate())
and m.EndedOn is NULL
order by oreq.ExpirationDate desc


--List of Requirement Names
select *
from erecruit_TRUSTAFF.dbo.Requirements
where IsEnabled = 1
order by Name



---filter out Requirement names SAM and OIG and NSOPW

---inclued (active match or upcoming match) or match ended exclude

---add columns - position owner and candidate owner

---list of Requirement names
