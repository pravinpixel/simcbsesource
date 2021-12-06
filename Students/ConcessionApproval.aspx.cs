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

public partial class Students_ConcessionApproval : System.Web.UI.Page
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
                BindClass();
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
            dummy.Columns.Add("RowNumber");
            dummy.Columns.Add("RegNo");
            dummy.Columns.Add("AdmissionNo");
            dummy.Columns.Add("StudentName");
            dummy.Columns.Add("Class");
            dummy.Columns.Add("Section");
            dummy.Columns.Add("PresentStatus");
            dummy.Columns.Add("ApprovalStatus");
            dummy.Columns.Add("View");
            dummy.Rows.Add();
            grdConcessionApproval.DataSource = dummy;
            grdConcessionApproval.DataBind();
        }
    }

    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("exec sp_GetConcessionApprovalClass");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass.DataSource = dsClass;
            ddlClass.DataTextField = "class";
            ddlClass.DataValueField = "classid";
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

    [WebMethod]
    public static string GetStudent(string StudentName, string RegNo)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStudentInfo " + "''" + ",'" + RegNo + "','" + StudentName + "'";
        return utl.GetDatasetTable(query, "Student").GetXml();
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
    public static string GetConcessionApprovalStudList(int pageIndex, string regNo, string Class, string studentName)
    {
        Utilities utl = new Utilities();
        string query = "[sp_GetConcessionApprovalStudList]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@regno", regNo);
        cmd.Parameters.AddWithValue("@classname", Class);
        cmd.Parameters.AddWithValue("@studentname", studentName);

        return utl.GetData(cmd, pageIndex, "ConcessionApprovalStudList", PageSize).GetXml();

    }   


    [WebMethod]
    public static string UpdateConcessionApproval(string regno, string status, int userId)
    {
        Utilities utl = new Utilities();

        string returnVal = utl.ExecuteQuery("sp_UpdateStudConcessionApproval " + regno + "," + status + "," + userId);
        if (returnVal == "")
            return "Updated";
        else
            return "Update Failed";
    }

}