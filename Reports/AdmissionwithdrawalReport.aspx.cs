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
public partial class Reports_AdmissionwithdrawalReport : System.Web.UI.Page
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
             
            DataTable dtSchool = new DataTable();
            utl = new Utilities();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            string AdmissionWithdraw = "";
           
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            rptAdmissionWithdraw.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            rptAdmissionWithdraw.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        }

    }

    
    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (rptAdmissionWithdraw!= null)
        {
            rptAdmissionWithdraw.Dispose();
            GC.SuppressFinalize(rptAdmissionWithdraw);
            GC.Collect();
        }    

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        rptAdmissionWithdraw.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        rptAdmissionWithdraw.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        rptAdmissionWithdraw.LocalReport.Refresh(); 
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(rptAdmissionWithdraw.LocalReport);
        m_currentPageIndex = 0;
    }
    protected void AdmissionWithdraw_Init(object sender, EventArgs e)
    {

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
        }
        catch (Exception)
        {


        }
    }

 
    private void PrintReport()
    {
         
        
    }

  
    protected void AdmissionWithdraw_Unload(object sender, EventArgs e)
    {
        if (rptAdmissionWithdraw != null)
        {
            rptAdmissionWithdraw.Dispose();
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

  
    private Stream CreateStream(string name, string fileNameExtension, Encoding encoding, string mimeType, bool willSeek)
    {
        Stream stream = new MemoryStream();
        m_streams.Add(stream);
        return stream;
    }
   
}