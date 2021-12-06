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

public partial class Block : System.Web.UI.Page
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
                BindHostel();
            }
        }
    }
    private void BindHostel()
    {
        utl = new Utilities();
        sqlstr = "sp_GetHostel";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlHostel.DataSource = dt;
            ddlHostel.DataTextField = "HostelName";
            ddlHostel.DataValueField = "HostelID";
            ddlHostel.DataBind();
        }
        else
        {
            ddlHostel.DataSource = null;
            ddlHostel.DataBind();
        }

    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("HostelName");
            dummy.Columns.Add("BlockName");
            dummy.Columns.Add("BlockID");
            dummy.Rows.Add();
            dgBlock.DataSource = dummy;
            dgBlock.DataBind();
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
                    sda.Fill(ds, "Blocks");
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
    public static string GetBlock(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetBlock_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditBlock(int BlockID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetBlock " + "" + BlockID + "";
        return utl.GetDatasetTable(query, "EditBlock").GetXml();
    }

    [WebMethod]
    public static string SaveBlock(string id, string blockname, string hostelid)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_blocks where blockname='" + blockname.Replace("'", "''") + "' and hostelid='" + hostelid + "'  and blockid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateBlock " + "'" + id + "','" + blockname.Replace("'", "''") + "','" + hostelid + "','" + Userid + "'";
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
            sqlstr = "select isnull(count(*),0) from m_blocks where blockname='" + blockname.Replace("'", "''") + "' and hostelid='" + hostelid + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertBlock " + "'" + blockname.Replace("'", "''") + "','" + hostelid + "','" + Userid + "'";
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
    public static string DeleteBlock(string BlockID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteBlock " + "" + BlockID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }

}