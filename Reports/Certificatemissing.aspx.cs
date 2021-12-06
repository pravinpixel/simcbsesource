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

public partial class Reports_Certificatemissing : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    public static int AcademicID = 0;
    public static string UserName = string.Empty;
    private static int PageSize = 10;
    string sqlstr = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }

        else
        {
            AcademicID = Convert.ToInt32(Session["AcademicID"]);
            Userid = Convert.ToInt32(Session["UserId"]);
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            LOAD_RESULT();
        }

        catch (Exception ex)
        {
            ClientScript.RegisterClientScriptBlock(this.GetType(), "bnn", "<script>jAlert('" + ex.Message + "')</script>");
        }
    }

    private void LOAD_RESULT()
    {
        utl = new Utilities();
        DataSet dsGetStaffID = new DataSet();
        string sqlstaffid;
        string strmaintable = string.Empty;

        int sno = 0;

        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");

        sqlstaffid = "select StaffID,StaffName,Empcode from e_staffinfo where IsActive=1 and PresentStatus='Active' order by convert(int,Empcode) asc ";
        dsGetStaffID = utl.GetDataset(sqlstaffid);

        if (dsGetStaffID != null && dsGetStaffID.Tables.Count > 0 && dsGetStaffID.Tables[0].Rows.Count > 0)
        {
            strmaintable = @"<table class='form' cellspacing='1' cellpadding='1' width='1000'><tr><td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td><tr></table><table class='performancedata'  border=1 cellspacing=5 cellpadding=10 width=100%><tr><td align='left'><label><b>S.No</b></label></td><td align='left'><label><b>Emp code</b></label></td><td align='left'><label><b>Staff Name</b></label></td><td align='left'><label><b>Certificate Missing Degree List</b></label></td></tr>";

            for (int i = 0; i < dsGetStaffID.Tables[0].Rows.Count; i++)
            {

                string tblacademic = string.Empty;
                DataSet dsGetStaffAcademic = new DataSet();
                string sqlstaffacademic;
                sqlstaffacademic = "sp_GetStaffAcademicInfo " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffAcademic = utl.GetDataset(sqlstaffacademic);

                if (dsGetStaffAcademic != null && dsGetStaffAcademic.Tables.Count > 0 && dsGetStaffAcademic.Tables[0].Rows.Count > 0)
                {
                    for (int p = 0; p < dsGetStaffAcademic.Tables[0].Rows.Count; p++)
                    {
                        string coursecomplete = dsGetStaffAcademic.Tables[0].Rows[p]["CourseCompleted"].ToString();
                        string certificate = dsGetStaffAcademic.Tables[0].Rows[p]["CertNo"].ToString();

                        if (certificate == null || certificate == "")
                        {
                            if (tblacademic == "")
                            {
                                tblacademic = coursecomplete;
                            }
                            else
                            {
                                tblacademic = tblacademic +" " + "|" + " " + coursecomplete ;
                            }
                            
                        }
                    }

                    if (tblacademic != "")
                    {
                        sno = sno + 1;

                        strmaintable = strmaintable + "<tr><td>" + sno.ToString() + "</td><td>" + dsGetStaffID.Tables[0].Rows[i]["Empcode"].ToString() + "</td><td>" + dsGetStaffID.Tables[0].Rows[i]["StaffName"].ToString() + "</td><td>" + tblacademic + "</td></tr>";
                    }
                }

                else
                {
                   // strmaintable = strmaintable + "<tr><td colspan='2'> - No Data-</td></tr>";
                }


            }

            strmaintable = strmaintable + "</table>";

            dvCard.InnerHtml = strmaintable;
        }

        else
        {
            strmaintable = @"<table border='1' cellspacing='2' cellpadding='2' ><thead><tr><th>SNo</th><th>Emp code</th><th>Name</th><th>Certificate Missing Degree List</th></tr></thead><tbody><tr><td colspan='4'>-No Data-</td></tr>";           

            dvCard.InnerHtml = strmaintable;
        }

    }

}