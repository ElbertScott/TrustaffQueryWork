USE MarginCalculator


select *
from dbo.CalculatorStatus



select  p.Guarantee, c.ResultsGrossMargin, c.BillOvertimeFlatRate , c.OvertimeRate, can.CandidateFullName, r.RecruiterFirstName, r.RecruiterLastName,
		f.FacilityName, c.CalculatorID, c.CalculatorIDParent, c.CalculatorIDSequence, 
		c.SubmittalID, cs.CalculatorStatusDescription, p.*
from dbo.PositionDetail p
join dbo.Calculator c on p.PositionDetailID = c.PositionDetailID
join dbo.Candidates can on c.CandidateID = can.CandidateID
join dbo.Recruiter r on c.RecruiterID = r.RecruiterID
join dbo.Facility f on p.FacilityID = f.FacilityID
join dbo.calculatorstatus cs on c.CalculatorStatusID = cs.CalculatorStatusID
join 
(
	select CalculatorID, CalculatorIDParent
	from 
	(
		select	c1.CalculatorID, cr.CalculatorIDParent
				,ROW_NUMBER() OVER(Partition by cr.CalculatorIDParent order by c1.CalculatorID desc) as Row
		from dbo.ContractRequest  cr
		join dbo.Calculator c1 on cr.CalculatorIDParent = c1.CalculatorIDParent
		--where cr.ContractStatus in ('Executed')   
	) as conreq
	where row = 1
) as cal
	on c.CalculatorID = cal.CalculatorID
where p.Guarantee >= 48
--and c.SubmittalID is not null
--and cs.CalculatorStatusDescription = 'Acceptance'
order by p.PositionDetailID desc



select CalculatorID, CalculatorIDParent
from 
(
	select	c1.CalculatorID, cr.CalculatorIDParent
			,ROW_NUMBER() OVER(Partition by cr.CalculatorIDParent order by c1.CalculatorID desc) as Row
	from dbo.ContractRequest  cr
	join dbo.Calculator c1 on cr.CalculatorIDParent = c1.CalculatorIDParent
	--where cr.ContractStatus in ('Executed')   
) as conreq
where row = 1
