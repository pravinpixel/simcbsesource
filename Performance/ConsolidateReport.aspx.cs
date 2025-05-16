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
using System.Text;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html;
using iTextSharp.text.html.simpleparser;
using System.Drawing;
using System.ComponentModel;
using System.Drawing.Imaging;
using System.Web.SessionState;
using System.Web.UI.HtmlControls;

public partial class Reports_ConsolidateReport : System.Web.UI.Page
{   
    string strExamName = "";
    string strExamNameID = "";
    string strExamType = "";
    string strExamTypeID = "";
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    Utilities utl = null;
   
    public static int Userid = 0;
    public static int AcademicID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindClass();
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

    protected void BindSectionByClass()
    {
        utl = new Utilities();
        DataSet dsSection = new DataSet();
        ddlSection.DataSource = null;

        dsSection = utl.GetDataset("sp_GetSectionByClass " + ddlClass.SelectedValue);

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
        ddlSection.Items.Insert(0, "---Select---");
    }

    protected void Page_UnLoad(object sender, EventArgs e)
    {


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

    StringBuilder str = new StringBuilder();

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (Session["strClassID"] != null && Session["strClassID"].ToString() != "")
        {
            strClassID = Session["strClassID"].ToString();
        }

        if (Session["strSectionID"] != null && Session["strSectionID"].ToString() != "")
        {
            strSectionID = Session["strSectionID"].ToString();
        }
        if (Session["strClass"] != null && Session["strClass"].ToString() != "")
        {
            strClass = Session["strClass"].ToString();
        }

        if (Session["strSection"] != null && Session["strSection"].ToString() != "")
        {
            strSection = Session["strSection"].ToString();
        }
        if (Session["strExamNameID"] != null && Session["strExamNameID"].ToString() != "")
        {
            strExamNameID = Session["strExamNameID"].ToString();
        }

        if (ddlExamType.SelectedValue != null && ddlExamType.SelectedIndex != 0)
        {
            strExamTypeID = ddlExamType.SelectedValue;
        }
        if (Session["strExamName"] != null && Session["strExamName"].ToString() != "")
        {
            strExamName = Session["strExamName"].ToString();
        }
        if (Session["strExamType"] != null && Session["strExamType"].ToString() != "")
        {
            strExamType = Session["strExamType"].ToString();
        }
        if (strClass == "")
        {
            strClass = "All Classes";
        }
        if (strSection == "")
        {
            strSection = "All Sections";
        }
        if (strClassID != "")
        {
            DataTable DataTable1 = new DataTable();
            DataTable1 = utl.GetDataTable("SP_GetConsolidateReport " + "'" + strClassID + "','" + strSectionID + "','" + strExamNameID + "','" + strExamTypeID + "','" + ddlType.SelectedItem.Text + "','" + AcademicID + "'");
            if (DataTable1.Rows.Count > 0)
            {                

                DataTable dtSchool = new DataTable();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                str.Append("<br><table class='form' width='1000'><tr>");
                str.Append("<td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td><tr><tr><td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>CONSOLIDATED REPORT (STANDARD WISE)</td></tr><tr><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:15px;'>" + strExamName.ToString().ToUpper() + " -  " + strClass.ToString().ToUpper() + " Standard </td></tr></table>");


                Details_Pass();//over all Details of pass and fail for all subjects


                str.Append("<table class='performancedata'  border=1 cellspacing=5 cellpadding=10 width=100%><tr>");
                str.Append("<td align='left'><label>SL.NO.</label></td>");
                for (int i = 0; i < DataTable1.Columns.Count; i++)
                {
                    str.Append("<td align='left'><label>" + DataTable1.Columns[i].ColumnName.ToUpper().ToString() + "</label></td>");
                }
                str.Append(@"</tr>");

                for (int i = 0; i < DataTable1.Rows.Count; i++)
                {
                    str.Append(@"<tr><td>" + (i + 1).ToString() + "</td><td>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td><td>" + DataTable1.Rows[i]["StudentName"].ToString() + "</td><td>" + DataTable1.Rows[i]["ExamNo"].ToString() + "</td><td>" + DataTable1.Rows[i]["Class"].ToString() + "</td><td>" + DataTable1.Rows[i]["Section"].ToString() + "</td>");
                    for (int j = 5; j < DataTable1.Columns.Count; j++)
                    {
                        string mark = DataTable1.Rows[i]["" + DataTable1.Columns[j].ColumnName.ToUpper() + ""].ToString();
                        if (mark == "" || mark == null)
                        {
                            str.Append("<td align='center' style='color:red'>A</td>");
                        }
                        else
                        {
                            str.Append("<td align='center' style='color:black'>" + DataTable1.Rows[i]["" + DataTable1.Columns[j].ColumnName.ToUpper() + ""].ToString() + "</td>");
                        }
                      
                    }
                    str.Append(@"</tr>");
                }
               
                str.Append(@"</table>");
                dvCard.InnerHtml = str.ToString();
            }
            else
            {
                dvCard.InnerHtml = string.Empty;
            }
        }
    }

