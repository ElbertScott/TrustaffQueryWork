USE [Trustaff_Med]
GO

/****** Object:  StoredProcedure [dbo].[USP_ADMINBUCKETCA]    Script Date: 04/16/2021 11:01:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_ADMINBUCKETCA]
AS 
BEGIN
Select COUNT(Nurse_ID) total,Cancellation_Status,Nurse_ID,candidateID 
INTO #CANCELLED from Esig.dbo.Documents
INNER JOIN Trustaff_MEd.dbo.candidatelink on CandidateLink.NurseID = Documents.Nurse_ID
 where Status_ID =8 AND Form_ID =182
 AND	CONVERT(VARCHAR(30),Document_Create,111)>= CONVERT(VARCHAR(30),GETDATE()-365,111)
--and Cancellation_Date >='5/1/2017'
AND Cancellation_Status in ('Fired','Quit')
GROUP BY Cancellation_Status ,Nurse_ID,candidateID
Having COUNT(Nurse_ID) >=3
--Order by  candidateid DESC

(SELECT dbo.FacPackets.CandidateID
INTO #TEMP FROM  dbo.FacPackets 
INNER JOIN  dbo.CONTACT1 ON dbo.FacPackets.FacilityID = dbo.CONTACT1.id 
INNER JOIN  dbo.CONTACT1 AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id 
INNER JOIN  dbo.LookupValue AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID 
INNER JOIN  dbo.UserList ON CONTACT1_1.KEY4 = SUBSTRING(dbo.UserList.GM_Username,0,9)
INNER JOIN  dbo.JobSpecialty ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID 
WHERE(dbo.FacPackets.SubmitStatus IN (414,411) 
AND  (dbo.FacPackets.AcctManager IS NULL) 
AND  (dbo.FacPackets.RequestDate > GETDATE() - 1))GROUP BY FacPackets.CandidateID Having COUNT(candidateID)>1)

(SELECT C1.id ,ISNULL(C2.UVMSMSP,'None') + ' - ' + ISNULL(C2.UPORTAL,'None') as VMSPortal
INTO #VMSPORTAL 
FROM  dbo.CONTACT2 AS C2
INNER JOIN dbo.CONTACT1 C1 ON C1.ACCOUNTNO = C2.ACCOUNTNO
WHERE (len(C2.UVMSMSP) >0  ))


SELECT CONTACT1.COMPANY AS Facility,CONTACT1.[STATE], CONTACT1.KEY4 AS AM, CONTACT1_1.CONTACT AS Nurse, 
                CONTACT1_1.KEY4 AS Recruiter, FacPackets.RequestDate AS Submitted, FacPackets.FacPacketID, 
                DATEDIFF(Minute, GETDATE(), FacPackets.RequestDate) AS ElaspeTime, LookupValue_1.ShortDesc AS SubmitStatus, 
                FacPackets.Cancelled, FacPackets.Fired, FacPackets.CandidateID, FacPackets.RequestID, FacPackets.AssocJobID,
				Case FacPackets.RegistryPrivateID WHEN '' Then jr.RegistryPrivateID else
                 FacPackets.RegistryPrivateID end  as RegistryPrivateID ,FacPackets.Notes, CONTACT1_1.KEY2, JobSpecialty.SpecialtyName AS ShortDesc,
                 ISNULL(JR.InternalDescription,'See job notes')InternalDescription,
                (select Ugrade from CONTACT2 where ACCOUNTNO=CONTACT1.ACCOUNTNO) as Tier,ISNULL(dbo.Facpackets.BillRate,'') As BillRate,
				(select ISNULL(CandidateiD,0) fired from #CANCELLED where candidateID = dbo.FacPackets.CandidateID GROUP BY #CANCELLED.CandidateID) as redflag,
				CASE  ISNULl(SE.CandidateID,0) WHEN 0 THEN 0 ELSE 1 END as SubmittedElse,
				ISNULL(VMS.VMSPortal,'None') as VMS,CONTACT1.ADDRESS1,CONTACT1.CITY,CONTACT1.ZIP,FacPackets.AmToAdmin,
				(select ISNULL(UHLTHSYS,'') from CONTACT2 where ACCOUNTNO=CONTACT1.ACCOUNTNO) as USNDINVTO,ISNULL(Jr.fk_StatusID,0) as JobStatus
                 FROM FacPackets INNER JOIN CONTACT1 ON FacPackets.FacilityID = CONTACT1.id 
                 INNER JOIN CONTACT1 AS CONTACT1_1 ON FacPackets.CandidateID = CONTACT1_1.id
				 LEFT JOIN #TEMP SE ON SE.CandidateID = CONTACT1_1.id 
				 LEFT JOIN #VMSPORTAL VMS ON VMS.id = FacPackets.FacilityID
                 INNER JOIN LookupValue AS LookupValue_1 ON FacPackets.SubmitStatus = LookupValue_1.LookupValueID
                  INNER JOIN JobSpecialty ON FacPackets.Specialty = JobSpecialty.pk_SpecialtyID 
                   INNER JOIN userlist ul on contact1_1.key4 = SUBSTRING(ul.GM_Username,0,9)
                   left JOIN userlistBranch ulb on ul.EsigId = ulb.EsigId
                LEFT JOIN JobRequests JR ON JR.pk_JobRequestID = FacPackets.RequestID
                  WHERE  (FacPackets.AcctManager IS NULL)  and (ulb.branch_Id In(17, 15,22) or ulb.Branch_ID is null) AND (FacPackets.SubmitStatus = 411) OR 
                  (FacPackets.SubmitStatus = 415) OR (FacPackets.SubmitStatus = 496) ORDER BY Facility
				  DROP TABLE #CANCELLED,#TEMP,#VMSPORTAL
				  END


GO


