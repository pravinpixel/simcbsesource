using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.IO;
using System.Drawing.Printing;
using System.Text;
using System.Configuration;
using System.Drawing.Imaging;
using System.Globalization;

public partial class Reports_FeesCollectionReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    string Month = "";
    Utilities utl = null;
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
            DataTable dtSchool = new DataTable();
            utl = new Utilities();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter SchoolName = new ReportParameter("SchoolName", dtSchool.Rows[0]["SchoolName"].ToString());
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

            ReportParameter Month = new ReportParameter("formonth", monthname);
            ReportParameter Printdate = new ReportParameter("PrintDate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Class = new ReportParameter("Class", ddlClass.SelectedItem.Text + "/" + ddlSection.SelectedItem.Text);
            ReportFeesCollection.LocalReport.SetParameters(new ReportParameter[] { SchoolName });
            ReportFeesCollection.LocalReport.SetParameters(new ReportParameter[] { Month });
            ReportFeesCollection.LocalReport.SetParameters(new ReportParameter[] { Printdate });
            ReportFeesCollection.LocalReport.SetParameters(new ReportParameter[] { Class });
        }
    }
    private void BindAcademicMonths()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        if (Session["AcademicID"] != null)
        {
            dt = utl.GetDataTable("select top 1 convert(varchar,startdate,121)startdate,convert(Varchar,enddate,121)enddate from m_academicyear where " +
    "academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
        }
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
        ddlClass.Items.Insert(0, new ListItem("--Select---", ""));
    }
    protected void BindSectionByClass()
    {
        utl = new Utilities();
        DataSet dsSection = new DataSet();
        dsSection = utl.GetDataset("sp_GetSectionByClass " + ddlClass.SelectedValue);
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

    private void Page_Init(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        if (!Page.IsPostBack)
        {
            Session["strClass"] = "All Class";
            Session["strSection"] = "All Section";
        }

        BindAcademicMonths();
        BindClass();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dtSchool = new DataTable();
        utl = new Utilities();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter SchoolName = new ReportParameter("SchoolName", dtSchool.Rows[0]["SchoolName"].ToString());
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

        
        ReportParameter Month = new ReportParameter("formonth", monthname);
        ReportParameter Printdate = new ReportParameter("PrintDate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        ReportParameter Class = new ReportParameter("Class", Session["strClass"].ToString() + "/" + Session["strSection"].ToString());
        ReportFeesCollection.LocalReport.SetParameters(new ReportParameter[] { SchoolName });
        ReportFeesCollection.LocalReport.SetParameters(new ReportParameter[] { Month });
        ReportFeesCollection.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        ReportFeesCollection.LocalReport.SetParameters(new ReportParameter[] { Class });

    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(ReportFeesCollection.LocalReport);
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
        printDoc.DefaultPageSettings.PaperSize = new PaperSize(rps.PaperSize.Kind.ToString(), rps.PaperSize.Height, rps.PaperSize.Width);

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
        }
    }
}