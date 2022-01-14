USE Trustaff_Med_bucket

select *
from dbo.UserList

update dbo.UserList
set Password = 'welcome'

update dbo.UserList
set User_Email = 'nima.talebi@ctipartners.co'
