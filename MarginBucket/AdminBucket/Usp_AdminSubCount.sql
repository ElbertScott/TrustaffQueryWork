USE [Trustaff_Med]
GO

/****** Object:  StoredProcedure [dbo].[Usp_AdminSubCount]    Script Date: 04/16/2021 11:03:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE   [dbo].[Usp_AdminSubCount]


(

 @Type INT = 0,
@AdminId  INT = 0 ,
@StartDate  Datetime ,
@EndDate Datetime 
)

AS BEGIN
If @Type = 0 
BEGIN
Select MIn( CONVERT(VARCHAR(10), Ad.dateAdded, 110)) As [Date],Count(SubmittalID) Total , Ul.name as AdminRep From ADMINSUBS Ad
INNER JOIN UserList UL ON UL.EsigID = Ad.AdminRep
--WHERE AdminRep = @AdminId
GROUP By ( CONVERT(VARCHAR(10), Ad.dateAdded, 110)),Name
END
If @Type = 1  -- yestarday
BEGIN
Select MIn( CONVERT(VARCHAR(10), Ad.dateAdded, 110)) As [Date],Count(SubmittalID) Total ,Ul.name as AdminRep From ADMINSUBS Ad
INNER JOIN UserList UL ON UL.EsigID = Ad.AdminRep
WHERE AdminRep = @adminId
AND CONVERT(VARCHAR(10), Ad.dateAdded, 110) = CONVERT(VARCHAR(10), Getdate()-1, 110)
GROUP By ( CONVERT(VARCHAR(10), Ad.dateAdded, 110)),Name
END
If @Type = 2  -- last 30 days
BEGIN
Select 'Last 30 Days' As [Date],Count(SubmittalID) Total ,Ul.name as AdminRep From ADMINSUBS Ad
INNER JOIN UserList UL ON UL.EsigID = Ad.AdminRep
WHERE AdminRep = @adminId
AND CONVERT(VARCHAR(10), Ad.dateAdded, 110) between  CONVERT(VARCHAR(10), Getdate()-30, 110) And CONVERT(VARCHAR(10), Getdate(), 110) 
GROUP By Name
END
If @Type = 3 -- last two weeks
BEGIN
Select Distinct'Last Two Weeks' As [Date],  Count(SubmittalID) Total ,Ul.name as AdminRep From ADMINSUBS Ad
INNER JOIN UserList UL ON UL.EsigID = Ad.AdminRep
WHERE AdminRep = @adminId
AND CONVERT(VARCHAR(10), Ad.dateAdded, 110) >= CONVERT(VARCHAR(10), Getdate()-14, 110)
GROUP By Name
END
If @Type = 4 -- today
BEGIN
Select MIn( CONVERT(VARCHAR(10), Ad.dateAdded, 110)) As [Date],Count(SubmittalID) Total ,Ul.name as AdminRep From ADMINSUBS Ad
INNER JOIN UserList UL ON UL.EsigID = Ad.AdminRep
WHERE AdminRep = @adminId
AND CONVERT(VARCHAR(10), Ad.dateAdded, 110) = CONVERT(VARCHAR(10), Getdate(), 110)
GROUP By ( CONVERT(VARCHAR(10), Ad.dateAdded, 110)),Name
END
If @Type = 5 --by admin and date Range
BEGIN
Select 'Up to date' As [Date],Count(SubmittalID) Total , Ul.name as AdminRep From ADMINSUBS Ad
INNER JOIN UserList UL ON UL.EsigID = Ad.AdminRep
WHERE AdminRep =  @adminId
AND CONVERT(VARCHAR(10), Ad.dateAdded, 110) between  CONVERT(VARCHAR(10), @StartDate, 110) And CONVERT(VARCHAR(10), @EndDate, 110) 
GROUP By Name
END

If @Type = 6 -- YTD
BEGIN
Select MIn( CONVERT(VARCHAR(10), Ad.dateAdded, 110)) As [Date],Count(SubmittalID) Total ,Ul.name as AdminRep From ADMINSUBS Ad
INNER JOIN UserList UL ON UL.EsigID = Ad.AdminRep
WHERE AdminRep = @adminId
AND Year(ad.DATEADDED) =YEAR(Getdate())
GROUP By Name
END

If @Type = 7 
BEGIN
Select 'From: ' + CONVERT(VARCHAR(10), @StartDate, 110) + ' To: ' + CONVERT(VARCHAR(10), @EndDate, 110)  As [Date],Count(SubmittalID) Total , Ul.Name as AdminRep From ADMINSUBS Ad
INNER JOIN UserList UL ON UL.EsigID = Ad.AdminRep
WHERE CONVERT(VARCHAR(10), Ad.dateAdded, 110) between  CONVERT(VARCHAR(10), @StartDate, 110) And CONVERT(VARCHAR(10), @EndDate, 110) 
GROUP By Name
END

END
GO


