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

public partial class Vehicle : System.Web.UI.Page
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
                BindDummyVehicleRow();
                BindDummyServiceRow();
                BindVehicleCode();
            }


            if (Session["Reminder"] != null && Session["Reminder"].ToString() !="")
            {
                ClientScript.RegisterClientScriptBlock(this.GetType(), "sss", "<Script>changeAccordion();</script>");
                Session["Reminder"] = "";
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
    private void BindDummyVehicleRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("VehicleCode");
            dummy.Columns.Add("RegistrationNo");
            dummy.Columns.Add("ClassOfVehicle");
            dummy.Columns.Add("EngineNo");
            dummy.Columns.Add("ChasisNo");
            dummy.Columns.Add("ModelNo");
            dummy.Columns.Add("YearofPurchase");
            dummy.Columns.Add("SchoolCode");
            dummy.Columns.Add("VehicleID");
            dummy.Rows.Add();
            dgVehicle.DataSource = dummy;
            dgVehicle.DataBind();
        }
    }
    private void BindDummyServiceRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("VehicleCode");
            dummy.Columns.Add("ServiceType");
            dummy.Columns.Add("FromDate");
            dummy.Columns.Add("ToDate");
            dummy.Columns.Add("ServiceID");
            dummy.Rows.Add();
            dgService.DataSource = dummy;
            dgService.DataBind();
        }
    }

    public static DataSet GetServiceData(SqlCommand cmd, int pageIndex)
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
                    sda.Fill(ds, "Services");
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
    public static string GetService(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetService_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetServiceData(cmd, pageIndex).GetXml();
    }


    [WebMethod]
    public static string GetVehicleCode()
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetVehicle ";
        return utl.GetDatasetTable(query, "Vehicle").GetXml();
    }

    [WebMethod]
    public static string EditService(int ServiceID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetService " + "" + ServiceID + "";
        return utl.GetDatasetTable(query, "EditService").GetXml();
    }

    [WebMethod]
    public static string SaveService(string id, string vehicleid, string type, string fromdate, string todate)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        if (fromdate != "")
        {
            string[] myDateTimeString = fromdate.Split('/');
            fromdate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (todate != "")
        {
            string[] myDateTimeString = todate.Split('/');
            todate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_Services where vehicleid='" + vehicleid + "' and ServiceType='" + type + "'  and fromdate=" + fromdate + "  and todate=" + todate + " and Serviceid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateService " + "'" + id + "'," + vehicleid + ",'" + type + "'," + fromdate + "," + todate + ",'" + Userid + "'";
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
            sqlstr = "select isnull(count(*),0) from m_Services where vehicleid='" + vehicleid + "' and ServiceType='" + type + "'  and fromdate=" + fromdate + "  and todate=" + todate + "  and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertService " + "" + vehicleid + ",'" + type + "'," + fromdate + "," + todate + ",'" + Userid + "'";
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
    public static string DeleteService(string ServiceID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteService " + "" + ServiceID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }


    public static DataSet GetVehicleData(SqlCommand cmd, int pageIndex)
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
                    sda.Fill(ds, "Vehicles");
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
    public static string GetVehicle(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetVehicle_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetVehicleData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditVehicle(int VehicleID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetVehicle " + "" + VehicleID + "";
        return utl.GetDatasetTable(query, "EditVehicle").GetXml();
    }

    [WebMethod]
    public static string SaveVehicle(string id, string vehiclecode, string registrationno, string classofvehicle, string engineno, string chasisno, string modelno, string yearofpurchase, string schoolcode)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_Vehicles where VehicleCode='" + vehiclecode.Replace("'", "''") + "' and  registrationno='" + registrationno.Replace("'", "''") + "'  and  classofvehicle='" + classofvehicle.Replace("'", "''") + "'  and  engineno='" + engineno.Replace("'", "''") + "' and  chasisno='" + chasisno.Replace("'", "''") + "' and  modelno='" + modelno.Replace("'", "''") + "'  and  yearofpurchase='" + yearofpurchase.Replace("'", "''") + "' and  schoolcode='" + schoolcode.Replace("'", "''") + "'   and Vehicleid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {

                sqlstr = "sp_UpdateVehicle " + "'" + id + "','" + vehiclecode + "','" + registrationno + "','" + classofvehicle + "','" + engineno + "','" + chasisno + "','" + modelno + "','" + yearofpurchase + "','" + schoolcode + "','" + Userid + "'";
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
            sqlstr = "select isnull(count(*),0) from m_Vehicles where VehicleCode='" + vehiclecode.Replace("'", "''") + "' and  registrationno='" + registrationno.Replace("'", "''") + "'  and  classofvehicle='" + classofvehicle.Replace("'", "''") + "'  and  engineno='" + engineno.Replace("'", "''") + "' and  chasisno='" + chasisno.Replace("'", "''") + "' and  modelno='" + modelno.Replace("'", "''") + "'  and  yearofpurchase='" + yearofpurchase.Replace("'", "''") + "' and  schoolcode='" + schoolcode.Replace("'", "''") + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertVehicle " + "'" + vehiclecode + "','" + registrationno + "','" + classofvehicle + "','" + engineno + "','" + chasisno + "','" + modelno + "','" + yearofpurchase + "','" + schoolcode + "','" + Userid + "'";
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
    public static string DeleteVehicle(string VehicleID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteVehicle " + "" + VehicleID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
}