USE MarginCalculator


--16288	220405	576078
select *
from dbo.PositionDetail
where JobRequestID = 576078

select *
from dbo.Calculator
where PositionDetailID = 16288
order by CalculatorID desc



Update dbo.Calculator
set CalculatorStatusID = 361
where CalculatorID = 1708322

Update dbo.Calculator
set CalculatorStatusID = 362
where CalculatorID = 1708329

Update dbo.Calculator
set CalculatorStatusID = 364
where CalculatorID = 1708324



--17333	219014	550966
select *
from dbo.PositionDetail
where JobRequestID = 550966

select *
from dbo.Calculator
where PositionDetailID = 17333

select *
from dbo.CalculatorStatus
where CalculatorStatusID in (361,362,364)

Update dbo.Calculator
set CalculatorStatusID = 361
where CalculatorID = 1708336

Update dbo.Calculator
set CalculatorStatusID = 362
where CalculatorID = 1708338

Update dbo.Calculator
set CalculatorStatusID = 364
where CalculatorID = 1708337

select *
from dbo.PTRNRequest

select *
from dbo.Calculator
where PTRNRequestID is not null
