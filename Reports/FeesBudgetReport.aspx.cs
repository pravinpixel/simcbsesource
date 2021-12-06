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
public partial class Reports_FeesBudgetReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    public int m_currentPageIndex;
    public IList<Stream> m_streams;
    Utilities utl = null;
    public static int Userid = 0;
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
            BindAcademicMonths();
            utl = new Utilities();
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Classname = new ReportParameter("Classname", "");
            FeesBudgetReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            FeesBudgetReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
            FeesBudgetReport.LocalReport.SetParameters(new ReportParameter[] { Classname });
            FeesBudgetReport.LocalReport.Refresh();
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
            dpClass.DataSource = dsClass;
            dpClass.DataTextField = "ClassName";
            dpClass.DataValueField = "ClassID";
            dpClass.DataBind();
        }
        else
        {
            dpClass.DataSource = null;
            dpClass.DataTextField = "";
            dpClass.DataValueField = "";
            dpClass.DataBind();
        }
        dpClass.Items.Insert(0, new ListItem("---Select---", ""));
    }

    protected void BindSectionByClass()
    {
        utl = new Utilities();
        DataSet dsSection = new DataSet();
        if (dpClass.SelectedValue != string.Empty)
        {
            dsSection = utl.GetDataset("sp_GetSectionByClass " + dpClass.SelectedValue);
        }
        else
        {
            dpSection.Items.Clear();
        }

        dpSection.DataSource = null;
        dpSection.AppendDataBoundItems = false;
        if (dsSection != null && dsSection.Tables.Count > 0 && dsSection.Tables[0].Rows.Count > 0)
        {
            dpSection.DataSource = dsSection;
            dpSection.DataTextField = "SectionName";
            dpSection.DataValueField = "SectionID";
            dpSection.DataBind();
        }
        else
        {
            dpSection.DataSource = null;
            dpSection.DataTextField = "";
            dpSection.DataValueField = "";
            dpSection.DataBind();
        }
        dpSection.Items.Insert(0, "-----Select-----");
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
            dpSection.DataSource = null;
            DataTable dt = new DataTable();
            utl = new Utilities();
            BindClass();
        }
    }
    
    protected void Page_UnLoad(object sender, EventArgs e)
    {
        
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        ReportParameter Classname = new ReportParameter("Classname", Session["strClass"] + "/" + Session["strSection"]);
        ReportParameter forMonth = new ReportParameter("formonth", ddlMonth.SelectedItem.Text);
        FeesBudgetReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        FeesBudgetReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        FeesBudgetReport.LocalReport.SetParameters(new ReportParameter[] { forMonth });
        FeesBudgetReport.LocalReport.SetParameters(new ReportParameter[] { Classname });
        FeesBudgetReport.LocalReport.Refresh();
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(FeesBudgetReport.LocalReport);
        m_currentPageIndex = 0;
        Print();
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
    protected void dpClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["strSection"] = "All Section";
        Session["strClass"] = "All Class";
        BindSectionByClass();
        if (dpClass.SelectedItem.Text == "-----Select-----" || dpClass.SelectedItem.Value == "-----Select-----" || dpClass.SelectedItem.Value == "")
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
            Session["strClass"] = dpClass.SelectedItem.Text;
            Session["strClassID"] = dpClass.SelectedValue;
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "All Section";
            Session["strSectionID"] = "";
        }
    }
    protected void dpSection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (dpSection.SelectedItem.Text == "-----Select-----" || dpSection.SelectedItem.Value == "-----Select-----")
        {
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "All Section";
        }
        else
        {
            Session["strSection"] = dpSection.SelectedItem.Text;
            Session["strSectionID"] = dpSection.SelectedValue;
        }
    }
}