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

public partial class Section : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = string.Empty;
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
                BindSchoolCategory();
                //BindClassBySchoolTypeIds();
                BindDummyRow();

            }
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("SchoolTypeName");
            dummy.Columns.Add("ClassName");
            dummy.Columns.Add("SectionName");
            dummy.Columns.Add("SectionID");
            dummy.Rows.Add();
            dgSection.DataSource = dummy;
            dgSection.DataBind();
        }
    }
    private void BindSchoolCategory()
    {
        utl = new Utilities();
        sqlstr = "sp_GetSchoolCategory";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSchoolType.DataSource = dt;
            ddlSchoolType.DataTextField = "SchoolTypeName";
            ddlSchoolType.DataValueField = "SchoolTypeID";
            ddlSchoolType.DataBind();
        }
        else
        {
            ddlSchoolType.DataSource = null;
            ddlSchoolType.DataBind();
            ddlSchoolType.Items.Clear();

        }

        ddlSchoolType.SelectedIndex = 0;

    }
    //private void BindClassBySchoolTypeIds()
    //{
    //    utl = new Utilities();
    //    sqlstr = "sp_GetClassBySchoolType";
    //    DataTable dt = new DataTable();
    //    dt = utl.GetDataTable(sqlstr);
    //    if (dt != null && dt.Rows.Count > 0)
    //    {
    //        ddlClass.DataSource = dt;
    //        ddlClass.DataTextField = "ClassName";
    //        ddlClass.DataValueField = "ClassID";
    //        ddlClass.DataBind();
    //    }
    //    else
    //    {
    //        ddlClass.DataSource = null;
    //        ddlClass.DataBind();
    //        ddlClass.Items.Clear();

    //    }
    //    ddlClass.SelectedIndex = 0;

    //}
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
                    sda.Fill(ds, "Sections");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }
    [WebMethod]
    public static string GetClassBySchoolTypeID(int SchoolTypeID)
    {
        Utilities utl = new Utilities();
        string query = "sp_GetClassBySchoolType " + "" + SchoolTypeID + "";
        return utl.GetDatasetTable(query, "ClassBySchoolType").GetXml();
    }

    [WebMethod]
    public static string GetSection(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetSection_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditSection(int SectionID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSection " + "" + SectionID + "";
        return utl.GetDatasetTable(query, "EditSection").GetXml();
    }

    [WebMethod]
    public static string SaveSection(string id, string sectionname, string classid)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_Section where Sectionname='" + sectionname.Replace("'", "''") + "' and classid='" + classid + "' and Sectionid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateSection " + "'" + id + "','" + sectionname + "','" + classid + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Exists, Update";
            }
        }
        else
        {
            sqlstr = "select isnull(count(*),0) from m_Section where Sectionname='" + sectionname.Replace("'", "''") + "'  and classid='" + classid + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertSection " + "'" + sectionname + "','" + classid + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }
    [WebMethod]
    public static string DeleteSection(string SectionID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteSection " + "" + SectionID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }

}