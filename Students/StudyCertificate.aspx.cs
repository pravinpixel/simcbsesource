using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Data.SqlClient;

public partial class Students_StudyCertificate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        BindDummyRow();
        if (Session["UserId"] != null)
            GetModuleId("Students/ViewStudyCertificate.aspx", Session["UserId"].ToString());
        BindClass();
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
           
            dummy.Columns.Add("Register No");
            dummy.Columns.Add("Admission No");
            dummy.Columns.Add("Student Name");
            dummy.Columns.Add("Class");
            dummy.Columns.Add("Section");
            dummy.Columns.Add("Option");

            DataRow dr = dummy.NewRow();
            dr["Student Name"] = "No Records Found";
            dummy.Rows.Add(dr);
            grdStudentSCInfo.DataSource = dummy;
            grdStudentSCInfo.DataBind();
        }
    }

    [WebMethod]
    public static string GetStudyCertificate(string Regno, string StName, string AdminNo, string Class, string Section,string pageIndex)
    {
        Utilities utl = new Utilities();

        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "[sp_GetStudyCertificate_Pager]";
        }
        else
        {
            query = "[sp_GetOldStudyCertificate_Pager]";
        }

       
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", Convert.ToInt32(pageIndex));
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@regno", Regno);
        cmd.Parameters.AddWithValue("@studentname", StName);
        cmd.Parameters.AddWithValue("@adminno", AdminNo);
        cmd.Parameters.AddWithValue("@classname", Class);
        cmd.Parameters.AddWithValue("@section", Section);
        cmd.Parameters.AddWithValue("@Academic", HttpContext.Current.Session["AcademicID"]);
        return utl.GetData(cmd, Convert.ToInt32(pageIndex), "StudyCertificate", 5).GetXml();
    }

    [WebMethod]
    public static string GetStudInfo(string Regno, string AdminNo, string name, string className, string section)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "[sp_GetStudentInfo] null, " + Regno + "," + AdminNo + ",'" + name + "','" + className + "','" + section + "'";
        }
        else
        {
            query = "[sp_GetOldStudentInfo] " + HttpContext.Current.Session["AcademicID"].ToString() + ", null, " + Regno + "," + AdminNo + ",'" + name + "','" + className + "','" + section + "'";
        }

        return utl.GetDatasetTable(query, "StudInfo").GetXml();
    }

    public void GetModuleId(string path, string userId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModuleMenuIdByPath '" + path + "'," + userId + "";
        ds = utl.GetDataset(query);
        if (ds != null && ds.Tables[0].Rows.Count > 0)
        {
            hdnViewTcMenu.Value= ds.Tables[0].Rows[0]["menuid"].ToString();
            hdnViewTcModuleMenu.Value = ds.Tables[0].Rows[0]["modulemenuid"].ToString();
        }
    }

    [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }

    private void BindClass()
    {
        Utilities utl = new Utilities();
        string sqlstr = "sp_GetClass";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlClass.DataSource = dt;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataBind();
            ddlClass.SelectedIndex = 0;

        }

    }
}