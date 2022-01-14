USE [Trustaff_Med]
GO

/****** Object:  StoredProcedure [dbo].[sp_FixGoldMindFacilityIDs]    Script Date: 1/3/2021 11:08:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_FixGoldMindFacilityIDs]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Update dbo.Facility with GoldMind ID's
	Update f
	set f.GoldMineID = l.GMID
	from MarginCalculator.dbo.Facility f
	join 
	(
		select f.FacilityID, f.ERecruitID, lk.GMID
		from MarginCalculator.dbo.Facility f
		join Trustaff_Med.src.tbl_GM_Facilitylink lk on f.ERecruitID = lk.facility_Code
	) as l
	on f.ERecruitID = l.ERecruitID

	--Update Position Detail with updated FacilityID
	update p
	set p.FacilityID = i.FacilityID
	from MarginCalculator.dbo.PositionDetail p
	join 
	(
		select jb.pk_JobRequestID, jb.GoldMineID, f.FacilityID
		from Trustaff_Med.dbo.JobBoard jb
		join MarginCalculator.dbo.Facility f on jb.GoldMineID = f.GoldMineID and f.ERecruitID is not null
	) as i
	on p.JobRequestID = i.pk_JobRequestID

END
GO

