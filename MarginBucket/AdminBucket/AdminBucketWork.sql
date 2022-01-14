USE Trustaff_Med

select EsigID, GM_Username, Name, User_Email, Department
from dbo.UserList
where 1=1
and Department = 'Admin'
and Company_ID = 1
and Active = 1


select SubmittalID, CandidateID, AdminRep, DATEADDED
from dbo.ADMINSUBS
where 1=1
and AdminRep = 515 --Pass in Admin Rep ESig ID
and DATEADDED > GETDATE() - 365


select *
from dbo.FacPackets fp
where 1=1
AND fp.RequestDate > GETDATE() - 365
and (fp.FacPacketID NOT IN (select SubmittalID from dbo.ADMINSUBS)
	OR fp.FacPacketID IN (select SubmittalID from dbo.ADMINSUBS where AdminRep = 515 and DATEADDED > GETDATE() - 365))

