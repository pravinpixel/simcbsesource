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


public partial class Promotions_PromotionSearch : System.Web.UI.Page
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
                if (Request.Params["Status"] != null)
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>AlertMessage('success', " + Request.Params["Status"].ToString() + ");</script>", false);
                }
                BindClass();
                BindDummyRow();

            }
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
            dummy.Columns.Add("Class");
            dummy.Columns.Add("Section");
            dummy.Columns.Add("PromotionID");
            dummy.Rows.Add();
            dgPromotionInfo.DataSource = dummy;
            dgPromotionInfo.DataBind();
        }
    }
    public static DataSet GetData(SqlCommand cmd, int pageIndex,string ClassID,string SectionID,string AcademicID)
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
                    sda.Fill(ds, "PromotionInfo");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Columns.Add("ClassID");
                    dt.Columns.Add("SectionID");
                    dt.Columns.Add("AcademicId");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = ds.Tables[1].Rows[0][0];
                    dt.Rows[0]["ClassID"] = ClassID;
                    dt.Rows[0]["SectionID"] = SectionID;
                    dt.Rows[0]["AcademicId"] = AcademicID;
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }

    [WebMethod]
    public static string GetPromotionInfo(int pageIndex, string Class, string Section)
    {
        Utilities utl = new Utilities();
        string query = "[GetPromotionInfo_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@ClassID", Class);
        cmd.Parameters.AddWithValue("@SectionID", Section);
        cmd.Parameters.AddWithValue("@AcademicId", HttpContext.Current.Session["AcademicID"].ToString());
        return GetData(cmd, pageIndex, Class, Section, HttpContext.Current.Session["AcademicID"].ToString()).GetXml();

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
    public static string ViewPromotionInfo(string PromotionID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "";
        string[] tmp = new string[2];
        tmp = PromotionID.ToString().Split('-');
        query = "sp_GetPromotionInfo '" + tmp[0].ToString() + "','" + tmp[1].ToString() + "','" + HttpContext.Current.Session["AcademicID"] + "'";

        return utl.GetDatasetTable(query, "ViewPromotionInfo").GetXml();
    }

    [WebMethod]
    public static string DeletePromotionInfo(string PromotionID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string[] tmp = new string[2];
        tmp = PromotionID.ToString().Split('-');
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        strQueryStatus = utl.ExecuteQuery("sp_DeletePromotionInfo '" + tmp[0].ToString() + "','" + tmp[1].ToString() + "','" + HttpContext.Current.Session["AcademicID"] + "','" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
}