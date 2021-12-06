using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Students_StudentFee : System.Web.UI.Page
{
    Utilities utl = null;
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
            hdnUserId.Value = Session["UserId"].ToString();

            if (Session["AcademicID"] != null && Session["AcademicID"].ToString() != string.Empty)
            {
                hdnAcademicYearId.Value = Session["AcademicID"].ToString();
            }
            else
            {
                Utilities utl = new Utilities();
                hdnAcademicYearId.Value = utl.ExecuteScalar("select top 1 academicid from m_academicyear where isactive=1 order by academicid desc");
            }

            if (!IsPostBack)
            {

                BindDummyRow();
                BindClass();            

            }
        }
    }

    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("Register No");
            dummy.Columns.Add("Student Name");
            dummy.Columns.Add("Class");
            dummy.Columns.Add("Section");
            dummy.Columns.Add("Options");
            dummy.Rows.Add();
            grdPayStudList.DataSource = dummy;
            grdPayStudList.DataBind();
        }
    }

    protected void BindClass()
    {
        utl = new Utilities();
         DataTable dt = new DataTable();
        dt = utl.GetDataTable( "sp_GetClass");

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

    [WebMethod]
    public static string GetStudList(int pageIndex, string regNo, string Class, string Section, string studentName, string AcademicYearId, string FeeType)
    {
     
        Utilities utl = new Utilities();
          string query = string.Empty;

          string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
          string Isactive = utl.ExecuteScalar(sqlstr);
          HttpContext.Current.Session["Isactive"] = Isactive.ToString();         
          DataSet dsStud = new DataSet();
          if (Isactive == "True")
          {
              if (FeeType == "1")
                  query = "[sp_GetPayStudList]";
              else if (FeeType == "2")
                  query = "[sp_GetPayHostelStudList]"; 
          }
          else
          {
              if (FeeType == "1")
                  query = "[sp_GetOldPayStudList]";
              else if (FeeType == "2")
                  query = "[sp_GetOldPayHostelStudList]"; 
          }

       
        
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.AddWithValue("@regno", regNo);
        cmd.Parameters.AddWithValue("@classname", Class);
        cmd.Parameters.AddWithValue("@section", Section);
        cmd.Parameters.AddWithValue("@studentname", studentName);
        cmd.Parameters.AddWithValue("@AcademicYearId", AcademicYearId);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return utl.GetData(cmd, pageIndex, "PayStudList", PageSize).GetXml();

    }

    [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }
    [WebMethod]
    public static string GetModuleMenuId(string path, string UserId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModuleMenuId '" + path + "'," + UserId;
        return utl.GetDatasetTable(query, "ModuleMenu").GetXml();
    }

    
}