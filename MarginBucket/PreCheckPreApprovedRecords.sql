USE Trustaff_Med



INSERT INTO [SQLAZUPROD01].[MarginBucket].[dbo].[SubmittalPrecheck]
(
	[FacPacketID],[SubmittalPrecheckStatusID],[IsReturned],[InsertDate],[AssignedDate],[ResolutionDate],[SubmittalPrecheckUserID],[ApproveReason],[RejectReason]
)
select FacPacketID, 1, 0, getdate(), getdate(), getdate(), 'CTI', 'These records have been PreApproved.', NULL
from dbo.FacPackets f
where SubmitStatus = 411
--and RequestDate > GETDATE() - 365 
and f.FacPacketID not in (
select FacPacketID
from [SQLAZUPROD01].[MarginBucket].[dbo].[SubmittalPrecheck]
)


Update [SQLAZUPROD01].[MarginBucket].[dbo].[SubmittalPrecheck] 
	set SubmittalPrecheckStatusID = 4,
		ResolutionDate = getdate(),
		NLAPOS = 1
where [SQLAZUPROD01].[MarginBucket].[dbo].[SubmittalPrecheck].FacPacketID in
(
	select FacPacketID
	from Trustaff_Med.dbo.FacPackets
	where CandidateID in (select CandidateID from Trustaff_Med.dbo.FacPackets where FacPacketID = 674748) --Pass in FacpacketID Here
)
