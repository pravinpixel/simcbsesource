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


public partial class Performance_CoScholasticReport : System.Web.UI.Page
{
    Utilities utl = null;
    Utilities utl1 = null;
    Utilities utl2 = null;

    PrintDocument printDoc = new PrintDocument();
    public static int Userid = 0;
    public static int AcademicID = 0;
    public static string UserName = string.Empty;
    private static int PageSize = 10;
    string sqlstr = "";
    string sqlstr1 = "";

    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";

    protected void Page_Load(object sender, EventArgs e)
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
            hfUserId.Value = Userid.ToString();

            if (!IsPostBack)
            {
                Session["strSection"] = "";
                Session["strSectionID"] = "";
                Session["strExamName"] = "";
                Session["strExamNameID"] = "";
                Session["strSubject"] = "";
                Session["strSubjectID"] = "";

                BindClass();
                BindExamName_List();

                utl = new Utilities();
                DataTable dtSchool = new DataTable();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            }
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
    }

    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSectionByClass();
        if (ddlClass.SelectedItem.Text == "---Select---" || ddlClass.SelectedItem.Value == "---Select---")
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

        }
    }

    protected string BindExamname()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();

        dt = utl.GetDataTable("sp_GetExamNameList  " + "''" + "," + AcademicID);
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                sb.Append("<div class=\"checkbox\"><input id=\"rd_" + dr["ExamNameID"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkSubjects\" name=\"chkSubjects\" value=\"" + dr["ExamNameID"].ToString() + "\" />");
                sb.Append("<label name=\"lblSubjects\" id=\"lbl_rd_" + dr["ExamNameID"].ToString() + "\" for=\"rd_" + dr["ExamNameID"].ToString() + "\">" + dr["ExamName"].ToString() + "</label></div>");
            }

        }
        return sb.ToString();
    }


    protected void BindSectionByClass()
    {
        utl = new Utilities();
        DataSet dsSection = new DataSet();
        dsSection = utl.GetDataset("sp_GetSectionByClass " + ddlClass.SelectedValue);
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
        ddlSection.Items.Insert(0, "---Select---");
    }



    protected void ddlSection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSection.SelectedItem.Text == "---Select---" || ddlSection.SelectedItem.Value == "---Select---")
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

    private void BindExamName_List()
    {
        string query = "sp_GetExamNameList " + "''" + "," + Session["AcademicID"] + "";

        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);
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
        }      
    }

    string SubjectListID = "";
    string CO_SubjectListID = "";
    string GA_SubjectListID = "";
    int CO_SUBListcount = 0;
    int GA_SUBListcount = 0;
                  
    private void Disp_SubjectList()
    {
        utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SP_GETLANGUAGELIST " + Convert.ToInt32(ddlClass.Text) + ",''," + AcademicID + "";
        ds = utl.GetDataset(query);

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {

                if (ds.Tables[0].Rows[i]["Type"].ToString() == "Co-Curricular Activities")
                {
                    if (CO_SubjectListID == "")
                    {
                        CO_SUBListcount += 1;
                        CO_SubjectListID = ds.Tables[0].Rows[i]["Subjectid"].ToString();
                    }

                    else
                    {
                        CO_SUBListcount += 1;
                        CO_SubjectListID = CO_SubjectListID + "," + ds.Tables[0].Rows[i]["Subjectid"].ToString();
                    }
                }

                else if (ds.Tables[0].Rows[i]["Type"].ToString() == "General Activities")
                {
                    if (GA_SubjectListID == "")
                    {
                        GA_SUBListcount += 1;
                        GA_SubjectListID = ds.Tables[0].Rows[i]["Subjectid"].ToString();
                    }

                    else
                    {
                        GA_SUBListcount += 1;
                        GA_SubjectListID = GA_SubjectListID + "," + ds.Tables[0].Rows[i]["Subjectid"].ToString();
                    }
                }

                //else
                //{
                //    if (SubjectListID == "")
                //    {
                //        SubjectListID = ds.Tables[0].Rows[i]["Subjectid"].ToString();
                //    }

                //    else
                //    {
                //        SubjectListID = SubjectListID + "," + ds.Tables[0].Rows[i]["Subjectid"].ToString();
                //    }
                //}

            }
        }
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            Disp_SubjectList();

            //LOAD_Totdays();
            LOAD_RESULT();
        }

        catch (Exception ex)
        {
            //Response.Write("<script>alert('"+ex.Message+"')</script>");
            ClientScript.RegisterClientScriptBlock(this.GetType(), "bnn", "<script>jAlert('" + ex.Message + "')</script>");
        }
    }


    //Main Search Function

    string stroption;
    StringBuilder dvContent = new StringBuilder();
    DataSet dsGet = new DataSet();
    string examnochk = string.Empty;
    
    private void LOAD_RESULT()
    {
        utl = new Utilities();

        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
       
        string examnochk = string.Empty;
        DataSet dsGet = new DataSet();

        string[] CO_SUBList = CO_SubjectListID.Split(',');
        string[] GA_SUBList = GA_SubjectListID.Split(',');

        int COlenth = (CO_SUBListcount * 2);
        int GAlenth = (GA_SUBListcount * 2);


        sqlstr = "sp_getCoScholasticReport '" + Session["strClassID"] + "','" + Session["strSectionID"] + "'," + "'" + ddlExamName.SelectedValue + "'" + "," + "''" + "," + AcademicID;
        dsGet = utl.GetDataset(sqlstr);

        dvContent.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
        dvContent.Append("<td align='center' colspan='3' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td width='15%' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>" + Session["strClass"].ToString().ToUpper() + " - " + Session["strSection"].ToString().ToUpper() + "</td><td align='center' style='font-family:Arial,padding-left: 17px; Helvetica, sans-serif; font-size:17px;'><b>CO-SCHOLASTIC REPORT</b></td></tr></table>");

        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><thead><tr><th colspan='4'>&nbsp;</th>");

            //Head Title CO-CURRICULAR ACTIVITIES Start
            if (COlenth > 0)
            {
                stroption += @"<th colspan='" + COlenth + "'><b>Co-Curricular Activities</b></th>";
            }

            else
            {
                // stroption += @"<th colspan='2'><b>Co-Curricular Activities</b></th>";
            }
            //Head Title CO-CURRICULAR ACTIVITIES End



            //Head Title General ACTIVITIES Start
            if (GAlenth > 0)
            {
                stroption += @"<th colspan='" + GAlenth + "'><b>General Activities</b></th>";                
            }

            else
            {
               // stroption += @"<th colspan='2'><b>General Activities</b></th>";
            }
            //Head Title General ACTIVITIES End   

         

            stroption += @"</tr></thead>";
            stroption += @"<tr><td>Sl No</td><td>Exam No</td><td>Reg No</td><td>Name of the student</td>";



            //Subject List for CO-CURRICULAR ACTIVITIES Start            
            if (COlenth > 0)
            {
                foreach (string COSubListID in CO_SUBList)
                {                    
                    sqlstr1 = "select SubExperienceName from m_subexperiences where SubExperienceId='" + COSubListID + "' and IsActive=1";
                    string SubjectName = utl.ExecuteScalar(sqlstr1);
                    stroption += @"<td colspan='2'>" + SubjectName + "</td>";
                }
            }

            else
            {
              //  stroption += @"<td colspan='2'>&nbsp;</td>";
            }
            //Subject List for CO-CURRICULAR ACTIVITIES End



            //Subject List for GENERAL ACTIVITIES Start
            if (GAlenth > 0)
            {
                foreach (string GASubListID in GA_SUBList)
                {                   
                    sqlstr1 = "select SubExperienceName from m_subexperiences where SubExperienceId='" + GASubListID + "' and IsActive=1";
                    string SubjectName = utl.ExecuteScalar(sqlstr1);
                    stroption += @"<td colspan='2'>" + SubjectName + "</td>";
                }
            }

            else
            {
               // stroption += @"<td colspan='2'>&nbsp;</td>";
            }
            //Subject List for GENERAL ACTIVITIES End



            stroption += @"<tr><td colspan='4'>&nbsp;</td>";



            //CO-CURRICULAR ACTIVITIES for Mark and Grade alignment purpose only Start
            if (COlenth > 0)
            {
                foreach (string COSubListID in CO_SUBList)
                {                   
                    stroption += @"<td>Mark</td><td>Grade</td>";
                }
            }

            else
            {
              //  stroption += @"<td>&nbsp;</td><td>&nbsp;</td>";
            }
            //CO-CURRICULAR ACTIVITIES for Mark and Grade alignment purpose only End



            //GENERAL ACTIVITIES for Mark and Grade alignment purpose only Start
            if (GAlenth > 0)
            {
                foreach (string GASubListID in GA_SUBList)
                {
                    
                    stroption += @"<td>Mark</td><td>Grade</td>";

                }
            }

            else
            {
              //  stroption += @"<td>&nbsp;</td><td>&nbsp;</td>";
            }
            //GENERAL ACTIVITIES for Mark and Grade alignment purpose only End


            stroption += @"</tr>";


            //Subject Mark and Grade List 
             int p = 0;

             for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
             {
                 if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                 {
                     p = p + 1;

                     stroption += @"<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td>";


                     //CO-CURRICULAR ACTIVITIES TD for Mark and Grade Start 
                     if (COlenth > 0)
                     {
                         foreach (string COSubListID in CO_SUBList)
                         {
                             DataRow[] drCOMark = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and SubExperienceid='" + COSubListID + "'");
                             if (drCOMark.Length > 0)
                             {
                                 string mark = drCOMark[0]["Mark"].ToString();
                                 if (mark=="A")
                                 {
                                     stroption += @"<td style='color:red'>A</td><td>NIL</td>";
                                 }
                                 else
                                 {
                                     sqlstr1 = "sp_getCalculateGrade " + "'Co-Curricular Activities'" + "," + Convert.ToDouble(drCOMark[0]["Mark"].ToString()) + "," + "'" + Session["AcademicID"].ToString() + "'"; 
                                     string Mark_Grade = utl.ExecuteScalar(sqlstr1);
                                     stroption += @"<td  style='color:black'>" + drCOMark[0]["Mark"].ToString() + "</td><td>" + Mark_Grade + "</td>";
                                 }
                                

                                
                             }

                             else
                             {
                                 stroption += @"<td>&nbsp;</td><td>&nbsp;</td>";
                             }

                         }
                     }

                     else
                     {
                        // stroption += @"<td>&nbsp;</td><td>&nbsp;</td>";
                     }
                     //CO-CURRICULAR ACTIVITIES TD for Mark and Grade End


                     //GENERAL ACTIVITIES TD for Mark and Grade Start
                     if (GAlenth > 0)
                     {
                         foreach (string GASubListID in GA_SUBList)
                         {   
                             DataRow[] drGAMark = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and SubExperienceid='" + GASubListID + "'");
                             if (drGAMark.Length > 0)
                             {

                                 string mark = drGAMark[0]["Mark"].ToString();
                                 if (mark == "A")
                                 {
                                     stroption += @"<td style='color:red'>A</td><td>NIL</td>";
                                 }
                                 else
                                 {
                                     sqlstr1 = "sp_getCalculateGrade " + "'General Activities'" + "," + Convert.ToDouble(drGAMark[0]["Mark"].ToString()) + "," + "'" + Session["AcademicID"].ToString() + "'"; 
                                     string Mark_Grade = utl.ExecuteScalar(sqlstr1);
                                     stroption += @"<td  style='color:black'>" + drGAMark[0]["Mark"].ToString() + "</td><td>" + Mark_Grade + "</td>";
                                 }
                                  
                             }

                             else
                             {
                                 stroption += @"<td>&nbsp;</td><td>&nbsp;</td>";
                             }

                         }
                     }

                     else
                     {
                        // stroption += @"<td>&nbsp;</td><td>&nbsp;</td>";
                     }

                     //GENERAL ACTIVITIES TD for Mark and Grade End


                     stroption += @"</tr>";
                     examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                 }
             }

             stroption += @"</table>";
             dvContent.Append(stroption);
        }

        dvCard.InnerHtml = dvContent.ToString();
    }



    int totdays;
    private void LOAD_Totdays()
    {
        utl2 = new Utilities();
        string sql;

        sql = "select SUM(convert(int,noofdays))as Totaldays from m_DaysinMonths where AcademicID='" + AcademicID + "' ";
        totdays = Convert.ToInt32(utl2.ExecuteScalar(sql));
    }
}