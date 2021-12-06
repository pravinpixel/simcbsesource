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

public partial class Rooms : System.Web.UI.Page
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
            Response.Redirect("~/Default.aspx?ses=expired");
        }
        else
        {
            Userid = Convert.ToInt32(Session["UserId"]);
            if (!IsPostBack)
            {
                BindHostel();
              //  BindBlockByHostelIds();
                BindDummyRow();
            }
        }
    }
    //private void BindBlockByHostelIds()
    //{
    //    utl = new Utilities();
    //    sqlstr = "sp_GetBlockByHostel " + "'" + ddlHostel.SelectedValue + "'";
    //    DataTable dt = new DataTable();
    //    dt = utl.GetDataTable(sqlstr);
    //    ddlBlock.Items.Clear();
    //    if (dt != null && dt.Rows.Count > 0)
    //    {
    //        ddlBlock.DataSource = dt;
    //        ddlBlock.DataTextField = "BlockName";
    //        ddlBlock.DataValueField = "BlockID";
    //        ddlBlock.DataBind();
    //    }
    //    else
    //    {
    //        ddlBlock.DataSource = dt;
    //        ddlBlock.DataBind();
    //        ddlBlock.Items.Clear();
    //    }

    //    ddlBlock.SelectedIndex = 0;


    //}
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
            ddlHostel.SelectedIndex = 0;
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
            dummy.Columns.Add("RoomName");
            dummy.Columns.Add("RoomID");
            dummy.Rows.Add();
            dgRooms.DataSource = dummy;
            dgRooms.DataBind();
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
            ddlHostel.DataSource = dt;
            ddlHostel.DataTextField = "HostelName";
            ddlHostel.DataValueField = "HostelID";
            ddlHostel.DataBind();
        }
        else
        {
            ddlHostel.DataSource = null;
            ddlHostel.DataBind();
            ddlHostel.Items.Clear();

        }

        ddlHostel.SelectedIndex = 0;

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
                    sda.Fill(ds, "Rooms");
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
    public static string GetBlockByHostelID(int HostelID)
    {
        Utilities utl = new Utilities();
        string query = "sp_GetBlockByHostel " + "" + HostelID + "";
        return utl.GetDatasetTable(query, "BlockByHostel").GetXml();
    }

    [WebMethod]
    public static string GetRooms(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetRooms_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditRooms(int RoomsID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetRoom " + "" + RoomsID + "";
        return utl.GetDatasetTable(query, "EditRooms").GetXml();
    }

    [WebMethod]
    public static string SaveRooms(string id, string roomname, string blockid)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_Rooms where Roomname='" + roomname.Replace("'", "''") + "' and blockid='" + blockid + "'  and roomid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateRoom " + "'" + id + "','" + roomname + "','" + blockid + "','" + Userid + "'";
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
            sqlstr = "select isnull(count(*),0) from m_Rooms where Roomname='" + roomname.Replace("'", "''") + "' and blockid='" + blockid + "'  and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertRoom " + "'" + roomname + "','" + blockid + "','" + Userid + "'";
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
    public static string DeleteRooms(string RoomsID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteRoom " + "" + RoomsID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }



}