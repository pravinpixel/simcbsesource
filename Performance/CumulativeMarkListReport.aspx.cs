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


public partial class Performance_CumulativeMarkListReport : System.Web.UI.Page
{
    Utilities utl = null;
    Utilities utl1 = null;
    Utilities utl2 = null;

    string strExamName = "";
    string strExamNameID = "";

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
                BindExamName();

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

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            Disp_SubjectList();


            if (ddlType.SelectedItem != null && ddlType.SelectedItem.Text != "---Select---")
            {
                if (ddlType.SelectedItem.Text == "Samacheer")
                {
                    LOAD_RESULT();
                }

                else
                {
                    LOAD_RESULT_NORMAL();
                }
            }



        }

        catch (Exception ex)
        {
            utl.ShowMessage("<script>AlertMessage('info', '" + ex.Message + "');</script>", this.Page);
        }
    }


    //Main Search Function

    string stroption;
    private void LOAD_RESULT()
    {
        utl = new Utilities();

        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());

        int chk = 0;
        string examnochk = string.Empty;

        DataSet dsGet = new DataSet();

        sqlstr = "sp_getCCEpromotion " + Session["strClassID"] + ",'" + Session["strSectionID"] + "'," + "'" + Session["strExamNameID"] + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + SubjectListID + "'" + "," + AcademicID;

        dsGet = utl.GetDataset(sqlstr);

        StringBuilder dvContent = new StringBuilder();


        dvContent.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
        dvContent.Append("<td align='center' colspan='3' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td width='15%' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>" + Session["strClass"].ToString().ToUpper() + " - " + Session["strSection"].ToString().ToUpper() + "</td><td align='center' style='font-family:Arial,padding-left: 17px; Helvetica, sans-serif; font-size:17px;'><b>CUMULATIVE MARKLIST REPORT</b></td></tr></table>");



        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%>");
            stroption += @"<thead><tr><th colspan='3'>&nbsp;</th>";

            //Subject List Load start


            utl1 = new Utilities();
            DataSet ds = new DataSet();
            string query = "SP_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'" + ddlType.SelectedItem.Text + "','" + AcademicID + "'";
            ds = utl1.GetDataset(query);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    stroption += @"<th colspan='8'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></th>";
                }
            }

            stroption += @"</tr></thead>";

            stroption += @"<tr><td>Sl No</td><td>Exam No</td><td>Name of the student</td>";

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    for (int k = 0; k < 1; k++)
                    {
                        stroption += @"<td>FA(a)Total</td><td>FA(b)Total</td><td>FA Total</td><td>SA Total</td><td>Total Marks </td><td>FA Grade</td><td>SA Grade</td><td>Total Grade </td>";
                    }
                }
            }


            //Subject List Load End

            int p = 0;

            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {

                if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                {
                    p = p + 1;

                    stroption += @"<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {

                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            double FAtot = 0;
                            double FBtot = 0;
                            double FABTotal = 0;
                            double SAtot = 0;
                            int Total = 0;
                            string strTotal = "";

                            DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");
                            string FAActualMark = "";
                            double dblFAActualMark = 0;
                            string FBActualMark = "";
                            double dblFBActualMark = 0;
                            string SAActualMark = "";
                            double dblSAActualMark = 0;
                            string strFABTotal = "";
                            if (drFAScroedMarkTOT.Length > 0)
                            {
                                FAActualMark = drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString();

                                if (FAActualMark == null || FAActualMark == "")
                                {
                                    dblFAActualMark = 0;
                                    FAActualMark = "";
                                }
                                else
                                {
                                    dblFAActualMark = Convert.ToDouble(drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                }
                            }

                            else
                            {
                                FAActualMark = "";
                            }

                            DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                            if (drFBScroedMarkTOT.Length > 0)
                            {
                                FBActualMark = drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString();

                                if (FBActualMark == null || FBActualMark == "")
                                {
                                    dblFBActualMark = 0;
                                    FBActualMark = "";
                                }
                                else
                                {
                                    dblFBActualMark = Convert.ToDouble(drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                }
                            }

                            else
                            {
                                FBActualMark = "";
                            }


                            if ((FAActualMark != "" && FBActualMark != "") && (FAActualMark != null && FBActualMark != null))
                            {
                                FABTotal = Convert.ToInt32(Math.Ceiling(dblFAActualMark + dblFBActualMark));
                                strFABTotal = FABTotal.ToString();
                            }
                            else if (FAActualMark == "" && FBActualMark != "")
                            {
                                FABTotal = Convert.ToInt32(Math.Ceiling(dblFBActualMark));
                                strFABTotal = FABTotal.ToString();
                            }
                            else if (FAActualMark != "" && FBActualMark == "")
                            {
                                FABTotal = Convert.ToInt32(Math.Ceiling(dblFAActualMark));
                                strFABTotal = FABTotal.ToString();
                            }
                            else
                            {
                                strFABTotal = "";
                            }

                            DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                            if (drSAScroedMarkTOT.Length > 0)
                            {
                                SAActualMark = drSAScroedMarkTOT[0]["Mark"].ToString();

                                if (SAActualMark == null || SAActualMark == "")
                                {
                                    dblSAActualMark = 0;
                                    SAActualMark = "";
                                }
                                else
                                {
                                    dblSAActualMark = Convert.ToDouble(drSAScroedMarkTOT[0]["Mark"].ToString());
                                }
                            }

                            else
                            {
                                SAActualMark = "";
                            }


                            if (SAActualMark != "" && strFABTotal != "")
                            {
                                Total = Convert.ToInt32(Math.Ceiling(FABTotal + dblSAActualMark));
                                strTotal = Total.ToString();
                            }
                            else if (SAActualMark == "" && strFABTotal != "")
                            {
                                Total = Convert.ToInt32(Math.Ceiling(FABTotal));
                                strTotal = Total.ToString();
                            }
                            else if (SAActualMark != "" && strFABTotal == "")
                            {
                                Total = Convert.ToInt32(Math.Ceiling(dblSAActualMark));
                                strTotal = Total.ToString();
                            }
                            else
                            {
                                strTotal = "";
                            }


                            //Grade Calculation

                            string FA_Grade = "";
                            if (FBActualMark != "" || FAActualMark != "")
                            {
                                sqlstr1 = "sp_getCalculateGrade " + "'FA'" + "," + FABTotal + "," + "'" + Session["AcademicID"].ToString() + "'";
                                FA_Grade = utl.ExecuteScalar(sqlstr1);
                            }
                            else
                            {
                                FA_Grade = "ABSENT";
                            }

                            string SA_Grade = "";
                            if (SAActualMark != "")
                            {
                                sqlstr1 = "sp_getCalculateGrade " + "'SA'" + "," + dblSAActualMark + "," + "'" + Session["AcademicID"].ToString() + "'";
                                SA_Grade = utl.ExecuteScalar(sqlstr1);
                            }
                            else
                            {
                                SA_Grade = "ABSENT";
                            }

                            string TOTALL_Grade = "";
                            if (strTotal != "")
                            {
                                sqlstr1 = "sp_getCalculateGrade " + "'OverAll'" + "," + Total + "," + "'" + Session["AcademicID"].ToString() + "'";
                                TOTALL_Grade = utl.ExecuteScalar(sqlstr1);
                            }
                            else
                            {
                                TOTALL_Grade = "ABSENT";
                            }

                            if (FAActualMark == "")
                            {
                                FAActualMark = "A";
                            }
                            else
                            {
                                FAActualMark = dblFAActualMark.ToString();
                            }
                            if (FBActualMark == "")
                            {
                                FBActualMark = "A";
                            }
                            else
                            {
                                FBActualMark = dblFBActualMark.ToString();
                            }
                            if (strFABTotal == "")
                            {
                                strFABTotal = "A";
                            }
                            else
                            {
                                strFABTotal = FABTotal.ToString();
                            }
                            if (SAActualMark == "")
                            {
                                SAActualMark = "A";
                            }
                            else
                            {
                                SAActualMark = dblSAActualMark.ToString();
                            }
                            if (strTotal == "")
                            {
                                strTotal = "A";
                            }
                            else
                            {
                                strTotal = Total.ToString();
                            }
                            stroption += @"<td>" + FAActualMark + "</td><td>" + FBActualMark + "</td><td>" + strFABTotal + "</td><td>" + SAActualMark + "</td><td>" + strTotal + "</td><td>" + FA_Grade + "</td><td>" + SA_Grade + "</td><td>" + TOTALL_Grade + "</td>";

                        }
                    }

                    stroption += @"</tr>";
                    examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                }

            }

            stroption += @"</table>";
            dvContent.Append(stroption);
        }

        dvCard.InnerHtml = dvContent.ToString();

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


    //Normal Type Result [General or others Only Not Samacheer type]
    private void LOAD_RESULT_NORMAL()
    {
        DataTable DataTable1 = new DataTable();
        DataTable1 = utl.GetDataTable("SP_CumulativeMarklist " + "'" + Session["strClassID"] + "','" + Session["strSectionID"] + "','" + Session["strExamNameID"] + "','','" + ddlType.SelectedItem.Text + "','" + AcademicID + "'");

        if (DataTable1.Rows.Count > 0)
        {
            StringBuilder str = new StringBuilder();

            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            str.Append("<br><table class='form' width='1000'><tr>");
            str.Append("<td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td><tr><tr><td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>CUMULATIVE MARKLIST REPORT</td></tr><tr><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:15px;'>" + Session["strExamName"].ToString().ToUpper() + " -  " + Session["strClass"].ToString().ToUpper() + "</td></tr></table>");


            str.Append("<table class='performancedata'  border='1' cellspacing='5' cellpadding='10' width='100%'><tr>");
            str.Append("<td align='left'><label>SL.NO.</label></td>");
            for (int i = 0; i <= 4; i++)
            {
                str.Append("<td align='left'><label>" + DataTable1.Columns[i].ColumnName.ToUpper().ToString() + "</label></td>");
            }
            for (int i = 5; i < DataTable1.Columns.Count - 4; i++)
            {
                str.Append("<td align='left'><label>" + DataTable1.Columns[i].ColumnName.ToUpper().ToString() + "</label></td><td align='left'><label>Grade</label></td>");
            }
            for (int i = DataTable1.Columns.Count - 4; i < DataTable1.Columns.Count; i++)
            {
                str.Append("<td align='left'><label>" + DataTable1.Columns[i].ColumnName.ToUpper().ToString() + "</label></td>");
            }
            str.Append(@"</tr>");

            for (int i = 0; i < DataTable1.Rows.Count; i++)
            {
                str.Append(@"<tr><td>" + (i + 1).ToString() + "</td><td>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td><td>" + DataTable1.Rows[i]["StudentName"].ToString() + "</td><td>" + DataTable1.Rows[i]["ExamNo"].ToString() + "</td><td>" + DataTable1.Rows[i]["Class"].ToString() + "</td><td>" + DataTable1.Rows[i]["Section"].ToString() + "</td>");

                for (int j = 5; j < DataTable1.Columns.Count - 4; j++)
                {
                    sqlstr = @"select  mg.GradeName       
from Vw_GetStudent a inner join m_class c on a.classid=c.classid                       
inner join m_schooltypes b on a.schooltypeid=b.schooltypeid                       
inner join [p_ClassSubjects] d on d.schooltypeid=b.schooltypeid and d.ClassId=c.ClassId                       
inner join m_subexperiences e on d.subjectid=e.subexperienceid left join p_examsetup j on (j.ClassSubjectID=d.ClassSubjectID)                       
inner join p_exammarks k on (k.regno=a.regno and k.examtypeid=j.examtypeid and k.classsubjectid=d.classsubjectid) inner join p_examtypes l on l.examtypeid=j.examtypeid inner join p_examnamelist m on m.examnameid=l.examnameid inner join p_gradesetup gs on gs.pattern=l.pattern and gs.isactive=1 inner join m_grades mg on (mg.gradeID=gs.GradeId and mg.Isactive=1)  where d.isactive=1 and a.RegNo=" + DataTable1.Rows[j]["RegNo"].ToString() + " and " + DataTable1.Rows[i]["" + DataTable1.Columns[j].ColumnName.ToUpper() + ""].ToString() + " between gs.MarkFrom and gs.markTo and convert(nvarchar(3),upper(e.subexperiencename)) ='" + DataTable1.Columns[j].ColumnName.ToUpper() + "' and a.AcademicYear='" + AcademicID + "' and d.AcademicID='" + AcademicID + "' and k.AcademicID='" + AcademicID + "' and l.AcademicID='" + AcademicID + "' and m.AcademicID='" + AcademicID + "'";
                    string grade = utl.ExecuteScalar(sqlstr);
                    str.Append("<td align='center'>" + DataTable1.Rows[i]["" + DataTable1.Columns[j].ColumnName.ToUpper() + ""].ToString() + "</td><td align='center'>" + grade + "</td>");
                }
                for (int j = DataTable1.Columns.Count - 4; j < DataTable1.Columns.Count; j++)
                {
                    str.Append("<td align='center'>" + DataTable1.Rows[i]["" + DataTable1.Columns[j].ColumnName.ToUpper() + ""].ToString() + "</td>");
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