USE AppSecurity

--Account Managers
select *
from dbo.ADUserGroupList
where UserName in
(
	'Christopher Ford',  --good
	'Kristi Whitaker', --good
	'David Bethel',  --good
	'Kayce Cox', --good
	'Ashley Walter', --good
	'Sara Wilson, MSN', --good
	'Allison Light', --good
	'Cara Novak', --good
	'Rae Nogueira', --good
	'Jennifer Zerhusen'  --good
)
order by UserName

update dbo.ADUserGroupList
set ADGroup = 'AppAccessAccountManager'
where id = 1180


select *
from dbo.ADUserGroupList
where UserName like '%Wilson%'


--Recruiters:
select *
from dbo.ADUserGroupList
where UserName in
(
	'Tim Erwin', --good
	'Heather Bors', --good
	'Kevin Fultz', --good
	'Stephen James', --good
	'Harry Wittenberg', --good
	'Pamela Thomayer',  --good
	'Katie Dils', --good
	'Richard Rothweiler', --good
	'Jase Simpson', --good
	'Karen Hardy', --good
	'Chuck Logsdon', --good
	'Patrick McGrath', --good
	'Joe Schoepf', --good
	'Jerry Helferich', --good
	'Ryan Slandzicki', --good
	'Sondra Ryle', --good
	'Eric Houseweart', --good
	'Erin Swanson', --good
	'Bobby Timbo', --good
	'Samantha Reeves', --good
	'Kat Warren Schaefer' --good
	
)
order by UserName


update dbo.ADUserGroupList
set ADGroup = 'AppAccessRecruiter'
where id in (1293,1103,1160,1115,1159,1244,1133,1125,1178,1057,1228,1226,1269)


--Recruiters:
select *
from dbo.ADUserGroupList
where UserName in
(
	'Stephen James', --spelling/add
	'Pamela Thomayer',  --spelling/add
	'Chuck Logsdon', --spelling/add
	'Patrick McGrath',   --'Pat McGrath', --add/insert --Patrick McGrath
	'Eric Houseweart' --add
)
order by UserName



--PTRN Manager Approver
select *
from dbo.ADUserGroupList
where UserName in
(
	'Doug Dean',  --Doug
	'Pam Oliver', --PAM	
	'Kathryn Mullins', --KMULLINS
	'Mike Williams', --MWILLIAMS
	'Marc Bonora',  --Did not find in userlist table
	'Kara Schaufert'  --KARA
)

INSERT INTO [dbo].[ADUserGroupList]
([SamAccountName], [UserName], [Email], [EmployeeID], [ADGroup],[DateRefreshed])
VALUES
('doug', 'Doug Dean','doug@trustaff.com',NULL,'PTRN Manager Approver',getdate()),
('pam', 'Pam Oliver','pam@trustaff.com ',NULL,'PTRN Manager Approver',getdate()),
('kmullins', 'Kathryn Mullins','kmullins@trustaff.com',NULL,'PTRN Manager Approver',getdate()),
('mwilliams', 'Mike Williams','mwilliams@trustaff.com',NULL,'PTRN Manager Approver',getdate()),
('kara', 'Kara Schaufert','kara@trustaff.com',NULL,'PTRN Manager Approver',getdate()),
('mbonora', 'Marc Bonora','mbonora@trustaff.com',NULL,'PTRN Manager Approver',getdate())
GO


INSERT INTO [dbo].[ADUserGroupList]
([SamAccountName], [UserName], [Email], [EmployeeID], [ADGroup],[DateRefreshed]) --AppAccessRecruiter
VALUES
('ABROOKS', 'Alec Brooks','abrooks@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('ADONOVAN', 'Adam Donovan','aDonovan@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('BDEWIG', 'Benjamin Dewig','bdewig@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('cschwarz', 'Cody Schwarz','cschwarz@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('DLAURENC', 'Danny Laurence','dlaurence@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('HKLASS', 'Haley Klass','hklass@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('JHORNING', 'Jonathan Horning','jhorning@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('JPIRELA', 'Jorge Pirela','jpirela@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('JPOTEET', 'Jacob Poteet','jpoteet@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('JZOLLER', 'Jamie Zoller','jzoller@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('KALBERS', 'Ken Albers','kalbers@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('KGARRETS', 'Kellie Garretson','kgarretson@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('KRSMITH', 'Kelsey Smith','krsmith@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('KTAYLOR', 'Kelli Taylor','ktaylor@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('MBRETZ', 'Mark Bretz','mbretz@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('PHARRING', 'Phillip Harrington','pharrington@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('RFOURNIE', 'Rylee Fournier','rfournier@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('ROLIVARE', 'Robert Olivarez','rolivarez@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
('WYOTT', 'Wade Yott','wyott@trustaff.com',NULL,'AppAccessRecruiter',getdate())
GO

INSERT INTO [dbo].[ADUserGroupList]
	([SamAccountName],[UserName],[Email] ,[EmployeeID],[ADGroup],[DateRefreshed])
VALUES
	('MROLDAN','Marcos Roldan','mroldan@trustaff.com',NULL,'AppAccessRecruiter',getdate())
	

INSERT INTO [dbo].[ADUserGroupList]
	([SamAccountName],[UserName],[Email] ,[EmployeeID],[ADGroup],[DateRefreshed])
VALUES
	('AHOGE','Angela Hoge','ahoge@trustaff.com',NULL,'AppAccessAccountManager',getdate()),
	('RMESSMER','Rachel Messmer','rmessmer@trustaff.com',NULL,'AppAccessAccountManager',getdate()),
	('VIRWIN','Victoria Irwin','virwin@trustaff.com',NULL,'AppAccessAccountManager',getdate()),
	
	


INSERT INTO [dbo].[ADUserGroupList]
	([SamAccountName],[UserName],[Email] ,[EmployeeID],[ADGroup],[DateRefreshed])
VALUES
	('LBOWEN','Linsey Bowen','lbowen@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
	('NGORMSEN','Nick Gormsen','ngormsen@trustaff.com',NULL,'AppAccessRecruiter',getdate()),
	('WJACKSON','Wesley Jackson','wjackson@trustaff.com',NULL,'AppAccessRecruiter',getdate()),

update dbo.ADUserGroupList
set ADGroup = 'AppAccessRecruiter'
where email = 'rolivarez@trustaff.com'
	

INSERT INTO [dbo].[ADUserGroupList]
	([SamAccountName],[UserName],[Email] ,[EmployeeID],[ADGroup],[DateRefreshed])
VALUES
	('AWILDE','Andrea Wilde','awilde@trustaff.com',NULL,'AppAccessAccountManager',getdate()),


INSERT INTO [dbo].[ADUserGroupList]
	([SamAccountName],[UserName],[Email] ,[EmployeeID],[ADGroup],[DateRefreshed])
VALUES
	('CFLYNN','Cyntia Flynn','cflynn@trustaff.com',NULL,'AppAccessAccountManager',getdate())

Linsey Herald


USE AppSecurity


--rslandzi from active directory in AppSecurity
select *
from dbo.ADUserGroupList
where Email = 'rslandzicki@trustaff.com'

update dbo.ADUserGroupList
set SamAccountName = 'RSLANDZICKI'
where Email = 'rslandzicki@trustaff.com'

select *
from dbo.ADUserGroupList
where Email = 'hblaker@trustaff.com'

update dbo.ADUserGroupList
set SamAccountName = 'HBLAKER'
where Email = 'hblaker@trustaff.com'



