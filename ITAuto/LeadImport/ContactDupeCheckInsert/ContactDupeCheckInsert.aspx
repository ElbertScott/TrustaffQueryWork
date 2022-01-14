<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ContactDupeCheckInsert.aspx.cs" Inherits="TrustaffPortal_Submittals_ContactDupeCheckInsert" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Import Namespace="Microsoft.VisualBasic"%>
<%@ Import Namespace="Microsoft.VisualBasic.FileIO"%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
      <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
</asp:ToolkitScriptManager>
        <div style="font-family: Verdana; font-size: x-large; font-weight: bold; color: #FF0000; background-color: #000000">
            STOP! before you start, please read the following:
        </div>
        <div>
            <p>
                For <b>HJN CUSTOM</b> source: <br />
                your file can only contain the following columns:(THE ORDER IS VERY IMPORTANT)<br />
                Firstname<br />	
                Lastname<br />	
                Country	<br />
                State	<br />
                Locality (City)<br />	
                Phone	<br />
                Email	<br />
                Locations (state Long)	<br />
                Department	<br />
                Statelicenses	<br />
                Source<br />
                Please remove any extra columns before saving your file. 

            </p>
           
            <p>
                For <b>TNS Daty and ATC Daty</b> sources: <br />
                your file can only contain the following columns:(THE ORDER IS VERY IMPORTANT)<br />
                Firstname<br />	
                Lastname<br />	
                City	<br />
                State	<br />
                Zip <br />	
                Email	<br />
                Phone	<br />
                Record Type	<br />
                Statelicenses	<br />
                Dept1 <br />
                Dept2<br />
                Please remove any extra columns before saving your file. 

            </p>
             <p style="font-size: xx-large; font-weight: bold; color: #FF0000">
                PS. Your file must be a comma delimited file format (.CSV) 
            </p>
        </div>
 <div>
           <%-- <asp:UpdatePanel ID="pnlcontrols" runat="server" UpdateMode="Conditional" >
                <ContentTemplate>--%>
                    <div>Source Type:
                <asp:DropDownList ID="ddlChangeType" runat="server" AutoPostBack="true" Height="24px" Width="222px">
                                <asp:ListItem Value="-1">Select</asp:ListItem>
                                <asp:ListItem Value="HJN Custom">HJNCUSTOM</asp:ListItem>
                                <asp:ListItem Value="TNS Daty">TNSDATY</asp:ListItem>
                                <asp:ListItem Value="ATC Daty">ATCDATY</asp:ListItem>
                                <asp:ListItem Value="Gypsy Nurse">GYPSYNURSE</asp:ListItem>
                           </asp:DropDownList>
                                  <asp:RequiredFieldValidator ID="rfvchangetype" runat="server" ControlToValidate="ddlChangeType" ValidationGroup="AM" InitialValue="-1"
                                                ErrorMessage="Please Select Source Type" SetFocusOnError="true" >*</asp:RequiredFieldValidator>
                                                <asp:ValidatorCalloutExtender ID="vcechangetype" TargetControlID="rfvchangetype" runat="server">
                                                </asp:ValidatorCalloutExtender>
                </div>
                    <div>
                      Select username:  <asp:DropDownList ID="ddlUsers" runat="server" Width="222px"
                                        DataSourceID="SDSUSERS" AutoPostBack="true" DataTextField="Name" DataValueField="GMUsername" AppendDataBoundItems="true">
                                        <asp:ListItem></asp:ListItem>
                                        <asp:ListItem Value="-1">Select One</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvfrontEnd" runat="server" ControlToValidate="ddlUsers" ValidationGroup="AM"
                                        ErrorMessage="Please select a user" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                    <asp:ValidatorCalloutExtender ID="vceFrontEnd" TargetControlID="rfvfrontEnd" runat="server" />
                    </div>
                    <div>
                        Browse a file to upload:<asp:FileUpload ID="fuCSV" runat="server" />
                         <asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click" /> 
                     </div>
                    <div>
                        <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" ValidationGroup="AM"/>
                    </div>
                    <div>
                        <asp:Label ID="lblMessage" runat="server" Visible="false"/>
                    </div>
                    <div>
                        <asp:GridView ID="grvUpload" runat="server" >
                            <EmptyDataTemplate>
                                No Data Found
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                    <div>
                        A total Number of  <asp:Label ID="lblTotalNew" runat="server" /> are te be added to GM out of  <asp:Label ID="lbloriginalCount" runat="server" />
                    </div>

        <%--        </ContentTemplate>
             </asp:UpdatePanel>--%>
        <div>
            <asp:GridView ID="GrvNew" runat="server" >
                 <EmptyDataTemplate>
                    No New records found!!
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
        </div>
        <div>
            <asp:SqlDataSource ID="SDSUSERS" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:Trustaff_MedConnectionString %>" 
                            SelectCommand=" Select SUBSTRING(GM_Username,0,9) as GMUsername, [Name] from UserList where Department='Marketing' and active =1 ORDER BY [Name] " 
                            SelectCommandType="Text">
                            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
