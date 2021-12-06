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

public partial class Reports_GSTBillingReport : System.Web.UI.Page
{
    string sDate = "";
    string eDate = "";
    Utilities utl = null;
    public static int Userid = 0;
    public static string AcademicID;
    public int m_currentPageIndex;
    public IList<Stream> m_streams;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindFees();
            AcademicID = Session["AcademicID"].ToString();
           
            hfSDate.Value = System.DateTime.Now.ToString("MM/dd/yyyy");
            hfEDate.Value = System.DateTime.Now.ToString("MM/dd/yyyy");

            txtStartdate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            txtEnddate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            utl = new Utilities();
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            ReportParameter Schoolname = new ReportParameter("schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            ReportParameter Type = new ReportParameter("Type", ddltype.Text.ToString());
            ReportParameter Startdate = new ReportParameter("Startdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Enddate = new ReportParameter("Enddate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
            GSTReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
            GSTReport.LocalReport.SetParameters(new ReportParameter[] { Startdate });
            GSTReport.LocalReport.SetParameters(new ReportParameter[] { Enddate });
            GSTReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
            GSTReport.LocalReport.SetParameters(new ReportParameter[] { Type });

        }

    }

    private void bindFees()
    {
        ddlFeesHead.Items.Clear();
        utl = new Utilities();
        DataTable dts = new DataTable();
        dts = utl.GetDataTable("select FeesHeadID,FeesHeadName,FeesHeadCode,HSNCode from m_feeshead where isactive=1 and istaxable=1 and FeesHeadCode='U'");
        if (dts.Rows.Count>0)
        {
            ddlFeesHead.DataSource = dts;
            ddlFeesHead.DataTextField = "FeesHeadName";
            ddlFeesHead.DataValueField = "FeesHeadID";
            ddlFeesHead.DataBind();
        }
        ddlFeesHead.Items.Insert(0, "Select");
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
        ReportParameter Schoolname = new ReportParameter("schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        ReportParameter Startdate = new ReportParameter("Startdate", txtStartdate.Text);
        ReportParameter Enddate = new ReportParameter("Enddate", txtEnddate.Text);
        ReportParameter Type = new ReportParameter("Type", ddltype.Text.ToString());
        ReportParameter Printdate = new ReportParameter("Printdate", System.DateTime.Now.ToString("dd/MM/yyyy"));
        GSTReport.LocalReport.SetParameters(new ReportParameter[] { Schoolname });
        GSTReport.LocalReport.SetParameters(new ReportParameter[] { Startdate });
        GSTReport.LocalReport.SetParameters(new ReportParameter[] { Enddate });
        GSTReport.LocalReport.SetParameters(new ReportParameter[] { Printdate });
        GSTReport.LocalReport.SetParameters(new ReportParameter[] { Type });
        GSTReport.LocalReport.Refresh();

        GSTReport.LocalReport.Refresh();
    }

    protected void txtStartdate_TextChanged(object sender, EventArgs e)
    {
        Session["sDate"] = txtStartdate.Text;
        Session["eDate"] = "";
    }
    protected void txtEnddate_TextChanged(object sender, EventArgs e)
    {
        Session["sDate"] = txtStartdate.Text;
        Session["eDate"] = txtEnddate.Text;
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



    protected void ddlFeesHead_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlFeesHead.SelectedIndex!=-1 && ddlFeesHead.SelectedIndex!=0)
        {
            Session["FeesHeadID"] = ddlFeesHead.SelectedValue;
        }
        else
        {
            Session["FeesHeadID"] = "";
        }
    }
}