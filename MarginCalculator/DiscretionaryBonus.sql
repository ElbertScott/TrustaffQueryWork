USE MarginCalculator


alter table dbo.calculator
	add DiscretionaryBonusAmount [decimal](7, 2),
		DiscretionaryBonusReason varchar(100),
		DiscretionaryBonusPayDate [datetime],
		DiscretionaryBonusApproveReject bit,
		DiscretionaryBonusRejectNotes varchar(100)


--Crate a table in Calculator DB to allow for entry of discretionary bonus request.
--Fields:
--Request Number - Job Request Number
--Nurse Name - Candidate Name
--Recruiter - Recruiter
--Start Date - Assignment Start Date
--End Date - - Assignment End Date
--Bonus Type -Discretionary (need to determine other types)  --Discretionary as BonusType
--Bonus Reason - DiscretionaryBonusReason - new field
--Margin% - ResultsGrossMargin
--Bonus Amount - DiscretionaryBonusAmount - new field
--Date to be paid - DiscretionaryBonusPayDate - new field
--Approved/Rejected - DiscretionaryBonusApproveReject - new field
--Notes (if rejected) - DiscretionaryBonusRejectNotes - new field


select	po.JobRequestID, can.CandidateFullName, r.RecruiterFirstName, r.RecruiterLastName
		,ca.CalculatorAssignmentStartDate, ca.CalculatorAssignmentEndDate, 'Discretionary' as BonusType
		,ca.DiscretionaryBonusReason, ca.ResultsGrossMargin, ca.DiscretionaryBonusAmount
		,ca.DiscretionaryBonusPayDate, ca.DiscretionaryBonusApproveReject, ca.DiscretionaryBonusRejectNotes
from dbo.Calculator ca
join dbo.PositionDetail po on ca.PositionDetailID = po.PositionDetailID
join dbo.Candidates can on ca.CandidateID = can.CandidateID
join dbo.Recruiter r on ca.RecruiterID = r.RecruiterID
where ca.DiscretionaryBonusAmount is not null