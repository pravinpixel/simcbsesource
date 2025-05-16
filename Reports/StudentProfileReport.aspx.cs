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

public partial class Reports_StudentProfileReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    Utilities utl = null;
    public static int Userid = 0;
    
    protected void Page_Load(object sender, EventArgs e)
    {
         
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
        ddlSection.Items.Insert(0, "-----Select-----");
    }

    protected void Page_UnLoad(object sender, EventArgs e)
    {


    }
    protected void StudentIdCardReport_Unload(object sender, EventArgs e)
    {

    }


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
            string sqlstr = "";
            if (Session["AcademicID"] != null && Session["AcademicID"].ToString() != "")
            {
                sqlstr = "select Isactive from m_academicyear where AcademicId=" + Session["AcademicID"].ToString();
                string Isactive = utl.ExecuteScalar(sqlstr);
                if (Isactive == "1" || Isactive == "True")
                {
                    sqlstr = "select * from vw_getstudent where classid='" + strClassID + "' and sectionid='" + strSectionID + "' and AcademicYear='" + Session["AcademicID"] + "'  order by StudentName";
                }
                else if (Isactive == "0" || Isactive == "False")
                {
                    sqlstr = "select * from vw_getoldstudent where classid='" + strClassID + "' and sectionid='" + strSectionID + "' and AcademicID='" + Session["AcademicID"] + "'  order by StudentName";
                }
            }
              
            
            DataTable1 = utl.GetDataTable(sqlstr);
            if (DataTable1.Rows.Count > 0)
            {
                StringBuilder str = new StringBuilder();
                str.Append("<table width='100%'><tr>");
                int x = 8;
                for (int i = 0; i < DataTable1.Rows.Count; i++)
                {
                    string Acayear = utl.ExecuteScalar("select (convert(Varchar(10),year(startdate))+' - '+convert(Varchar(10),YEAR(EndDate))) acayear from m_academicyear where academicid='"+  Session["AcademicID"] +"'");


                    str.Append(@"<td style='padding-right:30px;height:200px'><div style='margin-right:70px;'><table width='550' border='0' cellspacing='10' cellpadding='0'><tr><td style='padding-right:30px;border:1px solid #000;padding:2px;'><table width='100%' border='0' cellspacing='0' cellpadding='0' style='font-family:Arial, Helvetica, sans-serif;'><tr><td align='center' style='font-weight: bold;font-size: large;font-style: normal;'><BR>AMALORPAVAM LOURDS ACADEMY</td></tr><tr><td align='center' HEIGHT='30' style='font-weight: bold;font-size: large;font-style: normal;'>PUDUCHERRY</td></tr>");

                 str.Append(@"<tr><td align='center' style='font-weight: bold;'><BR>STUDENT DATA SHEET (" + Acayear + ")</td></tr><tr><td align='center' HEIGHT='20' style='font-weight: bold;font-size: large;font-style: normal;'></td></tr><tr><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='26%'  style='border:1px solid #000;padding:2px;  background-color: #eeeeee; height: 30px;'>Student's Name</td><td width='30%' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["StudentName"].ToString() + "</td><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='20%'  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Regn. No.</td><td width='30%' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td></tr></table></td></tr><tr><td colspan='2' height='10' ></td><td width='47%' height='10'></td></tr><tr><td style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Gender</td><td style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["Sex"].ToString() + "</td><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='20%'  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Class & Sec</td><td width='30%' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["Class"].ToString() + " &nbsp; " + DataTable1.Rows[i]["Section"].ToString() + "</td></tr></table></td></tr>");

                    str.Append(@"<tr><td colspan='2' height='10' ></td><td width='47%' height='10'></td></tr><tr><td style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Date of Birth</td><td style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["DOB"].ToString() + "</td><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='20%'  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Religion</td><td width='30%' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["Religion"].ToString() + "</td></tr></table></td></tr>");

                                                                             str.Append(@"<tr><td colspan='2' height='10' ></td><td width='47%' height='10'></td></tr><tr><td  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Father's Name</td><td style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["FName"].ToString() + "</td><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='20%'  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Father's Mobile</td><td width='30%' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["FatherCell"].ToString() + "</td></tr></table></td></tr><tr><td colspan='2' height='10' ></td><td width='47%' height='10'></td></tr><tr><td  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Mother's Name</td><td style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["MName"].ToString() + "</td><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='20%'  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Mother's Mobile</td><td width='30%' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["MotherCell"].ToString() + "</td></tr></table></td></tr><tr><td colspan='2' height='10' ></td><td width='47%' height='10'></td></tr><tr><td  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Guardian's Name</td><td style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["GName1"].ToString() + "</td><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='15%'  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Guardian's Mobile</td><td width='30%' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["GPhno1"].ToString() + "</td></tr></table></td></tr><tr><td colspan='2' height='10' ></td><td width='47%' height='10'></td></tr><tr><td style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Caste</td><td style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["Caste"].ToString() + "</td><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='40%'  style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 30px;'>Community</td><td width='63%' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["Community"].ToString() + "</td></tr></table></td></tr><tr><td colspan='2' height='10' ></td><td width='47%' height='10'></td></tr><tr><td class='addr' style='border:1px solid #000;padding:2px;background-color: #eeeeee;height: 50px;'>Postal Address for Result</td><td colspan='2' style='border:1px solid #000;padding:2px;'>" + DataTable1.Rows[i]["PerAddr"].ToString() + "</td></tr><tr><td colspan='3' height='10' ></td></tr><tr><td colspan='3'  style='border:0px solid #000;padding:2px;/*  background-color: #eeeeee;  height: 30px; */'></p><br/><br/></td></tr><tr><td colspan='3' height='10' ></td></tr><tr><td colspan='3'  style='border:1px solid #000;padding:2px;/*  background-color: #eeeeee;  height: 30px; */'>Note :Please make necessary corrections if any in <u><b>Blue Pen.</u><br><p style='font-family: diamond;'>Bjitahd jpUj;jA;fis ePyepw vGJBfhy; K}yk; jpUj;jt[k;.  </p><br/><br/><p style='text-align: right;'>Signature of the Parent<p></td></tr></table></td></tr></table></td></tr></table></div></td>");



                    if (i > 0)
                    {

                        if (((i + 1) % 2) == 0)
                        {
                            str.Append(@"</tr></table> <p class='pagebreakhere' style='page-break-after: always; color: Red;'></p><table width='100%'  style='padding-top:50px;'><tr>");
                        }


                    }

                }
                str.Append(@"</tr></table>");
                dvCard.InnerHtml = str.ToString();
            }

        }

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
                if (!IsPostBack)
                {
                    Session["strClass"] = null;
                    Session["strSection"] = null;
                    Session["strClassID"] = null;
                    Session["strSectionID"] = null;
                }
                ddlSection.DataSource = null;
                DataTable dt = new DataTable();
                utl = new Utilities();
                BindClass();

            }
        }
        catch (Exception)
        {


        }
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

        }
    }
    protected void ddlSection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSection.SelectedItem.Text == "-----Select-----" || ddlSection.SelectedItem.Value == "-----Select-----")
        {
            strSection = "";
            strSectionID = "";

        }
        else
        {
            Session["strSection"] = ddlSection.SelectedItem.Text;
            Session["strSectionID"] = ddlSection.SelectedValue;
        }
    }

}