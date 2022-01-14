USE MarginCalculator


INSERT INTO [dbo].[CalculatorEvent] 
([CalculatorEventDescription],[IsDeleted],[CalculatorEventCreateDate],[CalculatorEventCreateBy],[CalculatorEventUpdateDate],[CalculatorEventUpdateBy]) 
VALUES 
('Discretionary Bonus Requested', 0, getdate(),SYSTEM_USER, getdate(), SYSTEM_USER),
('Discretionary Bonus Approved', 0, getdate(),SYSTEM_USER, getdate(), SYSTEM_USER),
('Discretionary Bonus Rejected', 0, getdate(),SYSTEM_USER, getdate(), SYSTEM_USER)