USE trustaff_Med


select EsigID, GM_Username, Name, User_Email, Department
from dbo.UserList
where 1=1
and Department = 'Admin'
and Company_ID = 1
and Active = 1
