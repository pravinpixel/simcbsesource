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

public partial class Students_AdmissionApproval : System.Web.UI.Page
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
                hdnAcademicId.Value = Session["AcademicID"].ToString();
            }
            else
            {
                Utilities utl = new Utilities();
                hdnAcademicId.Value = utl.ExecuteScalar("select top 1 academicid from m_academicyear where isactive=1 order by academicid desc");
            }


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
        utl = new Utilities();
        DataTable dtAcademicYear = utl.GetDataTable("exec sp_getAdmissionBelongYear");
        if (dtAcademicYear != null && dtAcademicYear.Rows.Count > 0)
        {
            ListItem currentYear = new ListItem(dtAcademicYear.Rows[0]["currentacd"].ToString(), dtAcademicYear.Rows[0]["academicid"].ToString());
            currentYear.Selected = true;
            radlAcademicYear.Items.Add(currentYear);
            DataTable dt = new DataTable();
            dt = utl.GetDataTable("sELECT AcademicId+1 nextacd, convert(varchar(10),year(startdate)+1)+'-'+convert(varchar(10),year(enddate)+1) as Year   FROM m_academicyear where isactive='true'");
           if (dt!=null && dt.Rows.Count>0)
           {
               ListItem nextYear = new ListItem(dt.Rows[0]["Year"].ToString(), dt.Rows[0]["nextacd"].ToString());
               radlAcademicYear.Items.Add(nextYear);
               
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
            dummy.Rows.Add();
            grdAdmissionApproval.DataSource = dummy;
            grdAdmissionApproval.DataBind();
        }
    }

    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("exec sp_GetAdmissionApprovalClass");
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
    public static string GetAdmissionApprovalStudList(int pageIndex, string regNo, string Class, string studentName, string AcademicId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_GetAdmissionStudList]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@regno", regNo);
        cmd.Parameters.AddWithValue("@classname", Class);
        cmd.Parameters.AddWithValue("@studentname", studentName);
        cmd.Parameters.AddWithValue("@AcademicId", AcademicId);
        return utl.GetData(cmd, pageIndex, "AdmissionStudList", PageSize).GetXml();

    }

    [WebMethod]
    public static string GetAdmissionApprovalStudClassbySection(string regNo, string Classid)
    {

        Utilities utl = new Utilities();
        DataSet dsSection = new DataSet();
        StringBuilder strSection = new StringBuilder();
        SqlCommand cmd = new SqlCommand("sp_GetSectionByClass");

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@ClassId", Classid);
        dsSection = utl.GetDataset("exec sp_GetSectionByClass " + Classid);
        strSection.Append("<select id=\"" + regNo + "\" onchange=\"updateSection('" + regNo.Trim() + "','" + Classid + "');\"><option value=\"\">---Select---</option>");
        if (dsSection != null && dsSection.Tables.Count > 0 && dsSection.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsSection.Tables[0].Rows.Count; i++)
                strSection.Append("<option value=\"" + dsSection.Tables[0].Rows[i]["sectionid"].ToString() + "\">" + dsSection.Tables[0].Rows[i]["sectionname"].ToString() + "</option>");

        }
        strSection.Append("</select>");
        return strSection.ToString();
    }

    [WebMethod]
    public static string UpdateStudentSection(string regNo, string sectionId, string Classid, string AcademicYearId, int userId)
    {
        Utilities utl = new Utilities();

        string sqlstr = "select studentid from s_studentinfo where regno='" + regNo + "'";
        string studentid = utl.ExecuteScalar(sqlstr);
        string returnVal = "";
        if (studentid == regNo)
        {
            returnVal = utl.ExecuteScalar("exec sp_StudAdmissionApprovalNew " + regNo + "," + sectionId + "," + Classid + ",'" + AcademicYearId + "'," + userId);
        }
        else
        {
            returnVal = utl.ExecuteScalar("exec sp_StudAdmissionApproval " + regNo + "," + sectionId + "," + Classid + ",'" + AcademicYearId + "'," + userId);
        }
        string reg = returnVal;

        utl.ExecuteQuery("update f_studentbillmaster set refno=" + regNo + " and academicID='" + AcademicYearId + "' where regno=" + returnVal + "");

        returnVal = utl.ExecuteScalar("select 'The Approved Student Register no is : ' + CONVERT(varchar(max), RegNo) + ' and Admission no is :  ' + CONVERT(varchar(max), AdminNo) + ' ' from s_studentinfo where RegNo='" + reg + "'");
        if (returnVal=="")
        {
            return returnVal;
        }
        else
        {
            return returnVal;
        }       
    }
}