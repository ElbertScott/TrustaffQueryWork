CREATE TABLE [SubmittalPrecheckStatus] (
  [SubmittalPrecheckStatusID] INT IDENTITY(1,1) PRIMARY KEY,
  [SubmittalPrecheckStatusDescription] varchar(20),
  [SubmittalPrecheckStatusInsertDate] DateTime,
  [SubmittalPrecheckStatusInsertBy] varchar(30),
  [SubmittalPrecheckStatusUpdateDate] DateTime,
  [SubmittalPrecheckStatusUpdateBy] varchar(30)
);



CREATE TABLE [SubmittalPrecheck] (
  [SubmittalPreCheckID] INT IDENTITY(1,1) PRIMARY KEY,
  [FacPacketID] INT,
  [SubmittalPrecheckStatusID] INT,
  [IsReturned] bit,
  [InsertDate] DateTime,
  [AssignedDate] DateTime,
  [ResolutionDate] DateTime,
  [SubmittalPrecheckUserID] varchar(100),
  [SubmittalPrecheckRejectNote] varchar(150),
  CONSTRAINT [FK_SubmittalPrecheck.SubmittalPrecheckStatusID]
    FOREIGN KEY ([SubmittalPrecheckStatusID])
      REFERENCES [SubmittalPrecheckStatus]([SubmittalPrecheckStatusID]));

--Insert INTO dbo.SubmittalPrecheck ([FacPacketID],[SubmittalPrecheckStatusID],[IsReturned],[InsertDate],[AssignedDate],[ResolutionDate],[SubmittalPrecheckUserID],[SubmittalPrecheckRejectNote])
--VALUES
--(@facpacketID, NULL, NULL, getdate(), NULL, NULL, NULL)


CREATE TABLE [SubmittalPrecheckRejectReason] (
  [SubmittalPrecheckRejectReasonID] INT IDENTITY(1,1) PRIMARY KEY,
  [SubmittalPrecheckRejectReasonDescription] varchar(30),
  [IsActive] bit,
  [SubmittalPrecheckRejectReasonInsertDate] DateTime,
  [SubmittalPrecheckRejectReasonInsertBy] varchar(30),
  [SubmittalPrecheckRejectReasonUpdateDate] DateTime,
  [SubmittalPrecheckRejectReasonUpdateBy] varchar(30),
);

CREATE TABLE [SubmittalPrecheckReject] (
  [SubmittalPrecheckRejectID] INT IDENTITY(1,1) PRIMARY KEY,
  [SubmittalPreCheckID] INT,
  [SubmittalPrecheckRejectReasonID] INT,
  [SubmittalPrecheckRejectInsertDate] DateTime,
  CONSTRAINT [FK_SubmittalPrecheckReject.SubmittalPreCheckID]
    FOREIGN KEY ([SubmittalPreCheckID])
      REFERENCES [SubmittalPrecheck]([SubmittalPreCheckID]),
  CONSTRAINT [FK_SubmittalPrecheckReject.SubmittalPrecheckRejectReasonID]
    FOREIGN KEY ([SubmittalPrecheckRejectReasonID])
      REFERENCES [SubmittalPrecheckRejectReason]([SubmittalPrecheckRejectReasonID])
);
