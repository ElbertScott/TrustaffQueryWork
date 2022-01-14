USE MarginCalculator

select jr.pk_JobRequestID,
            jr.guarantee,
            lv.ShortDesc as Duration,
            js.SpecialtyName,
            c.id as GoldMineID,
            c.Company as Facility,
            c.ADDRESS1,
            c.CITY,
            SUBSTRING(c.ZIP,1,5) as ZIP,
            c.[STATE],
            CASE ISNULL(jr.Bill, 0) WHEN 0 THEN r.Rate ELSE jr.Bill END as BillRate,
            CAST(fo.OnCallBillRate as decimal) as OnCallBillRate,
            CAST(fo.OtBillRate as decimal)  as OtBillRate,
            jr.dateNeeded as startDate,
            fo.Enddate as Enddate,
            fo.WeekStart as WeekStart,
            fo.WeekEnd as WeekEnd,
            fo.ComplianceDueDate as ComplianceDueDate,
             jr.InternalDescription AS JobNotes,
            fo.FacilityTestinglocation as FacilityTestingLocation,
            fo.FacilityLocation as FacilityLocation,
            c2.UVMSMSP as V_M_services,
            fo.RequestedTimeOff,
            fo.UnitName as PrimaryUnit,
            CASE jr.InternalUserGroup
            WHEN 2 THEN c2.U_GENER13
            WHEN 3 THEN c2.UR_IT
            ELSE c.KEY4
            END AS AccountManager,
            jr.RegistryPrivateID,
            jr.RegistryID,
            jr.BlindJob,
            CASE WHEN jr.Shift = 172 THEN 12
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
            END AS HrShift,
            CASE WHEN jr.Shift = 172 THEN '12 HR AM'
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
            END AS Shift,
			c2.UHLTHSYS AS HEALTH_SYSTEM,  --New
			rjs.Name AS Portal --New
from dbo.jobrequests (nolock) jr
left join dbo.contact1 (nolock) c on jr.fk_ClientID = c.id
left join dbo.CONTACT2 (nolock) c2 on c.ACCOUNTNO = c2.ACCOUNTNO
left join dbo.RPAJobListing (nolock) r on jr.RegistryPrivateID = r.PrivateId AND jr.RegistryID = r.SiteId
LEFT JOIN dbo.RPAJobSite AS rjs WITH (NOLOCK) ON rjs.ID = jr.RegistryID --New
LEFT JOIN dbo.JobSpecialty (nolock) js ON jr.fk_SpecialtyID  = js.pk_SpecialtyID
LEFT JOIN dbo.FacilityOffer (nolock) fo    ON fo.SubmittalID = (select max(FacPacketID) as FacPacketID from dbo.FacPackets (nolock) where RequestID = jr.pk_JobRequestID)
LEFT JOIN dbo.LookupValue (nolock) lv  ON jr.Duration = lv.LookupValueID
where pk_JobRequestID = %s 

