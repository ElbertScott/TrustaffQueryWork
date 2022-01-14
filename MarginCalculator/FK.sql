USE MarginCalculator

--PositionDetail
ALTER table dbo.PositionDetail
ADD CONSTRAINT FK_PositionDetail_FacilityID FOREIGN KEY (FacilityID)     
    REFERENCES [dbo].[Facility] (FacilityID)

--CandidateNote
ALTER table dbo.CandidateNote
ADD CONSTRAINT FK_CandidateNote_CandidateID FOREIGN KEY (CandidateID)     
    REFERENCES [dbo].[Candidates] (CandidateID)

--CandidateSkils
ALTER table dbo.CandidateSkills
ADD CONSTRAINT FK_CandidateSkils_CandidateID FOREIGN KEY (CandidateID)     
    REFERENCES [dbo].[Candidates] (CandidateID)

--Calculator
ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_CalculatorID FOREIGN KEY (CalculatorIDParent)     
    REFERENCES dbo.Calculator (CalculatorID)

ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_PositionDetailID FOREIGN KEY (PositionDetailID)     
    REFERENCES dbo.PositionDetail (PositionDetailID)

ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_TemplateID FOREIGN KEY (TemplateID)     
    REFERENCES dbo.Template (TemplateID)

ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_CandidateID FOREIGN KEY (CandidateID)     
    REFERENCES dbo.Candidates (CandidateID)

ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_RecruiterID FOREIGN KEY (RecruiterID)     
    REFERENCES dbo.Recruiter (RecruiterID)

ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_CalculatorStatusID FOREIGN KEY (CalculatorStatusID)     
    REFERENCES dbo.CalculatorStatus (CalculatorStatusID)

--ALTER table dbo.Calculator
--ADD CONSTRAINT FK_Calculator_VMSRateID FOREIGN KEY (VMSRateID)     
--    REFERENCES dbo.VMSRate (VMSRateID)

ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_PayOvertimeFlatMultiplierID FOREIGN KEY (PayOvertimeFlatMultiplierID)     
    REFERENCES dbo.OvertimeFlatMultiplier (OvertimeFlatMultiplierID)

ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_CalculatorSubmitToID FOREIGN KEY (CalculatorSubmitToID)     
    REFERENCES dbo.CalculatorSubmitTo (CalculatorSubmitTo)

ALTER table dbo.Calculator
ADD CONSTRAINT FK_Calculator_CancellationPolicyID FOREIGN KEY (CancellationPolicyID)     
    REFERENCES dbo.CancellationPolicy (CancellationPolicyID)

--Template
ALTER table dbo.Template
ADD CONSTRAINT FK_Template_RecruiterID FOREIGN KEY (RecruiterID)     
    REFERENCES dbo.Recruiter (RecruiterID)

ALTER table dbo.Template
ADD CONSTRAINT FK_Template_FacilityID FOREIGN KEY (FacilityID)     
    REFERENCES dbo.Facility (FacilityID)

ALTER table dbo.Template
ADD CONSTRAINT FK_Template_VMSRateID FOREIGN KEY (VMSRateID)     
    REFERENCES dbo.VMSRate (VMSRateID)

ALTER table dbo.Template
ADD CONSTRAINT FK_Template_PayOvertimeFlatMultiplierID FOREIGN KEY (PayOvertimeFlatMultiplierID)     
    REFERENCES dbo.OvertimeFlatMultiplier (OvertimeFlatMultiplierID)
