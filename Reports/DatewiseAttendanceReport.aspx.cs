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

public partial class Reports_DatewiseAttendanceReport : System.Web.UI.Page
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
                BindAcademicMonths();
                BindClass();
                DataTable dtSchool = new DataTable();
                utl = new Utilities();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
                string monthname = "";
                if (ddlMonth.SelectedItem != null)
                {
                    if (ddlMonth.SelectedItem.Text == "---Select---")
                    {
                        monthname = "";
                    }
                    else
                    {
                        monthname = ddlMonth.SelectedItem.Text;
                    }
                }
            }
        }

    }

    private void BindAcademicMonths()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable("select top 1 convert(varchar,startdate,121)startdate,convert(Varchar,enddate,121)enddate from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
        if (dt.Rows.Count > 0)
        {
            DataTable dtmon = new DataTable();
            dtmon = utl.GetDataTable("exec sp_getacademicmonths '" + dt.Rows[0]["startdate"].ToString() + "','" + dt.Rows[0]["enddate"].ToString() + "'");
            if (dtmon != null && dtmon.Rows.Count > 0)
            {
                ddlMonth.DataSource = dtmon;
                ddlMonth.DataTextField = "fullmonth";
                ddlMonth.DataValueField = "MonthID";
                ddlMonth.DataBind();
            }
            else
            {
                ddlMonth.DataSource = null;
                ddlMonth.DataTextField = "";
                ddlMonth.DataValueField = "";
                ddlMonth.DataBind();
            }
            ddlMonth.Items.Insert(0, new ListItem("---Select---", ""));
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

    protected void Page_UnLoad(object sender, EventArgs e)
    {

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
    protected void btnPrint_Click(object sender, EventArgs e)
    {

    }
    protected void ddlMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlMonth.Text == "" || ddlMonth.SelectedValue == "---Select---" || ddlMonth.SelectedItem.Text == "---Select---")
        {
            Session["Month"] = "";
            Session["MonthID"] = "";
        }
        else if (ddlMonth.SelectedValue != "---Select---" && ddlMonth.SelectedItem.Text != "---Select---")
        {
            Session["Month"] = ddlMonth.SelectedItem.Text;
            Session["MonthID"] = ddlMonth.SelectedValue;
        }
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

        string sqlstr = "[sp_GetDaysByMonth] " + Session["strClassID"] + "," + Session["MonthID"] + "," + AcademicID;
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);
        string NoofDays = string.Empty;
        if (dt.Rows.Count > 0)
        {
            NoofDays = dt.Rows[0]["NoofDays"].ToString();
        }
        if (Session["MonthID"] != null && Session["strSectionID"] != null)
        {
            sqlstr = "select DATEPART(mm, StartDate) as sm,DATEPART(mm, EndDate) as em from m_academicyear where AcademicId='" + AcademicID + "' and IsActive=1";
            DataTable dt1 = new DataTable();
            dt1 = utl.GetDataTable(sqlstr);
            int stdmnth = 0;
            int endmnth = 0;
            if (dt1.Rows.Count > 0)
            {
                stdmnth = Convert.ToInt32(dt1.Rows[0]["sm"].ToString());
                endmnth = Convert.ToInt32(dt1.Rows[0]["em"].ToString());
            }
            if (Convert.ToInt32(Session["MonthID"]) >= stdmnth)
            {
                sqlstr = "select year(startdate) from m_academicyear where AcademicId='" + AcademicID + "'";
            }
            else if (Convert.ToInt32(Session["MonthID"]) <= endmnth)
            {
                sqlstr = "select year(enddate) from m_academicyear where AcademicId='" + AcademicID + "'";
            }
            string StDate = utl.ExecuteScalar(sqlstr);
            sqlstr = "select  [dbo].[udf_GetNumDaysInMonth]('" + StDate + "-" + Session["MonthID"] + "-01')";
            int totdays = Convert.ToInt32(utl.ExecuteScalar(sqlstr));
            // int totdays = Convert.ToInt32(NoofDays); //Total day's in a Month 

            sqlstr = " sp_getAttendance " + Session["strClassID"] + "," + Session["strSectionID"] + "," + Session["MonthID"] + "," + totdays + ",'" + Session["AcademicID"].ToString() + "'";
            DataSet dsGet = new DataSet();

            dsGet = utl.GetDataset(sqlstr);
            StringBuilder str = new StringBuilder();
            if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
            {

                DataTable dtSchool = new DataTable();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                str.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
                str.Append("<td colspan='3' align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td align='right'  style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>Class " + Session["strClass"].ToString().ToUpper() + " Std " + Session["strSection"].ToString().ToUpper() + " Sec " + "</td><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>DAY-WISE ATTENDANCE REPORT</td><td align='left' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>For the month of " + Session["Month"] + " " + StDate + " </td></tr></table>");


                str.Append(@"<table class=performancedata border=1 cellspacing=5 cellpadding=10 width=100%><tr><td rowspan=2><b>Sl.No.</b></td><td rowspan=2><b>Student Name</b></td><td  rowspan=2><b>Reg.No</b></td>");



                for (int i = 1; i <= totdays; i++)
                {
                    sqlstr = "select count(*) from m_dayslist where DayValue='" + i + "' and  ClassID='" + Session["strClassID"] + "' and  MonthID='" + Session["MonthID"] + "' and AcademicID='" + AcademicID + "'";
                    int iCnt = Convert.ToInt32(utl.ExecuteScalar(sqlstr));
                    if (iCnt == 0)
                    {
                        str.Append(@"<td style='vertical-align: top;color:Red ; text-align: center;' cellspacing=2 cellpadding=5 colspan='2' ><b>" + i + "</b></td>");
                    }
                    else
                    {
                        str.Append(@"<td style='vertical-align: top; color:Black ; text-align: center;' cellspacing=2 cellpadding=5 colspan='2' ><b>" + i + "</b></td>");
                    }

                }

                str.Append(@"<td rowspan=2 style='vertical-align: top;text-align: center;'><b>Total Present</b></td><td rowspan=2 style='vertical-align: top;text-align: center;'><b>Total Absent</b></td><td rowspan=2 style='vertical-align: top;text-align: center;'><b>Total</b></td></tr><tr>");


                for (int x = 1; x <= totdays; x++)
                {

                    sqlstr = "select count(*) from m_dayslist where DayValue='" + x + "' and  ClassID='" + Session["strClassID"] + "' and  MonthID='" + Session["MonthID"] + "' and AcademicID='" + AcademicID + "'";
                    int iCnt = Convert.ToInt32(utl.ExecuteScalar(sqlstr));
                    if (iCnt == 0)
                    {
                        str.Append(@"<td><p align=center>-</p></td><td><p align=center>-</p></td>");
                    }
                    else
                    {
                        str.Append(@"<td><p align=center>FN</p></td><td><p align=center>AN</p></td>");
                    }


                }

                str.Append(@"</tr>");

                for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                {
                    if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                    {
                        double present = 0;
                        double absent = 0;
                        int iCnt = 0;
                        p = p + 1;
                        str.Append(@"<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]
                            ["RegNo"].ToString() + "</td>");

                        DataRow[] drSTUD = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "");
                        if (drSTUD.Length > 0)
                        {

                            for (int q = 0; q < drSTUD.Length; q++)
                            {
                                if (drSTUD[q]["ForeNoon"].ToString() == "P")
                                {
                                    sqlstr = "select count(*) from m_dayslist where DayValue='" + drSTUD[q]["AttDate"].ToString() + "' and  ClassID='" + Session["strClassID"] + "' and  MonthID='" + Session["MonthID"] + "' and AcademicID='" + AcademicID + "'";
                                    iCnt = Convert.ToInt32(utl.ExecuteScalar(sqlstr));
                                    if (iCnt > 0)
                                    {
                                        present = present + 1;
                                    }
                                }

                                else if (drSTUD[q]["ForeNoon"].ToString() == "A")
                                {

                                    sqlstr = "select count(*) from m_dayslist where DayValue='" + drSTUD[q]["AttDate"].ToString() + "' and  ClassID='" + Session["strClassID"] + "' and  MonthID='" + Session["MonthID"] + "' and AcademicID='" + AcademicID + "'";
                                    iCnt = Convert.ToInt32(utl.ExecuteScalar(sqlstr));
                                    if (iCnt > 0)
                                    {
                                        absent = absent + 1;
                                    }

                                }

                                if (drSTUD[q]["AfterNoon"].ToString() == "P")
                                {
                                    sqlstr = "select count(*) from m_dayslist where DayValue='" + drSTUD[q]["AttDate"].ToString() + "' and  ClassID='" + Session["strClassID"] + "' and  MonthID='" + Session["MonthID"] + "' and AcademicID='" + AcademicID + "'";
                                    iCnt = Convert.ToInt32(utl.ExecuteScalar(sqlstr));
                                    if (iCnt > 0)
                                    {
                                        present = present + 1;
                                    }

                                }

                                else if (drSTUD[q]["AfterNoon"].ToString() == "A")
                                {
                                    sqlstr = "select count(*) from m_dayslist where DayValue='" + drSTUD[q]["AttDate"].ToString() + "' and  ClassID='" + Session["strClassID"] + "' and  MonthID='" + Session["MonthID"] + "' and AcademicID='" + AcademicID + "'";
                                    iCnt = Convert.ToInt32(utl.ExecuteScalar(sqlstr));
                                    if (iCnt > 0)
                                    {
                                        absent = absent + 1;
                                    }
                                }


                                sqlstr = "select count(*) from m_dayslist where DayValue='" + drSTUD[q]["AttDate"].ToString() + "' and  ClassID='" + Session["strClassID"] + "' and  MonthID='" + Session["MonthID"] + "' and AcademicID='" + AcademicID + "'";
                                iCnt = Convert.ToInt32(utl.ExecuteScalar(sqlstr));
                                if (iCnt == 0)
                                {
                                    str.Append(@"<td style='vertical-align: top;color:Red ; text-align: center;'><p align=center>-</p></td><td  style='vertical-align: top;color:Red ; text-align: center;'><p align=center>-</p></td>");
                                }
                                else
                                {
                                    if (drSTUD[q]["ForeNoon"].ToString() == "A")
                                    {
                                        str.Append(@"<td style='vertical-align: top;color:Red ; text-align: center;'><p align=center>" + drSTUD[q]["ForeNoon"].ToString() + "</p></td>");
                                    }
                                    else
                                    {
                                        str.Append(@"<td style='vertical-align: top;color:Black ; text-align: center;'><p align=center>" + drSTUD[q]["ForeNoon"].ToString() + "</p></td>");
                                    }
                                    if (drSTUD[q]["AfterNoon"].ToString() == "A")
                                    {
                                        str.Append(@"<td  style='vertical-align: top;color:Red ; text-align: center;'><p align=center>" + drSTUD[q]["AfterNoon"].ToString() + "</p></td>");
                                    }
                                    else
                                    {
                                        str.Append(@"<td  style='vertical-align: top;color:Black ; text-align: center;'><p align=center>" + drSTUD[q]["AfterNoon"].ToString() + "</p></td>");
                                    }
                                }

                            }


                        }

                        double total = Convert.ToDouble(present / 2) + Convert.ToDouble(absent / 2);

                        str.Append(@"<td style='vertical-align: top;text-align: center;'>" + (present / 2).ToString() + "</td><td style='vertical-align: top;text-align: center;'>" + (absent / 2).ToString() + "</td><td style='vertical-align: top;text-align: center;'>" + total.ToString() + "</td>");

                        str.Append(@"</tr>");
                        examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();

                    }
                }

                str.Append(@"</table>");
                dvCard.InnerHtml = str.ToString();
            }
            else
            {
                dvCard.InnerHtml = str.ToString();
            }
        }
    }
}