    //Details Will be displayed [Allpass,onepass,two pass,three pass]
    private void Details_Pass()
    {

        //overall Details -start
        DataSet dsGet = new DataSet();
        string sqlqry;
        int maxpasscount;
        int total = 0;
        int subjectcount = 0;

        string sql = "select COUNT(*)as subjectcount from p_classsubjects where ClassID='" + strClassID + "' and IsActive=1 and SubjectType='" + ddlType.SelectedItem.Text + "' and AcademicID='" + AcademicID + "'";
        subjectcount =Convert.ToInt32(utl.ExecuteScalar(sql));

        if (subjectcount > 0)
        {
            sqlqry = "SP_GetConsolidateReport_OVERALLDETAILS " + "'" + strClassID + "','" + strSectionID + "','" + strExamNameID + "','" + strExamTypeID + "','" + ddlType.SelectedItem.Text + "','" + AcademicID + "'";
            dsGet = utl.GetDataset(sqlqry);

            if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
            {              

                str.Append("<div style='float:left;padding-bottom:20px'><div style='float:left;margin-left:10px'><table class='performancedata'  border=1 cellspacing=5 cellpadding=10 width='100%'><tr><td><strong>SUBJECTS</strong></td><td><strong>NO OF STUDENTS</strong></td></tr>");


                for (int i = subjectcount; i >= 0; i--)
                {
                    if (i == subjectcount)
                    {
                        DataRow[] drAllpass = dsGet.Tables[0].Select("res =" + subjectcount + "");
                        str.Append("<tr><td>ALL PASS</td><td>" + drAllpass.Length.ToString() + "</td></tr>");
                        total += drAllpass.Length;
                    }
                    else
                    {
                        maxpasscount = subjectcount - i;
                        string word = utl.IntegerToWritten(maxpasscount);
                        DataRow[] drFailcount = dsGet.Tables[0].Select("res =" + i + "");

                        if (drFailcount.Length == 0)
                        {
                            str.Append("<tr><td>" + word.ToUpper() + " SUBJECT FAIL</td><td>NIL</td></tr>");
                        }

                        else
                        {
                            str.Append("<tr><td>" + word.ToUpper() + " SUBJECT FAIL</td><td>" + drFailcount.Length.ToString() + "</td></tr>");
                        }

                       
                        total += drFailcount.Length;
                    }
                }

                str.Append("<tr><td>TOTAL :</td><td>" + total.ToString() + "</td></tr>");

                str.Append("</table></div><div style='float:left;margin-left:10px'><table class='performancedata'  border=1 cellspacing=5 cellpadding=10 width='100%'><tr><td><strong>SUBJECTS</strong></td><td><strong>NO OF FAILURES</strong></td></tr>");

            }
        }

        //overall Details -End



        
        //Subject wise details-start

        DataSet dsGet1 = new DataSet();
        string sqlqry1;

        string subjectList = Disp_SubjectList();
        string[] SUBList = subjectList.Split(',');

        sqlqry1 = "SP_GetConsolidateReport_SUBJECTWISEFAIL_LIST " + "'" + strClassID + "','" + strSectionID + "','" + strExamNameID + "','" + strExamTypeID + "','" + ddlType.SelectedItem.Text + "','" + AcademicID + "'";

        dsGet1 = utl.GetDataset(sqlqry1);
        if (dsGet1 != null && dsGet1.Tables.Count > 0 && dsGet1.Tables[0].Rows.Count > 0)
        {
            foreach (string SUBListID in SUBList)
            {
               int drSubject = dsGet1.Tables[0].Select("res='0' and SubExperienceId='" + SUBListID + "' ").Length;
               string query = "select SubExperienceName from m_subexperiences where SubExperienceId =" + SUBListID + "";
               string subjectName = utl.ExecuteScalar(query);

               if (drSubject == 0)
               {
                   str.Append("<tr><td>" + subjectName + "</td><td>NIL</td></tr>");
               }
               else
               {
                   str.Append("<tr><td>" + subjectName + "</td><td>" + drSubject.ToString() + "</td></tr>");
               }

              
            }
                        
        }
        
        str.Append("</table></div></div>");

        //Subject wise details-end

        

    }

    
    private string Disp_SubjectList()
    {
        string SubjectListID = "";

        utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SP_GETLANGUAGELIST " + strClassID + ",'" + ddlType.SelectedItem.Text + "'," + AcademicID + "";
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

        return SubjectListID;
    }



