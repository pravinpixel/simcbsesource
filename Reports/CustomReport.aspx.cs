using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Configuration;
using System.IO;
using Microsoft.Reporting.WebForms;
using System.Drawing.Printing;
using System.Drawing.Imaging;
using System.Text;

public partial class Reports_CustomReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    Utilities utl = null;
    public static int Userid = 0;
    public int m_currentPageIndex;
    public IList<Stream> m_streams;
    PrintDocument printDoc = new PrintDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            cmbPrinters.Items.Clear();
            foreach (string sPrinters in System.Drawing.Printing.PrinterSettings.InstalledPrinters)
            {
                cmbPrinters.Items.Add(sPrinters);
            }
            BindClass();
            DataTable dtSchool = new DataTable();
            utl = new Utilities();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            BindFields();
            ReportParameter aadhaarno = new ReportParameter("aadhaarno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { aadhaarno });
            ReportParameter adclass = new ReportParameter("adclass", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { adclass });
            ReportParameter regno = new ReportParameter("regno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { regno });
            ReportParameter admissionno = new ReportParameter("admissionno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { admissionno });
            ReportParameter adsection = new ReportParameter("adsection", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { adsection });
            ReportParameter bloodgroup = new ReportParameter("bloodgroup", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { bloodgroup });
            ReportParameter caste = new ReportParameter("caste", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { caste });
            ReportParameter iclass = new ReportParameter("class", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { iclass });
            ReportParameter community = new ReportParameter("community", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { community });
            ReportParameter doa = new ReportParameter("doa", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { doa });
            ReportParameter dob = new ReportParameter("dob", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { dob });
            ReportParameter docaddr = new ReportParameter("docaddr", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { docaddr });
            ReportParameter docphno = new ReportParameter("docphno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { docphno });
            ReportParameter doctor = new ReportParameter("doctor", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { doctor });
            ReportParameter doj = new ReportParameter("doj", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { doj });
            ReportParameter email = new ReportParameter("email", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { email });
            ReportParameter phoneno = new ReportParameter("phoneno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { phoneno });
            ReportParameter emerphno = new ReportParameter("emerphno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { emerphno });
            ReportParameter fathercell = new ReportParameter("fathercell", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { fathercell });
            ReportParameter femail = new ReportParameter("femail", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { femail });
            ReportParameter firstlang = new ReportParameter("firstlang", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { firstlang });
            ReportParameter fname = new ReportParameter("fname", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { fname });
            ReportParameter foccaddress = new ReportParameter("foccaddress", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { foccaddress });
            ReportParameter foccupation = new ReportParameter("foccupation", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { foccupation });
            ReportParameter fqual = new ReportParameter("fqual", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { fqual });
            ReportParameter finc = new ReportParameter("finc", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { finc });
            ReportParameter gname1 = new ReportParameter("gname1", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gname1 });
            ReportParameter gemail1 = new ReportParameter("gemail1", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gemail1 });
            ReportParameter gocc1 = new ReportParameter("gocc1", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gocc1 });
            ReportParameter gphno1 = new ReportParameter("gphno1", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gphno1 });
            ReportParameter gaddr1 = new ReportParameter("gaddr1", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gaddr1 });
            ReportParameter gname2 = new ReportParameter("gname2", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gname2 });
            ReportParameter gemail2 = new ReportParameter("gemail2", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gemail2 });
            ReportParameter gocc2 = new ReportParameter("gocc2", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gocc2 });
            ReportParameter gphno2 = new ReportParameter("gphno2", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gphno2 });
            ReportParameter gaddr2 = new ReportParameter("gaddr2", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { gaddr2 });
            ReportParameter memail = new ReportParameter("memail", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { memail });
            ReportParameter mname = new ReportParameter("mname", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { mname });           
            ReportParameter moccaddress = new ReportParameter("moccaddress", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { moccaddress });
            ReportParameter moccupation = new ReportParameter("moccupation", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { moccupation });
            ReportParameter mothercell = new ReportParameter("mothercell", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { mothercell });
            ReportParameter mothertongue = new ReportParameter("mothertongue", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { mothertongue });
            ReportParameter mqual = new ReportParameter("mqual", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { mqual });
            ReportParameter minc = new ReportParameter("minc", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { minc });
            ReportParameter peraddr = new ReportParameter("peraddr", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { peraddr });
            ReportParameter religion = new ReportParameter("religion", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { religion });
            ReportParameter seclang = new ReportParameter("seclang", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { seclang });
            ReportParameter section = new ReportParameter("section", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { section });
            ReportParameter sex = new ReportParameter("sex", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { sex });
            ReportParameter studentname = new ReportParameter("studentname", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { studentname });
            ReportParameter tempaddr = new ReportParameter("tempaddr", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { tempaddr });
            ReportParameter transportname = new ReportParameter("transportname", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { transportname });
            ReportParameter smartcardno = new ReportParameter("smartcardno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { smartcardno });
            ReportParameter rationcardno = new ReportParameter("rationcardno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { rationcardno });
            ReportParameter idmarks = new ReportParameter("idmarks", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { idmarks });
            ReportParameter handicap = new ReportParameter("handicap", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { handicap });
            ReportParameter examno = new ReportParameter("examno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { examno });
            ReportParameter nationality = new ReportParameter("nationality", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { nationality });
            ReportParameter handicaptdetails = new ReportParameter("handicaptdetails", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { handicaptdetails });
            ReportParameter disorders = new ReportParameter("disorders", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { disorders });
            ReportParameter medium = new ReportParameter("medium", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { medium });
            ReportParameter academicremarks = new ReportParameter("academicremarks", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { academicremarks });
            ReportParameter medicalremarks = new ReportParameter("medicalremarks", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { medicalremarks });
            ReportParameter sslcno = new ReportParameter("sslcno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { sslcno });
            ReportParameter sslcyear = new ReportParameter("sslcyear", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { sslcyear });
            ReportParameter hscno = new ReportParameter("hscno", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { hscno });
            ReportParameter hscyear = new ReportParameter("hscyear", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { hscyear });
            ReportParameter caretaker = new ReportParameter("caretaker", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { caretaker });
            ReportParameter curricularremarks = new ReportParameter("curricularremarks", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { curricularremarks });
            ReportParameter suid = new ReportParameter("suid", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { suid });
            ReportParameter tamilname = new ReportParameter("tamilname", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { tamilname });
            ReportParameter height = new ReportParameter("height", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { height });
            ReportParameter weight = new ReportParameter("weight", "False", false);
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { weight });

            ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            CustomReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });

        }


    }
    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("sp_GetClass");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass.DataSource = dsClass;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataTextField = "";
            ddlClass.DataValueField = "";
            ddlClass.DataBind();
        }
    }

    protected void BindSectionByClass()
    {
        utl = new Utilities();
        DataSet dsSection = new DataSet();
        if (ddlClass.SelectedValue != string.Empty)
            dsSection = utl.GetDataset("sp_GetSectionByClass " + ddlClass.SelectedValue);
        else
            ddlSection.Items.Clear();
        ddlSection.DataSource = null;
        ddlSection.AppendDataBoundItems = false;
        if (dsSection != null && dsSection.Tables.Count > 0 && dsSection.Tables[0].Rows.Count > 0)
        {
            ddlSection.DataSource = dsSection;
            ddlSection.DataTextField = "SectionName";
            ddlSection.DataValueField = "SectionID";
            ddlSection.DataBind();
        }
        else
        {
            ddlSection.DataSource = null;
            ddlSection.DataTextField = "";
            ddlSection.DataValueField = "";
            ddlSection.DataBind();
        }
        ddlSection.Items.Insert(0, new ListItem("--Select---", ""));
    }
    protected string BindFields()
    {
        StringBuilder sb = new StringBuilder();

        DataTable dt = new DataTable();
        string Isactive=utl.ExecuteScalar("select IsActive from m_academicyear where AcademicID='"+ Session["AcademicID"] +"'");
        string sqlstr = "";
        if (Isactive == "1" || Isactive == "True")
        {
            sqlstr = "SELECT upper(COLUMN_NAME) as Columnname FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'vw_getallstudent' and COLUMN_NAME  in ('studentname','regno','AdmissionNo','AdClass','AdSection','class','section','DOB','DOA','DOJ','Sex','MotherTongue','Religion','Community','Caste','AadhaarNo','TempAddr','PerAddr','Email','FName','FOccupation','FOccAddress','FQual','FEmail','FIncome','MName','MOccupation','MOccAddress','MQual','MEmail','MIncome','FatherCell','MotherCell','BloodGroup','EmerPhNo','Doctor','DocPhNo','DocAddr','TransportName','Firstlang','Seclang','GName1','GEmail1','GOcc1','GPhno1','GAddr1','SmartCardNo','RationCardNo','IDmarks','ExamNo','Nationality','HandicaptDetails','DisOrders','Medium','PhoneNo','AcademicRemarks','MedicalRemarks','SSLCNo','SSLCYear','HSCNo','HSCYear','GName2','GAddr2','GPhno2','GOcc2','GEmail2','Caretaker','CurricularRemarks','SUID', 'TamilName', 'Height', 'Weight' )  order by column_name";
        }
        else if (Isactive == "0" || Isactive == "False")
        {
            sqlstr = "SELECT upper(COLUMN_NAME) as Columnname FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'vw_getalloldstudent' and COLUMN_NAME  in ('studentname','regno','AdmissionNo','AdClass','AdSection','class','section','DOB','DOA','DOJ','Sex','MotherTongue','Religion','Community','Caste','AadhaarNo','TempAddr','PerAddr','Email','FName','FOccupation','FOccAddress','FQual','FIncome','MIncome','FEmail','MName','MOccupation','MOccAddress','MQual','MEmail','FatherCell','MotherCell','BloodGroup','EmerPhNo','Doctor','DocPhNo','DocAddr','TransportName','Firstlang','Seclang','GName1','GEmail1','GOcc1','GPhno1','GAddr1','SmartCardNo','RationCardNo','IDmarks','ExamNo','Nationality','HandicaptDetails','DisOrders','Medium','PhoneNo','AcademicRemarks','MedicalRemarks','SSLCNo','SSLCYear','HSCNo','HSCYear','GName2','GAddr2','GPhno2','GOcc2','GEmail2','Caretaker','CurricularRemarks','SUID', 'TamilName', 'Height', 'Weight' )  order by column_name";
        }
        
        dt = utl.GetDataTable(sqlstr);
        Session["Count"] = dt.Rows.Count.ToString();
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                if (dr["Columnname"].ToString().Trim() == "ACADEMICREMARKS")
                {
                    chkids.Items.Add("ACADEMIC REMARKS");
                }
                else if (dr["Columnname"].ToString().Trim() == "MEDICALREMARKS")
                {
                    chkids.Items.Add("MEDICAL REMARKS");
                }
                else if (dr["Columnname"].ToString().Trim() == "MEDIUM")
                {
                    chkids.Items.Add("MEDIUM");
                }
                else if (dr["Columnname"].ToString().Trim() == "DISORDERS")
                {
                    chkids.Items.Add("DISORDERS");
                }
                else if (dr["Columnname"].ToString().Trim() == "AADHAARNO")
                {
                    chkids.Items.Add("AADHAAR NO");
                }
                else if (dr["Columnname"].ToString().Trim() == "ADMISSIONNO")
                {
                    chkids.Items.Add("ADMISSION NO");
                }
                else if (dr["Columnname"].ToString().Trim() == "DOJ")
                {
                    chkids.Items.Add("DATE OF JOINING");
                }
                else if (dr["Columnname"].ToString().Trim() == "DOB")
                {
                    chkids.Items.Add("DATE OF BIRTH");
                }
                else if (dr["Columnname"].ToString().Trim() == "EXAMNO")
                {
                    chkids.Items.Add("EXAM NO");
                }
                else if (dr["Columnname"].ToString().Trim() == "MOTHERCELL")
                {
                    chkids.Items.Add("MOTHER CELL");
                }
                else if (dr["Columnname"].ToString().Trim() == "DOA")
                {
                    chkids.Items.Add("DATE OF ADMISSION");
                }
                else if (dr["Columnname"].ToString().Trim() == "ADCLASS")
                {
                    chkids.Items.Add("ADMITTED CLASS");
                }
                else if (dr["Columnname"].ToString().Trim() == "ADSECTION")
                {
                    chkids.Items.Add("ADMITTED SECTION");
                }
                else if (dr["Columnname"].ToString().Trim() == "TEMPADDR")
                {
                    chkids.Items.Add("TEMPORARY ADDRESS");
                }
                else if (dr["Columnname"].ToString().Trim() == "PERADDR")
                {
                    chkids.Items.Add("PERMANENT ADDRESS");
                }
                else if (dr["Columnname"].ToString().Trim() == "FNAME")
                {
                    chkids.Items.Add("FATHER NAME");
                }
                else if (dr["Columnname"].ToString().Trim() == "FOCCUPATION")
                {
                    chkids.Items.Add("FATHER OCCUPATION");
                }
                else if (dr["Columnname"].ToString().Trim() == "FATHERCELL")
                {
                    chkids.Items.Add("FATHER CELL");
                }
                else if (dr["Columnname"].ToString().Trim() == "FOCCADDRESS")
                {
                    chkids.Items.Add("FATHER ADDRESS");
                }
                else if (dr["Columnname"].ToString().Trim() == "FQUAL")
                {
                    chkids.Items.Add("FATHER QUALIFICATION");
                }
                else if (dr["Columnname"].ToString().Trim() == "FINCOME")
                {
                    chkids.Items.Add("FATHER INCOME");
                }
                else if (dr["Columnname"].ToString().Trim() == "FEMAIL")
                {
                    chkids.Items.Add("FATHER EMAIL");
                }              
                else if (dr["Columnname"].ToString().Trim() == "MNAME")
                {
                    chkids.Items.Add("MOTHER NAME");
                }
                else if (dr["Columnname"].ToString().Trim() == "MOCCUPATION")
                {
                    chkids.Items.Add("MOTHER OCCUPATION");
                }
                else if (dr["Columnname"].ToString().Trim() == "MOCCADDRESS")
                {
                    chkids.Items.Add("MOTHER ADDRESS");
                }
                else if (dr["Columnname"].ToString().Trim() == "MQUAL")
                {
                    chkids.Items.Add("MOTHER QUALIFICATION");
                }
                else if (dr["Columnname"].ToString().Trim() == "MEMAIL")
                {
                    chkids.Items.Add("MOTHER EMAIL");
                }
                else if (dr["Columnname"].ToString().Trim() == "MINCOME")
                {
                    chkids.Items.Add("MOTHER INCOME");
                }
                else if (dr["Columnname"].ToString().Trim() == "EMERPHNO")
                {
                    chkids.Items.Add("EMERGENCY PHONENO");
                }
                else if (dr["Columnname"].ToString().Trim() == "PHONENO")
                {
                    chkids.Items.Add("PHONENO");
                }
                else if (dr["Columnname"].ToString().Trim() == "DOCTOR")
                {
                    chkids.Items.Add("DOCTOR NAME");
                }
                else if (dr["Columnname"].ToString().Trim() == "DOCPHNO")
                {
                    chkids.Items.Add("DOCTOR PHONENO");
                }
                else if (dr["Columnname"].ToString().Trim() == "DOCADDR")
                {
                    chkids.Items.Add("DOCTOR ADDRESS");
                }
                else if (dr["Columnname"].ToString().Trim() == "FIRSTLANG")
                {
                    chkids.Items.Add("FIRST LANGUAGE");
                }
                else if (dr["Columnname"].ToString().Trim() == "SECLANG")
                {
                    chkids.Items.Add("SECONDARY LANGUAGE");
                }
                else if (dr["Columnname"].ToString().Trim() == "GNAME1")
                {
                    chkids.Items.Add("GAURDIAN I NAME");
                }
                else if (dr["Columnname"].ToString().Trim() == "GEMAIL1")
                {
                    chkids.Items.Add("GAURDIAN I EMAIL");
                }
                else if (dr["Columnname"].ToString().Trim() == "GOCC1")
                {
                    chkids.Items.Add("GAURDIAN I OCCUPATION");
                }
                else if (dr["Columnname"].ToString().Trim() == "GADDR1")
                {
                    chkids.Items.Add("GAURDIAN I ADDRESS");
                }
                else if (dr["Columnname"].ToString().Trim() == "GPHNO1")
                {
                    chkids.Items.Add("GAURDIAN I PHONENO");
                }
                else if (dr["Columnname"].ToString().Trim() == "GNAME2")
                {
                    chkids.Items.Add("GAURDIAN II NAME");
                }
                else if (dr["Columnname"].ToString().Trim() == "GEMAIL2")
                {
                    chkids.Items.Add("GAURDIAN II EMAIL");
                }
                else if (dr["Columnname"].ToString().Trim() == "GOCC2")
                {
                    chkids.Items.Add("GAURDIAN II OCCUPATION");
                }
                else if (dr["Columnname"].ToString().Trim() == "GADDR2")
                {
                    chkids.Items.Add("GAURDIAN II ADDRESS");
                }
                else if (dr["Columnname"].ToString().Trim() == "GPHNO2")
                {
                    chkids.Items.Add("GAURDIAN II PHONENO");
                }
                else if (dr["Columnname"].ToString().Trim() == "IDMARKS")
                {
                    chkids.Items.Add("IDENTIFICATION MARKS");
                }
                else if (dr["Columnname"].ToString().Trim() == "HANDICAP")
                {
                    chkids.Items.Add("IS HANDICAP");
                }
                else if (dr["Columnname"].ToString().Trim() == "handicaptdetails")
                {
                    chkids.Items.Add("handicaptdetails");
                }
                else if (dr["Columnname"].ToString().Trim() == "STUDENTNAME")
                {
                    chkids.Items.Add("STUDENT NAME");
                }
                else if (dr["Columnname"].ToString().Trim() == "SMARTCARDNO")
                {
                    chkids.Items.Add("SMARTCARD NO");
                }
                else if (dr["Columnname"].ToString().Trim() == "TRANSPORTNAME")
                {
                    chkids.Items.Add("TRANSPORT NAME");
                }
                else if (dr["Columnname"].ToString().Trim() == "RATIONCARDNO")
                {
                    chkids.Items.Add("RATIONCARD NO");
                }
                else
                {
                    chkids.Items.Add(dr["Columnname"].ToString());
                }
                
            }
            foreach (ListItem li in chkids.Items)
            {

                if (li.Text.ToLower() == "regno" || li.Text.ToLower() == "student name" || li.Text.ToLower() == "class" || li.Text.ToLower() == "section")
                {
                    li.Selected = true;
                    li.Enabled = false;
                }
            }
        }


        return sb.ToString();
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");

        foreach (ListItem li in chkids.Items)
        {
            if (li.Text.ToLower() == "suid")
            {
                if (li.Selected == true)
                {
                    ReportParameter suid = new ReportParameter("suid", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { suid });
                }
                else
                {
                    ReportParameter suid = new ReportParameter("suid", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { suid });
                }

            }

            if (li.Text.ToLower() == "tamilname")
            {
                if (li.Selected == true)
                {
                    ReportParameter tamilname = new ReportParameter("tamilname", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { tamilname });
                }
                else
                {
                    ReportParameter tamilname = new ReportParameter("tamilname", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { tamilname });
                }

            }


            if (li.Text.ToLower() == "height")
            {
                if (li.Selected == true)
                {
                    ReportParameter height = new ReportParameter("height", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { height });
                }
                else
                {
                    ReportParameter height = new ReportParameter("height", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { height });
                }

            }


            if (li.Text.ToLower() == "weight")
            {
                if (li.Selected == true)
                {
                    ReportParameter weight = new ReportParameter("weight", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { weight });
                }
                else
                {
                    ReportParameter weight = new ReportParameter("weight", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { weight });
                }

            }

            if (li.Text.ToLower() == "academic remarks")
            {
                if (li.Selected == true)
                {
                    ReportParameter academicremarks = new ReportParameter("academicremarks", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { academicremarks });
                }
                else
                {
                    ReportParameter academicremarks = new ReportParameter("academicremarks", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { academicremarks });
                }

            }
            if (li.Text.ToLower() == "medical remarks")
            {
                if (li.Selected == true)
                {
                    ReportParameter medicalremarks = new ReportParameter("medicalremarks", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { medicalremarks });
                }
                else
                {
                    ReportParameter medicalremarks = new ReportParameter("medicalremarks", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { medicalremarks });
                }

            }
            if (li.Text.ToLower() == "disorders")
            {
                if (li.Selected == true)
                {
                    ReportParameter disorders = new ReportParameter("disorders", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { disorders });
                }
                else
                {
                    ReportParameter disorders = new ReportParameter("disorders", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { disorders });
                }

            }
            if (li.Text.ToLower() == "medium")
            {
                if (li.Selected == true)
                {
                    ReportParameter medium = new ReportParameter("medium", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { medium });
                }
                else
                {
                    ReportParameter medium = new ReportParameter("medium", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { medium });
                }

            }
            if (li.Text.ToLower() == "regno")
            {
                if (li.Selected == true)
                {
                    ReportParameter regno = new ReportParameter("regno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { regno });
                }
                else
                {
                    ReportParameter regno = new ReportParameter("regno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { regno });
                }

            }
            if (li.Text.ToLower() == "aadhaar no")
            {
                if (li.Selected == true)
                {
                    ReportParameter aadhaarno = new ReportParameter("aadhaarno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { aadhaarno });
                }
                else
                {
                    ReportParameter aadhaarno = new ReportParameter("aadhaarno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { aadhaarno });
                }

            }
            if (li.Text.ToLower() == "admitted class")
            {
                if (li.Selected == true)
                {
                    ReportParameter adclass = new ReportParameter("adclass", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { adclass });
                }
                else
                {
                    ReportParameter adclass = new ReportParameter("adclass", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { adclass });
                }

            }

            if (li.Text.ToLower() == "admission no")
            {
                if (li.Selected == true)
                {
                    ReportParameter admissionno = new ReportParameter("admissionno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { admissionno });
                }
                else
                {
                    ReportParameter admissionno = new ReportParameter("admissionno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { admissionno });
                }

            }

            if (li.Text.ToLower() == "admitted section")
            {
                if (li.Selected == true)
                {
                    ReportParameter adsection = new ReportParameter("adsection", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { adsection });
                }
                else
                {
                    ReportParameter adsection = new ReportParameter("adsection", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { adsection });
                }

            }

            if (li.Text.ToLower() == "bloodgroup")
            {
                if (li.Selected == true)
                {
                    ReportParameter bloodgroup = new ReportParameter("bloodgroup", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { bloodgroup });
                }
                else
                {
                    ReportParameter bloodgroup = new ReportParameter("bloodgroup", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { bloodgroup });
                }

            }

            if (li.Text.ToLower() == "caste")
            {
                if (li.Selected == true)
                {
                    ReportParameter caste = new ReportParameter("caste", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { caste });
                }
                else
                {
                    ReportParameter caste = new ReportParameter("caste", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { caste });
                }

            }

            if (li.Text.ToLower() == "class")
            {
                if (li.Selected == true)
                {
                    ReportParameter iclass = new ReportParameter("class", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { iclass });
                }
                else
                {
                    ReportParameter iclass = new ReportParameter("class", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { iclass });
                }

            }

            if (li.Text.ToLower() == "community")
            {
                if (li.Selected == true)
                {
                    ReportParameter community = new ReportParameter("community", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { community });
                }
                else
                {
                    ReportParameter community = new ReportParameter("community", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { community });
                }

            }

            if (li.Text.ToLower() == "date of admission")
            {
                if (li.Selected == true)
                {
                    ReportParameter doa = new ReportParameter("doa", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { doa });
                }
                else
                {
                    ReportParameter doa = new ReportParameter("doa", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { doa });
                }

            }

            if (li.Text.ToLower() == "date of birth")
            {
                if (li.Selected == true)
                {
                    ReportParameter dob = new ReportParameter("dob", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { dob });
                }
                else
                {
                    ReportParameter dob = new ReportParameter("dob", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { dob });
                }

            }

            if (li.Text.ToLower() == "doctor address")
            {
                if (li.Selected == true)
                {
                    ReportParameter docaddr = new ReportParameter("docaddr", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { docaddr });
                }
                else
                {
                    ReportParameter docaddr = new ReportParameter("docaddr", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { docaddr });
                }

            }

            if (li.Text.ToLower() == "doctor phoneno")
            {
                if (li.Selected == true)
                {
                    ReportParameter docphno = new ReportParameter("docphno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { docphno });
                }
                else
                {
                    ReportParameter docphno = new ReportParameter("docphno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { docphno });
                }

            }

            if (li.Text.ToLower() == "doctor")
            {
                if (li.Selected == true)
                {
                    ReportParameter doctor = new ReportParameter("doctor", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { doctor });
                }
                else
                {
                    ReportParameter doctor = new ReportParameter("doctor", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { doctor });
                }

            }

            if (li.Text.ToLower() == "date of joining")
            {
                if (li.Selected == true)
                {
                    ReportParameter doj = new ReportParameter("doj", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { doj });
                }
                else
                {
                    ReportParameter doj = new ReportParameter("doj", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { doj });
                }

            }

            if (li.Text.ToLower() == "email")
            {
                if (li.Selected == true)
                {
                    ReportParameter email = new ReportParameter("email", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { email });
                }
                else
                {
                    ReportParameter email = new ReportParameter("email", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { email });
                }

            }
            if (li.Text.ToLower() == "phoneno")
            {
                if (li.Selected == true)
                {
                    ReportParameter phoneno = new ReportParameter("phoneno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { phoneno });
                }
                else
                {
                    ReportParameter phoneno = new ReportParameter("phoneno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { phoneno });
                }

            }

            if (li.Text.ToLower() == "emergency phoneno")
            {
                if (li.Selected == true)
                {
                    ReportParameter emerphno = new ReportParameter("emerphno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { emerphno });
                }
                else
                {
                    ReportParameter emerphno = new ReportParameter("emerphno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { emerphno });
                }

            }

            if (li.Text.ToLower() == "father cell")
            {
                if (li.Selected == true)
                {
                    ReportParameter fathercell = new ReportParameter("fathercell", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { fathercell });
                }
                else
                {
                    ReportParameter fathercell = new ReportParameter("fathercell", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { fathercell });
                }

            }

            if (li.Text.ToLower() == "father email")
            {
                if (li.Selected == true)
                {
                    ReportParameter femail = new ReportParameter("femail", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { femail });
                }
                else
                {
                    ReportParameter femail = new ReportParameter("femail", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { femail });
                }

            }

            if (li.Text.ToLower() == "father income")
            {
                if (li.Selected == true)
                {
                    ReportParameter finc = new ReportParameter("finc", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { finc });
                }
                else
                {
                    ReportParameter finc = new ReportParameter("finc", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { finc });
                }

            }

            if (li.Text.ToLower() == "mother income")
            {
                if (li.Selected == true)
                {
                    ReportParameter minc = new ReportParameter("minc", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { minc });
                }
                else
                {
                    ReportParameter minc = new ReportParameter("minc", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { minc });
                }

            }

            if (li.Text.ToLower() == "first language")
            {
                if (li.Selected == true)
                {
                    ReportParameter firstlang = new ReportParameter("firstlang", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { firstlang });
                }
                else
                {
                    ReportParameter firstlang = new ReportParameter("firstlang", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { firstlang });
                }

            }

            if (li.Text.ToLower() == "father name")
            {
                if (li.Selected == true)
                {
                    ReportParameter fname = new ReportParameter("fname", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { fname });
                }
                else
                {
                    ReportParameter fname = new ReportParameter("fname", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { fname });
                }

            }

            if (li.Text.ToLower() == "father address")
            {
                if (li.Selected == true)
                {
                    ReportParameter foccaddress = new ReportParameter("foccaddress", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { foccaddress });
                }
                else
                {
                    ReportParameter foccaddress = new ReportParameter("foccaddress", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { foccaddress });
                }

            }

            if (li.Text.ToLower() == "father occupation")
            {
                if (li.Selected == true)
                {
                    ReportParameter foccupation = new ReportParameter("foccupation", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { foccupation });
                }
                else
                {
                    ReportParameter foccupation = new ReportParameter("foccupation", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { foccupation });
                }

            }

            if (li.Text.ToLower() == "father qualification")
            {
                if (li.Selected == true)
                {
                    ReportParameter fqual = new ReportParameter("fqual", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { fqual });
                }
                else
                {
                    ReportParameter fqual = new ReportParameter("fqual", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { fqual });
                }

            }
            if (li.Text.ToLower() == "gaurdian i name")
            {
                if (li.Selected == true)
                {
                    ReportParameter gname1 = new ReportParameter("gname1", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gname1 });
                }
                else
                {
                    ReportParameter gname1 = new ReportParameter("gname1", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gname1 });
                }

            }

            if (li.Text.ToLower() == "gaurdian i email")
            {
                if (li.Selected == true)
                {
                    ReportParameter gemail1 = new ReportParameter("gemail1", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gemail1 });
                }
                else
                {
                    ReportParameter gemail1 = new ReportParameter("gemail1", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gemail1 });
                }

            }

            if (li.Text.ToLower() == "gaurdian i occupation")
            {
                if (li.Selected == true)
                {
                    ReportParameter gocc1 = new ReportParameter("gocc1", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gocc1 });
                }
                else
                {
                    ReportParameter gocc1 = new ReportParameter("gocc1", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gocc1 });
                }

            }

            if (li.Text.ToLower() == "gaurdian i phoneno")
            {
                if (li.Selected == true)
                {
                    ReportParameter gphno1 = new ReportParameter("gphno1", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gphno1 });
                }
                else
                {
                    ReportParameter gphno1 = new ReportParameter("gphno1", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gphno1 });
                }

            }

            if (li.Text.ToLower() == "gaurdian i address")
            {
                if (li.Selected == true)
                {
                    ReportParameter gaddr1 = new ReportParameter("gaddr1", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gaddr1 });
                }
                else
                {
                    ReportParameter gaddr1 = new ReportParameter("gaddr1", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gaddr1 });
                }

            }

            if (li.Text.ToLower() == "gaurdian ii name")
            {
                if (li.Selected == true)
                {
                    ReportParameter gname2 = new ReportParameter("gname2", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gname2 });
                }
                else
                {
                    ReportParameter gname2 = new ReportParameter("gname2", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gname2 });
                }

            }

            if (li.Text.ToLower() == "gaurdian ii email")
            {
                if (li.Selected == true)
                {
                    ReportParameter gemail2 = new ReportParameter("gemail2", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gemail2 });
                }
                else
                {
                    ReportParameter gemail2 = new ReportParameter("gemail2", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gemail2 });
                }

            }

            if (li.Text.ToLower() == "gaurdian ii occupation")
            {
                if (li.Selected == true)
                {
                    ReportParameter gocc2 = new ReportParameter("gocc2", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gocc2 });
                }
                else
                {
                    ReportParameter gocc2 = new ReportParameter("gocc2", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gocc2 });
                }

            }

            if (li.Text.ToLower() == "gaurdian ii phoneno")
            {
                if (li.Selected == true)
                {
                    ReportParameter gphno2 = new ReportParameter("gphno2", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gphno2 });
                }
                else
                {
                    ReportParameter gphno2 = new ReportParameter("gphno2", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gphno2 });
                }

            }

            if (li.Text.ToLower() == "gaurdian ii address")
            {
                if (li.Selected == true)
                {
                    ReportParameter gaddr2 = new ReportParameter("gaddr2", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gaddr2 });
                }
                else
                {
                    ReportParameter gaddr2 = new ReportParameter("gaddr2", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { gaddr2 });
                }

            }
            if (li.Text.ToLower() == "mother email")
            {
                if (li.Selected == true)
                {
                    ReportParameter memail = new ReportParameter("memail", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { memail });
                }
                else
                {
                    ReportParameter memail = new ReportParameter("memail", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { memail });
                }

            }

            if (li.Text.ToLower() == "mother name")
            {
                if (li.Selected == true)
                {
                    ReportParameter mname = new ReportParameter("mname", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { mname });
                }
                else
                {
                    ReportParameter mname = new ReportParameter("mname", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { mname });
                }

            }

            if (li.Text.ToLower() == "mother address")
            {
                if (li.Selected == true)
                {
                    ReportParameter moccaddress = new ReportParameter("moccaddress", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { moccaddress });
                }
                else
                {
                    ReportParameter moccaddress = new ReportParameter("moccaddress", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { moccaddress });
                }

            }

            if (li.Text.ToLower() == "mother occupation")
            {
                if (li.Selected == true)
                {
                    ReportParameter moccupation = new ReportParameter("moccupation", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { moccupation });
                }
                else
                {
                    ReportParameter moccupation = new ReportParameter("moccupation", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { moccupation });
                }

            }

            if (li.Text.ToLower() == "mother cell")
            {
                if (li.Selected == true)
                {
                    ReportParameter mothercell = new ReportParameter("mothercell", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { mothercell });
                }
                else
                {
                    ReportParameter mothercell = new ReportParameter("mothercell", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { mothercell });
                }

            }

            if (li.Text.ToLower() == "mothertongue")
            {
                if (li.Selected == true)
                {
                    ReportParameter mothertongue = new ReportParameter("mothertongue", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { mothertongue });
                }
                else
                {
                    ReportParameter mothertongue = new ReportParameter("mothertongue", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { mothertongue });
                }

            }

            if (li.Text.ToLower() == "mother qualification")
            {
                if (li.Selected == true)
                {
                    ReportParameter mqual = new ReportParameter("mqual", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { mqual });
                }
                else
                {
                    ReportParameter mqual = new ReportParameter("mqual", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { mqual });
                }

            }

            if (li.Text.ToLower() == "permanent address")
            {
                if (li.Selected == true)
                {
                    ReportParameter peraddr = new ReportParameter("peraddr", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { peraddr });
                }
                else
                {
                    ReportParameter peraddr = new ReportParameter("peraddr", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { peraddr });
                }

            }

            if (li.Text.ToLower() == "religion")
            {
                if (li.Selected == true)
                {
                    ReportParameter religion = new ReportParameter("religion", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { religion });
                }
                else
                {
                    ReportParameter religion = new ReportParameter("religion", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { religion });
                }

            }

            if (li.Text.ToLower() == "secondary language")
            {
                if (li.Selected == true)
                {
                    ReportParameter seclang = new ReportParameter("seclang", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { seclang });
                }
                else
                {
                    ReportParameter seclang = new ReportParameter("seclang", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { seclang });
                }

            }

            if (li.Text.ToLower() == "section")
            {
                if (li.Selected == true)
                {
                    ReportParameter section = new ReportParameter("section", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { section });
                }
                else
                {
                    ReportParameter section = new ReportParameter("section", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { section });
                }

            }

            if (li.Text.ToLower() == "sex")
            {
                if (li.Selected == true)
                {
                    ReportParameter sex = new ReportParameter("sex", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { sex });
                }
                else
                {
                    ReportParameter sex = new ReportParameter("sex", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { sex });
                }

            }

            if (li.Text.ToLower() == "student name")
            {
                if (li.Selected == true)
                {
                    ReportParameter studentname = new ReportParameter("studentname", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { studentname });
                }
                else
                {
                    ReportParameter studentname = new ReportParameter("studentname", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { studentname });
                }

            }

            if (li.Text.ToLower() == "temporary address")
            {
                if (li.Selected == true)
                {
                    ReportParameter tempaddr = new ReportParameter("tempaddr", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { tempaddr });
                }
                else
                {
                    ReportParameter tempaddr = new ReportParameter("tempaddr", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { tempaddr });
                }

            }

            if (li.Text.ToLower() == "transport name")
            {
                if (li.Selected == true)
                {
                    ReportParameter transportname = new ReportParameter("transportname", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { transportname });
                }
                else
                {
                    ReportParameter transportname = new ReportParameter("transportname", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { transportname });
                }
            }

            if (li.Text.ToLower() == "smartcard no")
            {
                if (li.Selected == true)
                {
                    ReportParameter smartcardno = new ReportParameter("smartcardno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { smartcardno });
                }
                else
                {
                    ReportParameter smartcardno = new ReportParameter("smartcardno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { smartcardno });
                }
            }

            if (li.Text.ToLower() == "rationcard no")
            {
                if (li.Selected == true)
                {
                    ReportParameter rationcardno = new ReportParameter("rationcardno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { rationcardno });
                }
                else
                {
                    ReportParameter rationcardno = new ReportParameter("rationcardno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { rationcardno });
                }
            }


            if (li.Text.ToLower() == "identification marks")
            {
                if (li.Selected == true)
                {
                    ReportParameter idmarks = new ReportParameter("idmarks", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { idmarks });
                }
                else
                {
                    ReportParameter idmarks = new ReportParameter("idmarks", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { idmarks });
                }
            }  
           
            if (li.Text.ToLower() == "is handicap")
            {
                if (li.Selected == true)
                {
                    ReportParameter handicap = new ReportParameter("handicap", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { handicap });
                }
                else
                {
                    ReportParameter handicap = new ReportParameter("handicap", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { handicap });
                }
            }

            if (li.Text.ToLower() == "exam no")
            {
                if (li.Selected == true)
                {
                    ReportParameter examno = new ReportParameter("examno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { examno });
                }
                else
                {
                    ReportParameter examno = new ReportParameter("examno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { examno });
                }
            }

            if (li.Text.ToLower() == "nationality")
            {
                if (li.Selected == true)
                {
                    ReportParameter nationality = new ReportParameter("nationality", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { nationality });
                }
                else
                {
                    ReportParameter nationality = new ReportParameter("nationality", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { nationality });
                }
            }

            if (li.Text.ToLower() == "handicaptdetails")
            {
                if (li.Selected == true)
                {
                    ReportParameter handicaptdetails = new ReportParameter("handicaptdetails", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { handicaptdetails });
                }
                else
                {
                    ReportParameter handicaptdetails = new ReportParameter("handicaptdetails", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { handicaptdetails });
                }
            }

            if (li.Text.ToLower() == "handicaptdetails")
            {
                if (li.Selected == true)
                {
                    ReportParameter handicaptdetails = new ReportParameter("handicaptdetails", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { handicaptdetails });
                }
                else
                {
                    ReportParameter handicaptdetails = new ReportParameter("handicaptdetails", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { handicaptdetails });
                }
            }
            if (li.Text.ToLower() == "sslcno")
            {
                if (li.Selected == true)
                {
                    ReportParameter sslcno = new ReportParameter("sslcno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { sslcno });
                }
                else
                {
                    ReportParameter sslcno = new ReportParameter("sslcno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { sslcno });
                }
            }
            if (li.Text.ToLower() == "sslcyear")
            {
                if (li.Selected == true)
                {
                    ReportParameter sslcyear = new ReportParameter("sslcyear", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { sslcyear });
                }
                else
                {
                    ReportParameter sslcyear = new ReportParameter("sslcyear", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { sslcyear });
                }
            }
            if (li.Text.ToLower() == "hscno")
            {
                if (li.Selected == true)
                {
                    ReportParameter hscno = new ReportParameter("hscno", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { hscno });
                }
                else
                {
                    ReportParameter hscno = new ReportParameter("hscno", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { hscno });
                }
            }
            if (li.Text.ToLower() == "hscyear")
            {
                if (li.Selected == true)
                {
                    ReportParameter hscyear = new ReportParameter("hscyear", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { hscyear });
                }
                else
                {
                    ReportParameter hscyear = new ReportParameter("hscyear", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { hscyear });
                }
            }
            if (li.Text.ToLower() == "caretaker")
            {
                if (li.Selected == true)
                {
                    ReportParameter caretaker = new ReportParameter("caretaker", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { caretaker });
                }
                else
                {
                    ReportParameter caretaker = new ReportParameter("caretaker", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { caretaker });
                }
            }
            if (li.Text.ToLower() == "curricularremarks")
            {
                if (li.Selected == true)
                {
                    ReportParameter curricularremarks = new ReportParameter("curricularremarks", "True", true);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { curricularremarks });
                }
                else
                {
                    ReportParameter curricularremarks = new ReportParameter("curricularremarks", "False", false);
                    CustomReport.LocalReport.SetParameters(new ReportParameter[] { curricularremarks });
                }
            }
        }

        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        CustomReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        CustomReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        ReportParameter className = new ReportParameter("className", Session["strClass"].ToString() + "/" + Session["strSection"].ToString());
        CustomReport.LocalReport.SetParameters(new ReportParameter[] { className });

        CustomReport.LocalReport.Refresh();

    }


    private void Page_Init(object sender, EventArgs e)
    {
        try
        {
            Master.chkUser();
            if (Session["UserId"] == null || Session["AcademicID"] == null)
            {

                Response.Redirect("Default.aspx?ses=expired");
            }
            else
            {
                if (!Page.IsPostBack)
                {
                    Session["strClass"] = "All Class";
                    Session["strSection"] = "All Section";
                }
                // btnSearch_Click(sender, e);
            }

        }
        catch (Exception)
        {


        }
    }

    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSectionByClass();
        if (ddlClass.SelectedValue == string.Empty)
        {
            strClass = "";
            strClassID = "";
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "All Section";
            Session["strClass"] = "All Class";
        }
        else
        {
            Session["strClass"] = ddlClass.SelectedItem.Text;
            Session["strClassID"] = ddlClass.SelectedValue;
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "All Section";
            Session["strSectionID"] = "";

        }


    }
    protected void ddlSection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSection.SelectedItem.Value == string.Empty)
        {
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "All Section";
        }
        else
        {
            Session["strSection"] = ddlSection.SelectedItem.Text;
            Session["strSectionID"] = ddlSection.SelectedValue;
        }

    }
    private void PrintReport()
    {


    }



    public void Dispose()
    {
        if (m_streams != null)
        {
            foreach (Stream stream in m_streams)
                stream.Close();
            m_streams = null;
        }
    }

    public void Export(LocalReport report)
    {
        string deviceInfo =
          "<DeviceInfo>" +
          "  <OutputFormat>EMF</OutputFormat>" +
          "  <PageWidth>8.27in</PageWidth>" +
          "  <PageHeight>11.69in</PageHeight>" +
          "  <MarginTop>0.5in</MarginTop>" +
          "  <MarginLeft>0.5in</MarginLeft>" +
          "  <MarginRight>0.5in</MarginRight>" +
          "  <MarginBottom>0.5in</MarginBottom>" +
          "</DeviceInfo>";
        Warning[] warnings;
        m_streams = new List<Stream>();
        report.Render("Image", deviceInfo, CreateStream,
           out warnings);



        foreach (Stream stream in m_streams)
            stream.Position = 0;
    }
    // Handler for PrintPageEvents
    public void PrintPage(object sender, PrintPageEventArgs ev)
    {
        Metafile pageImage = new
           Metafile(m_streams[m_currentPageIndex]);
        ev.Graphics.DrawImage(pageImage, ev.PageBounds);
        m_currentPageIndex++;
        ev.HasMorePages = (m_currentPageIndex < m_streams.Count);
    }

    public void Print()
    {
        if (m_streams == null || m_streams.Count == 0)
            return;
        printDoc.PrinterSettings.PrinterName = cmbPrinters.SelectedItem.Text;
        if (!printDoc.PrinterSettings.IsValid)
        {
            string msg = String.Format(
               "Can't find printer \"{0}\".", cmbPrinters.SelectedItem.Text);
            return;
        }
        printDoc.PrintPage += new PrintPageEventHandler(PrintPage);
        printDoc.Print();
    }
    private Stream CreateStream(string name, string fileNameExtension, Encoding encoding, string mimeType, bool willSeek)
    {
        Stream stream = new MemoryStream();
        m_streams.Add(stream);
        return stream;
    }

    protected void chkAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkAll.Checked == true)
        {
            foreach (ListItem li in chkids.Items)
            {

                if (li.Text.ToLower() == "regno" || li.Text.ToLower() == "student name" || li.Text.ToLower() == "class" || li.Text.ToLower() == "section")
                {
                    li.Selected = true;
                    li.Enabled = false;
                }
                else
                {
                    li.Selected = true;
                }
            }
            unchkAll.Checked = false;
        }

    }

    protected void unchkAll_CheckedChanged(object sender, EventArgs e)
    {
        if (unchkAll.Checked == true)
        {
            foreach (ListItem li in chkids.Items)
            {

                if (li.Text.ToLower() == "regno" || li.Text.ToLower() == "student name" || li.Text.ToLower() == "class" || li.Text.ToLower() == "section")
                {
                    li.Selected = true;
                    li.Enabled = false;
                }
                else
                {
                    li.Selected = false;
                }
            }
            chkAll.Checked = false;
        }

    }

     
}