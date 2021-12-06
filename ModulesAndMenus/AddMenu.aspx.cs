using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.Services;
using System.Configuration;

public partial class AddMenu : System.Web.UI.Page
{

    Utilities utl = null;
    string sqlstr = "";
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
       
        if (!IsPostBack)
        {
            BindMenuRow();
            BindDropDownMenu();
        }
    }

    private void BindMenuRow()
    {
         HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
         if (hdnID.Value.ToLower() == "true")
         {
             DataTable dummy = new DataTable();
             dummy.Columns.Add("MenuName");
             dummy.Columns.Add("Description");
             dummy.Columns.Add("MenuId");
             dummy.Columns.Add("ParentMenuName");
             dummy.Rows.Add();
             dgMenu.DataSource = dummy;
             dgMenu.DataBind();
         }
    }

    private void BindDropDownMenu()
    {
        utl = new Utilities();
        sqlstr = "exec sp_GetMenu '',0";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);
        if (dt != null && dt.Rows.Count > 0)
        {
            dpMenu.DataSource = dt;
            dpMenu.DataTextField = "MenuName";
            dpMenu.DataValueField = "MenuId";
            dpMenu.DataBind();
        }
        else
        {
            dpMenu.DataSource = null;
            dpMenu.DataBind();
        }
        dpMenu.Items.Insert(0, new ListItem("-- Select Parent Menu --", "0"));
    }
    [WebMethod]

    public static string GetMenu(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetMenu_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return utl.GetData(cmd, pageIndex, "Menus", PageSize).GetXml();
    }

    [WebMethod]
    public static string EditMenus(int menuId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetMenu " + "" + menuId + "";
        return utl.GetDatasetTable(query, "EditMenus").GetXml();
    }

    [WebMethod]
    public static string SaveMenu(string id, string name, string description, string parentId, int userId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        if (!string.IsNullOrEmpty(id))
        {
            string sqlExists = "[sp_ISNameExistForUpdate] 'm_menus','menuname','" + name + "','menuid','"+id+"'";
            string result = utl.ExecuteScalar(sqlExists);
            if (result != "0")
            {
                return "Exists";
            }
            else
            {
                sqlstr = "sp_UpdateMenu " + "" + id + ",'" + name + "','" + description + "'," + userId + "," + parentId + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
        }
        else
        {
            string sqlExists="[sp_ISNameExist] 'm_menus','menuname','"+name+"'";
            string result = utl.ExecuteScalar(sqlExists);
            if (result != "0")
            {
                return "Exists";
            }
            else
            {
                sqlstr = "sp_InsertMenu '" + name + "','" + description + "'," + userId + "," + parentId + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
                else
                    return "Insert Failed";
            }
        }
    }
    [WebMethod]
    public static string DeleteMenu(string menuId, string userId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        strQueryStatus = utl.ExecuteScalar("sp_DeleteMenu " + "" + menuId + "," + userId + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }

    [WebMethod]
    public static string GetMenuDropDown()
    {
        Utilities utl = new Utilities();
        string sqlstr = "exec sp_GetMenu '',0";
        DataSet ds = new DataSet();
        ds = utl.GetDatasetTable(sqlstr, "DropDownMenus");
        return ds.GetXml();
    }
}