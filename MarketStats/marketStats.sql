USE EDW_IGH


select *
from dbo.SourceSystem_D


select *
from dbo.JobProfession_D

select *
from dbo.JobDivision_D


select	JobID
		, VMSSID
		, SourceSystemSID
		, VMSSID
		, FacilitySID
		, JobProfessionSID
		, JobSpecialtySID
		, JobDivisionSID
		, JobStatusSID
		, ShiftSID
		, JobDurationSID
		, JobNumberOpenings
		, JobBillRate
from dbo.Job_F 
where JobCreatedDate >= GETDATE() - 365
order by JobSID desc


select	jf.JobID
		, jf.VMSJobID  
		, sd.SourceSystemName  --SourceSystemSID
		, vd.VMSName  --VMSSID
		, fd.FacilityName  --FacilitySID
		, fd.FacilityAddress1
		, fd.FacilityAddress2
		, fd.FacilityAddress3
		, fd.FacilityCity
		, fd.FacilityState
		, fd.FacilityZip
		, jpd.JobProfessionDescription  --JobProfessionSID
		, jsd.JobSpecialtyDescription  --JobSpecialtySID
		, jdd.JobDivisionDescription  --JobDivisionSID
		, js.JobStatusDescription  --JobStatusSID
		, sfd.ShiftDescription  --ShiftSID
		--, jdud.JobDurationWeeks  --JobDurationSID
		, jf.JobNumberOpenings
		, jf.JobBillRate
		, jf.JobCreatedDate
from dbo.Job_F jf
join dbo.VMS_D vd on jf.VMSSID = vd.VMSID
join dbo.SourceSystem_D sd on jf.SourceSystemSID = sd.SourceSystemSID
join dbo.Facility_D fd on jf.FacilitySID = fd.FacilitySID
join dbo.JobProfession_D jpd on jf.JobProfessionSID = jpd.JobProfessionSID
join dbo.JobSpecialty_D jsd on jf.JobSpecialtySID = jsd.JobSpecialtySID 
join dbo.JobDivision_D jdd on jf.JobDivisionSID = jdd.JobDivisionSID
join dbo.JobStatus_D js on jf.JobStatusSID = js.JobStatusSID
join dbo.Shift_D sfd on jf.ShiftSID = sfd.ShiftSID
--join dbo.JobDuration_D jdud on jf.JobDurationSID = jdud.JobDurationSID
where jf.JobCreatedDate >= GETDATE() - 365
and jf.JobStatusSID <> 5
order by JobSID desc