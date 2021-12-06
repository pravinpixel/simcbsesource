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
public partial class Fuel : System.Web.UI.Page
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
                BindFuelType();
                BindDummyRow();
            }
        }
    }
    private void BindFuelType()
    {
        utl = new Utilities();
        sqlstr = "sp_GetFuelType";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlFuelType.DataSource = dt;
            ddlFuelType.DataTextField = "FuelTypeName";
            ddlFuelType.DataValueField = "FuelTypeID";
            ddlFuelType.DataBind();
        }
        else
        {
            ddlFuelType.DataSource = null;
            ddlFuelType.DataBind();
            ddlFuelType.SelectedIndex = 0;
        }


    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("FuelTypeName");
            dummy.Columns.Add("EntryDate");
            dummy.Columns.Add("PricePerLtr");
            dummy.Columns.Add("FuelID");

            dummy.Rows.Add();
            dgFuel.DataSource = dummy;
            dgFuel.DataBind();
        }
    }

    [WebMethod]
    public static string GetFuel(int pageIndex)
    {
        string query = "[GetFuel_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditFuel(int FuelID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetFuel " + "" + FuelID + "";
        return utl.GetDatasetTable(query, "EditFuel").GetXml();
    }

    [WebMethod]
    public static string SaveFuel(string id, string name, string entrydate, string priceperltr)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (entrydate != "")
        {
            string[] myDateTimeString = entrydate.Split('/');
            entrydate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }


        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_Fuels where FuelTypeID='" + name.Replace("'", "''") + "' and entrydate=" + entrydate + " and priceperltr='" + priceperltr + "' and Fuelid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateFuel " + "'" + id + "','" + name + "'," + entrydate + ",'" + priceperltr + "'," + Userid + "";
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
            sqlstr = "select isnull(count(*),0) from m_Fuels where FuelTypeID='" + name.Replace("'", "''") + "' and entrydate=" + entrydate + " and priceperltr='" + priceperltr + "' and isactive=1 ";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
            sqlstr = "sp_InsertFuel " + "'" + name + "'," + entrydate + ",'" + priceperltr + "'," + Userid + "";
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
    public static string DeleteFuel(string FuelID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteFuel " + "" + FuelID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
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
                    sda.Fill(ds, "Fuels");
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

}