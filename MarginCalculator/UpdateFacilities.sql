USE MarginCalculator

select tf.*, f.FacilityID as GMFacilityID
into #tempFacility
from 
(
	select f.FacilityID as ERFacilityID, f.ERecruitID, f.GoldMineID, flink.GMID
	from dbo.Facility f
	join [192.168.0.9].Trustaff_Med.dbo.tbl_Gm_facilityLink flink on f.ERecruitID = flink.facility_Code
	where ERecruitID is not null 
	and GoldMineID is null
) as tf
join dbo.Facility f on tf.GMID = f.GoldMineID

select * from #tempFacility

--Update Position Detail with FacilityID = ERFacilityID where equal to GMFacilityID from #tempFacility
update p
set p.FacilityID = ERFacilityID
from dbo.PositionDetail p
join #tempFacility tf on p.FacilityID = tf.GMFacilityID

--Update Facility set GoldMineID = GMID where equal to ERFacilityID from #tempFacility
Update f
set f.GoldMineID = tf.GMID
from dbo.Facility f
join #tempFacility tf on f.FacilityID = tf.ERFacilityID

--Delete from Facility FacilityID = GMFacilityID
delete from Facility 
where FacilityID in (select GMFacilityID from #tempFacility)
