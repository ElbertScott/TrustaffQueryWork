USE [Trustaff_Med]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAMBucket]    Script Date: 02/03/2021 15:33:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_GetAMBucket]
(
   @AccountManager   VARCHAR(255)
)

AS 
BEGIN

Select COUNT(Nurse_ID) total,Cancellation_Status,Nurse_ID,candidateID 
INTO #CANCELLED from Esig.dbo.Documents
INNER JOIN Trustaff_MEd.dbo.candidatelink on CandidateLink.NurseID = Documents.Nurse_ID
 where Status_ID =8 
and Cancellation_Date >='5/1/2017'
AND Cancellation_Status in ('Fired','Quit')
GROUP BY Cancellation_Status ,Nurse_ID,candidateID
Having COUNT(Nurse_ID) >=3
Order by  candidateid DESC

(SELECT dbo.FacPackets.CandidateID
INTO #TEMP FROM  dbo.FacPackets 
INNER JOIN  dbo.CONTACT1 ON dbo.FacPackets.FacilityID = dbo.CONTACT1.id 
INNER JOIN  dbo.CONTACT1 AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id 
INNER JOIN  dbo.LookupValue AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID 
INNER JOIN  dbo.UserList ON CONTACT1_1.KEY4 = SUBSTRING(dbo.UserList.GM_Username,0,9)
INNER JOIN  dbo.JobSpecialty ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID 
WHERE(dbo.FacPackets.SubmitStatus IN (576,578) 
AND  (dbo.FacPackets.AcctManager IS NULL) 
AND  (dbo.FacPackets.ClosedDate > GETDATE() - 1))GROUP BY FacPackets.CandidateID)

(SELECT CONTACT1_1.id ,ISNULL(C2.U_GENER13,'None') as FrontEnd,UL.User_Email as frontEndEmail
INTO #FrontEnd 
FROM  dbo.CONTACT1 AS CONTACT1_1
INNER JOIN dbo.CONTACT2 C2 ON C2.ACCOUNTNO = CONTACT1_1.ACCOUNTNO
INNER JOIN  dbo.UserList ON SUBSTRING(CONTACT1_1.KEY4,0,9) = SUBSTRING(dbo.UserList.GM_Username,0,9)
INNER JOIN  dbo.UserList as UL ON SUBSTRING(c2.U_GENER13,0,9) = SUBSTRING(UL.GM_Username,0,9)
WHERE (C2.U_GENER13 != NULL or U_GENER13 !='')
GROUP BY CONTACT1_1.id,C2.U_GENER13,UL.User_Email)

SELECT     dbo.contact1.COMPANY AS Facility,  contact1.KEY4 AS AM, contact1_1.CONTACT AS Nurse,  contact1_1.KEY4 AS Recruiter, ISNULL(Fe.FrontEnd,'None') as frontEnd, 
                                dbo.FacPackets.RequestDate AS Submitted,dbo.FacPackets.RegistryPrivateID, dbo.FacPackets.Highlight, 
                                dbo.FacPackets.FacPacketID, LookupValue_1.ShortDesc AS SubmitStatus, dbo.FacPackets.Cancelled, 
                                dbo.FacPackets.Fired,  dbo.FacPackets.CandidateID, dbo.FacPackets.RequestID, dbo.FacPackets.AssocJobID, 
                                dbo.FacPackets.Notes, contact1_1.KEY2, dbo.FacPackets.Old,   dbo.FacPackets.ClosedDate, dbo.UserList.Department, 
                                dbo.JobSpecialty.SpecialtyName AS ShortDesc, dbo.FacPackets.DailyUpdate,  dbo.FacPackets.AssistantDate, dbo.FacPackets.AMDate,   
                                dbo.FacPackets.FacilityID, dbo.FacPackets.SubmittalType, dbo.FacPackets.AcctManager ,dbo.FacPackets.AMNotes, 
                                dbo.FacPackets.CaseManage, LookupValue_1.LookupValueId, dbo.FacPackets.SubmitDate, 
                                (select name from userlist where Substring(gm_username,0,9)=SUBSTRING(@AccountManager,0,9)) as usersName, 
                                (select user_email from userlist where Substring(gm_username,0,9)=SUBSTRING(@AccountManager,0,9)) as actMgrEmail, 
                                (select user_email from userlist where Substring(gm_username,0,9)=SUBSTRING(contact1_1.KEY4,0,9)) as recEmail, 
                                (select TOP 1 contsupref from CONTSUPP 
                                 where(ACCOUNTNO = contact1_1.ACCOUNTNO)
                                AND CONTACT='E-mail Address' ORDER BY LASTDATE DESC) as nurseEmail,contact1_1.CONTACT AS candidate,
								CASE  ISNULl(T.CandidateID,0) WHEN 0 THEN 0 ELSE 1 END as SubmittedElse,
								ISNULL(fe.FrontEndEmail,'Noreply@trustaff.com')frontEndEmail ,
								(select Ugrade from CONTACT2 where ACCOUNTNO=CONTACT1.ACCOUNTNO) as Tier,
								ISNULL(dbo.facpackets.Billrate,'') As BillRate,
								(select ISNULL(CandidateiD,0) fired from #CANCELLED where candidateID = dbo.FacPackets.CandidateID GROUP BY #CANCELLED.CandidateID) as redflag,
								(select ISNULL(Notes,'') from tbl_ExtensionRequests where SubmittalID = FacPackets.FacPacketID) as extensionNotes
                                FROM  dbo.FacPackets 
                                INNER JOIN  dbo.contact1 ON dbo.FacPackets.FacilityID = dbo.contact1.id 
                                INNER JOIN  dbo.contact1 AS contact1_1 ON dbo.FacPackets.CandidateID = contact1_1.id 
                                INNER JOIN  dbo.LookupValue AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID 
                                INNER JOIN  dbo.UserList ON SUBSTRING(dbo.UserList.GM_Username,0,9)=SUBSTRING(contact1_1.KEY4,0,9) 
                                INNER JOIN  dbo.JobSpecialty ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID
								LEFT JOIN #TEMP T ON T.CandidateID = CONTACT1_1.id
								left JOin #FrontEnd fe on fe.id = contact1_1.id   
                                WHERE SUBSTRING(contact1.KEY4,0,9)= SUBSTRING(@AccountManager,0,9) AND    
                                (dbo.FacPackets.SubmitStatus IN (411,414,423,426,567,568,576,579,601,602,619,623,638) AND (dbo.FacPackets.trustaffCompany_ID != 9)) 
																(411,414,423,426,567,568,576,579,601,602,619,623,638,639)
                                AND  (dbo.FacPackets.RequestDate > GETDATE() - 365) ORDER BY Facility
								DROP TABLE #TEMP,#FrontEnd,#CANCELLED

END

--exec USP_GetAMBucket 'RNOGUEIR'


