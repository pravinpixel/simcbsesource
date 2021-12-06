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
using System.Globalization;
using System.Net;

public partial class Reports_MonthwiseAttendanceReport : System.Web.UI.Page
{
    ScriptManager ScriptManager = null;
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    public static int AcademicID = 0;
    string Month = "";
    Utilities utl = null;
    public static int Userid = 0;
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
            if (!IsPostBack)
            {
                BindClass();
                DataTable dtSchool = new DataTable();
                utl = new Utilities();
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
    protected void BindSectionByClass()
    {
        utl = new Utilities();
        DataSet dsSection = new DataSet();
        if (ddlClass.SelectedValue != string.Empty)
        {
            dsSection = utl.GetDataset("sp_GetSectionByClass " + ddlClass.SelectedValue);
        }
        else
        {
            ddlSection.Items.Clear();
        }

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
        ddlSection.Items.Insert(0, "-----Select-----");
    }


    private void Page_Init(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Display();
        ClientScript.RegisterStartupScript(this.GetType(), "", "RemoveProgess();", true);
    }


    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["strClass"] = "All Class";
        Session["strSection"] = "All Section";
        BindSectionByClass();
        if (ddlClass.SelectedItem.Text == "-----Select-----" || ddlClass.SelectedItem.Value == "-----Select-----" || ddlClass.SelectedItem.Value == "")
        {
            strClass = "";
            strClassID = "";
            strSection = "";
            strSectionID = "";
            Session["strClass"] = "All Class";
            Session["strSection"] = "All Section";

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
        if (ddlSection.SelectedItem.Text == "-----Select-----" || ddlSection.SelectedItem.Value == "-----Select-----")
        {
            Session["strSection"] = "All Section";
            Session["strSectionID"] = "";

        }
        else
        {
            Session["strSection"] = ddlSection.SelectedItem.Text;
            Session["strSectionID"] = ddlSection.SelectedValue;
        }
    }

    private string Attenance(string regno, string MonthID, int totdays)
    {
        Utilities utl = new Utilities();
        string AttendanceDetail;

        double presentdays = 0;
        string sql2;

        double NoofPresent = 0;


        sql2 = "select (convert(float,((dbo.[fn_GetFNAttCount]('" + regno + "','" + AcademicID + "','" + MonthID + "','" + totdays + "'))+(dbo.[fn_GetANAttCount]('" + regno + "','" + AcademicID + "','" + MonthID + "','" + totdays + "')))/2)) as PresentDays";


        presentdays = Convert.ToDouble(utl.ExecuteScalar(sql2));

        NoofPresent += presentdays;

        AttendanceDetail = NoofPresent.ToString();

        return AttendanceDetail;
    }

    private void Display()
    {
        utl = new Utilities();
        string examnochk = string.Empty;
        int p = 0;

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
        if (strClass == "")
        {
            strClass = "All Classes";
        }
        if (strSection == "")
        {
            strSection = "All Sections";
        }

        string sqlstr = "";
        utl = new Utilities();
        DataTable dtmnth = new DataTable();
        dtmnth = utl.GetDataTable("select top 1 convert(varchar,startdate,121)startdate,convert(Varchar,enddate,121)enddate from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
        if (dtmnth.Rows.Count > 0)
        {
            StringBuilder str = new StringBuilder();
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");
            str.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
            str.Append("<td colspan='3' align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td align='right'  style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>Class " + Session["strClass"].ToString().ToUpper() + " Std " + Session["strSection"].ToString().ToUpper() + " Sec " + "</td><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>MONTH-WISE ATTENDANCE REPORT</td></tr></table>");

            str.Append(@"<table class=performancedata border=1 cellspacing=5 cellpadding=10 width=100%><tr><td rowspan=2><b>Sl.No.</b></td><td rowspan=2><b>Student Name</b></td><td  rowspan=2><b>Reg.No</b></td><td  rowspan=2><b>Exam No</b></td>");

            sqlstr = "select COUNT(*) from m_DaysList where ClassID=" + Session["strClassID"] + " and AcademicID=" + AcademicID + " and IsActive=1";
            string totaldays = utl.ExecuteScalar(sqlstr);

            DataTable dtmon = new DataTable();
            dtmon = utl.GetDataTable("exec sp_getacademicmonths '" + dtmnth.Rows[0]["startdate"].ToString() + "','" + dtmnth.Rows[0]["enddate"].ToString() + "'");
            if (dtmon != null && dtmon.Rows.Count > 0)
            {
                for (int k = 0; k < dtmon.Rows.Count; k++)
                {

                    str.Append(@"<td style='vertical-align: top; color:Black ; text-align: center;' cellspacing=2 cellpadding=5><b>" + dtmon.Rows[k]["shortmonth"].ToString() + "</b></td>");

                }
            }

            str.Append(@"<td rowspan=2 style='vertical-align: top;text-align: center;'><b>Total Present</b></td><td rowspan=2 style='vertical-align: top;text-align: center;'><b>Total Days</b></td><td rowspan=2 style='vertical-align: top;text-align: center;'><b>Total Percent</b></td></tr><tr>");

            utl = new Utilities();
            DataSet dsGet = new DataSet();
            dsGet = utl.GetDataset("select * from s_studentinfo where class='" + strClassID + "' and Section='" + strSectionID + "' and academicyear='" + Session["AcademicID"] + "' and active in('C','N') order by examno asc");
            if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
            {

                for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                {
                    if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                    {
                        double actual = 0;
                        double present = 0;
                        int iCnt = 0;
                        p = p + 1;
                        str.Append(@"<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td>");

                        DataRow[] drSTUD = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "");
                        if (drSTUD.Length > 0)
                        {
                            for (int q = 0; q < drSTUD.Length; q++)
                            {
                                dtmon = utl.GetDataTable("exec sp_getacademicmonths '" + dtmnth.Rows[0]["startdate"].ToString() + "','" + dtmnth.Rows[0]["enddate"].ToString() + "'");
                                if (dtmon != null && dtmon.Rows.Count > 0)
                                {
                                    for (int k = 0; k < dtmon.Rows.Count; k++)
                                    {
                                        sqlstr = "select COUNT(*) from m_DaysList where ClassID=" + strClassID + " and MonthID='" + dtmon.Rows[k]["MonthID"].ToString() + "' and AcademicID=" + AcademicID + " and IsActive=1";
                                        string strtotdays = utl.ExecuteScalar(sqlstr);
                                        string MonthAtt = Attenance(dsGet.Tables[0].Rows[i]["RegNo"].ToString(), dtmon.Rows[k]["MonthID"].ToString(), Convert.ToInt32(strtotdays));
                                        
                                        if (Convert.ToDouble(MonthAtt) < 0)
                                        {
                                            str.Append(@"<td style='vertical-align: top;text-align: center;'>0</td>");
                                        }
                                        else
                                        {
                                            present += Convert.ToDouble(MonthAtt);
                                            str.Append(@"<td style='vertical-align: top;text-align: center;'>" + MonthAtt.ToString() + "</td>");
                                        }
                                        actual += Convert.ToDouble(strtotdays);
                                    }
                                }
                            }
                        }

                        str.Append(@"<td style='vertical-align: top;text-align: center;'>" + present.ToString() + "</td><td style='vertical-align: top;text-align: center;'>" + actual.ToString() + "</td><td style='vertical-align: top;text-align: center;'>" + Math.Ceiling(Convert.ToDouble((present/ actual)*100)).ToString() + "</td>");

                        str.Append(@"</tr>");
                        examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();

                    }
                }

                str.Append(@"</table>");
                dvCard.InnerHtml = str.ToString();
            }
        }
    }
}
                    
                
            
        
    
