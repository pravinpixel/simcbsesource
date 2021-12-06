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

public partial class Reports_StudentAbsentReport : System.Web.UI.Page
{
    Utilities utl = new Utilities();
    public static int Userid = 0;
    public static int AcademicID = 0;   


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
            if (!IsPostBack)
            {
                BindClass();
            }
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

    private bool validate()
    {
        bool chk = true;
        
        if (txtFromDate.Text == string.Empty)
        {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Please Choose From Date','info');</script>", false);
                chk = false;
        }

        if (txtTodate.Text == string.Empty)
        {
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Please Choose To Date','info');</script>", false);
            chk = false;
        }

        return chk;
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            if (validate())
            {
                LOAD_RESULT();
            }
        }

        catch (Exception ex)
        {
            //Response.Write("<script>alert('"+ex.Message+"')</script>");
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('" + ex.Message + "','info');</script>", false);
        }
    }

    //Main Search Function
    string stroption;
    StringBuilder dvContent = new StringBuilder();
    DataSet dsGet = new DataSet();
    string sqlstr;

    private void LOAD_RESULT()
    {        
        int p = 0;
        string fromdate=string.Empty;
        string todate = string.Empty;

        if (txtFromDate.Text != "")
        {
            string[] myDateTimeString = txtFromDate.Text.ToString().Split('/');
            fromdate = "" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }
        if (txtTodate.Text != "")
        {
            string[] myDateTimeString = txtTodate.Text.ToString().Split('/');
            todate = "" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }


        string chkregno=string.Empty;
        sqlstr = "sp_getStudentAbsentReport  " + AcademicID + ",'" + fromdate + "','" + todate + "','" + Session["strClassID"] + "','" + Session["strSectionID"] + "' ";
        dsGet = utl.GetDataset(sqlstr);

        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            stroption += @"<table class='formtc' width='100%' border='1px'><tr><th>S.No</th><th>RegNo</th><th>Student Name</th><th>Class</th><th>Section</th><th>Absent Date</th><th>Days Count</th></tr>";
            double Attcnt = 0;
            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {
                double Icnt = 0;
                if (chkregno != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                {
                    p = p+1;
                    stroption += @"<tr><td align='center'>" + p.ToString() + "</td> ";
                    DataRow[] drAbsentdate = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " ");
                    
                    if (drAbsentdate.Length > 0)
                    {
                        stroption += @"<td align='center'>" + drAbsentdate[0]["RegNo"].ToString() + "</td><td>" + drAbsentdate[0]["StudentName"].ToString() + "</td><td align='center'>" + drAbsentdate[0]["Class"].ToString() + "</td><td align='center'>" + drAbsentdate[0]["Section"].ToString() + "</td><td align='center'>";

                        for (int j = 0; j < drAbsentdate.Length; j++)
                        {
                            stroption += @"" + drAbsentdate[j]["Attdate"].ToString() + "<br/>";
                           // stroption += @"<tr><td colspan='5'></td><td>" + drAbsentdate[j]["Attdate"].ToString() + "</td></tr>";
                            if (drAbsentdate[j]["ForeNoon"].ToString() == "True")
                            {
                                Icnt = Icnt + 0.5;
                            }
                            if (drAbsentdate[j]["AfterNoon"].ToString() == "True")
                            {
                                Icnt = Icnt + 0.5;
                            }
                        }


                        stroption += @"</td><td align='center'>" + Convert.ToDecimal(Icnt).ToString() + "</td>";
                    }                    

                    chkregno = dsGet.Tables[0].Rows[i]["RegNo"].ToString();

                    stroption += @"</tr>";                    
                }
                
            }

            stroption += @"</table>";
        }

        dvContent.Append(stroption);
        dvAbsentReport.InnerHtml = dvContent.ToString();
    }
    
    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSectionByClass();
        if (ddlClass.SelectedItem.Text == "---Select---" || ddlClass.SelectedItem.Value == "---Select---")
        {
            Session["strClass"] = "";
            Session["strClassID"] = "";
            Session["strSection"] = "";
            Session["strSectionID"] = "";
        }
        else
        {
            Session["strClass"] = ddlClass.SelectedItem.Text;
            Session["strClassID"] = ddlClass.SelectedValue;         
            Session["strSection"] = "";
            Session["strSectionID"] = "";
        }
    }

    protected void BindSectionByClass()
    {
        utl = new Utilities();
        DataSet dsSection = new DataSet();
        dsSection = utl.GetDataset("sp_GetSectionByClass " + ddlClass.SelectedValue);
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
            Session["strSection"] = "";
            Session["strSectionID"] = "";
        }
        else
        {
            Session["strSection"] = ddlSection.SelectedItem.Text;
            Session["strSectionID"] = ddlSection.SelectedValue;
        }
    }
}