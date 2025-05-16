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
using System.IO;
using Microsoft.Reporting.WebForms;
using System.Drawing.Printing;
using System.Drawing.Imaging;
using System.Text;
using System.Xml.Serialization;


public partial class Performance_MarkEntry : System.Web.UI.Page
{
    Utilities utl = null;
    Utilities utl1 = null;
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
                               
            hfUserId.Value = Userid.ToString();
            if (!IsPostBack)
            {
                BindExamNames();
                BindClass();
            }

        }
    }

    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        ddlClass.Items.Clear();
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
        ddlClass.Items.Insert(0, "---Select---");
    }

    protected void BindClassByExamType()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("sp_GetClassByExamType " + ""+ ddlExamType.SelectedValue +","+ AcademicID +"");
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
        ddlClass.Items.Insert(0, "---Select---");
    }


    private void BindExamNames()
    {
        Utilities utl = new Utilities();
        string sqlstr = "SP_GETExamNameList " + "'','"+ AcademicID +"'";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlExamName.DataSource = dt;
            ddlExamName.DataTextField = "ExamName";
            ddlExamName.DataValueField = "ExamNameID";
            ddlExamName.DataBind();
        }
        else
        {
            ddlExamName.DataSource = null;
            ddlExamName.DataBind();
            ddlExamName.SelectedIndex = 0;
        }
    }

    private void BindExamType()
    {
        if (ddlExamName.SelectedItem.Text == "-----Select-----" || ddlExamName.SelectedItem.Value == "-----Select-----" || ddlClass.SelectedItem.Text == "---Select---" || ddlClass.SelectedItem.Value == "---Select---")
        {
            // ddlExamType.Items.Insert(0, "---Select---");
        }

        else
        {
            utl = new Utilities();
            DataSet dsExam = new DataSet();
            ddlExamType.Items.Clear();
            string sqlstr = "[sp_GetExamTypeByExamName_Filter] " + "'" + ddlExamName.SelectedValue + "','" + ddlClass.SelectedValue + "','" + AcademicID + "'";
            dsExam = utl.GetDataset(sqlstr);
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
            ddlExamType.Items.Insert(0, "---Select---");
        }
    }

    protected void ddlExamName_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlExamName.SelectedItem.Text == "-----Select-----" || ddlExamName.SelectedItem.Value == "-----Select-----")
        {           
            Session["strExamName"] = "";
            Session["strExamNameID"] = "";
        }
        else
        {
            Session["strExamName"] = ddlExamName.SelectedItem.Text;
            Session["strExamNameID"] = ddlExamName.SelectedValue;
            BindExamType();
        }

        //Utilities utl = new Utilities();
        //string sqlstr = "[sp_GetExamNameByType] " + "'" + ddlExamName.SelectedValue + "','" + AcademicID + "'";
        //DataTable dt = new DataTable();
        //dt = utl.GetDataTable(sqlstr);
        //ddlExamType.Items.Clear();
        //if (dt != null && dt.Rows.Count > 0)
        //{
        //    ddlExamType.DataSource = dt;
        //    ddlExamType.DataTextField = "ExamTypeName";
        //    ddlExamType.DataValueField = "ExamTypeID";
        //    ddlExamType.DataBind();
        //    ddlExamName.Focus();
        //}
        //else
        //{
        //    ddlExamType.DataSource = null;
        //    ddlExamType.DataBind();
        //    ddlExamType.SelectedIndex = -1;
        //}
        //ddlExamType.Items.Insert(0, "---Select---");
    }
   
          
    public static string ToXml(DataSet ds)
    {
        using (var memoryStream = new MemoryStream())
        {
            using (TextWriter streamWriter = new StreamWriter(memoryStream))
            {
                var xmlSerializer = new XmlSerializer(typeof(DataSet));
                xmlSerializer.Serialize(streamWriter, ds);
                return Encoding.UTF8.GetString(memoryStream.ToArray());
            }
        }
    }

    public class MarkList
    {
        public string examId { get; set; }
        public string type { get; set; }
        public string classID { get; set; }
        public string sectionId { get; set; }
        public string regNo { get; set; }
        public string subId { get; set; }
        public string marks { get; set; }
        public string academicId { get; set; }
        public string userId { get; set; }
    }

   
    string SubjectListID = "";
    private void Disp_SubjectList()
    {
        utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SP_GETLANGUAGELIST " + Convert.ToInt32(ddlClass.Text) + ",'" + ddlType.Text + "','" + AcademicID + "'";
        ds = utl.GetDataset(query);

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (SubjectListID == "")
                {
                    SubjectListID = ds.Tables[0].Rows[i]["Subjectid"].ToString();
                }

                else
                {
                    SubjectListID = SubjectListID + "," + ds.Tables[0].Rows[i]["Subjectid"].ToString();
                }
            }
        }
    }


    int markfrom;
    int markto;

    private bool validate()
    {
        bool chk = true;
        //if (ddlSubjects.Text == " ")
        //{
        //  ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Select Subject Name','info');</script>", false);
        //  chk = false;
        //}

        if (txtMarkFrom.Text != string.Empty)
        {
            try
            {
                markfrom = Convert.ToInt32(txtMarkFrom.Text);
            }
            catch (Exception ex)
            {
              ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Enter Valid Mark','info');</script>", false);
              chk = false;
            }
        }

        if (txtMarkTo.Text != string.Empty)
        {
            try
            {
                markto = Convert.ToInt32(txtMarkTo.Text);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Enter Valid Mark','info');</script>", false);
                chk = false;
            }
        }


        return chk;
    }


   
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            
                if (txtMarkFrom.Text != string.Empty && txtMarkTo.Text != string.Empty)
                {
                    if (validate())
                    {
                        if (ddlSubjects.Text == " ")
                        {
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Select Subject Name','info');</script>", false);
                        }

                        else
                        {
                            RESULT_LOAD_SUBJECTWISE(); //Subjectwise Mark Load
                        }
                    }
                }
                else
                {
                    if (ddlSubjects.Text != " ")
                    {
                        markfrom = 0;
                        markto = 2000;
                        RESULT_LOAD_SUBJECTWISE(); //Subjectwise Mark Load
                    }
                    else
                    {
                        markfrom = 0;
                        markto = 2000;
                        RESULT_LOAD();
                    }
                }
            

        }

        catch (Exception ex)
        {
           // Response.Write("<script>alert('"+ex.Message+"')</script>");
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('"+ex.Message+"','info');</script>", false);
        }
    }

    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        Utilities utl = new Utilities();
        string query = "sp_GetSectionByClass " + ddlClass.SelectedValue;
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);

        ddlSection.Items.Clear();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSection.DataSource = dt;
            ddlSection.DataTextField = "SectionName";
            ddlSection.DataValueField = "SectionID";
            ddlSection.DataBind();
            ddlClass.Focus();
        }
        else
        {
            ddlSection.DataSource = null;
            ddlSection.DataBind();
            ddlSection.SelectedIndex = -1;
        }

        BindExamType();
    }

    string stroption;
    private void RESULT_LOAD()
    {
        string Result = txtMarkFrom.Text + "-" + txtMarkTo.Text;       
        utl = new Utilities();

        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());

        DataSet dsGet = new DataSet();


        sqlstr = "SP_MarklistReport " + ddlClass.SelectedValue + "," + ddlSection.SelectedValue + "," + "'" + ddlExamType.SelectedValue + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + AcademicID + "," + markfrom + "," + markto;

        dsGet = utl.GetDataset(sqlstr);
        StringBuilder dvContent = new StringBuilder();

        dvContent.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
        dvContent.Append("<td align='center' colspan='3' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td width='25%' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>Class - Section :" + ddlClass.SelectedItem.Text + " - " + ddlSection.SelectedItem.Text + "</td><td align='center'  style='font-family:Arial,padding-left: 17px; Helvetica, sans-serif; font-size:17px;'>" + ddlExamType.SelectedItem.Text + "<b> - MARK LIST</b></td><td width='25%'></td><td style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'> Total Range (" + Result + " )</td></tr></table>");


        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%>");
            stroption += @"<thead><tr><th>RegNo</th> <th>Student Name</th><th>Exam No</th>";

            utl1 = new Utilities();
            DataSet ds = new DataSet();
            string query = "SP_GETLANGUAGELIST " + Convert.ToInt32(ddlClass.SelectedValue) + ",'" + ddlType.SelectedItem.Text + "','" + AcademicID + "'";
            ds = utl1.GetDataset(query);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    stroption += @"<th><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></th>";
                }
            }

            stroption += @"<th>Total Marks</th></tr></thead>";



            if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                {

                    stroption += @"<tr><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td>";

                    for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                    {
                        if (dsGet.Tables[0].Rows[i][j + 3].ToString() == "")
                        {
                            stroption += @"<td align='center' style='color:red'>A</td>";
                        }
                        else
                        {
                            stroption += @"<td align='center'>" + dsGet.Tables[0].Rows[i][j + 3].ToString() + "</td>";
                        }
                    }

                    stroption += @"<td align='center'>" + dsGet.Tables[0].Rows[i][ds.Tables[0].Rows.Count + 3].ToString() + "</td>";

                    stroption += @"</tr>";

                    //stroption += @"<tr><td>" + dsGet.Tables[0].Rows[i][0].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i][1].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td>";

                }
            }

            stroption += @"</table>";
            dvContent.Append(stroption);

        }
        dvCard.InnerHtml = dvContent.ToString();

    }


    private void RESULT_LOAD_SUBJECTWISE()
    {
        string Result = txtMarkFrom.Text + "-" + txtMarkTo.Text;       
        utl = new Utilities();

        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());

        DataSet dsGet = new DataSet();

        sqlstr = "SP_MarklistReportSubjectwise " + ddlClass.SelectedValue + "," + ddlSection.SelectedValue + "," + "'" + ddlExamName.SelectedValue + "'" + "," + "'" + ddlExamType.SelectedValue + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + ddlSubjects.SelectedValue + "'" + "," + AcademicID + "," + markfrom + "," + markto;


        dsGet = utl.GetDataset(sqlstr);
        StringBuilder dvContent = new StringBuilder();

        dvContent.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
        dvContent.Append("<td align='center' colspan='3' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td width='25%' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>Class - Section :" + ddlClass.SelectedItem.Text + " - " + ddlSection.SelectedItem.Text + "</td><td align='center'  style='font-family:Arial,padding-left: 17px; Helvetica, sans-serif; font-size:17px;'>" + ddlExamType.SelectedItem.Text + "<b> - MARK LIST</b></td><td width='25%'></td><td style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'> Mark Range (" + Result + " )</td></tr></table>");


        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%>");
            stroption += @"<thead><tr><th>RegNo</th><th>Exam No</th><th>Student Name</th><th>" + ddlSubjects.SelectedItem.Text + "</th></tr></thead>";


            if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                {
                    if (dsGet.Tables[0].Rows[i]["Mark"].ToString() == "A")
                    {
                        stroption += @"<tr><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td align='center' style='color:red'>" + dsGet.Tables[0].Rows[i]["Mark"].ToString() + "</td></tr>";
                    }
                    else
                    {
                        stroption += @"<tr><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td align='center'>" + dsGet.Tables[0].Rows[i]["Mark"].ToString() + "</td></tr>";
                    }

                }
            }
            stroption += @"</table>";
            dvContent.Append(stroption);
        }

        dvCard.InnerHtml = dvContent.ToString();

    }


    //protected void ddlExamType_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    BindClassByExamType();
    //}

    protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
    {
        Utilities utl = new Utilities();
        string query = "SP_GETLANGUAGELIST " + Convert.ToInt32(ddlClass.SelectedValue) + ",'" + ddlType.SelectedItem.Text + "','" + AcademicID + "'";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);
        ddlSubjects.Items.Clear();
        ddlSubjects.Items.Add(new ListItem("-----Select-----", " "));
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSubjects.DataSource = dt;
            ddlSubjects.DataTextField = "SubjectName";
            ddlSubjects.DataValueField = "SubjectId";
            ddlSubjects.DataBind();           
        }
        else
        {
            ddlSubjects.DataSource = null;
            ddlSubjects.DataBind();
            ddlSubjects.SelectedIndex = -1;
        }
        //ddlSubjects.Items.Insert(0, "---Select---");
    }           

}