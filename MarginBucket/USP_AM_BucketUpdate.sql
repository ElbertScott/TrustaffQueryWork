USE [Trustaff_Med]
GO

/****** Object:  StoredProcedure [dbo].[USP_AM_BucketUpdate]    Script Date: 02/03/2021 16:07:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_AM_BucketUpdate]

(
    @StatusID			INT,
	@PacketID			INT,
	@AmToAdmin	INT
)

AS 

BEGIN 


if @statusID= 426 
	BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets SET SubmitStatus = @StatusID, ClosedDate =GETDATE(),
	        AMDate=GETDATE() ,AmToAdmin=@AmToAdmin WHERE FacPacketID=@PacketID
	END
			
IF @StatusID = 567 
    BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets 
		SET SubmitStatus = @StatusID, 
			ClosedDate =GETDATE(),
			Interview1Date=GETDATE(),
			AmToAdmin=@AmToAdmin 
		WHERE FacPacketID=@PacketID
	END

IF @StatusID = 568
    BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets 
		SET SubmitStatus = @StatusID, 
			ClosedDate =GETDATE(),
			Interview2Date=GETDATE(),
			AmToAdmin=@AmToAdmin 
		WHERE FacPacketID=@PacketID
	END

IF @StatusID = 415 OR @StatusID=423 OR @StatusID =413 OR @StatusID=422 OR @StatusID=414
	BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets 
		SET SubmitStatus = @StatusID, 
			ClosedDate =GETDATE(),
	        AMDate=GETDATE(),
			AmToAdmin=@AmToAdmin 
		WHERE FacPacketID=@PacketID
	END
			
IF @StatusID = 576
    BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets 
			SET SubmitStatus = @StatusID, 
				ClosedDate =GETDATE(),
				OfferDate=GETDATE(),
				AmToAdmin=@AmToAdmin 
		WHERE FacPacketID=@PacketID
	END

IF @StatusID = 577
    BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets 
	    SET SubmitStatus = @StatusID, 
			ClosedDate =GETDATE(),
	        DeclineAcceptDate=GETDATE(),
			AmToAdmin=@AmToAdmin, 
		WHERE FacPacketID=@PacketID
	END
			
IF @StatusID = 597 OR @StatusID =430 OR @StatusID =619 OR @StatusID = 451
    BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets 
	    SET SubmitStatus = @StatusID, 
			ClosedDate =GETDATE(),
	        AssistantDate=GETDATE(),
			AmToAdmin=@AmToAdmin 
		WHERE FacPacketID=@PacketID
	END
			
IF @StatusID = 602 OR @StatusID = 544 OR @StatusID =578
    BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets 
	    SET SubmitStatus = @StatusID, 
			ClosedDate =GETDATE(),
	        DateSubmitted=GETDATE(),
			AmToAdmin=@AmToAdmin 
		WHERE FacPacketID=@PacketID
	END
	Else
	BEGIN
		UPDATE Trustaff_Med.dbo.FacPackets 
	    SET SubmitStatus = @StatusID, 
			ClosedDate=GETDATE(),
			AmToAdmin=@AmToAdmin 
		WHERE FacPacketID=@PacketID
	END
END

GO


