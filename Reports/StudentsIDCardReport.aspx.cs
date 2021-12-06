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
using System.util;
using System.Net;
using System.Xml;
public partial class Reports_StudentsIDCardReport : System.Web.UI.Page
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
             //DataTable1 = utl.GetDataTable("sp_getstudentactiveinfo" + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "'" + strClassID + "'" + "," + "'" + strSectionID + "'" + "," + "'" + Session["AcademicID"] + "'");
            DataTable1 = utl.GetDataTable("sp_getstudentactiveinfo" + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "'" + strClassID + "'" + "," + "'" + strSectionID + "'");
            if (DataTable1.Rows.Count > 0)
            {
                StringBuilder str = new StringBuilder();
                str.Append("<br><table border='0' style='padding:15px;' width='1800'><tr>");
                int x = 8;
                for (int i = 0; i < DataTable1.Rows.Count; i++)
                {
                    str.Append(@"<td valign='top'><table border='0' cellpadding='3' cellspacing='3' style='width:280px;font-family:arial;font-size:11px;border:1px solid #ccc;'><tr ><td> REG NO<td>:</td><td>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td><td rowspan='3'><img src='../Students/Photos/" + DataTable1.Rows[i]["PhotoFile"].ToString() + "' width='70'  /></td></tr><tr><td> CLASS<td>:</td><td>" + DataTable1.Rows[i]["Class"].ToString() + "</td></tr><tr><td> SECTION<td>:</td><td>" + DataTable1.Rows[i]["Section"].ToString() + "</td></tr><tr><td> NAME<td>:</td><td colspan='3'><strong>" + DataTable1.Rows[i]["StudentName"].ToString() + "</strong></td></tr><tr><td> DOB<td>:</td><td colspan='3'>" + DataTable1.Rows[i]["DOB"].ToString() + "</td></tr><tr><td> BLOOD GROUP<td>:</td><td colspan='3'>" + DataTable1.Rows[i]["BloodGroup"].ToString() + "</td></tr><tr><td> FATHER<td>:</td><td colspan='3'>" + DataTable1.Rows[i]["FName"].ToString() + "</td></tr><tr><td> FATHER CELL<td>:</td><td colspan='3'>" + DataTable1.Rows[i]["FatherCell"].ToString() + "</td></tr><tr><td> MOTHER<td>:</td><td>" + DataTable1.Rows[i]["MName"].ToString() + "</td></tr><tr><td> MOTHER CELL<td>:</td><td colspan='3'>" + DataTable1.Rows[i]["MotherCell"].ToString() + "</td></tr><tr><td> CONTACT NO<td>:</td><td colspan='3'>" + DataTable1.Rows[i]["PhoneNo"].ToString() + "</td></tr><tr><td colspan='4'>ADDRESS :<br/> " + DataTable1.Rows[i]["PerAddr"].ToString() + "</td></tr></table></td>");
                    if (i > 0)
                    {

                        if (((i + 1) % 6) == 0)
                        {
                            str.Append(@"</tr><tr><td height='20' colspan='6'></td></tr><tr>");
                        }

                        if (((i + 1) % 18) == 0)
                        {
                            str.Append(@"</tr></table>  <p class='pagebreakhere' style='page-break-after: always; color: Red;'></p><br><table border='0' style='padding:15px;' width='1800' ><tr>");
                        }


                    }

                }
                str.Append(@"</tr></table>");
                dvCard.InnerHtml = str.ToString();

            }

        }

    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        string str = dvCard.InnerHtml;
        StringReader sr = new StringReader(str.ToString());
        Document pdfDoc = new Document();
        pdfDoc.SetPageSize(PageSize.A3.Rotate());
        pdfDoc.SetMargins(5f, 5f, 5f, 5f);
        HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
        PdfWriter.GetInstance(pdfDoc, new FileStream("d:\\IDCardList.pdf", FileMode.Create));
        pdfDoc.Open();
        htmlparser.Parse(sr);
        pdfDoc.Close();
        pdfDoc.Dispose();
        htmlparser.Dispose();
        sr.Dispose();
        Response.AppendHeader("Content-Disposition", "attachment; filename=IDCardList.pdf");
        Response.TransmitFile("d:\\IDCardList.pdf");
        Response.End();
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