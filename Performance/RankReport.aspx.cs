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

public partial class Performance_RankReport : System.Web.UI.Page
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


    string SubjectListID = "";
    int SubjectListCount;
    private void Disp_SubjectList()
    {
        utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SP_GETLANGUAGELIST " + Convert.ToInt32(ddlClass.Text) + ",'" + ddlType.Text + "','" + AcademicID + "'";
        ds = utl.GetDataset(query);
       

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            SubjectListCount = ds.Tables[0].Rows.Count;
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

            //sp_getRankReport
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


    //Normal Type Result [General or others Only Not Samacheer type]
    private void LOAD_RESULT_NORMAL()
    {
        DataTable DataTable1 = new DataTable();
        DataTable1 = utl.GetDataTable("SP_RankReportGeneralType " + "'" + Session["strClassID"] + "','" + Session["strSectionID"] + "','" + Session["strExamNameID"] + "','','" + ddlType.SelectedItem.Text + "','" + AcademicID + "'");

        if (DataTable1.Rows.Count > 0)
        {
            StringBuilder str = new StringBuilder();

            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            str.Append("<br><table class='form' width='1000'><tr>");
            str.Append("<td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td><tr><tr><td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>RANK REPORT</td></tr><tr><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:15px;'>" + Session["strExamName"].ToString().ToUpper() + " -  " + Session["strClass"].ToString().ToUpper() + "</td></tr></table>");


            str.Append("<table class='performancedata'  border=1 cellspacing=5 cellpadding=10 width=100%><tr>");
            str.Append("<td align='left'><label>SL.NO.</label></td>");

            for (int i = 0; i <= DataTable1.Columns.Count-2; i++)
            {
                str.Append("<td align='left'><label>" + DataTable1.Columns[i].ColumnName.ToUpper().ToString() + "</label></td>");
            }            
            str.Append(@"</tr>");


            for (int i = 0; i < DataTable1.Rows.Count; i++)
            {
                str.Append(@"<tr><td>" + (i + 1).ToString() + "</td>");
                for (int j = 0; j < DataTable1.Columns.Count-1; j++)
                {
                    str.Append(@"<td>" + DataTable1.Rows[i][j].ToString() + "</td>");
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



    //Main Search Function

    string stroption=string.Empty;
    private void LOAD_RESULT()
    {
        utl = new Utilities();         
        StringBuilder dvContent = new StringBuilder();
                     
        DataTable DataTable1 = new DataTable();
        DataTable1 = utl.GetDataTable("sp_getRankReport " + Session["strClassID"] + ","+"'" + Session["strSectionID"] + "'"+"," + "'" + Session["strExamNameID"] + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + SubjectListID + "'" + "," + AcademicID);
        if (DataTable1.Rows.Count > 0)
        {
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            dvContent.Append("<br><table class='form' width='1000'><tr>");
            dvContent.Append("<td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td><tr><tr><td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>RANK REPORT</td></tr><tr><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:15px;'>" + Session["strExamName"].ToString().ToUpper() + " -  " + Session["strClass"].ToString().ToUpper() + " Standard </td></tr></table>");


            dvContent.Append("<table class='performancedata'  border=1 cellspacing=5 cellpadding=10 width=100%><tr>");
            dvContent.Append("<td align='left'><label>SL.NO.</label></td>");
            for (int i = 0; i < DataTable1.Columns.Count; i++)
            {
                dvContent.Append("<td align='left'><label>" + DataTable1.Columns[i].ColumnName.ToUpper().ToString() + "</label></td>");
            }
            dvContent.Append(@"</tr>");

            for (int i = 0; i < DataTable1.Rows.Count; i++)
            {
                dvContent.Append(@"<tr><td>" + (i + 1).ToString() + "</td><td>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td><td>" + DataTable1.Rows[i]["StudentName"].ToString() + "</td><td>" + DataTable1.Rows[i]["ExamNo"].ToString() + "</td><td>" + DataTable1.Rows[i]["Class"].ToString() + "</td><td>" + DataTable1.Rows[i]["Section"].ToString() + "</td>");
                for (int j = 5; j < DataTable1.Columns.Count; j++)
                {
                    string mark = DataTable1.Rows[i]["" + DataTable1.Columns[j].ColumnName.ToUpper() + ""].ToString();
                    if (mark == "" || mark == null)
                    {
                        dvContent.Append("<td align='center' style='color:red'>A</td>");
                    }
                    else
                    {
                        dvContent.Append("<td align='center' style='color:black'>" + DataTable1.Rows[i]["" + DataTable1.Columns[j].ColumnName.ToUpper() + ""].ToString() + "</td>");
                    }

                }
                dvContent.Append(@"</tr>");
            }
            dvContent.Append(@"</table>");
            dvCard.InnerHtml = dvContent.ToString();

       }

        else
        {
            dvCard.InnerHtml = string.Empty;
        }
        
    }    

}