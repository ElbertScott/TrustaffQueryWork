USE [Trustaff_Med]
GO

/****** Object:  StoredProcedure [dbo].[sp_JobRequestHotJobStatusUpdate]    Script Date: 5/26/2021 6:05:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Elbert Scott II
-- Create date: May 2021
-- Description:	Update hot jobs older than 48hrs to
--				open status.
-- =============================================
CREATE PROCEDURE [dbo].[sp_JobRequestHotJobStatusUpdate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update jr with (UPDLOCK, SERIALIZABLE)
	set jr.fk_StatusID = 1  --Open
	from dbo.JobRequests jr 
	WHERE 1=1
	and YEAR(jr.dateUpdated) >= 2021
	and jr.fk_StatusID = 6  --Hot
	and dateCreated < DATEADD(hh, -48, GETDATE())

END
GO


