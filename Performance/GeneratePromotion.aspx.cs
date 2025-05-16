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


public partial class Performance_GeneratePromotion : System.Web.UI.Page
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
            hfAcademicID.Value = AcademicID.ToString();
            Userid = Convert.ToInt32(Session["UserId"]);
            hfUserId.Value = Userid.ToString();

            if (!IsPostBack)
            {
                BindClass();
                if (Request.Params["ClassID"] != null && Request.Params["SectionID"] != null)
                {
                    Session["strClassID"] = Request.Params["ClassID"].ToString();
                    Session["strSectionID"] = Request.Params["SectionID"].ToString();
                    hfClassID.Value = Session["strClassID"].ToString();
                    hfSectionID.Value = Session["strSectionID"].ToString();
                    LOAD_RESULT();
                }
            }
        }
    }
    [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }
    private void BindClass()
    {
        utl = new Utilities();
        sqlstr = "sp_GetClass ";
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

        ddlClass.Items.Insert(0, "Select");
    }
    [WebMethod]
    public static string UpdatePromotion(string NxtClassID, string NxtSectionID, string ClassID, string SectionID, string RegNo, string Status)
    {
        try
        {
            Utilities utl = new Utilities();
            string retval = utl.ExecuteQuery("update p_promotionlist set remarks='" + Status.ToUpper() + "',PromotionStatus='True' where RegNo='" + RegNo + "' and ClassID='" + ClassID + "' and SectionID='" + SectionID + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'");
            if (retval == "")
               {
                if (Status.ToLower() == "promoted")
                {
                    string Active = utl.ExecuteScalar("Select Active from s_studentinfo where regno='" + RegNo + "'");

                    DataTable dt = new DataTable();
                    dt = utl.GetDataTable("select busfacility,concession,Hostel,Scholar,active from s_studentinfo where regno='" + RegNo + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "' and class='" + ClassID + "' and section='" + SectionID + "'");

                    if (Active.ToLower() == "n")
                    {
                        utl.ExecuteQuery("update s_studentinfo set class='" + NxtClassID + "',section='" + NxtSectionID + "',userid='" + HttpContext.Current.Session["Userid"].ToString() + "',busfacility='',concession='',Hostel='',Scholar='',ExamNo='',Active='C',modifieddate=getdate(), academicyear=null where regno='" + RegNo + "'  ");
                    }
                    else
                    {
                        utl.ExecuteQuery("update s_studentinfo set class='" + NxtClassID + "',section='" + NxtSectionID + "',userid='" + HttpContext.Current.Session["Userid"].ToString() + "',busfacility='',concession='',Hostel='',Scholar='',ExamNo='',modifieddate=getdate(), academicyear=null where regno='" + RegNo + "'  ");
                    }

                    string icnt = "";
                    icnt=utl.ExecuteScalar("select count(*) from s_studentpromotion where regno='" + RegNo + "' and AcademicId='" + HttpContext.Current.Session["AcademicID"].ToString() + "' and classID='" + ClassID + "'");
                    if (icnt=="" || icnt=="0")
                    {
                        utl.ExecuteQuery("insert into s_studentpromotion(RegNo,AcademicId,ClassId,SectionId,UserId) values ('" + RegNo + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "','" + ClassID + "','" + SectionID + "','" + HttpContext.Current.Session["Userid"].ToString() + "')");
                    }
                    if (dt.Rows.Count > 0)
                    {
                        utl.ExecuteQuery("update s_studentpromotion set sectionID='" + SectionID + "',busfacility='" + dt.Rows[0]["busfacility"].ToString() + "',concession='" + dt.Rows[0]["concession"].ToString() + "',Hostel='" + dt.Rows[0]["Hostel"].ToString() + "',Scholar='" + dt.Rows[0]["Scholar"].ToString() + "',active='" + dt.Rows[0]["active"].ToString() + "' where regno='" + RegNo + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "' and classID='" + ClassID + "'");
                    }
                  
                }
                else if (Status.ToLower() == "detained")
                {
                    string Active = utl.ExecuteScalar("Select Active from s_studentinfo where regno='" + RegNo + "'");

                    DataTable dt = new DataTable();
                    dt = utl.GetDataTable("select busfacility,concession,Hostel,Scholar,active from s_studentinfo where regno='" + RegNo + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "' and class='" + ClassID + "' and section='" + SectionID + "'");

                    if (Active.ToLower() == "n")
                    {
                        utl.ExecuteQuery("update s_studentinfo set userid='" + HttpContext.Current.Session["Userid"].ToString() + "',Active='C',busfacility='',concession='',Hostel='',Scholar='',modifieddate=getdate(), academicyear=null where regno='" + RegNo + "'  ");
                    }
                    else
                    {
                        utl.ExecuteQuery("update s_studentinfo set userid='" + HttpContext.Current.Session["Userid"].ToString() + "',busfacility='',concession='',Hostel='',Scholar='' ,modifieddate=getdate(), academicyear=null where regno='" + RegNo + "'  ");
                    }

                    string icnt = "";
                    icnt = utl.ExecuteScalar("select count(*) from s_studentpromotion where regno='" + RegNo + "' and AcademicId='" + HttpContext.Current.Session["AcademicID"].ToString() + "' and classID='" + ClassID + "'");
                    if (icnt == "" || icnt == "0")
                    {
                        utl.ExecuteQuery("insert into s_studentpromotion(RegNo,AcademicId,ClassId,SectionId,UserId) values ('" + RegNo + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "','" + ClassID + "','" + SectionID + "','" + HttpContext.Current.Session["Userid"].ToString() + "')");
                    }                   
                    if (dt.Rows.Count > 0)
                    {
                        utl.ExecuteQuery("update s_studentpromotion set sectionID='" + SectionID + "',busfacility='" + dt.Rows[0]["busfacility"].ToString() + "',concession='" + dt.Rows[0]["concession"].ToString() + "',Hostel='" + dt.Rows[0]["Hostel"].ToString() + "',Scholar='" + dt.Rows[0]["Scholar"].ToString() + "',active='" + dt.Rows[0]["active"].ToString() + "' where regno='" + RegNo + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "' and classID='" + ClassID + "'");
                    }
                }

            }
        }
        catch
        {

        }

        return "Promotion Applied";
    }

    private void LOAD_RESULT()
    {
        utl = new Utilities();
        sqlstr = "[GeneratePromotionReport] " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
        DataSet ds = new DataSet();
        ds = utl.GetDataset(sqlstr);
        StringBuilder dvContent = new StringBuilder();
        string RegNo = "";
        int j = 0;
        if (ds.Tables[0].Rows.Count > 0)
        {
            utl = new Utilities();
            DataSet dsLang = new DataSet();
            string query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
            dsLang = utl.GetDataset(query);

            dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td width='2%'><b>Sl.No</b></td><td width='10%'><b>AdmissionNo</b></td><td width='10%'><b>ExamNo</b></td><td width='10%'><b>RegNo</b></td><td width='10%'><b>StudentName</b></td><td width='10%'><b>DOB</b></td><td width='10%'><b>ClassName</b></td><td width='10%'><b>SectionName</b></td>");

            dvContent.Append(@"<td width='10%'><b>PresentDays</b></td><td width='10%'><b>AttendancePercent</b></td><td width='10%'><b>Status</b></td><td width='10%'><b>Present Remark</b></td><td width='10%'><b>Final Remark</b></td></tr>");

            int h = 0;
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {

                if (RegNo != ds.Tables[0].Rows[i]["RegNo"].ToString())
                {
                    h = h + 1;
                    if (ds.Tables[0].Rows[i]["Remarks"].ToString().ToLower() == "promoted")
                    {

                        dvContent.Append(@"<tr class='even'><td>" + h.ToString() + "</td><td>" + ds.Tables[0].Rows[i]["AdminNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td class='regno'>" + ds.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["DOB"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["ClassName"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["SectionName"].ToString() + "</td>");


                        dvContent.Append(@"<td>" + ds.Tables[0].Rows[i]["PresentDays"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["AttendancePercn"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["Status"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["Remarks"].ToString() + "</td>");

                        dvContent.Append(@"<td class='status'><select id='ddlpromote' style='width:100px'><option selected='true' value='Promoted'>Promoted</option><option value'Detained'>Detained</option></td>");
                    }
                    else
                    {
                        dvContent.Append(@"<tr class='even rowred'><td>" + h.ToString() + "</td><td>" + ds.Tables[0].Rows[i]["AdminNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td class='regno'>" + ds.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["DOB"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["ClassName"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["SectionName"].ToString() + "</td>");


                        dvContent.Append(@"<td>" + ds.Tables[0].Rows[i]["PresentDays"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["AttendancePercn"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["Status"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["Remarks"].ToString() + "</td>");

                        dvContent.Append(@"<td class='status'><select id='ddlpromote' style='width:100px'><option value='Promoted'>Promoted</option><option  selected='true' value'Detained'>Detained</option></td>");
                    }

                    RegNo = ds.Tables[0].Rows[i]["RegNo"].ToString();
                    dvContent.Append(@"</tr>");
                }
            }


            dvContent.Append(@"</table>");
            dvCard.InnerHtml = dvContent.ToString();

        }
    }
}