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

using System.Globalization;

public partial class Reports_ConsolidatedStrengthReport : System.Web.UI.Page
{
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
            lblDate.Text = System.DateTime.Now.ToString("dd-MM-yyyy");
        }
        if (Session["AcademicId"] != null)
        {
            GetStudentInfo(Session["AcademicId"].ToString());
        }
        GetStaffInfo();

    }
    private void GetStaffInfo()
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        ds = utl.GetDataset("SP_GETSTAFFINFOCOUNTS");

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
          lblStaffCount.Text  = ds.Tables[0].Rows[0]["TOTALSTAFFS"].ToString();

        if (ds != null && ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
            lblFemaleStaff.Text = ds.Tables[1].Rows[0]["TOTALFEMALE"].ToString();

        if (ds != null && ds.Tables.Count > 2 && ds.Tables[2].Rows.Count > 0)
            lblMaleStaff.Text = ds.Tables[2].Rows[0]["TOTALMALE"].ToString();

        if (ds != null && ds.Tables.Count > 3 && ds.Tables[3].Rows.Count > 0)
            lblTodayStaffs.Text = ds.Tables[3].Rows[0]["TODAYATT"].ToString();
    }
    private void GetStudentInfo(string acdId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        ds = utl.GetDataset("SP_GETSTUDENTINFOCOUNTS " + acdId + "");
        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
           lblStudentCount.Text = ds.Tables[0].Rows[0]["TOTALSTUDENTS"].ToString();

        if (ds != null && ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
            lblGirlsCount.Text = ds.Tables[1].Rows[0]["TOTALFEMALE"].ToString();

        if (ds != null && ds.Tables.Count > 2 && ds.Tables[2].Rows.Count > 0)
            lblBoysCount.Text = ds.Tables[2].Rows[0]["TOTALMALE"].ToString();

        if (ds != null && ds.Tables.Count > 3 && ds.Tables[3].Rows.Count > 0)
            lblTodayStudents.Text = ds.Tables[3].Rows[0]["TODAYATT"].ToString();

        if (ds != null && ds.Tables.Count > 4 && ds.Tables[3].Rows.Count > 0)
            lblHandicap.Text = ds.Tables[4].Rows[0]["HANDICAP"].ToString();

    }
    protected void Page_UnLoad(object sender, EventArgs e)
    {
    }
}
    