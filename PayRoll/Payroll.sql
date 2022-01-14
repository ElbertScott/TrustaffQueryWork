USE erecruit_Trustaff

select *
from dbo.CANDIDATE_STATUS


select *
from dbo.CANDIDATE
where STATUS_ID in (3,5)  --DNU, Inactive
order by CANDIDATE_ID desc


select *
from dbo.CompanyStatus

select distinct cI.COMPANY_ID, cI.NAME, cI.ADDRESS_LINE1, cI.CITY, cI.POSTAL_CODE, 'Inactive' as Status
				,cA.COMPANY_ID as A_Company_ID, cA.NAME as A_Name, cA.ADDRESS_LINE1 as A_ADDRESS_LINE1, cA.CITY as A_CITY, cA.POSTAL_CODE as A_POSTAL_CODE, cA.Status
from 
(
	select COMPANY_ID, NAME, ADDRESS_LINE1, CITY, POSTAL_CODE, StatusID 
	from dbo.COMPANY
	where StatusID = 147  --Inactive
) as cI
JOIN
(
	select COMPANY_ID, NAME, ADDRESS_LINE1, CITY, POSTAL_CODE, 'Active' as Status
	from dbo.COMPANY
	where StatusID = 139  --Active
) as cA
	on cI.NAME = cA.NAME
	--on cI.ADDRESS_LINE1 = cA.ADDRESS_LINE1 and cI.ADDRESS_LINE1 not in (NULL,'')
order by cI.NAME
