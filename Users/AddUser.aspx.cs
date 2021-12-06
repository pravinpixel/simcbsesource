using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Text;

public partial class Users_AddUser : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public int Userid = 0;
    string strQueryStatus = "";
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] != null)
        {
            hdnUserId.Value = Session["UserId"].ToString();
            Userid = Convert.ToInt32(hdnUserId.Value);

        }
        if (!IsPostBack)
        {
            BindRole();
            BindEmployee();
            BindUserRow();
        }
    }
    private void BindUserRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("UserName");
            dummy.Columns.Add("EmpCode");
            dummy.Columns.Add("EmpName");
            dummy.Columns.Add("RoleName");
            dummy.Columns.Add("UserId");

            dummy.Rows.Add();
            dgUser.DataSource = dummy;
            dgUser.DataBind();
        }
    }

    [WebMethod]
    public static string GetUsers(int pageIndex,string search)
    { 
        DataSet dsusers = new DataSet();
        Utilities utl = new Utilities();
        string query = "[GetUser_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@search", search);
        dsusers = utl.GetData(cmd, pageIndex, "Users", PageSize);

        Utilities1 utl1 = new Utilities1();
        query = "[GetUser_Pager]";
        cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@search", search);
      
        //dsusers= utl1.GetData(cmd, pageIndex, "Users", PageSize);

       return dsusers.GetXml();
    }

    [WebMethod]
    public static string GetEmployee(string staffId)
    {
        Utilities utl = new Utilities();
        Utilities1 utl1 = new Utilities1();
        DataTable dt = new DataTable();
        DataTable dt1 = new DataTable();

        string query = "[sp_GetEmployee] "+staffId+"";

        dt = utl.GetDataTable(query);
        dt1 = utl.GetDataTable(query);

        if (dt != null && dt.Rows.Count > 0)
        {
            return utl.GetDatasetTable(query, "Employees").GetXml();
        }
        else
        {
            return utl1.GetDatasetTable(query, "Employees").GetXml();
        }        
    }

    
    [WebMethod]
    public static string GetEmployeeByName(string staffName)    
    {
        Utilities utl = new Utilities();
        Utilities1 utl1 = new Utilities1();
        string query = "[sp_GetEmployee] '','" + staffName.Trim() + "'";

        DataSet ds = utl.GetDatasetTable(query, "Employee");
        DataSet ds1 = utl1.GetDatasetTable(query, "Employee");

        ds.Merge(ds1);

        return ds.GetXml();
    }


    [WebMethod]
    public static string ChangePassword(string userId)
    {
        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable("sp_GetUser " + "" + userId + "");
        if (dt != null && dt.Rows.Count > 0)
        {
            return userId;
        }
        else
            return "-1";
    }
    private void BindEmployee()
    {
        Utilities utl = new Utilities();
        Utilities1 utl1 = new Utilities1();

        DataTable dt = new DataTable();
        dt = utl.GetDataTable("[sp_GetEmployeeForAddUser]");

        DataTable dt1 = new DataTable();
        dt1 = utl1.GetDataTable("[sp_GetEmployeeForAddUser]");

        DataTable dtAll = new DataTable();
        dtAll = dt1.Copy();
        dtAll.Merge(dt, true);
        
        if (dt != null && dt.Rows.Count > 0)
        {
            dpEmployee.DataSource = dtAll;
            dpEmployee.DataTextField = "EmpCode";
            dpEmployee.DataValueField = "StaffId";
            dpEmployee.DataBind();            
        }        

        dpEmployee.Items.Insert(0, new ListItem("-- Select Employee --", ""));
    }

    private void BindRole()
    {
        utl = new Utilities();
        sqlstr = "exec sp_GetRole";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            dpRole.DataSource = dt;
            dpRole.DataTextField = "RoleName";
            dpRole.DataValueField = "RoleId";
            dpRole.DataBind();
        }
        else
        {
            dpRole.DataSource = null;
            dpRole.DataBind();
        }
        dpRole.Items.Insert(0, new ListItem("-- Select Role --", ""));
    }
    [WebMethod]
    public static string DeleteUser(string userId)
    {
        Utilities utl = new Utilities();
        string strQueryStatus = utl.ExecuteScalar("sp_DeleteUser " + "" + userId + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
    [WebMethod]
    public static string ViewRights(string userId)
    {
        StringBuilder divFirstContent = new StringBuilder();
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        ds = utl.GetDataset("Exec sp_getPermissionList " + userId);
        if (ds != null && ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                divFirstContent.Append(" <table class='data display datatable' id='example'><thead><tr><th width='20%' class='sorting_mod center' >MenuName</th><th width='20% center' class='sorting_mod' >ModuleName</th><th width='16%' class='sorting_mod center' >ViewPrm</th><th width='16%' class='sorting_mod center' >AddPrm</th><th width='18%' class='sorting_mod center' >EditPrm</th><th width='30% center' class='sorting_mod' >DeletePrm</th></tr></thead><tbody>");
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    divFirstContent.Append("<tr class='even'><td style='color:black; font-weight:bold'>" + ds.Tables[0].Rows[i]["MenuName"].ToString() + "</td><td style='color:black; font-weight:bold'>" + ds.Tables[0].Rows[i]["ModuleName"].ToString() + "</td>");
                    if (ds.Tables[0].Rows[i]["ViewPrm"].ToString().Trim() == "Yes")
                     {
                         divFirstContent.Append("<td style='color:green; font-weight:bold'>" + ds.Tables[0].Rows[i]["ViewPrm"].ToString() + "</td>");
                     }
                     else
                     {
                         divFirstContent.Append("<td style='color:red; font-weight:bold'>" + ds.Tables[0].Rows[i]["ViewPrm"].ToString() + "</td>");
                     }
                     if (ds.Tables[0].Rows[i]["AddPrm"].ToString().Trim() == "Yes")
                     {
                         divFirstContent.Append("<td style='color:green; font-weight:bold'>" + ds.Tables[0].Rows[i]["AddPrm"].ToString() + "</td>");
                     }
                     else
                     {
                         divFirstContent.Append("<td style='color:red; font-weight:bold'>" + ds.Tables[0].Rows[i]["AddPrm"].ToString() + "</td>");
                     }
                     if (ds.Tables[0].Rows[i]["EditPrm"].ToString().Trim() == "Yes")
                     {
                         divFirstContent.Append("<td style='color:green; font-weight:bold'>" + ds.Tables[0].Rows[i]["EditPrm"].ToString() + "</td>");
                     }
                     else
                     {
                         divFirstContent.Append("<td style='color:red; font-weight:bold'>" + ds.Tables[0].Rows[i]["EditPrm"].ToString() + "</td>");
                     }
                     if (ds.Tables[0].Rows[i]["DeletePrm"].ToString().Trim() == "Yes")
                     {
                         divFirstContent.Append("<td style='color:green; font-weight:bold'>" + ds.Tables[0].Rows[i]["DeletePrm"].ToString() + "</td>");
                     }
                     else
                     {
                         divFirstContent.Append("<td style='color:red; font-weight:bold'>" + ds.Tables[0].Rows[i]["DeletePrm"].ToString() + "</td>");
                     }
                     divFirstContent.Append("</tr>");
                }
                divFirstContent.Append("</tbody></table>");
            }
        }       
        string firstContent = string.Empty;
        DataSet ds1 = new DataSet();
        DataTable dt = new DataTable("Rights");
        dt.Columns.Add(new DataColumn("rights", typeof(string)));
        firstContent = divFirstContent.ToString();
        DataRow dr = dt.NewRow();
        dr["rights"] = firstContent;
        dt.Rows.Add(dr);

        ds1.Tables.Add(dt);
        return ds1.GetXml();
    }
    [WebMethod]
    public static string SaveUser(string empId, string userName, string password, string roleId)
    {
        string user = IsUserExists(userName);
        if (user == "0")
        {
            Utilities utl = new Utilities();
            CryptoSystem crp = new CryptoSystem();
            string newPassword = crp.Encrypt(password);
            string sqlstr = "sp_InsertUser " + "" + Convert.ToInt32(empId) + ",'" + userName + "','" + newPassword + "'," + Convert.ToInt32(roleId) + "";
            string strQueryStatus = utl.ExecuteScalar(sqlstr);
            if (strQueryStatus!= "")
            {
                string CurrentUserID = strQueryStatus.ToString();
                sqlstr = "select * from m_userpermissions where  userid in ( select top 1 userid from m_users where RoleId =" + roleId + ")";
                DataTable dts = new DataTable();
               dts= utl.GetDataTable(sqlstr);
               if (dts.Rows.Count>0)
               {
                   for (int i = 0; i < dts.Rows.Count; i++)
                   {
                       sqlstr = "insert into m_userpermissions (UserId,AdminId,ModuleMenuId,AddPrm,ViewPrm,EditPrm,DeletePrm) values(" + CurrentUserID + "," + HttpContext.Current.Session["UserId"].ToString() + "," + dts.Rows[i]["ModuleMenuId"] + ",'" + dts.Rows[i]["AddPrm"] + "','" + dts.Rows[i]["ViewPrm"] + "','" + dts.Rows[i]["EditPrm"] + "','" + dts.Rows[i]["DeletePrm"] + "')";
                       utl.ExecuteQuery(sqlstr);
                   }
               }
                return "Inserted";
            }
            else
                return "Insert Failed";
        }
        else 
            return "exists";
   }
    [WebMethod]
    public static string IsUserExists(string userName)
    {
        Utilities utl = new Utilities();
        string query = "exec sp_IsUserNameExists '" + userName + "'";
        return utl.ExecuteScalarValue(query);
    }
    [WebMethod]
    public static string SavePassword(string id, string password)
    {
        Utilities utl = new Utilities();
        CryptoSystem crp = new CryptoSystem();
        string newPassword = crp.Encrypt(password);
        string sqlstr = "sp_UpdateUserPassword " + "'" + id + "','" + newPassword + "'";
        string strQueryStatus = utl.ExecuteQuery(sqlstr);
        if (strQueryStatus == "")
            return "Updated";
        else
            return "Update Failed";
    }
    [WebMethod]
    public static string ReloadEmployee()
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        ds = utl.GetDatasetTable("Exec sp_GetEmployeeForAddUser", "Employees");
        return ds.GetXml();
    }
}