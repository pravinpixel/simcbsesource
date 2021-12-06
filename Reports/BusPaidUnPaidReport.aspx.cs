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
using System.Globalization;
using System.Net;

public partial class Reports_BusPaidUnPaidReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    string Month = "";
    Utilities utl = null;
    public static int Userid = 0;
    public int m_currentPageIndex;
    public IList<Stream> m_streams;
    private PageSettings m_pagesettings;
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
            BindAcademicMonths();
            BindClass();
            DataTable dtSchool = new DataTable();
            utl = new Utilities();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            string monthname = "";
            if (ddlMonth.SelectedItem != null)
            {

                if (ddlMonth.SelectedItem.Text == "---Select---")
                {
                    monthname = "";
                }
                else
                {
                    monthname = ddlMonth.SelectedItem.Text;
                }
            }
            if (rbtnPaid.Checked == true)
            {
                rbtnUnPaid.Checked = false;
                Session["strType"] = "PaidList";
            }
            else if (rbtnUnPaid.Checked == true)
            {
                rbtnPaid.Checked = false;
                Session["strType"] = "PaidList";
            }
            string istrType = Session["strType"].ToString();
            ReportParameter Month = new ReportParameter("Month", monthname);
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter strType = new ReportParameter("strType", istrType);
            ReportParameter Class = new ReportParameter("Class", "");
            BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { Month });
            BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
            BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { strType });
            BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { Class });
            ReportParameter tlPortrait = new ReportParameter("TLPORTRAIT", "false", false);
            BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { tlPortrait });

        }
     
    }
    private void BindAcademicMonths()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable("select top 1 convert(varchar,startdate,121)startdate,convert(Varchar,enddate,121)enddate from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
        if (dt.Rows.Count > 0)
        {
            DataTable dtmon = new DataTable();
            dtmon = utl.GetDataTable("exec sp_getacademicmonths '" + dt.Rows[0]["startdate"].ToString() + "','" + dt.Rows[0]["enddate"].ToString() + "'");
            if (dtmon != null && dtmon.Rows.Count > 0)
            {
                ddlMonth.DataSource = dtmon;
                ddlMonth.DataTextField = "fullmonth";
                ddlMonth.DataValueField = "shortmonth";
                ddlMonth.DataBind();
            }
            else
            {
                ddlMonth.DataSource = null;
                ddlMonth.DataTextField = "";
                ddlMonth.DataValueField = "";
                ddlMonth.DataBind();
            }
            ddlMonth.Items.Insert(0, new ListItem("---Select---", ""));
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
        if (ddlClass.SelectedValue!=string.Empty)
        {
            dsSection = utl.GetDataset("sp_GetSectionByClass " + ddlClass.SelectedValue);
        }
        else
        {
            ddlSection.Items.Clear();
        }
       
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
        ddlSection.Items.Insert(0, "-----Select-----");
    }

    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (BusPaidUnPaidReport != null)
        {
            BusPaidUnPaidReport.Dispose();
            GC.Collect();
        }    
    }
    private void Page_Init(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            btnSearch_Click(sender, e);
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dtSchool = new DataTable();
        utl = new Utilities();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        string monthname = "";
        if (ddlMonth.SelectedItem != null)
        {

            if (ddlMonth.SelectedItem.Text == "---Select---")
            {
                monthname = "";
            }
            else
            {
                monthname = ddlMonth.SelectedItem.Text;
            }
        }
        if (rbtnPaid.Checked == true)
        {
            rbtnUnPaid.Checked = false;
            Session["strType"] = "PaidList";
        }
        else if (rbtnUnPaid.Checked == true)
        {
            rbtnPaid.Checked = false;
            Session["strType"] = "UnPaidList";
        }
        string istrType = Session["strType"].ToString();
        ReportParameter Month = new ReportParameter("Month", monthname);
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        ReportParameter strType = new ReportParameter("strType", istrType);
        ReportParameter Class = new ReportParameter("Class", Session["strClass"] + "/" + Session["strSection"]);
        BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { Month });
        BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { strType });
        BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { Class });
        ReportParameter tlPortrait = new ReportParameter("TLPORTRAIT", "false", false);
        BusPaidUnPaidReport.LocalReport.SetParameters(new ReportParameter[] { tlPortrait });
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(BusPaidUnPaidReport.LocalReport);
        m_currentPageIndex = 0;
        Print();
    }
    protected void ddlMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlMonth.Text == "" || ddlMonth.SelectedValue == "---Select---" || ddlMonth.SelectedItem.Text == "---Select---")
        {
            Month = "";
        }
        else if (ddlMonth.SelectedValue != "---Select---" && ddlMonth.SelectedItem.Text != "---Select---")
        {
            Session["Month"] = ddlMonth.SelectedValue;
        }
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
        m_pagesettings = new PageSettings();
        Margins margins = m_pagesettings.Margins;
        ReportPageSettings rps = report.GetDefaultPageSettings();
        printDoc.DefaultPageSettings.Landscape = true;
        printDoc.DefaultPageSettings.PaperSize = new PaperSize(rps.PaperSize.Kind.ToString(),rps.PaperSize.Height, rps.PaperSize.Width);
        
        string deviceInfo = string.Format(
                CultureInfo.InvariantCulture,
                "<DeviceInfo><OutputFormat>emf</OutputFormat><StartPage>0</StartPage><EndPage>0</EndPage><MarginTop>{0}</MarginTop><MarginLeft>{1}</MarginLeft><MarginRight>{2}</MarginRight><MarginBottom>{3}</MarginBottom><PageHeight>{4}</PageHeight><PageWidth>{5}</PageWidth></DeviceInfo>",
                "0.25in",
                "0.25in",
               "15in",
               "0.25in",
                ToInches(rps.PaperSize.Height), "11.5in");

        Warning[] warnings;
        m_streams = new List<Stream>();
        report.Render("Image", deviceInfo, CreateStream,
           out warnings);
        foreach (Stream stream in m_streams)
            stream.Position = 0;
    }
    private static string ToInches(int hundrethsOfInch)
    {
        double inches = hundrethsOfInch / 100.0;
        return inches.ToString(CultureInfo.InvariantCulture) + "in";
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
    protected void rbtnPaid_CheckedChanged(object sender, EventArgs e)
    {
        if (rbtnPaid.Checked==true)
        {
            rbtnUnPaid.Checked = false;
            Session["strType"] = "PaidList";
        }
    }
    protected void rbtnUnPaid_CheckedChanged(object sender, EventArgs e)
    {
        if (rbtnUnPaid.Checked == true)
        {
            rbtnPaid.Checked = false;
            Session["strType"] = "UnPaidList";
        }
    }
    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["strSection"] = "All Section";
        Session["strClass"] = "All Class";
        BindSectionByClass();
        if (ddlClass.SelectedItem.Text == "-----Select-----" || ddlClass.SelectedItem.Value == "-----Select-----" || ddlClass.SelectedItem.Value == "")
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
        if (ddlSection.SelectedItem.Text == "-----Select-----" || ddlSection.SelectedItem.Value == "-----Select-----")
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
}