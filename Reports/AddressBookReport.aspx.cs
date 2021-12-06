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
public partial class Reports_AddressBookReport : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
    string strAddressBookID = "";
    string strAddressBook = "";
    Utilities utl = null;
    public static int Userid = 0;
    StringBuilder str = new StringBuilder();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindClass();
            ddlClass.Enabled = false;
            ddlSection.Enabled = false;
        }

    }
    protected void AddressBook_Init(object sender, EventArgs e)
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
        if (ddlSection.SelectedValue == string.Empty)
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
        ddlSection.Items.Insert(0, new System.Web.UI.WebControls.ListItem("---Select---", ""));
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
                    ddlAddressBook.DataSource = null;
                    Session["strAddressBook"] = null;
                    Session["strAddressBookID"] = null;

                    Session["strAddressBook"] = "";
                    Session["strAddressBookID"] = "";
                    strClass = "";
                    strClassID = "";
                    strSection = "";
                    strSectionID = "";
                    Session["strSection"] = "";
                    Session["strClass"] = "";
                    Session["strSectionID"] = "";
                    Session["strClassID"] = "";
                }
                DataTable dt = new DataTable();
                utl = new Utilities();
            }
        }
        catch (Exception)
        {

        }
    }

    protected void ddlAddressBook_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["strAddressBook"] = "";
        Session["strAddressBookID"] = "";
        strClass = "";
        strClassID = "";
        strSection = "";
        strSectionID = "";
        Session["strSection"] = "";
        Session["strClass"] = "";
        Session["strSectionID"] = "";
        Session["strClassID"] = "";
        ddlClass.SelectedIndex = -1;
        ddlSection.SelectedIndex = -1;
        if (ddlAddressBook.SelectedItem.Text == "-----Select-----" || ddlAddressBook.SelectedItem.Value == "-----Select-----")
        {
            Session["strAddressBook"] = "";
            Session["strAddressBookID"] = "";

        }
        else
        {
            Session["strAddressBook"] = ddlAddressBook.SelectedItem.Text;
            Session["strAddressBookID"] = ddlAddressBook.SelectedValue;
            if (ddlAddressBook.SelectedItem.Text == "Student")
            {
                ddlClass.Enabled = true;
                ddlSection.Enabled = true;
            }
            else
            {
                ddlClass.Enabled = false;
                ddlSection.Enabled = false;
            }

        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (Session["strAddressBookID"] != null && Session["strAddressBookID"].ToString() != "")
        {
            strAddressBookID = Session["strAddressBookID"].ToString();
        }


        if (Session["strAddressBook"] != null && Session["strAddressBook"].ToString() != "")
        {
            strAddressBook = Session["strAddressBook"].ToString();
        }


        if (strAddressBook == "")
        {
            strAddressBook = "All Addresses";
        }


        DataTable DataTable1 = new DataTable();
        DataTable1 = utl.GetDataTable("sp_GetAddressReport " + "'" + strAddressBookID + "','" + Session["strClassID"].ToString() + "','" + Session["strSectionID"].ToString() + "'");
        if (DataTable1.Rows.Count > 0)
        {

            str.Append("<table width='1000'><tr>");

            for (int i = 0; i < DataTable1.Rows.Count; i++)
            {

                str.Append(@"<td><table border='0' cellspacing='0' cellpadding='0' style='margin-right:12px; float:left; font-family:times new roman; font-size:16px; text-align: left; color:#3b3b3f; border:0px solid #909195; padding:5px; border-radius:5px; '>
  <tr>
    <td valign='top'  style='padding:5px;height:130px;'><table border='0' cellspacing='0' cellpadding='0'><tr><td valign='top'><table  border='0' cellspacing='0' cellpadding='0'><tr><td height='30' colspan='2'  valign='top'><table width: 150px; border='0' cellspacing='0' cellpadding='0' ><tr><td width='350'><strong>" + DataTable1.Rows[i]["Name"].ToString().ToUpper() + "</strong></td></tr></table></td></tr><tr><td valign='top'><div style='float=left;'><table  border='0' cellpadding='0' cellspacing='0' style='width: 350px;'><tr><td><asp:TextBox ID='txtTempAddress' style='border: none;   border-width: 0px;' TextMode='MultiLine' Rows='5' Columns='30'runat='server'>" + DataTable1.Rows[i]["Address"].ToString().ToUpper() + "</asp:TextBox></td></tr></table></div></td></tr></table></td></tr></table></td></tr></table></td>");

                if (i > 0)
                {

                    if (((i + 1) % 2) == 0)
                    {
                        str.Append(@"</tr><tr><td height='20'></td></tr><tr>");
                    }

                    if (((i + 1) % 16) == 0)
                    {
                        str.Append(@"</tr></table> <p class='pagebreakhere' style='page-break-after: always; color: Red;'></p><table width='1000' height='1000' ><tr>");
                    }

                }

            }

            str.Append(@"</tr></table>");
            dvCard.InnerHtml = str.ToString();

        }
        else
        {
            dvCard.InnerHtml = string.Empty;
        }


    }
}