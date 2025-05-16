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

public partial class Reports_ExamNoReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    Utilities utl = null;
    public static int Userid = 0;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        BindClass();
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
            DataTable1 = utl.GetDataTable("select * from Vw_GetStudent where ClassID='" + strClassID + "' and sectionid='" + strSectionID + "'");
            if (DataTable1.Rows.Count > 0)
            {
                StringBuilder str = new StringBuilder();
                DataTable dtSchool = new DataTable();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                str.Append("<br><table class='form' cellspacing='1' cellpadding='1' width='1000'><tr>");
                str.Append("<td align='center' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td><tr><tr><td align='center'  style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>EXAM NO. REPORT - " + Session["strClass"].ToString().ToUpper() + " Standard "+ Session["strSection"].ToString().ToUpper() + " Section</td></tr></table>");

                str.Append("<table class='performancedata'  border=1 cellspacing=5 cellpadding=10 width=100%><tr><td align='left'><label>Sl.No.</label></td><td align='left'><label>RegNo</label></td><td align='left'><label>StudentName</label></td><td align='left'><label>ExamNo</label></td><td align='left'><label>Class</label></td><td align='left'><label>Section</label></td><td align='left'><label>Photo</label></td></tr>");

                for (int i = 0; i < DataTable1.Rows.Count; i++)
                {
                    str.Append(@"<tr height='50px'><td>" + (i + 1).ToString() + "</td><td>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td><td>" + DataTable1.Rows[i]["StudentName"].ToString() + "</td><td>" + DataTable1.Rows[i]["ExamNo"].ToString() + "</td><td>" + DataTable1.Rows[i]["Class"].ToString() + "</td><td>" + DataTable1.Rows[i]["Section"].ToString() + "</td><td  style='height: 80px;' align='left' valign='top'><img src='../Students/Photos/" + DataTable1.Rows[i]["PhotoFile"].ToString() + "' width='80'/></td></tr>");
                    
                }
                str.Append(@"</table>");
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