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


public partial class BirthdayWishes_BirthdayWishes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
        scriptManager.RegisterPostBackControl(this.btnExport);
        divBdayList.Visible = false;
        BindBirthdayList(string.Empty);
        if (!Page.IsPostBack)
            BindTemplate();
    }
    private void BindBirthdayList(string date)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        if (date == string.Empty)
            sqlstr = "SP_GETBIRTHDAYLIST";
        else
            sqlstr = "SP_GETBIRTHDAYLIST '" + date + "'";
        DataSet ds = new DataSet();
        ds = utl.GetDataset(sqlstr);
        lstStaff.Items.Clear();
        lstStudent.Items.Clear();
        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            lstStaff.DataSource = ds.Tables[0];
            lstStaff.DataTextField = "StaffName";
            lstStaff.DataValueField = "StaffId";
            lstStaff.DataBind();
        }
        else
        {
           
            lstStaff.DataSource = null;
            lstStaff.DataBind();
        }
        if (ds != null && ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 1)
        {
            lstStudent.DataSource = ds.Tables[1];
            lstStudent.DataTextField = "StName";
            lstStudent.DataValueField = "StudentId";
            lstStudent.DataBind();
        }
        else
        {
           
            lstStudent.DataSource = null;
            lstStudent.DataBind();
        }
    }
    private void BindTemplate()
    {
        Utilities utl = new Utilities();
        string sqlstr = "SP_GETTemplates";
        DataSet ds = new DataSet();
        ds = utl.GetDataset(sqlstr);
        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            dpTemplateList.DataSource = ds.Tables[0];
            dpTemplateList.DataTextField = "TemplateName";
            dpTemplateList.DataValueField = "TemplateId";
            dpTemplateList.DataBind();
        }
        else
        {
            dpTemplateList.DataSource = null;
            dpTemplateList.DataBind();
        }
    }
    [WebMethod]
    public static string GetList(string date)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        string formattedDate = string.Empty;
        string[] formats = { "dd/MM/yyyy" };
        formattedDate = DateTime.ParseExact(date, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        query = "[SP_GETBIRTHDAYLIST] '" + formattedDate + "'";
        return utl.GetDatasetTable(query, "Birthdays").GetXml();
    }

    protected void BindRepeater()
    {
        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        string formattedDate = string.Empty;
        string[] formats = { "dd/MM/yyyy" };
        formattedDate = DateTime.ParseExact(txtDate.Text, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        if (dpList.SelectedValue.ToLower() == "student")
            dt = utl.GetDataTable("exec SP_GETSTUDENTBIRTHDAYLIST '" + formattedDate + "'");
        else
            dt = utl.GetDataTable("exec SP_GETSTAFFBIRTHDAYLIST '" + formattedDate + "'");
        hdnCount.Value = dt.Rows.Count.ToString();
        PagedDataSource pgitems = new PagedDataSource();
        DataView dv = new DataView(dt);
        pgitems.DataSource = dv;
        pgitems.AllowPaging = true;
        pgitems.PageSize = 8;
        pgitems.CurrentPageIndex = PageNumber;
        if (pgitems.PageCount > 1)
        {
            rptPaging.Visible = true;
            ArrayList pages = new ArrayList();
            for (int i = 0; i < pgitems.PageCount; i++)
                pages.Add((i + 1).ToString());
            rptPaging.DataSource = pages;
            rptPaging.DataBind();
        }
        else
        {
            rptPaging.Visible = false;
        }
        rptBooks.DataSource = pgitems;
        rptBooks.DataBind();
    }
    public int PageNumber
    {
        get
        {
            if (ViewState["PageNumber"] != null)
                return Convert.ToInt32(ViewState["PageNumber"]);
            else
                return 0;
        }
        set
        {
            ViewState["PageNumber"] = value;
        }
    }
    protected void rptPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        PageNumber = Convert.ToInt32(e.CommandArgument) - 1;
        divBdayList.Visible = true;
        BindRepeater();
    }
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        if (dpTemplateList.SelectedValue == "1")
        {
            divWrapper.Attributes.Add("class", "birth_wrap");
            headWrapper.Attributes.Add("class", "birthday_heading");
        }
        else if (dpTemplateList.SelectedValue == "2")
        {
            divWrapper.Attributes.Add("class", "birth_wrap2");
            headWrapper.Attributes.Add("class", "birthday_heading2");
        }
        else if (dpTemplateList.SelectedValue == "3")
        {
            divWrapper.Attributes.Add("class", "birth_wrap3");
            headWrapper.Attributes.Add("class", "birthday_heading3");
        }
        BindRepeater();
        divBdayList.Visible = true;
        string formattedDate = string.Empty;
        string[] formats = { "dd/MM/yyyy" };
        formattedDate = DateTime.ParseExact(txtDate.Text, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        BindBirthdayList(formattedDate);
        lblDate.Text = txtDate.Text.Replace("/", " - ");


    }

    [WebMethod]
    public static string GetPrintOut(string type, string date, string index, string template)
    {
        string[] arr = index.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
        StringBuilder returnString = new StringBuilder();
        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        string formattedDate = string.Empty;
        string[] formats = { "dd/MM/yyyy" };
        formattedDate = DateTime.ParseExact(date, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        if (type.ToLower() == "student")
        {
            foreach (string s in arr)
            {

                DataSet ds = new DataSet();
                ds = utl.GetDataset("exec SP_GETSTUDENTBIRTHDAYLIST_PAGER '" + formattedDate + "'," + s + ",8,10");
                returnString.Append(GetFirstContent(date, template));
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    returnString.Append("<div class=\"birthday_phto-list\">");
                    returnString.Append("<div class=\"birthday_photo\">");
                    returnString.Append("<img src=\"" + dr["PhotoFile"].ToString() + "\" width=\"146\" height=\"147\"></div>");
                    returnString.Append("<div class=\"birthday_photo-name\">");
                    returnString.Append(dr["NAME"].ToString());
                    returnString.Append("</div>");
                    returnString.Append("</div>");
                }
                returnString.Append(GetSecondContent());

            }
        }
        else
        {
            foreach (string s in arr)
            {

                returnString.Append(GetFirstContent(date, template));
                DataSet ds = new DataSet();
                ds = utl.GetDataset("exec SP_GETSTAFFBIRTHDAYLIST_PAGER '" + formattedDate + "'," + s + ",8,10");
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    returnString.Append("<div class=\"birthday_phto-list\">");
                    returnString.Append("<div class=\"birthday_photo\">");
                    returnString.Append("<img src=\"" + dr["PhotoFile"].ToString() + "\" width=\"146\" height=\"147\"></div>");
                    returnString.Append("<div class=\"birthday_photo-name\">");
                    returnString.Append(dr["NAME"].ToString());
                    returnString.Append("</div>");
                    returnString.Append("</div>");
                }

                returnString.Append(GetSecondContent());
                //returnString.Append(utl.GetDatasetTable("exec SP_GETSTAFFBIRTHDAYLIST_PAGER '" + formattedDate + "'," + s + ",8,10", "PrintContents").GetXml());
            }
        }
        return returnString.ToString();
    }

    public static string GetFirstContent(string date, string template)
    {
        string className = string.Empty;
        string classHeadName = string.Empty;
        if (template == "1")
        {
            className = "birth_wrap";
            classHeadName = "birthday_heading";
        }
        else if (template == "2")
        {
            className = "birth_wrap2";
            classHeadName = "birthday_heading2";
        }
        else if (template == "3")
        {
            className = "birth_wrap3";
            classHeadName = "birthday_heading3";
        }

        StringBuilder returnString = new StringBuilder();
        returnString.Append("<div id=\"printDivBdayList\" class=\"birth_wrapper printDivBdayList\" style=\"display: block;\">");
        returnString.Append("<div class=\"" + className + "\">");
        returnString.Append("<div class=\"" + classHeadName + "\">");
        //returnString.Append("<br/><br/><br/><br/>");
        returnString.Append("<div class=\"txt-heading\">");
        returnString.Append("Today Birthday Celebrities -");
        returnString.Append("<label>" + date.Replace("/", " - ") + "</label></div>");
        returnString.Append("</div>");
        //returnString.Append("<br/><br/><br/><br/>");
        returnString.Append("<div class=\"clear\">");
        returnString.Append("</div>");
        returnString.Append("<div>");
        returnString.Append("<div class=\"birthday_phto-block\">");
        returnString.Append("<div class=\"appendList\">");
        returnString.Append("</div>");

        return returnString.ToString();
    }

    public static string GetSecondContent()
    {
        StringBuilder returnString = new StringBuilder();
        returnString.Append(" <div class=\"clear\">");
        returnString.Append(" </div>");
        returnString.Append(" <div class=\"\" style=\"height: 50px; width: 900px;\">");
        returnString.Append(" </div>");
        returnString.Append(" </div>");
        returnString.Append("</div>");
        returnString.Append("<div class=\"clear\">");
        returnString.Append(" </div>");
        returnString.Append("</div>");
        returnString.Append(" </div>");
        returnString.Append("<p class=\"pagebreakhere\" style=\"page-break-after: always; color:Red;\"></p>");
        return returnString.ToString();
    }
    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (dpTemplateList.SelectedValue == "1")
        {
            divWrapper.Attributes.Add("class", "birth_wrap");
            headWrapper.Attributes.Add("class", "birthday_heading");
        }
        else if (dpTemplateList.SelectedValue == "2")
        {
            divWrapper.Attributes.Add("class", "birth_wrap2");
            headWrapper.Attributes.Add("class", "birthday_heading2");
        }
        else if (dpTemplateList.SelectedValue == "3")
        {
            divWrapper.Attributes.Add("class", "birth_wrap3");
            headWrapper.Attributes.Add("class", "birthday_heading3");
        }
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string formattedDate = string.Empty;
        string[] formats = { "dd/MM/yyyy" };
        formattedDate = DateTime.ParseExact(txtDate.Text, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        if (dpList.SelectedValue.ToLower() == "student")
        {
            ds = utl.GetDataset("exec SP_ExportStudentBirthdayList '" + formattedDate + "'");
            ExportDataSetToExcel(ds, "StudentBirthdayList");
        }
        else
        {
            ds = utl.GetDataset("exec SP_ExportStaffBirthdayList '" + formattedDate + "'");
            ExportDataSetToExcel(ds, "StaffBirthdayList");
        }

    }
    public void ExportDataSetToExcel(DataSet ds, string filename)
    {
        if (ds.Tables[0].Rows.Count > 0)
        {


            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.Buffer = true;
            HttpContext.Current.Response.ContentType = "application/ms-excel";
            HttpContext.Current.Response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + filename + ".xls");

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