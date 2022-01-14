Imports System.Data
Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System.Web.Services
Imports System.Windows
Imports System.Drawing


Partial Class SubmittalBucketAM_Tim
    Inherits System.Web.UI.Page
    Dim facPacId As Integer = 0
    Dim myCounter As Int16 = 0
    Dim cellNotes As Int16 = 19
    Dim cellSubmitStatus As Int16 = 16
    Dim recruiterEmail As String = ""
    Private frontendemail As String = ""
    Dim recruiterEmailBody As String = ""
    Dim recruiterEmailNurse As String = ""
    Private EditedNotes As TextBox
    Private NurseName As String = ""
    Private SubNotes As String
    Private Gridviewnotes As Label
    Private lbbillrate As Label
    Private subStatus As DropDownList
    Private activeStatus As DropDownList
    Private Recruiter As String
    Private am As String
    Private facility As String
    Private specialty As String
    Private SubmitStatus As String
    Private Activeuser As Int16

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Try

            Dim actmgr As String
            Dim xwert As String = Request.Params.Get("__EVENTARGUMENT")
            Session.Timeout = 1440
            If Request.QueryString("Actmgr").Length < 8 Then
                actmgr = Request.QueryString("actmgr")
            Else
                actmgr = (Request.QueryString("actmgr").Substring(0, 8))
            End If
            Dim sql As String = "SElect esigId from userlist where actmgr=1 and Substring(gm_username,0,9)='" + actmgr + "'"
            GridView1.Enabled = True
            Panel1.Enabled = True
            bLogout.Visible = True
            bChangePw.Visible = True
            If Session("bucketUsername") = "" Then

                Panel1.Enabled = False
                bLogout.Visible = False
                bChangePw.Visible = False
            ElseIf Session("bucketUsername") <> Request.QueryString("actmgr") Then

                Dim username As String = tbUsername.Text
                Dim strquerystring As String = Request.QueryString("actmgr")
                If username.Length >= 8 Then
                    username.Substring(0, 8)
                    strquerystring = Request.QueryString("actmgr").Substring(0, 8)
                Else

                End If

                Response.Redirect("https://esig.trustaff.com/trustaffportal/submittals/SubmittalBucketAM_TimRemote.aspx?actmgr=" + username)

            ElseIf InStr(xwert, "Edit$") <> 1 Then
                If InStr(xwert, "ddlUpdate") < 1 Then
                    Dim sScript As New System.Text.StringBuilder
                    Dim sScriptName As String = String.Empty

                    sScript.Append("$(document).ready(function () {reloadFunctions();});")

                    ScriptManager.RegisterStartupScript(Label13, GetType(Label), sScriptName, sScript.ToString, True)
                End If
            End If
            Session("dontDoAnything") = False

        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED Page Render ERROR! " & ex.Message

        End Try

    End Sub

    <WebMethod(EnableSession:=True)>
    Public Shared Sub PokePage()
        ' called by client to refresh session
        EmailHelper.ODS("Server: I am poked")
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim Clips As New ClHelpers()
            Dim Access As String
            Access = Clips.LimitAccess(Request.UserHostAddress())
            If Access = String.Empty Then
                Response.Redirect("google.com")
                Exit Sub
            End If
            If Page.IsPostBack Then
                Dim eTarget As String = Request.Params("__EVENTTARGET").ToString()
            End If
            Session("referer") = Request.RawUrl
            If Not Page.IsPostBack Then
                Session("myDT") = Nothing
                Session("editIndex") = -1
            End If
            Dim actmgr As String

            If Request.QueryString("Actmgr").Length <= 8 Then
                actmgr = Request.QueryString("actmgr")
            Else
                actmgr = (Request.QueryString("actmgr").Substring(0, 8))
            End If
            Dim Conn As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim myConnection2 As New SqlConnection(Conn)
            Dim SqlEmail = "USP_Get_User"
            Dim objCmdEmail As New SqlCommand(SqlEmail, myConnection2)
            Dim objDREmail As SqlDataReader
            With objCmdEmail
                .CommandType = CommandType.StoredProcedure
                .Parameters.Add(New SqlParameter("@UserName", SqlDbType.NVarChar)).Value = actmgr
            End With
            myConnection2.Open()
            objDREmail = objCmdEmail.ExecuteReader(System.Data.CommandBehavior.CloseConnection)
            If objDREmail.Read() Then

                If IsDBNull(objDREmail("Company_ID")) Then
                    Session("Company_ID") = 0
                Else
                    Session("Company_ID") = objDREmail("Company_ID")
                End If

            End If

            objDREmail.Close()
            myConnection2.Close()
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim myConnection As New SqlConnection(connString)

            Dim xwert As String = Request.Params.Get("__EVENTARGUMENT")

            'for email parse out vars added  7-10-12ttw
            If InStr(xwert, "@@@@@$$$$$") > 0 Then
                recruiterEmailNurse = Mid(xwert, InStr(xwert, "</h1><p>Name: ") + 14, (InStr(xwert, "<br />") - 1) - (InStr(xwert, "</h1><p>Name: ") + 14))

                recruiterEmail = Mid(xwert, 1, InStr(xwert, "<p>") - 1)
                recruiterEmailBody = Mid(xwert, InStr(xwert, "<p>"), (InStr(xwert, "@@@@@$$$$$") - 1) - (InStr(xwert, "<p>")))
                xwert = Mid(xwert, InStr(xwert, "@@@@@$$$$$") + 10)
            Else
                'added 7-12-12ttw
                recruiterEmail = ""
                recruiterEmailBody = ""
                recruiterEmailNurse = ""
            End If

            Dim sql As String = ""

            GridView1.Enabled = True

            Panel1.Enabled = True
            bLogout.Visible = True
            bChangePw.Visible = True
            If Session("bucketUsername") = "" Then

                Panel1.Enabled = False
                bLogout.Visible = False
                bChangePw.Visible = False
                'End If
                'dr.Close()
                'myConnection.Close()
            ElseIf UCase(Session("bucketUsername")) <> UCase(actmgr) Then
                Response.Redirect("https://esig.trustaff.com/trustaffportal/submittals/SubmittalBucketAM_TimRemote.aspx?actmgr=" + actmgr)

            Else
                If InStr(xwert, "ddlUpdate") < 1 Then
                    Dim sScript As New System.Text.StringBuilder
                    Dim sScriptName As String = String.Empty
                    sScript.Append("$(document).ready(function () {reloadFunctions();});")
                    ScriptManager.RegisterStartupScript(Label13, GetType(Label), sScriptName, sScript.ToString, True)
                End If
            End If

            If xwert Is Nothing Or xwert Is DBNull.Value Then
                ' xwert = ""
                If Request.Params.Get("data") Is Nothing Or Request.Params.Get("data") Is DBNull.Value Then
                    xwert = ""
                Else
                    xwert = Request.Params.Get("data")
                End If
            End If

            If InStr(xwert, "high") Then
                'Dim objDR As SqlDataReader
                Dim objCmd As New SqlCommand(sql, myConnection)
                myConnection.Open()


                Dim xString1 As String = xwert
                Dim xString2 As String = Nothing
                Dim xString3 As String = Nothing
                xString1 = Mid(xString1, InStr(xString1, "&") + 1)

                If InStr(xString1, "&") Then
                    xString2 = Mid(xString1, 1, InStr(xString1, "&") - 1)
                Else
                    xString2 = xString1
                End If
                Do While True

                    If InStr(xString2, "true1") Then
                        objCmd.CommandText = "UPDATE FacPackets SET  Highlight=1 where FacPacketId=" + Mid(xString2, InStr(xString2, "_") + 1)
                    ElseIf InStr(xString2, "true2") Then
                        objCmd.CommandText = "UPDATE FacPackets SET  Highlight=2 where FacPacketId=" + Mid(xString2, InStr(xString2, "_") + 1)
                    ElseIf InStr(xString2, "true3") Then
                        objCmd.CommandText = "UPDATE FacPackets SET  Highlight=3 where FacPacketId=" + Mid(xString2, InStr(xString2, "_") + 1)
                    ElseIf InStr(xString2, "true4") Then
                        objCmd.CommandText = "UPDATE FacPackets SET  Highlight=4 where FacPacketId=" + Mid(xString2, InStr(xString2, "_") + 1)
                    Else
                        objCmd.CommandText = "UPDATE FacPackets SET  Highlight=0 where FacPacketId=" + Mid(xString2, InStr(xString2, "_") + 1)
                    End If
                    objCmd.ExecuteNonQuery()
                    xString3 += Mid(xString2, InStr(xString2, "_") + 1)
                    If InStr(xString1, "&") Then
                        xString1 = Mid(xString1, InStr(xString1, "&") + 1)
                        If InStr(xString1, "&") Then
                            xString2 = Mid(xString1, 1, InStr(xString1, "&") - 1)
                        Else
                            xString2 = xString1
                        End If
                    Else
                        Exit Do
                    End If
                Loop

                'trans.Commit()

                myConnection.Close()
            ElseIf InStr(xwert, "hidden") Then
                Dim objCmd As New SqlCommand(sql, myConnection)
                myConnection.Open()
                objCmd.CommandText = "UPDATE FacPackets SET  AMNotes='" + Mid(xwert, InStr(xwert, "!") + 1) + "'" &
                                     " where FacPacketId=" + Mid(xwert, InStr(xwert, "_") + 1, InStr(Mid(xwert, InStr(xwert, "_") + 1), "!") - 1)
                objCmd.ExecuteNonQuery() ' uncommit to allow updates
                myConnection.Close()

            ElseIf InStr(xwert, "notes") Then
                Dim objCmd As New SqlCommand(sql, myConnection)
                myConnection.Open()

                objCmd.CommandText = "UPDATE FacPackets SET  Notes='" + Mid(xwert, InStr(xwert, "!") + 1) + "{" + Date.Now.ToString("MMM, ddd d, h:mm tt") + "} * '" &
                                     " where FacPacketId=" + Mid(xwert, InStr(xwert, "_") + 1, InStr(Mid(xwert, InStr(xwert, "_") + 1), "!") - 1)
                objCmd.ExecuteNonQuery() ' uncommit to allow updates
                myConnection.Close()


            ElseIf InStr(xwert, "ddlUpdate") Then
                If Session("sortExpression2") <> "" Then
                    gridView_Sorting2()
                    myCounter = 0
                Else
                    generateGV()
                    myCounter = 0
                End If
                statusUpdate(xwert, True)

            End If


            'If Not Page.IsPostBack Then
            If Session("myDT") Is Nothing Then
                If Session("sortExpression2") Is Nothing Or Session("sortExpression2") = "" Or Request.QueryString("actmgr") = "" Or Request.QueryString("actmgr") Is Nothing Then

                    GridView1.DataSource = generateGV()
                    GridView1.DataBind()
                Else
                    Dim dataView As New DataView(generateGV())

                    dataView.Sort = Session("sortExpression2") & " " & Session("sortDirection2")

                    'If Session("editIndex") > 0 Then
                    GridView1.EditIndex = -1
                    'End If
                    Dim dt As DataTable = New DataTable()
                    dt = dataView.ToTable.Copy

                    Session("myDT") = dt
                    GridView1.DataSource = dataView
                    GridView1.DataBind()
                End If

                myCounter = 0
                'added 9-19-12-ttw
                getRecList()
            Else
                'added 9-19-12-ttw
                ddlRecruitersEmail = Session("ddlRecruiters")
                GridView1.DataSource = Session("myDT")
                GridView1.DataBind()
                myCounter = 0
                If InStr(xwert, "high") Then
                    generateGV()
                    myCounter = 0
                End If
            End If
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected Error has occured! Please try again or Contract your system Administrator for help!" & ex.Message
        End Try

    End Sub

    Function statusUpdate(ByVal xwert As String, ByVal isLabel As Boolean) As String
        Try
            'Dim Result As Forms.DialogResult
            'Result = Forms.MessageBox.Show("Potential removal from your Bucket warning!! Are you sure you want Update this record?", "Record update", Forms.MessageBoxButtons.YesNo, Forms.MessageBoxIcon.Question)

            'If Result = Forms.DialogResult.Yes Then
            Dim Submittal As New Submittals
            Dim SubmittalSatus As Submittals.SubmittalStatus
            Dim MyData As New DataTable
            Dim row As DataRow
            Dim facpacketId As Integer = Mid(xwert, InStr(xwert, "_") + 1, InStr(Mid(xwert, InStr(xwert, "_") + 1), "!") - 1)

            With SubmittalSatus
                .PacketID = facpacketId
                MyData = Submittal.GetPacketStatus(SubmittalSatus)
                For Each row In MyData.Rows
                    .PacketStatusId = row.Item("SubmitStatus")
                Next
                .statusID = Mid(xwert, InStr(xwert, "!") + 1)
            End With

            Dim AMTOADMIN As Integer = 0
            If (SubmittalSatus.PacketStatusId = 426 And SubmittalSatus.statusID = 411) Then
                AMTOADMIN = 1
            Else
                AMTOADMIN = 0
            End If
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim myConnection As New SqlConnection(connString)
            Dim objCmd As New SqlCommand("", myConnection)
            myConnection.Open()

            objCmd.CommandText = "USP_AM_BucketUpdate"
            objCmd.CommandType = CommandType.StoredProcedure
            objCmd.Parameters.AddWithValue("@StatusID", SubmittalSatus.statusID)
            objCmd.Parameters.AddWithValue("@PacketID", SubmittalSatus.PacketID)
            objCmd.Parameters.AddWithValue("@AmToAdmin", AMTOADMIN)
            objCmd.ExecuteNonQuery()
            myConnection.Close()
            Select Case Mid(xwert, InStr(xwert, "!") + 1)
                Case 426, 602 'In Queue - Act Mgr
                    ActMgrEmail(xwert, isLabel)

                Case 415, 423, 413, 422
                    RecEmail2(xwert, isLabel)
                Case 597, 430, 619, 451, 577, 576, 568, 567, 414, 602, 495, 578
                    ActMgrEmail(xwert, isLabel)
                    RecEmail2(xwert, isLabel)
                Case Else
                    ActMgrEmail(xwert, isLabel)
                    RecEmail2(xwert, isLabel)
            End Select
            'RecEmail(xwert, isLabel) ' added 6-12-12
            myConnection.Close()
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN UPDATING THE BUCKET! " & ex.Message
        End Try
        Return Nothing
    End Function

    Public Sub ActMgrEmail(ByVal xwert As String, ByVal isLabel As Boolean)
        Dim rowId As String = Mid(xwert, InStr(xwert, "_") + 1, InStr(Mid(xwert, InStr(xwert, "_") + 1), "!") - 1)
        Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
        Dim myConnection As New SqlConnection(connString)
        Dim sql As String = "SELECT  Fp.CandidateId,C.Contact, UL.User_Email,C.id,FP.Notes,ISNULL(ul2.User_Email,'noreply@trustaff.com')frontend,Ul.Name as Recruiter,ULF.Name As AM,CF.Company as Facility,JobSpecialty.SpecialtyName,LookupValue_1.ShortDesc AS SubmitStatus from Trustaff_Med.dbo.Facpackets FP " &
                                 "Inner Join TRustaff_med.dbo.CONTACT1 C ON C.id = FP.CandidateID " &
                                  "Inner Join TRustaff_med.dbo.CONTACT1 CF ON CF.id = FP.FacilityID " &
                                  "Inner JOin Trustaff_med.dbo.UserList ULF ON SUBSTRING(ULF.GM_Username,0,9) = SUBSTRING(CF.Key4,0,9) " &
                                  "INNER JOIN  Trustaff_med.dbo.LookupValue AS LookupValue_1 ON LookupValue_1.LookupValueID=FP.SubmitStatus " &
                                  "INNER JOIN Trustaff_med.dbo.JobSpecialty ON JobSpecialty.pk_SpecialtyID = FP.Specialty " &
                                 "Inner JOin Trustaff_med.dbo.UserList UL ON SUBSTRING(UL.GM_Username,0,9) = SUBSTRING(C.Key4,0,9) " &
                                 "LEFT JOIN trustaff_med.dbo.Contact2 c2 on c2.accountno = c.accountno " &
                                 "Left Join trustaff_med.dbo.userlist ul2 on SUBSTRING(ul2.GM_Username,0,9) = SUBSTRING(c2.U_GENER13,0,9) " &
                                 "where FacpacketID =@rowid"
        Dim conn As SqlConnection = Nothing
        Try
            conn = New SqlConnection(connString)
            Dim cmd As SqlCommand = New SqlCommand(sql, conn)
            With cmd
                .CommandType = CommandType.Text
                .Parameters.Add(New SqlParameter("@rowid", SqlDbType.Int)).Value = rowId
            End With
            conn.Open()
            Dim dr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
            Dim dt As DataTable = New DataTable()
            dt.Load(dr)
            SubNotes = dt.Rows(0).Item("Notes").ToString()
            recruiterEmail = dt.Rows(0).Item("User_Email")
            NurseName = dt.Rows(0).Item("Contact")
            frontendemail = dt.Rows(0).Item("frontend")
            Recruiter = dt.Rows(0).Item("recruiter")
            am = dt.Rows(0).Item("AM")
            facility = dt.Rows(0).Item("Facility")
            specialty = dt.Rows(0).Item("SpecialtyName")
            SubmitStatus = dt.Rows(0).Item("SubmitStatus")
        Catch ex As SqlException
            Response.Write("You must sign in.")
        Catch ex As Exception
            ' handle error
        Finally
            conn.Close()
        End Try

        Try
            ' Response.AddHeader("test", rowId)
            Dim x As GridViewRow = GridView1.FindControl(rowId)
            If GridView1.EditIndex > -1 Then
                EditedNotes = TryCast(Me.GridView1.Rows(Me.GridView1.EditIndex).FindControl("tbNotes"), TextBox)
            End If
            Dim smtp As New SmtpClient("mail2.trustaff.com")
            Dim Mailmsg As New System.Net.Mail.MailMessage("Submittal@trustaff.com", "" + Session("actMgrEmail"))
            'Dim copy As New MailAddress("ccherif@trustaff.com")
            ' Mailmsg.CC.Add(copy)
            Mailmsg.Priority = Net.Mail.MailPriority.High
            Mailmsg.IsBodyHtml = True
            Mailmsg.Subject = "A Submittal Packet Has Been Updated For " + NurseName
            Mailmsg.Headers.Add("X-Message-Flag", "Follow up")
            If isLabel = True Then
                If GridView1.EditIndex > -1 Then
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + x.Cells(23).Text + "<br />Recruiter: " + x.Cells(8).Text + "<br />Facility: " + x.Cells(3).Text + "<br />Specialty: " + x.Cells(6).Text + "<br />Status: " + Mid(xwert, InStr(xwert, "!") + 1) + "<br />Account Manager: " + x.Cells(5).Text + "<br />Notes: " & EditedNotes.Text & "<br /></p>"
                Else
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + NurseName + "<br />Recruiter: " + Recruiter + "<br />Facility: " + facility + "<br />Specialty: " + specialty + "<br />Status: " + SubmitStatus + "<br />Account Manager: " + am + "<br />Notes: " & SubNotes & "<br /></p>"
                End If
            Else
                If GridView1.EditIndex > -1 Then
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + x.Cells(23).Text + "<br />Recruiter: " + x.Cells(8).Text + "<br />Facility: " + x.Cells(3).Text + "<br />Specialty: " + x.Cells(6).Text + "<br />Status: In Queue - Act Mgr<br />Account Manager: " + x.Cells(5).Text + "<br />Notes: " & EditedNotes.Text & "<br /></p>"
                Else
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + NurseName + "<br />Recruiter: " + Recruiter + "<br />Facility: " + facility + "<br />Specialty: " + specialty + "<br />Status: " + subStatus.SelectedItem.Text + "<br />Account Manager: " + am + "<br />Notes: " & SubNotes & "<br /></p>"
                End If
            End If
            smtp.Send(Mailmsg)
            upGridview.Update()
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN SENDING EMAIL TO ACCOUNT MANAGER! " & ex.Message
        End Try
    End Sub
    Public Sub RecEmail(ByVal xwert As String, ByVal isLabel As Boolean)   ' added 6-12-12
        Try
            Dim rowId As String = Mid(xwert, InStr(xwert, "_") + 1, InStr(Mid(xwert, InStr(xwert, "_") + 1), "!") - 1)
            Dim x As GridViewRow = GridView1.FindControl(rowId)
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim myConnection As New SqlConnection(connString)
            Dim sql As String = ""
            sql = "SELECT  Fp.CandidateId,C.Contact, UL.User_Email,C.id,FP.Notes,ISNULL(ul2.User_Email,'noreply@trustaff.com')frontend,Ul.Name as Recruiter,ULF.Name As AM,CF.Company as Facility,JobSpecialty.SpecialtyName from Trustaff_Med.dbo.Facpackets FP " &
                                 "Inner Join TRustaff_med.dbo.CONTACT1 C ON C.id = FP.CandidateID " &
                                  "Inner Join TRustaff_med.dbo.CONTACT1 CF ON CF.id = FP.FacilityID " &
                                  "Inner JOin Trustaff_med.dbo.UserList ULF ON SUBSTRING(ULF.GM_Username,0,9) = SUBSTRING(CF.Key4,0,9) " &
                                  "INNER JOIN Trustaff_med.dbo.JobSpecialty ON JobSpecialty.pk_SpecialtyID = FP.Specialty " &
                                 "Inner JOin Trustaff_med.dbo.UserList UL ON SUBSTRING(UL.GM_Username,0,9) = SUBSTRING(C.Key4,0,9) " &
                                 "LEFT JOIN trustaff_med.dbo.Contact2 c2 on c2.accountno = c.accountno " &
                                 "Left Join trustaff_med.dbo.userlist ul2 on SUBSTRING(ul2.GM_Username,09) = SUBSTRING(c2.U_GENER13,0,9) " &
                                 "where FacpacketID =@rowid"
            Dim conn As SqlConnection = Nothing
            Try
                conn = New SqlConnection(connString)
                Dim cmd As SqlCommand = New SqlCommand(sql, conn)
                With cmd
                    .CommandType = CommandType.Text
                    .Parameters.Add(New SqlParameter("@rowid", SqlDbType.Int)).Value = rowId
                End With
                conn.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                Dim dt As DataTable = New DataTable()
                dt.Load(dr)

                recruiterEmail = dt.Rows(0).Item("User_Email")
                NurseName = dt.Rows(0).Item("Contact")
                SubNotes = dt.Rows(0).Item("Notes").ToString()
                frontendemail = dt.Rows(0).Item("frontend")
                Recruiter = dt.Rows(0).Item("recruiter")
                am = dt.Rows(0).Item("AM")
                facility = dt.Rows(0).Item("Facility")
                specialty = dt.Rows(0).Item("SpecialtyName")
                SubmitStatus = dt.Rows(0).Item("SubmitStatus")

            Catch ex As SqlException
                Response.Write("You must sign in.")
                Exit Sub
            Catch ex As Exception
                ' handle error
            Finally
                conn.Close()
            End Try
            If GridView1.EditIndex > -1 Then
                EditedNotes = TryCast(Me.GridView1.Rows(Me.GridView1.EditIndex).FindControl("tbNotes"), TextBox)
            End If
            Dim smtp As New SmtpClient("mail2.trustaff.com")
            Dim Mailmsg As New System.Net.Mail.MailMessage("Submittal@trustaff.com", "" + x.Cells(x.Cells.Count - 15).Text + "@trustaff.com")
            Dim copy As New MailAddress("ccherif@trustaff.com")
            If frontendemail = "noreply@trustaff.com" Then
            Else
                Mailmsg.Bcc.Add(frontendemail)
            End If
            ' Mailmsg.CC.Add(copy)
            Mailmsg.Priority = Net.Mail.MailPriority.High
            Mailmsg.IsBodyHtml = True
            Mailmsg.Subject = "A Submittal Packet Has Been Updated For " + NurseName
            Mailmsg.Headers.Add("X-Message-Flag", "Follow up")
            If isLabel = True Then
                If GridView1.EditIndex > -1 Then
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + x.Cells(23).Text + "<br />Recruiter: " + x.Cells(8).Text + "<br />Facility: " + x.Cells(3).Text + "<br />Specialty: " + x.Cells(6).Text + "<br />Status: " + ddlSubmitStatus.SelectedItem.ToString + "<br />Account Manager: " + x.Cells(5).Text + "<br />Notes: " & EditedNotes.Text & "<br />**Please confirm status in bucket!**</p>"
                Else
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + NurseName + "<br />Recruiter: " + Recruiter + "<br />Facility: " + facility + "<br />Specialty: " + specialty + "<br />Status: " + ddlSubmitStatus.SelectedItem.ToString + "<br />Account Manager: " + am + "<br />Notes: " & SubNotes & "<br />**Please confirm status in bucket!**</p>"
                End If

            Else
                If GridView1.EditIndex > -1 Then
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + x.Cells(23).Text + "<br />Recruiter: " + x.Cells(8).Text + "<br />Facility: " + x.Cells(3).Text + "<br />Specialty: " + x.Cells(6).Text + "<br />Status: " + ddlSubmitStatus.SelectedItem.ToString + "<br />Account Manager: " + x.Cells(5).Text + "<br />Notes: " & EditedNotes.Text & "<br />**Please confirm status in bucket!**</p>"
                Else
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + NurseName + "<br />Recruiter: " + Recruiter + "<br />Facility: " + facility + "<br />Specialty: " + specialty + "<br />Status: " + ddlSubmitStatus.SelectedItem.ToString + "<br />Account Manager: " + am + "<br />Notes: " & EditedNotes.Text & "<br />**Please confirm status in bucket!**</p>"
                End If

            End If
            smtp.Send(Mailmsg)
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN SENDING EMAIL TO RECRUITER! " & ex.Message

        End Try
    End Sub
    Public Sub RecEmail2(ByVal xwert As  String, ByVal isLabel As Boolean)   ' added 6-28-12ttw - modified 7-10-12ttw
        Dim rowId As String = Mid(xwert, InStr(xwert, "_") + 1, InStr(Mid(xwert, InStr(xwert, "_") + 1), "!") - 1)
        Try
            Dim x As GridViewRow = GridView1.FindControl(rowId)
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim myConnection As New SqlConnection(connString)
            Dim sql As String = ""

            sql = "SELECT  Fp.CandidateId,C.Contact, UL.User_Email,C.id,FP.Notes,ISNULL(ul2.User_Email,'noreply@trustaff.com')frontend,Ul.Name as Recruiter,ULF.Name As AM,CF.Company as Facility,JobSpecialty.SpecialtyName,LookupValue_1.ShortDesc AS SubmitStatus from Trustaff_Med.dbo.Facpackets FP " &
                     "Inner Join TRustaff_med.dbo.CONTACT1 C ON C.id = FP.CandidateID " &
                     "Inner Join TRustaff_med.dbo.CONTACT1 CF ON CF.id = FP.FacilityID " &
                     "Inner JOin Trustaff_med.dbo.UserList ULF ON SUBSTRING(ULF.GM_Username,0,9) = SUBSTRING(CF.Key4,0,9) " &
                     "INNER JOIN  Trustaff_med.dbo.LookupValue AS LookupValue_1 ON LookupValue_1.LookupValueID=FP.SubmitStatus   " &
                     "INNER JOIN Trustaff_med.dbo.JobSpecialty ON JobSpecialty.pk_SpecialtyID = FP.Specialty " &
                     "Inner JOin Trustaff_med.dbo.UserList UL ON SUBSTRING(UL.GM_Username,0,9) = SUBSTRING(C.Key4,0,9) " &
                     "LEFT JOIN trustaff_med.dbo.Contact2 c2 on c2.accountno = c.accountno " &
                     "Left Join trustaff_med.dbo.userlist ul2 on SUBSTRING(ul2.GM_Username,0,9) = SUBSTRING(c2.U_GENER13,0,9) " &
                     "where FacpacketID =@rowid"
            Dim conn As SqlConnection = Nothing
            Try
                conn = New SqlConnection(connString)
                Dim cmd As SqlCommand = New SqlCommand(sql, conn)
                With cmd
                    .CommandType = CommandType.Text
                    .Parameters.Add(New SqlParameter("@rowid", SqlDbType.Int)).Value = rowId
                End With
                conn.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                Dim dt As DataTable = New DataTable()
                dt.Load(dr)

                'If dr.Read Then
                recruiterEmail = dt.Rows(0).Item("User_Email")
                NurseName = dt.Rows(0).Item("Contact")
                SubNotes = dt.Rows(0).Item("Notes").ToString()
                frontendemail = dt.Rows(0).Item("frontend")
                Recruiter = dt.Rows(0).Item("recruiter")
                am = dt.Rows(0).Item("AM")
                facility = dt.Rows(0).Item("Facility")
                specialty = dt.Rows(0).Item("SpecialtyName")
                SubmitStatus = dt.Rows(0).Item("SubmitStatus")
                'End If
            Catch ex As SqlException
                Response.Write("You must sign in.")
                Exit Sub
            Catch ex As Exception
                ' handle error
            Finally
                conn.Close()
            End Try

            If GridView1.EditIndex > -1 Then
                EditedNotes = TryCast(Me.GridView1.Rows(Me.GridView1.EditIndex).FindControl("tbNotes"), TextBox)
            Else

            End If

            Dim smtp As New SmtpClient("mail2.trustaff.com")
            Dim Mailmsg As New System.Net.Mail.MailMessage("Submittal@trustaff.com", "" + recruiterEmail)
            Dim copy As New MailAddress("ccherif@trustaff.com")
            If frontendemail = "noreply@trustaff.com" Then
            Else
                Mailmsg.CC.Add(frontendemail)
            End If
            'Mailmsg.CC.Add(copy)
            Mailmsg.Priority = Net.Mail.MailPriority.High
            Mailmsg.IsBodyHtml = True
            Mailmsg.Subject = "A Submittal Packet Has Been Updated For " + NurseName
            Mailmsg.Headers.Add("X-Message-Flag", "Follow up")

            If isLabel = True Then
                If GridView1.EditIndex > -1 Then
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + x.Cells(7).Text + "<br />Recruiter: " + x.Cells(8).Text + "<br />Facility:" + x.Cells(3).Text + "<br />Status: " + DirectCast(x.Cells(cellSubmitStatus).Controls(1), DropDownList).Items.FindByValue(Mid(xwert, InStr(xwert, "!") + 1)).Text + "<br />Account Manager: " + x.Cells(4).Text + "<br />Notes: " & EditedNotes.Text & "<br /></p>"
                Else
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + NurseName + "<br />Recruiter: " + Recruiter + "<br />Facility:" + facility + "<br />Status: " + SubmitStatus + "<br />Account Manager: " + am + "<br />Notes: " & SubNotes & "<br /></p>"
                End If
            Else
                If GridView1.EditIndex > -1 Then
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + x.Cells(7).Text + "<br />Recruiter: " + x.Cells(8).Text + "<br />Facility:" + x.Cells(3).Text + "<br />Status: " + DirectCast(x.Cells(cellSubmitStatus).Controls(1), DropDownList).Items.FindByValue(Mid(xwert, InStr(xwert, "!") + 1)).Text + "<br />Account Manager: " + x.Cells(4).Text + "<br />Notes: " & EditedNotes.Text & "<br /></p>"
                Else
                    Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + NurseName + "<br />Recruiter: " + Recruiter + "<br />Facility:" + facility + "<br />Status: " + DirectCast(x.Cells(cellSubmitStatus).Controls(1), DropDownList).Items.FindByValue(Mid(xwert, InStr(xwert, "!") + 1)).Text + "<br />Account Manager: " + am + "<br />Notes: " & SubNotes & "<br /></p>"
                End If
            End If
            smtp.Send(Mailmsg)
            upGridview.Update()
            Dim sScript As New System.Text.StringBuilder
            Dim sScriptName As String = String.Empty
            sScript.Append("javascript: window.location = window.location;")
            ScriptManager.RegisterClientScriptBlock(Page, GetType(String), sScriptName, sScript.ToString, True)
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN SENDING EMAIL TO RECRUITER! " & ex.Message

        End Try
    End Sub

    Function generateGV() As DataTable
        Dim dt As DataTable = New DataTable()
        Try
            Dim actmgr As String
            If Request.QueryString("Actmgr").Length <= 8 Then
                actmgr = Request.QueryString("actmgr")
            Else
                actmgr = (Request.QueryString("actmgr").Substring(0, 8))
            End If
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim myConnection As New SqlConnection(connString)
            Dim xwert As String = Request.Params.Get("__EVENTARGUMENT")
            Dim sql As String = "USP_GetAMBucket"
            Dim conn As SqlConnection = Nothing
            Try
                conn = New SqlConnection(connString)
                Dim cmd As SqlCommand = New SqlCommand(sql, conn)
                With cmd
                    .CommandType = CommandType.StoredProcedure
                    .Parameters.AddWithValue("@AccountManager", actmgr)
                End With
                conn.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)

                dt.Load(dr)
                Session("usersName") = dt.Rows(0).Item("usersName")
                Session("actMgrEmail") = dt.Rows(0).Item("actMgrEmail")
                Session("myDT") = dt
                Return dt

            Catch ex As SqlException
                Response.Write("You must sign in.")
            Catch ex As Exception
                ' handle error
            Finally
                conn.Close()
            End Try

        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN loading your bucket! " & ex.Message

        End Try
        Return dt
    End Function

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Try
            Dim NewDate As DateTime
            NewDate = DateTime.Now.AddHours(-2)
            If e.Row.RowType = DataControlRowType.DataRow Then
                e.Row.ID = e.Row.DataItem("FacPacketID")
                If Session("editIndex") = myCounter Then
                    Dim tb3 As LinkButton = DirectCast(e.Row.Cells(0).Controls(0), LinkButton)
                    If tb3.Text <> "Edit" Then
                        tb3.Text = "Y "
                        Dim tb4 As LinkButton = DirectCast(e.Row.Cells(0).Controls(2), LinkButton)
                        tb4.Text = " N"
                    End If
                End If
                If IsNothing(Session("Activeuser")) Then
                    activeStatus = e.Row.FindControl("ddlSubmitStatus2")
                    activeStatus.Enabled = False
                Else
                    activeStatus = e.Row.FindControl("ddlSubmitStatus2")
                    activeStatus.Enabled = True

                End If
                If InStr(e.Row.Cells(14).Text, "1/1/1900") Then
                    e.Row.Cells(14).Text = ""
                End If
                If Session("bucketUsername") = "" Then
                    e.Row.Cells(0).Enabled = False
                    e.Row.Cells(1).Enabled = False
                    e.Row.Cells(14).Enabled = False
                    e.Row.Cells(15).Enabled = False
                    e.Row.Cells(16).Enabled = False
                End If
                myCounter += 1
                e.Row.Cells(0).Width = "30"

                If (e.Row.DataItem("SubmitStatus") = "In Queue - Act Mgr") And (e.Row.DataItem("submitted") > NewDate And e.Row.DataItem("SubmittedElse") = 0) Then
                    e.Row.CssClass += " rowStyleLightGreen"
                    Exit Sub
                ElseIf (e.Row.DataItem("Fired").ToString = "Yes") And (e.Row.DataItem("SubmitStatus").ToString = "In Queue - Act Mgr") And (e.Row.DataItem("SubmittedElse") = 0) Then
                    e.Row.CssClass += " rowStyleRed"
                    Exit Sub
                ElseIf (e.Row.DataItem("Cancelled").ToString = "Yes") And (e.Row.DataItem("SubmitStatus").ToString = "In Queue - Act Mgr") And (e.Row.DataItem("SubmittedElse") = 1) Then
                    e.Row.CssClass += " rowStyleOrange"
                    Exit Sub
                ElseIf ((e.Row.DataItem("KEY2") = "Can.Current Employee") Or (e.Row.DataItem("KEY2") = "Can. Former Employee")) And (e.Row.DataItem("SubmitStatus") = "In Queue - Act Mgr") And (e.Row.DataItem("SubmittedElse") = 0) Then
                    e.Row.CssClass += " rowStyleLightBlue"
                    Exit Sub
                End If
                If (e.Row.DataItem("SubmitStatus") = "Facility Made Offer") Then
                    e.Row.CssClass += " rowStyleOrange"
                    e.Row.Font.Bold = True
                    Exit Sub
                End If

                If Not (e.Row.DataItem("Highlight") Is DBNull.Value) AndAlso (e.Row.DataItem("Highlight") = 1 And e.Row.DataItem("SubmittedElse") = 0) Then
                    e.Row.CssClass += " rowStyleHighlightYellow"
                    Exit Sub
                ElseIf Not (e.Row.DataItem("Highlight") Is DBNull.Value) AndAlso (e.Row.DataItem("Highlight") = 2 And e.Row.DataItem("SubmittedElse") = 0) Then
                    e.Row.CssClass += " rowStyleHighlightBlue"
                    Exit Sub
                ElseIf Not (e.Row.DataItem("Highlight") Is DBNull.Value) AndAlso (e.Row.DataItem("Highlight") = 3 And e.Row.DataItem("SubmittedElse") = 0) Then
                    e.Row.CssClass += " rowStyleHighlightPink"
                    Exit Sub
                ElseIf Not (e.Row.DataItem("Highlight") Is DBNull.Value) AndAlso (e.Row.DataItem("Highlight") = 4 And e.Row.DataItem("SubmittedElse") = 0) Then
                    e.Row.CssClass += " rowStyleHighlightGreen"
                    Exit Sub
                End If
                If (e.Row.DataItem("SubmittedElse") = 1) Then

                    Dim ColorID As Integer = GetCandidateIDStatus(e.Row.DataItem("CandidateId"))
                    If ColorID = 0 Then
                        e.Row.CssClass += " rowStyleOrange"
                        e.Row.Font.Bold = True
                    Else
                        e.Row.CssClass += " rowbgblk"
                        e.Row.BackColor = Color.Black
                        e.Row.Font.Bold = True
                        e.Row.ForeColor = Color.White
                    End If

                    Exit Sub
                End If
                If IsNumeric(e.Row.DataItem("redflag")) Then
                    e.Row.CssClass += " rowStyleRed"
                    Exit Sub
                End If
            End If
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN LOADING THE BUCKET! " & ex.Message
        End Try
    End Sub
    Private Function GetSortDirection(ByVal column As String) As String
        Dim sortDirection As String = "ASC"
        Try
            Dim sortExpression As String = TryCast(ViewState("SortExpression"), String)
            If sortExpression IsNot Nothing Then
                If sortExpression = column Then
                    Dim lastDirection As String = TryCast(ViewState("SortDirection"), String)
                    If (lastDirection IsNot Nothing) AndAlso (lastDirection = "ASC") Then
                        sortDirection = "DESC"
                    End If
                End If
            End If
            ViewState("SortDirection") = sortDirection
            ViewState("SortExpression") = column
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN SORTING THE BUCKET! " & ex.Message
        End Try
        Return sortDirection
    End Function
    Protected Sub gridView_Sorting(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
        Try
            Dim dataTable As DataTable = TryCast(GridView1.DataSource, DataTable)

            If dataTable IsNot Nothing Then
                Dim dataView As New DataView(dataTable)
                Session("sortDirection2") = GetSortDirection(e.SortDirection)
                dataView.Sort = Convert.ToString(e.SortExpression) & " " & Session("sortDirection2")
                Session("sortExpression2") = Convert.ToString(e.SortExpression)
                GridView1.EditIndex = -1
                'End If
                Dim dt As DataTable = New DataTable()
                dt = dataView.ToTable.Copy

                Session("myDT") = dt

                GridView1.DataSource = dataView
                GridView1.DataBind()

            End If
            Dim sScript As New System.Text.StringBuilder
            Dim sScriptName As String = String.Empty

            sScript.Append("reloadFunctions();")

            ScriptManager.RegisterStartupScript(Label13, GetType(Label), sScriptName, sScript.ToString, True)
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN SORTING BUCKET! " & ex.Message

        End Try
    End Sub

    Function gridView_Sorting2() As DataTable

        Try
            Dim actmgr As String
            If Request.QueryString("Actmgr").Length <= 8 Then
                actmgr = Request.QueryString("actmgr")
            Else
                actmgr = (Request.QueryString("actmgr").Substring(0, 8))
            End If
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim myConnection As New SqlConnection(connString)
            Dim xwert As String = Request.Params.Get("__EVENTARGUMENT")
            Dim sql As String = "USP_GetAMBucketSorted"
            Dim conn As SqlConnection = Nothing
            Try
                conn = New SqlConnection(connString)
                Dim cmd As SqlCommand = New SqlCommand(sql, conn)
                With cmd
                    .CommandType = CommandType.StoredProcedure
                    .Parameters.AddWithValue("@AccountManager", actmgr)
                    .Parameters.AddWithValue("@SortExpression", Session("sortExpression2"))
                    .Parameters.AddWithValue("@sortDirection", Session("sortDirection2"))
                End With
                conn.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                Dim dt As DataTable = New DataTable()
                dt.Load(dr)
                myCounter = 0
                Session("myDT") = dt
                Return dt
            Catch ex As SqlException
                Response.Write("Dont Work")
            Catch ex As Exception
                ' handle error
            Finally
                conn.Close()
            End Try
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected Error HAS OCCURED When SORTING BUCKET! " & ex.Message
        End Try
        Return Nothing
    End Function

    Protected Sub GridView1_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles GridView1.RowCancelingEdit
    End Sub
    Protected Sub GridView1_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles GridView1.RowEditing
    End Sub
    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles GridView1.RowCommand

        Try
            If e.CommandName = "Edit" Then
                'Takes the GridView to Edit mode.
                Dim index As Integer = Convert.ToInt32(e.CommandArgument)
                GridView1.EditIndex = index
                Session("editIndex") = index
                Dim selectedRow As GridViewRow = DirectCast(e.CommandSource, GridView).Rows(index)
                myCounter = 0
                GridView1.DataSource = Session("myDT")
                GridView1.DataBind()
                Dim sScript As New System.Text.StringBuilder
                Dim sScriptName As String = String.Empty
                sScript.Append("reloadFunctions();")
                ScriptManager.RegisterStartupScript(Label13, GetType(Label), sScriptName, sScript.ToString, True)
            ElseIf e.CommandName = "Update" Then

                Dim updateButton As LinkButton = DirectCast(e.CommandSource, LinkButton)
                Dim dcfc As DataControlFieldCell = DirectCast(updateButton.Parent, DataControlFieldCell)
                Dim gvr As GridViewRow = DirectCast(dcfc.Parent, GridViewRow)
                Dim gvr2 As GridViewRow = DirectCast(updateButton.NamingContainer, GridViewRow)
                Dim id As Integer = CInt(GridView1.DataKeys(gvr.RowIndex).Value)
                UpdateDataInTheDatabase(gvr.Cells(cellNotes + 1).Controls, id, "notes")
                Dim sScript As New System.Text.StringBuilder
                Dim sScriptName As String = String.Empty
                sScript.Append("reloadFunctions();")
                ScriptManager.RegisterStartupScript(Label13, GetType(Label), sScriptName, sScript.ToString, True)
                'Grid goes back to normal
                GridView1.EditIndex = -1
                Session("editIndex") = -1

                myCounter = 0
                If Session("sortExpression2") <> "" Then
                    GridView1.DataSource = gridView_Sorting2()
                    GridView1.DataBind()
                    myCounter = 0
                Else
                    GridView1.DataSource = generateGV()
                    GridView1.DataBind()
                    myCounter = 0
                End If
                'generateGV()
            ElseIf e.CommandName = "Cancel" Then
                Dim sScript As New System.Text.StringBuilder
                Dim sScriptName As String = String.Empty
                sScript.Append("reloadFunctions();")
                ScriptManager.RegisterStartupScript(Label13, GetType(Label), sScriptName, sScript.ToString, True)
                GridView1.EditIndex = -1
                Session("editIndex") = -1
                myCounter = 0
                GridView1.DataSource = Session("myDT")
                GridView1.DataBind()
            End If

        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected Error HAS OCCURED When LOADING FUNTIONS! " & ex.Message
        End Try
    End Sub

    Private Sub UpdateDataInTheDatabase(ByVal cc As ControlCollection, ByVal id As Integer, ByVal field As String)

        Try
            If field = "notes" Then
                Dim tb As TextBox = DirectCast(cc(1), TextBox)
                tb.Text = Replace(tb.Text, "'", Chr(34))
                tb.Text += Environment.NewLine + " * " + Mid(Session("usersName"), 1, 1) + Mid(Session("usersName"), InStr(Session("usersName"), " ") + 1, 1) + " {" + Date.Now.ToString("MMM, ddd d, h:mm tt") + "} * "
                Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
                Dim myConnection As New SqlConnection(connString)
                Dim xwert As String = Request.Params.Get("__EVENTARGUMENT")
                Dim sql As String = ""
                Dim objCmd As New SqlCommand(sql, myConnection)
                myConnection.Open()
                objCmd.CommandText = "UPDATE FacPackets SET  " + field + " ='" + tb.Text + "'" &
                    " where FacPacketId=" + id.ToString
                objCmd.ExecuteNonQuery()
                myConnection.Close()
            Else
                Dim ddl As DropDownList = DirectCast(cc(1), DropDownList)
                statusUpdate("ddlUpdate&Gridview1_" & id.ToString & "!" & ddl.SelectedValue, False)
            End If

        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN UPDATING NOTES! " & ex.Message

        End Try
    End Sub
    Protected Sub GridView1_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView1.RowUpdating

    End Sub
    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button3.Click

        Try
            For Each myRow As GridViewRow In GridView1.Rows
                If DirectCast(myRow.Cells(2).Controls(1), CheckBox).Checked = True Then

                    statusUpdate("ddlUpdate&Gridview1_" & myRow.ID & "!" & ddlSubmitStatus.SelectedValue, True)
                End If
            Next

            GridView1.DataSource = generateGV()
            GridView1.DataBind()
            myCounter = 0
            Dim sScript As New System.Text.StringBuilder
            Dim sScriptName As String = String.Empty
            sScript.Append("reloadFunctions();")
            ScriptManager.RegisterStartupScript(Label13, GetType(Label), sScriptName, sScript.ToString, True)
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED WHEN UPDATING! " & ex.Message

        End Try
    End Sub

    Protected Sub bLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles bLogin.Click
        Try
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString

            Dim myConnection As New SqlConnection(connString)
            Dim xwert As String = Request.Params.Get("__EVENTARGUMENT")
            Dim sql As String = "SElect esigId,Active from userlist where actmgr=1 and Substring(gm_username,0,9)=SUBSTRING(@username,0,9) and password=@password and Active =1"
            Dim username As String = tbUsername.Text
            Dim strquerystring As String = Request.QueryString("actmgr")
            If username.Length >= 8 Then
                username.Substring(0, 8)
                strquerystring = Request.QueryString("actmgr").Substring(0, 8)
            Else
            End If
            Dim objCmd As New SqlCommand(sql, myConnection)
            With objCmd
                .Parameters.AddWithValue("@username", SqlDbType.NVarChar).Value = UCase(username)
                .Parameters.AddWithValue("@password", SqlDbType.NVarChar).Value = tbPassword.Text
            End With
            myConnection.Open()
            Dim dr As SqlDataReader = objCmd.ExecuteReader(CommandBehavior.CloseConnection)
            If dr.Read Then
                Session.Timeout = 1440
                Session("sortExpression2") = ""
                Session("sortDirection2") = ""
                Session("myDT") = Nothing
                Session("bucketUsername") = ""
                Session("editIndex") = -1
                Session("bucketUsername") = username
                Session("Activeuser") = dr.Item("Active")
                bLogout.Visible = True
                bChangePw.Visible = True
                Activeuser = 1
                ddlSubmitStatus.Enabled = True
                'ddlSubmitStatus2.Enabled = True
                If UCase(strquerystring) <> UCase(username) Then
                    Response.Redirect("https://esig.trustaff.com/trustaffportal/submittals/submittalBucketAm_TimRemote.aspx?actmgr=" + username)
                End If
                generateGV()
                GridView1.DataBind()
                myCounter = 0
                GridView1.Enabled = True
                Panel1.Enabled = True
                Dim sScript As New System.Text.StringBuilder
                Dim sScriptName As String = String.Empty
                sScript.Append("$(document).ready(function () {reloadFunctions();});")
                ScriptManager.RegisterStartupScript(Label13, GetType(Label), sScriptName, sScript.ToString, True)
            End If
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED IT'S a LOGIN ERROR! " & ex.Message
        End Try
    End Sub

    Protected Sub bLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles bLogout.Click
        Session("bucketUsername") = ""
        Panel1.Enabled = False
        bLogout.Visible = False
        bChangePw.Visible = False
        Response.Redirect(Request.RawUrl)
        ddlSubmitStatus.Enabled = False
        Activeuser = 0
        Session("Activeuser") = Nothing
        Session("sortExpression2") = Nothing
        Session("sortDirection2") = Nothing
    End Sub

    Protected Sub bChangePw_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles bChangePw.Click
        Response.Redirect("ChangePw.aspx")
    End Sub

    Protected Sub bLocal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles bLocal.Click
        Response.Redirect("https://esig.trustaff.com/trustaffportal/submittals/submittalBucketAm_TimRemote.aspx?actmgr=" & Request.QueryString("actmgr"))
    End Sub

    'added 9-19-12-ttw
    Function getRecList() As DBNull

        Try
            Dim myQuery As String = "Select name, user_email from userlist where recruiter=1 AND ACTIVE =1"
            Dim cn As New SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString)
            cn.Open()
            Dim cmd As New SqlClient.SqlCommand(System.Configuration.ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString, cn)
            cmd.CommandText = myQuery

            Dim reader As SqlClient.SqlDataReader = cmd.ExecuteReader()
            Dim myTable As DataTable = New DataTable

            myTable.Load(reader)
            reader.Close()
            Dim myListItem2 As ListItem = New ListItem
            Dim docEmails(myTable.Rows.Count - 1)() As String
            Dim myCounter As Integer = 0
            ddlRecruitersEmail.Items.Clear()
            'ddlFacilityViewCreate.Items.Clear()
            For Each myDataRow As DataRow In myTable.Rows
                myListItem2 = New ListItem
                myListItem2.Text = myDataRow("name")
                myListItem2.Value = myDataRow("user_email")
                ddlRecruitersEmail.Items.Add(myListItem2)

            Next
            Session("ddlRecruiters") = ddlRecruitersEmail
            reader.Close()
            cn.Close()
            cn.Dispose()
        Catch ex As Exception

            Label13.Visible = True
            Label13.Text = "An Unexpected ERROR HAS OCCURED Recruiter List ERROR! " & ex.Message

        End Try
        Return Nothing
    End Function
    Protected Sub LnkEdit_Click(sender As Object, e As EventArgs)
        Using row As GridViewRow = DirectCast(DirectCast(sender, LinkButton).Parent.Parent, GridViewRow)
            Dim pk As String = GridView1.DataKeys(row.RowIndex).Values(0).ToString()
            Gridviewnotes = TryCast(GridView1.Rows(row.RowIndex).FindControl("lNotes"), Label)
            lbbillrate = TryCast(GridView1.Rows(row.RowIndex).FindControl("lblbillrate"), Label)
            Dim substatus As DropDownList = TryCast(GridView1.Rows(row.RowIndex).FindControl("ddlSubmitStatus2"), DropDownList)
            Dim nurse As HyperLink = TryCast(GridView1.Rows(row.RowIndex).FindControl("hlEmail"), HyperLink)
            Dim nursename As String = ""
            txtnotes.Text = Gridviewnotes.Text
            txtbillrate.Text = Convert.ToString(lbbillrate.Text).Replace("$", String.Empty)
            SubID.Text = substatus.SelectedItem.Text
            ID.Value = CInt(pk.ToString())
            lblNurseName.Text = nurse.Text
            lblrecruiter.Text = row.Cells(9).Text
            lblam.Text = row.Cells(6).Text
            lblfacility.Text = row.Cells(4).Text
            lblspecialty.Text = row.Cells(7).Text
            LblFrontEnd.Text = row.Cells(10).Text
            nursename = row.Cells(25).Text
            LblDisplay.Text = nursename.ToUpper & " @ " & row.Cells(4).Text.ToUpper
            Activeuser = 1
            popup.Show()

        End Using

    End Sub
    Protected Sub Save_Click(sender As Object, e As EventArgs)
        Try
            txtnotes.Text = Replace(txtnotes.Text, "'", Chr(34))
            txtnotes.Text += Environment.NewLine + " * " + Mid(Session("usersName"), 1, 1) + Mid(Session("usersName"), InStr(Session("usersName"), " ") + 1, 1) + " {" + Date.Now.ToString("MMM, ddd d, h:mm tt") + "} * "
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim myConnection As New SqlConnection(connString)
            Dim sql As String = ""
            Dim objCmd As New SqlCommand(sql, myConnection)
            myConnection.Open()
            objCmd.CommandText = "UPDATE FacPackets SET Notes=@Notes,BillRate=@Billrate where FacpacketID=@FacpacketID "
            objCmd.CommandType = CommandType.Text
            objCmd.Parameters.AddWithValue("@Notes", txtnotes.Text)
            objCmd.Parameters.AddWithValue("@Billrate", txtbillrate.Text)
            objCmd.Parameters.AddWithValue("@FacpacketID", CInt(ID.Value))
            objCmd.ExecuteNonQuery()
            myConnection.Close()
            recemail(lblrecruiter.Text)
            frontend(LblFrontEnd.Text)
            Dim smtp As New SmtpClient("mail2.trustaff.com")
            Dim Mailmsg As New System.Net.Mail.MailMessage("Submittal@trustaff.com", "" + Session("actMgrEmail"))
            Dim copy As New MailAddress("ccherif@trustaff.com")
            'Mailmsg.CC.Add(copy)
            Mailmsg.CC.Add(dhrecemail.Value)
            If hdemail.Value = "" Or hdemail.Value = "None" Then
            Else
                Mailmsg.CC.Add(hdemail.Value)
            End If
            Mailmsg.Priority = Net.Mail.MailPriority.High
            Mailmsg.IsBodyHtml = True
            Mailmsg.Subject = "A Submittal Packet Has Been Updated For " + lblNurseName.Text
            Mailmsg.Headers.Add("X-Message-Flag", "Follow up")
            Mailmsg.Body = "<p><img src='https://esig.trustaff.com/trustaffportal/submittals/images/logo.jpg' width='206' height='64' /></p><h1>A Submittal Packet Has Been Updated.</h1><p>Name: " + lblNurseName.Text + "<br />Recruiter: " + lblrecruiter.Text + "<br />Facility: " + lblfacility.Text + "<br />Specialty: " + lblspecialty.Text + "<br />Status: " + SubID.Text + "<br />Account Manager: " + lblam.Text + "<br />Notes: " & txtnotes.Text & "<br /></p>"
            smtp.Send(Mailmsg)
            hdemail.Value = ""
            Activeuser = 1
            If Not IsNothing(Session("sortExpression2")) Or Not IsNothing(Session("sortDirection2")) Then
                GridView1.DataSource = Session("myDT")
                GridView1.DataBind()
                myCounter = 0
            Else
                GridView1.DataSource = Session("myDT")
                GridView1.DataBind()
                myCounter = 0

            End If
            upGridview.Update()
            Dim sScript As New System.Text.StringBuilder
            Dim sScriptName As String = String.Empty
            sScript.Append("javascript: window.location = window.location;")
            ScriptManager.RegisterClientScriptBlock(Page, GetType(String), sScriptName, sScript.ToString, True)
            GridView1.EditIndex = -1

        Catch ex As Exception
            Response.Write(ex.Message)
        End Try
    End Sub

    Private Sub frontend(frontEnd As String)
        Try
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim sql As String = "select User_Email from trustaff_Med.dbo.Userlist where Substring(Gm_Username,0,9) = SUBSTRING(@FrontEnd,0,9)"
            Dim conn As SqlConnection = Nothing
            Try
                conn = New SqlConnection(connString)
                Dim cmd As SqlCommand = New SqlCommand(sql, conn)
                With cmd
                    .CommandType = CommandType.Text
                    .Parameters.AddWithValue("@FrontEnd", frontEnd)
                End With
                conn.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                Dim dt As DataTable = New DataTable()
                dt.Load(dr)
                hdemail.Value = dt.Rows(0).Item("User_Email")
            Catch ex As SqlException
                Response.Write("Dont Work")
            Catch ex As Exception
                ' handle error
            Finally
                conn.Close()
            End Try
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected Error HAS OCCURED When retrieveing front end email " & ex.Message
        End Try
    End Sub
    Private Sub recemail(recmail As String)
        Try
            Dim connString As String = ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString
            Dim sql As String = "select User_Email from trustaff_Med.dbo.Userlist where Substring(Gm_Username,0,9) = SUBSTRING(@FrontEnd,0,9)"
            Dim conn As SqlConnection = Nothing
            Try
                conn = New SqlConnection(connString)
                Dim cmd As SqlCommand = New SqlCommand(sql, conn)
                With cmd
                    .CommandType = CommandType.Text
                    .Parameters.AddWithValue("@FrontEnd", recmail)
                End With
                conn.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                Dim dt As DataTable = New DataTable()
                dt.Load(dr)
                dhrecemail.Value = dt.Rows(0).Item("User_Email")
            Catch ex As SqlException
                Response.Write("Dont Work")
            Catch ex As Exception
                ' handle error
            Finally
                conn.Close()
            End Try
        Catch ex As Exception
            Label13.Visible = True
            Label13.Text = "An Unexpected Error HAS OCCURED When retrieveing front end email " & ex.Message
        End Try
    End Sub

    Protected Function SetVisibility(desc As Object, maxLength As Integer) As Boolean
        Dim notes = DirectCast(desc, String)
        If String.IsNullOrEmpty(notes) Then
            Return False
        End If
        Return notes.Length > maxLength
    End Function
    Protected Sub ReadMoreLinkButton_Click(sender As Object, e As EventArgs)
        Dim button As LinkButton = DirectCast(sender, LinkButton)
        Dim row As GridViewRow = TryCast(button.NamingContainer, GridViewRow)
        Dim descLabel As Label = TryCast(row.FindControl("lNotes"), Label)
        button.Text = If((button.Text = "Read More"), "Hide", "Read More")
        Dim temp As String = descLabel.Text
        descLabel.Text = descLabel.ToolTip
        descLabel.ToolTip = temp
    End Sub
    Protected Function Limit(desc As Object, maxLength As Integer) As String
        Dim notes = DirectCast(desc, String)
        If String.IsNullOrEmpty(notes) Then
            Return notes
        End If
        Return If(notes.Length <= maxLength, notes, notes.Substring(0, maxLength) + "...")
    End Function

    Private Sub ChangeColors()
        Response.Write("This was called!")
    End Sub
    Public Function ChangeRowColor(CandidateID As Integer) As Color
        Dim Conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString)
        Dim sql As String = ""
        Try
            sql = "Select Submitstatus from Facpackets where Submitstatus in (576,578,601,623) and CandidateID=@CandidateID "
            Dim Da As New SqlDataAdapter(sql, Conn)
            Da.SelectCommand.Parameters.AddWithValue("@CandidateID", CandidateID)
            Dim dt As New DataTable
            Conn.Open()
            Da.Fill(dt)
            Select Case dt.Rows.Count
                Case 0

                Case 1
                    Dim row As DataRow = dt.Rows(0)
                    Select Case Integer.Parse(row.Field(Of Integer)("Submitstatus"))
                        Case 576
                            ChangeRowColor = Color.Orange
                        Case 578
                            ChangeRowColor = Color.MediumPurple
                        Case 601
                            ChangeRowColor = Color.Orange
                        Case 623
                            ChangeRowColor = Color.BlanchedAlmond
                    End Select
            End Select
        Catch ex As Exception
            Conn.Close()
        End Try
        Return ChangeRowColor
    End Function

    Public Function GetCandidateID(FacpacketID As Integer) As Integer
        Dim Conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString)
        Dim sql As String = ""
        Try
            sql = "Select CandidateID from Facpackets where FacpacketID=@FacpacketID "
            Dim Da As New SqlDataAdapter(sql, Conn)
            Da.SelectCommand.Parameters.AddWithValue("@FacpacketID", FacpacketID)
            Dim dt As New DataTable
            Conn.Open()
            Da.Fill(dt)
            Select Case dt.Rows.Count
                Case 0

                Case 1
                    Dim row As DataRow = dt.Rows(0)
                    GetCandidateID = Integer.Parse(row.Field(Of Integer)("CandidateID"))
            End Select
        Catch ex As Exception
            Conn.Close()
        End Try
        Return GetCandidateID
    End Function

    Public Function GetCandidateIDStatus(candidateId As Integer) As Integer
        Dim Conn As New SqlConnection(ConfigurationManager.ConnectionStrings("Trustaff_MedConnectionString").ConnectionString)
        Dim sql As String = ""
        Try
            sql = "SELECT dbo.FacPackets.CandidateID,SubmitStatus " +
                "From dbo.FacPackets " +
                "INNER JOIN  dbo.CONTACT1 ON dbo.FacPackets.FacilityID = dbo.CONTACT1.id " +
                "INNER Join  dbo.CONTACT1 AS CONTACT1_1 ON dbo.FacPackets.CandidateID = CONTACT1_1.id " +
                "INNER JOIN  dbo.LookupValue AS LookupValue_1 ON dbo.FacPackets.SubmitStatus = LookupValue_1.LookupValueID " +
                "INNER Join  dbo.UserList On CONTACT1_1.U_KEY4 = SUBSTRING(dbo.UserList.GM_Username, 0, 9) " +
                "INNER JOIN  dbo.JobSpecialty ON dbo.FacPackets.Specialty = dbo.JobSpecialty.pk_SpecialtyID " +
                "WHERE(dbo.FacPackets.SubmitStatus In (578) And FacPackets.CandidateID = @CandidateId " +
                "AND  (dbo.FacPackets.AcctManager IS NULL) " +
                "AND  (dbo.FacPackets.ClosedDate > GETDATE() - 1)) GROUP BY FacPackets.CandidateID,SubmitStatus "
            Dim Da As New SqlDataAdapter(sql, Conn)
            Da.SelectCommand.Parameters.AddWithValue("@CandidateId", candidateId)
            Dim dt As New DataTable
            Conn.Open()
            Da.Fill(dt)
            Select Case dt.Rows.Count
                Case 0
                    candidateId = 0
                Case 1
                    Dim row As DataRow = dt.Rows(0)
                    candidateId = Integer.Parse(row.Field(Of Integer)("CandidateID"))
            End Select
        Catch ex As Exception
            Conn.Close()
        End Try
        Return candidateId
    End Function
End Class
