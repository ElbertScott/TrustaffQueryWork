USE MarginCalculator


select *
from dbo.Candidates
where 1=1 
--and CandidateID between 1 and 11810
order by CandidateID

Update dbo.Candidates
set CandidateLastName = 'Adams'
where CandidateID between 1 and 11810

Update dbo.Candidates
set CandidateLastName = 'Brown'
where CandidateID between 11811 and 21812

Update dbo.Candidates
set CandidateLastName = 'Garcia'
where CandidateID between 21813 and 31817

Update dbo.Candidates
set CandidateLastName = 'Smith'
where CandidateID > 31817


update dbo.Candidates
set CandidateEmail = 'samuel.waissman@ctipartners.co',
	CandidatePhone = '(903) 111-4444',
	CandidateNotes = 'Lorem ipsum dolor sit amet. Donec laoreet tincidunt sollicitudin Mauris. Proin sagittis turpis semper purus. Phasellus ut consectetur mauris mauris. Donec vel ligula eu erat'


select *
from erecruit_TRUSTAFF.dbo.newnotes

update erecruit_TRUSTAFF.dbo.newnotes
set Body = 'Lorem ipsum dolor sit amet. Donec laoreet tincidunt sollicitudin Mauris. Proin sagittis turpis semper purus. Phasellus ut consectetur mauris mauris. Donec vel ligula eu erat'
where NoteID is not null

select *
from MarginCalculator.dbo.CalculatorEvent
where 1=1
and CalculatorEventDescription like '%PTRN%'

update MarginCalculator.dbo.CalculatorEvent
set CalculatorEventDescription = 'Requested IRSPTR'
where CalculatorEventID = 7


select *
from MarginCalculator.dbo.CalculatorStatus


--select CANDIDATE_ID, FIRST_NAME, LAST_NAME, s.CandidateERecruitID, s.CandidateFirstName, s.CandidateLastName
update c
set LAST_NAME = s.CandidateLastName
from erecruit_TRUSTAFF.dbo.CANDIDATE c
join MarginCalculator.dbo.Candidates s on c.CANDIDATE_ID = s.CandidateERecruitID


select *
from erecruit_TRUSTAFF.dbo.Match

update erecruit_TRUSTAFF.dbo.Match
set EndReasonComment = 'Lorem ipsum dolor sit amet.'
where EndReasonComment is not null



select *
from MarginCalculator.dbo.Recruiter

update MarginCalculator.dbo.Recruiter
set RecruiterEmail = 'samuel.waissman@ctipartners.co'
