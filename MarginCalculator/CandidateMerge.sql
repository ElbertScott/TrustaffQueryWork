USE MarginCalculator

select *
from dbo.Candidates
where CandidateERecruitID = 40051
17718002


DECLARE @CandidateDelete INT = 177074
DECLARE @CandidateKeep INT = 177181

update dbo.Calculator
set CandidateID = @CandidateKeep
where CandidateID = @CandidateDelete

delete from dbo.Candidates
where CandidateID = @CandidateDelete

