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

public partial class Reports_BarcodeReport : System.Web.UI.Page
{
    StringBuilder str = new StringBuilder();
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
        if (strClassID != "" || txtSearch.Text != "")
        {
            DataTable DataTable1 = new DataTable();
           // DataTable1 = utl.GetDataTable("sp_getstudentactiveinfo" + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "'" + strClassID + "'" + "," + "'" + strSectionID + "'" + "," + "'" + Session["AcademicID"] + "'");
            DataTable1 = utl.GetDataTable("sp_getstudentactiveinfo" + "''" + "," + "'" + txtSearch.Text + "'" + "," + "''" + "," + "''" + "," + "'" + strClassID + "'" + "," + "'" + strSectionID + "'");
            if (ddlOption.Text == "With Photo")
            {
                if (DataTable1.Rows.Count > 0)
                {
                    str.Append("<table width='1000'><tr>");
                    int x = 8;
                    for (int i = 0; i < DataTable1.Rows.Count; i++)
                    {
                        Code39BarCode barcode = new Code39BarCode();
                        barcode.BarCodeText = DataTable1.Rows[i]["RegNo"].ToString();
                        barcode.ShowBarCodeText = true;
                        barcode.BarCodeWeight = BarCodeWeight.Small;
                        byte[] imgArr = barcode.Generate();
                        using (FileStream file = new FileStream(Server.MapPath("~\\Students\\Barcodes\\") + DataTable1.Rows[i]["RegNo"].ToString() + ".JPG", FileMode.Create, FileAccess.Write))
                        {
                            file.Write(imgArr, 0, imgArr.Length);
                        }

                        str.Append(@"<td><table width='419' border='0' cellspacing='0' cellpadding='0' style='width:419px; height:240px; margin-right:12px; float:left; font-family:Arial, Helvetica, sans-serif; font-size:14px; text-align: left; color:#3b3b3f; border:1px solid #909195; padding:5px; border-radius:5px;'><tr><td valign='top' style='padding:5px;'><table width='419' border='0' cellspacing='0' cellpadding='0'>  <tr><td valign='top'><table width='419' border='0' cellspacing='0' cellpadding='0'><tr><td height='30' colspan='2'  valign='top'><table width='419' border='0' cellspacing='0' cellpadding='0'><tr><td width='79' height='35'>NAME </td><td width='12'>:</td><td width='331'><strong>" + DataTable1.Rows[i]["StudentName"].ToString() + "</strong></td></tr></table></td></tr><tr><td width='259'  valign='top'><div style='float=left;'><table width='257'  border='0' cellpadding='0' cellspacing='0'><tr><td width='78'  height='35'>REGNO </td><td width='11'>:</td><td width='168'>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td></tr><tr><td height='35'>CLASS</td><td>:</td><td colspan='2'>" + DataTable1.Rows[i]["Class"].ToString() + "</td></tr><tr><td height='35'>SECTION </td><td>:</td><td colspan='2'>" + DataTable1.Rows[i]["Section"].ToString() + "</td></tr><tr><td align='center' valign='top' class='barcodeimage'><img style='max-width:inherit;' width='201' src= '../Students/Barcodes/" + DataTable1.Rows[i]["RegNo"].ToString() + ".JPG' /></td></tr></table></div></td><td align='right' valign='top'><img src='../Students/Photos/" + DataTable1.Rows[i]["RegNo"].ToString() + ".JPG' width='160'  /></td></tr></table></td></tr></table></td></tr></table></td>");


                        if (i > 0)
                        {

                            if (((i + 1) % 2) == 0)
                            {
                                str.Append(@"</tr><tr><td height='20'></td></tr><tr>");
                            }

                            if (((i + 1) % 10) == 0)
                            {
                                str.Append(@"</tr></table>  <p class='pagebreakhere' style='page-break-after: always; color: Red;'></p><table width='1000' height='1000' ><tr>");
                            }

                        }

                    }
                    str.Append(@"</tr></table>");
                    dvCard.InnerHtml = str.ToString();
                }
            }
            else if (ddlOption.Text == "Without Photo")
            {
                if (DataTable1.Rows.Count > 0)
                {
                   
                    str.Append("<table width='1000'><tr>");
                    int x = 8;
                    for (int i = 0; i < DataTable1.Rows.Count; i++)
                    {
                        Code39BarCode barcode = new Code39BarCode();
                        barcode.BarCodeText = DataTable1.Rows[i]["RegNo"].ToString();
                        barcode.ShowBarCodeText = true;
                        barcode.BarCodeWeight = BarCodeWeight.Small;
                        byte[] imgArr = barcode.Generate();
                        using (FileStream file = new FileStream(Server.MapPath("~\\Students\\Barcodes\\") + DataTable1.Rows[i]["RegNo"].ToString() + ".JPG", FileMode.Create, FileAccess.Write))
                        {
                            file.Write(imgArr, 0, imgArr.Length);
                        }

                        str.Append(@"<td><table width='450' border='0' cellpadding='0' cellspacing='0' style='margin-right:12px; float:left; font-family:Arial, Helvetica, sans-serif; font-size:14px; text-align: left; color:#3b3b3f; border:1px solid #909195; padding:5px; border-radius:5px; '><tr><td valign='top' style='padding:5px;'><table border='0' cellspacing='0' cellpadding='0'>  <tr><td valign='top'><table border='0' cellspacing='0' cellpadding='0'><tr><td height='30' colspan='2'  valign='top'><table width='300' border='0' cellpadding='0' cellspacing='0'><tr><td width='90' height='35'>NAME </td><td width='10'>:</td><td width='193'><strong>" + DataTable1.Rows[i]["StudentName"].ToString() + "</strong></td></tr></table></td></tr> <tr><td width='' height='80' valign='top'><div style='float=left;'><table width='280'  border='0' cellpadding='0' cellspacing='0'><tr><td height='35' width='86'>STD & SEC</td><td align='center' width='11'>:</td><td colspan='2' width='263'>" + DataTable1.Rows[i]["Class"].ToString() + " - " + DataTable1.Rows[i]["Section"].ToString() + "</td></tr><tr><td height='40'>REG NO. </td><td align='center'>:</td><td colspan='2'>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td></tr></table></div></td><td align='center' class='barcodeimage' valign='top'><img style='max-width:inherit;' width='201'  src= '../Students/Barcodes/" + DataTable1.Rows[i]["RegNo"].ToString() + ".JPG' /></td></tr></table></td></tr></table></td></tr></table></td>");



                        if (i > 0)
                        {

                            if (((i + 1) % 2) == 0)
                            {
                                str.Append(@"</tr><tr><td height='24'></td></tr><tr>");
                            }

                            if (((i + 1) % 16) == 0)
                            {
                                str.Append(@"</tr></table> <p class='pagebreakhere' style='page-break-after: always; color: Red;'></p><table width='1000'><tr>");
                            }

                        }

                    }   

                    str.Append(@"</tr></table>");
                    dvCard.InnerHtml = str.ToString();
                    //StringReader sr = new StringReader(str.ToString());
                    //Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);

                    //HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                    //if (File.Exists(Server.MapPath("~\\BarcodeReport.pdf")))
                    //{
                    //    File.Delete(Server.MapPath("~\\BarcodeReport.pdf"));
                    //}
                    //PdfWriter.GetInstance(pdfDoc, new FileStream(Server.MapPath("~\\BarcodeReport.pdf"), FileMode.Create));

                    //pdfDoc.Open();

                    //htmlparser.Parse(sr);

                    //pdfDoc.Close();

                    //pdfDoc.Dispose();
                    //htmlparser.Dispose();
                    //sr.Dispose();

                }
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


    protected void btnPrintExport_Click(object sender, EventArgs e)
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
            DataTable1 = utl.GetDataTable("sp_getstudentactiveinfo" + "''" + "," + "''" + "," + "''" + "," + "''" + "," + "'" + strClassID + "'" + "," + "'" + strSectionID + "'");
            if (ddlOption.Text == "With Photo")
            {
                if (DataTable1.Rows.Count > 0)
                {
                    str.Append("<table width='1000'><tr>");
                    int x = 8;
                    for (int i = 0; i < DataTable1.Rows.Count; i++)
                    {
                        
                        str.Append(@"<td><table width='419' border='0' cellspacing='0' cellpadding='0' style='width:419px; height:240px; margin-right:12px; float:left; font-family:Arial, Helvetica, sans-serif; font-size:14px; text-align: left; color:#3b3b3f; border:1px solid #909195; padding:5px; border-radius:5px; '>
   <tr>
   <td valign='top' style='padding:5px;'><table width='419' border='0' cellspacing='0' cellpadding='0'>  <tr><td valign='top'><table width='419' border='0' cellspacing='0' cellpadding='0'><tr><td height='30' colspan='2'  valign='top'><table width='419' border='0' cellspacing='0' cellpadding='0'><tr><td width='79' height='35'>NAME </td><td width='12'>:</td><td width='331'><strong>" + DataTable1.Rows[i]["StudentName"].ToString() + "</strong></td></tr></table></td></tr><tr><td width='259'  valign='top'><div style='float=left;'><table width='257'  border='0' cellpadding='0' cellspacing='0'><tr><td width='78'  height='35'>REGNO </td><td width='11'>:</td><td width='168'>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td></tr><tr><td height='35'>CLASS</td><td>:</td><td colspan='2'>" + DataTable1.Rows[i]["Class"].ToString() + "</td></tr><tr><td height='35'>SECTION </td><td>:</td><td colspan='2'>" + DataTable1.Rows[i]["Section"].ToString() + "</td></tr><tr><td align='center' valign='top'><img class='barcode' src= " + string.Format("../Handlers/ShowCode39BarCode.ashx?code={0}&ShowText={1}&Thickness={2}", DataTable1.Rows[i]["RegNo"].ToString(), 1, 1) + " /></td></tr></table></div></td><td align='right' valign='top'><img src='" + Server.MapPath("~/Students/Photos/" + DataTable1.Rows[i]["RegNo"].ToString() + ".JPG") + "' width='180'  /></td></tr></table></td></tr></table></td></tr></table></td>");




                        if (i > 0)
                        {

                            if (((i + 1) % 2) == 0)
                            {
                                str.Append(@"</tr><tr><td height='20'></td></tr><tr>");
                            }

                            if (((i + 1) % 10) == 0)
                            {
                                str.Append(@"</tr></table>  <p class='pagebreakhere' style='page-break-after: always; color: Red;'></p><table width='1000' height='1000' ><tr>");
                            }


                        }

                    }
                    str.Append(@"</tr></table>");
                    dvCard.InnerHtml = str.ToString();
                }
            }
            else if (ddlOption.Text == "Without Photo")
            {
                if (DataTable1.Rows.Count > 0)
                {

                    str.Append("<table width='1000'><tr>");
                    int x = 8;
                    for (int i = 0; i < DataTable1.Rows.Count; i++)
                    {
                        
                        str.Append(@"<td><table border='0' cellspacing='0' cellpadding='0' style='margin-right:12px; float:left; font-family:Arial, Helvetica, sans-serif; font-size:14px; text-align: left; color:#3b3b3f; border:1px solid #909195; padding:5px; border-radius:5px; '>
  <tr>
    <td valign='top' style='padding:5px;'><table border='0' cellspacing='0' cellpadding='0'>  <tr><td valign='top'><table  border='0' cellspacing='0' cellpadding='0'><tr><td height='30' colspan='2'  valign='top'><table width: 150px; border='0' cellspacing='0' cellpadding='0'><tr><td width='79' height='35'>NAME </td><td width='12'>:</td><td width='250'><strong>" + DataTable1.Rows[i]["StudentName"].ToString() + "</strong></td></tr></table></td></tr><tr><td valign='top'><div style='float=left;'><table  border='0' cellpadding='0' cellspacing='0'><tr><td width='78'  height='35'>REGNO </td><td width='11'>:</td><td>" + DataTable1.Rows[i]["RegNo"].ToString() + "</td></tr><tr><td height='35'>CLASS</td><td>:</td><td colspan='2'>" + DataTable1.Rows[i]["Class"].ToString() + "</td></tr><tr><td height='35'>SECTION </td><td>:</td><td colspan='2'>" + DataTable1.Rows[i]["Section"].ToString() + "</td></tr></table></div></td><td align='center' valign='top'><img class='barcode' src= " + string.Format("../Handlers/ShowCode39BarCode.ashx?code={0}&ShowText={1}&Thickness={2}", DataTable1.Rows[i]["RegNo"].ToString(), 1, 1) + " /></td></tr></table></td></tr></table></td></tr></table></td>");



                        if (i > 0)
                        {

                            if (((i + 1) % 2) == 0)
                            {
                                str.Append(@"</tr><tr><td height='20'></td></tr><tr>");
                            }

                            if (((i + 1) % 12) == 0)
                            {
                                str.Append(@"</tr></table> <p class='pagebreakhere' style='page-break-after: always; color: Red;'></p><table width='1000' height='1000' ><tr>");
                            }


                        }

                    }

                    str.Append(@"</tr></table>");                   
                    Directory.CreateDirectory(Request.PhysicalApplicationPath + "/Pdf/");
                    StringReader sr = new StringReader(str.ToString());
                    Document pdfDoc = new Document(PageSize.A4_LANDSCAPE, 0f, 0f, 0f, 0f);
                  
                    HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                    if (File.Exists(Request.PhysicalApplicationPath + "\\Pdf\\BarcodeReport.pdf"))
                    {
                        File.Delete(Request.PhysicalApplicationPath +"\\Pdf\\BarcodeReport.pdf");
                    }
                    PdfWriter.GetInstance(pdfDoc, new FileStream(Request.PhysicalApplicationPath + "\\Pdf\\BarcodeReport.pdf" , FileMode.Create));

                    pdfDoc.Open();

                    htmlparser.Parse(sr);

                    pdfDoc.Close();

                    pdfDoc.Dispose();
                    htmlparser.Dispose();
                    sr.Dispose();

                }
            }
        }
    }
    
}