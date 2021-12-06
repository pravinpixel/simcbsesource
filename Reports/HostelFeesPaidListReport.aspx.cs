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
public partial class Reports_HostelFeesPaidListReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    string StrStartDate = "";
    string StrEndDate = "";

    string StrMonth = "";
    string StrMonthID = "";
    Utilities utl = null;
    public int m_currentPageIndex;
    public IList<Stream> m_streams;
    PrintDocument printDoc = new PrintDocument();
    public static int Userid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            cmbPrinters.Items.Clear();
            foreach (string sPrinters in System.Drawing.Printing.PrinterSettings.InstalledPrinters)
            {
                cmbPrinters.Items.Add(sPrinters);
            }
            Session["strClass"] = "All Class";
            Session["strSection"] = "All Section";
            BindClass();
            hfSDate.Value = System.DateTime.Now.ToString("MM/dd/yyyy");
            txtStartdate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            txtEnddate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            DataTable dtSchool = new DataTable();
            utl = new Utilities();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            ReportParameter Startdate = new ReportParameter("Startdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Enddate = new ReportParameter("Enddate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Class = new ReportParameter("Class", "");
            HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Startdate });
            HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Enddate });
            HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Printdate });
            HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Class });
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
    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["strClass"] = "All Class";
        Session["strSection"] = "All Section";
        BindSectionByClass();
        if (ddlClass.SelectedItem.Text == "-----Select-----" || ddlClass.SelectedItem.Value == "-----Select-----" || ddlClass.SelectedItem.Value == "")
        {
            strClass = "";
            strClassID = "";
            strSection = "";
            strSectionID = "";
            Session["strClass"] = "All Class";
            Session["strSection"] = "All Section";

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
    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (HostelFeesPaidList != null)
        {
            HostelFeesPaidList.Dispose();
            GC.Collect();
        }

    }
    protected void HostelFeesPaidList_Unload(object sender, EventArgs e)
    {
        if (HostelFeesPaidList != null)
        {
            HostelFeesPaidList.Dispose();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (txtStartdate.Text != "")
        {
            string[] myDateTimeString = txtStartdate.Text.ToString().Split('/');
            hfSDate.Value = "" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }
        if (txtEnddate.Text != "")
        {
            string[] myDateTimeString = txtEnddate.Text.ToString().Split('/');
            hfEDate.Value = "" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }
       
        DataTable dtSchool = new DataTable();
        utl = new Utilities();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        ReportParameter Startdate = new ReportParameter("Startdate", txtStartdate.Text);
        ReportParameter Enddate = new ReportParameter("Enddate", txtEnddate.Text);
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        ReportParameter Class = new ReportParameter("Class", Session["strClass"] + "/" + Session["strSection"]);
        HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Startdate });
        HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Enddate });
        HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        HostelFeesPaidList.LocalReport.SetParameters(new ReportParameter[] { Class });
        HostelFeesPaidList.LocalReport.Refresh();
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(HostelFeesPaidList.LocalReport);
        m_currentPageIndex = 0;
        Print();
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
                if (!IsPostBack)
                {
                    Session["StrMonth"] = null;
                    Session["StrMonthID"] = null;
                    Session["StrStartDate"] = null;
                    Session["StrEndDate"] = null;

                }

            }
        }
        catch (Exception)
        {


        }
    }

 
    protected void txtStartdate_TextChanged(object sender, EventArgs e)
    {
        if (txtStartdate.Text != "")
        {
            Session["StrStartDate"] = txtStartdate.Text;
            StrMonth = "";
            StrMonthID = "";
            Session["StrMonth"] = "";
            Session["StrMonthID"] = "";
        }

    }
    protected void txtEnddate_TextChanged(object sender, EventArgs e)
    {
        if (txtEnddate.Text != "")
        {
            Session["StrEndDate"] = txtEnddate.Text;
            StrMonth = "";
            StrMonthID = "";
            Session["StrMonth"] = "";
            Session["StrMonthID"] = "";
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
        string deviceInfo =
          "<DeviceInfo>" +
          "  <OutputFormat>EMF</OutputFormat>" +
            "  <StartPage>0</StartPage>" +
              "  <EndPage>0</EndPage>" +
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
     
}