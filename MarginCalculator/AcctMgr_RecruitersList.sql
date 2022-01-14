USE Trustaff_Med


select *
from dbo.UserList
where User_Email = 'rnogueira@trustaff.com'

update dbo.UserList
set Password = 'welcome'
where User_Email = 'rnogueira@trustaff.com'

--Recruiters
select *
from dbo.UserList
where Recruiter = 1
and Active = 1
and Company_ID = 1

select *
from dbo.UserList
where GM_Username = 'sreeves'


--AccountMgr
select *
from dbo.UserList
where ActMgr = 1
and Active = 1
and Company_ID = 1


select *
from dbo.userList
where GM_Username like 'kwhitake%'

select *
from dbo.UserList
where Name = 'Sierra Sapp'
