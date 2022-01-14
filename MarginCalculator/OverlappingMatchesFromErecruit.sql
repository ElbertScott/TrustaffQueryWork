USE erecruit_TRUSTAFF


--select @startdate, @endDate



select CANDIDATE_ID, count(*)
from dbo.Match
group by CANDIDATE_ID
order by count(*) desc


DECLARE @startDate Date = '2021-10-31'
DECLARE @endDate Date = '2022-01-29'

select *
from 
(
	select m.MATCH_ID, c.NAME as Facility, p.POSITION_TITLE, m.START_DATE, isnull(m.[CNTR_END_DATE], m.[EstimatedEndDate]) as [EndDate]
	from dbo.Match m
	join dbo.POSITION p on m.POSITION_ID = p.POSITION_ID
	join dbo.COMPANY c on p.COMPANY_ID = c.COMPANY_ID
	where CANDIDATE_ID = 386  --Pass in Candidate ID
	--order by START_DATE desc
) as x
where (x.START_DATE = @startDate AND x.EndDate = @endDate)
OR
(x.START_DATE > @startDate AND x.EndDate < @endDate)
OR
(x.START_DATE >= @startDate AND x.EndDate < @endDate)
OR
(x.START_DATE >= @startDate AND x.EndDate > @endDate)
OR
(x.START_DATE < @startDate AND x.EndDate > @endDate)


