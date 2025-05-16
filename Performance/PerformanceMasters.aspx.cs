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
using System.Globalization;
using System.Drawing.Printing;
using System.Drawing;
using System.Text;

public partial class Performance_PerformanceMasters : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    public static int AcademicID = 0;
    public static string UserName = string.Empty;
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
            AcademicID = Convert.ToInt32(Session["AcademicID"]);
            hfAcademicID.Value = AcademicID.ToString();
            hfUserId.Value = Userid.ToString();
            if (!IsPostBack)
            {
                BindSchoolType();
                BindClass();
                BindSubjects();
                BindExamName();
                BindExamType();
                BindGrade();      
                BindDummyRow();
                BindSubjectMasters();
            }

        }
    }

    private void BindSubjectMasters()
    {
        utl = new Utilities();
        DataSet dsSubjects = new DataSet();
        dsSubjects = utl.GetDataset("sp_GetSubExperience");
        if (dsSubjects != null && dsSubjects.Tables.Count > 0 && dsSubjects.Tables[0].Rows.Count > 0)
        {
            ddlSubjects.DataSource = dsSubjects;
            ddlSubjects.DataTextField = "SubExperienceName";
            ddlSubjects.DataValueField = "SubExperienceID";
            ddlSubjects.DataBind();
        }
        else
        {
            ddlSubjects.DataSource = null;
            ddlSubjects.DataTextField = "";
            ddlSubjects.DataValueField = "";
            ddlSubjects.DataBind();
        }
    }
   
    private void BindGrade()
    {
        utl = new Utilities();
        DataSet dsGrade = new DataSet();
        dsGrade = utl.GetDataset("sp_GetGrade");
        if (dsGrade != null && dsGrade.Tables.Count > 0 && dsGrade.Tables[0].Rows.Count > 0)
        {
            ddlGrade.DataSource = dsGrade;
            ddlGrade.DataTextField = "GradeName";
            ddlGrade.DataValueField = "GradeID";
            ddlGrade.DataBind();
        }
        else
        {
            ddlGrade.DataSource = null;
            ddlGrade.DataTextField = "";
            ddlGrade.DataValueField = "";
            ddlGrade.DataBind();
        }
    }

  
    protected void BindExamType()
    {
        utl = new Utilities();
        DataSet dsExam = new DataSet();
        dsExam = utl.GetDataset("sp_GetExamType "+ "''"+ "," + AcademicID);
        if (dsExam != null && dsExam.Tables.Count > 0 && dsExam.Tables[0].Rows.Count > 0)
        {
            ddlExamType.DataSource = dsExam;
            ddlExamType.DataTextField = "ExamTypeName";
            ddlExamType.DataValueField = "ExamTypeID";
            ddlExamType.DataBind();
        }
        else
        {
            ddlExamType.DataSource = null;
            ddlExamType.DataTextField = "";
            ddlExamType.DataValueField = "";
            ddlExamType.DataBind();
        }
    }

    private void BindSchoolType()
    {
        utl = new Utilities();
        DataSet dsSchoolType = new DataSet();
        dsSchoolType = utl.GetDataset("sp_GetSchoolCategory");
        if (dsSchoolType != null && dsSchoolType.Tables.Count > 0 && dsSchoolType.Tables[0].Rows.Count > 0)
        {
            ddlSchoolType.DataSource = dsSchoolType;
            ddlSchoolType.DataTextField = "SchoolTypeName";
            ddlSchoolType.DataValueField = "SchoolTypeID";
            ddlSchoolType.DataBind();

            ddlSchType.DataSource = dsSchoolType;
            ddlSchType.DataTextField = "SchoolTypeName";
            ddlSchType.DataValueField = "SchoolTypeID";
            ddlSchType.DataBind();
        }
        else
        {
            ddlSchoolType.DataSource = null;
            ddlSchoolType.DataTextField = "";
            ddlSchoolType.DataValueField = "";
            ddlSchoolType.DataBind();

            ddlSchType.DataSource = null;
            ddlSchType.DataTextField = "";
            ddlSchType.DataValueField = "";
            ddlSchType.DataBind();
        }
    }

    [WebMethod]
    public static string GetClassSubjectID(string schooltypeid, string classid, string subjecttype, string subjects)
    {
        Utilities utl = new Utilities();
        string query = "GetClassSubjectID " + classid + "," + subjecttype + "," + subjects + ","+ AcademicID +"";
        return utl.GetDatasetTable(query, "GetClassSubjectID").GetXml();
    }

    [WebMethod]
    public static string GetClassBySchoolTypeID(int SchoolTypeID)
    {
        Utilities utl = new Utilities();
        string query = "sp_GetClassBySchoolType " + SchoolTypeID + "";
        return utl.GetDatasetTable(query, "ClassBySchoolType").GetXml();
    }
    protected string BindSubjects()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();

        dt = utl.GetDataTable("sp_GetSubExperience");
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                sb.Append("<div class=\"checkbox\"><input id=\"rd_" + dr["SubExperienceID"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkSubjects\" name=\"chkSubjects\" value=\"" + dr["SubExperienceID"].ToString() + "\" />");
                sb.Append("<label name=\"lblSubjects\" id=\"lbl_rd_" + dr["SubExperienceID"].ToString() + "\" for=\"rd_" + dr["SubExperienceID"].ToString() + "\">" + dr["SubExperienceName"].ToString() + "</label></div>");
            }

        }
        return sb.ToString();

    }

    protected void BindExamName()
    {
        utl = new Utilities();
        DataSet dsExam = new DataSet();
        dsExam = utl.GetDataset("sp_GetExamNameList  " + "''" + "," + AcademicID);
        if (dsExam != null && dsExam.Tables.Count > 0 && dsExam.Tables[0].Rows.Count > 0)
        {
            ddlExamNameID.DataSource = dsExam;
            ddlExamNameID.DataTextField = "ExamName";
            ddlExamNameID.DataValueField = "ExamNameID";
            ddlExamNameID.DataBind();
        }
        else
        {
            ddlExamNameID.DataSource = null;
            ddlExamNameID.DataTextField = "";
            ddlExamNameID.DataValueField = "";
            ddlExamNameID.DataBind();
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("RegNo");
            dummy.Columns.Add("StudentName");
            dummy.Columns.Add("DOB");
            dummy.Columns.Add("FatherName");
            dummy.Columns.Add("ExamNo");
            dummy.Rows.Add();
            dgStudentList.DataSource = dummy;
            dgStudentList.DataBind();

            dummy = new DataTable();
            dummy.Columns.Add("ExamTypeName");
            dummy.Columns.Add("ClassName");
            dummy.Columns.Add("ExamName");
            dummy.Columns.Add("Pattern");
            dummy.Columns.Add("ExamTypeID");
            dummy.Rows.Add();
            dgExamType.DataSource = dummy;
            dgExamType.DataBind();

            dummy = new DataTable();
            dummy.Columns.Add("ExamName");
            dummy.Columns.Add("Description");
            dummy.Columns.Add("StartDate");
            dummy.Columns.Add("EndDate");
            dummy.Columns.Add("ExamNameID");
            dummy.Rows.Add();
            dgExamName.DataSource = dummy;
            dgExamName.DataBind();

            dummy = new DataTable();
            dummy.Columns.Add("SchoolType");
            dummy.Columns.Add("Class");
            dummy.Columns.Add("SubjectType");
            dummy.Columns.Add("ClassSubjectName");
            dummy.Columns.Add("ClassSubjectID");
            dummy.Rows.Add();
            dgClassSubjects.DataSource = dummy;
            dgClassSubjects.DataBind();

            dummy = new DataTable();
            dummy.Columns.Add("ExamSetupID");
            dummy.Columns.Add("ClassSubjectID");
            dummy.Columns.Add("SubjectName");
            dummy.Columns.Add("MaxMark");
            dummy.Columns.Add("PassMark");
            dummy.Rows.Add();
            dgExamSetup.DataSource = dummy;
            dgExamSetup.DataBind();

            dummy = new DataTable();
            dummy.Columns.Add("GradeSetupID");
            dummy.Columns.Add("GradeName");
            dummy.Columns.Add("Pattern");
            dummy.Columns.Add("MarkFrom");
            dummy.Columns.Add("MarkTo");
            dummy.Rows.Add();
            dgGradeSetup.DataSource = dummy;
            dgGradeSetup.DataBind();

        }
    }
    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("sp_GetClass");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass.DataSource = dsClass;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataTextField = "";
            ddlClass.DataValueField = "";
            ddlClass.DataBind();
        }

        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass1.DataSource = dsClass;
            ddlClass1.DataTextField = "ClassName";
            ddlClass1.DataValueField = "ClassID";
            ddlClass1.DataBind();
        }
        else
        {
            ddlClass1.DataSource = null;
            ddlClass1.DataTextField = "";
            ddlClass1.DataValueField = "";
            ddlClass1.DataBind();
        }
         if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClassSearch.DataSource = dsClass;
            ddlClassSearch.DataTextField = "ClassName";
            ddlClassSearch.DataValueField = "ClassID";
            ddlClassSearch.DataBind();
        }
        else
        {
            ddlClassSearch.DataSource = null;
            ddlClassSearch.DataTextField = "";
            ddlClassSearch.DataValueField = "";
            ddlClassSearch.DataBind();
        }
         ddlClassSearch.Items.Insert(0, "---Select---");

         if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
         {
             ddlClassSearch1.DataSource = dsClass;
             ddlClassSearch1.DataTextField = "ClassName";
             ddlClassSearch1.DataValueField = "ClassID";
             ddlClassSearch1.DataBind();
         }
         else
         {
             ddlClassSearch1.DataSource = null;
             ddlClassSearch1.DataTextField = "";
             ddlClassSearch1.DataValueField = "";
             ddlClassSearch1.DataBind();
         }
         ddlClassSearch1.Items.Insert(0, "---Select---");
    }

    protected void BindSectionByClass()
    {
        utl = new Utilities();
        DataSet dsSection = new DataSet();
        if (ddlClass.SelectedValue != string.Empty)
            dsSection = utl.GetDataset("sp_GetSectionByClass " + ddlClass.SelectedValue);
        else
            ddlSection.Items.Clear();
        ddlSection.DataSource = null;
        ddlSection.AppendDataBoundItems = false;
        if (dsSection != null && dsSection.Tables.Count > 0 && dsSection.Tables[0].Rows.Count > 0)
        {
            ddlSection.DataSource = dsSection;
            ddlSection.DataTextField = "SectionName";
            ddlSection.DataValueField = "SectionID";
            ddlSection.DataBind();
        }
        else
        {
            ddlSection.DataSource = null;
            ddlSection.DataTextField = "";
            ddlSection.DataValueField = "";
            ddlSection.DataBind();
        }
        ddlSection.Items.Insert(0, new ListItem("-----Select-----", ""));
    }
    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSectionByClass();
        if (ddlClass.SelectedValue == string.Empty)
        {
            strClass = "";
            strClassID = "";
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "All Section";
            Session["strClass"] = "All Class";
        }
        else
        {
            Session["strClass"] = ddlClass.SelectedItem.Text;
            Session["strClassID"] = ddlClass.SelectedValue;
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "All Section";
            Session["strSectionID"] = "";

        }


    }
    protected void ddlSection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSection.SelectedItem.Value == string.Empty)
        {
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "All Section";
        }
        else
        {
            Session["strSection"] = ddlSection.SelectedItem.Text;
            Session["strSectionID"] = ddlSection.SelectedValue;
        }

    }

    [WebMethod]
    public static string BindClassByExamType(int ExamTypeID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_getexamtypes " + ExamTypeID + "," + AcademicID;
        return utl.GetDatasetTable(query, "ClassByExamType").GetXml();
    }
    [WebMethod]
    public static string EditExamType(int ExamTypeID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_getexamtypes " + ExamTypeID + "," + AcademicID;
        return utl.GetDatasetTable(query, "EditExamType").GetXml();
    }
    [WebMethod]
    public static string DeleteExamType(string ExamTypeID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteExamType " + "" + ExamTypeID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
    [WebMethod]
    public static string BindClassSubjects(int pageIndex, string ExamTypeID, string ClassID, string Type)
    {
        string query = "[BindClassSubjects_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.AddWithValue("@ExamTypeID", ExamTypeID);
        cmd.Parameters.AddWithValue("@ClassID", ClassID);
        cmd.Parameters.AddWithValue("@Type", Type);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@AcademicID", AcademicID);
        return GetClassSubjectsData(cmd, pageIndex).GetXml();
    }
    [WebMethod]
    public static string GetExamSetup(int pageIndex)
    {
        string query = "[BindExamSetup_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@AcademicID", AcademicID);
        return GetExamSetupData(cmd, pageIndex).GetXml();
    }
    [WebMethod]
    public static string GetExamType(int pageIndex,string ClassID)
    {
        Utilities utl = new Utilities();
        string query = "[GetExamType_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@AcademicID", AcademicID);
        cmd.Parameters.AddWithValue("@ClassID", ClassID);
        return GetData(cmd, pageIndex).GetXml();
    }
    public static DataSet GetData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "ExamTypes");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = ds.Tables[1].Rows[0][0];
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }
    public static DataSet GetExamSetupData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "ExamTypes");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }
    
    public static DataSet GetClassSubjectsData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "BindClassSubjects");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }
    [WebMethod]
    public static string GetStudentList(string classid, string sectionid)
    {
        Utilities utl = new Utilities();
        if (sectionid=="")
        {
            sectionid = "''";
        }
        string query = "[sp_GetPerformanceStudentList] '" + classid + "'," + sectionid + "," + AcademicID  + "";
        return utl.GetDatasetTable(query, "StudentList").GetXml();


    }
    [WebMethod]
    public static string SaveExamSetup(string ExamTypeID, string ClassSubjectID, string MaxMark, string PassMark, string query)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select count(*) from p_examsetup where ClassSubjectID='" + ClassSubjectID + "' and ExamTypeID='" + ExamTypeID + "' and AcademicID='" + AcademicID + "'";
        string iCount = utl.ExecuteScalar(sqlstr);
        if (iCount=="" || iCount=="0")
        {
            string queryStatus = utl.ExecuteQuery(query);
            if (queryStatus != string.Empty)
                return "failed";
            else
                return "Inserted";
        }
        else
        {
            sqlstr = "update p_examsetup set MaxMark='" + MaxMark + "' , PassMark='" + PassMark + "' where ClassSubjectID='" + ClassSubjectID + "' and ExamTypeID='" + ExamTypeID + "' and AcademicID='" + AcademicID + "'";
            string queryStatus = utl.ExecuteQuery(sqlstr);
            if (queryStatus != string.Empty)
                return "Update Failed";
            else
                return "Updated";
        }
     
       
    }
    [WebMethod]
    public static string UpdateExamNo(string query)
    {
        Utilities utl = new Utilities();
        string queryStatus = utl.ExecuteQuery(query);
        if (queryStatus != string.Empty)
            return "failed";
        else
            return "Updated";
    }
    [WebMethod]
    public static string SaveExamType(string ExamTypeID, string ExamType, string ClassID, string ExamNameID, string Pattern)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(ExamTypeID))
        {
            sqlstr = "select isnull(count(*),0) from p_examtypes where ExamTypeName='" + ExamType.Replace("'", "''") + "' and ClassID='" + ClassID + "'  and Pattern='" + Pattern + "'  and AcademicID='" + AcademicID + "' and ExamNameID!='" + ExamNameID + "'  and ExamTypeID!='" + ExamTypeID + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateExamType " + "'" + ExamTypeID + "','" + ExamType + "','" + ClassID + "','" + ExamNameID + "','" + Pattern + "','" + AcademicID + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Exists, Update";
            }
        }
        else
        {
            sqlstr = "select isnull(count(*),0) from p_examtypes where ExamTypeName='" + ExamType.Replace("'", "''") + "'  and ClassID='" + ClassID + "' and Pattern='" + Pattern + "'  and AcademicID='" + AcademicID + "' and ExamNameID!='" + ExamNameID + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertExamType " + "'" + ExamType + "','" + ClassID + "','" + ExamNameID + "','" + Pattern + "','" + AcademicID + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }


    [WebMethod]
    public static string GetExamName(int pageIndex)
    {
        string query = "[GetExamName_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@AcademicID", AcademicID);
        return GetExamNameData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditExamName(int ExamNameID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetExamNameList " + ExamNameID + "," + AcademicID;
        return utl.GetDatasetTable(query, "EditExamName").GetXml();
    }

    [WebMethod]
    public static string SaveExamName(string id, string name, string startdate, string enddate, string description)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        AcademicID = Convert.ToInt32(HttpContext.Current.Session["AcademicID"]);
        if (startdate != "")
        {
            string[] myDateTimeString = startdate.Split('/');
            startdate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (enddate != "")
        {
            string[] myDateTimeString = enddate.Split('/');
            enddate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from p_examnamelist where ExamName='" + name.Replace("'", "''") + "' and startdate=" + startdate + " and enddate=" + enddate + "  and AcademicID='" + AcademicID + "' and ExamNameid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateExamName " + "'" + id + "','" + name + "','" + description + "'," + startdate + "," + enddate + "," + AcademicID + "," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Exists, Update";
            }

        }
        else
        {
            sqlstr = "select isnull(count(*),0) from p_examnamelist where ExamName='" + name.Replace("'", "''") + "' and startdate=" + startdate + " and enddate=" + enddate + " and AcademicID='" + AcademicID + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertExamName " + "'" + name + "','" + description + "'," + startdate + "," + enddate + "," + AcademicID + "," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }
    [WebMethod]
    public static string DeleteExamName(string ExamNameID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteExamName " + "" + ExamNameID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
    public static DataSet GetExamNameData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "ExamNames");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }


    [WebMethod]
    public static string GetGradeSetup(int pageIndex)
    {
        string query = "[GetGradeSetup_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@AcademicID", AcademicID);
        return GetGradeSetupData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditGradeSetup(int GradeSetupID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetGradeSetup "  + GradeSetupID + "," + AcademicID;
        return utl.GetDatasetTable(query, "EditGradeSetup").GetXml();
    }

    [WebMethod]
    public static string SaveGradeSetup(string GradeSetupID, string GradeID, string Pattern, string MarkFrom, string MarkTo)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(GradeSetupID))
        {
            sqlstr = "select isnull(count(*),0) from p_GradeSetup where GradeID='" + GradeID + "' and Pattern='" + Pattern.Replace("'", "''") + "'  and MarkFrom='" + MarkFrom.Replace("'", "''") + "'  and MarkTo='" + MarkTo.Replace("'", "''") + "' and AcademicID='" + AcademicID + "' and GradeSetupid!='" + GradeSetupID + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateGradeSetup " + "'" + GradeSetupID + "','" + GradeID + "','" + Pattern + "','" + MarkFrom + "','" + MarkTo + "'," + AcademicID + "," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Exists, Update";
            }

        }
        else
        {
            sqlstr = "select isnull(count(*),0) from p_GradeSetup where GradeID='" + GradeID + "'  and Pattern='" + Pattern.Replace("'", "''") + "' and AcademicID='" + AcademicID + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertGradeSetup " + "'" + GradeID + "','" + Pattern + "','" + MarkFrom + "','" + MarkTo + "'," + AcademicID + "," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }
    [WebMethod]
    public static string DeleteGradeSetup(string GradeSetupID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteGradeSetup " + "" + GradeSetupID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
    public static DataSet GetGradeSetupData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "GradeSetups");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }


    [WebMethod]
    public static string GetClassSubject(string ClassID, string Type)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "GetClassSubjects " + ClassID + ",'" + Type + "'," + AcademicID + "";
        return utl.GetDatasetTable(query, "GetClassSubject").GetXml();
    }
    [WebMethod]
    public static string GetClassSubjects(int pageIndex,string ClassID)
    {
        string query = "[GetClassSubjects_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@AcademicID", AcademicID);
        cmd.Parameters.AddWithValue("@ClassID", ClassID);
        return GetClassData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditClassSubjects(int ClassSubjectID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetClassSubjects " + ClassSubjectID + "," + AcademicID;
        return utl.GetDatasetTable(query, "EditClassSubjects").GetXml();
    }

    [WebMethod]
    public static string SaveClassSubjects(string id, string schooltypeid, string classid, string subjecttype, string subjectid)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        subjectid = subjectid.Replace("|", "");

        sqlstr = "select isnull(count(*),0) from p_ClassSubjects where schooltypeid='" + schooltypeid.Replace("'", "''") + "' and classid='" + classid.Replace("'", "''") + "'  and subjecttype='" + subjecttype.Replace("'", "''") + "'   and AcademicID='" + AcademicID + "'  and subjectid='" + subjectid.Replace("'", "''") + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertClassSubjects " + "'" + schooltypeid + "','" + classid + "','" + subjecttype + "','" + subjectid + "'," + AcademicID + "," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
               
            }
            if (strQueryStatus == "")
                return "Inserted";
            else
                return "Insert Failed";
    }
    [WebMethod]
    public static string DeleteClassSubjects(string ClassSubjectID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteClassSubjects "  + ClassSubjectID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
    public static DataSet GetClassData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "ClassSubjects");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = ds.Tables[1].Rows[0][0];
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }
}