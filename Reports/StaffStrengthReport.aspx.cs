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
using System.Drawing.Imaging;
using System.Drawing.Printing;
using System.Text;

public partial class Reports_StaffStrengthReport : System.Web.UI.Page
{
    string sqlstr = "";
    public int m_currentPageIndex;
    public IList<Stream> m_streams;
    PrintDocument printDoc = new PrintDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            Utilities utl = new Utilities();
           
            sqlstr = "update a set a.DesignationID=b.DesignationID from e_staffinfo a inner join e_staffcareerservice b on a.StaffId=b.StaffId and CareerServiceDate =(select MAX(CareerServiceDate) from e_staffcareerservice where StaffId=a.StaffId)";
            utl.ExecuteQuery(sqlstr);
            sqlstr = "update a set a.DepartmentID=b.DepartmentID from e_staffinfo a inner join e_staffacdservices b on a.StaffId=b.StaffId and AcademicId =(select AcademicId from m_academicyear where IsActive=1)";
            utl.ExecuteQuery(sqlstr);
            
            cmbPrinters.Items.Clear();
            foreach (string sPrinters in System.Drawing.Printing.PrinterSettings.InstalledPrinters)
            {
                cmbPrinters.Items.Add(sPrinters);                
            }
            
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            ReportParameter PrintDate = new ReportParameter("PrintDate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            StaffStrengthReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            StaffStrengthReport.LocalReport.SetParameters(new ReportParameter[] { PrintDate });
            StaffStrengthReport.LocalReport.Refresh();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Utilities utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        ReportParameter PrintDate = new ReportParameter("PrintDate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        StaffStrengthReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        StaffStrengthReport.LocalReport.SetParameters(new ReportParameter[] { PrintDate });
        StaffStrengthReport.LocalReport.Refresh();
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(StaffStrengthReport.LocalReport);
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
}