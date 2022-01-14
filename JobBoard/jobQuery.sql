SELECT jr.pk_JobRequestID AS JobId,
	jr.InternalUserGroup,
	rjs.Name AS RegistryName,
	jr.RegistryID,
	jr.MktgPosting,
	c1.COMPANY AS Facility,
	CASE WHEN jr.[MCCity] IS NOT NULL THEN jr.[MCCity] ELSE c1.[CITY] END AS CITY,
	CASE WHEN jr.[MCState] IS NOT NULL THEN jr.[MCState] ELSE c1.[STATE] END AS STATE,
	LEFT(c1.ZIP, 5) AS Zip,
	c1.KEY4,
	REPLACE(js.SpecialtyName,'\t','') AS SpName,
	ISNULL(jset.SettingName, '') AS SettingName,
	jp.ProfessionName AS ProfName,
	jd.DivisionName AS DivName,
	jr.RegistryPrivateID AS RegPrivateId,
	(rjs.Name + jr.RegistryPrivateID) as IdName,
	jstat.StatusName,
	jr.InternalDescription,
	CASE WHEN jr.Guarantee < 36 THEN 36 ELSE jr.Guarantee END AS Guarantee,
	jr.NumOpenings AS NOpenings,
	CASE WHEN fp.Submittals IS NULL THEN 0 ELSE fp.Submittals END AS Submittals,
	CASE WHEN PL.Placements IS NULL THEN 0 ELSE PL.Placements END AS Placements,
	100.00 * (CAST(PL.Placements AS float) / CAST(fp.Submittals AS float)) as SpRatio,
	jr.dateNeeded AS DateNeeded,
	jr.AllInclusivePayRate,
	ISNULL(jr.OvertimePayRate, 0) AS OvertimePayRate,
	ISNULL(jr.TaxAdvPayRateNoTax, 0) AS TaxAdvPayRateNoTaxHourly,
	c1.MERGECODES AS Beds,
	LookupValue_1.ShortDesc AS Shiftt,
	lv.ShortDesc AS Duration,
	ISNULL(jr.TaxAdvPayRateNoTax + jr.TaxAdvPayRateTax, 0) AS Total,
	CASE jr.InternalUserGroup WHEN 2 THEN c2.U_GENER13 WHEN 3 THEN c2.UR_IT ELSE c1.KEY4 END AS AM,
	jr.Salary,
	c1.ADDRESS1,
	c2.UGRADE AS Tier,
	jr.AccuratePay,
	CASE WHEN jr.fk_StatusID = 1 THEN 'Open' WHEN jr.fk_StatusID = 6 THEN 'Hot Job' WHEN jr.fk_StatusID = 9 THEN 'Auto offer' ELSE 'Closed' END AS Status ,
	jr.Shift AS SHIFT ,
	jd.pk_DivisionID ,
	jp.pk_ProfessionID ,
	js.pk_SpecialtyID ,
	jset.pk_SettingID ,
	c1.id ,
	c2.UVMSMSP AS VMS_MSP ,
	CASE WHEN ISNULL(jr.Bill, 0) = 0 THEN RJL.Rate ELSE ISNULL(jr.Bill, 0) END AS BillRate ,
	c1.KEY2 AS FACILITY_STATUS ,
	c2.UHLTHSYS AS HEALTH_SYSTEM ,
	c2.USWATTIER AS SWAT_TIER,
	jr.dateCreated as CreateDate,
	CASE WHEN jr.dateCreated BETWEEN DATEADD(hh, -24, GETDATE()) AND GETDATE() THEN 1 WHEN jr.dateCreated BETWEEN DATEADD(hh, -72, GETDATE()) AND DATEADD(hh, -24, GETDATE()) THEN 2 WHEN jr.dateCreated < DATEADD(hh, -73, GETDATE()) THEN 3 END as Age
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
LEFT JOIN (SELECT fp.RequestID,COUNT(*) as Submittals from dbo.FacPackets fp where 1=1 and fp.RequestDate > GETDATE() - 365 and fp.RequestID is not NULL and fp.SubmitStatus = 414 GROUP BY fp.RequestID) AS FP ON jr.pk_JobRequestID = fp.RequestID
LEFT JOIN (SELECT fp.RequestID, COUNT(*) as Placements from dbo.FacPackets fp WHERE 1=1 AND fp.RequestDate > GETDATE() - 365 AND fp.RequestID is not NULL and fp.SubmitStatus = 578 GROUP BY fp.RequestID) AS PL ON jr.pk_JobRequestID = PL.RequestID
WHERE 1=1
and YEAR(jr.dateUpdated) >= 2021
and (c1.STATE in (SELECT State from dbo.LookUpState) or jr.mcstate in (SELECT State from dbo.LookUpState))
and jr.Shift in (172, 174, 175, 178, 181, 296, 301,173, 174, 176, 177, 179, 180, 297, 301,555)
AND jr.fk_StatusID in (SELECT DISTINCT fk_StatusID from dbo.JobRequests where fk_StatusID NOT IN (1,6,9))
ORDER BY jr.pk_JobRequestID Desc