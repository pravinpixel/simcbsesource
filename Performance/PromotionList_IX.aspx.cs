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


public partial class Performance_PromotionList_IX : System.Web.UI.Page
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
            Userid = Convert.ToInt32(Session["UserId"]);
            hfUserId.Value = Userid.ToString();

            if (!IsPostBack)
            {
                Session["strSection"] = "";
                Session["strSectionID"] = "";
                Session["strExamName"] = "";
                Session["strExamNameID"] = "";
                Session["strSubject"] = "";
                Session["strSubjectID"] = "";

                BindClass();
                BindSectionByClass();

                BindExamName_List();

                utl = new Utilities();
                DataTable dtSchool = new DataTable();
                dtSchool = utl.GetDataTable("exec sp_schoolDetails");
                ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
            }
        }
    }

    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("sp_GetClass 11");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass.DataSource = dsClass;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();

            Session["strClass"] = ddlClass.SelectedItem.Text;
            Session["strClassID"] = ddlClass.SelectedValue;
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
        dsSection = utl.GetDataset("sp_GetSectionByClass 11");
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
        ddlSection.Items.Insert(0, "---Select---");
    }



    protected void ddlSection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSection.SelectedItem.Text == "---Select---" || ddlSection.SelectedItem.Value == "---Select---")
        {
            strSection = "";
            strSectionID = "";
            Session["strSection"] = "";
            Session["strSectionID"] = "";
        }
        else
        {
            Session["strSection"] = ddlSection.SelectedItem.Text;
            Session["strSectionID"] = ddlSection.SelectedValue;
        }
    }

    private void BindExamName_List()
    {
        string query = "sp_GetExamNameList " + "''" + "," + AcademicID;

        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            chkExamName.DataSource = dt;
            chkExamName.DataTextField = "ExamName";
            chkExamName.DataValueField = "ExamNameID";
            chkExamName.DataBind();
        }
        else
        {
            chkExamName.DataSource = null;
            chkExamName.DataBind();
        }
        foreach (ListItem li in chkExamName.Items)
            li.Attributes.Add("Classes", li.Value);
    }



    private string Disp_SchoolName()
    {
        DataTable dtSchool = new DataTable();
        dtSchool = utl.GetDataTable("exec sp_schoolDetails");
        ReportParameter Schoolname = new ReportParameter("Schoolname", dtSchool.Rows[0]["SchoolName"].ToString());
        string SchoolName = string.Empty;

        SchoolName = "<table class='form' cellspacing='1' cellpadding='1' width='1000'><tr><td align='center' colspan='3' style='font-family:Arial, Helvetica, sans-serif; font-size:20px;'><label>" + dtSchool.Rows[0]["SchoolName"].ToString().ToUpper() + "</label></td></tr><tr><td width='15%' style='font-family:Arial, Helvetica, sans-serif; font-size:17px;'>" + Session["strClass"].ToString().ToUpper() + " - " + Session["strSection"].ToString().ToUpper() + "</td><td align='center' style='font-family:Arial,padding-left: 17px; Helvetica, sans-serif; font-size:17px;'><b>PROMOTIONLIST</b></td></tr></table>";

        return SchoolName;

    }


    string SubjectListID = "";
    private void Disp_SubjectList()
    {
        utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
        ds = utl.GetDataset(query);

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            ddlType.Text = ds.Tables[0].Rows[0]["Type"].ToString();

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (SubjectListID == "")
                {
                    SubjectListID = ds.Tables[0].Rows[i]["Subjectid"].ToString();
                }

                else
                {
                    SubjectListID = SubjectListID + "," + ds.Tables[0].Rows[i]["Subjectid"].ToString();
                }
            }
        }
    }

    int totdays;
    string startdate;
    string enddate;
    private void LOAD_Totdays()
    {
        utl2 = new Utilities();
        DataSet ds = new DataSet();
        string sql;

        sql = "select isnull(SUM(convert(int,noofdays)),0)as Totaldays from m_DaysinMonths where AcademicID='" + AcademicID + "' and ClassID='" + Session["strClassID"] + "' and IsActive=1 ";
        totdays = Convert.ToInt32(utl2.ExecuteScalar(sql));

        string query = "select convert(varchar(10),StartDate,121) as StartDate, convert(varchar(10),EndDate,121) as EndDate from m_academicyear where AcademicId='" + AcademicID + "'";
        ds = utl.GetDataset(query);
        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            startdate = ds.Tables[0].Rows[0]["StartDate"].ToString();
            enddate = ds.Tables[0].Rows[0]["EndDate"].ToString();
        }

    }
        

    private string Attenance(string regno)
    {
        utl2 = new Utilities();
        string AttendanceDetail;

        double presentdays = 0;
        string sql2;

        double NoofPresent = 0;


        sql2 = "select (convert(float,((dbo.[fn_GetFNCount]('" + regno + "','" + AcademicID + "','" + startdate + "','" + enddate + "','" + totdays + "'))+(dbo.[fn_GetANCount]('" + regno + "','" + AcademicID + "','" + startdate + "','" + enddate + "','" + totdays + "')))/2)) as PresentDays";


        presentdays = Convert.ToDouble(utl2.ExecuteScalar(sql2));

        NoofPresent += presentdays;

        AttendanceDetail = NoofPresent.ToString();

        return AttendanceDetail;
    }

    string C1_ExamNameID = "";
    string C1_ExamName = "";
    string C1_Passmark = "";
    private void C1_Disp_ExamNameID()
    {
        utl = new Utilities();
        DataSet ds = new DataSet();
        string sqlquery = "select PSD.ExamIdList1,PSD.ShortName1,PSD.MarkPercentage1 from p_promotionsetup PS inner join p_promotionsetupdetails PSD on PS.PromotionId =PSD.PromotionId where PS.ClassID='" + Convert.ToInt32(Session["strClassID"]) + "' and PS.IsActive=1 and PSD.IsActive=1 and PS.Type='CaseI' and PS.AcademicID='" + AcademicID + "' and PSD.AcademicID='" + AcademicID + "'";
        ds = utl.GetDataset(sqlquery);

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            C1_ExamNameID = ds.Tables[0].Rows[0]["ExamIdList1"].ToString();
            C1_Passmark = Convert.ToInt32(ds.Tables[0].Rows[0]["MarkPercentage1"]).ToString();

            // C1_ExamName = utl.ExecuteScalar("select ExamName from p_examnamelist where ExamNameID='" + C1_ExamNameID + "'");
            C1_ExamName = ds.Tables[0].Rows[0]["ShortName1"].ToString();
        }
    }


    string C2EX1_ExamNameIDs = "";
    string C2EX1_MarkPercn = "";
    string C2EX2_ExamNameIDs = "";
    string C2EX2_MarkPercn = "";
    string C2EX3_ExamNameIDs = "";
    string C2EX3_MarkPercn = "";
    string C2EX4_ExamNameIDs = "";
    string C2EX4_MarkPercn = "";
    string C2ALL_ExamNameIDs = "";
    string C2_Passmark = "";

    string C2EX1_ExamNames = "";
    string C2EX2_ExamNames = "";
    string C2EX3_ExamNames = "";
    string C2EX4_ExamNames = "";

    private void C2_Disp_ExamNameID()
    {
        utl = new Utilities();
        DataSet ds = new DataSet();
        string sqlquery = "sp_Promo_GetCaseIIExamName " + Session["strClassID"] + ",'" + Session["AcademicID"] + "'";
        ds = utl.GetDataset(sqlquery);

        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            C2ALL_ExamNameIDs = ds.Tables[0].Rows[0]["AllExamIdList"].ToString();
            C2_Passmark = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalMarks"]).ToString();

            C2EX1_ExamNameIDs = ds.Tables[0].Rows[0]["ExamIdList1"].ToString();
            C2EX1_MarkPercn = ds.Tables[0].Rows[0]["MarkPercentage1"].ToString();
            C2EX2_ExamNameIDs = ds.Tables[0].Rows[0]["ExamIdList2"].ToString();
            C2EX2_MarkPercn = ds.Tables[0].Rows[0]["MarkPercentage2"].ToString();
            C2EX3_ExamNameIDs = ds.Tables[0].Rows[0]["ExamIdList3"].ToString();
            C2EX3_MarkPercn = ds.Tables[0].Rows[0]["MarkPercentage3"].ToString();
            C2EX4_ExamNameIDs = ds.Tables[0].Rows[0]["ExamIdList4"].ToString();
            C2EX4_MarkPercn = ds.Tables[0].Rows[0]["MarkPercentage4"].ToString();

            C2EX1_ExamNames = ds.Tables[0].Rows[0]["ShortName1"].ToString();
            C2EX2_ExamNames = ds.Tables[0].Rows[0]["ShortName2"].ToString();
            C2EX3_ExamNames = ds.Tables[0].Rows[0]["ShortName3"].ToString();
            C2EX4_ExamNames = ds.Tables[0].Rows[0]["ShortName4"].ToString();

            // C2EX2_ExamNames = utl.ExecuteScalar("SELECT distinct (SELECT  '' + ExamName + ' ' FROM p_examnamelist where  ExamNameID IN(" + C2EX2_ExamNameIDs + ") FOR XML PATH('')) AS vals from p_examnamelist");          

        }
    }

    string C3_Passmark = "";
    private void C3_Disp_ExamNameID()
    {
        utl = new Utilities();
        DataSet ds = new DataSet();
        string sqlquery = "sp_Promo_GetCase3ExamName " + Session["strClassID"] + ",'" + Session["AcademicID"] + "'";
        ds = utl.GetDataset(sqlquery);
        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            C3_Passmark = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalMarks"]).ToString();
        }
    }

    string ALL_ExamNameIDs = "";
    private void Disp_AllExamNameID_GENERAL()
    {
        if (C1_ExamNameID != "")
        {
            ALL_ExamNameIDs = C1_ExamNameID + "," + C2ALL_ExamNameIDs;
        }
        else
        {
            ALL_ExamNameIDs = C2ALL_ExamNameIDs;
        }

    }


    private void Disp_AllExamNameID_SAMACHEER()
    {
        if (C1_ExamNameID != "")
        {
            ALL_ExamNameIDs = C1_ExamNameID + C2ALL_ExamNameIDs;
        }
        else
        {
            ALL_ExamNameIDs = "0" + C2ALL_ExamNameIDs;
        }

    }


    protected void btnP1Search_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                string chk = CheckAlready();

                if (chk == "true")
                {
                    Disp_SubjectList();
                    LOAD_Totdays();

                    C1_Disp_ExamNameID();
                    C2_Disp_ExamNameID();
                    C3_Disp_ExamNameID();

                    Disp_AllExamNameID_SAMACHEER();
                    LOAD_RESULT_SAMACHEER();
                }

            }


        }

        catch (Exception ex)
        {
            utl.ShowMessage("<script>AlertMessage('info', '" + ex.Message + "');</script>", this.Page);
        }
    }
    
       
    protected void btnShow_Click(object sender, EventArgs e)
    {
        try
        {
            string chk = CheckAlready();

            if (chk == "true")
            {
                dvC1_Content.InnerHtml = "";
                if (ddlSection.SelectedIndex != 0 && ddlSection.SelectedIndex != -1)
                {
                    dvNotify.Visible = true;
                }
                else
                {
                    dvNotify.Visible = false;
                }
            }
        }

        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Please Check Promotion Setup');</script>", false);
        }
    }

    private string CheckAlready()
    {
        string result = "false";
        string sqlquery = string.Empty;
        string status = string.Empty;
        string sqlquery1 = string.Empty;
        string status1 = string.Empty;

        utl = new Utilities();
        sqlquery = "select COUNT(*) from p_promotionsetup where ClassID='" + Session["strClassID"] + "' and AcademicID ='" + AcademicID + "'";
        status = utl.ExecuteScalar(sqlquery);

        if (status != "0")
        {
            sqlquery1 = "select COUNT(*) from p_promotionList where ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID ='" + AcademicID + "' ";
            status1 = utl.ExecuteScalar(sqlquery1);

            if (status1 != "0")
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Promotion List Already Prepared');</script>", false);
                result = "false";
                return result;
            }

            else
            {
                result = "true";
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Please Check Promotion Setup');</script>", false);
            result = "false";
            return result;
        }

        return result;
    }

    protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = chkAgree.Checked;
    }
    protected void btnPromotionCancel_Click(object sender, EventArgs e)
    {
        dvNotify.Visible = false;
        dvC1_Content.InnerHtml = null;
    }


    protected void btnExport0_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                utl = new Utilities();
                sqlstr = "select COUNT(*) from p_promotionList where ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID ='" + AcademicID + "' ";
                string status1 = utl.ExecuteScalar(sqlstr);               

                if (status1 != "0")
                {
                    if (dvC1_Content.InnerHtml != null && dvC1_Content.InnerHtml.Trim() != "" && dvC1_Content.InnerHtml.Trim() != "\r\n")
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>Export();</script>", false);
                    }
                    else
                    {
                        Disp_SubjectList();
                        LOAD_Totdays();

                        C1_Disp_ExamNameID();
                        C2_Disp_ExamNameID();
                        C3_Disp_ExamNameID();

                        Disp_AllExamNameID_SAMACHEER();
                        LOAD_RESULT_SAMACHEER_Export();

                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>Export();</script>", false);
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Please Promotion List Not Yet Generated');</script>", false);                    
                }
            }

        }

        catch (Exception ex)
        {
            utl.ShowMessage("<script>AlertMessage('info', '" + ex.Message + "');</script>", this.Page);
        }
    }



    //Main Search Function
    string stroption;

    //C1 Samacheer Marks function -  Start
    private void LOAD_RESULT_SAMACHEER()
    {
        try
        {
            if (C1_ExamNameID != "")
            {
                utl = new Utilities();

                string proInsertQuery = string.Empty;
                string proUpdateQuery = string.Empty;
                string Tempstroption;
                int chk = 0;
                string examnochk = string.Empty;
                string proStatus = string.Empty;
                string proChk = string.Empty;

                decimal Max_Mark = 0;
                decimal Calc_Mark = 0;

                DataSet dsGet = new DataSet(); //ALL_ExamNameIDs  SubjectListID  ALL_ExamNameIDs  ddlType.SelectedItem.Text

                sqlstr = "sp_Promo_getCCEpromotion_IX " + Session["strClassID"] + "," + Session["strSectionID"] + "," + "'" + ALL_ExamNameIDs + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + SubjectListID + "'" + "," + AcademicID;

                dsGet = utl.GetDataset(sqlstr);
                StringBuilder dvContent = new StringBuilder();

                dvContent.Append(Disp_SchoolName());//SchoolName Bind 

                int EXNamecount = 0;
                string[] ExamTypeName;


                if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                {
                    dvContent.Append("<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tbody>");

                    stroption +="<tr><td rowspan='3'><b>Sl No</b></td><td rowspan='3'><b>Adm No</b></td><td rowspan='3'><b>Reg No</b></td><td rowspan='3'><b>Exam No</b></td><td rowspan='3'><b>Name of the student</b></td><td rowspan='3'><b>Sex</b></td><td rowspan='3'><b>Category</b></td><td rowspan='3'><b>Date of birth</b></td>";


                    //ExamsType (TERMs) Count START
                    EXNamecount = 0;
                    ExamTypeName = C2ALL_ExamNameIDs.Split(',');
                    foreach (string EXName in ExamTypeName)
                    {
                        if (EXName != "")
                        {
                            EXNamecount = EXNamecount + 1;
                        }
                    }
                    int thlenght = (EXNamecount * 2);
                    //ExamsType (TERMs) Count END


                    //Subject List Load START

                    utl1 = new Utilities();
                    DataSet ds = new DataSet();
                    string query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
                    ds = utl1.GetDataset(query);

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += "<td colspan='" + thlenght + "' align='center'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></td>";
                        }
                    }

                    //Subject List Load END


                    //Aggregate TD START
                    int Aggcnt = ((ds.Tables[0].Rows.Count) * 2);
                    stroption += "<td colspan='" + Aggcnt + "' align='center'><b>Aggregate</b></td><td rowspan='3'><b>Over All Total</b></td><td rowspan='3'><b>% of Total</b></td><td rowspan='3'><b>Total No. of Days Present</b></td><td rowspan='3'><b>% of Attendance</b></td><td rowspan='3'><b>Remark</b></td><td rowspan='3'><b>Class Teacher Intial</b></td>";
                    //Aggregate TD END


                    //TERM LIST ROW -1 START 
                    stroption += "<tr>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            foreach (string EXTypeID in ExamTypeName)
                            {
                                if (EXTypeID != "")
                                {
                                    string query1 = "select ExamName from p_examnamelist where ExamNameID='" + EXTypeID + "' and AcademicID='" + AcademicID + "'";
                                    string ExTypeName = utl.ExecuteScalar(query1);
                                    stroption += "<td colspan='2' align='center'>" + ExTypeName + "</td>";
                                }
                            }                            
                        }
                    }


                    //Aggregate Subject List START

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += "<td colspan='2' align='center'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></td>";
                        }
                    }

                    //Aggregate Subject List  End

                    stroption += "</tr>";

                    //TERM LIST ROW -1 END


                    //TERM LIST ROW -2 START 

                    stroption += "<tr>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            foreach (string EXTypeID in ExamTypeName)
                            {
                                if (EXTypeID != "")
                                {
                                    stroption += "<td>FA(40)</td><td>SA(60)</td>";
                                }
                            }
                        }
                    }


                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += "<td>FA(40)</td><td>SA(60)</td>";
                        }
                    }

                    stroption += "</tr>";
                    //TERM LIST ROW -2 END 


                    //Student Mark Details Normal - START

                    int p = 0;
                    int SACnt = 0;
                    for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                    {
                        decimal TotMarksPercetage = 0;

                        if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                        {
                            Tempstroption = string.Empty;
                            int Adjmark = Convert.ToInt32(C3_Passmark.ToString());
                            string chkstatus = string.Empty;
                            int FAPassmark = 14;
                            int SAPassmark = 21;
                          
                            proStatus = "";

                            p = p + 1;

                            stroption += "<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Sex"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["CommunityName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td>";

                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                //All Term Marks display [except P1,p2,p2 calc] - START
                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    double FAtot = 0;
                                    double FBtot = 0;
                                    double FABTotal = 0;
                                    double SAtot = 0;
                                    
                                    foreach (string EXTypeID in ExamTypeName)
                                    {
                                        if (EXTypeID != "")
                                        {
                                            DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drFAScroedMarkTOT.Length > 0)
                                            {
                                                if (drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    FAtot = Convert.ToDouble(drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    FAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                FAtot = 0;
                                            }

                                            DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drFBScroedMarkTOT.Length > 0)
                                            {
                                                if (drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    FBtot = Convert.ToDouble(drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    FBtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                FBtot = 0;
                                            }

                                            FABTotal = FAtot + FBtot;
                                            FABTotal = Convert.ToInt32(Math.Round(FABTotal, 0, MidpointRounding.AwayFromZero));
                                            stroption += "<td>" + FABTotal.ToString() + "</td>";

                                            DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drSAScroedMarkTOT.Length > 0)
                                            {
                                                if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SACnt = 1;
                                                    SAtot = Convert.ToDouble(drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    SAtot = Convert.ToInt32(Math.Round(SAtot, 0, MidpointRounding.AwayFromZero));
                                                    stroption += "<td>" + SAtot + "</td>";                                                    
                                                }
                                                else
                                                {
                                                    stroption += "<td>A</td>";
                                                    SAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                stroption += "<td>A</td>";
                                                SAtot = 0;
                                            }                                           
                                                                                                                    
                                        }
                                    }
                                                                       
                                }
                                //All Term Marks display [except P1,p2,p2 calc] - END       

                                
                                //Total Mark Cal Culation for (Three Term using FA and SA) [Pass or Fail] - START

                                double Ex_OverallTotal = 0;
                                double P_MarksPercetage = 0;

                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    double P_FABTotal = 0;
                                    double P_SATotal = 0;
                                    double P_FABTotalAVG = 0;
                                    double P_SATotalAVG = 0;

                                    int P_SAcnt = 0;

                                    foreach (string EXTypeID in ExamTypeName)
                                    {
                                        if (EXTypeID != "")
                                        {
                                            double FAtot = 0;
                                            double FBtot = 0;
                                            double FABTotal = 0;
                                            double SAtot = 0;                                          

                                            DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drFAScroedMarkTOT.Length > 0)
                                            {
                                                if (drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {                                                    
                                                    FAtot = Convert.ToDouble(drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    FAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                FAtot = 0;
                                            }

                                            DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drFBScroedMarkTOT.Length > 0)
                                            {
                                                if (drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    FBtot = Convert.ToDouble(drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    FBtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                FBtot = 0;
                                            }

                                            FABTotal = FAtot + FBtot;
                                            FABTotal = Convert.ToInt32(Math.Round(FABTotal, 0, MidpointRounding.AwayFromZero));
                                            P_FABTotal += FABTotal;

                                            DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drSAScroedMarkTOT.Length > 0)
                                            {
                                                if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    P_SAcnt = P_SAcnt + 1;
                                                    SAtot = Convert.ToDouble(drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    SAtot = Convert.ToInt32(Math.Round(SAtot, 0, MidpointRounding.AwayFromZero));
                                                }
                                                else
                                                {                                                    
                                                    SAtot = 0;
                                                }
                                            }

                                            else
                                            {                                               
                                                SAtot = 0;
                                            }

                                            P_SATotal += SAtot;

                                        }
                                    }

                                    P_FABTotalAVG = P_FABTotal / EXNamecount;
                                    P_SATotalAVG = P_SATotal / P_SAcnt;

                                   

                                    if (P_FABTotal!=0)
                                    {
                                         P_FABTotalAVG = Convert.ToDouble(Convert.ToInt32(Math.Round(P_FABTotalAVG, 0, MidpointRounding.AwayFromZero)).ToString());
                                    }
                                    else
                                    {
                                        P_FABTotalAVG = 0;
                                    }
                                    if (P_SATotal!=0)
                                    {
                                        P_SATotalAVG = Convert.ToDouble(Convert.ToInt32(Math.Round(P_SATotalAVG, 0, MidpointRounding.AwayFromZero)).ToString());
                                    }
                                    else
                                    {
                                        P_SATotalAVG = 0;
                                    }
                                  
                                    double subjectTotal = (P_FABTotalAVG + P_SATotalAVG);

                                    Ex_OverallTotal += subjectTotal;

                                    stroption += @"<td>" + P_FABTotalAVG + "</td><td>" + P_SATotalAVG + "</td>";

                                    //Remarks Check [Promoted or Detained] - START
                                    if (proStatus != "DETAINED")
                                    {
                                        if (P_FABTotalAVG >= FAPassmark && P_SATotalAVG >= SAPassmark)
                                        {
                                            proStatus = "PROMOTED";
                                        }
                                        else
                                        {
                                            proStatus = "DETAINED";
                                        }
                                    }
                                    //Remarks Check [Promoted or Detained] - END


                                    //Insert Into PromotionList DB - START                                  

                                    proInsertQuery = "sp_PromotionList_IX_Insert '" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "','" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "','" + dsGet.Tables[0].Rows[i]["ClassID"].ToString() + "','" + dsGet.Tables[0].Rows[i]["SectionID"].ToString() + "','" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "','" + Convert.ToInt32(Math.Round(P_FABTotalAVG, 0, MidpointRounding.AwayFromZero)).ToString() + "','" + Convert.ToInt32(Math.Round(P_SATotalAVG, 0, MidpointRounding.AwayFromZero)).ToString() + "','" + Convert.ToInt32(Math.Round(subjectTotal, 0, MidpointRounding.AwayFromZero)).ToString() + "','" + Convert.ToInt32(Math.Round(subjectTotal, 0, MidpointRounding.AwayFromZero)).ToString() + "','" + AcademicID + "','" + Userid + "'";
                                    utl.ExecuteQuery(proInsertQuery);

                                    //Insert Into PromotionList DB - END

                                }

                                Ex_OverallTotal = Convert.ToDouble(Convert.ToInt32(Math.Round(Ex_OverallTotal, 0, MidpointRounding.AwayFromZero)).ToString());
                                P_MarksPercetage = Ex_OverallTotal / ds.Tables[0].Rows.Count;

                                stroption += @"<td>" + Ex_OverallTotal + "</td><td>" + Math.Round(P_MarksPercetage, 2) + "</td>";

                                //Total Mark Cal Culation for (Three Term using FA and SA) [Pass or Fail] - END
                                
                                //Student Attendance Details -START
                                string StudRegno = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                                string studAtt = Attenance(StudRegno);
                                double StudPresentdays = Convert.ToDouble(studAtt);
                                double Attpercentage = (StudPresentdays / totdays) * 100;

                                stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>" + proStatus + "</td><td>&nbsp;</td></tr>";
                                //Student Attendance Details -END

                                //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                proUpdateQuery = "update p_promotionList set OverAllTotal='" + Ex_OverallTotal.ToString() + "', TotalPercn='" + Math.Round(P_MarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Remarks='" + proStatus + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                utl.ExecuteQuery(proUpdateQuery);
                                //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]
                                
                            }
                            
                            examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                        }
                    }

                    //Student Mark Details - END

                    stroption += "</tbody></table><br/><br/>";
                    dvContent.Append(stroption);

                    //Cumulative List -Start

                    string sqlquery = string.Empty;
                    DataSet dscnt = new DataSet();


                    sqlquery = "getPromotionCount " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
                    dscnt = utl.GetDataset(sqlquery);
                    if (dscnt.Tables.Count > 0)
                    {
                        dvContent.Append("<table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'> <thead><tr><th colspan='2'>&nbsp;</th><th colspan='3'><b>GENERAL</b></th><th colspan='3'><b>SC</b></th></tr></thead><tbody><tr><td colspan='2'>&nbsp;</td><td>Boys</td><td>Girls</td><td>Total</td><td>Boys</td><td>Girls</td><td>Total</td></tr><tr><td colspan='2'>Total No of Students</td><td>" + dscnt.Tables[0].Rows[0]["TotalBoys"].ToString() + "</td><td>" + dscnt.Tables[1].Rows[0]["TotalGirls"].ToString() + "</td><td>" + dscnt.Tables[2].Rows[0]["TotalStudents"].ToString() + "</td><td>" + dscnt.Tables[3].Rows[0]["TotalSCBoys"].ToString() + "</td><td>" + dscnt.Tables[4].Rows[0]["TotalSCGirls"].ToString() + "</td><td>" + dscnt.Tables[5].Rows[0]["TotalSCStudents"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Appeared</td><td>" + dscnt.Tables[6].Rows[0]["TotalBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[7].Rows[0]["TotalGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[8].Rows[0]["TotalStudentsAppeared"].ToString() + "</td><td>" + dscnt.Tables[9].Rows[0]["TotalSCBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[10].Rows[0]["TotalSCGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[11].Rows[0]["TotalSCStudentsAppeared"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Promoted</td><td>" + dscnt.Tables[12].Rows[0]["TotalBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[13].Rows[0]["TotalGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[14].Rows[0]["TotalStudentsPromoted"].ToString() + "</td><td>" + dscnt.Tables[15].Rows[0]["TotalSCBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[16].Rows[0]["TotalSCGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[17].Rows[0]["TotalSCStudentsPromoted"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Detained</td><td>" + dscnt.Tables[18].Rows[0]["TotalBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[19].Rows[0]["TotalGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[20].Rows[0]["TotalStudentsDetained"].ToString() + "</td><td>" + dscnt.Tables[21].Rows[0]["TotalSCBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[22].Rows[0]["TotalSCGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[23].Rows[0]["TotalSCStudentsDetained"].ToString() + "</td></tr></tbody></table>");
                    }

                    //Cumulative List -End

                }

                else
                {
                    dvContent.Append("<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td colspan='6'>No Data</td></tr></table>");
                }

                dvC1_Content.InnerHtml = dvContent.ToString();
            }

        }
        catch (Exception)
        {
            throw;
        }

    }
    //C1 Samacheer Marks function -  End   


    private void LOAD_RESULT_SAMACHEER_Export()
    {
        try
        {
            if (C1_ExamNameID != "")
            {
                utl = new Utilities();

                string proInsertQuery = string.Empty;
                string proUpdateQuery = string.Empty;
                string Tempstroption;
                int chk = 0;
                string examnochk = string.Empty;
                string proStatus = string.Empty;
                string proChk = string.Empty;

                decimal Max_Mark = 0;
                decimal Calc_Mark = 0;

                DataSet dsGet = new DataSet(); //ALL_ExamNameIDs  SubjectListID  ALL_ExamNameIDs  ddlType.SelectedItem.Text

                sqlstr = "sp_Promo_getCCEpromotion " + Session["strClassID"] + "," + Session["strSectionID"] + "," + "'" + ALL_ExamNameIDs + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + SubjectListID + "'" + "," + AcademicID;

                dsGet = utl.GetDataset(sqlstr);
                StringBuilder dvContent = new StringBuilder();

                dvContent.Append(Disp_SchoolName());//SchoolName Bind 

                int EXNamecount = 0;
                string[] ExamTypeName;


                if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                {
                    dvContent.Append("<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tbody>");

                    stroption += "<tr><td rowspan='3'><b>Sl No</b></td><td rowspan='3'><b>Adm No</b></td><td rowspan='3'><b>Reg No</b></td><td rowspan='3'><b>Exam No</b></td><td rowspan='3'><b>Name of the student</b></td><td rowspan='3'><b>Sex</b></td><td rowspan='3'><b>Category</b></td><td rowspan='3'><b>Date of birth</b></td>";


                    //ExamsType (TERMs) Count START
                    EXNamecount = 0;
                    ExamTypeName = C2ALL_ExamNameIDs.Split(',');
                    foreach (string EXName in ExamTypeName)
                    {
                        if (EXName != "")
                        {
                            EXNamecount = EXNamecount + 1;
                        }
                    }
                    int thlenght = (EXNamecount * 2);
                    //ExamsType (TERMs) Count END


                    //Subject List Load START

                    utl1 = new Utilities();
                    DataSet ds = new DataSet();
                    string query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
                    ds = utl1.GetDataset(query);

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += "<td colspan='" + thlenght + "' align='center'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></td>";
                        }
                    }

                    //Subject List Load END


                    //Aggregate TD START
                    int Aggcnt = ((ds.Tables[0].Rows.Count) * 2);
                    stroption += "<td colspan='" + Aggcnt + "' align='center'><b>Aggregate</b></td><td rowspan='3'><b>Over All Total</b></td><td rowspan='3'><b>% of Total</b></td><td rowspan='3'><b>Total No. of Days Present</b></td><td rowspan='3'><b>% of Attendance</b></td><td rowspan='3'><b>Remark</b></td><td rowspan='3'><b>Class Teacher Intial</b></td>";
                    //Aggregate TD END


                    //TERM LIST ROW -1 START 
                    stroption += "<tr>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            foreach (string EXTypeID in ExamTypeName)
                            {
                                if (EXTypeID != "")
                                {
                                    string query1 = "select ExamName from p_examnamelist where ExamNameID='" + EXTypeID + "' and AcademicID='" + AcademicID + "'";
                                    string ExTypeName = utl.ExecuteScalar(query1);
                                    stroption += "<td colspan='2' align='center'>" + ExTypeName + "</td>";
                                }
                            }
                        }
                    }


                    //Aggregate Subject List START

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += "<td colspan='2' align='center'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></td>";
                        }
                    }

                    //Aggregate Subject List  End

                    stroption += "</tr>";

                    //TERM LIST ROW -1 END


                    //TERM LIST ROW -2 START 

                    stroption += "<tr>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            foreach (string EXTypeID in ExamTypeName)
                            {
                                if (EXTypeID != "")
                                {
                                    stroption += "<td>FA(40)</td><td>SA(60)</td>";
                                }
                            }
                        }
                    }


                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += "<td>FA(40)</td><td>SA(60)</td>";
                        }
                    }

                    stroption += "</tr>";
                    //TERM LIST ROW -2 END 


                    //Student Mark Details Normal - START

                    int p = 0;
                    int SACnt = 0;
                    for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                    {
                        decimal TotMarksPercetage = 0;

                        if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                        {
                            Tempstroption = string.Empty;
                            int Adjmark = Convert.ToInt32(C3_Passmark.ToString());
                            string chkstatus = string.Empty;
                            int FAPassmark = 14;
                            int SAPassmark = 21;

                            proStatus = "";

                            p = p + 1;

                            stroption += "<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Sex"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["CommunityName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td>";

                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                //All Term Marks display [except P1,p2,p2 calc] - START
                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    double FAtot = 0;
                                    double FBtot = 0;
                                    double FABTotal = 0;
                                    double SAtot = 0;

                                    foreach (string EXTypeID in ExamTypeName)
                                    {
                                        if (EXTypeID != "")
                                        {
                                            DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drFAScroedMarkTOT.Length > 0)
                                            {
                                                if (drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    FAtot = Convert.ToDouble(drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    FAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                FAtot = 0;
                                            }

                                            DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drFBScroedMarkTOT.Length > 0)
                                            {
                                                if (drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    FBtot = Convert.ToDouble(drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    FBtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                FBtot = 0;
                                            }

                                            FABTotal = FAtot + FBtot;
                                            SAtot = Convert.ToInt32(Math.Round(SAtot, 0, MidpointRounding.AwayFromZero));
                                            stroption += "<td>" + FABTotal.ToString() + "</td>";

                                            DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drSAScroedMarkTOT.Length > 0)
                                            {
                                                if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SACnt = 1;
                                                    SAtot = Convert.ToDouble(drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    SAtot = Convert.ToInt32(Math.Round(SAtot, 0, MidpointRounding.AwayFromZero));
                                                    stroption += "<td>" + SAtot + "</td>";

                                                }
                                                else
                                                {
                                                    stroption += "<td>A</td>";
                                                    SAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                stroption += "<td>A</td>";
                                                SAtot = 0;
                                            }

                                        }
                                    }

                                }
                                //All Term Marks display [except P1,p2,p2 calc] - END       


                                //Total Mark Cal Culation for (Three Term using FA and SA) [Pass or Fail] - START

                                double Ex_OverallTotal = 0;
                                double P_MarksPercetage = 0;

                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    double P_FABTotal = 0;
                                    double P_SATotal = 0;
                                    double P_FABTotalAVG = 0;
                                    double P_SATotalAVG = 0;

                                    int P_SAcnt = 0;

                                    foreach (string EXTypeID in ExamTypeName)
                                    {
                                        if (EXTypeID != "")
                                        {
                                            double FAtot = 0;
                                            double FBtot = 0;
                                            double FABTotal = 0;
                                            double SAtot = 0;

                                            DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drFAScroedMarkTOT.Length > 0)
                                            {
                                                if (drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    FAtot = Convert.ToDouble(drFAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    FAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                FAtot = 0;
                                            }

                                            DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drFBScroedMarkTOT.Length > 0)
                                            {
                                                if (drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    FBtot = Convert.ToDouble(drFBScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    FBtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                FBtot = 0;
                                            }

                                            FABTotal = FAtot + FBtot;
                                            FABTotal = Convert.ToInt32(Math.Round(FABTotal, 0, MidpointRounding.AwayFromZero));
                                            P_FABTotal += FABTotal;

                                            DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drSAScroedMarkTOT.Length > 0)
                                            {
                                                if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    P_SAcnt = P_SAcnt + 1;
                                                    SAtot = Convert.ToDouble(drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                }
                                                else
                                                {
                                                    SAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                SAtot = 0;
                                            }
                                            SAtot = Convert.ToInt32(Math.Round(SAtot, 0, MidpointRounding.AwayFromZero));
                                            P_SATotal += SAtot;

                                        }
                                    }


                                    P_FABTotalAVG = P_FABTotal / EXNamecount;
                                    P_SATotalAVG = P_SATotal / P_SAcnt;

                                    if (P_FABTotal != 0)
                                    {
                                        P_FABTotalAVG = Convert.ToDouble(Convert.ToInt32(Math.Round(P_FABTotalAVG, 0, MidpointRounding.AwayFromZero)).ToString());
                                    }
                                    else
                                    {
                                        P_FABTotalAVG = 0;
                                    }
                                    if (P_SATotal != 0)
                                    {
                                        P_SATotalAVG = Convert.ToDouble(Convert.ToInt32(Math.Round(P_SATotalAVG, 0, MidpointRounding.AwayFromZero)).ToString());
                                    }
                                    else
                                    {
                                        P_SATotalAVG = 0;
                                    }
                                  

                                    Ex_OverallTotal += (P_FABTotalAVG + P_SATotalAVG);

                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(P_FABTotalAVG, 0, MidpointRounding.AwayFromZero)).ToString() + "</td><td>" + Convert.ToInt32(Math.Round(P_SATotalAVG, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";

                                    //Remarks Check [Promoted or Detained] - START
                                    if (proStatus != "Detained")
                                    {
                                        if (P_FABTotalAVG >= FAPassmark && P_SATotalAVG >= SAPassmark)
                                        {
                                            proStatus = "Promoted";
                                        }
                                        else
                                        {
                                            proStatus = "Detained";
                                        }
                                    }
                                    //Remarks Check [Promoted or Detained] - END

                                }

                                Ex_OverallTotal = Convert.ToDouble(Convert.ToInt32(Math.Round(Ex_OverallTotal, 0, MidpointRounding.AwayFromZero)).ToString());
                                P_MarksPercetage = Ex_OverallTotal / ds.Tables[0].Rows.Count;

                                stroption += @"<td>" + Ex_OverallTotal + "</td><td>" + Math.Round(P_MarksPercetage, 2) + "</td>";

                                //Total Mark Cal Culation for (Three Term using FA and SA) [Pass or Fail] - END

                                //Student Attendance Details -START
                                string StudRegno = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                                string studAtt = Attenance(StudRegno);
                                double StudPresentdays = Convert.ToDouble(studAtt);
                                double Attpercentage = (StudPresentdays / totdays) * 100;

                                stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>" + proStatus + "</td><td>&nbsp;</td></tr>";
                                //Student Attendance Details -END

                            }

                            examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                        }
                    }

                    //Student Mark Details - END

                    stroption += "</tbody></table><br/><br/>";
                    dvContent.Append(stroption);

                    //Cumulative List -Start

                    string sqlquery = string.Empty;
                    DataSet dscnt = new DataSet();


                    sqlquery = "getPromotionCount " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
                    dscnt = utl.GetDataset(sqlquery);
                    if (dscnt.Tables.Count > 0)
                    {
                        dvContent.Append("<table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'> <thead><tr><th colspan='2'>&nbsp;</th><th colspan='3'><b>GENERAL</b></th><th colspan='3'><b>SC</b></th></tr></thead><tbody><tr><td colspan='2'>&nbsp;</td><td>Boys</td><td>Girls</td><td>Total</td><td>Boys</td><td>Girls</td><td>Total</td></tr><tr><td colspan='2'>Total No of Students</td><td>" + dscnt.Tables[0].Rows[0]["TotalBoys"].ToString() + "</td><td>" + dscnt.Tables[1].Rows[0]["TotalGirls"].ToString() + "</td><td>" + dscnt.Tables[2].Rows[0]["TotalStudents"].ToString() + "</td><td>" + dscnt.Tables[3].Rows[0]["TotalSCBoys"].ToString() + "</td><td>" + dscnt.Tables[4].Rows[0]["TotalSCGirls"].ToString() + "</td><td>" + dscnt.Tables[5].Rows[0]["TotalSCStudents"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Appeared</td><td>" + dscnt.Tables[6].Rows[0]["TotalBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[7].Rows[0]["TotalGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[8].Rows[0]["TotalStudentsAppeared"].ToString() + "</td><td>" + dscnt.Tables[9].Rows[0]["TotalSCBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[10].Rows[0]["TotalSCGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[11].Rows[0]["TotalSCStudentsAppeared"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Promoted</td><td>" + dscnt.Tables[12].Rows[0]["TotalBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[13].Rows[0]["TotalGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[14].Rows[0]["TotalStudentsPromoted"].ToString() + "</td><td>" + dscnt.Tables[15].Rows[0]["TotalSCBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[16].Rows[0]["TotalSCGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[17].Rows[0]["TotalSCStudentsPromoted"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Detained</td><td>" + dscnt.Tables[18].Rows[0]["TotalBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[19].Rows[0]["TotalGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[20].Rows[0]["TotalStudentsDetained"].ToString() + "</td><td>" + dscnt.Tables[21].Rows[0]["TotalSCBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[22].Rows[0]["TotalSCGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[23].Rows[0]["TotalSCStudentsDetained"].ToString() + "</td></tr></tbody></table>");
                    }

                    //Cumulative List -End

                    //subject list -START
                    DataSet ds_subject = new DataSet();
                    string sublist_query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
                    ds_subject = utl.GetDataset(sublist_query);

                    if (ds_subject != null && ds_subject.Tables.Count > 0 && ds_subject.Tables[0].Rows.Count > 0)
                    {
                        dvContent.Append("<br/><br/><br/><br/><table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'><tr><td><table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'><thead><tr><th><b>SUBJECT</b></th><th><b>NAME OF THE TEACHER</b></th><th><b>SIGNATURE</b></th></tr></thead><tbody>");

                        for (int z = 0; z < ds_subject.Tables[0].Rows.Count; z++)
                        {

                            dvContent.Append("<tr><td>" + ds_subject.Tables[0].Rows[z]["SubjectName"].ToString() + "</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
                        }
                        

                        dvContent.Append("</tbody></table></td><td width='50px;'></td><td><table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'><tbody><tr><td><b>CHECKED BY : </b></td></tr><tr><td><b>SIGNATURE OF THE CLASS TEACHER :</b></td></tr><tr><td><b>SIGNATURE OF THE HEAD OF INSTITUTION :</b></td></tr></tbody></table></td></tr></table>");
                        
                    }

                    //subject list -END

                }

                else
                {
                    dvContent.Append("<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td colspan='6'>No Data</td></tr></table>");
                }

                dvC1_Content.InnerHtml = dvContent.ToString();
            }

        }
        catch (Exception)
        {
            throw;
        }

    }


}