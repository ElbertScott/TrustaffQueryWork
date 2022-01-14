--select	pd.JobRequestID, pd.HoursPerShift, pd.Guarantee, pd.ShiftsPerWeek, pd.Guarantee / pd.HoursPerShift
Update pd
set pd.ShiftsPerWeek = pd.Guarantee / pd.HoursPerShift
from dbo.PositionDetail pd
where pd.Guarantee > 0
and pd.HoursPerShift > 0


Update pd
set --pd.HoursPerShift = CAST(jb.HrShift as INT)
	pd.Guarantee = CAST(jb.guarantee as INT)
from dbo.PositionDetail pd
join dbo.JobBoard jb on pd.JobRequestID = jb.pk_JobRequestID
where jb.guarantee <> 'NULL'

