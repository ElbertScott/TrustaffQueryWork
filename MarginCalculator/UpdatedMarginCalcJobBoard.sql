select	jr.pk_JobRequestID 
		,jr.guarantee 
		,lv.ShortDesc AS Duration 
		,js.SpecialtyName 
		,c.id AS GoldMineID 
		,c.Company as Facility 
		,c.ADDRESS1 
		,c.CITY 
		,SUBSTRING(c.ZIP,1,5) AS ZIP 
		,c.[STATE] 
		,CAST(COALESCE(jr.Bill,r.Rate) AS decimal) as BillRate 
		,NULL as OnCallBillRate  
		,NULL as OtBillRate 
		,NULL as startDate 
		,NULL as Enddate 
		,NULL as WeekStart 
		,NULL as WeekEnd 
		,NULL as ComplianceDueDate 
		,NULL as AcctMgrNotes 
		,NULL as FacilityTestingLocation 
		,NULL as FacilityLocation 
		,c2.UVMSMSP as V_M_services --save to PositionDetails.VMSType, 174
		,NULL as RequestedTimeOff 
		,NULL as UnitName 
		,NULL as AccountManager 

		,CASE	WHEN jr.Shift = 172 THEN 12 --int
				WHEN jr.Shift = 173 THEN 12
				WHEN jr.Shift = 174 THEN 12
				WHEN jr.Shift = 175 THEN 8
				WHEN jr.Shift = 176 THEN 8
				WHEN jr.Shift = 177 THEN 8
				WHEN jr.Shift = 178 THEN 12
				WHEN jr.Shift = 179 THEN 12
				WHEN jr.Shift = 180 THEN 12
				WHEN jr.Shift = 181 THEN 12
				WHEN jr.Shift = 296 THEN 12
				WHEN jr.Shift = 297 THEN 12
				WHEN jr.Shift = 298 THEN 8
				WHEN jr.Shift = 299 THEN 12
				WHEN jr.Shift = 300 THEN 10
		END AS HrShift
		,CASE	WHEN jr.Shift = 172 THEN '12 HR AM' 
				WHEN jr.Shift = 173 THEN '12 HR PM'
				WHEN jr.Shift = 174 THEN '12 HR Rotate'
				WHEN jr.Shift = 175 THEN '8 HR Days'
				WHEN jr.Shift = 176 THEN '8 HR Evenings'
				WHEN jr.Shift = 177 THEN '8 HR Nights'
				WHEN jr.Shift = 178 THEN '11AM - 11PM'
				WHEN jr.Shift = 179 THEN '11PM - 11AM'
				WHEN jr.Shift = 180 THEN '3PM - 3AM'
				WHEN jr.Shift = 181 THEN '3AM - 3PM'
				WHEN jr.Shift = 296 THEN '7a - 7p'
				WHEN jr.Shift = 297 THEN '7p - 7a'
				WHEN jr.Shift = 298 THEN '8 HR'
				WHEN jr.Shift = 299 THEN '12 HR'
				WHEN jr.Shift = 300 THEN '10 HR'
		END AS Shift
		,jr.RegistryPrivateID 
		,jr.RegistryID 
from dbo.jobrequests (nolock) jr
left join dbo.contact1 (nolock) c on jr.fk_ClientID = c.id
left join dbo.CONTACT2 (nolock) c2 on c.ACCOUNTNO = c2.ACCOUNTNO --174
left join dbo.RPAJobListing (nolock) r on jr.RegistryPrivateID = r.PrivateId	AND jr.RegistryID = r.SiteId
LEFT JOIN dbo.JobSpecialty (nolock) js ON jr.fk_SpecialtyID  = js.pk_SpecialtyID	
LEFT JOIN dbo.LookupValue (nolock) lv	ON jr.Duration = lv.LookupValueID
--left JOIN dbo.UserList (nolock) ul on fo.AMID = ul.EsigID --REMOVE
where 1=1
and pk_JobRequestID = 561608
