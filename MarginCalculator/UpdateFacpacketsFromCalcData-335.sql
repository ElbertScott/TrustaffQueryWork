USE MarginCalculator


--SELECT FacPacketID, DateUpdated, TimeOff, Comment, InterviewTime, AssignTerm, BestContact, * 
drop table #tempMC

select *
into #tempMC
from 
(
	select SubmittalID, CalculatorSubmitDate, RequestedTimeOff, 'N/A' as CommentMC, 'N/A' as InterviewTimeMC
			,CONCAT('up to ', CAST(p.NumberWeeks as INT),' weeks') as NumberWeeks, can.CandidatePhone 
			,ROW_NUMBER() OVER (PARTITION by SubmittalID ORDER BY CalculatorIDSequence desc) row_num
	from dbo.Calculator c
	left join dbo.PositionDetail p on c.PositionDetailID = p.PositionDetailID
	left join dbo.Candidates can on c.CandidateID = can.CandidateID
	where SubmittalID is not null
	and c.CalculatorSubmitDate >= '2021-07-12'
) as cat
where 1=1
and row_num = 1


--select FacPacketID, DateUpdated, TimeOff, Comment, InterviewTime, AssignTerm, BestContact,
--		MC.*
BEGIN TRAN

Update p with (UPDLOCK, SERIALIZABLE)
set p.DateUpdated = MC.CalculatorSubmitDate
	,p.TimeOff = MC.RequestedTimeOff
	,p.Comment = MC.CommentMC
	,p.InterviewTime = MC.InterviewTimeMC
	,p.AssignTerm = MC.NumberWeeks
	,p.BestContact = MC.CandidatePhone
from [192.168.0.9].Trustaff_Med.dbo.FacPackets p 
join #tempMC MC on p.FacPacketID = MC.SubmittalID
where p.NewMCMargin = 1
and p.FacPacketID = 648515

COMMIT TRAN
