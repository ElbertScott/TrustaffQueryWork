USE MarginCalculator

--[192.168.0.9].Trustaff_Med.
--NurseID

INSERT INTO [192.168.0.9].eSig.dbo.Documents
(
	[User_Name]
	,[Form_ID]
	,[Nurse_ID]
	,[Document_Name]
	,[Document]
	,[Document_Hash]
	,[Document_Create]
	,[Signer_IP]
	,[Completed]
	,[ExpDate]
	,[Approved]
	,[Status_ID]
	,[Hospital]
	,[AssignLength]
	,[AssignDate]
	,[StartDate]
	,[CompletionDate]
	,[PrimaryUnit]
	,[RequiredToFloat]
	,[WeekStart]
	,[WeekEnd]
	,[BasePay]
	,[PerDiemPay]
	,[OverTimePay]
	,[Deduct]
	,[ApprovedBy]
	,[ApprovedOn]
	,[Bonus]
	,[oncallpay]
	,[callbackpay]
	,[facilityreqs]
	,[requestedtimeoff]
	,[guaranteehours]
	,[allinclusivetaxable]
	,[allinclusivehousing]
	,[position]
	,[company_name]
	,[Recruiter]
	,[perdiemhours]
	,[IssueDate]
	,[IssueAuthority]
	,[State]
	,[Interpretation]
	,[MedDesc]
	,[Score]
	,[Source]
	,[Result]
	,[DrugType]
	,[SubjectArea]
	,[Reason]
	,[Cancellation_Date]
	,[Facility_ID]
	,[Extended_From]
	,[Acct_Mgr]
	,[Confirm_Doc]
	,[Confirm_Doc_Hash]
	,[Hours_Guaranteed]
	,[Guaranteed_Type]
	,[State_ID]
	,[Replacement_Needed]
	,[Parent_ID]
	,[Notes]
	,[Cancellation_Status]
	,[Recruiter_dateChange]
	,[Mgr_DateChange]
	,[CaliforniaContract]
	,[BlendedRate]
	,[CaliforniaBasePay]
	,[CaliforniaDTPay]
	,[Unit_ID]
	,[Discipline_ID]
	,[RegularHours]
	,[Voluntary]
	,[BlendedChargeRate]
	,[ChargeRegularRate]
	,[ChargeGreaterThanEight]
	,[ChargeGreaterThanTwelve]
	,[ChargeGreaterThanForty]
	,[OrientationRate]
	,[CallBackGreaterThanEight]
	,[CallBackGreaterThanTwelve]
	,[CallBackGreaterThanForty]
	,[SharesExpensesWithDocument_ID]
	,[MileageRate]
	,[ShowOnCall]
	,[ShowCallBackBefore40]
	,[ShowCallBackAfter8]
	,[ShowCallBackAfter12]
	,[ShowCallBackAfter40]
	,[ShowChargeBefore40]
	,[ShowChargeAfter8]
	,[ShowChargeAfter12]
	,[ShowChargeAfter40]
	,[ShowOrientation]
	,[ShowBlendedRate]
	,[ShowBlendedChargeRate]
	,[IsPerdiem]
	,[IsOpen]
	,[Create_Date]
	,[Created_By]
	,[Assigned_By]
	,[ISPAPER_Contract]
	,[ACTIVE_Contract]
	,[Delete_Doc]
	,[housingSubsidy]
	,[ShiftCancellationPolicy]
	,[HasCancellationFee]
	,[CancellationFee]
	,[CancellationFeeNotes]
	,[Contract_ControlID]
	,[ISAK]
	,[ISNV]
	,[CAUSE]
	,[ContractDocumentTypeID]
	,[ContractAccId]
	,[NewMCMargin]
)
select	can.CandidateEmail as User_Name
		, 182 as FormID
		, canlk.NurseID as Nurse_ID
		, NULL as Document_Name
		, NULL as Document
		, NULL as Document_Hash
		, getdate() as Document_Create
		, NULL as Signer_IP
		, 1 as Completed
		, NULL as ExpDate
		, 0 as Approved
		, 3 as Status_ID
		, f.FacilityName as Hospital
		, p.NumberWeeks as AssignLength
		, cal.CalculatorAssignmentStartDate as AssignDate
		, cal.CalculatorAssignmentStartDate as StartDate
		, cal.CalculatorAssignmentEndDate as CompletionDate
		, js.SpecialtyName as PrimaryUnit
		, cal.RequiredToFloat as RequiredToFloat
		, cal.WorkWeekStartDay as WeekStart
		, cal.WorkWeekEndDay as WeekEnd
		, cal.RegularRate as BasePay
		, cal.PerDiem as PerDiemPay
		, cal.OvertimeRate as OverTimePay
		, 0 as Deduct
		, NULL as ApprovedBy
		, NULL as ApprovedOn
		, cal.CompensationBonus as Bonus
		, cal.OnCallBillRate as oncallpay
		, cal.CallBackBillRate as callbackpay
		, cal.FacilityFloatingClause as facilityreqs
		, cal.RequestedTimeOff as requestedtimeoff
		, p.Guarantee as guaranteehours
		, NULL as allinclusivetaxable
		, NULL as allinclusivehousing
		, p.PositionName as position
		, 'Trustaff Travel Nurses' as company_name
		, CONCAT(r.RecruiterFirstName, ' ',r.RecruiterLastName) as Recruiter
		, cal.PaySpreadPerDiem as perdiemhours
		, NULL as IssueDate
		, NULL as IssueAuthority
		, f.FacilityCity as State
		, NULL as Interpretaion
		, NULL as MedDesc
		, NULL as Score
		, NULL as Source
		, NULL as Result
		, NULL as DrugType
		, NULL as SubjectArea
		, NULL as Reason
		, NULL as Cancellation_Date
		, ef.Facility_ID as Facility_ID
		, 0 as Extended_From
		, p.AccountManager as Acct_Mgr
		, NULL as Confirm_Doc
		, NULL as Confirm_Doc_Hash
		, p.Guarantee as Hours_Guaranteed
		, 'Weekly' as Guarantee_Type
		, s.State_ID as State_ID
		, NULL as Replacement_Needed
		, NULL as Parent_ID
		, NULL as Notes
		, NULL as Cancellation_Status
		, NULL as Recruiter_dateChange
		, NULL as Mgr_DateChange
		, CASE WHEN f.FacilityState = 'CA' THEN 1 ELSE 0 END as CaliforniaContract
		, 0 as BlendedRate
		, cal.CaliforniaFirst8Hours as CaliforniaBasePay
		, 0 as CaliforniaDTPay
		, NULL as Unit_ID
		, 0 as Discipline_ID
		, p.Guarantee as RegularHours
		, NULL as Voluntary
		, 0 as BlendedChargeRate
		, cal.RegularRate as ChargeRegularRate
		, 0 as ChargeGreaterThanEight
		, 0 as ChargeGreaterThanTwelve
		, cal.OvertimeRate as ChargeGreaterThanForty
		, cal.BillOrientation as OrientationRate
		, 0  as CallBackGreaterThanEight
		, 0  as CallBackGreaterThanTwelve
		, cal.callbackpayafter40hours as CallBackGreaterThanForty
		, NULL as SharesExpensesWithDocument_ID
		, 0 as MileageRate
		, 0 as ShowOnCall
		, 0 as ShowCallBackBefore40
		, 0 as ShowCallBackAfter8
		, 0 as ShowCallBackAfter12
		, 0 as ShowCallBackAfter40
		, 0 as ShowChargeBefore40
		, 0 as ShowChargeAfter8
		, 0 as ShowChargeAfter12
		, 0 as ShowChargeAfter40
		, 0 as ShowOrientation
		, 0 as ShowBlendedRate
		, 0 as ShowBlendedChargeRate
		, 0 as IsPerdiem
		, 0 as IsOpen
		, getdate() as Create_Date
		, p.AccountManager as Created_By
		, p.AccountManager as Assigned_By
		, 0 as ISPAPER_Contract
		, 1 as ACTIVE_Contract
		, 0 as Delete_Doc
		, 0 as housingSubsidy
		, cp.CancellationPolicyDescription as ShiftCancellationPolicy
		, 0 as HasCancellationFee
		, 0 as CancellationFee
		, NULL as CancellationFeeNotes
		,(SELECT controlID from [192.168.0.9].esig.dbo.contract_control_codes	--1 = Nursing, 2 = Allied
			where control_code in ( select CASE WHEN js.fk_ProfessionID = 1 and br.Branch_ID = 15 THEN 'CN' 
												WHEN js.fk_ProfessionID = 2 and br.Branch_ID = 15 THEN 'CA'		
												WHEN js.fk_ProfessionID = 1 and br.Branch_ID = 17 THEN 'BN' 
												WHEN js.fk_ProfessionID = 2 and br.Branch_ID = 17 THEN 'BA'
												WHEN js.fk_ProfessionID = 1 and br.Branch_ID = 22 THEN 'DN' 
												WHEN js.fk_ProfessionID = 2 and br.Branch_ID = 22 THEN 'DA'
												WHEN js.fk_ProfessionID = 1 and br.Branch_ID = 23 THEN 'BWN' 
												WHEN js.fk_ProfessionID = 2 and br.Branch_ID = 23 THEN 'BWA'
												WHEN js.fk_ProfessionID = 1 and br.Branch_ID = 24 THEN 'SSN' 
												WHEN js.fk_ProfessionID = 2 and br.Branch_ID = 24 THEN 'SSA'
											END)
		) as Contract_ControlID
		--, NULL as Contract_ControlID
		, 0 as ISAK
		, 0 as ISNV
		, NULL as CAUSE
		, 0 as ContractDocumentTypeID
		, cal.CalculatorID as ContractAccId
		,1 as NewMCMargin
		
