

select x. * 
from (
		SELECT fp.FacPacketID, C1.COMPANY AS Facility,
                            (select UVMSMSP from CONTACT2 where ACCOUNTNO = c1.ACCOUNTNO) as VMSPortal,
                            (select UHLTHSYS from CONTACT2 where ACCOUNTNO = c1.ACCOUNTNO) as HealthSystem,
                            CASE WHEN JR1.[MCState] IS NOT NULL THEN JR1.[MCState] ELSE c1.[STATE] END AS STATE,
                            (select Ugrade from CONTACT2 where ACCOUNTNO = c1.ACCOUNTNO) as Tier,
                            CASE WHEN(JR1.fk_ProfessionID = '1') AND(JR1.fk_DivisionID = '2')  THEN
                            C1.KEY4 ELSE C1.KEY4 END as AM,JS.SpecialtyName AS Specialty,
                            C2.CONTACT AS Nurse,
                            C2.PHONE1 as NursePhone,
                            (select TOP 1 CONTSUPREF from dbo.CONTSUPP where ACCOUNTNO = C2.ACCOUNTNO and CONTACT = 'E-mail Address' order by recid desc) as NurseEmail,
                            C2.KEY4 AS Recruiter,
							JR1.InternalDescription,
                            FP.RequestID,
                            fp.AssocJobID,
                            FP.RegistryPrivateID as JobID,
                            FP.RequestDate as Submitted,
                            LV.ShortDesc AS SubmitStatus,
                            LV.LookupValueID as statusId,
                            FP.Notes,
                            fp.BillRate,
                            C2.KEY2 as GMStatus,
                            FP.AMNotes,
                            FP.FacilityID,
                            FP.CandidateID,
                            cL.ErecruitId,
                            FP.fired,
                            FP.Cancelled,
                            FP.Highlight,
							--jp.ProfessionName AS ProfName,
                            admin.AdminBucketUserID,
                            admin.IsReturned,
                            admin.InsertDate,
                            admin.AdminBucketID,
							adminage.age,
                            CASE
                            ISNULL(T.CandidateID, 0)
                            WHEN 0 THEN 0 ELSE 1
                            END as SubmittedElse,
                            ISNULL(CN.CandidateiD, 0) as RedFlag,
                            CASE
                            ISNULL(NAO.CandidateID, 0) WHEN 0 THEN 0 ELSE 1
                            END as NurseAcceptedOffer,
                            CASE ISNULL(CNLA.CandidateID, 0) WHEN 0 THEN 0 ELSE 1 END as CandidateNoLongerAvailable
                            FROM dbo.FacPackets(nolock)
                            FP
                            JOIN dbo.CONTACT1(nolock) C1 ON FP.FacilityID = C1.id
                            JOIN dbo.CONTACT1(nolock) C2 ON FP.CandidateID = C2.id
                            LEFT JOIN 
							(
								select FacPacketID,
								IsReturned, InsertDate, AssignedDate, ResolutionDate, AdminBucketID, AdminBucketUserID
								from 
								(
									select AdminBucketID, FacPacketID,
									IsReturned, InsertDate, AssignedDate, ResolutionDate, AdminBucketUserID,
									ROW_NUMBER() OVER(Partition by FacPacketID order by AdminBucketID desc) as row
									from [MCSQLTST01].[MarginBucket].dbo.AdminBucket 
								) as x where row = 1
							) as admin
								on FP.FacPacketID = admin.FacPacketID
							LEFT JOIN 
							(
								select FacPacketID, DATEDIFF(dd,InsertDate, getdate()) as Age
								from 
								(
									select AdminBucketID, FacPacketID, InsertDate,
									ROW_NUMBER() OVER(Partition by FacPacketID order by AdminBucketID) as row
									from [MCSQLTST01].[MarginBucket].dbo.AdminBucket 
								) as x 
								where row = 1
							) as adminage
								on FP.FacPacketID = adminage.FacPacketID	

                            JOIN dbo.LookupValue(nolock) LV ON FP.SubmitStatus = LV.LookupValueID
                            LEFT JOIN dbo.UserList(nolock) UL ON C2.U_KEY4 = UL.GM_Username
                            JOIN dbo.JobSpecialty(nolock) JS ON FP.Specialty = JS.pk_SpecialtyID
                            LEFT JOIN dbo.JobRequests(nolock) as JR1 ON C1.id = JR1.fk_ClientID
                            AND JR1.pk_JobRequestID = FP.requestid
							--JOIN dbo.JobProfessions AS jp (NOLOCK) ON JR1.fk_ProfessionID = jp.pk_ProfessionID
                            LEFT JOIN dbo.CandidateLink  cL  on FP.CandidateID = cL.candidateID
							--JOIN dbo.JobProfessions AS jp WITH (NOLOCK) ON JR1.fk_ProfessionID = jp.pk_ProfessionID
                            LEFT  JOIN
                            (
                            SELECT
                            CONTACT1_1.id, ISNULL(C2.U_GENER13, 'None') as FrontEnd, UL.User_Email as frontEndEmail
                            FROM dbo.CONTACT1 AS CONTACT1_1
                            JOIN dbo.CONTACT2 C2 ON C2.ACCOUNTNO = CONTACT1_1.ACCOUNTNO
                            JOIN dbo.UserList ON SUBSTRING(CONTACT1_1.KEY4, 0, 9) = SUBSTRING(dbo.UserList.GM_Username, 0, 9)
                            JOIN dbo.UserList as UL
                            ON SUBSTRING(c2.U_GENER13, 0, 9) = SUBSTRING(UL.GM_Username, 0, 9)
                            WHERE(C2.U_GENER13 != NULL or U_GENER13 != '') GROUP
                            BY CONTACT1_1.id, C2.U_GENER13, UL.User_Email
                            ) as fe on c2.id = fe.id
                            LEFT JOIN
                            (
                            SELECT
                            dbo.FacPackets.CandidateID FROM dbo.FacPackets
                            JOIN dbo.CONTACT1 ON  dbo.FacPackets.FacilityID = dbo.CONTACT1.id
                            JOIN dbo.CONTACT1 AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id
                            JOIN dbo.LookupValue  AS LookupValue_1  ON  dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID
                            JOIN dbo.UserList ON CONTACT1_1.KEY4 = SUBSTRING(dbo.UserList.GM_Username, 0, 9)
                            JOIN dbo.JobSpecialty ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID
                            WHERE dbo.FacPackets.SubmitStatus IN(576, 578) AND dbo.FacPackets.AcctManager IS NULL
                            AND dbo.FacPackets.ClosedDate > GETDATE() - 7 GROUP BY  FacPackets.CandidateID
                            ) as T  on FP.candidateID = T.CandidateID
                            LEFT JOIN
                            (
                            select distinct x.candidateID
                            from
                            (
                            Select COUNT(Nurse_ID)
                            total, Cancellation_Status, Nurse_ID, candidateID
                            from Esig.dbo.Documents
                            JOIN dbo.candidatelink
                            on CandidateLink.NurseID = Documents.Nurse_ID where Status_ID = 8
                            and Cancellation_Date >= '5/1/2017'
                            AND Cancellation_Status in ('Fired', 'Quit') GROUP BY Cancellation_Status, Nurse_ID, candidateID Having
                            COUNT(Nurse_ID) >= 3 ) as x ) as CN
                            on FP.CandidateID = CN.CandidateID
                            LEFT JOIN
                            (
                            select
                            CandidateID, SubmitStatus
                            from dbo.FacPackets where 1 = 1
                            and SubmitStatus = 578  and ClosedDate > GETDATE() - 7
                            GROUP BY CandidateID, SubmitStatus ) as NAO  on FP.CandidateID = NAO.CandidateID
                            LEFT JOIN(select CandidateID, SubmitStatus
                            from dbo.FacPackets
                            where 1=1
                            and SubmitStatus = 670 and ClosedDate > GETDATE() - 7
                            GROUP BY CandidateID, SubmitStatus) as CNLA
                            on FP.CandidateID = CNLA.CandidateID
                            where 1= 1
                            AND(FP.SubmitStatus in (411,638))
                            AND FP.trustaffCompany_ID != 9
                            AND fp.RequestDate > GETDATE() - 365
                            ) as x where 1 = 1  order by Facility