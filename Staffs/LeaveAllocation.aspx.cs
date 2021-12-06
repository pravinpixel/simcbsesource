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
using System.Globalization;
using System.Drawing.Printing;
using System.Drawing;
using System.Text;

public partial class Staffs_LeaveAllocation : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    public static int AcademicID = 0;
    public static string UserName = string.Empty;
    private static int PageSize = 10;
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
            hfAcademicID.Value = AcademicID.ToString();
            hfUserId.Value = Userid.ToString();
            if (!IsPostBack)
            {
                BindLeave();
                BindPlaceofwork();
                BindDummyRow();
            }

        }

    }

    private void BindLeave()
    {
        Utilities utl = new Utilities();
        string query;
        query = "select  LeaveID,LeaveName from  m_Leave where IsActive=1 and LeaveName='Earned' ";

        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);


        if (dt != null && dt.Rows.Count > 0)
        {
            ddlLeave.DataSource = dt;
            ddlLeave.DataTextField = "LeaveName";
            ddlLeave.DataValueField = "LeaveID";
            ddlLeave.DataBind();
        }
        else
        {
            ddlLeave.DataSource = null;
            ddlLeave.DataBind();
            ddlLeave.SelectedIndex = -1;
        }
    }

    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffID");
            dummy.Columns.Add("EmpCode");
            dummy.Columns.Add("StaffName");
            dummy.Columns.Add("Accumulated");
            dummy.Columns.Add("AvailableLeave");
            dummy.Rows.Add();
            dgStaffList.DataSource = dummy;
            dgStaffList.DataBind();
        }
    }

    private void BindPlaceofwork()
    {
        Utilities utl = new Utilities();
        string query;
        query = "select  Placeofwork,PlaceofworkID from  m_placeofwork  where IsActive=1 ";

        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);


        if (dt != null && dt.Rows.Count > 0)
        {
            ddlPlaceofwork.DataSource = dt;
            ddlPlaceofwork.DataTextField = "Placeofwork";
            ddlPlaceofwork.DataValueField = "PlaceofworkID";
            ddlPlaceofwork.DataBind();
        }
        else
        {
            ddlPlaceofwork.DataSource = null;
            ddlPlaceofwork.DataBind();
            ddlPlaceofwork.SelectedIndex = -1;
        }
    }

    [WebMethod]

    public static string GetStaffList(string PlaceofworkID, string LeaveID)
    {
        Utilities utl = new Utilities();

        string query = "[sp_GetStaffListForAllocation] '" + PlaceofworkID + "','" + LeaveID + "'," + HttpContext.Current.Session["AcademicID"] + "";
        return utl.GetDatasetTable(query, "StaffList").GetXml();


    }
    public class LeaveList
    {
        public string LeaveID { get; set; }
        public string StaffID { get; set; }
        public string Accumulated { get; set; }
        public string AvailableLeave { get; set; }
        public string AcademicID { get; set; }
        public string userId { get; set; }
    }
    [WebMethod]

    public static string UpdateAllocation(List<LeaveList> leavelist)
    {
        if (leavelist != null && leavelist.Count > 0)
        {
            Utilities utl = new Utilities();
            string query = string.Empty;

            foreach (LeaveList leave in leavelist)
            {
                int i = 0;

                string qry = utl.ExecuteScalar("select  count(*) from e_staffleaveallocation where staffid='" + leave.StaffID + "' and AcademicID='" + leave.AcademicID + "' and LeaveID='" + leave.LeaveID + "'");

                if (qry == "" || qry == "0")
                {

                    query += "insert into e_staffleaveallocation(StaffID,LeaveID,Accumulated,AvailableLeave,AcademicID,UserID,Isactive)values('" + leave.StaffID + "','" + leave.LeaveID + "','" + leave.Accumulated + "','" + leave.AvailableLeave + "','" + leave.AcademicID + "','" + leave.userId + "',1)";
                }
                else
                {
                    query += "update e_staffleaveallocation set Accumulated ='" + leave.Accumulated + "',AvailableLeave='" + leave.AvailableLeave + "' where staffid='" + leave.StaffID + "' and AcademicID='" + leave.AcademicID + "' and LeaveID='" + leave.LeaveID + "'";
                }
                i++;

            }
            string err = utl.ExecuteQuery(query);

        }
        return "";
    }
}