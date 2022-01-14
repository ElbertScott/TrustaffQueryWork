USE AppSecurity

--Gregg Harris -GHARRIS	Gregg Harris	gharris@trustaff.com --AppAccessAccountManager
--Amanda Allen - amallen@trustaff.com --AppAccessAccountManager
--Brett Bell - bjbell@trustaff.com  --AppAccessRecruiter


select *
from dbo.ADUserGroupList
where UserName in 
(
	'Gregg Harris',
	'Amanda Allen',  
	'Brett Bell'
)

select *
from dbo.ADUserGroupList
where Email = 'gharris@trustaff.com'

--Amanda Allen - amallen@trustaff.com --AppAccessAccountManager
Update dbo.ADUserGroupList
set ADGroup = 'AppAccessAccountManager'
where Email = 'amallen@trustaff.com'

--Brett Bell - bjbell@trustaff.com  --AppAccessRecruiter
Update dbo.ADUserGroupList
set ADGroup = 'AppAccessRecruiter'
where Email = 'bjbell@trustaff.com'


--Gregg Harris -GHARRIS	Gregg Harris	gharris@trustaff.com --AppAccessAccountManager
INSERT INTO [dbo].[ADUserGroupList]
	([SamAccountName],[UserName],[Email] ,[EmployeeID],[ADGroup],[DateRefreshed])
VALUES
	('gharris','Gregg Harris','gharris@trustaff.com',NULL,'AppAccessAccountManager',getdate())

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
