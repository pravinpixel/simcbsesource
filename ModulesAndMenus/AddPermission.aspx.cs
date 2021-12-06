using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;


public partial class ModulesAndMenus_AddPermission : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    int Userid = 0;
    string strQueryStatus = "";
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (!Page.IsPostBack)
        {
            if (Session["UserId"] != null)
            {
                Userid = Convert.ToInt32(Session["UserId"].ToString());
                hdnAdminId.Value = Userid.ToString();
            }

            BindUsers();
            BindPermissionRow();
            BindParentMenu();
        }
    }
    private void BindUsers()
    {
        utl = new Utilities();
        sqlstr = "exec sp_GetUser";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            dpUsers.DataSource = dt;
            dpUsers.DataTextField = "UserName";
            dpUsers.DataValueField = "UserId";
            dpUsers.DataBind();

        }
        else
        {
            dpUsers.DataSource = null;
            dpUsers.DataBind();
        }
        dpUsers.Items.Remove(dpUsers.Items.FindByValue("1"));
        dpUsers.Items.Insert(0, new ListItem("-- Select Users--", ""));
    }
    private void BindParentMenu()
    {
        utl = new Utilities();
        sqlstr = "exec sp_GetMenu '',0";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            dpParentMenu.DataSource = dt;
            dpParentMenu.DataTextField = "MenuName";
            dpParentMenu.DataValueField = "MenuId";
            dpParentMenu.DataBind();

        }
        else
        {
            dpParentMenu.DataSource = null;
            dpParentMenu.DataBind();

        }
        dpParentMenu.Items.Insert(0, new ListItem("-- Select Parent Menu --", ""));
    }
    private void BindPermissionRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

         if (hdnID.Value.ToLower() == "true")
         {
             DataTable dummy = new DataTable();
             //dummy.Columns.Add("modulemenuId");
             dummy.Columns.Add("modulename");
             dummy.Columns.Add("AddPrm");
             dummy.Columns.Add("EditPrm");
             dummy.Columns.Add("DeletePrm");
             dummy.Columns.Add("ViewPrm");

             dummy.Rows.Add();
             dgUserPermission.DataSource = dummy;
             dgUserPermission.DataBind();
         }
    }
    [WebMethod]
    public static string GetSubMenu(int id)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        if (id == 0)
            sqlstr = "exec sp_GetSubMenu";
        else
            sqlstr = "exec sp_GetSubMenu " + id + "";
        DataTable dt = new DataTable();
        return utl.GetDatasetTable(sqlstr, "SubMenus").GetXml();
    }

    [WebMethod]
    public static string GetUserRoleById(string userId)
    {
    Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable("sp_GetUser " + "" + userId + "");
        if (dt != null && dt.Rows.Count > 0)
        {
            return dt.Rows[0]["RoleName"].ToString();
        }
        else
            return "";
}

    [WebMethod]
    public static string GetPermission(string userId, string menuId)
    {
        Utilities utl = new Utilities();
        string query = "[GetUserPermission_Pager] "+userId+","+menuId+"";
        DataTable dt = new DataTable();
        DataSet ds = utl.GetDatasetTable(query, "UserPermissions");
        if(ds!=null&&ds.Tables[0].Rows.Count>0)
        return utl.GetDatasetTable(query, "UserPermissions").GetXml();
        else
            return utl.GetDatasetTable("exec sp_GetModuleMenu ''," + menuId + "," + userId + "", "UserPermissions").GetXml();
    }
    [WebMethod]
    public static string SavePermission(string query)
    {
        Utilities utl = new Utilities();
        string strQueryStatus = utl.ExecuteQuery(query);
        string message=string.Empty;
        if (strQueryStatus == string.Empty)
        {
            if (query.Contains("update"))
                message = "Updated";
            else
                message = "Inserted";
        }
        else
        {
            if (query.Contains("update"))
                message = "UpdateFailed";
            else
                message = "InsertFailed";
        }
        return message;
    }

}