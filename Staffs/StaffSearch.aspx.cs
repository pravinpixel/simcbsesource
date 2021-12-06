using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Data.SqlClient;

public partial class Staffs_StaffSearch : System.Web.UI.Page
{
    Utilities utl = null;
    private static int PageSize = 10;
    string sqlstr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        BindDummyRow();
        BindHdnValues();
        BndPlaceofwork();
        BindDepartment();
        BindDesignation();
        BindSubjectUpto();
        BindReligion();
        BindBloodGroup();
    }
    private void BindBloodGroup()
    {
        utl = new Utilities();
        sqlstr = "[sp_GetBloodGroup]";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlBloodGroup.DataSource = dt;
            ddlBloodGroup.DataTextField = "BloodGroupName";
            ddlBloodGroup.DataValueField = "BloodGroupID";
            ddlBloodGroup.DataBind();
        }
        else
        {
            ddlBloodGroup.DataSource = null;
            ddlBloodGroup.DataBind();
        }

        ddlBloodGroup.Items.Insert(0, new ListItem("--Select---", ""));
    }
    private void BindReligion()
    {
        utl = new Utilities();
        sqlstr = "sp_GetReligion";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlReligion.DataSource = dt;
            ddlReligion.DataTextField = "ReligionName";
            ddlReligion.DataValueField = "ReligionId";
            ddlReligion.DataBind();
        }
        else
        {
            ddlReligion.DataSource = null;
            ddlReligion.DataBind();
        }
        ddlReligion.Items.Insert(0, new ListItem("--Select---", ""));
    }
    private void BindDepartment()
    {
        utl = new Utilities();
        sqlstr = "[sp_GetDepartment]";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "DepartmentName";
            ddlDepartment.DataValueField = "DepartmentId";
            ddlDepartment.DataBind();         

        }
        else
        {
            ddlDepartment.DataSource = null;
            ddlDepartment.DataBind();            
        }

        ddlDepartment.Items.Insert(0, new ListItem("--Select---", ""));
       

    }

    private void BindDesignation()
    {
        utl = new Utilities();
        sqlstr = "sp_Getdesignation";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDesignation.DataSource = dt;
            ddlDesignation.DataTextField = "DesignationName";
            ddlDesignation.DataValueField = "DesignationId";
            ddlDesignation.DataBind();    

        }
        else
        {
            ddlDesignation.DataSource = null;
            ddlDesignation.DataBind();          
        }
        ddlDesignation.Items.Insert(0, new ListItem("--Select---", ""));
      
    }

    private void BindSubjectUpto()
    {
        utl = new Utilities();
        sqlstr = "[sp_GetSubExperience]";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {

            ddlSubject.DataSource = dt;
            ddlSubject.DataTextField = "SubExperienceName";
            ddlSubject.DataValueField = "SubExperienceId";
            ddlSubject.DataBind();

        }
        else
        {

            ddlSubject.DataSource = null;
            ddlSubject.DataBind();
        }
        ddlSubject.Items.Insert(0, new ListItem("--Select---", ""));
    }
    private void BndPlaceofwork()
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        ds = utl.GetDataset("sp_getplaceofwork ");
        if (ds.Tables[0].Rows.Count > 0)
        {
            ddlPlace.DataSource = ds.Tables[0];
            ddlPlace.DataTextField = "Placeofwork";
            ddlPlace.DataValueField = "PlaceofworkID";
            ddlPlace.DataBind();
        }
        else
        {
            ddlPlace.DataSource = null;
        }
        ddlPlace.Items.Insert(0, new ListItem("--Select---", ""));
    }
    private void BindHdnValues()
    {
        if (Request.QueryString["menuId"] != null)
            hdnContentMenuId.Value = Request.QueryString["menuId"].ToString();
        if (Request.QueryString["activeIndex"] != null)
            hdnContentActiveIndex.Value = Request.QueryString["activeIndex"].ToString();
        BindModuleMenuId();       
    }
    private void BindModuleMenuId()
    {
        if (Session["UserId"] != null)
        {
            string userId = Session["UserId"].ToString();
            string path = "Staffs/StaffInfo.aspx";
            string query = "sp_GetModuleMenuId'" + path + "'," + userId + "";

            Utilities utl = new Utilities();
            DataSet ds = new DataSet();
            ds = utl.GetDatasetTable(query, "ModuleMenusByPath");

            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                hdnContentMenuId.Value = ds.Tables[0].Rows[0]["menuid"].ToString();
                hdnContentModuleId.Value = ds.Tables[0].Rows[0]["modulemenuid"].ToString();
            }
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("SlNo");
            dummy.Columns.Add("EmpCode");
            dummy.Columns.Add("StaffName");
            dummy.Columns.Add("Designation");
            dummy.Columns.Add("Placeofwork");
            dummy.Columns.Add("StaffId");

            dummy.Rows.Add();
            dgStaffInfo.DataSource = dummy;
            dgStaffInfo.DataBind();
        }
    }
    
    
    [WebMethod]
    public static string GetStaffInfo(int index, string code, string name, string designation, string sex, string pNo, string emailId, string department, string presentstatus, string placeofwork, string bloodgroup, string religion, string subjecthandling)
    {
        Utilities utl = new Utilities();

        if (string.IsNullOrEmpty(code))code = "null";else code = "'" + code + "'";
        if (string.IsNullOrEmpty(name)) name = "null"; else name = "'" + name.Replace("'", "''") + "'";
        if (string.IsNullOrEmpty(designation)) designation = "null"; else designation = "'" + designation + "'";
        if (string.IsNullOrEmpty(sex)) sex = "null"; else sex = "'" + sex + "'";
        if (string.IsNullOrEmpty(pNo)) pNo = "null"; else pNo = "'" + pNo + "'";
        if (string.IsNullOrEmpty(emailId)) emailId = "null"; else emailId = "'" + emailId + "'";
        if (string.IsNullOrEmpty(department)) department = "null"; else department = "'" + department + "'";
        if (string.IsNullOrEmpty(presentstatus)) presentstatus = "null"; else presentstatus = "'" + presentstatus + "'";
        if (string.IsNullOrEmpty(placeofwork)) placeofwork = "null"; else placeofwork = "'" + placeofwork + "'";
        if (string.IsNullOrEmpty(bloodgroup)) bloodgroup = "null"; else bloodgroup = "'" + bloodgroup + "'";
        if (string.IsNullOrEmpty(religion)) religion = "null"; else religion = "'" + religion + "'";
        if (string.IsNullOrEmpty(subjecthandling)) subjecthandling = "null"; else subjecthandling = "'" + subjecthandling + "'";

        string query = "[GetStaffInfo_Pager] " + index + "," + PageSize + "," + 10 + "," + code + "," + name + "," + designation + "," + sex + "," + pNo + "," + emailId + "," + department + "," + presentstatus + "," + placeofwork + "," + bloodgroup + "," + religion + "," + subjecthandling + ",'" + HttpContext.Current.Session["AcademicID"] + "'";
        DataSet ds= utl.GetDatasetTable(query, "StaffInfo");
        DataTable dt = new DataTable("Pager");
        dt.Columns.Add("PageIndex");
        dt.Columns.Add("PageSize");
        dt.Columns.Add("RecordCount");
        dt.Rows.Add();
        dt.Rows[0]["PageIndex"] = index;
        dt.Rows[0]["PageSize"] = PageSize;
        dt.Rows[0]["RecordCount"] = ds.Tables[1].Rows[0][0];
        ds.Tables.Add(dt);
        return ds.GetXml();
    }
    
    [WebMethod]
    public static string GetEmployee(string staffName,string empCode)
    {
        Utilities utl = new Utilities();
        string query = "[sp_GetEmployee] '','" + staffName.Replace("'","''") + "','" + empCode + "'";
        DataSet ds = utl.GetDatasetTable(query, "Employee");
        return ds.GetXml();
    }
}