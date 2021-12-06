using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Data.SqlClient;

public partial class Students_ChangeofSection : System.Web.UI.Page
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
            if (!IsPostBack)
            {
                BindDummyRow();
                BindClass();
                BindAcademicYear();

            }
        }       
    }

    private void BindAcademicYear()
    {
        utl=new Utilities();
        DataTable dtAcademicYear=utl.GetDataTable("exec sp_getAdmissionBelongYear");
        if(dtAcademicYear!=null && dtAcademicYear.Rows.Count>0)
        {
            ListItem currentYear = new ListItem(dtAcademicYear.Rows[0]["currentacd"].ToString(), dtAcademicYear.Rows[0]["academicid"].ToString());
            currentYear.Selected = true;
            ListItem nextYear=new ListItem(dtAcademicYear.Rows[0]["nextacd"].ToString(),"new");
            radlAcademicYear.Items.Add(currentYear);
            radlAcademicYear.Items.Add(nextYear);
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
            dummy.Columns.Add("View");
            dummy.Rows.Add();
            grdChangeofSection.DataSource = dummy;
            grdChangeofSection.DataBind();

            dummy = new DataTable();
            dummy.Columns.Add("SlNo");
            dummy.Columns.Add("ClassName");
            dummy.Columns.Add("SectionName");
            dummy.Columns.Add("NoofStudents");
            dummy.Rows.Add();
            dgClass.DataSource = dummy;
            dgClass.DataBind();
        }
    }

    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("exec sp_GetChangeofSectionClass");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass.DataSource = dsClass;
            ddlClass.DataTextField = "class";
            ddlClass.DataValueField = "classid";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataTextField = "";
            ddlClass.DataValueField = "";
            ddlClass.DataBind();
        }
    }

     

 [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStudentCount " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }

    [WebMethod]
    public static string GetChangeofSectionStudList(int pageIndex, string regNo, string Class, string Section, string studentName)
    {
        Utilities utl = new Utilities();
        string query = "[sp_GetChangeofSectionStudList]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@regno", regNo);
        cmd.Parameters.AddWithValue("@classname", Class);
        cmd.Parameters.AddWithValue("@Sectionname", Section);
        cmd.Parameters.AddWithValue("@studentname", studentName);
        return utl.GetData(cmd, pageIndex, "ChangeofSectionStudList", PageSize).GetXml();       

    }

    [WebMethod]
    public static string GetChangeofSectionStudClassbySection(string regNo, string Classid)
    {
        
        Utilities utl = new Utilities();
        DataSet dsSection = new DataSet();
        StringBuilder strSection = new StringBuilder();
        SqlCommand cmd = new SqlCommand("sp_GetSectionByClass");
       
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@ClassId", Classid);
        dsSection = utl.GetDataset("exec sp_GetSectionByClass " + Classid);
        strSection.Append("<select id=\""+regNo+"\" onchange=\"updateSection('"+regNo.Trim()+"','"+Classid+"');\"><option value=\"\">---Select---</option>");
        if (dsSection != null && dsSection.Tables.Count > 0 && dsSection.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsSection.Tables[0].Rows.Count; i++)
                strSection.Append("<option value=\"" + dsSection.Tables[0].Rows[i]["sectionid"].ToString() + "\">" + dsSection.Tables[0].Rows[i]["sectionname"].ToString() + "</option>");

        }
        strSection.Append("</select>");
        return strSection.ToString(); ;
    }


    [WebMethod]
    public static string UpdateStudentSection(string regNo, string sectionId, string Classid, string AcademicYearId, int userId)
    {
        Utilities utl = new Utilities();

     
        string returnVal = utl.ExecuteQuery("exec sp_StudChangeofSection " + regNo + "," + sectionId + "," + Classid + ",'" + AcademicYearId + "'," + userId);
        if(returnVal =="")
                return "Updated";
        else
            return "Updated Failed";
    }
    

    
}