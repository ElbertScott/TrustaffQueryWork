USE [Trustaff_Med]
GO

/****** Object:  View [dbo].[V_Jobboard]    Script Date: 03/08/2021 17:20:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--tru-vweb2:8000/JobBoard.aspx?userid=SFRASER
CREATE VIEW [dbo].[V_Jobboard]
AS
SELECT	jr.pk_JobRequestID
		, jr.InternalUserGroup
		, rjs.Name AS RegistryName
		, jr.RegistryID
		, jr.MktgPosting
		, c1.COMPANY as Facility
		, CASE WHEN jr.[MCCity] IS NOT NULL THEN jr.[MCCity] ELSE c1.[CITY] END AS CITY
		, CASE WHEN jr.[MCState] IS NOT NULL THEN jr.[MCState] ELSE c1.[STATE] END AS STATE
		, LEFT(c1.ZIP, 5) AS Zip
		, c1.KEY4 as AccountManager
		, jr.dateUpdated
		, js.SpecialtyName
		, ISNULL(jset.SettingName, '') AS SettingName
		, jp.ProfessionName
		, jd.DivisionName
		, jr.RegistryPrivateID
		, jstat.StatusName
		, jr.InternalDescription
		, CASE WHEN jr.Guarantee < 36 THEN 36 ELSE jr.Guarantee END AS Guarantee
		, jr.NumOpenings
		, jr.dateNeeded
		, jr.AllInclusivePayRate
		, jr.EstimatedExpenses
		, ISNULL(jr.OvertimePayRate, 0) AS OvertimePayRate
		, CASE WHEN jr.Guarantee < 36 THEN 36 ELSE jr.Guarantee END * ISNULL(jr.TaxAdvPayRateNoTax, 0) AS TaxAdvPayRateNoTax
		, ISNULL(jr.TaxAdvPayRateNoTax, 0) AS TaxAdvPayRateNoTaxHourly
		, ISNULL(jr.TaxAdvPayRateTax, 0) AS TaxAdvPayRateTax
		, c1.MERGECODES AS Beds
		, LookupValue_1.ShortDesc AS Shiftt
		, lv.ShortDesc AS Duration
		, ISNULL(jr.TaxAdvPayRateNoTax + jr.TaxAdvPayRateTax, 0) AS Total
		, CASE jr.InternalUserGroup 
				WHEN 2 THEN c2.U_GENER13 
				WHEN 3 THEN c2.UR_IT 
				ELSE c1.KEY4 
			END AS AM
		, jr.Salary
		, c1.ADDRESS1
		, c2.UGRADE AS Tier
		, jr.AccuratePay
		, CASE WHEN jr.fk_StatusID = 1 THEN 'Open' 
				WHEN jr.fk_StatusID = 6 THEN 'Hot' 
				WHEN jr.fk_StatusID = 9 THEN 'Auto offer' 
				ELSE 'Closed' 
		END AS Status
		, jr.Shift
		, jd.pk_DivisionID
		, jp.pk_ProfessionID
		, js.pk_SpecialtyID
		, jset.pk_SettingID
		, c1.id
		, c2.UVMSMSP AS VMS_MSP
		, CASE WHEN ISNULL(jr.Bill, 0) = 0 THEN RJL.Rate ELSE ISNULL(jr.Bill, 0) END AS BillRate
		, c1.KEY2 AS FACILITY_STATUS
		, c2.UHLTHSYS AS HEALTH_SYSTEM
		, c2.USWATTIER AS SWAT_TIER
FROM dbo.JobDivisions AS jd WITH (NOLOCK) 
JOIN dbo.JobRequests AS jr WITH (NOLOCK) ON jd.pk_DivisionID = jr.fk_DivisionID 
JOIN dbo.JobProfessions AS jp WITH (NOLOCK) ON jr.fk_ProfessionID = jp.pk_ProfessionID 
JOIN dbo.JobSpecialty AS js WITH (NOLOCK) ON jr.fk_SpecialtyID = js.pk_SpecialtyID 
JOIN dbo.JobStatus AS jstat WITH (NOLOCK) ON jr.fk_StatusID = jstat.pk_StatusID 
JOIN dbo.CONTACT1 AS c1 WITH (NOLOCK) ON jr.fk_ClientID = c1.id 
JOIN dbo.CONTACT2 AS c2 WITH (NOLOCK) ON c1.ACCOUNTNO = c2.ACCOUNTNO 
JOIN dbo.LookupValue AS LookupValue_1 WITH (NOLOCK) ON jr.Shift = LookupValue_1.LookupValueID 
JOIN dbo.LookupValue AS lv WITH (NOLOCK) ON jr.Duration = lv.LookupValueID 
LEFT JOIN dbo.JobSetting AS jset WITH (NOLOCK) ON jr.fk_SettingID = jset.pk_SettingID 
LEFT JOIN dbo.RPAJobSite AS rjs WITH (NOLOCK) ON rjs.ID = jr.RegistryID 
LEFT JOIN dbo.RPAJobListing AS RJL WITH (NOLOCK) ON RJL.PrivateId = jr.RegistryPrivateID AND RJL.SiteId = jr.RegistryID
WHERE 1=1
and YEAR(jr.dateUpdated) >= 2021
and jr.fk_StatusID in (1,6,9)
ORDER BY jr.pk_JobRequestID Desc

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[34] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "jd"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 118
               Right = 245
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "jr"
            Begin Extent = 
               Top = 6
               Left = 283
               Bottom = 135
               Right = 503
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "jp"
            Begin Extent = 
               Top = 6
               Left = 541
               Bottom = 135
               Right = 761
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "js"
            Begin Extent = 
               Top = 6
               Left = 799
               Bottom = 135
               Right = 985
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "jstat"
            Begin Extent = 
               Top = 6
               Left = 1023
               Bottom = 101
               Right = 1209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c1"
            Begin Extent = 
               Top = 6
               Left = 1247
               Bottom = 135
               Right = 1433
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c2"
            Begin Extent = 
               Top = 102
               Left = 1023
               Bottom = 231
               Right = 1212
            End
            DisplayFlags = 280
            TopColumn = 0
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_Jobboard'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     End
         Begin Table = "LookupValue_1"
            Begin Extent = 
               Top = 120
               Left = 38
               Bottom = 249
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lv"
            Begin Extent = 
               Top = 138
               Left = 266
               Bottom = 268
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "jset"
            Begin Extent = 
               Top = 138
               Left = 494
               Bottom = 267
               Right = 680
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rjs"
            Begin Extent = 
               Top = 138
               Left = 718
               Bottom = 267
               Right = 904
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RJL"
            Begin Extent = 
               Top = 138
               Left = 1250
               Bottom = 268
               Right = 1432
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 37
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_Jobboard'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_Jobboard'
GO


