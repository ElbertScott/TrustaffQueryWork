USE Trustaff_Med
GO


-- =============================================
-- Author:		Elbert Scott II
-- Create date: August 6, 2021
-- Description:	Moves closed jobs older than 365 days
-- from dbo.JobRequests to dbo.JobRequests_Archive.
-- =============================================
CREATE PROCEDURE [dbo].[sp_JobRequests_Archive] 
AS
BEGIN

	SET NOCOUNT ON;

	select pk_JobRequestID
	into #tempOldJobs
	from dbo.JobRequests (nolock)
	where fk_StatusID = 5
	and dateUpdated < getdate() - 365


	insert into dbo.JobRequests_Archive
	select *
	from dbo.JobRequests (nolock)
	where fk_StatusID = 5
	and dateUpdated < getdate() - 365


	delete from dbo.JobRequests
	where pk_JobRequestID in (select pk_JobRequestID from #tempOldJobs)


END
GO


USE Trustaff_Med

--717766 total jobs
--517230 total of jobs to be archived

select count(*)
--into #tempOldJobs
from dbo.JobRequests (nolock)
where fk_StatusID = 5
and dateUpdated < getdate() - 365


select *
from dbo.JobRequests (nolock)
where fk_StatusID in (1,6,9)

select *
into dbo.JobRequests_bak20210807
from dbo.JobRequests

select *
--into #tempOldJobs
from dbo.JobRequests (nolock)
where fk_StatusID = 5
and dateCreated < getdate() - 365


