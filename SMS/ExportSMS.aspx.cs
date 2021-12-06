using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Globalization;
using System.Collections;
using System.Text;
using System.IO;
using Excel = Microsoft.Office.Interop.Excel;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Reflection;

public partial class SMS_ExportSMS : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
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
                BindDummyRow();
                txtDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            }
          
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("MessageType");
            dummy.Columns.Add("ReceiverType");
            dummy.Columns.Add("MessageCount");
            dummy.Rows.Add();
            dgSMSList.DataSource = dummy;
            dgSMSList.DataBind();
        }
    }
    [WebMethod]
    public static string GetMessageList(string MessageDate)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "GetApprovedSMSList '" + MessageDate + "'";
        return utl.GetDatasetTable(query, "SMS").GetXml();
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
         Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string AttDate = "";
        if (txtDate.Text != "")
        {
            string[] myDateTimeString = txtDate.Text.Split('/');
            AttDate = "'" + myDateTimeString[1] + "/" + myDateTimeString[0] + "/" + myDateTimeString[2] + "'";
        }
        string query = "GetApprovedSMSListByType " + AttDate + "";
        ds = utl.GetDataset(query);
        if (ds.Tables[0].Rows.Count > 0)
        {
            ExportDataSetToExcel(ds);
        }
    }     
    protected void ExportDataSetToExcel(DataSet ds)
    {
        if (ds.Tables[0].Rows.Count > 0)
        {
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.Buffer = true;
            HttpContext.Current.Response.ContentType = "application/ms-excel";
            HttpContext.Current.Response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=SMSList.xls");

            HttpContext.Current.Response.Charset = "utf-8";
            HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1250");
            //sets font
            HttpContext.Current.Response.Write("<font style='font-size:10.0pt; font-family:Calibri;'>");
            HttpContext.Current.Response.Write("<BR><BR><BR>");
            //sets the table border, cell spacing, border color, font of the text, background, foreground, font height
            HttpContext.Current.Response.Write("<Table border='1' bgColor='#ffffff' " +
              "borderColor='#000000' cellSpacing='0' cellPadding='0' " +
              "style='font-size:10.0pt; font-family:Calibri; background:white;'> <TR>");
            //am getting my grid's column headers
            int columnscount = ds.Tables[0].Columns.Count;

            for (int j = 0; j < columnscount; j++)
            {      //write in new column
                HttpContext.Current.Response.Write("<Td>");
                //Get column headers  and make it as bold in excel columns
                HttpContext.Current.Response.Write("<B>");
                HttpContext.Current.Response.Write(ds.Tables[0].Columns[j].ColumnName.ToString());
                HttpContext.Current.Response.Write("</B>");
                HttpContext.Current.Response.Write("</Td>");
            }
            HttpContext.Current.Response.Write("</TR>");
            foreach (DataRow row in ds.Tables[0].Rows)
            {//write in new row
                HttpContext.Current.Response.Write("<TR>");
                for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                {
                    HttpContext.Current.Response.Write("<Td>");
                    HttpContext.Current.Response.Write(row[i].ToString());
                    HttpContext.Current.Response.Write("</Td>");
                }

                HttpContext.Current.Response.Write("</TR>");
            }
            HttpContext.Current.Response.Write("</Table>");
            HttpContext.Current.Response.Write("</font>");
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.End();
        }

    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        return;
    }
}