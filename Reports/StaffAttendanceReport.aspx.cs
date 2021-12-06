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
using System.Net;

public partial class Reports_StaffAttendanceReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    public static int AcademicID = 0;
    string Month = "";
    Utilities utl = null;
    public static int Userid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
         
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            Userid = Convert.ToInt32(Session["UserId"]);
            AcademicID = Convert.ToInt32(Session["AcademicID"]);
            if (!IsPostBack)
            {
                DataTable dtSchool = new DataTable();
                utl = new Utilities();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                dvCard.InnerHtml = "";
                txtStartdate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtEnddate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            }
        }       

    }   
    
   

   
    private void Page_Init(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }         

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
    protected void btnSearch_Click(object sender, EventArgs e)
    {

        utl = new Utilities();
        string StartDate = "", EndDate = "";
        if (txtStartdate.Text != "")
        {
            string[] myDateTimeString = txtStartdate.Text.ToString().Split('/');
            StartDate = "" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }
        if (txtEnddate.Text != "")
        {
            string[] myDateTimeString = txtEnddate.Text.ToString().Split('/');
            EndDate = "" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }
        string sqlstr = "sp_getStaffAttendance '" + StartDate + "','" + EndDate + "','"+  Session["AcademicID"] +"'";
        DataTable DataTable1 = new DataTable();
        DataSet dsGet = new DataSet();
        dsGet = utl.GetDataset(sqlstr);
        StringBuilder str = new StringBuilder();
        string chkempcode = string.Empty;
        int p = 0;
        if (dsGet != null && dsGet.Tables[0].Rows.Count > 0 && dsGet.Tables.Count>0)
        {
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            str.Append("<table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
            str.Append("<td colspan='3' align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>Staff Attendance Report</td></tr></table>");

            str.Append("<table class=performancedata  border=1 cellspacing=5 cellpadding=10 width=100%><tr><td align='left'><b>Sl.No.</b></td><td align='left'><b>EmpCode</label></td><td align='left'><b>StaffName</b></td><td align='left'><b>Designation</b></td><td align='left'><b>Absent Date</b></td><td align='left'><b>Reason</b></td><td align='left'><b>Count</b></td></tr>");
            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {
                double Icnt = 0;
                if (chkempcode != dsGet.Tables[0].Rows[i]["EmpCode"].ToString())
                {
                    p = p + 1;                    
                    DataRow[] drAbsentdate = dsGet.Tables[0].Select("EmpCode='" + dsGet.Tables[0].Rows[i]["EmpCode"].ToString() + "' ");

                    if (drAbsentdate.Length > 0)
                    {
                        for (int j = 0; j < drAbsentdate.Length; j++)
                        {
                           
                            if (drAbsentdate[j]["ForeNoon"].ToString() == "True")
                            {
                                Icnt = Icnt + 0.5;
                            }
                            if (drAbsentdate[j]["AfterNoon"].ToString() == "True")
                            {
                                Icnt = Icnt + 0.5;
                            }
                        }
                        str.Append(@"<tr><td align='center'>" + p.ToString() + "</td><td align='center'>" + drAbsentdate[0]["EmpCode"].ToString() + "</td><td> " + drAbsentdate[0]["StaffName"].ToString() + "</td><td>" + drAbsentdate[0]["DesignationName"].ToString() + "</td><td>" + drAbsentdate[0]["Attdate"].ToString() + "</td><td>" + drAbsentdate[0]["Reason"].ToString() + "</td><td rowspan=" + drAbsentdate.Length.ToString() + " align='center'>" + Convert.ToDecimal(Icnt).ToString() + "</td></tr>");                       


                        for (int j = 1; j < drAbsentdate.Length; j++)
                        {
                            str.Append(@"<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>" + drAbsentdate[j]["Attdate"].ToString() + "</td><td>" + drAbsentdate[j]["Reason"].ToString() + "</td></tr>");
                        }                        

                        chkempcode = dsGet.Tables[0].Rows[i]["EmpCode"].ToString();                       
                    }                   
                  
                }               

            }
            str.Append(@"</table>");
            dvCard.InnerHtml = str.ToString();
        }
        else
        {
            dvCard.InnerHtml = str.ToString();
        }
    }
    
    protected void btnExport_Click(object sender, EventArgs e)
    {

        utl = new Utilities();
        string StartDate = "", EndDate = "";
        if (txtStartdate.Text != "")
        {
            string[] myDateTimeString = txtStartdate.Text.ToString().Split('/');
            StartDate = "" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }
        if (txtEnddate.Text != "")
        {
            string[] myDateTimeString = txtEnddate.Text.ToString().Split('/');
            EndDate = "" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }
        string sqlstr = "sp_getStaffAttendance '" + StartDate + "','" + EndDate + "','" + Session["AcademicID"] + "'";
        DataTable DataTable1 = new DataTable();
        DataTable1 = utl.GetDataTable(sqlstr);
        StringBuilder str = new StringBuilder();
        if (DataTable1 != null && DataTable1.Rows.Count > 0)
        {
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            str.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
            str.Append("<td colspan='3' align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>Staff Attendance Report</td></tr></table>");

            str.Append("<table class=performancedata  border=1 cellspacing=5 cellpadding=10 width=100%><tr><td align='left'><b>Sl.No.</b></td><td align='left'><b>EmpCode</label></td><td align='left'><b>StaffName</b></td><td align='left'><b>Designation</b></td><td align='left'><b>Absent Date</b></td><td align='left'><b>Reason</b></td></tr>");
            for (int i = 0; i < DataTable1.Rows.Count; i++)
            {
                str.Append(@"<tr><td>" + (i + 1).ToString() + "</td><td>" + DataTable1.Rows[i]["EmpCode"].ToString() + "</td><td>" + DataTable1.Rows[i]["StaffName"].ToString() + "</td><td>" + DataTable1.Rows[i]["DesignationName"].ToString() + "</td><td>" + DataTable1.Rows[i]["AttDate"].ToString() + "</td><td>" + DataTable1.Rows[i]["Reason"].ToString() + "</td></tr>");

            }
            str.Append(@"</table>");
            dvCard.InnerHtml = str.ToString();

        }
        else
        {
            dvCard.InnerHtml = str.ToString();
        }
    }
}