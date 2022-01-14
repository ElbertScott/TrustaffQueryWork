USE Trustaff_Med

--Setting
SELECT SettingName, pk_SettingID 
FROM JobSetting 
WHERE Active = 1 
and SettingName IS NOT NULL


--Registry/Portal
select distinct ID, name as RegistryName 
from RPAJobSite 
WHERE ID NOT IN (4,3,5,7,8,9,13,14,15,18,19,22,23,24,25,38,45,46,51) 
order by RegistryName


--VMS
select distinct UVMSMSP as VMS
from dbo.CONTACT2
where UVMSMSP is NOT NULL
and len(UVMSMSP) > 1
order by UVMSMSP

SELECT ENTRY as VMS_MSP 
FROM dbo.LOOKUP 
where FIELDNAME = 'UVMSMSP   V' 
AND ENTRY NOT IN ('OH Hospital Association','RN Allied Specialty','RTG Staffing','Agile','Symbio','AZ Hospital Association (AZHA)','PPR Healthcare') 
order by 1


--Facility
select distinct c1.id, c1.COMPANY
from dbo.CONTACT1 c1
where KEY1 = 'Facility'
and KEY2 = 'Facility Active'
and KEY4 <> 'UNASSIGNED'
and COMPANY is not null
and LEN(COMPANY) > 1 
order by c1.COMPANY

SELECT DISTINCT CONTACT1.COMPANY AS FACILITY, CONTACT1.ID as FACILITYID 
FROM CONTACT1 
JOIN JobRequests ON CONTACT1.ID = JobRequests.fk_ClientID 
WHERE JobRequests.fk_StatusID IN (1, 6,9) 
ORDER BY CONTACT1.COMPANY

--State
select distinct MCState
from dbo.JobRequests
order by MCState

select [state] as 'State', [state] + ' - ' + [statedesc] as 'Description' 
from [LookupState] order by statedesc


--Division
select pk_DivisionID, DivisionName
from dbo.JobDivisions
order by DivisionName


--JobProfessions --Pass in Division ID based on selection from Division Drop down menu.
select pk_ProfessionID, ProfessionName
from dbo.JobProfessions
where pk_ProfessionID in (select ProfessionID from dbo.RPAiDPSMap where DivisionID = 1)  
order by ProfessionName


--JobSpecialty --pass professionID based on selection from Profession drop down.
select pk_SpecialtyID, SpecialtyName
from dbo.JobSpecialty
where Active = 1
and pk_SpecialtyID in (select SpecialtyID from dbo.RPAiDPSMap where ProfessionID = 1)  
order by SpecialtyName


select *
from dbo.LookupValue
order by GroupName


--Account Manager
SELECT DISTINCT  CONTACT1.Key4  AS AcctManager 
FROM CONTACT1 
JOIN JobRequests ON CONTACT1.ID = JobRequests.fk_ClientID  
ORDER BY CONTACT1.Key4
