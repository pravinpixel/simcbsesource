using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Drawing;
using System.Collections;
using System.Text;
using System.Web.Services;
using System.Data.SqlClient;


public partial class ModulesAndMenus_AddModuleMenu : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    int Userid = 0;
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
            BindParentMenu();
            BindModuleMenuRow();
        }
    }
    private void BindModuleMenuRow()
    {
         HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

         if (hdnID.Value.ToLower() == "true")
         {
             DataTable dummy = new DataTable();
             dummy.Columns.Add("parentname");
             dummy.Columns.Add("menuname");
             dummy.Columns.Add("modulename");
             dummy.Columns.Add("STATUS");
             dummy.Columns.Add("modulemenuid");
             dummy.Rows.Add();
             dgModuleMenu.DataSource = dummy;
             dgModuleMenu.DataBind();
         }
    }

    private DataTable GetModule()
    {
        utl = new Utilities();
        sqlstr = "exec sp_GetModule";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        return dt;
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

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        utl = new Utilities();
        if (hfModuleMenuId.Value != "")
        {
            sqlstr = "sp_UpdateModuleMenu " + "'" + hfModuleMenuId.Value + "'," + Userid + "," + dpMenu.SelectedValue + "";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
            {
                utl.ShowMessage("Updated Successfully", this.Page);
            }
            else
            {
                utl.ShowMessage(strQueryStatus, this.Page);
            }
        }
        else
        {
            //foreach (ListItem lst in chkModules.Items)
            //{
            //    if (lst.Selected)
            //    {
            //        sqlstr = "sp_InsertModuleMenu " + lst.Value + "," + "" + Userid + "," + dpMenu.SelectedValue + "";
            //        strQueryStatus = utl.ExecuteQuery(sqlstr);

            //        if (strQueryStatus == "")
            //        {
            //            utl.ShowMessage("Inserted Successfully", this.Page);
            //        }
            //        else
            //        {
            //            utl.ShowMessage(strQueryStatus, this.Page);
            //        }
            //    }
            //}
        }
        Response.Redirect("AddModuleMenu.aspx");
    }
    [WebMethod]
    public static string ChangeStatus(string moduleMenuId, string status, string userId)
    {
        Utilities utl = new Utilities();
        DataTable dt = new DataTable();

        string message = string.Empty;

        if (status.ToLower() == "deactive")
        {
            status = "0";
            message = "Deactivated";
        }
        else
        {
            status = "1";
            message = "Activated";
        }

         string strQueryStatus=utl.ExecuteQuery("sp_UpdateModuleMenu " + moduleMenuId + "," + "'" + status + "'," + userId + "");
         if (strQueryStatus == "")
             return message;
         else
             return "Status Update Failed";
    }

    protected string BindModules()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();

        dt = GetModule();
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                sb.Append("<div class=\"checkbox\"><input id=\"rd_" + dr["ModuleId"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" name=\"chkModules\" value=\"" + dr["ModuleId"].ToString() + "\" />");
                sb.Append("<label name=\"lblModules\" id=\"lbl_rd_" + dr["ModuleId"].ToString() + "\" for=\"rd_" + dr["ModuleId"].ToString() + "\">" + dr["ModuleName"].ToString() + "</label></div>");
            }

        }
        return sb.ToString();
    }
    [WebMethod]
    public static string GetModuleMenu(int pageIndex, string menuId, string pMenuId)
    {
        if (string.IsNullOrEmpty(menuId))
            menuId ="''";

        if (string.IsNullOrEmpty(pMenuId))
            pMenuId = "null";

        Utilities utl = new Utilities();

        string query = "[GetModuleMenu_Pager1] " + pageIndex + "," + PageSize + ",10," + pMenuId + "," + menuId + "";

        DataSet ds = utl.GetDatasetTable(query, "ModuleMenus");
        DataTable dt = new DataTable("Pager");
        dt.Columns.Add("PageIndex");
        dt.Columns.Add("PageSize");
        dt.Columns.Add("RecordCount");
        dt.Rows.Add();
        dt.Rows[0]["PageIndex"] = pageIndex;
        dt.Rows[0]["PageSize"] = PageSize;
        dt.Rows[0]["RecordCount"] = ds.Tables[1].Rows[0][0];
        ds.Tables.Add(dt);
        return ds.GetXml();
    }
    [WebMethod]
    public static string GetModuleMenuByMenuId(int menuId)
    {
        Utilities utl = new Utilities();
        string query = "[GetModuleMenuByMenuId] "+menuId+"";
        return utl.GetDatasetTable(query, "ModuleMenuById").GetXml();
    }
    [WebMethod]
    public static string SaveModuleMenu(string query)
    {
        Utilities utl = new Utilities();
        string strQueryStatus = utl.ExecuteQuery(query);

        if (strQueryStatus == "")
            return "Inserted";
        else
            return "Insert Failed";
    }

    [WebMethod]
    public static string UpdateModuleMenu(List<string> array, string parentMenu, string menu, string userId)
    {
        string mQuery = string.Empty;
        Utilities utl = new Utilities();
        string query = "exec [GetModuleMenuByMenuId] " + menu + "";
        DataSet ds = utl.GetDataset(query);

        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            string value = dr["moduleid"].ToString();
            var isactive = dr["IsModuleActive"].ToString();
            int pos = array.FindIndex(arr => arr == value);
            if (pos == -1)
            {
                    mQuery += "exec sp_InsertModuleMenu " + value + "," + "" + userId + "," + menu + ",'False';";
            }
            else
            {
                if (isactive == "False")
                    mQuery += "exec sp_InsertModuleMenu " + value + "," + "" + userId + "," + menu + ",'True';";
            }
            array.Remove(value);
        }
        foreach (string str in array)
        {
            mQuery += "exec sp_InsertModuleMenu " + str + "," + "" + userId + "," + menu + ",'True';";
        }
        string strQueryStatus = string.Empty;
        if (mQuery != string.Empty)
            strQueryStatus = utl.ExecuteQuery(mQuery);

        if (strQueryStatus == "")
            return "Updated";
        else
            return "Failed";
    }

    [WebMethod]
    public static string UpdateSortingOrder(string moduleMenuId, string sortingValue)
    {
        Utilities utl = new Utilities();
        string query = "exec [UpdateSortingOrder] " + moduleMenuId + "," + sortingValue + "";
        string queryStatus = utl.ExecuteQuery(query);
        if (queryStatus != string.Empty)
            return "failed";
        else
        return "";
    }

    void GroupGridView(GridViewRowCollection gvrc, int startIndex, int total)
    {
        if (total == 0) return;
        int i, count = 1;
        ArrayList lst = new ArrayList();
        lst.Add(gvrc[0]);
        var ctrl = gvrc[0].Cells[startIndex];
        for (i = 1; i < gvrc.Count; i++)
        {
            TableCell nextCell = gvrc[i].Cells[startIndex];
            if (ctrl.Text == nextCell.Text)
            {
                count++;
                nextCell.Visible = false;
                lst.Add(gvrc[i]);
            }
            else
            {
                if (count > 1)
                {
                    ctrl.RowSpan = count;
                    GroupGridView(new GridViewRowCollection(lst), startIndex + 1, total - 1);
                }
                count = 1;
                lst.Clear();
                ctrl = gvrc[i].Cells[startIndex];
                lst.Add(gvrc[i]);
            }
        }
        if (count > 1)
        {
            ctrl.RowSpan = count;
            GroupGridView(new GridViewRowCollection(lst), startIndex + 1, total - 1);
        }
        count = 1;
        lst.Clear();
    }


}


