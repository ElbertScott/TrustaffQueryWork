USE marginBucket


select *
from dbo.BucketAudit


select ba.*, lv.ShortDesc
from dbo.BucketAudit ba 
join [192.168.0.9].Trustaff_Med.dbo.LookupValue lv on ba.SubmitStatus = lv.LookupValueID
where ba.FacPacketId in
(
	select FacPacketId
	from 
	(
		select FacPacketId, count(*) as Total
		from dbo.BucketAudit
		where SubmitStatus = 411
		and CreateDate >= '2021-12-01'
		group by FacPacketId
		having count(*) > 2
	) as x
)
order by ba.FacPacketId, ba.CreateDate
