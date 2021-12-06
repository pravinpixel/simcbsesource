using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Web.Services;
using System.Web.Security;

public partial class AdminMaster : System.Web.UI.MasterPage
{
    Utilities utl = null;
    string sqlstr = "";
    int Userid = 0;
    string strQueryStatus = "";
    string Academicyear, academicid = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] != null)
        {
            utl = new Utilities();
            Userid = Convert.ToInt32(Session["UserId"].ToString());
            sqlstr = "select top 1 convert(varchar,logindate,109) as logindate from m_loginlogs where userid='" + Userid + "' and logoutdate is not null order by logid desc ";
            lstlogin.Text = utl.ExecuteScalar(sqlstr);
            sqlstr = "select top 1 LogID from m_loginlogs where userid='" + Userid + "' order by logid desc ";
            Session["LogID"] = utl.ExecuteScalar(sqlstr);

            sqlstr = "select Photofile from e_staffinfo a inner join m_users b on a.staffid=b.staffid where b.isactive=1 and b.userid='" + Session["UserId"].ToString() + "'";
            string Photofile = utl.ExecuteScalar(sqlstr);
            if (Photofile != null && Photofile != "")
            {
                if (System.IO.File.Exists("../Staffs/Uploads/ProfilePhotos/" + Photofile))
                {
                    imgStaff.Src = "../Staffs/Uploads/ProfilePhotos/" + Photofile;
                }
                else
                {
                    imgStaff.Src = "../img/photo.jpg";
                }                
            }
            else
            {
                imgStaff.Src = "../img/photo.jpg";
            }

        }
        else
            Response.Redirect("~/Default.aspx");

        if (Request.QueryString["moduleId"] != null)
            hdnDashModuleId.Value = Request.QueryString["moduleId"].ToString();

        if (Request.QueryString["activeIndex"] != null)
            hdnIndex.Value = Request.QueryString["activeIndex"].ToString();
        else
            hdnIndex.Value = "0";

        if (Request.QueryString["menuId"] != null)
            hdnMenuIndex.Value = Request.QueryString["menuId"].ToString();
        
        chkUser();
        GetMenus();
        if (!IsPostBack)
        {
            BindAcademicYear();
            if (Session["AcademicID"].ToString() != "")
            {
                academicid = utl.ExecuteScalar("select top 1 academicid from m_academicyear where academicid='" + Session["AcademicID"] + "' order by academicid desc");
                if (academicid != "")
                {
                    hfAcademicYear.Value = academicid.ToString();
                    ddlAcademicYear.SelectedValue = academicid.ToString();
                    Session["AcademicID"] = academicid.ToString();
                }
            }

        }
        if (string.IsNullOrEmpty(hdnMenuIndex.Value))
            BindSubMenu("-1");
        else
            BindSubMenu(hdnMenuIndex.Value);
        
    }
    public void BindAcademicYear()
    {
        utl = new Utilities();
        sqlstr = "sp_getAcademinYear";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlAcademicYear.DataSource = dt;
            ddlAcademicYear.DataTextField = "AcademicYear";
            ddlAcademicYear.DataValueField = "AcademicID";
            ddlAcademicYear.DataBind();
            ddlAcademicYear.Items.Insert(0, "Academic Year");
        }
        else
        {
            ddlAcademicYear.DataSource = null;
            ddlAcademicYear.DataBind();
            ddlAcademicYear.SelectedIndex = 0;
        }
    }
    public void chkUser()
    {
        if (Session["UserId"] != null & Request.QueryString["moduleId"] != null)
        {
            hfuserid.Value = Session["UserId"].ToString();
            if (hfuserid.Value != "1")
            {
                GetRole(Convert.ToInt32(hfuserid.Value), Convert.ToInt32(Request.QueryString["moduleId"].ToString()));
            }
            else
            {
                hfAddPrm.Value = "true";
                hfDeletePrm.Value = "true";
                hfEditPrm.Value = "true";
                hfViewPrm.Value = "true";
            }

        }
        else if (Session["UserId"] != null & Request.QueryString["StudentID"] != null)
        {
            hfuserid.Value = Session["UserId"].ToString();
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }
        lblUserName.Text = GetUserByUserId(Convert.ToInt32(hfuserid.Value)).ToUpper().ToString();
    }

    public void GetRole(int userId, int moduleId)
    {
        if (moduleId == -1)
        {
            hfAddPrm.Value = "true";
            hfDeletePrm.Value = "true";
            hfEditPrm.Value = "true";
            hfViewPrm.Value = "true";
        }
        else
        {
            hfAddPrm.Value = "true";
            hfDeletePrm.Value = "true";
            hfEditPrm.Value = "true";
            hfViewPrm.Value = "true";

            utl = new Utilities();
            sqlstr = "exec [sp_GetUserMenusAndModules1]" + userId + "," + moduleId + "";
            DataTable dt = new DataTable();
            DataRow dr = null;
            dt = utl.GetDataTable(sqlstr);
            if (dt != null && dt.Rows.Count > 0)
            {
                dr = dt.Rows[0];
                hfAddPrm.Value = dr["AddPrm"].ToString().ToLower();
                hfDeletePrm.Value = dr["DeletePrm"].ToString().ToLower();
                hfEditPrm.Value = dr["EditPrm"].ToString().ToLower();

                if (hfAddPrm.Value == "true" || hfDeletePrm.Value == "true" || hfEditPrm.Value == "true")
                    hfViewPrm.Value = "true";
                else
                    hfViewPrm.Value = "true";
            }
            else
            {
                FormsAuthentication.SignOut();
                Session["User"] = null;
                Response.Redirect("~/Default.aspx");
            }
        }
    }

    protected string GetUserByUserId(int userId)
    {
        string userName = string.Empty;
        utl = new Utilities();
        sqlstr = "exec [sp_GetUser] " + userId + "";
        DataTable dt = new DataTable();
        DataRow dr = null;
        dt = utl.GetDataTable(sqlstr);
        if (dt != null && dt.Rows.Count > 0)
        {
            dr = dt.Rows[0];
            userName = dr["UserName"].ToString();
        }
        return userName;
    }

    private void BindSubMenu(string id)
    {
        HtmlGenericControl ul = new HtmlGenericControl("ul");
        ul.Attributes.Add("class", "section1 menu");

        if (id == "-1")
        {
            //subMain.Controls.Clear();
            HtmlGenericControl dbLi = new HtmlGenericControl("li");
            HtmlAnchor dbAnchor = new HtmlAnchor();
            dbAnchor.InnerText = "Dashboard";
            dbAnchor.Attributes.Add("class", "menuitem");

            HtmlGenericControl dbSubUL = new HtmlGenericControl("ul");
            dbSubUL.Attributes.Add("class", "submenu");

            HtmlGenericControl dbSubLI = new HtmlGenericControl("li");
            HtmlAnchor dbSubAnchor = new HtmlAnchor();
            dbSubAnchor.InnerHtml = "Manage Dashboard";
            dbSubAnchor.HRef = "~/Users/Dashboard.aspx?menuId=-1&moduleId=-1&AcademicYear=" + Session["AcademicID"].ToString() + "";
            dbSubAnchor.Attributes.Add("id", "-1-1");
            dbSubLI.Controls.Add(dbSubAnchor);
            dbSubUL.Controls.Add(dbSubLI);
            dbSubAnchor.Attributes.Add("style", "background:#a8bcc8;font-weight:bold;");

            dbLi.Controls.Add(dbAnchor);
            dbLi.Controls.Add(dbSubUL);
            ul.Controls.Add(dbLi);
        }
        else
        {
            phSubMenu.Controls.Clear();
            HtmlGenericControl div = (HtmlGenericControl)FindControl("menuDash");

            //dBbtn.Attributes.Add("style", "background:#103D5F");

            DataTable dtTable = new DataTable();
            dtTable = (DataTable)ViewState["menuDataTable"];
            DataTable dtMenu = new DataTable(); ;
            if (dtTable != null && dtTable.Rows.Count > 0)
                dtMenu = dtTable.Select("ParentId=" + Convert.ToInt32(id) + "").CopyToDataTable();

            DataTable dt = new DataTable();
            if (dtMenu != null && dtMenu.Rows.Count > 0)
                dt = dtMenu.DefaultView.ToTable(true, "MenuId", "MenuName");
            if (dt != null && dt.Rows.Count > 0)
            {
                int index = 0;

                foreach (DataRow dr in dt.Rows)
                {
                    HtmlGenericControl li = new HtmlGenericControl("li");
                    HtmlAnchor anchor = new HtmlAnchor();
                    anchor.InnerText = dr["MenuName"].ToString();
                    anchor.Attributes.Add("class", "menuitem");

                    HtmlGenericControl subUL = new HtmlGenericControl("ul");
                    subUL.Attributes.Add("class", "submenu");

                    DataTable dtModules = dtMenu.Select("MenuId=" + Convert.ToInt32(dr["MenuId"]) + "").CopyToDataTable();

                    if (dtModules != null && dtModules.Rows.Count > 0)
                    {
                        foreach (DataRow drow in dtModules.Rows)
                        {
                            string queryString = "menuId=" + drow["ParentId"].ToString() + "&activeIndex=" + index + "&moduleId=" + drow["modulemenuid"].ToString() + "&AcademicYear=" + Session["AcademicID"].ToString() + "";
                            string oldId = hdnMenuIndex.Value + hdnDashModuleId.Value;
                            string newId = drow["ParentId"].ToString() + drow["modulemenuid"].ToString();

                            HtmlGenericControl subLI = new HtmlGenericControl("li");
                            HtmlAnchor subAnchor = new HtmlAnchor();
                            subAnchor.InnerHtml = drow["ModuleName"].ToString();
                            subAnchor.HRef = "~/" + drow["ModulePath"].ToString() + "?" + queryString + "";
                            subAnchor.Attributes.Add("id", drow["ParentId"].ToString() + drow["modulemenuid"].ToString());
                            if (oldId == newId)
                                subAnchor.Attributes.Add("style", "background:#a8bcc8;font-weight:bold;");

                            subLI.Controls.Add(subAnchor);
                            subUL.Controls.Add(subLI);
                        }
                    }
                    else
                    {
                        HtmlGenericControl subLI = new HtmlGenericControl("li");
                        HtmlAnchor subAnchor = new HtmlAnchor();
                        subAnchor.InnerHtml = "No Module";

                        subLI.Controls.Add(subAnchor);
                        subUL.Controls.Add(subLI);
                    }

                    li.Controls.Add(anchor);
                    li.Controls.Add(subUL);
                    ul.Controls.Add(li);

                    index++;
                }
            }
            else
            {
                HtmlGenericControl li = new HtmlGenericControl("li");
                HtmlAnchor anchor = new HtmlAnchor();
                anchor.InnerText = "No Menu for this item";
                anchor.Attributes.Add("class", "menuitem");

                li.Controls.Add(anchor);
                ul.Controls.Add(li);
            }
        }
        phSubMenu.Controls.Add(ul);

    }

    protected void btn_Click(object sender, EventArgs e)
    {
        LinkButton clickedButton = (LinkButton)sender;
        string id = clickedButton.ID;
        BindSubMenu(id);
    }

    private void GetMenus()
    {
        string userId = string.Empty;
        if (Session["UserId"] != null)
            userId = Session["UserId"].ToString();
        utl = new Utilities();
        sqlstr = "exec [sp_GetUserMenusAndModules1] " + userId + "";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);
        string menuName = string.Empty;

        ViewState["menuDataTable"] = dt;
        DataTable uniqueCols = dt.DefaultView.ToTable(true, "ParentId", "ParentMenuName");
        BindParentMenu(uniqueCols);

    }
    private void BindParentMenu(DataTable dt)
    {
        HtmlGenericControl ul = new HtmlGenericControl("ul");
        ul.Attributes.Add("class", "nav main");

        HtmlGenericControl dBli = new HtmlGenericControl("li");
        dBli.Attributes.Add("class", "ic-grid-tables");

        HtmlAnchor dBbtn = new HtmlAnchor();
        dBbtn.ID = "-1";
        dBbtn.HRef = "~/Users/Dashboard.aspx?moduleId=-1";
        dBbtn.Attributes.Add("style", "background:#103D5F;");
        dBbtn.Attributes.Add("onclick", "ChangeParentMenuBG('-1')");
      //  dBbtn.Click += new EventHandler(btn_Click);

        HtmlGenericControl dBspan = new HtmlGenericControl("span");
        dBspan.InnerText = "Dashboard";
        dBbtn.Controls.Add(dBspan);
        dBli.Controls.Add(dBbtn);
        ul.Controls.Add(dBli);

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                HtmlGenericControl li = new HtmlGenericControl("li");
                li.Attributes.Add("class", "ic-grid-tables");
                li.ID = "li-"+dr["ParentId"].ToString();
                LinkButton btn = new LinkButton();
                btn.ID = dr["ParentId"].ToString();
                btn.Click += new EventHandler(btn_Click);
                btn.Attributes.Add("onclick", "ChangeParentMenuBG('" + dr["ParentId"].ToString() + "')");
                btn.Attributes.Add("class", dr["ParentId"].ToString());
                //HtmlAnchor anchor = new HtmlAnchor();
                //anchor.Attributes.Add("class", "amenu");
                //anchor.ID = "anchor-" + dr["MenuId"].ToString();
                //anchor.Attributes.Add("onserverclick", "serverClick('" + anchor.ID + "')");
                HtmlGenericControl span = new HtmlGenericControl("span");
                span.InnerText = dr["ParentMenuName"].ToString();
                btn.Controls.Add(span);
                li.Controls.Add(btn);
                ul.Controls.Add(li);
            }
        }
        phMainMenu.Controls.Add(ul);
    }

    protected void ddlAcademicYear_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["AcademicID"] = ddlAcademicYear.SelectedValue.ToString();
        if (Session["AcademicID"].ToString() != "")
        {
            hfAcademicYear.Value = Session["AcademicID"].ToString();
            ddlAcademicYear.SelectedValue = Session["AcademicID"].ToString();
            Response.Redirect("~/Users/Dashboard.aspx?moduleId=-1&AcademicYear=" + Session["AcademicID"].ToString() + "");
        }
    }

    
}
