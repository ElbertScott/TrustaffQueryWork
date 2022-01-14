Use Trustaff_Med


select x.*
from 
(
Select	DISTINCT coalesce(NAO.CandidateID,FMO.CandidateID, CR.CandidateID, PL.CandidateID) as CandidateID,  coalesce(NAO.AccountMgr,FMO.AccountMgr,CR.AccountMgr,PL.AccountMgr) as AccountMgr
		,NAO.NurseAcceptedOffer, FMO.FacilityMadeOffer, CR.CancelledRequest, PL.Placed
from 
(
	SELECT dbo.FacPackets.CandidateID, SUBSTRING(CONTACT1_1.U_KEY4,0,9) as AccountMgr, 1 as 'NurseAcceptedOffer'
	From dbo.FacPackets (nolock)
	JOIN  dbo.CONTACT1 (nolock) ON dbo.FacPackets.FacilityID = dbo.CONTACT1.id 
	Join  dbo.CONTACT1 (nolock) AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id 
	JOIN  dbo.LookupValue (nolock) AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID 
	Join  dbo.UserList (nolock) On CONTACT1_1.U_KEY4 = SUBSTRING(dbo.UserList.GM_Username, 0, 9) 
	JOIN  dbo.JobSpecialty (nolock) ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID 
	WHERE dbo.FacPackets.SubmitStatus = 578 
	AND  dbo.FacPackets.AcctManager IS NULL
	AND  dbo.FacPackets.ClosedDate > GETDATE() - 30
	AND CONTACT1_1.U_KEY4 <> 'SFRASER' --Pass in Account Mgr User Name i.e. JENDRES
	GROUP BY FacPackets.CandidateID,SubmitStatus, SUBSTRING(CONTACT1_1.U_KEY4,0,9)
) as NAO
FULL JOIN
(
	SELECT dbo.FacPackets.CandidateID, SUBSTRING(CONTACT1_1.U_KEY4,0,9) as AccountMgr, 1 as 'FacilityMadeOffer'
	From dbo.FacPackets (nolock)
	JOIN  dbo.CONTACT1 (nolock) ON dbo.FacPackets.FacilityID = dbo.CONTACT1.id 
	Join  dbo.CONTACT1 (nolock) AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id 
	JOIN  dbo.LookupValue (nolock) AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID 
	Join  dbo.UserList (nolock) On CONTACT1_1.U_KEY4 = SUBSTRING(dbo.UserList.GM_Username, 0, 9) 
	JOIN  dbo.JobSpecialty (nolock) ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID 
	WHERE dbo.FacPackets.SubmitStatus = 576 
	AND  dbo.FacPackets.AcctManager IS NULL
	AND  dbo.FacPackets.ClosedDate > GETDATE() - 30
	AND CONTACT1_1.U_KEY4 <> 'SFRASER' --Pass in Account Mgr User Name i.e. JENDRES
	GROUP BY FacPackets.CandidateID,SubmitStatus, SUBSTRING(CONTACT1_1.U_KEY4,0,9)
) as FMO
	ON NAO.CandidateID = FMO.CandidateID
FULL JOIN
(
	SELECT dbo.FacPackets.CandidateID, SUBSTRING(CONTACT1_1.U_KEY4,0,9) as AccountMgr, 1 as 'CancelledRequest'
	From dbo.FacPackets (nolock)
	JOIN  dbo.CONTACT1 (nolock) ON dbo.FacPackets.FacilityID = dbo.CONTACT1.id 
	Join  dbo.CONTACT1 (nolock) AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id 
	JOIN  dbo.LookupValue (nolock) AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID 
	Join  dbo.UserList (nolock) On CONTACT1_1.U_KEY4 = SUBSTRING(dbo.UserList.GM_Username, 0, 9) 
	JOIN  dbo.JobSpecialty (nolock) ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID 
	WHERE dbo.FacPackets.SubmitStatus = 424 
	AND  dbo.FacPackets.AcctManager IS NULL
	AND  dbo.FacPackets.ClosedDate > GETDATE() - 30
	AND CONTACT1_1.U_KEY4 <> 'SFRASER' --Pass in Account Mgr User Name i.e. JENDRES
	GROUP BY FacPackets.CandidateID,SubmitStatus, SUBSTRING(CONTACT1_1.U_KEY4,0,9)
) as CR
	ON NAO.CandidateID = CR.CandidateID
FULL JOIN
(
	SELECT dbo.FacPackets.CandidateID, SUBSTRING(CONTACT1_1.U_KEY4,0,9) as AccountMgr, 1 as 'Placed'
	From dbo.FacPackets (nolock)
	JOIN  dbo.CONTACT1 (nolock) ON dbo.FacPackets.FacilityID = dbo.CONTACT1.id 
	Join  dbo.CONTACT1 (nolock) AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id 
	JOIN  dbo.LookupValue (nolock) AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID 
	Join  dbo.UserList (nolock) On CONTACT1_1.U_KEY4 = SUBSTRING(dbo.UserList.GM_Username, 0, 9) 
	JOIN  dbo.JobSpecialty (nolock) ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID 
	WHERE dbo.FacPackets.SubmitStatus = 554 
	AND  dbo.FacPackets.AcctManager IS NULL
	AND  dbo.FacPackets.ClosedDate > GETDATE() - 30
	AND CONTACT1_1.U_KEY4 <> 'SFRASER' --Pass in Account Mgr User Name i.e. JENDRES
	GROUP BY FacPackets.CandidateID,SubmitStatus, SUBSTRING(CONTACT1_1.U_KEY4,0,9)
) as PL
	ON NAO.CandidateID = PL.CandidateID
) as x
where CandidateID = 17628560


select *
from dbo.FacPackets
where CandidateID = 16340829
order by ClosedDate desc


select *
from dbo.CONTACT1
where id = 17477570


--Jason Lopes - 17361144. DBURLAGA. Facility ID 17477570.  Ronald Reagan UCLA Medical Center. CancelledRequest = 1.  Cancelled Request (424) is red.  Closed date within 30 days 2021-02-18 10:42:10.100.
--Percola Wilson - 16340829. Is not returned in Color Logic sql.  First 424 appears where Closed date = 2020-05-11 13:28:26.657.  red in Old.
--Tamara Crawford - 17592896. KGARRETS. Facility ID 21384. St. Joseph Hospital - Lexington.   Facility Made offer = 1 (Orange).  Cancelled Request = 1 (Red). Closed date within 30 days 2021-02-12 11:49:38.830.
--Jennifer Wilson - 17446491. PTHOMAYE. Facility ID 535112. Methodist Le Bonheur Healthcare - Float Pool. Cancelled Request (424) = 1 (red). Closed date within 30 days 2021-02-08 15:27:06.090
--India Curenton - 17628560. TLAFAZIA. Facility ID 14508. Wayne UNC Healthcare. Cancelled Request (424) = 1 (red). Closed date within 30 days 2021-01-25 11:12:15.247
--Christopher Hansen - 17580146. SJAMES.  Facility ID 9638. Newton Wellesley Hospital.  Cancelled Request (424) = 1 (red). Closed date within 30 days 2021-02-15 18:42:02.823. red in new.
--Gabrielle Glowacki - 17392699.  JALLEN. Facility ID 272. The Finley Hospital. Cancelled Request (424) = 1 (red). Closed date within 30 days 2021-02-19 11:57:43.760. red in new.

