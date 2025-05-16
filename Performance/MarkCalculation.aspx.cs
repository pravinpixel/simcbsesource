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

public partial class Performance_MarkCalculation : System.Web.UI.Page
{
    string  strSubject = "";
    string strSubjectID = "";
    string strExamName = "";
    string strExamNameID = "";
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    Utilities utl = null;
    string sqlstr = "";
    string sqlstr1 = "";
    public static int Userid = 0;
    public static int AcademicID = 0;
    public static string UserName = string.Empty;
    private static int PageSize = 10;
    PrintDocument printDoc = new PrintDocument();
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
                BindSubjects();
                BindClass();
                BindExamName();

                utl = new Utilities();
                DataTable dtSchool = new DataTable();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
                string ExamName = "";
                if (ddlExamName.SelectedItem != null && ddlExamName.SelectedItem.Text != "---Select---")
                {
                    ExamName = ddlExamName.SelectedItem.Text;
                }
                string Subject = "";
                if (ddlSubjects.SelectedItem != null && ddlSubjects.SelectedItem.Text != "---Select---")
                {
                    Subject = ddlSubjects.SelectedItem.Text;
                }              
            }

        }
    }

    private void BindSubjects()
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
    private void BindExamName()
    {
        utl = new Utilities();
        DataSet dsExam = new DataSet();
        dsExam = utl.GetDataset("sp_GetExamNameList " + "''" + "," + Session["AcademicID"] + "");
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
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            LOAD();
        }

        catch (Exception ex)
        {
            Response.Write("<script>alert('"+ex.Message+"')</script>");
        }
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

    

    //Marks Table Creation [New Function]

    int chk = 0;
    string strOptions = string.Empty;

    private void LOAD()
    {
        utl = new Utilities();
        
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        string ExamName = "";
        if (ddlExamName.SelectedItem != null && ddlExamName.SelectedItem.Text != "---Select---")
        {
            ExamName = ddlExamName.SelectedItem.Text;
        }
        string Subject = "";
        if (ddlSubjects.SelectedItem != null && ddlSubjects.SelectedItem.Text != "---Select---")
        {
            Subject = ddlSubjects.SelectedItem.Text;
        }
        

        string strFA = string.Empty;
        string strFB = string.Empty;
        string strNone = string.Empty;
        string strFAFBTotal = string.Empty;
        string strSA = string.Empty;
        DataSet dsGet = new DataSet();

        //sqlstr = "sp_getCalculateMarks " + 3 + "," + 27 + "," + 1 + "," + "'Samacheer'" + "," + 1 + "," + 1;
        //dsGet = utl.GetDataset(sqlstr);

        if ((Session["strClassID"] != null && Session["strSectionID"] != null) && (Session["strClassID"].ToString() != "" && Session["strSectionID"].ToString() != ""))
        {
            sqlstr = "sp_getCalculateMarks '" + Session["strClassID"] + "','" + Session["strSectionID"] + "','" + Session["strExamNameID"] + "'," + "'" + ddlType.SelectedItem.Text + "'" + ",'" + Session["strSubjectID"] + "'," + AcademicID;

            dsGet = utl.GetDataset(sqlstr);
        }


        StringBuilder dvContent = new StringBuilder();

        //DataSet ds = new DataSet();
      
        //dtSchool = utl.GetDataTable("exec sp_schoolDetails");

        dvContent.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
        dvContent.Append("<td align='center' colspan='3' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td width='25%' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>" + Session["strClass"].ToString().ToUpper() + " - " + Session["strSection"].ToString().ToUpper() + "</td><td align='center'  style='font-family:Arial,padding-left: 17px; Helvetica, sans-serif; font-size:17px;'>" + Session["strExamName"] + " - MARKLIST</td><td  width='25%' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;padding-right: 27px;text-align: right;'>Subject : " + Session["strSubject"] + "</td></tr></table>");


        if (dsGet != null && dsGet.Tables.Count>0 && dsGet.Tables[0].Rows.Count > 0)
        {
            dvContent.Append(@"<table class='performancedata'  border=1 cellspacing=5 cellpadding=10 width=100%>");

            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {
                  double FATOT = 0;
                  double FBTOT =0;
                  double SATOT = 0;
                  int strFAFBTotal1 = 0;
                  string strTotal = "";

                  if (chk == 0)
                  {
                      chk = 1;

                      DataRow[] drNone = dsGet.Tables[0].Select("Pattern='None' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                      if (drNone.Length > 0)
                      {
                          strNone += @"<tr><td width=90><b>Sl. No.</b></td><td width=90><b>Exam. No</b></td><td width=175><b>Student Name</b></td><td width=175><b>Exam Type</b></td><td width=142 style='vertical-align: top; text-align: center;'><b>Max Mark</b></td><td width=75 style='vertical-align: top;text-align: center;'><b>Pass Mark</b></td><td width=142 style='vertical-align: top;text-align: center;'><b>Scored Mark</b></td><td width=142 style='vertical-align: top;text-align: center;'><b>Grade</b></td>";

                          strOptions += strNone;

                          DISPLAY();
                      }

                      else
                      {
                          DataRow[] drFA = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                          if (drFA.Length > 0)
                          {
                              //strFA += @"<tr><td>gfhgf</td></tr></table></body></html>";


                              strFA += @"<tr><td width=90 rowspan=2><b>Sl. No.</b></td><td width=90 rowspan=2><b>Exam. No</b></td><td width=175 rowspan=2><b>Student Name</b></td><td width=142 style='vertical-align: top; text-align: center;' colspan=" + drFA.Length + "><b>" + drFA[0]["Pattern"].ToString() + "</b></td><td width=75 style='vertical-align: top;text-align: center;'><b>" + drFA[0]["Pattern"].ToString() + "</b><br/><b>Total</b></td>";

                              if (drFA[0]["PassMarkTotal"].ToString() != "")
                              {
                                  FATOT = Convert.ToDouble(drFA[0]["PassMarkTotal"].ToString());
                              }

                          }

                          DataRow[] drFb = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                          if (drFb.Length > 0)
                          {

                              strFB += @"<td width=142 style='vertical-align: top; text-align: center;' colspan=" + drFb.Length + "><b>" + drFb[0]["Pattern"].ToString() + "</b></td><td width=75 style='vertical-align: top;text-align: center;'><b>" + drFb[0]["Pattern"].ToString() + "</b><br/><b>Total</b><br/></td>";
                              if (drFb[0]["PassMarkTotal"].ToString() != "")
                              {
                                  FBTOT = Convert.ToDouble(drFb[0]["PassMarkTotal"].ToString());
                              }


                          }

                          // strFAFBTotal = Convert.ToString(Convert.ToDouble(drFA[0]["PassMarkTotal"].ToString()) + (drFb[0]["PassMarkTotal"].ToString()));


                          int FABTotal = 0;
                          FABTotal = Convert.ToInt32(Math.Ceiling(FATOT + FBTOT));
                          strFAFBTotal = Convert.ToString(FABTotal);

                          strOptions = strFA + strFB + "<td width=35 style='vertical-align: top;text-align: center;'><b>FA</b><br/><b>Total</b></td>";

                          DataRow[] drSA = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                          if (drSA.Length > 0)
                          {

                              strSA += @"<td width=36 style='vertical-align: top;text-align: center;'><b>SA</b><br/><b>Marks</b></td>";
                              if (drSA[0]["PassMarkTotal"].ToString() != "")
                              {
                                  SATOT = Convert.ToDouble(drSA[0]["PassMarkTotal"].ToString());
                              }

                          }
                          strOptions += strSA;

                          //string strTotal = Convert.ToString(Convert.ToDouble(drSA[0]["PassMarkTotal"].ToString()) + (strFAFBTotal));


                          strFAFBTotal1 = Convert.ToInt32(strFAFBTotal);
                          strTotal = Convert.ToString(SATOT + strFAFBTotal1);

                          strOptions += "<td width=35 style='vertical-align: top;text-align: center;'><b>Total</b><br/><b>Marks</b></td><td width=36 style='vertical-align: top;text-align: center;'><b>FA</b><br/><b>Grade</b></p></td><td width=35 style='vertical-align: top;text-align: center;'><b>SA</b><br/><b>Grade</b></td><td width=35 style='vertical-align: top;text-align: center;'><b>Overall</b><br/><b>Grade</b></td></tr><tr>";


                          for (int p = 0; p < drFA.Length; p++)
                          {
                              strOptions += "<td width=35><p align=center><b>" + drFA[p]["PassMark"].ToString() + "</b></p></td>";
                          }

                          strOptions += "<td width=35><p align=center><b>" + FATOT + "</b></p></td>";

                          for (int q = 0; q < drFb.Length; q++)
                          {
                              strOptions += "<td width=35><p align=center><b>" + drFb[q]["PassMark"].ToString() + "</b></p></td>";
                          }

                          strOptions += "<td width=35><p align=center><b>" + FBTOT + "</b></p></td>";

                          strOptions += "<td width=35><p align=center><b>" + strFAFBTotal + "</b></p></td>";

                          if (drSA.Length > 0)
                          {

                              strOptions += "<td width=35><p align=center><b>" + SATOT + "</b></p></td>";

                          }

                        

                          strOptions += "<td width=35><p align=center><b>" + strTotal + "</b></p></td>";

                          strOptions += "</tr>";

                          DISPLAY();

                      }
                  }

            }

            strOptions += "</table>";
            dvContent.Append(strOptions);
        }

        dvCard.InnerHtml = dvContent.ToString();
    }


    //Mark List Student Name Wise

    private void DISPLAY()
    {
        utl = new Utilities();

        string strFA = string.Empty;
        string strFB = string.Empty;
        string strFAFBTotal = string.Empty;
        string strSA = string.Empty;
        DataSet dsGet = new DataSet();
        string examnochk = string.Empty;

        sqlstr = "sp_getCalculateMarks '" + Session["strClassID"] + "','" + Session["strSectionID"] + "','" + Session["strExamNameID"] + "'," + "'" + ddlType.SelectedItem.Text + "'" + ",'" + Session["strSubjectID"] + "'," + AcademicID;
        dsGet = utl.GetDataset(sqlstr);
             
        StringBuilder dvContent = new StringBuilder();

        if (dsGet.Tables[0].Rows.Count > 0)
        {
            int j = 0;

            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {

                 double tot_FA =0;
                 double tot_FB = 0;
                 double SA = 0;
                 if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                 {
                    
                     //Pattern None Details Start
                     DataRow[] drNone = dsGet.Tables[0].Select("Pattern='None' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                     if (drNone.Length > 0)
                     {
                         j = i + 1;
                         for (int k = 0; k < drNone.Length; k++)
                         {
                             strOptions += "<tr><td width=49><p align=center>" + (j).ToString() + "</p></td><td width=49><p align=center>" + drNone[k]["ExamNo"].ToString() + "</p></td><td width=175><p>" + drNone[k]["StudentName"].ToString() + "</p></td>";

                             //Check Absent - change the color Red -Start
                             if (drNone[k]["Mark"].ToString() == "A")
                             {
                                 strOptions += @"<td width=175><p>" + dsGet.Tables[0].Rows[k]["ExamTypeName"].ToString() + "</p></td><td width=142 style='vertical-align: top; text-align: center;'>" + drNone[k]["MaxMark"].ToString() + "</td><td width=75 style='vertical-align: top;text-align: center;'>" + drNone[k]["PassMark"].ToString() + "</td><td width=142 style='vertical-align: top;text-align: center; color:red;'>" + drNone[k]["Mark"].ToString() + "</td><td width=142 style='vertical-align: top;text-align: center;'>" + drNone[k]["Grade"].ToString() + "</td></tr>";
                                 j = j + 1;
                             }

                             else
                             {
                                 strOptions += @"<td width=175><p>" + dsGet.Tables[0].Rows[k]["ExamTypeName"].ToString() + "</p></td><td width=142 style='vertical-align: top; text-align: center;'>" + drNone[k]["MaxMark"].ToString() + "</td><td width=75 style='vertical-align: top;text-align: center;'>" + drNone[k]["PassMark"].ToString() + "</td><td width=142 style='vertical-align: top;text-align: center;'>" + drNone[k]["Mark"].ToString() + "</td><td width=142 style='vertical-align: top;text-align: center;'>" + drNone[k]["Grade"].ToString() + "</td></tr>";
                                 j = j + 1;
                             }
                             //Check Absent - change the color Red -End


                         }
                      
                         examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                     }

                    //Pattern None Details End

                     else
                     {
                         j = j + 1;
                         strOptions += "<tr><td width=49><p align=center>" + (j).ToString() + "</p></td><td width=49><p align=center>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</p></td><td width=175><p>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</p></td>";
                         
                         //FA(a) - Colspan Mark Details                    
                         DataRow[] drFA = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                         if (drFA.Length > 0)
                         {

                             for (int p = 0; p < drFA.Length; p++)
                             {
                                 //Check Absent - change the color Red 
                                 if (drFA[p]["Mark"].ToString() == "A")
                                 {
                                     strOptions += "<td width=35><p align=center style='color:red;'>" + drFA[p]["Mark"].ToString() + "</p></td>";
                                 }

                                 else
                                 {
                                     strOptions += "<td width=35><p align=center>" + drFA[p]["Mark"].ToString() + "</p></td>";
                                 }
                             }

                             strOptions += "<td width=35><p align=center>" + drFA[0]["ScoredMarkTotal"].ToString() + "</p></td>";
                             tot_FA = Convert.ToDouble(drFA[0]["ScoredMarkTotal"].ToString());
                         }


                         //FA(b) - Colspan Mark Details

                         DataRow[] drFb = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                         if (drFb.Length > 0)
                         {
                             for (int q = 0; q < drFb.Length; q++)
                             {
                                 //Check Absent - change the color Red 
                                 if (drFb[q]["Mark"].ToString() == "A")
                                 {
                                     strOptions += "<td width=35><p align=center style='color:red;'>" + drFb[q]["Mark"].ToString() + "</p></td>";
                                 }
                                 else
                                 {
                                     strOptions += "<td width=35><p align=center>" + drFb[q]["Mark"].ToString() + "</p></td>";
                                 }
                             }

                             strOptions += "<td width=35><p align=center>" + drFb[0]["ScoredMarkTotal"].ToString() + "</p></td>";
                             tot_FB = Convert.ToDouble(drFb[0]["ScoredMarkTotal"].ToString());
                         }

                         //FA - Total


                         int FA = Convert.ToInt32(Math.Ceiling(tot_FA + tot_FB));

                         strOptions += "<td width=35><p align=center>" + FA + "</p></td>";

                         //SA - Mark Details
                         DataRow[] drSA = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                         if (drSA.Length > 0)
                         {
                             if (drSA[0]["Mark"].ToString() == "A")
                             {
                                 strOptions += "<td width=35><p align=center style='color:red;'>" + drSA[0]["Mark"].ToString() + "</p></td>";
                                 SA = 0;
                             }

                             else
                             {
                                 strOptions += "<td width=35><p align=center>" + drSA[0]["Mark"].ToString() + "</p></td>";
                                 SA = Convert.ToDouble(drSA[0]["Mark"].ToString());
                             }

                             
                         }

                         //Total -Over All Marks

                         int TOTAL_ALL = Convert.ToInt32(FA + SA);

                         strOptions += "<td width=35><p align=center>" + TOTAL_ALL + "</p></td>";


                         //Grade Calculation

                         sqlstr1 = "sp_getCalculateGrade " + "'FA'" + "," + FA + "," + "'" + Session["AcademicID"].ToString() + "'"; 
                         string FA_Grade = utl.ExecuteScalar(sqlstr1);


                         sqlstr1 = "sp_getCalculateGrade " + "'SA'" + "," + SA + "," + "'" + Session["AcademicID"].ToString() + "'"; 
                         string SA_Grade = utl.ExecuteScalar(sqlstr1);


                         sqlstr1 = "sp_getCalculateGrade " + "'OverAll'" + "," + TOTAL_ALL + "," + "'" + Session["AcademicID"].ToString() + "'"; 
                         string TOTALL_Grade = utl.ExecuteScalar(sqlstr1);

                         strOptions += "<td width=35><p align=center>" + FA_Grade + "</p></td><td width=35><p align=center>" + SA_Grade + "</p></td><td width=35><p align=center>" + TOTALL_Grade + "</p></td></tr>";

                         examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                     }
                 }
            }

        }


    }




    protected void ddlExamName_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlExamName.SelectedItem.Text == "---Select---" || ddlExamName.SelectedItem.Value == "---Select---")
        {
            strExamName = "";
            strExamNameID = "";
            Session["strExamName"] = "";
            Session["strExamNameID"] = "";

        }
        else
        {
            Session["strExamName"] = ddlExamName.SelectedItem.Text;
            Session["strExamNameID"] = ddlExamName.SelectedValue;
        }
    }
    protected void ddlSubjects_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSubjects.SelectedItem.Text == "---Select---" || ddlSubjects.SelectedItem.Value == "---Select---")
        {
            strSubject = "";
            strSubjectID = "";
            Session["strSubject"] = "";
            Session["strSubjectID"] = "";

        }
        else
        {
            Session["strSubject"] = ddlSubjects.SelectedItem.Text;
            Session["strSubjectID"] = ddlSubjects.SelectedValue;
        }
    }
}