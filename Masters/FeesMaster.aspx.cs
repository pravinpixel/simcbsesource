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

public partial class FeesMaster : System.Web.UI.Page
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
                string academicid = "";
                utl = new Utilities();
                academicid = utl.ExecuteScalar("select top 1 academicid from m_academicyear where academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
                if (academicid != "")
                {
                    hfAcademicYear.Value = academicid.ToString();
                }
                BindSchoolCategory();
               // BindClassBySchoolTypeIds();
                BindFeesCategory();
                // BindFeesHead();
                BindDummyRow();

            }
        }
    }

    //private void BindFeesHead()
    //{
    //    utl = new Utilities();
    //    sqlstr = "sp_GetFeesHead";
    //    DataTable dt = new DataTable();
    //    dt = utl.GetDataTable(sqlstr);
    //    if (dt != null && dt.Rows.Count > 0)
    //    {
    //        chkFeesHead.DataSource = dt;
    //        chkFeesHead.DataTextField = "FeesHeadName";
    //        chkFeesHead.DataValueField = "FeesHeadID";
    //        chkFeesHead.DataBind();
    //    }
    //    else
    //    {
    //        chkFeesHead.DataSource = null;
    //        chkFeesHead.DataBind();

    //    }
    //}

    private void BindFeesCategory()
    {
        utl = new Utilities();
        sqlstr = "sp_GetFeesCategory";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);
        if (dt != null && dt.Rows.Count > 0)
        {
            rbtnFeesCategory.DataSource = dt;
            rbtnFeesCategory.DataTextField = "FeesCategoryName";
            rbtnFeesCategory.DataValueField = "FeesCategoryID";
            rbtnFeesCategory.DataBind();
        }
        else
        {
            rbtnFeesCategory.DataSource = null;
            rbtnFeesCategory.DataBind();

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
            dummy.Columns.Add("FeesCategoryName");
            dummy.Columns.Add("FeesHeadName");
            dummy.Columns.Add("AcademicYear");
            dummy.Columns.Add("ForMonth");
            dummy.Columns.Add("Amount");
            dummy.Columns.Add("FeesCatHeadID");
            dummy.Rows.Add();
            dgFeesCategoryHead.DataSource = dummy;
            dgFeesCategoryHead.DataBind();
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
                    sda.Fill(ds, "FeeCatHeads");
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
        string query = "sp_GetClassBySchoolType " + SchoolTypeID + "";
        return utl.GetDatasetTable(query, "ClassBySchoolType").GetXml();
    }
    [WebMethod]
    public static string GetFeesTypeByClass(int ClassID)
    {
        Utilities utl = new Utilities();
        string query = "sp_GetFeesTypeByClass " + ClassID + "";
        return utl.GetDatasetTable(query, "FeesTypeByClass").GetXml();
    }
    [WebMethod]
    public static string GetFeesCatHead(int pageIndex, int AcademicId)
    {
        Utilities utl = new Utilities();
        string query = "[GetFeesCategoryHead_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.AddWithValue("@AcademicId", AcademicId);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditFeesCatHead(int FeesCatHeadID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetFeesCatHead " + FeesCatHeadID + "";
        return utl.GetDatasetTable(query, "EditFeesCatHead").GetXml();
    }


    [WebMethod]
    public static string DeleteFeesCatHead(string FeesCatHeadID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteFeesCatHead " + FeesCatHeadID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

}