from dbo.Calculator cal
join 
(
	select CalculatorIDParent
	from dbo.ContractRequest
	where ContractStatus in ('Executed') --'Draft'
	group by CalculatorIDParent
) as c
	on cal.CalculatorID = c.CalculatorIDParent
left join
(
	select distinct CalculatorIDParent, SubmittalID
	from dbo.Calculator
	where SubmittalID is not null
) as fac
	on cal.CalculatorID = fac.CalculatorIDParent
join dbo.Candidates can on cal.CandidateID = can.CandidateID
join dbo.PositionDetail p on cal.PositionDetailID = p.PositionDetailID
join dbo.Facility f on p.FacilityID = f.FacilityID
join dbo.Recruiter r on cal.RecruiterID = r.RecruiterID
join dbo.CancellationPolicy cp on cal.CancellationPolicyID = cp.CancellationPolicyID
left join [192.168.0.9].Trustaff_Med.dbo.tbl_Gm_facilityLink fl on f.GoldMineID = fl.GMID
left join [192.168.0.9].Trustaff_Med.dbo.CandidateLink canlk on canlk.candidateID = can.CandidateGoldMineID
left join [192.168.0.9].eSig.dbo.Facilities ef on ef.facility_code = '000' + CAST(fl.facility_Code as varchar)
left join [192.168.0.9].eSig.dbo.States s on f.FacilityState = s.ST
left join [192.168.0.9].Trustaff_Med.dbo.Contact1 c1 on can.CandidateGoldMineID = c1.id
left join [192.168.0.9].Trustaff_Med.dbo.UserList ul on SUBSTRING(c1.KEY4,0,9) = SUBSTRING(ul.GM_Username,0,9) 
left join [192.168.0.9].Trustaff_Med.dbo.Branches br on ul.BRANCH_id = br.branch_id
left join [192.168.0.9].Trustaff_Med.dbo.facpackets fp on fac.SubmittalID = fp.FacPacketID
left join [192.168.0.9].Trustaff_Med.dbo.JobSpecialty js on fp.Specialty = js.pk_SpecialtyID



