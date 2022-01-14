USE AppSecurity

--HJHAVERI to SJHAVERI

select *
from dbo.ADUserGroupList
where SamAccountName = 'SJHAVERI'


Update dbo.ADUserGroupList
set SamAccountName = 'SJHAVERI'
where id = 1107

select *
from dbo.ADUserGroup
where SAMAccountName = 'HJHAVERI'

Update dbo.ADUserGroup
set SAMAccountName = 'SJHAVERI'
where SAMAccountName = 'hjhaveri'
