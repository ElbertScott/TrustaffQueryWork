Imports System.Data.SqlClient
Imports System.Net.Mail
Imports Crypto

Public Class TravelSubmittal
    Inherits System.Web.UI.Page
    Dim recEmail As String = String.Empty
    Private FrontEnds As String = String.Empty
    Private conn As New SqlConnection(My.Resources.Trustaff_Med)
    Private DRHIPPA As Boolean = False
    Private SubCount As Boolean = False
    Public Sub connString_infoMessage(ByVal sender As Object, ByVal e As System.Data.SqlClient.SqlInfoMessageEventArgs)
        testlabel.Text = ("info message event: " & e.Message)
    End Sub
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Try
            Dim submittals As New Submittals
            ' getrecord()
            SqlDataSource1.SelectCommand = "SELECT CONTACT1.COMPANY + ',' + CONTACT1.CITY + ',' + CONTACT1.[STATE] + ', ' + JobSpecialty.SpecialtyName  + ',  '+ ISNULL(RegistryPrivateID,'') AS Job, JobRequests_1.pk_JobRequestID, JobRequests_1.fk_StatusID, CONTACT1.ID, RegistryPrivateID FROM JobRequests AS JobRequests_1 INNER JOIN JobSpecialty ON JobRequests_1.fk_SpecialtyID = JobSpecialty.pk_SpecialtyID INNER JOIN CONTACT1 ON JobRequests_1.fk_ClientID = CONTACT1.ID WHERE (JobRequests_1.fk_StatusID in(1,6)) AND (NOT (CONTACT1.COMPANY + JobSpecialty.SpecialtyName IS NULL)) AND (NOT (CONTACT1.COMPANY + JobSpecialty.SpecialtyName IS NULL)) AND (JobRequests_1.fk_ProfessionID in (1,2,3,4,13,14,18,20,33,12,9))  ORDER BY CONTACT1.COMPANY + JobSpecialty.SpecialtyName"
            ' >> Dynamic fields must be created in Init vs Load or they will not be available on postback
            ' >> Get Submittal Packet for Candidate
            Dim myConnection As New System.Data.SqlClient.SqlConnection(My.Resources.Trustaff_Med)
            Dim sql As String
            sql = "Select PacketID,NewSclForms From SubmittalPacket Where CandidateID =@candidateID"  '" & Request.QueryString("CandidateID") & "'" changed to protect from sql injection
            Dim objCmd As New System.Data.SqlClient.SqlCommand(sql, myConnection)
            Dim objDr As System.Data.SqlClient.SqlDataReader
            With objCmd
                .CommandType = CommandType.Text
                .Parameters.Add(New SqlParameter("@candidateID", SqlDbType.Int)).Value = Request.QueryString("CandidateID")
            End With
            myConnection.Open()
            objDr = objCmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection)
            While objDr.Read()
                TextBox7.Text = objDr("PacketID").ToString
                'Tack new scls on to the end
                scl.Value = scl.Value + "|" + objDr("newSclForms").ToString
            End While
            ' Clean up 
            objDr.Close()
            myConnection.Close()
            ' >> Pull additional candidate info (Nurse, Recruiter, GMStatus)
            Dim Traverlerinfo As New Submittals.TravelerInfo
            Traverlerinfo = submittals.GetTravelerInfo(Request.QueryString("CandidateID"))

            Nurse.Value = Traverlerinfo.Travelername
            recEmail = Traverlerinfo.RecruiterEmail
            FrontEnd.Value = Traverlerinfo.FrontendEmail
            Recruiter.Value = Traverlerinfo.Recruiter
            FrontEnds = Traverlerinfo.FrontEnd
            GMStatus.Value = Traverlerinfo.CandidateStatus
            LabelContact.Text = Traverlerinfo.Travelername
            txtBestContactNumber.Text = Traverlerinfo.PhoneNumber
            Old.Text = Traverlerinfo.AltPhone
            If UCase(GMStatus.Value) = "DO NOT USE" Then
                Response.Redirect("https://esig.trustaff.com/TrustaffPortal/Submittals/NOTFOUND.aspx")
            End If
            ' >> Generate Dynamic SCL fields based on SCLs completed by Candidate   --James Pazolt	LBURWELL	Can. Lead	lburwell@trustaff.com
            '    No longer uses Submittal Packet for this information since SCLs can change.
            GenerateDynamicSCLfields()
        Catch ex As Exception
            testlabel.Visible = True
            testlabel.Text = "AN UNEXPECTED Error HAS OCCURED! " & ex.Message
        End Try
    End Sub
    Public Function getrecord() As Boolean
        Try
            Dim sqlGetrecord As New SqlCommand("usp_DRHIPPA", conn)
            AddHandler conn.InfoMessage, AddressOf connString_infoMessage
            With sqlGetrecord
                .CommandType = CommandType.StoredProcedure
                .Parameters.Add(New SqlParameter("@candidateID", SqlDbType.Int)).Value = Request.QueryString("CandidateID")
            End With
            ' attempt to login
            If (conn.State = ConnectionState.Open) Then
                conn.Close()
            End If
            conn.Open()
            DRHIPPA = sqlGetrecord.ExecuteScalar()
            If DRHIPPA = True Then
                getrecord = True
            Else
                getrecord = False
            End If
        Catch ex As Exception
            testlabel.Visible = True
            testlabel.ForeColor = Drawing.Color.Red
            testlabel.Text = ex.Message
            testlabel.Focus()
            conn.Close()
        Finally
            conn.Close()
        End Try
        Return getrecord
    End Function
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Clips As New ClHelpers()
        Dim Access As String
        Access = Clips.LimitAccess(Request.UserHostAddress())
        If Access = String.Empty Then
            Response.Redirect("google.com")
            Exit Sub
        End If
        getsubcount()

        If Not IsPostBack Then
            Dim Submittal As New Submittals
            Dim DT As New DataTable
            Dim SwatDt As New DataTable
            Try
                ddlProfession.SelectedIndex = 1
                DT = Submittals.GetIncompleteApp(Request.QueryString("CandidateID"))
                If Not IsNothing(DT) Then
                    Dim row As DataRow
                    If DT.Rows.Count > 0 Then
                        For Each row In DT.Rows
                            LbllAppMessage.Text = Facilityoffers.IncompleteErrorMessage() + "<br />"
                            If row.Item("ReferencesIncomplete") = 0 Then
                                LbllAppMessage.Text &= " - Employee references not approved or incomplete!" + "<br />"
                            End If
                            If row.Item("EmpQuestionsNotComplete") = 0 Then
                                LbllAppMessage.Text &= " - Employee questionnaire not approved or incomplete!" + "<br />"
                            End If
                            If row.Item("CertificationNotComplete") = 0 Then
                                LbllAppMessage.Text &= " - Employee Certification not approved or incomplete!" + "<br />"
                            End If
                            If row.Item("WorkHistoryNotComplete") = 0 Then
                                LbllAppMessage.Text &= " - Employee work history not approved or incomplete!" + "<br />"
                            End If
                            If row.Item("EducationNotcomplete") = 0 Then
                                LbllAppMessage.Text &= " - Employee Education history not approved or incomplete!"
                            End If
                            MPEIncompleteApp.Show()
                        Next
                    End If
                End If
                SwatDt = Submittals.GetSwatRecruiters()
                ' BindDropdown(ddlSwat, SwatDt, "Name", "EsigID")
            Catch ex As Exception
                testlabel.Visible = True
                testlabel.ForeColor = Drawing.Color.Red
                testlabel.Text = ex.Message
            Finally
                Dim HippaandDr As Boolean
                HippaandDr = getrecord()
                If HippaandDr = False Then
                    If LbllAppMessage.Text = String.Empty Then
                        LbllAppMessage.Text &= "It looks like that this traveler has not completed the Hippa or the D&R forms or they have expired, please have the candidate update these forms to help speed up the submittal Process."
                    End If
                    LbllAppMessage.Text &= " Also It looks like that this traveler has not completed the Hippa or the D&R forms or they have expired, please have the candidate update these forms to help speed up the submittal Process."
                End If
            End Try
        End If
    End Sub
    Protected Sub ddlProfession_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlProfession.SelectedIndexChanged
        Try
            If ddlProfession.Items(0).Selected Then
                SqlDataSourceSpecialty.SelectCommand = "Select MAX(pk_SpecialtyID) As pk_SpecialtyID, SpecialtyName FROM JobSpecialty WHERE (Active = 1) GROUP BY SpecialtyName ORDER BY SpecialtyName"
            Else
                Dim idList As String = "0"
                For Each item As ListItem In ddlProfession.Items
                    If item.Selected Then
                        idList &= "," & item.Value
                    End If
                Next
                SqlDataSourceSpecialty.SelectCommand = String.Format("Select MAX(pk_SpecialtyID) As pk_SpecialtyID, SpecialtyName FROM JobSpecialty WHERE (fk_ProfessionID In ({0})) And (Active = 1) GROUP BY SpecialtyName ORDER BY SpecialtyName", idList)
            End If
        Catch ex As Exception
            testlabel.Visible = True
            testlabel.Text = "AN UNEXPECTED Error HAS OCCURED In The Select Statement! " & ex.Message
        End Try
    End Sub
    Protected Sub GenerateDynamicSCLfields()
        Try
            Dim submittals As New Submittals
            Dim sclFormsList As String = "|"
            'Dim parameters As SqlParameter() = {New SqlParameter("@CandidateID", Request.QueryString("CandidateID"))}
            Dim dsFormsList As DataSet = submittals.GenerateDynamicSCL(Request.QueryString("CandidateID")) 'ExecuteSprocReturnDataset("getFormListByCandidateID_maxDate", parameters)

            For Each newscl2 As DataRow In dsFormsList.Tables(0).Rows
                phNewSclForms.Controls.Add(New LiteralControl("<tr>"))
                phNewSclForms.Controls.Add(New LiteralControl(String.Format("<td class='style2'>{0}</td>", newscl2("formDisplayName").ToString())))
                phNewSclForms.Controls.Add(New LiteralControl("<td>"))
                'Create the dropdown list.
                Dim ddlScl As New DropDownList()
                ddlScl.ID = "ddlSCL" + newscl2("formID").ToString()
                ddlScl.Items.Add(New ListItem("Yes", newscl2("id").ToString()))
                ddlScl.Items.Add(New ListItem("No", "0"))
                ddlScl.SelectedValue = "1"
                phNewSclForms.Controls.Add(ddlScl)
                phNewSclForms.Controls.Add(New LiteralControl("</td>"))
                phNewSclForms.Controls.Add(New LiteralControl("</tr>"))
            Next

        Catch ex As Exception
            testlabel.Visible = True
            testlabel.Text = "AN UNEXPECTED Error HAS OCCURED! " & ex.Message
        End Try
    End Sub
    Function emailList(ByVal recruiter As String, ByVal FrontEnd As String) As String
        Dim TSMED As New SqlConnection(My.Resources.Trustaff_Med)
        Dim DT As New DataTable
        Dim BranchID As Integer
        Dim myEmailList As String = String.Empty
        Try
            Dim myQuery As String = "Select  ulb.branch_id from userlist ul inner JOIN userlistBranch ulb On ul.EsigId = ulb.EsigId where  SUBSTRING(ul.GM_Username,0,9)=SUBSTRING(@Recruiter,0,9)"
            Dim sda As New SqlDataAdapter(myQuery, TSMED)
            sda.SelectCommand.CommandType = CommandType.Text
            sda.SelectCommand.Parameters.Add(New SqlParameter("@Recruiter", SqlDbType.VarChar)).Value = recruiter
            TSMED.Open()
            sda.Fill(DT)
            TSMED.Close()
            Select Case DT.Rows.Count
                Case 0
                    DT = Nothing
                Case Is > 0
                    Dim dr As DataRow = DT.Rows(0)
                    BranchID = dr.Field(Of Integer)("branch_id")
            End Select

            Select Case BranchID
                Case 17
                    myEmailList = ",jmierzejewski@trustaff.com,sbaute@trustaff.com,cbaute@trustaff.com," & FrontEnd
                Case Else
                    myEmailList = ",sbaute@trustaff.com,cbaute@trustaff.com," & FrontEnd
            End Select
        Catch ex As Exception
            TSMED.Close()
            testlabel.Visible = True
            testlabel.Text = "AN UNEXPECTED ERROR HAS OCCURED! " & ex.Message
        End Try
        Return myEmailList
    End Function
    Protected Sub BtnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnSave.Click
        Dim submittals As New Submittals
        Dim CandidateSubmittal As New Submittals.CandidateSubmittal
        Try
            If Request.QueryString("CandidateID") = String.Empty Then
                testlabel.Visible = True
                testlabel.Text = "Candidate Unknown Submittal insert failed!"
            Else

                If LabelT.Text = "" And ListBoxSelectJob.SelectedItem Is Nothing Then
                    lblJobError.Visible = True
                    testlabel.Text = "Not Saved, Please select a job."
                    testlabel.ForeColor = Drawing.Color.Red
                    Exit Sub
                Else
                    lblJobError.Visible = False
                End If
                Dim shiftPreference As String
                If ddlShiftPreference.SelectedValue = "Other" Then
                    shiftPreference = txtShiftPreferenceOther.Text
                Else
                    shiftPreference = ddlShiftPreference.SelectedValue
                End If
                Dim facilityInfo As New Submittals.Facility
                facilityInfo.JobID = CInt(ListBoxSelectJob.SelectedValue)
                facilityInfo = submittals.GetFacilityInfo(facilityInfo)
                Facility.Value = facilityInfo.FacilityName
                ActMgr.Value = facilityInfo.AccountManager
                FacilityID.Value = facilityInfo.FacilityID
                Dim myEmailList As String = emailList(Recruiter.Value, FrontEnd.Value)
                Dim jobrequest As New Submittals.Jobrequest
                With jobrequest
                    .JobID = ListBoxSelectJob.SelectedValue
                    .FacilityID = FacilityID.Value
                    .CandidateID = CInt(Request.QueryString("CandidateID"))
                    .SpecialtyID = ddlSpecialty.SelectedValue
                End With
                jobrequest = submittals.GetSubmittalByCandidateID(jobrequest)
                jobrequest.CandidateID = CInt(Request.QueryString("CandidateID"))
                Select Case jobrequest.SubmittalId
                    Case 0
                        If jobrequest.CandidateID = 0 Then
                            testlabel.Visible = True
                            testlabel.Text = "Candidate Unknown Submittal insert failed!"
                        Else
                            Insertsubmittal()
                        End If

                    Case Else
                        LblCatchError.Text = "It looks like you have submitted this traveler to the same facility with the same specialty over the past three days, we suggest you click on Edit submittal button below to edit."
                        MPEShowdupe.Show()
                End Select
            End If
        Catch ex As Exception
            testlabel.Visible = True
            testlabel.Text = "AN UNEXPECTED ERROR HAS OCCURED! " & ex.Message
        End Try
    End Sub
    Protected Sub ddlShiftPreference_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If ddlShiftPreference.SelectedValue = "Other" Then
            txtShiftPreferenceOther.Visible = True
        Else
            txtShiftPreferenceOther.Visible = False
        End If
    End Sub
    Protected Sub ddlTermOfAssignment_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If ddlTermOfAssignment.SelectedValue = "Other" Then
            TermOfAssignmentOther.Visible = True
        Else
            TermOfAssignmentOther.Visible = False
        End If
    End Sub
    Private Function ExecuteSprocReturnDataset(ByVal sproc As String, ByVal parameters As SqlParameter()) As DataSet
        Dim ds As New DataSet()
        Try
            Dim conn As New SqlConnection(My.Resources.Trustaff_Med)
            Dim cmd As New SqlCommand(sproc, conn)
            cmd.CommandType = CommandType.StoredProcedure
            If parameters.Length > 0 Then
                For Each parameter As SqlParameter In parameters
                    cmd.Parameters.Add(parameter)
                Next
            End If
            Dim da As New SqlDataAdapter(cmd)
            'Attempt to retrieve data from the query.
            Try
                conn.Open()
                da.Fill(ds)
            Finally
                conn.Close()
                conn.Dispose()
            End Try
        Catch ex As Exception
            testlabel.Visible = True
            testlabel.Text = "AN UNEXPECTED ERROR HAS OCCURED Function DataSET! " & ex.Message
        End Try
        Return ds
    End Function
    Public Sub getsubcount()
        Try
            '"WHERE KEY4 In('SJAMES','JSHRINER','MBLYTHE','BJBell') " &
            Dim sql As String = "Select Count(FP.CandidateID),CONVERT(VARCHAR(30),FP.RequestDate,111),FP.candidateID from FacPackets FP " &
                 "INNER JOIN CONTACT1 C ON C.id = FP.CandidateID " &
                  "WHERE CONVERT(VARCHAR(30),RequestDate,111) = CONVERT(VARCHAR(30),GETDATE(),111) " &
                  "AND KEY4 In('SJAMES','JSHRINER','MBLYTHE','BJBell') " &
                  "AND Fp.CandidateID = @candidateID " &
                  "GROUP BY CandidateID,CONVERT(VARCHAR(30),RequestDate,111) " &
                  "HAVING COUNT(candidateid) >=12"
            Dim sqlGetrecord As New SqlCommand(sql, conn)
            AddHandler conn.InfoMessage, AddressOf connString_infoMessage
            With sqlGetrecord
                .CommandType = CommandType.Text
                .Parameters.Add(New SqlParameter("@candidateID", SqlDbType.Int)).Value = Request.QueryString("CandidateID")
            End With
            If (conn.State = ConnectionState.Open) Then
                conn.Close()
            End If
            conn.Open()
            SubCount = sqlGetrecord.ExecuteScalar()
            If SubCount = True Then
                Response.Redirect("https://esig.trustaff.com/TrustaffPortal/Submittals/limitted.aspx")
            Else
            End If
        Catch ex As Exception
            conn.Close()
            testlabel.Visible = True
            testlabel.ForeColor = Drawing.Color.Red
            testlabel.Text = ex.Message
            testlabel.Focus()
            conn.Close()
        Finally
            conn.Close()
        End Try
    End Sub
    Protected Sub ListBoxSelectJob_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ListBoxSelectJob.SelectedIndexChanged

    End Sub
    Public Function creditLimit(FacId As Integer) As Submittals.ClientCreditLimit
        Dim FacCreditlimit As New Submittals.ClientCreditLimit
        Dim ClientCredit_Limit As DataTable
        Dim Submittal As New Submittals()


        Try
            Dim strServer As String = ConfigurationManager.AppSettings("Strserver")
            Dim Database As String = ConfigurationManager.AppSettings("Database")
            Dim username As String = ConfigurationManager.AppSettings("Username")
            Dim Password As String = ConfigurationManager.AppSettings("StrPassword")

            Dim Crypto As New clsCrypto.SymmProvEnum()
            Dim CrPTo As New clsCrypto(Crypto)
            Dim Newpassword As String = CrPTo.Encrypt2014(Password)

            Dim GpMethods = New GPMethods.GPMethods(strServer, Database, username, Password)
            Dim facilityCode As String
            Dim id As Integer = CInt(FacilityID.Value)
            facilityCode = Submittal.GetFacilityCode(id)
            Dim ExFacilityCode As String = Submittal.GetExFacilityCode(facilityCode)
            ClientCredit_Limit = GpMethods.GetCustomerOverLimit(ExFacilityCode)
            If ClientCredit_Limit.Rows.Count > 0 Then
                For Each drow As DataRow In ClientCredit_Limit.Rows

                    With FacCreditlimit
                        .CreditLimitAmount = drow.Item("CreditLimitAmount")
                        .CustomerBalance = drow.Item("CustBalance")
                        .CustomerNumber = drow.Item("CustID")
                        .CustomerName = drow.Item("Custname")
                        .CreditLimitType = drow.Item("CreditLimitType")
                        .totalTravelers = .CreditLimitAmount / 10000
                        .facilityTotalNurses = Submittal.GETNurseCOUNT(facilityCode)
                        .erFacilityTotalNurses = Submittal.CountTotalplacementEr(facilityCode)
                    End With

                Next
            Else

            End If
        Catch ex As Exception

        End Try
        Return FacCreditlimit
    End Function
    Private Sub hideFieldset()
        FsCreditCheck.Visible = False
    End Sub
    Protected Sub btnSelectJob_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSelectJob.Click
        Dim Submittals As New Submittals
        Dim FacilityCreditlimit As New Submittals.ClientCreditLimit
        Dim RegistryPrivateID As String = String.Empty
        Try
            LabelT.Text = ListBoxSelectJob.SelectedItem.ToString
            If ListBoxSelectJob.SelectedValue <> "" Then
                RegistryPrivateID = Submittals.GetRegistryIDByJobID(ListBoxSelectJob.SelectedValue)
                If RegistryPrivateID <> String.Empty Then
                    LabelJobID.Text = RegistryPrivateID
                    LabelJobID.Visible = True
                    Label4.Visible = True
                Else
                    LabelJobID.Text = ""
                    LabelJobID.Visible = False
                    Label4.Visible = False
                End If
            End If

            Dim facilityInfo As New Submittals.Facility
            facilityInfo.JobID = CInt(ListBoxSelectJob.SelectedValue)
            facilityInfo = Submittals.GetFacilityInfo(facilityInfo)
            Facility.Value = facilityInfo.FacilityName
            ActMgr.Value = facilityInfo.AccountManager
            FacilityID.Value = facilityInfo.FacilityID

            Dim jobrequest As New Submittals.Jobrequest
            If IsNumeric(ListBoxSelectJob.SelectedValue) Then

                With jobrequest
                    .CandidateID = Request.QueryString("CandidateID")
                    .FacilityID = FacilityID.Value
                    .JobID = CInt(ListBoxSelectJob.SelectedValue)
                End With
                jobrequest = Submittals.GetSubmittalByJobIDANDCandidateID(jobrequest)
                Select Case jobrequest.JobID
                    Case > 0
                        ModalPopupExtender1.Show()
                    Case Else
                        With jobrequest
                            .CandidateID = Request.QueryString("CandidateID")
                            .FacilityID = FacilityID.Value
                            .ResigtryID = RegistryPrivateID
                        End With

                        If RegistryPrivateID <> String.Empty Then
                            jobrequest = Submittals.GetSubmittalByRegistryANDCandidateID(jobrequest)
                            Select Case jobrequest.ResigtryID
                                Case <> String.Empty
                                    ModalPopupExtender1.Show()
                                Case Else
                            End Select
                        End If
                End Select
            Else
                With jobrequest
                    .CandidateID = Request.QueryString("CandidateID")
                    .FacilityID = FacilityID.Value
                    .ResigtryID = RegistryPrivateID
                End With

                If RegistryPrivateID <> String.Empty Then
                    jobrequest = Submittals.GetSubmittalByRegistryANDCandidateID(jobrequest)
                    Select Case jobrequest.ResigtryID
                        Case <> String.Empty
                            ModalPopupExtender1.Show()
                        Case Else
                    End Select
                End If
            End If

            '''''''' Check Credit limit
            FacilityCreditlimit = creditLimit(FacilityID.Value)

            If FacilityCreditlimit.CustomerNumber <> String.Empty Then

                If FacilityCreditlimit.totalTravelers > 0 Then

                    Select Case FacilityCreditlimit.CreditLimitAmount
                        Case 0
                            Select Case FacilityCreditlimit.totalTravelers
                                Case >= 5
                                    ' FsCreditCheck.Visible = True
                                    Dim CurrentPercentage As Decimal = Math.Round((FacilityCreditlimit.facilityTotalNurses / FacilityCreditlimit.erFacilityTotalNurses) * 100)
                                    lblfacTotalMaxAllowed.Text = FacilityCreditlimit.totalTravelers.ToString()
                                    lblFacTotalNurses.Text = FacilityCreditlimit.facilityTotalNurses.ToString()
                                    LblCreditLimitAmount.Text = FormatCurrency(FacilityCreditlimit.CreditLimitAmount, 2)
                                    lblTotalPercent.Text = FormatPercent(CurrentPercentage / 100, 0)
                                    lblCreditNotes.Text = "There is no credit for this facility, your submittal will be sent to Accounting for approval. Please get with the account manager of this facility to speed up the process and prevent delays."
                            End Select
                        Case Else
                            'FsCreditCheck.Visible = True
                            Dim CurrentPercentage As Decimal = Math.Round((FacilityCreditlimit.facilityTotalNurses / FacilityCreditlimit.erFacilityTotalNurses) * 100)
                            lblfacTotalMaxAllowed.Text = FacilityCreditlimit.totalTravelers.ToString()
                            lblFacTotalNurses.Text = FacilityCreditlimit.facilityTotalNurses.ToString()
                            LblCreditLimitAmount.Text = FormatCurrency(FacilityCreditlimit.CreditLimitAmount, 2)
                            lblTotalPercent.Text = FormatPercent(CurrentPercentage / 100, 0)
                            lblCreditNotes.Text = "Total working and maximum allowed ratio is too high your submittal may be sent to Accounting for Verification if the percentage is greater than 50%"
                    End Select


                Else
                    'hideFieldset()
                End If
            Else
                'hideFieldset()
            End If

        Catch ex As Exception
            testlabel.Visible = True
            testlabel.Text = "AN UNEXPECTED ERROR HAS OCCURED! " & ex.Message
        End Try
    End Sub
    Protected Sub Button4_Click(sender As Object, e As EventArgs)
        Try
            Insertsubmittal()
        Catch ex As Exception
            testlabel.Visible = True
            testlabel.Text = "AN UNEXPECTED ERROR HAS OCCURED! " & ex.Message
        End Try
    End Sub
    Protected Sub Button5_Click(sender As Object, e As EventArgs)
        'Cancel And edit Submittal
        Try
            Dim submittals As New Submittals
            Dim jobrequest As New Submittals.Jobrequest
            With jobrequest
                .JobID = ListBoxSelectJob.SelectedValue
                .FacilityID = FacilityID.Value
                .CandidateID = CInt(Request.QueryString("CandidateID"))
                .SpecialtyID = ddlSpecialty.SelectedValue
            End With
            jobrequest = submittals.GetSubmittalByCandidateID(jobrequest)
            Dim targetURL As String = ""
            targetURL = "https://esig.trustaff.com/trustaffportal/submittals/submit_edit.aspx?"
            targetURL &= "FacPacketID=" & jobrequest.SubmittalId
            targetURL &= "&CandidateID=" & jobrequest.CandidateID
            Response.Write("<script>")
            Response.Redirect(targetURL)
            Response.Write("</script>")
        Catch ex As Exception
        End Try
    End Sub
    Private Sub Insertsubmittal()
        Dim submittals As New Submittals
        Dim CandidateSubmittal As New Submittals.CandidateSubmittal
        Dim CLGM As New GoldMine
        Dim CompanyRecord As New GoldMine.GoldmineCompanyRecord()
        Dim FacCreditlimit As New Submittals.ClientCreditLimit()
        Dim Cancelled As Boolean
        Try
            Dim shiftPreference As String
            If ddlShiftPreference.SelectedValue = "Other" Then
                shiftPreference = txtShiftPreferenceOther.Text
            Else
                shiftPreference = ddlShiftPreference.SelectedValue
            End If
            Dim myEmailList As String = emailList(Recruiter.Value, FrontEnd.Value)

            If Page.IsValid Then
                If ddlSpecialty.SelectedValue = "427" Then
                    ddlSpecialty.SelectedValue = "429"
                End If
                Cancelled = submittals.PlacementCancelled(Request.QueryString("CandidateID"))
                If Cancelled = True Then
                    CancelledYes.Value = "Yes"
                Else
                    CancelledYes.Value = "No"
                End If
                FiredYes.Value = submittals.CandidateFired(Request.QueryString("CandidateID"))

                CompanyRecord = CLGM.getCompanyrecordbyId(CLGM.getFacilityIDByJobID(ListBoxSelectJob.SelectedValue))

                Facility.Value = CompanyRecord.COMPANY
                ActMgr.Value = CompanyRecord.KEY4
                FacilityID.Value = CompanyRecord.ID

                Dim Ctl As Control
                Dim ddlCtl As DropDownList
                Dim sclFormsList As String = ""
                For Each Ctl In phNewSclForms.Controls
                    If Left(Ctl.UniqueID.ToString(), 6) = "ddlSCL" Then
                        ddlCtl = CType(Ctl, DropDownList)
                        If ddlCtl.SelectedItem.Value > 0 Then
                            sclFormsList = sclFormsList + ddlCtl.SelectedValue.ToString + "|"
                        End If
                    End If
                Next

                Dim SubmittalStatus As Integer
                'Send Submittal Directly to Account manager Bucket if account is direct
                Select Case CompanyRecord.VMS.Trim
                    Case "Direct"
                        Select Case CompanyRecord.ID
                            Case 10902, 17016069, 2044, 38187, 15906927
                                SubmittalStatus = 426 ' turn back on again on 5/6 per management
                            Case Else
                                SubmittalStatus = 411 ' Turned off for now  when ready this number need to get switched to 426
                        End Select
                    Case Else
                        SubmittalStatus = 411
                End Select

                With CandidateSubmittal
                    Select Case ddlTruStaffCompany.SelectedValue
                        Case 9
                            .SubmitStatus = 602
                        Case Else
                            .SubmitStatus = SubmittalStatus
                    End Select
                    .CandidateID = CInt(Request.QueryString("CandidateID"))
                    .RequestID = ListBoxSelectJob.SelectedValue
                    .trustaffCompany_ID = ddlTruStaffCompany.SelectedValue
                    .BestContact = Replace(txtBestContactNumber.Text.ToString, "'", "`")
                    .Specialty = ddlSpecialty.SelectedValue
                    .ShiftPref = ddlShiftPreference.SelectedValue
                    .DateStart = Replace(txtDateAvailable.Text.ToString, "'", "`")
                    .AssignTerm = ddlTermOfAssignment.SelectedValue
                    .TimeOff = Replace(txtTimeOff.Text.ToString, "'", "`")
                    .Comment = Replace(txtComments.Text.ToString, "'", "`")
                    .PacketID = Replace(TextBox7.Text.ToString, "'", "`")
                    .FacilityID = FacilityID.Value
                    .Cancelled = CancelledYes.Value
                    .Fired = FiredYes.Value
                    .Other = Replace(SpecialtyApplyingForOther.Text.ToString, "'", "`")
                    .Notes = Replace(txtAdminNotes.Text.ToString, "'", "`")
                    If ddlShiftPreference.SelectedValue = "Other" Then
                        .ShiftOther = Replace(txtShiftPreferenceOther.Text.ToString, "'", "`")
                    Else
                        .ShiftOther = "See shift Pref"
                    End If
                    If ddlTermOfAssignment.SelectedValue = "Other" Then
                        .TermOther = Replace(TermOfAssignmentOther.Text.ToString, "'", "`")
                    Else
                        .TermOther = "Please see assignment Terms"
                    End If
                    .Old = Replace(Old.Text.ToString, "'", "`")
                    .OtherContact = Replace(Old.Text.ToString, "'", "`")
                    .cathlab = False
                    .gi = False
                    .ms = False
                    .dialysis = False
                    .psyc = False
                    .icu = False
                    .ed = False
                    .landd = False
                    .nicu = False
                    .onc = False
                    .pacu = False
                    .peds = False
                    .tele = False
                    .picu = False
                    .or1 = False
                    .lpn = False
                    .ltc = False
                    .RegistryPrivateID = LabelJobID.Text
                    .sclForms = sclFormsList
                    .InterviewTime = txtinterviewtime.Text
                    .swatRecId = 0 ' CInt(ddlSwat.SelectedValue)
                End With

                Dim success As Boolean = submittals.InsertSubmittalRecord(CandidateSubmittal)

                If success = True Then
                    Dim EmailFormat As String = "<div><table><tr style ='width:50px;' ><td colspan =4 bgcolor =#FFFFFF valign=top>"
                    EmailFormat &= "<a href = 'http://www.trustafftravel.com/' style='border:none;'>"
                    EmailFormat &= "<img src ='https://www.trustaff.com/marketing/htmlimages/splatter_header_2017.jpg'/></a>"
                    EmailFormat &= "<div>A Traveler has been submitted to the Facility below: </br></div>"
                    EmailFormat &= "<div> Name: <b>" & Nurse.Value & "</b></div>"
                    EmailFormat &= "<div> Recruiter: <b>" & Recruiter.Value & "</b></div>"
                    EmailFormat &= "<div> Facility name: <b>" & Facility.Value & "</b></div>"
                    EmailFormat &= "<div>GM Status:  <b>" & GMStatus.Value & "</b></br></div>"
                    EmailFormat &= "<div>Job:  <b>" & CandidateSubmittal.RequestID & "</b></br></div>"
                    EmailFormat &= "<div><table><tr><td> Notes: <b>" & CandidateSubmittal.Notes & "</b></td></tr></table></div>"
                    EmailFormat &= "<tr style='width:50px;'><td colspan =4 bgcolor=#FFFFFF valign=top><a href = 'http://www.trustafftravel.com/' style='border:none;'>"
                    EmailFormat &= "<img src ='http://www.trustaff.com/marketing/htmlimages/swoop_footer.png'/></a></td></tr></table></div>"

                    'Dim body As String = "<p><img src='http://www.trustaff.com/images/logo.gif' width='206' height='64' /></p><h1>A Nurse Has Been Submitted </h1><p>Name: " & Nurse.Value & "<br />Recruiter: " & Recruiter.Value & "<br />Facility: " & Facility.Value & "<br /><br />GM Status: " & GMStatus.Value & "<br />Job: " & ListBoxSelectJob.SelectedValue & "<br /><br /><br />Notes: " & txtAdminNotes.Text & "<br /></p>"
                    Select Case CompanyRecord.VMS.Trim
                        Case "Direct"
                            SendDirectSubsEmailToAM(CandidateSubmittal)
                        Case Else
                            EmailHelper.SubmittalEmail(recEmail + myEmailList, "A Nurse Has Been Submitted " & Nurse.Value, EmailFormat, False)
                    End Select
                    testlabel.ForeColor = Drawing.Color.Green
                    testlabel.Text = "Success! Traveler has been submitted."
                    'BtnSave.Enabled = False
                    FacCreditlimit = creditLimit(FacilityID.Value)
                    If FacCreditlimit.CustomerNumber <> String.Empty Then
                        Dim CurrentPercantage As Decimal
                        Select Case FacCreditlimit.erFacilityTotalNurses
                            Case Is > 0
                                CurrentPercantage = Math.Round((FacCreditlimit.erFacilityTotalNurses * 100) / FacCreditlimit.totalTravelers)
                            Case Else
                                CurrentPercantage = Math.Round((FacCreditlimit.facilityTotalNurses * 100) / FacCreditlimit.totalTravelers)
                        End Select
                        Select Case FacCreditlimit.CreditLimitAmount
                            Case 0
                                Select Case FacCreditlimit.erFacilityTotalNurses
                                    Case Is >= 5
                                        Dim facrecrodexist As Boolean = submittals.GetfacilityCreditRecord(FacilityID.Value)
                                        If facrecrodexist = True Then
                                        Else
                                            submittals.InsertfacilityCreditLimit(FacilityID.Value, FacCreditlimit.CustomerNumber)
                                            submittals.SendCreditlimitEmail(FacCreditlimit)
                                        End If
                                    Case Else
                                End Select
                            Case Else
                                Select Case CurrentPercantage
                                    Case Is >= 50
                                        Dim facrecrodexist As Boolean = submittals.GetfacilityCreditRecord(FacilityID.Value)
                                        If facrecrodexist = True Then
                                        Else
                                            submittals.InsertfacilityCreditLimit(FacilityID.Value, FacCreditlimit.CustomerNumber)
                                            submittals.SendCreditlimitEmail(FacCreditlimit)
                                        End If
                                    Case Else

                                End Select
                        End Select
                        ' Credit limit is not questionable
                    Else
                    End If

                    GridView2.DataBind()
                Else
                    testlabel.ForeColor = Drawing.Color.Red
                    testlabel.Text = "There has been a technical problem with your data,Submittal not saved... Try again or contact your system administrator for help."
                End If

            Else
                testlabel.ForeColor = Drawing.Color.Red
                testlabel.Text = "Page data is invalid."
            End If
        Catch ex As Exception
        End Try
    End Sub
    Public Function SendDirectSubsEmailToAM(CandidateSubmittal As Submittals.CandidateSubmittal) As Boolean
        Dim BoolSend As Boolean = False
        Dim submittals As New Submittals
        Dim Facilityoffer As New Facilityoffers
        Dim GM As New GoldMine
        Dim FacilityRecord As New GoldMine.GoldmineCompanyRecord
        Dim TravelerInfo As New Submittals.TravelerInfo
        TravelerInfo = submittals.GetTravelerInfo(CandidateSubmittal.CandidateID)
        FacilityRecord = GM.getCompanyrecordbyId(CandidateSubmittal.FacilityID)
        Dim AccountManagerEmail As String
        AccountManagerEmail = Facilityoffer.GetUserEmailByID(Facilityoffer.GetUserByID(FacilityRecord.KEY4))
        Dim emails As String = emailList(TravelerInfo.Recruiter, TravelerInfo.FrontendEmail)
        Try
            Dim EmailFormat As String = "<div><table><tr style ='width:50px;' ><td colspan =4 bgcolor =#FFFFFF valign=top>"
            EmailFormat &= "<a href = 'http://www.trustafftravel.com/' style='border:none;'>"
            EmailFormat &= "<img src ='https://www.trustaff.com/marketing/htmlimages/splatter_header_2017.jpg'/></a>"
            EmailFormat &= "<div>A Traveler has been submitted to the (DIRECT) Facility below: </br></div>"
            EmailFormat &= "<div> Recruiter: <b>" & TravelerInfo.Recruiter & "</b></div>"
            EmailFormat &= "<div> Facility name: <b>" & FacilityRecord.COMPANY & "</b></div>"
            EmailFormat &= "<div>GM Status:  <b>" & TravelerInfo.CandidateStatus & "</b></br></div>"
            EmailFormat &= "<div>Job:  <b>" & CandidateSubmittal.RequestID & "</b></br></div>"
            EmailFormat &= "<div><table><tr><td> Notes: <b>" & CandidateSubmittal.Notes & "</b></td></tr></table></div>"
            EmailFormat &= "<tr style='width:50px;'><td colspan =4 bgcolor=#FFFFFF valign=top><a href = 'http://www.trustafftravel.com/' style='border:none;'>"
            EmailFormat &= "<img src ='http://www.trustaff.com/marketing/htmlimages/swoop_footer.png'/></a></td></tr></table></div>"


            Dim Subject As String = "A Nurse Has Been Submitted - " & TravelerInfo.Travelername
            Dim mailMessage As New MailMessage()
            mailMessage.To.Add(AccountManagerEmail & "," & TravelerInfo.RecruiterEmail & emails)
            mailMessage.From = New MailAddress("Submittals@trustaff.com", "Submittals")
            mailMessage.Subject = Subject
            mailMessage.SubjectEncoding = Encoding.UTF8
            mailMessage.Body = EmailFormat
            mailMessage.IsBodyHtml = True
            mailMessage.Priority = MailPriority.High
            Dim Smtp As New SmtpClient("mail2.trustaff.com")
            Smtp.Send(mailMessage)
        Catch ex As Exception
        End Try
        Return BoolSend
    End Function
    Private Sub BindDropdown(ByVal ddl As DropDownList, ByVal ds As Object, ByVal dataTextField As String, ByVal dataValueField As String)
        With ddl
            .Items.Clear()
            .Items.Insert(0, New ListItem("--Select--", "-1"))
            .Items.Insert(1, New ListItem("None", "0"))
            .DataSource = ds
            .DataTextField = dataTextField
            .DataValueField = dataValueField
            .DataBind()
        End With
    End Sub
End Class