    private void Page_Init(object sender, EventArgs e)
    {
        try
        {
            Master.chkUser();
            if (Session["UserId"] == null || Session["AcademicID"] == null)
            {
                Response.Redirect("Default.aspx?ses=expired");
            }
            else
            {
                AcademicID = Convert.ToInt32(Session["AcademicID"]);
                Userid = Convert.ToInt32(Session["UserId"]);

                if (!IsPostBack)
                {
                    Session["strClass"] = null;
                    Session["strSection"] = null;
                    Session["strClassID"] = null;
                    Session["strSectionID"] = null;
                    Session["strExamType"] = null;
                    Session["strExamTypeID"] = null;
                }
                ddlSection.DataSource = null;
                DataTable dt = new DataTable();
                utl = new Utilities();
                BindExamName();

            }
        }
        catch (Exception)
        {


        }
    }

    private void BindExamName()
    {
        utl = new Utilities();
        DataSet dsExam = new DataSet();
        dsExam = utl.GetDataset("sp_GetExamNameList" + "'','" + AcademicID + "'");
        if (dsExam != null && dsExam.Tables.Count > 0 && dsExam.Tables[0].Rows.Count > 0)
        {
            ddlExamName.DataSource = dsExam;
            ddlExamName.DataTextField = "ExamName";
            ddlExamName.DataValueField = "ExamNameID";
            ddlExamName.DataBind();
        }
        else
        {
            ddlExamName.DataSource = null;
            ddlExamName.DataTextField = "";
            ddlExamName.DataValueField = "";
            ddlExamName.DataBind();
        }
        ddlExamName.Items.Insert(0, "-----Select-----");
    }



    private void LoadImage(DataRow objDataRow, string strImageField, string FilePath)
    {
        try
        {
            FileStream fs = new FileStream(FilePath,
                       System.IO.FileMode.Open, System.IO.FileAccess.Read);
            byte[] Image = new byte[fs.Length];
            fs.Read(Image, 0, Convert.ToInt32(fs.Length));
            fs.Close();
            objDataRow[strImageField] = Image;
        }
        catch (Exception ex)
        {
            Response.Write("<font color=red>" + ex.Message + "</font>");
        }
    }
    private void LoadPath(DataRow objDataRow, string strImageField, string FilePath)
    {
        try
        {
            objDataRow[strImageField] = FilePath;
        }
        catch (Exception ex)
        {
            Response.Write("<font color=red>" + ex.Message + "</font>");
        }
    }
    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSectionByClass();
        if (ddlClass.SelectedItem.Text == "-----Select-----" || ddlClass.SelectedItem.Value == "-----Select-----")
        {
            strClass = "";
            strClassID = "";
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "";
            Session["strSectionID"] = "";

        }
        else
        {
            Session["strClass"] = ddlClass.SelectedItem.Text;
            Session["strClassID"] = ddlClass.SelectedValue;
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "";
            Session["strSectionID"] = "";

            BindExamType();
        }
    }
    protected void ddlSection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSection.SelectedItem.Text == "-----Select-----" || ddlSection.SelectedItem.Value == "-----Select-----")
        {
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "";
            Session["strSectionID"] = "";
        }
        else
        {
            Session["strSection"] = ddlSection.SelectedItem.Text;
            Session["strSectionID"] = ddlSection.SelectedValue;
        }
    }

    protected void ddlExamType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlExamType.SelectedItem.Text == "---Select---" || ddlExamType.SelectedItem.Value == "---Select---")
        {
            strExamType = "";
            strExamTypeID = "";
            Session["strExamType"] = "";
            Session["strExamTypeID"] = "";
        }
        else
        {
            Session["strExamType"] = ddlExamType.SelectedItem.Text;
            Session["strExamTypeID"] = ddlExamType.SelectedValue;
        }
        BindClass();
    }

    protected void ddlExamName_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlExamName.SelectedItem.Text == "-----Select-----" || ddlExamName.SelectedItem.Value == "-----Select-----")
        {
            strExamNameID = "";
            strExamName = "";
            Session["strExamName"] = "";
            Session["strExamNameID"] = "";
        }
        else
        {
            Session["strExamName"] = ddlExamName.SelectedItem.Text;
            Session["strExamNameID"] = ddlExamName.SelectedValue;
            BindExamType();
           
        }

      
    }
}