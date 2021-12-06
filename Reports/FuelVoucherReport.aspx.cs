using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;
using System.Data;
using System.Drawing.Printing;
using System.Drawing.Imaging;
using System.Text;
using System.IO;
using System.Configuration;
using System.Management;
public partial class Reports_FuelVoucherReport : System.Web.UI.Page
{
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
            hfSDate.Value = System.DateTime.Now.ToString("MM/dd/yyyy");
            hfEDate.Value = System.DateTime.Now.ToString("MM/dd/yyyy");

            txtStartdate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            txtEnddate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            Utilities utl = new Utilities();
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            ReportParameter formonth = new ReportParameter("formonth", System.DateTime.Now.ToString("dd/MM/yyyy") + " - " + System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            FuelVoucherReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            FuelVoucherReport.LocalReport.SetParameters(new ReportParameter[] { formonth });
            FuelVoucherReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        }
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(FuelVoucherReport.LocalReport);
        m_currentPageIndex = 0;
        Print();
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

        Utilities utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        ReportParameter formonth = new ReportParameter("formonth", txtStartdate.Text+" - "+txtEnddate.Text);
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        FuelVoucherReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        FuelVoucherReport.LocalReport.SetParameters(new ReportParameter[] { formonth });
        FuelVoucherReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
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