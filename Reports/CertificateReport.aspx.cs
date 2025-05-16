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


public partial class Performance_CertificateReport : System.Web.UI.Page
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

    string strCompfor = "";
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
                BindTemplate();
                BindClass();
                BindType();
                utl = new Utilities();
                utl.ExecuteQuery("DeleteDuplicate '" + AcademicID + "'");
                DataTable dtSchool = new DataTable();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            }
        }
    }

    private void BindType()
    {
        utl = new Utilities();
        DataSet dsType = new DataSet();
        dsType = utl.GetDataset("select distinct title,AcademicId from s_Certificate order by AcademicId desc");
        if (dsType != null && dsType.Tables.Count > 0 && dsType.Tables[0].Rows.Count > 0)
        {
            ddlType.DataSource = dsType.Tables[0];
            ddlType.DataTextField = "title";
            ddlType.DataValueField = "title";
            ddlType.DataBind();
        }
        else
        {
            ddlType.DataSource = null;
            ddlType.DataTextField = "";
            ddlType.DataValueField = "";
            ddlType.DataBind();
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

    protected void BindTemplate()
    {
        utl = new Utilities();
        DataSet dsTemp = new DataSet();
        dsTemp = utl.GetDataset("sp_GetTemplate");
        if (dsTemp != null && dsTemp.Tables.Count > 0 && dsTemp.Tables[0].Rows.Count > 0)
        {
            ddlTmp.DataSource = dsTemp;
            ddlTmp.DataTextField = "CertificateTypeName";
            ddlTmp.DataValueField = "CertificateTypeName";
            ddlTmp.DataBind();
        }
        else
        {
            ddlTmp.DataSource = null;
            ddlTmp.DataTextField = "";
            ddlTmp.DataValueField = "";
            ddlTmp.DataBind();
        }
    }

    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {

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
        BindSectionByClass();
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



    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            LOAD_RESULT();
        }

        catch (Exception ex)
        {
            ClientScript.RegisterClientScriptBlock(this.GetType(), "bnn", "<script>jAlert('" + ex.Message + "')</script>");
        }
    }


    //Main Search Function

    string stroption;
    StringBuilder dvContent = new StringBuilder();
    DataSet dsGet = new DataSet();
    string examnochk = string.Empty;
    string printdata = "";
    private void LOAD_RESULT()
    {
        try
        {
            printdata = DISPLAY();
        }
        catch
        {

        }
        //Normal Type only - Samacheer and General Result

        dvContent.Append(printdata);
        dvCard.InnerHtml = dvContent.ToString();
    }



    string acadamicyear;
    private string DISPLAY()
    {
        utl = new Utilities();
        string sqlqry = "select YEAR(StartDate) from m_academicyear where AcademicId='" + AcademicID + "'";
        acadamicyear = utl.ExecuteScalar(sqlqry);
        
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        HttpContext.Current.Session["Isactive"] = Isactive.ToString();

        if (Session["strCompfor"].ToString() != "")
        {
            if (Isactive == "True")
            {
                sqlstr = "[sp_GetStudentCertificateInfoByTemplate] '" + AcademicID + "','" + ddlClass.SelectedValue + "','" + ddlSection.SelectedValue + "'," + "'" + ddlTmp.SelectedValue + "'" + ",'" + ddlPrint.SelectedValue + "','" + ddlType.Text + "','" + txtSearch.Text + "'";
            }
            else
            {
                sqlstr = "[sp_GetOldStudentCertificateInfoByTemplate] '" + AcademicID + "','" + ddlClass.SelectedValue + "','" + ddlSection.SelectedValue + "'," + "'" + ddlTmp.SelectedValue + "'" + ",'" + ddlPrint.SelectedValue + "','" + ddlType.Text + "','" + txtSearch.Text + "'";
            }
            dsGet = utl.GetDataset(sqlstr);
        }
        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {
                //if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                //{
                string photofile = "../Students/Photos/" + dsGet.Tables[0].Rows[i]["Photo"].ToString().ToUpper() + "";
                if (!File.Exists(Server.MapPath("../Students/Photos/" + dsGet.Tables[0].Rows[i]["Photo"].ToString().ToUpper() + "")))
                {
                    photofile = "../Students/Photos/noimage.jpg";
                }

                string TemplateName = "../Masters/Templates/" + dsGet.Tables[0].Rows[i]["TemplateName"].ToString() + "";
                if (!File.Exists(Server.MapPath("../Masters/Templates/" + dsGet.Tables[0].Rows[i]["TemplateName"].ToString() + "")))
                {
                    TemplateName = "../Masters/Templates/noimage.jpg";
                }
                //style='background-repeat: no-repeat;margin: 0 auto;background-image: url(" + TemplateName + ")'
                stroption += @"<div class='merit-certificate'> <table width='800px' border='0' cellspacing='0' cellpadding='0' class='merit-bg'>";

                DataRow[] drExamPattern = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");

                if (drExamPattern.Length > 0)
                {
                    string crttpe = "";
                    if (dsGet.Tables[0].Rows[i]["remarks"].ToString().Replace("\n", "").ToUpper() == "WINNER")
                    {
                        crttpe = "Merit";
                    }
                    else
                    {
                        crttpe = "Participation";
                    }

                    stroption += @"<tr> <td height='1130px' align='center' valign='top' style=' padding-top: 8%;'> <table width='90%' border='0' cellspacing='0' cellpadding='0' class='merit-table' > <col width='35%'></col> <col width='65%'></col><tr><td colspan='2' style='text-align: center;'><img src='" + photofile + "' width='130px' height='150px'  /></td></tr> <tr><td colspan='2' style='text-align: center;font-size: 45px;text-transform: uppercase;color: #00abed;'>Certificate of " + crttpe.ToString().ToUpper() + "</td></tr> <tr> <td class='label'>Name:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString().ToUpper() + "</div></td></tr><tr> <td class='label'>Register No:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString().ToUpper() + "</div></td></tr><tr> <td class='label'>Class & Sec:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["Class"].ToString().ToUpper() + " - " + dsGet.Tables[0].Rows[i]["Section"].ToString().ToUpper() + "</div></td></tr><tr> <td class='label'>Name of the Program:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["eventname"].ToString().ToUpper() + "</div></td></tr><tr> <td class='label'>Date of the Program:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["compdate"].ToString().ToUpper() + "</div></td></tr><tr><td class='label'>Name of the Event:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["awardtype"].ToString().ToUpper() + "</div></td></tr>";
                    //if (dsGet.Tables[0].Rows[i]["result"].ToString() == "Winner")
                    //{
                    //if (dsGet.Tables[0].Rows[i]["position"].ToString().ToUpper() == "WINNER")
                    //{
                    //    stroption += @"<tr> <td class='label'>Result:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["position"].ToString().ToUpper() + "</div></td></tr></table> </td></tr>";
                    //}
                    //else
                    //{
                    //    stroption += @"<tr> <td class='label'>Result:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["position"].ToString().ToUpper() + " Prize</div></td></tr></table> </td></tr>";
                    //    //}								

                    //}
                    stroption += @"<tr> <td class='label'>Result:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["position"].ToString().ToUpper() + " Prize</div></td></tr>";

                    stroption += @"</table> </td></tr>";
                    //<tr> <td class='label'>Name of the Competition:</td><td> <div class='value'> " + dsGet.Tables[0].Rows[i]["title"].ToString().ToUpper() + "</div></td></tr>
                    //<tr> <td class='label'>Position:</td><td> <div class='value'>" + dsGet.Tables[0].Rows[i]["remarks"].ToString().ToUpper() + "</div></td></tr>
                }

                stroption += @"</table> </div>";
                // }

                // examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
            }
        }
        return stroption;
    }


    protected void ddlTmp_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlTmp.SelectedItem.Text == "---Select---" || ddlTmp.SelectedItem.Value == "---Select---")
        {
            strCompfor = "";
            Session["strCompfor"] = "";

        }
        else
        {
            Session["strCompfor"] = ddlTmp.SelectedItem.Text;
            strCompfor = "";

        }
    }
}