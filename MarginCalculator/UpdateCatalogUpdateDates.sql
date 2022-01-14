USE MarginCalculator

select *
from dbo.BackgroundChecks

update dbo.BackgroundChecks
set UpdateDate = getdate()

select *
from dbo.CancellationPolicy

update dbo.CancellationPolicy
set CancellationPolicyUpdateDate = getdate()

select *
from dbo.Commission

update dbo.Commission
set UpdateDate = getdate()

select *
from dbo.MedicalInsurance

update dbo.MedicalInsurance
set UpdateDate = getdate()

select *
from dbo.MedicalTesting

update dbo.MedicalTesting
set UpdateDate = getdate()

select *
from PayrollTaxes

update dbo.PayrollTaxes
set UpdateDate = getdate()

select *
from dbo.StateBurden

update dbo.StateBurden
set StateBurdenUpdateDate = getdate()

select *
from dbo.WorkersCompensation

update dbo.WorkersCompensation
set UpdateDate = getdate()







