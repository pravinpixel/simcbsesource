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
public partial class Reports_BusRouteReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    string strBusRouteID = "";
    string strBusRoute = "";
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
            BindBus();
            BindClass();
            BindBusRoute();
            DataTable dtSchool = new DataTable();
            utl = new Utilities();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            string Busroute = "";
            if (ddlBusRoute.SelectedItem != null && ddlBusRoute.SelectedItem.Text != "-----Select-----")
            {
                Busroute = ddlBusRoute.SelectedItem.Text;
            }
            else
            {
                Busroute = "All Routes";
            }
            Session["strClass"] = "All Class";
            Session["strSection"] = "All Section";
            ReportParameter Busroutename = new ReportParameter("Busroutename", Busroute);
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            BusRoute.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            BusRoute.LocalReport.SetParameters(new ReportParameter[] { Busroutename });
            BusRoute.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        }

    }

    private void BindBus()
    {
        utl = new Utilities();
        DataSet dsBus = new DataSet();
        dsBus = utl.GetDataset("select distinct (substring(routecode,1,1))as RouteCode from m_busroute");
        if (dsBus != null && dsBus.Tables.Count > 0 && dsBus.Tables[0].Rows.Count > 0)
        {
            ddlBus.DataSource = dsBus;
            ddlBus.DataTextField = "RouteCode";
            ddlBus.DataValueField = "RouteCode";
            ddlBus.DataBind();
        }
        else
        {
            ddlBus.DataSource = null;
            ddlBus.DataTextField = "";
            ddlBus.DataValueField = "";
            ddlBus.DataBind();
        }
        ddlBus.Items.Insert(0, "-----Select-----");
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

    protected void BindBusRoute()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("sp_GetBusRouteDetails " + "''");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlBusRoute.DataSource = dsClass;
            ddlBusRoute.DataTextField = "BusRouteName";
            ddlBusRoute.DataValueField = "RouteCode";
            ddlBusRoute.DataBind();
        }
        else
        {
            ddlBusRoute.DataSource = null;
            ddlBusRoute.DataTextField = "";
            ddlBusRoute.DataValueField = "";
            ddlBusRoute.DataBind();
        }
        ddlBusRoute.Items.Insert(0, "-----Select-----");
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

    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (BusRoute != null)
        {
            BusRoute.Dispose();
            GC.SuppressFinalize(BusRoute);
            GC.Collect();
        }    

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        string Busroute = "";
        if (ddlBusRoute.SelectedItem != null && ddlBusRoute.SelectedItem.Text != "-----Select-----")
        {
            Busroute = ddlBusRoute.SelectedItem.Text;
        }
        else
        {
            Busroute = "All Routes";
        }
        ReportParameter Busroutename = new ReportParameter("Busroutename", Busroute);
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        ReportParameter className = new ReportParameter("className", Session["strClass"] + "/" + Session["strSection"]);
        BusRoute.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        BusRoute.LocalReport.SetParameters(new ReportParameter[] { Busroutename });
        BusRoute.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        BusRoute.LocalReport.SetParameters(new ReportParameter[] { className });
        BusRoute.LocalReport.Refresh(); 
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        Export(BusRoute.LocalReport);
        m_currentPageIndex = 0;
        Print();
    }
    protected void BusRoute_Init(object sender, EventArgs e)
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
                    ddlBusRoute.DataSource = null;
                    Session["strBusRoute"] = null;
                    Session["strBusRouteID"] = null;
                }
                DataTable dt = new DataTable();
                utl = new Utilities();
                BindBusRoute();
            }
        }
        catch (Exception)
        {


        }
    }

 
    private void PrintReport()
    {
         
        
    }

    protected void ddlBusRoute_SelectedIndexChanged(object sender, EventArgs e)
    {
           Session["strBusRouteID"] = ddlBusRoute.SelectedValue;
    }
    protected void BusRoute_Unload(object sender, EventArgs e)
    {
        if (BusRoute != null)
        {
            BusRoute.Dispose();
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
}