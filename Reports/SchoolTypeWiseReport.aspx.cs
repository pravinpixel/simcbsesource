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

public partial class Reports_SchoolTypeWiseReport : System.Web.UI.Page
{
    string sDate = "";
    string eDate = "";
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
            hfSDate.Value = System.DateTime.Now.ToString("yyyy-MM-dd");
            hfEDate.Value = System.DateTime.Now.ToString("yyyy-MM-dd");

            txtStartdate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            txtEnddate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            utl = new Utilities();
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            ReportParameter Startdate = new ReportParameter("Startdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Enddate = new ReportParameter("Enddate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            SchoolTypewise.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            SchoolTypewise.LocalReport.SetParameters(new ReportParameter[] { Startdate });
            SchoolTypewise.LocalReport.SetParameters(new ReportParameter[] { Enddate });
            SchoolTypewise.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        }
    }
    protected void Page_UnLoad(object sender, EventArgs e)
    {
       
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


        utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        ReportParameter Startdate = new ReportParameter("Startdate", txtStartdate.Text);
        ReportParameter Enddate = new ReportParameter("Enddate", txtEnddate.Text);
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        SchoolTypewise.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        SchoolTypewise.LocalReport.SetParameters(new ReportParameter[] { Startdate });
        SchoolTypewise.LocalReport.SetParameters(new ReportParameter[] { Enddate });
        SchoolTypewise.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        SchoolTypewise.LocalReport.Refresh();
        
        }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(SchoolTypewise.LocalReport);
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
                    Session["sDate"] = null;
                    Session["eDate"] = null;

                    DataTable dts = new DataTable();
                    utl = new Utilities();
                    dts = utl.GetDataTable("select top 1 convert(varchar,startdate,103)startdate,convert(Varchar,enddate,103)enddate from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
                    if (dts.Rows.Count > 0)
                    {
                        txtStartdate.Text = dts.Rows[0]["startdate"].ToString();
                        txtEnddate.Text = dts.Rows[0]["enddate"].ToString();
                    }
                    else
                    {
                        txtStartdate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                        txtEnddate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                    }
                    //btnSearch_Click(sender, e);
                }
              
                DataTable dt = new DataTable();
                utl = new Utilities();
            }
        }
        catch (Exception)
        {

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
}