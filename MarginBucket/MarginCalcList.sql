USE MarginCalculator


select	 calc.CalculatorID
		, cal.CalculatorID as CalID
		, calc.CalculatorIDParent
		, cal.PositionDetailID
		, f.FacilityName
		, p.AccountManager as CSM
		, p.PositionName
		, can.CandidateFullName 
		, cstatus.CalculatorStatusDescription as NurseStatus
		, pstatus.PTRNStatusDescription
		, r.RecruiterLastName 
		, p.JobRequestID
		, cal.UpdateDate
		, calnotes.CalculatorNote
		, cal.AMNotes
		, cal.ResultsGrossMargin
		, cal.CalculatorAssignmentStartDate
		, cal.ComplianceDueDate
from 
(
	select CalculatorID, CalculatorIDParent
	from 
	(
		select	c.CalculatorID, c.CalculatorIDParent
				,ROW_NUMBER() OVER(Partition by c.CalculatorIDParent order by c.CalculatorID desc) as Row
		from dbo.Calculator c
		where RecruiterID = 2701  --Pass in Recruiter ID
	) as calcx
	where Row = 1
) as calc
join dbo.Calculator cal on calc.CalculatorID = cal.CalculatorID
join dbo.PositionDetail p on cal.PositionDetailID = p.PositionDetailID
join dbo.Facility f on p.FacilityID = f.FacilityID
join dbo.Candidates can on cal.CandidateID = can.CandidateID
join dbo.Recruiter r on cal.RecruiterID = r.RecruiterID
left join dbo.CalculatorStatus cstatus on cal.CalculatorStatusID = cstatus.CalculatorStatusID
LEFT JOIN
(
	select CalculatorNoteID, CalculatorIDParent, CalculatorNote
	from 
	(
		select	CalculatorNoteID, CalculatorIDParent, CalculatorNote, CalculatorNoteCreateDate
				,ROW_NUMBER() OVER(Partition by cn.CalculatorIDParent order by cn.CalculatorNoteCreateDate desc) as Row
		from dbo.CalculatorNote cn
	) as cnote
	where Row = 1
) as calnotes
	on cal.CalculatorID = calnotes.CalculatorIDParent
LEFT JOIN
(
	select PTRNRequestID, CalculatorParentID, PTRNStatusID, PTRNStatusDescription
	from 
	(
		select	prt.PTRNRequestID, prt.CalculatorParentID, prt.PTRNStatusID, prs.PTRNStatusDescription
				,ROW_NUMBER() OVER(Partition by prt.CalculatorParentID order by prt.PTRNRequestID desc) as Row 
		from dbo.PTRNRequest prt
		join dbo.PTRNStatus prs on prt.PTRNStatusID = prs.PTRNStatusID
	) as ptrn
	where Row = 1
) as pstatus
	on cal.CalculatorIDParent = pstatus.CalculatorParentID

