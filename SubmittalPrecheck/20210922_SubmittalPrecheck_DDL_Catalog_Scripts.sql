INSERT INTO dbo.SubmittalPrecheckStatus
VALUES 
('Approved', getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('Rejected', getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('Returned', getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('Dismiss', getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME())


INSERT INTO dbo.SubmittalPrecheckRejectReason
VALUES 
('Highlights', 1, getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('Questionnaire', 1, getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('Certs', 1, getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('Specialty', 1, getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('License', 1, getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('Employment', 1, getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME()),
('Skills Checklist', 1, getdate(), SUSER_SNAME(), getdate(), SUSER_SNAME())
