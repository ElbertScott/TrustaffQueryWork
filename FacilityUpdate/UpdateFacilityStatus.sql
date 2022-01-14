USE erecruit_TRUSTAFF


--1747	Inactive	Active
--1741	Inactive	Active
--2744	Inactive	Do Not Staff


--139	Active
--140	Do Not Staff

select *
from dbo.companystatus

select  StatusID, *
from dbo.COMPANY
where COMPANY_ID in (1747,1741)

update dbo.COMPANY
set StatusID = 139
where COMPANY_ID in (1747,1741)


select  StatusID, *
from dbo.COMPANY
where COMPANY_ID = 2744

update dbo.COMPANY
set StatusID = 140
where COMPANY_ID in (2744)


select StatusID, *
from erecruit_TRUSTAFF.dbo.COMPANY
where COMPANY_ID in (select COMPANY_ID from dbo.xlsFacilityUpdate where UpdatedStatus = 'Active')

update erecruit_TRUSTAFF.dbo.COMPANY
set StatusID = 139
where COMPANY_ID in (select COMPANY_ID from dbo.xlsFacilityUpdate where UpdatedStatus = 'Active')


select StatusID, *
from erecruit_TRUSTAFF.dbo.COMPANY
where COMPANY_ID in (select COMPANY_ID from dbo.xlsFacilityUpdate where UpdatedStatus = 'Do Not Staff')

update erecruit_TRUSTAFF.dbo.COMPANY
set StatusID = 140
where COMPANY_ID in (select COMPANY_ID from dbo.xlsFacilityUpdate where UpdatedStatus = 'Do Not Staff')