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
public partial class Reports_HostelReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    string strHostelID = "";
    string strHostel = "";
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
            BindHostel();
            DataTable dtSchool = new DataTable();
            utl = new Utilities();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            string sGender = "";
            if (ddlGender.SelectedItem != null && ddlGender.SelectedItem.Text != "-----Select----")
            {
                sGender = ddlGender.SelectedItem.Text;
            }
            else
            {
                sGender = "-";
            }
            ReportParameter Hostelname = new ReportParameter("Hostelname", ddlHostel.SelectedItem.Text);
            ReportParameter Gender = new ReportParameter("Gender", sGender);
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            Hostel.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            Hostel.LocalReport.SetParameters(new ReportParameter[] { Hostelname });
            Hostel.LocalReport.SetParameters(new ReportParameter[] { Gender });
            Hostel.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        }

    }


    protected void BindHostel()
    {
        utl = new Utilities();
        DataSet dsHostel = new DataSet();
        dsHostel = utl.GetDataset("sp_GetHostel " + "''");
        if (dsHostel != null && dsHostel.Tables.Count > 0 && dsHostel.Tables[0].Rows.Count > 0)
        {
            ddlHostel.DataSource = dsHostel;
            ddlHostel.DataTextField = "HostelName";
            ddlHostel.DataValueField = "HostelID";
            ddlHostel.DataBind();
        }
        else
        {
            ddlHostel.DataSource = null;
            ddlHostel.DataTextField = "";
            ddlHostel.DataValueField = "";
            ddlHostel.DataBind();
        }
    }


    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (Hostel != null)
        {
            Hostel.Dispose();
            GC.SuppressFinalize(Hostel);
            GC.Collect();
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        string sGender = "";
        if (ddlGender.SelectedItem != null && ddlGender.SelectedItem.Text != "-----Select----")
        {
            sGender = ddlGender.SelectedItem.Text;
        }
        else
        {
            sGender = "-";
        }
        ReportParameter Hostelname = new ReportParameter("Hostelname", ddlHostel.SelectedItem.Text);
        ReportParameter Gender = new ReportParameter("Gender", sGender);
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        Hostel.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        Hostel.LocalReport.SetParameters(new ReportParameter[] { Hostelname });
        Hostel.LocalReport.SetParameters(new ReportParameter[] { Gender });
        Hostel.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        Hostel.LocalReport.Refresh();
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(Hostel.LocalReport);
        m_currentPageIndex = 0;
        Print();
    }
    protected void Hostel_Init(object sender, EventArgs e)
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
            else
            {
                if (!IsPostBack)
                {
                    ddlHostel.DataSource = null;
                    Session["strHostel"] = null;
                    Session["strHostelID"] = null;
                }
                DataTable dt = new DataTable();
                utl = new Utilities();
                BindHostel();
            }
        }
        catch (Exception)
        {


        }
    }


    private void PrintReport()
    {


    }

    protected void ddlHostel_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["strHostelID"] = ddlHostel.SelectedValue;
    }
    protected void Hostel_Unload(object sender, EventArgs e)
    {
        if (Hostel != null)
        {
            Hostel.Dispose();
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