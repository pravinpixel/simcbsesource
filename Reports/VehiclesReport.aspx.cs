using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.Drawing.Printing;
using System.Drawing.Imaging;
using System.Text;
using System.Globalization;
using System.Net;
using System.IO;

public partial class Reports_VehiclesReport : System.Web.UI.Page
{
    public int m_currentPageIndex;
    public IList<Stream> m_streams;
    private PageSettings m_pagesettings;
    PrintDocument printDoc = new PrintDocument();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

             
            Utilities utl = new Utilities();
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("SchoolName", dtSchool.Rows[0]["SchoolName"].ToString());
            ReportParameter Printdate = new ReportParameter("PrintDate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            VehicleReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            VehicleReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
            VehicleReport.LocalReport.Refresh();
          
        }
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(VehicleReport.LocalReport);
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