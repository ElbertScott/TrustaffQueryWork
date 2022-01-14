using System;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;
using Microsoft.VisualBasic.FileIO;
using System.Text.RegularExpressions;
using System.Security.Cryptography;

public partial class TrustaffPortal_Submittals_ContactDupeCheckInsert :  System.Web.UI.Page
{
    private static Regex digitsOnly = new Regex(@"[^\d]");
    public static string CleanPhone(string phone)
    {
        return digitsOnly.Replace(phone, "");
    }

    public static string CreateRandomPassword(int Length)
    {
        string _Chars = "ABCDEFGHJKLMNOPQRSTUVWXYZ[_@!$#+&*?";
        Byte[] randomBytes = new Byte[Length];
        var rng = new RNGCryptoServiceProvider();
        rng.GetBytes(randomBytes);
        var chars = new char[Length];
        int Count = _Chars.Length;
        for (int i = 0; i < Length; i++)
        {
            chars[i] = _Chars[(int)randomBytes[i] % Count];
        }
        return new string(chars);
    }
    public static string CreaterandomNumber(int length)
    {
        while (true)
        {
            var pass = CreateRandomPassword(length);
            
            int upper = 0, special = 0, lower = 0;
            foreach (var c in pass)
            {
                if (c > 'A' && c < 'Z')
                {
                    upper++;
                }
                else if (c > 'a' && c < 'z')
                {
                    lower++;
                }
                //else if (c > '0' && c < '9')
                //{
                //    num++;
                //}
                else
                {
                    special++;
                }
            }
            if (upper >= 2 && 1 >= special)
            {
                return  pass;
            }
        }
    }
    public static string RandomString(int size)
    {
        var allowedChars = "1,2,3,4,5,6,7,8,9,0";
        var arr = allowedChars.Split(',');
        var passwordString = "";
        var rand = new Random();

        char ch;
        for (var i = 0; i < size; i++)
        {
            ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * rand.NextDouble() + 65)));
            passwordString += ch;
        }
        return passwordString;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    private void BindDataCSV(string filepath)
    {
        GoldMine GM = new GoldMine();
        DataTable dt = new DataTable();
        string[] Lines = File.ReadAllLines(filepath);
        try
        {
            if (Lines.Length > 0)
            {
                string firstLine = Lines[0];
                string[] headerlables = firstLine.Split(',');
                foreach (string Headerword in headerlables)
                {
                    dt.Columns.Add(new DataColumn(Headerword));
                }
                for (int r = 1; r < Lines.Length; r++)
                {
                    TextFieldParser parser = new TextFieldParser(new StringReader(Lines[r]));
                    parser.HasFieldsEnclosedInQuotes = true;
                    parser.SetDelimiters(",");
                    string[] fields;
                    DataRow dr = dt.NewRow();
                    while (!parser.EndOfData)
                    {
                        fields = parser.ReadFields();
                       for (int i = 0; i < fields.Length; i++)
                        {
                            foreach (string headerwords in headerlables)
                            {
                                if (headerlables.ToString() == "")
                                {
                                    dr[headerwords] = GoldMine.FormatPhone(fields[i++]);
                                }
                                else
                                {
                                 dr[headerwords] = fields[i++];
                                }                                
                            }
                        }                  
                        dt.Rows.Add(dr);
                        parser.Close();
                    }
                }
            }
                if (dt.Rows.Count > 0)
                {
                lbloriginalCount.Text = dt.Rows.Count.ToString();
                grvUpload.DataSource = dt;
                    grvUpload.DataBind();
                }
DataTable dtnew = new DataTable();
            if (ddlChangeType.SelectedValue == "HJN Custom")
            {
                dtnew.Columns.AddRange(new DataColumn[14] { new DataColumn("Name", typeof(string)),
                    new DataColumn("FirstName", typeof(string)),
                    new DataColumn("LastName", typeof(string)),
                    new DataColumn("Email", typeof(string)),
                    new DataColumn("Phone", typeof(string)),
                    new DataColumn("Locality", typeof(string)),
                    new DataColumn("State", typeof(string)),
                    new DataColumn("Position", typeof(string)),
                    new DataColumn("JobTitle", typeof(string)),
                    new DataColumn("RecordType", typeof(string)),
                    new DataColumn("Specialty", typeof(string)),
                    new DataColumn("KEY4", typeof(string)),
                    new DataColumn("Source", typeof(string)),
                    new DataColumn("Department",typeof(string)) });
                foreach (GridViewRow row in grvUpload.Rows)
                {
                    string name = (row.Cells[0].Text + " " + row.Cells[1].Text);
                    string FirstName = row.Cells[0].Text.ToString().Replace("&nbsp;", "");
                    string LastName = row.Cells[1].Text.ToString().Replace("&nbsp;", "");
                    string Locality = row.Cells[4].Text.ToString().Replace("&nbsp;", "");
                    string State = row.Cells[3].Text.ToString().Replace("&nbsp;", "");
                    string Phone = GoldMine.FormatPhone(CleanPhone(row.Cells[5].Text.ToString().Replace("&nbsp;", "")));
                    string email = row.Cells[6].Text.ToString().Replace("&nbsp;", "");
                    string Department = row.Cells[8].Text.ToString().Replace("&nbsp;", "").Replace("&#39;", "'").Replace("Administration", "Admin");
                    string Specialty = row.Cells[7].Text.ToString().Replace("&nbsp;", "");
                    string Position = row.Cells[7].Text.ToString().Replace("&nbsp;", "");
                    string JobTitle = "RN";
                    string RecordType = "RN";
                    string KEY4 = "ANDREW";
                    string Source = ddlChangeType.SelectedValue;
                    if ((row.Cells[2].Text == "US"))
                    {
                        dtnew.Rows.Add(name, FirstName, LastName, email, Phone, Locality, State, Position, JobTitle, RecordType, Specialty, KEY4, Source, Department);
                    }
                }
            }
            if (ddlChangeType.SelectedValue == "Gypsy Nurse")
            {
                dtnew.Columns.AddRange(new DataColumn[12] { new DataColumn("Name", typeof(string)),
                    new DataColumn("FirstName", typeof(string)),
                    new DataColumn("LastName", typeof(string)),
                    new DataColumn("Phone", typeof(string)),
                    new DataColumn("Email", typeof(string)),
                    new DataColumn("Status", typeof(string)),
                    new DataColumn("Department",typeof(string)),
                    new DataColumn("JobTitle", typeof(string)),
                    new DataColumn("ContactTime", typeof(string)),
                    new DataColumn("Timezone", typeof(string)),
                    new DataColumn("Key4", typeof(string)),
                    new DataColumn("AvailableDates", typeof(string))});
                foreach (GridViewRow row in grvUpload.Rows)
                {
                    string name = (row.Cells[0].Text + " " + row.Cells[1].Text);
                    string FirstName = row.Cells[0].Text.ToString().Replace("&nbsp;", "");
                    string LastName = row.Cells[1].Text.ToString().Replace("&nbsp;", "");
                    string email = row.Cells[3].Text.ToString().Replace("&nbsp;", ""); //5
                    string Phone = GoldMine.FormatPhone(CleanPhone(row.Cells[2].Text.ToString().Replace("&nbsp;", ""))); //6
                    string JobTitle = row.Cells[6].Text.ToString().Replace("&nbsp;", "");
                    string ContactTime =row.Cells[7].Text.ToString().Replace("&nbsp;", "");
                    string Timezone = row.Cells[8].Text.ToString().Replace("&nbsp;", "");
                    string Status = "Can.Lead";
                    string AvailableDates =  row.Cells[9].Text.ToString().Replace("&nbsp;", "");
                    //string License = "";// row.Cells[8].Text.ToString().Replace("&nbsp;", "");
                    string KEY4 = "ANDREW";
                    string Source = ddlChangeType.SelectedValue;
                    string Department = row.Cells[5].Text.ToString().Replace("&nbsp;", "").Replace("&#39;", "'").Replace("Administration", "Admin");// + " " + row.Cells[10].Text.ToString().Replace("&nbsp;", "").Replace("&#39;", "'").Replace("Administration", "Admin");
                    dtnew.Rows.Add(name, FirstName, LastName, Phone,email, Status,Department, JobTitle, ContactTime, Timezone,  KEY4, AvailableDates);
                }

                //new DataColumn("RecordType", typeof(string)),
                //    new DataColumn("Specialty", typeof(string)),
                //    new DataColumn("KEY4", typeof(string)),
            }
            else
            {
                if (dtnew.Rows.Count < 0)
                { 
                 dtnew.Columns.AddRange(new DataColumn[14] { new DataColumn("Name", typeof(string)),
                    new DataColumn("FirstName", typeof(string)),
                    new DataColumn("LastName", typeof(string)),
                    new DataColumn("Email", typeof(string)),
                    new DataColumn("Phone", typeof(string)),
                    new DataColumn("Locality", typeof(string)),
                    new DataColumn("State", typeof(string)),
                    new DataColumn("ZIP", typeof(string)),
                    new DataColumn("Status", typeof(string)),
                    new DataColumn("RecordType", typeof(string)),
                    new DataColumn("License", typeof(string)),
                    new DataColumn("KEY4", typeof(string)),
                    new DataColumn("Source", typeof(string)),
                    new DataColumn("Department",typeof(string)) });
                foreach (GridViewRow row in grvUpload.Rows)
                {
                    string name = (row.Cells[0].Text + " " + row.Cells[1].Text);
                    string FirstName = row.Cells[0].Text.ToString().Replace("&nbsp;", "");
                    string LastName = row.Cells[1].Text.ToString().Replace("&nbsp;", "");
                    string email = row.Cells[3].Text.ToString().Replace("&nbsp;", ""); //5
                    string Phone = GoldMine.FormatPhone(CleanPhone(row.Cells[2].Text.ToString().Replace("&nbsp;", ""))); //6
                    string Locality = "";// row.Cells[2].Text.ToString().Replace("&nbsp;", "");
                    string State = row.Cells[3].Text.ToString().Replace("&nbsp;", "");
                    string Zip = row.Cells[4].Text.ToString().Replace("&nbsp;", "");
                    string Status = "Can.Lead";
                    string RecordType = row.Cells[7].Text.ToString().Replace("&nbsp;", "");
                    string License = row.Cells[8].Text.ToString().Replace("&nbsp;", "");
                    string KEY4 = "ANDREW";
                    string Source = ddlChangeType.SelectedValue;
                    string Department = row.Cells[9].Text.ToString().Replace("&nbsp;", "").Replace("&#39;", "'").Replace("Administration", "Admin") + " " + row.Cells[10].Text.ToString().Replace("&nbsp;", "").Replace("&#39;", "'").Replace("Administration", "Admin");
                    dtnew.Rows.Add(name, FirstName, LastName, email, Phone, Locality, State, Zip, Status, RecordType, License, KEY4, Source, Department);
                }               
                }
               
            }
            DataTable dtnewRecord = new DataTable();
            if (dtnew.Rows.Count > 0)
            {
                GoldMine g = new GoldMine();
                int ddlType;
                if (ddlChangeType.SelectedValue == "Gypsy Nurse")
                {
                    ddlType = 1;
                }
                else
                {
                    ddlType = 2;
                }
                dtnewRecord = g.GetDTDNY(dtnew,ddlType);
                grvUpload.Visible = false;
            }
            lblTotalNew.Text = dtnewRecord.Rows.Count.ToString();
            GrvNew.DataSource = dtnewRecord;
            GrvNew.DataBind();
        }
        catch (Exception ex)
        {
            lblMessage.Visible = true;
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = ex.Message;
        }
    }
    protected void btnupload_Click(object sender, EventArgs e)
    {
        try
        {
            string CSVFilePath = Server.MapPath("~/Uploads/") + Path.GetFileName(fuCSV.PostedFile.FileName);
            if (File.Exists(CSVFilePath))
            {
                File.Delete(CSVFilePath);
            }
            fuCSV.SaveAs(CSVFilePath);
            BindDataCSV(CSVFilePath);      
        }
        catch (Exception ex)
        {
            lblMessage.Visible = true;
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = ex.Message;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        GoldMine GM = new GoldMine();
        FacilityChange FacChange = new FacilityChange();
        GoldMine.GoldmineRecord GMRecord = new GoldMine.GoldmineRecord();
        GoldMine.Contsupp Contsupp = new GoldMine.Contsupp();
        string currentTime = DateTime.Now.ToString("HH:mm");
        string month = DateTime.Now.ToString("MM");
        string Day = DateTime.Now.ToString("dd");
        string dateValue = DateTime.Now.ToString("mmfff");
        string stryear = DateTime.Now.ToString("yyyy");
        var dateAndTime = DateTime.Now;
        var date = dateAndTime.Date;
        try
        {
            if (ddlChangeType.SelectedValue == "HJN Custom")
            { 
            foreach (GridViewRow row in GrvNew.Rows)
            {               
                GMRecord.CONTACT = row.Cells[0].Text;
                GMRecord.LASTNAME = row.Cells[2].Text;
                    string sbfirstname = "";
                    if (row.Cells[1].Text.Length <= 2)
                    {
                        sbfirstname = row.Cells[1].Text.ToString();
                    }
                    else
                    {
                        sbfirstname = row.Cells[1].Text.Substring(0, 3);
                    }
                    GMRecord.ACCOUNTNO = "B" + stryear.Substring(stryear.Length -1) + month + Day + dateValue + (FacChange.RandomString(4, true) + sbfirstname).ToUpper() ;
                if (row.Cells[13].Text.Length >= 35)
                {
                    GMRecord.DEPARTMENT = row.Cells[13].Text.ToString().Replace("&nbsp;", "").Substring(0, 34).Trim();
                }
                else
                {
                    GMRecord.DEPARTMENT = row.Cells[13].Text.ToString().Replace("&nbsp;", "");
                }              
                GMRecord.TITLE = row.Cells[8].Text;
                GMRecord.PHONE = row.Cells[4].Text;
                GMRecord.CITY = row.Cells[5].Text;
                GMRecord.STATE = row.Cells[6].Text;
                GMRecord.ZIP = "";
                GMRecord.COMPANY = "";
                GMRecord.SOURCE = row.Cells[12].Text;
                GMRecord.KEY1 = row.Cells[8].Text; 
                GMRecord.KEY2 = "Can. Lead";
                GMRecord.KEY4 = row.Cells[11].Text;
                GMRecord.STATUS = " 0";
                GMRecord.CREATEBY = ddlUsers.SelectedValue;
                GMRecord.CREATEON = date;
                GMRecord.CREATEAT = currentTime.ToString();
                GMRecord.OWNER = "";
                GMRecord.LASTUSER = ddlUsers.SelectedValue;
                GMRecord.LASTDATE = date;
                GMRecord.LASTTIME = currentTime.ToString();
                GMRecord.U_COMPANY = "";
                GMRecord.U_CONTACT = row.Cells[0].Text.ToUpper();
                GMRecord.U_LASTNAME = row.Cells[2].Text.ToUpper();
                GMRecord.U_CITY = row.Cells[5].Text.ToUpper();
                GMRecord.U_STATE = row.Cells[6].Text.ToUpper();
                GMRecord.U_COUNTRY = "";
                GMRecord.U_KEY1 = row.Cells[11].Text.ToUpper(); 
                GMRecord.U_KEY2 = "CAN.LEAD";
                GMRecord.U_KEY3 = "";
                GMRecord.U_KEY4 = row.Cells[11].Text.ToUpper();
                GMRecord.U_KEY5 = "";
                GMRecord.RECID = FacChange.RandomString(9, true);
                GM.InsertContactRecord(GMRecord);
                
                Contsupp.ACCOUNTNO = GMRecord.ACCOUNTNO;
                Contsupp.RECTYPE = "P";
                Contsupp.CONTACT = "E-mail Address";
                Contsupp.CONTSUPREF = row.Cells[3].Text.ToString().Replace("&nbsp;", "");
                Contsupp.ADDRESS2 = "";
                Contsupp.CITY = GMRecord.LASTUSER + DateTime.Now.ToString();
                Contsupp.ZIP = "011";
                Contsupp.LASTUSER = GMRecord.LASTUSER;
                Contsupp.LASTDATE = GMRecord.LASTDATE;
                Contsupp.LASTTIME = GMRecord.LASTTIME;
                Contsupp.U_CONTACT = Contsupp.CONTACT.ToUpper();
                Contsupp.U_CONTSUPREF = row.Cells[3].Text.ToString().Replace("&nbsp;", "").ToUpper();
                Contsupp.U_ADDRESS = "";
                Contsupp.recid = FacChange.RandomString(9, true);
                GM.InsertContactRecordSupp(Contsupp);                              
            }
            }

            if (ddlChangeType.SelectedValue == "Gypsy Nurse")
            {
                foreach (GridViewRow row in GrvNew.Rows)
                {
                    GMRecord.CONTACT = row.Cells[0].Text ;
                    GMRecord.LASTNAME = row.Cells[2].Text;
                    string sbfirstname = "";
                    if (row.Cells[0].Text.Length <= 2)
                    {
                        sbfirstname = row.Cells[0].Text.ToString();
                    }
                    else
                    {
                        sbfirstname = row.Cells[0].Text.Substring(0, 3);
                    }
                    GMRecord.ACCOUNTNO = "B" + stryear.Substring(stryear.Length - 1) + month + Day + dateValue + (FacChange.RandomString(4, true) + sbfirstname).ToUpper();
                    //if (row.Cells[13].Text.Length >= 35)
                    //{
                    //    GMRecord.DEPARTMENT = row.Cells[13].Text.ToString().Replace("&nbsp;", "").Substring(0, 34).Trim();
                    //}
                    //else
                    //{
                    //    GMRecord.DEPARTMENT = row.Cells[13].Text.ToString().Replace("&nbsp;", "");
                    //}
                    GMRecord.DEPARTMENT = row.Cells[6].Text.ToString().Replace("&nbsp;", ""); ;
                    GMRecord.TITLE = row.Cells[7].Text;
                    GMRecord.PHONE = row.Cells[4].Text;
                    GMRecord.CITY = "";// row.Cells[5].Text;
                    GMRecord.STATE = "";// row.Cells[6].Text;
                    GMRecord.ZIP = "";
                    GMRecord.COMPANY = "";
                    GMRecord.SOURCE = "Gypsy Nurse"; // row.Cells[12].Text;
                    GMRecord.KEY1 = "";// row.Cells[8].Text;
                    GMRecord.KEY2 = "Can. Lead";
                    GMRecord.KEY4 = "Andrew";// row.Cells[11].Text;
                    GMRecord.STATUS = " 0";
                    GMRecord.CREATEBY = ddlUsers.SelectedValue;
                    GMRecord.CREATEON = date;
                    GMRecord.CREATEAT = currentTime.ToString();
                    GMRecord.OWNER = "";
                    GMRecord.LASTUSER = ddlUsers.SelectedValue;
                    GMRecord.LASTDATE = date;
                    GMRecord.LASTTIME = currentTime.ToString();
                    GMRecord.U_COMPANY = "";
                    GMRecord.U_CONTACT = row.Cells[0].Text.ToUpper() ;
                    GMRecord.U_LASTNAME = row.Cells[2].Text.ToUpper();
                    GMRecord.U_CITY = "";// row.Cells[5].Text.ToUpper();
                    GMRecord.U_STATE = "";//row.Cells[6].Text.ToUpper();
                    GMRecord.U_COUNTRY = "";
                    GMRecord.U_KEY1 = "";// row.Cells[11].Text.ToUpper();
                    GMRecord.U_KEY2 = "CAN.LEAD";
                    GMRecord.U_KEY3 = "";
                    GMRecord.U_KEY4 = "ADNREW";// row.Cells[11].Text.ToUpper();
                    GMRecord.U_KEY5 = "";
                    GMRecord.RECID = FacChange.RandomString(9, true);
                    GM.InsertContactRecord(GMRecord);

                    Contsupp.ACCOUNTNO = GMRecord.ACCOUNTNO;
                    Contsupp.RECTYPE = "P";
                    Contsupp.CONTACT = "E-mail Address";
                    Contsupp.CONTSUPREF = row.Cells[3].Text.ToString().Replace("&nbsp;", "");
                    Contsupp.ADDRESS2 = "";
                    Contsupp.CITY = GMRecord.LASTUSER + DateTime.Now.ToString();
                    Contsupp.ZIP = "011";
                    Contsupp.LASTUSER = GMRecord.LASTUSER;
                    Contsupp.LASTDATE = GMRecord.LASTDATE;
                    Contsupp.LASTTIME = GMRecord.LASTTIME;
                    Contsupp.U_CONTACT = Contsupp.CONTACT.ToUpper();
                    Contsupp.U_CONTSUPREF = row.Cells[3].Text.ToString().Replace("&nbsp;", "").ToUpper();
                    Contsupp.U_ADDRESS = "";
                    Contsupp.recid = FacChange.RandomString(9, true);
                    GM.InsertContactRecordSupp(Contsupp);
                }
            }
            else
            {
                foreach (GridViewRow row in GrvNew.Rows)
                {
                    GMRecord.CONTACT = row.Cells[0].Text;
                    GMRecord.LASTNAME = row.Cells[2].Text;
                    string sbfirstname = "";
                    if (row.Cells[1].Text.Length <= 2)
                    {
                        sbfirstname = row.Cells[1].Text.ToString();
                    }
                    else
                    {
                        sbfirstname = row.Cells[1].Text.Substring(0, 3);
                    }
                    GMRecord.ACCOUNTNO = "B" + stryear.Substring(stryear.Length - 1) + month + Day + dateValue + (FacChange.RandomString(4, true) + sbfirstname).ToUpper();
                    if (row.Cells[13].Text.Length >= 35)
                    {
                        GMRecord.DEPARTMENT = row.Cells[13].Text.ToString().Replace("&nbsp;", "").Substring(0, 34).Trim();
                    }
                    else
                    {
                        GMRecord.DEPARTMENT = row.Cells[13].Text.ToString().Replace("&nbsp;", "");
                    }
                    GMRecord.TITLE = row.Cells[9].Text;
                    GMRecord.PHONE = row.Cells[4].Text;
                    GMRecord.CITY = row.Cells[5].Text;
                    GMRecord.STATE = row.Cells[6].Text;
                    GMRecord.ZIP = row.Cells[7].Text;
                    GMRecord.COMPANY = "";
                    GMRecord.SOURCE = row.Cells[12].Text;
                    GMRecord.KEY1 = row.Cells[9].Text;
                    GMRecord.KEY2 = row.Cells[8].Text; ;
                    GMRecord.KEY4 = row.Cells[11].Text;
                    GMRecord.STATUS = " 0";
                    GMRecord.CREATEBY = ddlUsers.SelectedValue;
                    GMRecord.CREATEON = date;
                    GMRecord.CREATEAT = currentTime.ToString();
                    GMRecord.OWNER = "";
                    GMRecord.LASTUSER = ddlUsers.SelectedValue;
                    GMRecord.LASTDATE = date;
                    GMRecord.LASTTIME = currentTime.ToString();
                    GMRecord.U_COMPANY = "";
                    GMRecord.U_CONTACT = row.Cells[0].Text.ToUpper();
                    GMRecord.U_LASTNAME = row.Cells[2].Text.ToUpper();
                    GMRecord.U_CITY = row.Cells[5].Text.ToUpper();
                    GMRecord.U_STATE = row.Cells[6].Text.ToUpper();
                    GMRecord.U_COUNTRY = "";
                    GMRecord.U_KEY1 = row.Cells[9].Text.ToUpper();
                    GMRecord.U_KEY2 = row.Cells[8].Text.ToUpper();
                    GMRecord.U_KEY3 = "";
                    GMRecord.U_KEY4 = row.Cells[11].Text.ToUpper();
                    GMRecord.U_KEY5 = "";
                    GMRecord.RECID = FacChange.RandomString(9, true);
                    GM.InsertContactRecord(GMRecord);

                    Contsupp.ACCOUNTNO = GMRecord.ACCOUNTNO;
                    Contsupp.RECTYPE = "P";
                    Contsupp.CONTACT = "E-mail Address";
                    Contsupp.CONTSUPREF = row.Cells[3].Text.ToString().Replace("&nbsp;", "");
                    Contsupp.ADDRESS2 = "";
                    Contsupp.CITY = GMRecord.LASTUSER + DateTime.Now.ToString();
                    Contsupp.ZIP = "011";
                    Contsupp.LASTUSER = GMRecord.LASTUSER;
                    Contsupp.LASTDATE = GMRecord.LASTDATE;
                    Contsupp.LASTTIME = GMRecord.LASTTIME;
                    Contsupp.U_CONTACT = Contsupp.CONTACT.ToUpper();
                    Contsupp.U_CONTSUPREF = row.Cells[3].Text.ToString().Replace("&nbsp;", "").ToUpper();
                    Contsupp.U_ADDRESS = "";
                    Contsupp.recid = FacChange.RandomString(9, true);
                    GM.InsertContactRecordSupp(Contsupp);
                }
            }
            lblMessage.Visible = true;
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Success! your records have been updated you may relaod the file to see if there are any remaining records.";
        }        
        catch (Exception ex)
        {       
            lblMessage.Visible = true;
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = ex.Message;
        }
    }
}