USE MarginCalculator


select tc.*, c.CandidateID as GMCandidateID
into #tempCandidates
from
(
	select c.CandidateID, c.CandidateERecruitID, c.CandidateGoldMineID, cl.erecruitid, cl.candidateID as clcandidateID
	--into #tempCandidates
	from dbo.Candidates c
	join [192.168.0.9].Trustaff_Med.dbo.CandidateLink cl on c.CandidateERecruitID = cl.erecruitid
	where cl.candidateID is NOT NULL
) tc
join dbo.Candidates c on c.CandidateGoldMineID = tc.clcandidateID

--drop table #tempCandidates

select *
from #tempCandidates

--Update Candidates table
Update c
set	c.CandidateGoldMineID = c2.clcandidateID
from dbo.Candidates c
join #tempCandidates c2 on c.CandidateERecruitID = c2.erecruitid

--Update Calculator table
Update cal
set cal.CandidateID = c2.CandidateID
from dbo.Calculator cal
join #tempCandidates c2 on cal.CandidateID = c2.GMCandidateID

--delete from Candidates table
delete from dbo.Candidates
where CandidateID in (select GMCandidateID from #tempCandidates where CandidateGoldMineID is NULL)


select c.CandidateERecruitID, c.CandidateGoldMineID, cl.candidateID
from MarginCalculator.dbo.Candidates c
join [192.168.0.9].Trustaff_Med.dbo.CandidateLink cl on c.CandidateERecruitID = cl.eRecruitID
where c.CandidateGoldMineID is NULL
and cl.candidateID is NOT NULL


select c.CandidateGoldMineID, count(*)
from MarginCalculator.dbo.Candidates c
where c.CandidateGoldMineID is NOT NULL
group by c.CandidateGoldMineID
having count(*) > 1
