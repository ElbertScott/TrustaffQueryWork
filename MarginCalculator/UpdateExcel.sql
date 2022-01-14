USE MarginCalculator


select *
from dbo.xlsWorkersCompensation

select *
from dbo.WorkersCompensation

Update t
set t.[Percent] = s.[Percent],
	t.UpdateBy = SYSTEM_USER,
	t.Updatedate = GETDATE()
from dbo.WorkersCompensation t
join dbo.xlsWorkersCompensation s on s.State = t.State


select *
from dbo.StateBurden

select *
from dbo.xlsPTOFactor


update t
set t.PTOFactorValue = s.PTOFactorValue,
	t.StateBurdenUpdateBy = SYSTEM_USER,
	t.StateBurdenUpdateDate = GETDATE()
from dbo.StateBurden t
join dbo.xlsPTOFactor s on t.State = s.State

Facility can cancel 1 shift per 30 days. FacilityID = 0.  Add to cancellation Policy table.