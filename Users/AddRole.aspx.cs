using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

public partial class Users_AddRole : System.Web.UI.Page
{
    private static int PageSize = 10;
    public static int Userid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] != null)
            Userid = Convert.ToInt32(Session["UserId"].ToString());
        if (!IsPostBack)
            BindRoleRow();
    }
    private void BindRoleRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("RoleName");
            dummy.Columns.Add("RoleId");
            dummy.Rows.Add();
            dgRole.DataSource = dummy;
            dgRole.DataBind();
        }
    }

    [WebMethod]
    public static string GetRoles(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetRole_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return utl.GetData(cmd, pageIndex, "Roles", PageSize).GetXml();
    }

    [WebMethod]
    public static string SaveRole(string id, string name)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;

        if (!string.IsNullOrEmpty(id))
        {
            string sqlExists = "[sp_ISNameExistForUpdate] 'm_roles','rolename','" + name + "','roleid',"+id+"";
            string result = utl.ExecuteScalar(sqlExists);
            if (result != "0")
            {
                return "Exists";
            }
            else
            {
                sqlstr = "sp_UpdateRole " + "'" + id + "','" + name + "'," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
        }
        else
        {
            string sqlExists = "[sp_ISNameExist] 'm_roles','rolename','" + name + "'";
            string result = utl.ExecuteScalar(sqlExists);
            if (result != "0")
            {
                return "Exists";
            }
            else
            {
                sqlstr = "sp_InsertRole " + "'" + name + "'," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
                else
                    return "Insert Failed";
            }
        }
    }

    [WebMethod]
    public static string EditRole(int roleId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetRole " + "" + roleId + "";
        return utl.GetDatasetTable(query, "EditRoles").GetXml();
    }
    [WebMethod]
    public static string DeleteRole(string roleId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        strQueryStatus = utl.ExecuteScalar("sp_DeleteRole " + "" + roleId + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
}