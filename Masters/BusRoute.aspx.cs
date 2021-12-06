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

public partial class BusRoute : System.Web.UI.Page
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
                BindVehicleCode();
            }
        }

    }
    private void BindVehicleCode()
    {
        utl = new Utilities();
        sqlstr = "sp_GetVehicle";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlVehicleCode.DataSource = dt;
            ddlVehicleCode.DataTextField = "VehicleCode";
            ddlVehicleCode.DataValueField = "VehicleID";
            ddlVehicleCode.DataBind();
        }
        else
        {
            ddlVehicleCode.DataSource = null;
            ddlVehicleCode.DataBind();
            ddlVehicleCode.SelectedIndex = 0;
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("BusRouteName");
            dummy.Columns.Add("BusRouteCode");
            dummy.Columns.Add("VehicleName");
            dummy.Columns.Add("Timings");
            dummy.Columns.Add("BusCharge");
            dummy.Columns.Add("BusRouteID");
            dummy.Rows.Add();
            dgBusRoute.DataSource = dummy;
            dgBusRoute.DataBind();
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
                    sda.Fill(ds, "BusRoutes");
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
    public static string GetBusRoute(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetBusRoute_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditBusRoute(int BusRouteID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetBusRoute " + BusRouteID + "," + "''" + "";
        return utl.GetDatasetTable(query, "EditBusRoute").GetXml();
    }
    [WebMethod]
    public static string GetRegisterNo(int VehicleID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetVehicle " + VehicleID + "";
        return utl.GetDatasetTable(query, "RegisterNo").GetXml();
    }

    [WebMethod]
    public static string SaveBusRoute(string id, string busroutename, string busroutecode, string vehicleid, string timings, string buscharge)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {

            sqlstr = "select isnull(count(*),0) from m_busroute where Routename='" + busroutename.Replace("'", "''") + "' and VehicleID='" + vehicleid + "' and RouteCode='" + busroutecode + "' and BusRouteId!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateBusRoute " + "'" + id + "','" + busroutename.Replace("'", "''") + "','" + busroutecode.Replace("'", "''") + "','" + vehicleid + "','" + timings + "','" + buscharge + "','" + Userid + "'";
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
            sqlstr = "select isnull(count(*),0) from m_busroute where Routename='" + busroutename.Replace("'", "''") + "' and VehicleID='" + vehicleid + "' and RouteCode='" + busroutecode + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertBusRoute " + "'" + busroutename.Replace("'", "''") + "','" + busroutecode.Replace("'", "''") + "','" + vehicleid + "','" + timings + "','" + buscharge + "','" + Userid + "'";
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
    public static string DeleteBusRoute(string BusRouteID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteBusRoute " + "" + BusRouteID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
}