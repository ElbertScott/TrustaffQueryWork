USE Trustaff_Med

select ACCOUNTNO, CONTACT, ADDRESS2, CONTSUPREF, recid
from dbo.CONTSUPP
where CONTACT = 'E-mail Address'
and LASTDATE >= '2019-01-01'


select *
from dbo.CONTSUPP
where CONTACT = 'E-mail Address'
and LASTDATE >= '2019-01-01'

SELECT [ID]
      ,[StartDate]
      ,[CreateDate]
      ,[Title]
      ,[Type]
      ,[StatusID]
      ,'' AS [Comment]
      ,[PrivateId]
      ,[SiteId]
      ,'' AS [RawHtml]
      ,[LastUpdated]
      ,'' AS [Description]
      ,[Url]
      ,[City]
      ,[Facility]
      ,[USState]
      ,[DivisionID]
      ,[Shift]
      ,[Duration]
      ,[HotJob]
      ,[Guarantee]
      ,[Rate]
      ,[FacilityGroup]
      ,[Openings]
      ,[DetailDate]
      ,[OverrideStartDate]
      ,[AutoAdd]
FROM [Trustaff_Med].[dbo].[RPAJobListing]