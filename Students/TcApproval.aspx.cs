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
using System.Globalization;
using System.Text;


public partial class Students_TcApproval : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    private static int PageSize = 10;

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();

        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            Userid = Convert.ToInt32(Session["UserId"]);
            hdnUserId.Value = Session["UserId"].ToString();

            if (Session["AcademicID"] != null && Session["AcademicID"].ToString() != string.Empty)
            {
                hdnAcademicYearId.Value = Session["AcademicID"].ToString();
            }
            else
            {
                Utilities utl = new Utilities();
                hdnAcademicYearId.Value = utl.ExecuteScalar("select top 1 academicid from m_academicyear where isactive=1 order by academicid desc");
            }

            if (!IsPostBack)
            {
                BindClass();
                BindDummyRow();
            }
        }
    }


    private void BindClass()
    {
        utl = new Utilities();
        sqlstr = "sp_GetClass";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlClass.DataSource = dt;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();

            ddlClassForApproval.DataSource = dt;
            ddlClassForApproval.DataTextField = "ClassName";
            ddlClassForApproval.DataValueField = "ClassID";
            ddlClassForApproval.DataBind();

        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataBind();
            ddlClass.SelectedIndex = 0;

            ddlClassForApproval.DataTextField = null;
            ddlClassForApproval.DataBind();
        }

        ddlClassForApproval.Items.Insert(0, new ListItem("-- Select--", ""));
    }


    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("Check All");
            dummy.Columns.Add("Serial No");
            dummy.Columns.Add("Register No");
            dummy.Columns.Add("Admission No");
            dummy.Columns.Add("Student Name");
            dummy.Columns.Add("Class");
            dummy.Columns.Add("Section");
            dummy.Columns.Add("Due Status");
            dummy.Columns.Add("Approval Status");
            dummy.Columns.Add("Option");
            dummy.Rows.Add();
            grdStudentTCInfo.DataSource = dummy;
            grdStudentTCInfo.DataBind();
        }
    }

    [WebMethod]
    public static string printTc(string pregno)
    {
        string strQuery = string.Empty;

        StringBuilder tcContent = new StringBuilder();

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();

        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        if (Isactive == "True")
        {
            ds = utl.GetDataset("exec [SP_GETTCINFO] " + pregno + "," + "''" + "," + "''" + "," + "'" + HttpContext.Current.Session["AcademicID"].ToString() + "'");
        }
        else
        {
            ds = utl.GetDataset("exec [SP_GETPromoTCINFO] " + pregno + "," + "''" + "," + "''" + "," + "'" + HttpContext.Current.Session["AcademicID"].ToString() + "'");
        }



        if (ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string[] Dateformats = { "dd/MM/yyyy" };
                string regno = dr["RegNo"].ToString();
                string[] _IdMarks = dr["idmarks"].ToString().Split(';');
                string IdMarks = "";
                int slno = 1;
                foreach (string idmark in _IdMarks)
                {
                    if (idmark.ToUpper().CompareTo("NIL") != 0)
                    {
                        IdMarks += slno.ToString() + ") " + idmark.ToUpper() + "<br/>";
                        slno += 1;
                    }
                }
                if (slno > 1)
                {
                    IdMarks = IdMarks.Remove(IdMarks.Length - 2);
                }
                else
                    IdMarks = "NIL";
                tcContent.Append("<table class='formtc' style='margin-left: 15px;'> <tr> <td align='center' style='padding:0px;' class='tctext'><img src='../images/tc-header-transp.png' alt='tc-header' width='110' height='110'></td></tr><tr> <td align='center' valign='bottom' style='padding:0px;'> <table width='98%' border='0' cellspacing='0' cellpadding='0' class='tcbg' style='padding:0px;'> <tr> <td width='44%' align='left' valign='middle' class='ser-no' style='padding:0px;'>Serial No : " + dr["SlNo"].ToString() + "</td><td width='33%' align='right' valign='middle' class='ser-no' style='padding:0px;'>Admission No :" + dr["AdmissionNo"].ToString() + "</td><td width='33%' align='right' valign='middle' class='tc-photo' style='padding:0px;'> <div class='tc-imgplace'> <td width='33%' align='center' valign='middle' class='tctext' style='padding:0px;'></td><td width='33%' align='right' valign='middle' class='tc-photo' style='padding:0px;'> <div class='tc-imgplace'> <div class='tc-img'><img src='Photos/" + dr["RegNo"].ToString() + ".jpg' height='110' width='110' alt=''/></div></div></td></tr></table> </td></tr><tr> <td style='padding:0px;' class=''> <table width='100%' cellpadding='4' cellspacing='0' class='formtctxt' style='padding-top:0px;'> <tr> <td width='4%' height='30' class=''>1.</td><td width='43%' class=''> <span class='alignleft'>Name of the Pupil /<span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:'Times New Roman';mso-bidi-font-family:'Times New Roman';mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>   Ê´ÉtÉlÉÔ EòÉ xÉÉ¨É</span> <br/> </span> </td><td width='3%' class=''>:</td><td width='50%' class='tc-txt-upper'><b>" + dr["Name"].ToString() + "</b></td></tr><tr> <td height='35' class='tdHeight35'>2.</td><td> <span class='alignleft'>Father's / Guardian's Name / <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:'Times New Roman';mso-bidi-font-family:'Times New Roman';mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>Ê{ÉiÉÉ / +Ê¦É¦ÉÉ´ÉEò EòÉ xÉÉ¨É </span> </span> </td><td>:</td><td class='tc-txt-upper'>" + dr["ParentName"].ToString() + "</td></tr><tr> <td height='35' class='tdHeight35'>3.</td><td> <span class='alignleft'>Mother's Name /<span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:'Times New Roman';mso-bidi-font-family:'Times New Roman';mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'> ¨ÉÉiÉÉ EòÉ xÉÉ¨É</span></span> </td><td>:</td><td class='tc-txt-upper'>" + dr["MotherName"].ToString() + "</td></tr><tr> <td height='35' class='tdHeight35'>4.</td><td> <span class='alignleft'>Nationality /<span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:'Times New Roman';mso-bidi-font-family:'Times New Roman';mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'> ®úÉ¹]õÒªÉiÉÉ </span> </span> </td><td>:</td><td class='tc-txt-upper'>" + dr["Nationality"].ToString() + "</td></tr><tr> <td height='35' valign='top' class='tdHeight35'>5.</td><td valign='top'><span class='alignleft'>Whether the candidate belongs to <br/> Scheduled Caste or Scheduled Tribe /</span><span style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'></span> <span style='font-size:9.0pt;mso-bidi-font-size:14.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'><span style='mso-spacerun:yes'>&nbsp;</span></span><span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>CªÉÉ Ê´ÉtÉlÉÔ +xÉÖºÉÚÊSÉiÉ VÉÉÊiÉ / +xÉÖºÉÚÊSÉiÉ VÉxÉVÉÉÊiÉ EòÉ ½èþ?</span></span></td><td valign='top'>:</td><td valign='top' class='tc-txt-upper'>" + dr["Community"].ToString() + "</td></tr><tr> <td height='35' class='tdHeight35'>6.</td><td> <span class='alignleft'>Date of first admission with class / <span class='style1'> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>Ê´ÉtÉ±ÉªÉ ¨Éå |ÉlÉ¨É |É´Éä¶É EòÒ ÊiÉÊlÉ +Éè®ú EòIÉÉ</span> </span> </span> </td><td>:</td><td class='tc-txt-upper'>" + dr["DOA"].ToString() + "</td></tr><tr> <td height='35' valign='top' class='tdHeight35'>7.</td><td valign='top'>Date of Birth ( in Christian Era ) according to the admission Register (in figures &amp; in words) / <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>É´Éä¶É <span style='mso-spacerun:yes'>&nbsp;</span>®úÊVÉº]õ®ú Eäò +xÉÖºÉÉ®ú VÉx¨É ÊiÉÊlÉ </span>(<span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>(&lt;ÇºÉ´ÉÓ ºÉxÉ ¨Éå</span>) <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>+ÆEòÉä ¨Éå</span><span style='font-size:9.0pt;mso-bidi-font-size:14.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'> </span><span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>+Éè®ú ¶É¤nùÉå ¨Éå</span></td><td valign='top'>:</td><td valign='top' class='tc-txt-upper'>" + dr["DOB"].ToString() + "<br/>" + ConvertDate.DateToText(DateTime.ParseExact(dr["DOB"].ToString(), Dateformats, new CultureInfo("en-US"), DateTimeStyles.None), true) + "</td></tr><tr> <td height='35' valign='top' class='tdHeight35'>8.</td><td valign='top'> <span class='alignleft'>Class in which the pupil last studied in words and in figures / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>+ÎxiÉ¨É EòIÉÉ ÊVÉºÉ ¨Éå Ê´ÉtÉlÉÔ xÉä +vªÉªÉxÉ ÊEòªÉÉ +ÆEòÉå ¨Éå +Éè®ú ¶É¤nùÉå ¨Éå</span></td><td valign='top'>:</td><td valign='top' class='tc-txt-upper'>" + dr["Class"].ToString() + "</td></tr><tr> <td height='35' class='tdHeight35'>9.</td><td> <span class='alignleft'>School / Board Annual Examination last taken with result / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>¤ÉÉäbÇ÷ EòÒ +ÎxiÉ¨É ´ÉÉÌ¹ÉEò {É®úÒIÉÉ +Éè®ú =ºÉEòÉ ¨ÉÊ®úhÉÉ¨É</span></td><td>:</td><td class='tc-txt-upper'>" + dr["result"].ToString() + "</td></tr><tr> <td height='35' valign='top' class='tdHeight35'>10.</td><td valign='top'> <span class='alignleft'>Whether failed? if so, once / twice in the same class / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>+xÉÖkÉÒhÉÇ ®ú½þÉ ªÉÊnù ½þÉÄ iÉÉä =ºÉÒ EòIÉÉ ¨Éå CªÉÉ BEò ¤ÉÉ®ú / nùÉä ¤ÉÉ®</span></td><td valign='top'>:</td><td valign='top' class='tc-txt-upper'>" + dr["failed"].ToString() + "</td></tr><tr> <td height='35' class='tdHeight35'>11.</td><td> <span class='alignleft'>Subjects studied /<span class='style1'><span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>{Éfäø MÉB Ê´É¹ÉªÉ</span><span style='font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'> /</span> </span>Compulsory / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>+ÊxÉ´ÉÉªÉÇ</span><span style='font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'> /</span>Electives/<span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>´ÉèEòÎ±{ÉEò</span></td><td>:</td><td class='tc-txt-upper'> " + dr["CourseOfStudy"].ToString() + "</td></tr><tr> <td height='35' valign='top' class='tdHeight35'>12.</td><td valign='top'> <span class='alignleft'>Whether qualified for promotion to the higher class. If so, to which class/ <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>CªÉÉ =SSÉiÉ®ú EòIÉÉ ¨Éå VÉÉxÉä Eäò ªÉÉäMªÉ ½èþ? iÉÉä ÊEòºÉ EòIÉÉ ¨Éå  </span>in figures and in words: </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>+ÆEòÉå ¨Éå +Éè®ú ¶É¤nùÉå ¨Éå</span></td><td valign='top'>:</td><td valign='top' class='tc-txt-upper'> " + dr["Promotion"].ToString() + "</td></tr><tr> <td height='35' valign='top' class='tdHeight35'>13.</td><td valign='top'> <span class='alignleft'>Month up to which the pupil has paid School dues / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>ÊEòºÉ ¨ÉÉºÉ iÉEò Ê´ÉtÉ±ÉªÉ EòÒ näùªÉ ®úÉÊ¶ÉªÉÉå EòÉ ¦ÉÖMÉiÉÉxÉ Eò®ú ÊnùªÉÉ ½èþ?</span></td><td valign='top'>:</td><td valign='top' class='tc-txt-upper'>" + dr["feesdue"].ToString() + "</td></tr><tr> <td height='35' class='tdHeight35'>14.</td><td> <span class='alignleft'>Any fee concession availed of; if so, the nature of such concession / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>CªÉÉ ÊEòºÉÒ ¶ÉÖ±Eò EòÒ Ê®úªÉÉªÉiÉ |ÉÉ{iÉ EòÒ MÉ&lt;Ç, </span> <span style='font-size:12.0pt;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'><span style='mso-spacerun:yes'>&nbsp;</span></span><span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>ªÉÊnù ½þÉÄ iÉÉä ´É½þ Ê®úªÉÉªÉiÉ ÊEòºÉ |ÉEòÉ®ú EòÒ lÉÒ?</span></td><td>:</td><td class='tc-txt-upper'>" + dr["concession"].ToString() + "</td></tr><tr> <td height='35' class='tdHeight35' style='vertical-align: top; padding-top: 9px;'>15.</td><td style='vertical-align: top; padding-top: 9px;'> <span class='alignleft'>Total No. of working days / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>EòÉªÉÇÊnù´ÉºÉÉå EòÒ EÖò±É ºÉÆJªÉÉ</span></td><td style='vertical-align: top; padding-top: 9px;'>:</td><td class='tc-txt-upper'>" + dr["working"].ToString() + "</td></tr><tr> <td height='35' valign='top' class='tdHeight35'>16.</td><td valign='top'> <span class='alignleft'>Total No. of working days present / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>EòÉªÉÇÊnù´ÉºÉÉå ¨Éå ºÉä EÖò±É ={ÉÎºlÉÊiÉ Eäò ÊnùxÉ</span></td><td valign='top'>:</td><td valign='top' class='tc-txt-upper'>" + dr["present"].ToString() + "</td></tr><tr> <td height='35' class='tdHeight35' style='vertical-align: top; padding-top: 9px;'>17.</td><td style='vertical-align: top; padding-top: 9px;'> <span class='alignleft'>Whether NCC Cadet /Boy Scout / Girl Guide (details may be given) / <span class='style1'> <span style='font-size:9.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>/ </span><span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>CªÉÉ BxÉ ºÉÒ ºÉÒ Eèòb÷] õ/ ¤ÉÉ±ÉSÉ®ú(¤ÉÉªÉ ºEòÉ=]õ) / ¤ÉÉ±ÉSÉÉÊ®úEòÉ(MÉ±ÉÇ MÉÉ<b÷) ½èþ (¤ªÉÉè®úÉ näù)</span>&nbsp;/ </span> </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>¤ÉÉ±ÉSÉÉÊ®úEòÉ(MÉ±ÉÇ MÉÉ&lt;b÷) ½èþ (¤ªÉÉè®úÉ näù)</span></td><td>:</td><td class='tc-txt-upper'>" + dr["ncc"].ToString() + "</td></tr><tr> <td height='20' class='tdHeight35' style='vertical-align: top; padding-top: 9px;'>18.</td><td style='vertical-align: top; padding-top: 9px;'> <span class='alignleft'>Games played or extra curricular activities in which the pupil usually took part, (mention achievement level therein)*<span class='style1'> </span></span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>JÉä±Éä MÉªÉä JÉä±É ªÉÉ +ÊiÉÊ®úHò {ÉÉ`öªÉSÉªÉÉÇ  ÊGòªÉÉEò±ÉÉ{É ÊVÉºÉ ¨Éå Ê´ÉtÉlÉÔ xÉä ºÉÉ¨ÉÉxªÉiÉ: ¦ÉÉMÉ Ê±ÉªÉÉ ½þÉä (={É±ÉÎ¤nù ºiÉ®ú EòÉ =±±ÉäJÉ Eò®åú)</span></td><td style='vertical-align: top; padding-top: 9px;'>:</td><td class='tc-txt-upper'>" + dr["extra"].ToString() + "</td></tr><tr> <td height='20' class='tdHeight35' style='vertical-align: top; padding-top: 9px;'>19.</td><td style='vertical-align: top; padding-top: 9px;'> <span class='alignleft'>General Conduct / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>ºÉÉ¨ÉÉxªÉ +ÉSÉ®úhÉ</span></td><td style='vertical-align: top; padding-top: 9px;'>:</td><td class='tc-txt-upper'>" + dr["Conduct"].ToString() + "</td></tr><tr> <td height='20' class='tdHeight35' style='vertical-align: top; padding-top: 9px;'>20.</td><td style='vertical-align: top; padding-top: 9px;'> <span class='alignleft'>Date of application of certificate / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>|É¨ÉÉhÉ {ÉjÉ Eäò +É´ÉänùxÉ {ÉjÉ EòÒ ÊiÉÊlÉ</span></td><td style='vertical-align: top; padding-top: 9px;'>:</td><td class='tc-txt-upper'>" + dr["ApplicationDate"].ToString() + "</td></tr><tr> <td height='20' class='tdHeight35' style='vertical-align: top; padding-top: 9px;'>21.</td><td style='vertical-align: top; padding-top: 9px;'><span class='alignleft'>Date of issue of certificate / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'> |É¨ÉÉhÉ {ÉjÉ Eäò VÉÉ®úÒ Eò®úxÉä EòÒ ÊiÉÊlÉ</span></td><td style='vertical-align: top; padding-top: 9px;'>:</td><td class='tc-txt-upper'>" + dr["TcDate"].ToString() + "</td></tr><tr> <td height='20' class='tdHeight35' style='vertical-align: top; padding-top: 9px;'>22.</td><td style='vertical-align: top; padding-top: 9px;'> <span class='alignleft'>Reasons for leaving the school / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'> Ê´ÉtÉ±ÉªÉ UôÉäb÷xÉä Eäò EòÉ®úhÉ</span></td><td style='vertical-align: top; padding-top: 9px;'>:</td><td class='tc-txt-upper'>" + dr["reason"].ToString() + "</td></tr><tr> <td height='20' class='tdHeight35' style='vertical-align: top; padding-top: 9px;'>23.</td><td style='vertical-align: top; padding-top: 9px;'> <span class='alignleft'>Any other remarks / </span> <span style='font-size:12.0pt;font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'>EòÉä<Ç +xªÉ +¦ªÉÖÊHò</span></td><td style='vertical-align: top; padding-top: 9px;'>:</td><td class='tc-txt-upper'>" + dr["remarks"].ToString() + "</td></tr></table> </td></tr><tr> <td style='vertical-align: top; padding-top: 0px;' class='signparent' align='right'><br/><strong><span>Signature of the Principal<br/> with date and school seal</span></strong></td></tr><tr> <td style='vertical-align: top; padding-top: 0px;'><span class='aligncenter'>Note: </span></td></tr><tr> <td style='vertical-align: top; padding-top: 0px;'><span class='alignleft'>1. Erasures and unauthenticated or fraudulent alteration will lead to its cancellation.</span><br/><span class='alignleft'>2. Should be signed in ink by the Head of the Institution,</span><br/><span class='alignleft'>&nbsp;&nbsp;&nbsp;&nbsp;who will be held responsible for correctness of the entries.</span> </td></tr><tr> <td style='vertical-align: top; padding-top: 0px;'><span class='alignleft'><br/>I hereby declare that the particular given above are correct and that no change will be demanded by me in future</td></tr><tr> <td class='signparent' align='right' style='padding-top: 0px;'><strong><br/><br/>Signature of the Parent / Guardian </strong></td></tr></table><p class='pagebreakhere' style='page-break-after: always; color:Red;'></p>");
            }

        }
        return tcContent.ToString();

    }
    public static string BindCourseStudy(string regno)
    {
        Utilities utl = new Utilities();
        string _StudCourceHistory = string.Empty;
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_getTCCourseStudy " + regno;
        }
        else
        {
            query = "sp_getPromoTCCourseStudy " + regno + "," + HttpContext.Current.Session["AcademicID"].ToString();
        }
        DataSet dsCourseStudy = utl.GetDataset(query);
        if (dsCourseStudy != null && dsCourseStudy.Tables.Count > 0 && dsCourseStudy.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow _course in dsCourseStudy.Tables[0].Rows)
            {
                _StudCourceHistory += "<tr>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tl'><p>" + _course["schooladdr"].ToString() + "</p></td>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tl'><p>" + _course["acdyears"].ToString() + "</p></td>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tl'><p>" + _course["classes"].ToString() + "</p></td>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tl'><p>" + _course["firstlang"].ToString() + "</p></td>";
                _StudCourceHistory += "<td width='20%' class='cours-brd-tlr'><p>" + _course["mis"].ToString() + "</p></td>";
                _StudCourceHistory += "</tr>";
            }
        }

        return _StudCourceHistory;
    }
    [WebMethod]
    public static string GetStudentsTCDetail(int pageIndex, string Regno, string AdminNo, string gender, string Class, string Section, string StudentName)
    {
        Utilities utl = new Utilities();

        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_GetTCPendingList ";
        }
        else
        {
            query = "sp_GetPromoTCPendingList ";
        }

        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@regno", Regno);
        cmd.Parameters.AddWithValue("@adminno", AdminNo);
        cmd.Parameters.AddWithValue("@gender", gender == "undefined" ? "" : gender);
        cmd.Parameters.AddWithValue("@classname", Class);
        cmd.Parameters.AddWithValue("@section", Section);
        cmd.Parameters.AddWithValue("@studentname", StudentName);
        cmd.Parameters.AddWithValue("@AcademicID", HttpContext.Current.Session["AcademicID"].ToString());
        return utl.GetData(cmd, pageIndex, "StudentInfo", PageSize).GetXml();

    }

    [WebMethod]
    public static string GetStudentDup(int dupYear, string dupClass, string dupSection)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "";
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        if (Isactive == "True")
        {
            query = "sp_getStudentByDup " + dupYear + ",'" + dupClass + "','" + dupSection + "'";
        }
        else
        {
            query = "sp_getPromoStudentByDup " + dupYear + ",'" + dupClass + "','" + dupSection + "'";
        }

        return utl.GetDatasetTable(query, "Students").GetXml();

    }

    [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }

    [WebMethod]
    public static string GetStudentBySection(string Class, string Section)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_GetStudentBySection '" + Class + "','" + Section + "'";
        }
        else
        {
            query = "sp_GetPromoStudentBySection '" + Class + "','" + Section + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }
        return utl.GetDatasetTable(query, "Students").GetXml();
    }


    [WebMethod]
    public static string GetModuleMenuId(string path, string UserId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModuleMenuId '" + path + "'," + UserId;
        return utl.GetDatasetTable(query, "ModuleMenu").GetXml();
    }
    [WebMethod]
    public static string GetFeePendingList(string RegNo, string Active, string AcademicId)
    {
        Utilities utl = new Utilities();
        string query = "sp_AcademicFeesTotalDueList " + RegNo + ",'" + Active + "'," + AcademicId;
        DataSet ds = utl.GetDataset(query);
        return ds.GetXml();
    }

    [WebMethod]
    public static string SendForApporval(string RegNo, string AcademicId, string userId)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_TCSendForApporval " + RegNo + "," + AcademicId + "," + userId;
        }
        else
        {
            query = "sp_PromoTCSendForApporval " + RegNo + "," + AcademicId + "," + userId;
        }

        string strError = utl.ExecuteQuery(query);

        if (strError == string.Empty)
            return "1";
        else
            return "2";

    }
    [WebMethod]
    public static string ChangeApproval(string regNo)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "SP_UPDATETCSTATUS " + regNo + "," + "''" + "," + "''";
        }
        else
        {
            query = "SP_PromoUPDATETCSTATUS " + regNo + "," + "''" + "," + "''" + "," + "'" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }

        string strError = utl.ExecuteQuery(query);

        if (strError == string.Empty)
            return "";
        else
            return "fail";
    }
    [WebMethod]
    public static string UpdateBulkApporval(string classId, string sectionId)
    {
        Utilities utl = new Utilities();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "SP_UPDATETCSTATUS null, " + classId + "," + sectionId;
        }
        else
        {
            query = "SP_PromoUPDATETCSTATUS null, '" + classId + "','" + sectionId + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        }

        string strError = utl.ExecuteQuery(query);

        if (strError == string.Empty)
            return "";
        else
            return "fail";
    }
}

