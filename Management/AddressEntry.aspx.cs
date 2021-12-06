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
public partial class Management_AddressEntry : System.Web.UI.Page
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
            BindDummyRow();
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("SlNo");
            dummy.Columns.Add("Name");
            dummy.Columns.Add("AddressType");
            dummy.Columns.Add("Address");
            dummy.Columns.Add("MobileNo1");
            dummy.Columns.Add("MobileNo2");
            dummy.Columns.Add("MobileNo3");
            dummy.Columns.Add("Email");
            dummy.Columns.Add("WayofAssociation");
            dummy.Columns.Add("AddressID");
            dummy.Rows.Add();
            dgAddressBookInfo.DataSource = dummy;
            dgAddressBookInfo.DataBind();
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
                    sda.Fill(ds, "AddressBookInfo");
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
    public static string GetAddressBookInfo(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetAddressBook_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
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
    public static string GetAddressInfo(int AddressID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetAddressBook " + "" + AddressID + "";
        return utl.GetDatasetTable(query, "EditAddressBookInfo").GetXml();
    }
    [WebMethod]
    public static string EditAddressBookInfo(int AddressBookInfoID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetAddressBook " + "" + AddressBookInfoID + "";
        return utl.GetDatasetTable(query, "EditAddressBookInfo").GetXml();
    }

    [WebMethod]
    public static string DeleteAddressBookInfo(string AddressBookInfoID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteAddressBook " + "" + AddressBookInfoID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string SaveAddress(string AddressID, string Salutation, string Name, string Address, string AddressType, string WOA, string Email, string Mobile1, string Mobile2, string Mobile3)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(AddressID))
        {
            sqlstr = "select isnull(count(*),0) from a_addressbook where Name='" + Name.Replace("'", "''") + "' and Address='" + Address.Replace("'", "''") + "' and AddressType='" + AddressType.Replace("'", "''") + "' and wayofassociation='" + WOA.Replace("'", "''") + "' and Email='" + Email.Replace("'", "''") + "' and MobileNo1='" + Mobile1.Replace("'", "''") + "'  and MobileNo2='" + Mobile2.Replace("'", "''") + "'   and MobileNo3='" + Mobile3.Replace("'", "''") + "'   and AddressID!='" + AddressID + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateAddress " + "'" + AddressID + "','" + Salutation.Replace("'", "''") + "','" + Name.Replace("'", "''") + "','" + AddressType.Replace("'", "''") + "','" + Address.Replace("'", "''") + "','" + WOA.Replace("'", "''") + "','" + Email.Replace("'", "''") + "','" + Mobile1.Replace("'", "''") + "','" + Mobile2.Replace("'", "''") + "','" + Mobile3.Replace("'", "''") + "','" + Userid + "'";
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
            sqlstr = "select isnull(count(*),0) from a_addressbook where Name='" + Name.Replace("'", "''") + "' and Address='" + Address.Replace("'", "''") + "'and AddressType='" + AddressType.Replace("'", "''") + "' and wayofassociation='" + WOA.Replace("'", "''") + "' and Email='" + Email.Replace("'", "''") + "' and MobileNo1='" + Mobile1.Replace("'", "''") + "'  and MobileNo2='" + Mobile2.Replace("'", "''") + "'   and MobileNo3='" + Mobile3.Replace("'", "''") + "'   and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertAddress '" + Salutation.Replace("'", "''") + "','" + Name.Replace("'", "''") + "','" + Address.Replace("'", "''") + "','" + AddressType.Replace("'", "''") + "','" + WOA.Replace("'", "''") + "','" + Email.Replace("'", "''") + "','" + Mobile1.Replace("'", "''") + "','" + Mobile2.Replace("'", "''") + "','" + Mobile3.Replace("'", "''") + "','" + Userid + "'";
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
    
}