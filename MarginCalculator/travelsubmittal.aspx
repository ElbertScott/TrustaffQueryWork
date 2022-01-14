<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TravelSubmittal.aspx.vb" Inherits="Esig.TravelSubmittal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Submit - New Facility</title>
 <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/jquery-ui.js" type="text/javascript"></script>
<link href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/themes/blitzer/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/formatNum.js" type="text/javascript">
    
    </script>
    <script  type="text/javascript">
        var mybuttonclicked = false;
        function Count() {
            var i = document.getElementById("txtComments").value.length;
            document.getElementById("lblcountremaining").innerHTML = 50 - i + " characters remaining";
        }

    </script>
    <style type="text/css">
        .style2 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: small;
            font-weight: bold;
            color: #FFFFFF;
            background-color:orange;
        }

        .style3 {
            width: 333px;
        }


        .style6 {
            font-family: Tahoma, Arial, Helvetica, sans-serif;
            font-size: small;
            font-weight: bold;
            color: #FF9900;
            width: auto;
            height: 26px;
        }

        .style9 {
            width: 155px;
        }

        .modalBackground {
            background-color: lightgray;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }

        .modalPopup {
            background-color: #ffffdd;
            border-width: 3px;
            border-style: solid;
            border-color: Gray;
            padding: 3px;
            width: 250px;
        }

        .auto-style1 {
            width: 800px;
        }

         .CreditCheck {
            width: 800px;
        }

        .Popup 
        {
            border-radius: 5px;
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            padding-top: 10px;
            padding-left: 10px;
            width: 500px;
            height: 220px;

        }

        .Background 
        {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }
         .lbl
        {
            border-radius: 5px;
            font-size:16px;
            font-style:italic;
            font-weight:bold;
            position: Absolute;
            width: 500px;
            height: 35px;
            background-color:crimson;
            left: 1px;
            top: 4px;
            text-align:justify;
            display: flex;
            flex-flow: row wrap;
           justify-content: center;
           align-content: center;
           align-items: center;
        }
         .rcorners 
        {
            border-radius: 3px;
            background-color:whitesmoke;
            padding: 20px; 
            width: 225px;
            height: 8px;
            font-weight:bold;
            position: Absolute;
            top: 165px;
            font-size:20px;
            text-align:justify;
            display: inline;
            flex-flow: row wrap;
            justify-content: center;
            align-content: center;
            align-items: center;
           
       }
            .BtnAlertcorners 
        {
            border-radius: 5px;
            background-color:whitesmoke;
            padding: 18px; 
            width: 60px;
            height: 5px;
            font-weight:bold;
            position: Absolute;
            left:220px;
            top: 185px;
            font-size:20px;
            text-align:justify;
            display: inline;
            flex-flow: row wrap;
            justify-content: center;
            align-content: center;
            align-items: center;
           
       }
            .rcornersEdit 
        {
            border-radius: 3px;
            background-color:whitesmoke;
            padding: 20px; 
            width: 220px;
            height: 5px;
            font-weight:bold;
            right: 40px;
            position: Absolute;
            top: 165px;
            font-size:20px;
            text-align:justify;
            display:inline;
            flex-flow: row wrap;
            justify-content: center;
            align-content: center;
            align-items: center;
       }

              .lblDisplay
        {
            font-size:20px;
            font-style:normal;
            font-family:Verdana;
            color:black;
            height:auto;
           position: Absolute;
            background-color:white;
            top: 50px;
            text-align:center;
        }
        .PanelDuplicate
        {
            border-radius: 5px;
        }
                .Popupalert

        {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            padding-top: 10px;
            padding-left: 10px;
            width: 400px;
            height: 350px;
        }
                 .Backgrd
        {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" onsubmit="if(mybuttonclicked == true){document.getElementById('Button1').style.visibility='hidden';document.getElementById('waitMe').style.visibility='visible'; }mybuttonclicked = false; return true;">
        <asp:Label ID="testlabel" runat="server" Text=""></asp:Label>
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddlShiftPreference" EventName="SelectedIndexChanged" />

<asp:AsyncPostBackTrigger ControlID="btnSelectJob" EventName="Click"></asp:AsyncPostBackTrigger>
<asp:AsyncPostBackTrigger ControlID="ddlShiftPreference" EventName="SelectedIndexChanged" ></asp:AsyncPostBackTrigger>
</Triggers>
            <ContentTemplate>
                

                     <table align="left" padding="1">
                                  <tr colspan="6">
                            <td valign="left">
                                <hr width="400" align="left" color="Grey" />
                                <asp:Label ID="Label3" runat="server" Font-Bold="False" Text="Selected Job:" 
                                    Width="90px" />
                                <asp:Label ID="LabelT" runat="server" Font-Bold="True"></asp:Label>
                                <br />
                                <asp:Label ID="Label4" runat="server" Text="Job ID:" Visible="False" 
                                    Width="250px" />
                                <asp:Label ID="LabelJobID" runat="server" Font-Bold="True" Visible="False"></asp:Label>
                                <asp:ListSearchExtender ID="ListSearchExtender1" runat="server" 
                                    promptcssclass="PromptCSS" targetcontrolid="ListBoxSelectJob">
                                </asp:ListSearchExtender>
                                <br />
                                <asp:ListBox ID="ListBoxSelectJob" runat="server" BackColor="Snow" 
                                    DataSourceID="SqlDataSource1" DataTextField="Job" 
                                    DataValueField="pk_JobRequestID" Font-Bold="True" Font-Names="Courier New" 
                                    ForeColor="DarkOrchid" Height="166px" SelectionMode="Multiple" Width="830px" >
                                </asp:ListBox>
                            </td>
                        </tr>
                        <caption>
                            <br />
                            <tr>
                                <td class="style9">
                                    <asp:Button ID="btnSelectJob" runat="server" Text="Select Job" OnClick="btnSelectJob_Click" />
                                </td
                            </tr>
                        </caption>

                                    </table>

                                    <br /><br /><br /><br /><br /><br /><br /><br />
                     <br />
                     <br />
                     <br />
                     <br />
                     <br />
                     <br /><br />
                <fieldset class="CreditCheck" runat="server" id="FsCreditCheck" visible="false">
                    <legend>Facility Credit Limit details</legend>
                <table>
                    <tr>
                        <td>
                            Total Max allowed Nurses:
                        </td>
                        <td>
                            <asp:Label ID="lblfacTotalMaxAllowed" runat="server" />
                        </td>
                    </tr>

                    <tr>
                        <td>
                            Current Total Nurses:
                        </td>
                        <td>
                            <asp:Label ID="lblFacTotalNurses" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Total Credit Limit amount:
                        </td>
                        <td>
                            <asp:Label ID="LblCreditLimitAmount" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                           Current Percent Placed:
                        </td>
                        <td>
                            <asp:Label ID="lblTotalPercent" runat="server" />
                        </td>
                    </tr>

                     <tr>
                        <td style="font-family:Impact, Haettenschweiler, 'Arial Narrow Bold', sans-serif; color:red" >
                           Credit notes:
                        </td>
                        <td>
                            <asp:Label ID="lblCreditNotes" runat="server" ForeColor="Red" />
                        </td>
                    </tr>
                </table>
                </fieldset>
                    <br /><br /><br />
                                    <fieldset class="auto-style1">
                    <legend>Nurse Details</legend>

                    <table align="left" border ="0" style="width:auto" padding="1">
                        <tr>
                            <td class="style2">
                                Candidate Name
                            </td>
                            <td>
                                <asp:Label ID="LabelContact" runat="server" Text="Candidate Name" Font-Bold="True" ></asp:Label>
                            </td>
                            </tr>
                            <tr>
                            <td class="style2">
                                Best Contact #
                            </td>
                            <td  width="50">
                                <asp:TextBox runat="server" ID="txtBestContactNumber"  MaxLength="14" Width="250px" ReadOnly="true"
                                    CssClass="textEntry" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
                            </td>
                         </tr>
                          <tr>
                             <td class="style2">
                                2 Contact #
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="Old"  MaxLength="14" Width="250px" ReadOnly="true"
                                    CssClass="textEntry" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
                            </td>
                        </tr>
                       <%-- <tr>
                            <td class="style2">
                                Swat Recruiter
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlSwat" runat="server" DataTextField="Name" DataValueField="EsigID" AppendDataBoundItems="true" Width="250px"  >
                                    <asp:ListItem Value="-1">Select one</asp:ListItem>
                                    <asp:ListItem Value="0">None</asp:ListItem>
                                </asp:DropDownList>
                                       <asp:RequiredFieldValidator ID="rfvswat" runat="server" ControlToValidate="ddlSwat" Display="none" InitialValue="-1" 
                                           SetFocusOnError="true" Text="*" ValidationGroup="Submittal" ErrorMessage="Swat not selected">
                                    </asp:RequiredFieldValidator>
                                          <asp:ValidatorCalloutExtender ID="VceSwat" runat="server" TargetControlID="rfvswat" />
                            </td>
                         </tr>--%>
                        <tr>
                            <td class="style2">
                                Profession
                            </td>
                            <td>
                                <asp:ListBox ID="ddlProfession" runat="server" DataSourceID="SqlDataSourceProfession" Width="250px"
                                    OnSelectedIndexChanged="ddlProfession_SelectedIndexChanged" DataTextField="ProfessionName" AutoPostBack="true" 
                                 AppendDataBoundItems="true"    DataValueField="pk_ProfessionID" 
                                    SelectionMode="Single" Height="61px">
                                </asp:ListBox>
                            </td>
                         </tr>
                        <tr>
                            <td class="style2">
                                Specialty
                            </td>
                            <td>
                                <asp:UpdatePanel ID="upUpdatePanel" runat="server">
                                    <ContentTemplate>
                                        <asp:ListBox ID="ddlSpecialty" runat="server"  Width ="250px" DataSourceID="SqlDataSourceSpecialty" 
                                             DataTextField="SpecialtyName" DataValueField="pk_SpecialtyID" SelectionMode="Single"> 
                                            <asp:ListItem Value="Other">Other</asp:ListItem>
                                      </asp:ListBox>  
                                         </td>
                                      <tr><td>
                                          <asp:RequiredFieldValidator ID="rfvspecialty" runat="server" ControlToValidate="ddlSpecialty" Display="none" SetFocusOnError="true" Text="Specialty not selected" ValidationGroup="Submittal">
                                    </asp:RequiredFieldValidator>
                                          <asp:ValidatorCalloutExtender ID="vceSpacialty" runat="server" TargetControlID="rfvspecialty" />
                                       <asp:TextBox ID="SpecialtyApplyingForOther" runat="server" Visible ="false"></asp:TextBox>
</td>
                       </tr>             </ContentTemplate>
                                    <Triggers>
                         <asp:AsyncPostBackTrigger ControlID="ddlProfession" EventName="SelectedIndexChanged" />
                                   </Triggers>
                               </asp:UpdatePanel>
                   </td></tr>
                        <tr>
                            <td class="style2">
                               Date Available
                            </td>
                            <td>

  <asp:TextBox ID="txtDateAvailable" runat="server" Width="250px"></asp:TextBox>
                                    <asp:CalendarExtender ID="txtDateAvailable_CalendarExtender" runat="server" 
                                        Enabled="True" TargetControlID="txtDateAvailable">
                                    </asp:CalendarExtender>
 <asp:RequiredFieldValidator ID="rfvstartdate" runat="server" Display="none" SetFocusOnError="true" Text="*" ErrorMessage="Date Available not selected." ControlToValidate="txtDateAvailable" ValidationGroup ="Submittal">
                                    </asp:RequiredFieldValidator>
                                <asp:ValidatorCalloutExtender ID="vceDateAvailable" runat="server" TargetControlID="rfvstartdate" />
                               </td>
                             <tr>
                                <td class="style2">
                                   Shift Preference
                                </td>
                                <td>
                                  <asp:DropDownList ID="ddlShiftPreference" runat="server" AutoPostBack="True" AppendDataBoundItems="true"
                                       DataSourceID="SDSShiftPref" DataTextField="ShiftPref" DataValueField="ShiftPref" 
                                    OnSelectedIndexChanged="ddlShiftPreference_SelectedIndexChanged" Width="250px">
                                    <asp:ListItem Value=""></asp:ListItem>
                                    </asp:DropDownList>
                                     <asp:SqlDataSource ID="SDSShiftPref" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:Trustaff_Med %>" 
                                SelectCommand="Usp_GetShiftsTypes" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="Shift" Name="GroupName" Type="String" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                                    <asp:RequiredFieldValidator ID="rfvshiftpref" runat="server" ControlToValidate="ddlShiftPreference" Display="none" ErrorMessage="Shift preference not selected." InitialValue="" SetFocusOnError="true" Text="*" ValidationGroup="Submittal">
                                    </asp:RequiredFieldValidator>
                                    <asp:ValidatorCalloutExtender ID="vceShiftPref" runat="server" TargetControlID="rfvshiftpref" />
                                <asp:TextBox ID="txtShiftPreferenceOther"  runat="server" Visible="False"></asp:TextBox>
                                </td>
                           </tr>
                           <tr>
                                <td class="style2">
                                    Term of Assignment
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlTermOfAssignment" runat="server" AutoPostBack="True" 
                                        OnSelectedIndexChanged="ddlTermOfAssignment_SelectedIndexChanged" Width="250px">
                                        <asp:ListItem>up to 13 Weeks</asp:ListItem>
                                        <asp:ListItem>up to 4 Weeks</asp:ListItem>
                                        <asp:ListItem>up to 8 Weeks</asp:ListItem>
                                        <asp:ListItem>up to 26 weeks</asp:ListItem>
                                        <asp:ListItem>up to 39 weeks</asp:ListItem>
                                        <asp:ListItem>up to 48 weeks</asp:ListItem>
                                        <asp:ListItem>Registry</asp:ListItem>
                                        <asp:ListItem Value="Other">Other</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:TextBox ID="TermOfAssignmentOther" runat="server" Visible="False"></asp:TextBox>
                                </td>
                                <tr>
                                <td class="style2">
                                   Time off
                            
                                </td>
                                        <td>
                                            <asp:TextBox ID="txtTimeOff" runat="server" MaxLength="49" Width="250px"></asp:TextBox>
                                        </td>
                                    </tr>
				    <tr>
                                <td class="style2">
                                   Best time to contact for interview
                            
                                </td>
                                        <td>
                                            <asp:TextBox ID="txtinterviewtime" runat="server" MaxLength="50" TextMode="MultiLine" Width="250px" Height="72px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ErrorMessage="This field is required" Display="none"
                                ValidationGroup="Submittal" ControlToValidate="txtinterviewtime" Text="*" runat="server" ForeColor="Red" />
                                            <asp:ValidatorCalloutExtender ID="vceInterviewtime" runat="server" TargetControlID="RequiredFieldValidator5" />
                                        </td>
                                    </tr>
                                     <tr>
                                    <td class="style2">
                                        Comments
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtComments" runat="server" Height="72px" TextMode="MultiLine" 
                                            Width="250px" onkeyup="Count()"></asp:TextBox><asp:Label ID="lblcountremaining" runat="server" forcolor="red" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ErrorMessage="This field is required" Text="*" Display="none" 
                                ValidationGroup="Submittal" ControlToValidate="txtComments" runat="server" ForeColor="Red"/>
                                        <asp:ValidatorCalloutExtender ID="vceComments" runat="server" TargetControlID="RequiredFieldValidator4" />
                           <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="txtComments" 
Display="Dynamic" ErrorMessage="Minimum 50 characters required" Text="Minimum 50 characters required" ValidationExpression="[\S\s]{50,}"    runat="Server" />
                                    </td>
                                   </tr><tr>
                                    <td class="style2">
                                        Notes for Admin
                                    </td>
                                    <td class="style3">
                                        <asp:TextBox ID="txtAdminNotes" runat="server" Height="73px" 
                                            TextMode="MultiLine" Width="250px"></asp:TextBox>
                                    </td>
                                   </tr><tr>
                                    <td class="style2">
                                        truStaff Company
                                    </td>
                                    <td class="style3">
                                        <asp:DropDownList ID="ddlTruStaffCompany" runat="server"  Width="250px">
                                            <asp:ListItem></asp:ListItem>
                                            <asp:ListItem Selected="True" Value="1">Travel</asp:ListItem>
                                            <asp:ListItem Value="5">Exec</asp:ListItem>
                                        </asp:DropDownList>
                                    </td></tr>
                                         <caption>
                                             <br />
                                             <tr>
                                                 <td class="style2">
                                                     Scl Include</td>
                                           
                                                 <td>
                                                     <asp:PlaceHolder ID="phNewSclForms" runat="server"></asp:PlaceHolder>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td class="style2">
                                                     <asp:TextBox ID="TextBox7" runat="server" Visible="False">0</asp:TextBox>
                                                 </td>
                                             </tr>
                                         </caption>
                                </tr>
                                </table>
                    <table>
                        <tr>
                            <td class="style6">
                                <asp:Label ID="Label2" runat="server" Visible="False"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </ContentTemplate>
       </asp:UpdatePanel>
          <asp:Panel ID="pnlIncompleteApp" runat="server" CssClass="modalPopup" style="display: none" >
  <div class="popup_Container">
  <div class="popup_Titlebar" id="DivHeader">STOP!</div>
  <div class="pupup_body">
  <asp:Label ID="LbllAppMessage" runat="server" Font-Bold="True" Height="350px"  ForeColor="Black" BackColor="#FF9900" />
</div>
 <div class="Popup_Buttons">
 <asp:Button ID="Button2" runat="server" Text="OK" />
  </div>
  </div>
 <asp:ModalPopupExtender ID="MPEIncompleteApp" runat="server"             
TargetControlID="LbllAppMessage"             
PopupControlID="pnlIncompleteApp"                          
 RepositionMode="RepositionOnWindowResizeAndScroll" 
   BackgroundCssClass="modalBackground"           
DropShadow="false" Drag="true"            
PopupDragHandleControlID="DivHeader"/>
        </asp:Panel>
    
   <asp:Panel ID="pnlDuplicatealert" runat="server" CssClass="Popup" style="display: none"  >
  <div>
  </div>
  <div class="pupup_body">
      <asp:Label ID="lblerrorAlert" runat="server" CssClass="lbl" Text="WARNING! DUPLICATE SUBMITTAL" Font-Size="Large" ForeColor="white"></asp:Label><br />
  <asp:Label ID="LblCatchErroralert" runat="server" CssClass="lblDisplay" Text="Your traveler has been submitted. You may go to candidate Submittals to edit or updates this sub." />
      <div>

     <hr style="" />
 <asp:Button ID="Btnalert" runat="server" CssClass="BtnAlertcorners" Text="OK" ToolTip=" I don't care what color, i just want to paint my walls!"  /> 
  </div> </div>

 <asp:ModalPopupExtender ID="MPEShowdupeAlert" runat="server"             
TargetControlID="LblCatchErroralert"             
PopupControlID="pnlDuplicatealert"                          
 RepositionMode="RepositionOnWindowResizeAndScroll" 
   BackgroundCssClass="Background"           
DropShadow="false" Drag="true"            
PopupDragHandleControlID="DivHeader" CancelControlID="Btnalert"/>
        </asp:Panel>  
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" SetFocusOnError ="true" runat="server" ControlToValidate ="ddlSpecialty" ValidationGroup="Specialties"  ErrorMessage ="Select a specialty!"></asp:RequiredFieldValidator>
                        <asp:Label runat="server" ID="lblJobError" Text="Please Select a trustaff job!" Visible ="false" ForeColor ="Red"></asp:Label>
         <asp:Button OnClientClick="mybuttonclicked = true" ID="BtnSave" runat="server" BackColor="ButtonShadow" Font-Bold="True" Font-Names="Arial"
                                    ForeColor="White" Text="Submit"  CausesValidation ="true" ValidationGroup ="Submittal" />
                                    <div id="waitMe" style="float: left; visibility:hidden; color:Red;">Wait while the form submits!!</div>
        <div id="dialog" style="display: none" align="center">
    Potential duplicate are you sure you want submit this nurse again to the same facility (not recomended)
</div>
          <div id="trMessage" runat="server" visible="false">          
                 <asp:Label ID="lblincomplete" runat="server" />           
         </div>
        <p>
            <asp:HiddenField ID="Recruiter" runat="server" />
			<asp:HiddenField ID="FrontEnd" runat="server" />
            <asp:HiddenField ID="ActMgr" runat="server" />
            <asp:HiddenField ID="Nurse" runat="server" />
            <asp:HiddenField ID="Facility" runat="server" />
            <asp:HiddenField ID="FacilityID" runat="server" />
            <asp:HiddenField ID="Cancelled" runat="server" />
            <asp:HiddenField ID="Fired" runat="server" />
            <asp:HiddenField ID="Hot" runat="server" />
            <asp:HiddenField ID="CancelledYes" runat="server" />
            <asp:HiddenField ID="FiredYes" runat="server" />
            <asp:HiddenField ID="HotYes" runat="server" />
            <asp:HiddenField ID="GMStatus" runat="server" />
            <asp:HiddenField ID="scl" runat="server" />
        </p>    
    
  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Trustaff_Med %>"
        SelectCommand="SELECT CONTACT1.COMPANY + ',' + CONTACT1.CITY + ',' + CONTACT1.[STATE] + ', ' + JobSpecialty.SpecialtyName  + ',  '+ ISNULL(RegistryPrivateID,'') AS Job, JobRequests_1.pk_JobRequestID, JobRequests_1.fk_StatusID, CONTACT1.ID, RegistryPrivateID FROM JobRequests AS JobRequests_1 INNER JOIN JobSpecialty ON JobRequests_1.fk_SpecialtyID = JobSpecialty.pk_SpecialtyID INNER JOIN CONTACT1 ON JobRequests_1.fk_ClientID = CONTACT1.ID INNER JOIN UserList UL ON  SUBSTRING(UL.GM_USERNAME,0,9) =   SUBSTRING(CONTACT1.KEY4 ,0,9) WHERE (JobRequests_1.fk_ProfessionID In( 1,2,3,13,14,18,20,33,12,9)) AND (JobRequests_1.fk_StatusID = 1) AND (NOT (CONTACT1.COMPANY + JobSpecialty.SpecialtyName IS NULL)) OR (JobRequests_1.fk_StatusID = 6)  AND (NOT (CONTACT1.COMPANY + JobSpecialty.SpecialtyName IS NULL)) AND CONTACT1.KEY4 != 'ACCOUNTING' ORDER BY CONTACT1.COMPANY + JobSpecialty.SpecialtyName" />
     <asp:SqlDataSource ID="SqlDataSourceSpecialty" runat="server" ConnectionString="<%$ ConnectionStrings:Trustaff_Med %>"
        SelectCommand="SELECT pk_SpecialtyID, SpecialtyName FROM JobSpecialty WHERE (Active = 1) AND fk_ProfessionID in(1,2,3,13,14,15,20,18,33,12,9) ORDER BY SpecialtyName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceProfession" runat="server" ConnectionString="<%$ ConnectionStrings:Trustaff_Med %>"
        SelectCommand="SELECT [pk_ProfessionID], [ProfessionName] FROM [JobProfessions] WHERE pk_ProfessionID In(1,2,3,4,13,14,20,15,33,18,12,9) ORDER BY [ProfessionName]">
    </asp:SqlDataSource>


  
                       
   Today's Submittals
    <asp:GridView ID="GridView2" runat="server" AllowSorting="True" 
        AutoGenerateColumns="False" DataKeyNames="FacPacketID" 
        DataSourceID="SqlDataSource3" Width="785px">
        <RowStyle Font-Names="Arial" Font-Size="Small" />
        <Columns>
            <asp:BoundField DataField="COMPANY" HeaderText="Facility" 
                SortExpression="COMPANY" />
            <asp:BoundField DataField="ShortDesc" HeaderText="Specialty" 
                SortExpression="ShortDesc" />
            <asp:BoundField DataField="SubmittalStatus" HeaderText="Status" 
                SortExpression="SubmittalStatus" />
            <asp:BoundField DataField="RequestDate" HeaderText="Submittal Requested" 
                SortExpression="RequestDate" />

                  <asp:HyperLinkField DataNavigateUrlFields="FacPacketID,CandidateID" 
                DataNavigateUrlFormatString="submit_edit.aspx?FacPacketID={0}&CandidateID={1}" 
                NavigateUrl="~/submit_edit.aspx" Target="_blank" Text="Edit" />
           </Columns>
        <HeaderStyle BackColor="BlueViolet" Font-Bold="True" Font-Names="Arial" 
            Font-Size="Small" ForeColor="WHITE" />
        <AlternatingRowStyle BackColor="#CCCCCC" />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
        ConnectionString="<%$ ConnectionStrings:Trustaff_Med %>"       
        
        SelectCommand="SELECT CONTACT1.COMPANY, FacPackets.RequestDate, FacPackets.FacPacketID, FacPackets.CandidateID, 
FacPackets.RequestID, FacPackets.ClosedDate, DATEDIFF(minute, GETDATE(), FacPackets.RequestDate) 
AS ElaspedTime, LookupValue_1.ShortDesc 
AS SubmittalStatus, FacPackets.Notes, JobSpecialty.SpecialtyName AS ShortDesc 
FROM FacPackets INNER JOIN CONTACT1 ON FacPackets.FacilityID = CONTACT1.id INNER JOIN LookupValue 
AS LookupValue_1 ON FacPackets.SubmitStatus = LookupValue_1.LookupValueID INNER JOIN JobSpecialty 
ON FacPackets.Specialty = JobSpecialty.pk_SpecialtyID 
WHERE (FacPackets.CandidateID = @CandidateID) AND  CONVERT (VARCHAR, RequestDate,101) = CONVERT (VARCHAR,GETDATE () ,101)  
ORDER BY FacPackets.RequestDate DESC

select  CONVERT (VARCHAR,GETDATE (), 101)">
        <SelectParameters>
            <asp:QueryStringParameter QueryStringField="CandidateID"  Name="CandidateID" />
        </SelectParameters>
    </asp:SqlDataSource>
 
    <asp:Panel ID="PnlHeader" runat="server" Width="800px">
        Manage Submittals
  <asp:Image ImageUrl="~/TrustaffPortal/images/Expand.jpg"   runat="server" id="imgcolp" /> 
    </asp:Panel>
<asp:Panel runat="server" ID="PnlSubmittals" GroupingText="Submittals" 
        Width="800px" >
    
   <asp:GridView ID="GridView3" runat="server" AllowSorting="True" 
        AutoGenerateColumns="False" DataKeyNames="FacPacketID" 
        DataSourceID="SqlDataSource2" Width="785px">
        <RowStyle Font-Names="Arial" Font-Size="Small" />
        <Columns>
            <asp:BoundField DataField="COMPANY" HeaderText="Facility" 
                SortExpression="COMPANY" />
            <asp:BoundField DataField="ShortDesc" HeaderText="Specialty" 
                SortExpression="ShortDesc" />
            <asp:BoundField DataField="SubmittalStatus" HeaderText="Status" 
                SortExpression="SubmittalStatus" />
            <asp:BoundField DataField="RequestDate" HeaderText="Submittal Requested" 
                SortExpression="RequestDate" />

                  <asp:HyperLinkField DataNavigateUrlFields="FacPacketID,CandidateID" 
                DataNavigateUrlFormatString="submit_edit.aspx?FacPacketID={0}&CandidateID={1}" 
                NavigateUrl="~/submit_edit.aspx" Target="_blank" Text="Edit" />
                 <asp:HyperLinkField DataNavigateUrlFields="FacPacketID,CandidateID" 
                DataNavigateUrlFormatString="submit_edit.aspx?FacPacketID={0}&CandidateID={1}&Mode=Copy" 
                NavigateUrl="~/submit_reopen.aspx" Target="_blank" Text="Reopen" />
                     
       </Columns>
        <HeaderStyle BackColor="#a383c2" Font-Bold="True" Font-Names="Arial" 
            Font-Size="Small" ForeColor="WHITE" />
        <AlternatingRowStyle BackColor="#CCCCCC" />
    </asp:GridView>
    </asp:Panel>

    <asp:CollapsiblePanelExtender ID="CollapsiblePanelExtender1"
runat="server"
CollapseControlID="PnlHeader"
ExpandControlID="PnlHeader"
TargetControlID="PnlSubmittals" ImageControlID="imgcolp"  SuppressPostBack="True"
Collapsed="true" CollapsedText="Details" ExpandedText="Hide" ExpandDirection="Vertical" CollapsedImage="Collapse.jpg" ExpandedImage="Expand.jpg" >
</asp:CollapsiblePanelExtender>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
        ConnectionString="<%$ ConnectionStrings:Trustaff_Med %>"       
           SelectCommand="SELECT CONTACT1.COMPANY, FacPackets.RequestDate, FacPackets.FacPacketID, FacPackets.CandidateID, 
FacPackets.RequestID, FacPackets.ClosedDate, DATEDIFF(minute, GETDATE(), FacPackets.RequestDate) 
AS ElaspedTime, LookupValue_1.ShortDesc 
AS SubmittalStatus, FacPackets.Notes, JobSpecialty.SpecialtyName AS ShortDesc 
FROM FacPackets INNER JOIN CONTACT1 ON FacPackets.FacilityID = CONTACT1.id INNER JOIN LookupValue 
AS LookupValue_1 ON FacPackets.SubmitStatus = LookupValue_1.LookupValueID INNER JOIN JobSpecialty 
ON FacPackets.Specialty = JobSpecialty.pk_SpecialtyID 
WHERE (FacPackets.CandidateID = @CandidateID)  
ORDER BY FacPackets.RequestDate DESC ">
        <SelectParameters>
            <asp:QueryStringParameter QueryStringField="CandidateID"  Name="CandidateID" />
        </SelectParameters>
    </asp:SqlDataSource>
        <div>
           <asp:Panel ID="pnlDuplicate" runat="server" CssClass="Popup" style="display: none"  >

  <div >
      <asp:Label ID="Label7" runat="server" CssClass="lbl" Text="WARNING! DUPLICATE SUBMITTAL" Font-Size="Large" ForeColor="white"></asp:Label><br />
  <asp:Label ID="LblCatchError" runat="server" CssClass="lblDisplay" Text="It looks like you have submitted this traveler to the same facility with the same specialty over the past three days, we suggest you click on Edit submittal button below to edit." />
      <div>
     <hr style="" />
 <asp:Button ID="Button4" runat="server" CssClass="rcorners" Text="Proceed anyway!" OnClick="Button4_Click" ToolTip=" I don't care what color, i just want to paint my walls!"  /> 
 <asp:Button ID="Button5" runat="server" CssClass="rcornersEdit" Text="Edit submittal" ToolTip="Great thinking!" OnClick="Button5_Click" />
 </div> </div>

 <asp:ModalPopupExtender ID="MPEShowdupe" runat="server"             
TargetControlID="LblCatchError"             
PopupControlID="pnlDuplicate"                          
 RepositionMode="RepositionOnWindowResizeAndScroll" 
   BackgroundCssClass="Background"           
DropShadow="false" Drag="true" />
        </asp:Panel>  
</div>
         <div>
            <asp:Label ID="lblmylabel"  runat="server" Text="" />
            <asp:ModalPopupExtender ID="ModalPopupExtender1" runat="server" PopupControlID="Pnlshowme" TargetControlID="lblmylabel" DropShadow="true"
    CancelControlID="Button6" BackgroundCssClass="Backgrd"></asp:ModalPopupExtender>
    <asp:Panel ID="Pnlshowme" runat="server" CssClass="Popupalert" align="center" style = "display:none">
    <iframe style=" width: 350px; height: 300px;" id="irm1"  src="../FormAlerts/DuplicateAlert.aspx" runat="server"></iframe>
   <br/>
    <asp:Button ID="Button6" runat="server" Text="Continue" />
</asp:Panel>
        </div>
    </form>
</body>
</html>
