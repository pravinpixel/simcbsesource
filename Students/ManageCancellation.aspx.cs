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


public partial class Students_ManageCancellation : System.Web.UI.Page
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

                BindDummyRow();
                txtCancellationDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            }
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
            dummy.Columns.Add("StudentID");
            dummy.Columns.Add("View");
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
    public static string GetCancellationStudentInfo(int pageIndex, string regno, string searchtag)
    {
        Utilities utl = new Utilities();
        string query = "[GetCancellationStudentInfo_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@regno", regno);
        cmd.Parameters.AddWithValue("@Type", searchtag);
        cmd.Parameters.AddWithValue("@AcademicID", HttpContext.Current.Session["AcademicID"]);
        return GetData(cmd, pageIndex).GetXml();

    }
    [WebMethod]
    public static string GetModuleId(string path)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModuleIdByPath '" + path + "'";
        return utl.ExecuteScalarValue(query);
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
        string query = "sp_GetStudentBySection '" + Class + "','" + Section + "'";
        return utl.GetDatasetTable(query, "StudentBySection").GetXml();

    }

    [WebMethod]
    public static string EditStudentInfo(int StudentInfoID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStudentInfo " + "" + StudentInfoID + "";
        return utl.GetDatasetTable(query, "EditStudentInfo").GetXml();
    }

    [WebMethod]
    public static string UpdateCancellation(string regno, string type, string canceldate, string reason)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (type == "Bus")
        {
            sqlstr = "update s_studentinfo set busfacility='N' where regno='" + regno + "' and AcademicYear='"+ HttpContext.Current.Session["AcademicID"].ToString() +"'";
            utl.ExecuteQuery(sqlstr);

            sqlstr = "update s_studentbus set isactive='0' where regno='" + regno + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
            utl.ExecuteQuery(sqlstr);


            sqlstr = "update s_studentpromotion set busfacility='N' where regno='" + regno + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
            utl.ExecuteQuery(sqlstr);

            
        }
        else if (type == "Hostel")
        {
            sqlstr = "update s_studentinfo set hostel='N' where regno='" + regno + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
            utl.ExecuteQuery(sqlstr);

            sqlstr = "update s_studenthostel set isactive='0' where regno='" + regno + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
            utl.ExecuteQuery(sqlstr);

            sqlstr = "update s_studentpromotion set hostel='N' where regno='" + regno + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
            utl.ExecuteQuery(sqlstr);
        }
        if (canceldate != "")
        {
            string[] myDateTimeString = canceldate.Split('/');
            canceldate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        strQueryStatus = utl.ExecuteQuery("sp_UpdateCancellation " + regno + ",'" + type + "','" + reason + "'," + canceldate + ",'" + Userid + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
}