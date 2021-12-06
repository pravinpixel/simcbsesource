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

public partial class Reports_TCVerificationRpt : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
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
            if (!IsPostBack)
            {
                Session["SectionID"] = null;
                BindClass();

            }
        }
    }


    private void BindClass()
    {
        utl = new Utilities();
        sqlstr = "sp_GetClass";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlClass.DataSource = dt;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataBind();
            ddlClass.SelectedIndex = 0;
        }
        // ddlClass.Items.Insert(0, new ListItem("-- Select--", ""));      
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
        ddlSection.Items.Insert(0, new ListItem("--Select---", ""));
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
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder dvContent = new StringBuilder();
        Utilities utl = new Utilities();
        DataSet dsGet = new DataSet();
        DataSet drCourseStudy = new DataSet();

        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            dsGet = utl.GetDataset("exec SP_GETTCVerification '','" + Session["strClassID"] + "','" + Session["strSectionID"] + "','" + HttpContext.Current.Session["AcademicID"] + "'");
        }
        else
        {
            dsGet = utl.GetDataset("exec SP_GETOldTCVerification '','" + Session["strClassID"] + "','" + Session["strSectionID"] + "','" + HttpContext.Current.Session["AcademicID"] + "'");
        }


       

        if (dsGet.Tables[0].Rows.Count > 0)
        {
            DataTable dtSchool = new DataTable();
            dtSchool = utl.GetDataTable("exec sp_schoolDetails");

            dvContent.Append("<br><table class='form' width='1000'><tr><td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td><tr><tr><td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>TC VERIFICATION REPORT</td></tr></table>");

            dvContent.Append("<table class='performancedata'  border=1 cellspacing=5 cellpadding=10><tr><thead><th >School Name</th><th >Education District</th><th >RegNo</th><th >Pupil Name</th><th>Class</th><th>Section</th><th>Father/Mother Name</th><th>Nationality and Religion</th><th>Community</th><th>Sex</th><th>DOB</th><th>Identification Marks</th><th>Date of Admission and Std</th><th> leaving Class</th><th>Scholarship</th><th>Medical inspection</th><th style='Width:200px;'>Immediate School</th><th style='Width:200px;'>Present School</th></thead></tr>");

            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {
                //DataRow[] drCourseStudy = dsGet.Tables[0].Select("regno=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");

                dvContent.Append("<tr><td >" + dsGet.Tables[0].Rows[i]["SchoolName"].ToString() + "</td><td >" + dsGet.Tables[0].Rows[i]["SchoolDist"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Name"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["classname"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["sectionname"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ParentName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Nationality"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Community"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Gender"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["IdMarks"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["DOA"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Class"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Scholarship"].ToString() + "</td><td>YES</td>");

                sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                Isactive = utl.ExecuteScalar(sqlstr);
                query = "";
                if (Isactive == "True")
                {
                    query = "sp_getTCCourseStudy " + dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                }
                else
                {
                    query = "sp_getPromoTCCourseStudy " + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "," + HttpContext.Current.Session["AcademicID"].ToString();
                }


                drCourseStudy = utl.GetDataset(query);

                if (drCourseStudy.Tables[0].Rows.Count > 0)
                {
                    for (int j = 0; j < drCourseStudy.Tables[0].Rows.Count; j++)
                    {
                        string type = drCourseStudy.Tables[0].Rows[j]["Type"].ToString();
                        if (drCourseStudy.Tables[0].Rows.Count > 1)
                        {
                            if (type == "Present")
                            {
                                if (drCourseStudy.Tables[0].Rows[j]["schooladdr"].ToString() != null)
                                {

                                    dvContent.Append("<td>" + drCourseStudy.Tables[0].Rows[j]["schooladdr"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["acdyears"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["classes"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["firstlang"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["mis"].ToString() + "</td>");
                                }

                            }
                            else if (type == "Immediate")
                            {
                                if (drCourseStudy.Tables[0].Rows[j]["schooladdr"].ToString() != null)
                                {
                                    dvContent.Append("<td>" + drCourseStudy.Tables[0].Rows[j]["schooladdr"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["acdyears"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["classes"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["firstlang"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["mis"].ToString() + "</td>");

                                }
                            }
                        }
                        else if (drCourseStudy.Tables[0].Rows.Count == 1)
                        {
                            if (type == "Present")
                            {
                                if (drCourseStudy.Tables[0].Rows[j]["schooladdr"].ToString() != null)
                                {
                                    dvContent.Append("<td>N/A</td>");
                                    dvContent.Append("<td>" + drCourseStudy.Tables[0].Rows[j]["schooladdr"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["acdyears"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["classes"].ToString() + "; " + drCourseStudy.Tables[0].Rows[j]["firstlang"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["mis"].ToString() + "</td>");
                                }

                            }
                            else if (type == "Immediate")
                            {
                                if (drCourseStudy.Tables[0].Rows[j]["schooladdr"].ToString() != null)
                                {
                                    dvContent.Append("<td>" + drCourseStudy.Tables[0].Rows[j]["schooladdr"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["acdyears"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["classes"].ToString() + "; " + drCourseStudy.Tables[0].Rows[j]["firstlang"].ToString() + " ; " + drCourseStudy.Tables[0].Rows[j]["mis"].ToString() + "</td>");
                                    dvContent.Append("<td>N/A</td>");
                                }
                            }
                        }

                    }
                }

                else
                {
                    dvContent.Append("<td>&nbsp;</td><td>&nbsp;</td>");
                }



            }
            dvContent.Append("</tr></table>");
            RptContent.InnerHtml = dvContent.ToString();
        }

        else
        {
            RptContent.InnerHtml = string.Empty;
        }

    }
   
}