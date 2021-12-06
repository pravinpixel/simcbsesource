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
using System.Web.UI.HtmlControls;

public partial class ModulesAndMenus_AddModule : System.Web.UI.Page
{
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        
        if (!IsPostBack)
        {
            BindModuleRow(); 
        }
    }

    private void BindModuleRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("ModuleName");
            dummy.Columns.Add("Description");
            dummy.Columns.Add("ModulePath");
            dummy.Columns.Add("ModuleId");

            dummy.Rows.Add();
            dgModule.DataSource = dummy;
            dgModule.DataBind();
        }
    }

    [WebMethod]
    public static string GetModules(int pageIndex)
    {
        Utilities utl = new Utilities();

        string query = "[GetModules_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return utl.GetData(cmd, pageIndex, "Modules", PageSize).GetXml();
    }

    [WebMethod]
    public static string EditModules(int moduleId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModule " + "" + moduleId + "";
        return utl.GetDatasetTable(query,"EditModules").GetXml();
    }

    [WebMethod]
    public static string SaveModule(string id, string name, string description, string path)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        if (!string.IsNullOrEmpty(id))
        {
            string sqlExists = "[sp_ISNameExistForUpdate] 'm_modules','modulename','" + name + "','moduleid','"+id+"'";
            string result = utl.ExecuteScalar(sqlExists);
            if (result != "0")
            {
                return "Exists";
            }
            else
            {
                sqlstr = "sp_UpdateModule " + "'" + id + "','" + name + "','" + description + "','" + path + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
        }
        else
        {
            string sqlExists = "[sp_ISNameExist] 'm_modules','modulename','" + name + "'";
            string result = utl.ExecuteScalar(sqlExists);
            if (result != "0")
            {
                return "Exists";
            }
            else
            {
                sqlstr = "sp_InsertModule " + "'" + name + "','" + description + "','" + path + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
                else
                    return "Insert Failed";
            }
        }
    }
    [WebMethod]
    public static string DeleteModule(string moduleId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        strQueryStatus = utl.ExecuteScalar("sp_DeleteModule " + "" + moduleId + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
}