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


public partial class Students_StudentCertificateSearch : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
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

            if (!IsPostBack)
            {
                BindAcademicYear();
                BindClass();
                BindDummyRow();

            }
            if (Request.QueryString["AcademicYear"] != null && Session["AcademicID"] != null)
            {
                ddlAcademicYear.SelectedValue = Session["AcademicID"].ToString();
            }

        }
    }
    [WebMethod]
    public static string GetStudent(string StudentName, string RegNo)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "";
        string isActive = Convert.ToString(utl.ExecuteScalar("select isnull(isactive,0) isactive from m_academicyear where academicid='" + HttpContext.Current.Session["AcademicID"] + "'"));
        if (isActive == "True" || isActive == "1")
        {
            query = "sp_GetStudentInfo " + "''" + ",'" + RegNo + "','" + StudentName + "'";
        }
        else if (isActive == "False" || isActive == "0")
        {
            query = "sp_GetPromoStudentInfo " + HttpContext.Current.Session["AcademicID"] + ",'', '" + RegNo + "','" + StudentName + "'";
        }

        return utl.GetDatasetTable(query, "Student").GetXml();
    }
    private void BindAcademicYear()
    {
        utl = new Utilities();
        sqlstr = "sp_getAcademinYear";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlAcademicYear.DataSource = dt;
            ddlAcademicYear.DataTextField = "AcademicYear";
            ddlAcademicYear.DataValueField = "AcademicID";
            ddlAcademicYear.DataBind();
        }
        else
        {
            ddlAcademicYear.DataSource = null;
            ddlAcademicYear.DataBind();
            ddlAcademicYear.SelectedIndex = 0;
        }


    }
    private void BindClass()
    {
        utl = new Utilities();
        sqlstr = "sp_GetClass ";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlClass.DataSource = dt;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataBind();
            ddlClass.SelectedIndex = 0;
        }


    }


    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("SlNo");
            dummy.Columns.Add("RegNo");
            dummy.Columns.Add("StudentName");
            dummy.Columns.Add("Class");
            dummy.Columns.Add("Section");
            dummy.Columns.Add("Status");
            dummy.Columns.Add("StudentID");
            dummy.Rows.Add();
            dgStudentInfo.DataSource = dummy;
            dgStudentInfo.DataBind();
        }
    }
    public static DataSet GetData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "StudentInfo");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = ds.Tables[1].Rows[0][0];
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }

    [WebMethod]
    public static string GetStudentInfo(int pageIndex, string studentid, string regno, string studentname, string adminno, string classname, string section, string gender, string phoneno, string hostel, string hostelname, string busfacility, string routecode, string routename, string sStatus, string Academic)
    {
        Utilities utl = new Utilities();

        string isActive = Convert.ToString(utl.ExecuteScalar("select isnull(isactive,0) isactive from m_academicyear where academicid='" + HttpContext.Current.Session["AcademicID"] + "'"));
        string query = "";
        if (isActive == "True" || isActive == "1")
        {
            query = "[GetStudentInfo_Pager]";
        }
        else if (isActive == "False" || isActive == "0")
        {
            query = "[GetPromoStudentInfo_Pager]";
        }
       
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@studentid", studentid);
        cmd.Parameters.AddWithValue("@regno", regno);
        cmd.Parameters.AddWithValue("@studentname", studentname);
        cmd.Parameters.AddWithValue("@adminno", adminno);
        cmd.Parameters.AddWithValue("@classname", classname);
        cmd.Parameters.AddWithValue("@section", section);
        cmd.Parameters.AddWithValue("@gender", gender);
        cmd.Parameters.AddWithValue("@phoneno", phoneno);
        cmd.Parameters.AddWithValue("@hostel", hostel);
        cmd.Parameters.AddWithValue("@hostelname", hostelname);
        cmd.Parameters.AddWithValue("@busfacility", busfacility);
        cmd.Parameters.AddWithValue("@routecode", routecode);
        cmd.Parameters.AddWithValue("@routename", routename);
        cmd.Parameters.AddWithValue("@sStatus", sStatus);
        if (Academic == "")
        {
            Academic = HttpContext.Current.Session["AcademicID"].ToString();
        }
        cmd.Parameters.AddWithValue("@Academic", Academic);
        return GetData(cmd, pageIndex).GetXml();

    }
    [WebMethod]
    public static string GetModuleId(string path)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModuleMenuIdByPath '" + path + "'," + Userid + "";
        ds = utl.GetDatasetTable(query, "ModuleMenusByPath");
        return ds.GetXml();
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
    public static string GetStudentBySection(string Class, string Section)
    {

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string isActive = Convert.ToString(utl.ExecuteScalar("select isnull(isactive,0) isactive from m_academicyear where academicid='" + HttpContext.Current.Session["AcademicID"] + "'"));
        string query = "";
        if (isActive == "True" || isActive == "1")
        {
           query = "sp_GetStudentBySection '" + Class + "','" + Section + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }
        else if (isActive == "False" || isActive == "0")
        {
            query = "sp_GetPromoStudentBySection '" + Class + "','" + Section + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }

        return utl.GetDatasetTable(query, "StudentBySection").GetXml();

    }

    [WebMethod]
    public static string EditStudentInfo(int StudentInfoID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "";

        string isActive = Convert.ToString(utl.ExecuteScalar("select isnull(isactive,0) isactive from m_academicyear where academicid='" + HttpContext.Current.Session["AcademicID"] + "'"));
        if (isActive == "True" || isActive == "1")
        {
            query = "sp_GetStudentInfo " + StudentInfoID + "'";
        }
        else if (isActive == "False" || isActive == "0")
        {
            query = "sp_GetPromoStudentInfo " + HttpContext.Current.Session["AcademicID"] + ",'" + StudentInfoID + "'";
        }
        return utl.GetDatasetTable(query, "EditStudentInfo").GetXml();
    }

    [WebMethod]
    public static string DeleteStudentInfo(string StudentInfoID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteStudentInfo " + "" + StudentInfoID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
}