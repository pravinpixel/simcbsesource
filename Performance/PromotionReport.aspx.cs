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


public partial class Performance_PromotionReport : System.Web.UI.Page
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
                BindClass();
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
    protected void btnShow_Click(object sender, EventArgs e)
    {
        if (ddlClass.SelectedIndex != 0 && ddlClass.SelectedIndex != -1 && ddlSection.SelectedIndex != 0 && ddlSection.SelectedIndex != -1)
        {
            if (ddlClass.SelectedValue == "11")
            {
                LOAD_RESULT_IX();
            }
            else
            {
                LOAD_RESULT();
            }

            
        }
    }

    private void LOAD_RESULT()
    {
        utl = new Utilities();
        sqlstr = "[GeneratePromotionReport] " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
        DataSet ds = new DataSet();
        ds = utl.GetDataset(sqlstr);
        StringBuilder dvContent = new StringBuilder();
        string RegNo = "";
        int j = 0;
        if (ds.Tables[0].Rows.Count > 0)
        {
            utl = new Utilities();
            DataSet dsLang = new DataSet();
            string query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
            dsLang = utl.GetDataset(query);

            dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td width='10%'><b>AdmissionNo</b></td><td width='10%'><b>ExamNo</b></td><td width='10%'><b>RegNo</b></td><td width='10%'><b>StudentName</b></td><td width='10%'><b>DOB</b></td><td width='10%'><b>ClassName</b></td><td width='10%'><b>SectionName</b></td>");
            if (dsLang != null && dsLang.Tables.Count > 0 && dsLang.Tables[0].Rows.Count > 0)
            {
                for (int k = 0; k < dsLang.Tables[0].Rows.Count; k++)
                {
                    dvContent.Append(@"<td width='10%' colspan='4'><b>" + dsLang.Tables[0].Rows[k]["SubjectName"].ToString() + "</b></td>");
                }
                dvContent.Append(@"<td width='10%'><b>OverAllTotal</b></td><td width='10%'><b>TotalPercent</b></td><td width='10%'><b>PresentDays</b></td><td width='10%'><b>AttendancePercent</b></td><td width='10%'><b>Status</b></td><td width='10%'><b>Remark</b></td></tr>");
                dvContent.Append(@"<tr><td colspan='7'>&nbsp;</td>");
                for (int k = 0; k < dsLang.Tables[0].Rows.Count; k++)
                {
                    dvContent.Append(@"<td width='10%'><b>P1</b></td><td width='10%'><b>P2</b></td><td width='10%'><b>P2Mod</b></td><td width='10%'><b>FinalMark</b></td>");
                }
                dvContent.Append(@"<td colspan='7'>&nbsp;</td></tr>");
            }

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {

                if (RegNo != ds.Tables[0].Rows[i]["RegNo"].ToString())
                {
                    dvContent.Append(@"<tr><td>" + ds.Tables[0].Rows[i]["AdminNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["DOB"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["ClassName"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["SectionName"].ToString() + "</td>");

                    DataRow[] drReg = ds.Tables[0].Select("RegNo='" + ds.Tables[0].Rows[i]["RegNo"].ToString() + "'");

                    if (drReg.Length > 0)
                    {
                        for (int x = 0; x < drReg.Length; x++)
                        {
                            dvContent.Append(@"<td>" + ((System.Data.DataRow)(drReg.GetValue(x))).ItemArray[9] + "</td><td>" + ((System.Data.DataRow)(drReg.GetValue(x))).ItemArray[10] + "</td><td>" + ((System.Data.DataRow)(drReg.GetValue(x))).ItemArray[11] + "</td><td>" + ((System.Data.DataRow)(drReg.GetValue(x))).ItemArray[12] + "</td>");
                        }
                    }
                    dvContent.Append(@"<td>" + ds.Tables[0].Rows[i]["OverAllTotal"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["TotalPercn"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["PresentDays"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["AttendancePercn"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["Status"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["Remarks"].ToString() + "</td>");
                    RegNo = ds.Tables[0].Rows[i]["RegNo"].ToString();
                    dvContent.Append(@"</tr>");
                }
            }

            dvContent.Append(@"</table>");
            dvCard.InnerHtml = dvContent.ToString();

        }
    }


    private void LOAD_RESULT_IX()
    {
        utl = new Utilities();
        sqlstr = "[GeneratePromotionReport] " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
        DataSet ds = new DataSet();
        ds = utl.GetDataset(sqlstr);
        StringBuilder dvContent = new StringBuilder();
        string RegNo = "";
        int j = 0;
        if (ds.Tables[0].Rows.Count > 0)
        {
            utl = new Utilities();
            DataSet dsLang = new DataSet();
            string query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
            dsLang = utl.GetDataset(query);

            dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td width='10%'><b>AdmissionNo</b></td><td width='10%'><b>ExamNo</b></td><td width='10%'><b>RegNo</b></td><td width='10%'><b>StudentName</b></td><td width='10%'><b>DOB</b></td><td width='10%'><b>ClassName</b></td><td width='10%'><b>SectionName</b></td>");
            if (dsLang != null && dsLang.Tables.Count > 0 && dsLang.Tables[0].Rows.Count > 0)
            {
                for (int k = 0; k < dsLang.Tables[0].Rows.Count; k++)
                {
                    dvContent.Append(@"<td width='10%' colspan='3'><b>" + dsLang.Tables[0].Rows[k]["SubjectName"].ToString() + "</b></td>");
                }
                dvContent.Append(@"<td width='10%'><b>OverAllTotal</b></td><td width='10%'><b>TotalPercent</b></td><td width='10%'><b>PresentDays</b></td><td width='10%'><b>AttendancePercent</b></td><td width='10%'><b>Status</b></td><td width='10%'><b>Remark</b></td></tr>");
                dvContent.Append(@"<tr><td colspan='7'>&nbsp;</td>");
                for (int k = 0; k < dsLang.Tables[0].Rows.Count; k++)
                {
                    dvContent.Append(@"<td width='10%'><b>FA</b></td><td width='10%'><b>SA</b></td><td width='10%'><b>TOT</b></td>");
                }
                dvContent.Append(@"<td colspan='7'>&nbsp;</td></tr>");
            }

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {

                if (RegNo != ds.Tables[0].Rows[i]["RegNo"].ToString())
                {
                    dvContent.Append(@"<tr><td>" + ds.Tables[0].Rows[i]["AdminNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["DOB"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["ClassName"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["SectionName"].ToString() + "</td>");

                    DataRow[] drReg = ds.Tables[0].Select("RegNo='" + ds.Tables[0].Rows[i]["RegNo"].ToString() + "'");

                    if (drReg.Length > 0)
                    {
                        for (int x = 0; x < drReg.Length; x++)
                        {
                            dvContent.Append(@"<td>" + ((System.Data.DataRow)(drReg.GetValue(x))).ItemArray[9] + "</td><td>" + ((System.Data.DataRow)(drReg.GetValue(x))).ItemArray[10] + "</td><td>" + ((System.Data.DataRow)(drReg.GetValue(x))).ItemArray[11] + "</td>");
                        }
                    }
                    dvContent.Append(@"<td>" + ds.Tables[0].Rows[i]["OverAllTotal"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["TotalPercn"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["PresentDays"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["AttendancePercn"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["Status"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["Remarks"].ToString() + "</td>");
                    RegNo = ds.Tables[0].Rows[i]["RegNo"].ToString();
                    dvContent.Append(@"</tr>");
                }
            }

            dvContent.Append(@"</table>");
            dvCard.InnerHtml = dvContent.ToString();

        }
    }



}