using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Data.SqlClient;


public partial class Staffs_LeaveApproval : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
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
            hdnUserId.Value = Session["UserId"].ToString();
            if (!IsPostBack)
            {
                BindDummyRow();
                BindDesignation();
                BindAcademicYear();

            }
        }
    }

    private void BindAcademicYear()
    {
        utl = new Utilities();
        DataTable dtAcademicYear = utl.GetDataTable("exec sp_getAdmissionBelongYear");
        if (dtAcademicYear != null && dtAcademicYear.Rows.Count > 0)
        {
            ListItem currentYear = new ListItem(dtAcademicYear.Rows[0]["currentacd"].ToString(), dtAcademicYear.Rows[0]["academicid"].ToString());
            currentYear.Selected = true;
            ListItem nextYear = new ListItem(dtAcademicYear.Rows[0]["nextacd"].ToString(), "new");
            radlAcademicYear.Items.Add(currentYear);
            radlAcademicYear.Items.Add(nextYear);
        }
    }

    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("EmpCode");
            dummy.Columns.Add("Name");
            dummy.Columns.Add("RoleNo");
            dummy.Columns.Add("Designation");
            dummy.Columns.Add("RequestedDate");
            dummy.Columns.Add("NoOfDays");
            dummy.Columns.Add("From");
            dummy.Columns.Add("To");
            dummy.Columns.Add("Attachment");
            dummy.Columns.Add("LeaveType");
            dummy.Columns.Add("StatusName");
            dummy.Columns.Add("StaffLeaveId");
            dummy.Rows.Add();
            grdLeaveApproval.DataSource = dummy;
            grdLeaveApproval.DataBind();
        }
    }

    protected void BindDesignation()
    {
        Utilities utl = new Utilities();
        string sqlstr = "sp_Getdesignation";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDesignation.DataSource = dt;
            ddlDesignation.DataTextField = "DesignationName";
            ddlDesignation.DataValueField = "DesignationId";
            ddlDesignation.DataBind();
        }
        else
        {
            ddlDesignation.DataSource = null;
            ddlDesignation.DataBind();
        }
        ddlDesignation.Items.Insert(0, new ListItem("--Select---", ""));
    }
    [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }
    [WebMethod]
    public static string GetLeaveApprovalList(int pageIndex, string empCode, string designation, string staffName)
    {
        Utilities utl = new Utilities();
        string query = "[SP_GETLEAVEAPPROVAL]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@StaffId", empCode);
        cmd.Parameters.AddWithValue("@Designation", designation);
        cmd.Parameters.AddWithValue("@StaffName", staffName);
        cmd.Parameters.AddWithValue("@AcademicID", HttpContext.Current.Session["AcademicID"]);
        return utl.GetData(cmd, pageIndex, "LeaveApproval", PageSize).GetXml();
    }   


    [WebMethod]
    public static string UpdateLeaveApproval(string StaffLeaveId, string status, string userId)
    {
        Utilities utl = new Utilities();

        string returnVal = utl.ExecuteQuery("update e_Staffleave set statusID='" + status + "',userid='" + userId + "' where StaffLeaveId= " + StaffLeaveId + " and AcademicYear='" + HttpContext.Current.Session["AcademicID"] + "'");
        if (returnVal == "")
            return "Updated";
        else
            return "Update Failed";
    }

    [WebMethod]
    public static string GetDpStatus()
    {
        Utilities utl = new Utilities();
        string query = "select statusid,statusname from m_approvestatus where isactive='true'";
        DataSet ds = new DataSet();
        ds = utl.GetDataset(query);
        StringBuilder sb=new StringBuilder();
         sb.Append("<select>");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            sb.Append("<option value=\"" + dr["statusid"].ToString() + "\">" + dr["statusname"].ToString() + "</option>");
        }
        sb.Append("</select>");
        return sb.ToString();
    }
}