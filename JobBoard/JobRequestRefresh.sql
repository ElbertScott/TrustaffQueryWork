USE Trustaff_Med


select *
from dbo.JobRequests
where 1=1
and YEAR(dateUpdated) >= 2021
order by  dateCreated desc


select *
from dbo.CONTACT1
where YEAR(LastDATE) >= 2020
