USE MarginCalculator



--ER.Match
ALTER table ER.Match
ADD CONSTRAINT FK_ERMatch_CandidateID FOREIGN KEY (Candidate_ID)     
    REFERENCES ER.Candidate (Candidate_ID)

ALTER table ER.Match
ADD CONSTRAINT FK_ERMatch_PositionID FOREIGN KEY (Position_ID)     
    REFERENCES ER.Position (Position_ID)

ALTER table ER.Match
ADD CONSTRAINT FK_ERMatch_PendingStatus FOREIGN KEY (Pending_Status)
    REFERENCES ER.PENDING_DESC (Pending_Status)

ALTER table ER.Match
ADD CONSTRAINT FK_ERMatch_LastNoteID FOREIGN KEY (LastNoteID)
    REFERENCES ER.NewNotes (NoteID)


--ER.Position
ALTER table ER.Position
ADD CONSTRAINT FK_ERPosition_ContactID FOREIGN KEY (Contact_ID)
    REFERENCES ER.Contact (Contact_ID)

--ER.Contact
ALTER table ER.Contact
ADD CONSTRAINT FK_ERContact_CompanyID FOREIGN KEY (Company_ID)
    REFERENCES ER.Company (Company_ID)

