USE MarginCalculator


SELECT CalculatorID, CalculatorIDParent, CreateDate, UpdateDate, CalculatorStatusID, SubmittalID, CandidateID, RecruiterID
FROM [MarginCalculator].[dbo].[Calculator] 
where CalculatorStatusID = 364 
and SubmittalID is null 
and CalculatorSavedDate >= '2021-07-12'
order by CalculatorID desc


select *
from dbo.Template
where TemplateCreateDate >= '2021-07-12'

