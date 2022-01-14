USE MarginBucket



select sp.FacPacketID, LV.ShortDesc AS SubmitStatus, sp.SubmittalPrecheckStatusID, sps.SubmittalPrecheckStatusDescription, sp.IsReturned, sp.AssignedDate, sp.ResolutionDate, sp.SubmittalPrecheckUserID
from dbo.SubmittalPrecheck sp
left join dbo.SubmittalPrecheckStatus sps on sp.SubmittalPrecheckStatusID = sps.SubmittalPrecheckStatusID
left join [192.168.0.9].Trustaff_Med.dbo.FacPackets fp on sp.FacPacketID = fp.FacPacketID
left join [192.168.0.9].Trustaff_Med.dbo.LookupValue lv on fp.SubmitStatus = lv.LookupValueID
where sp.SubmittalPrecheckUserID <> 'CTI'


