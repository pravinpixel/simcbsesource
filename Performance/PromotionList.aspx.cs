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


public partial class Performance_PromotionList : System.Web.UI.Page
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
        if (ddlClass.SelectedItem.Text == "---Select---" || ddlClass.SelectedItem.Value == "---Select---")
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
        string sqlquery = "select PSD.ExamIdList1,PSD.ShortName1,PSD.MarkPercentage1 from p_promotionsetup PS inner join p_promotionsetupdetails PSD on PS.PromotionId =PSD.PromotionId where PS.ClassID='" + Convert.ToInt32(Session["strClassID"]) + "' and PS.IsActive=1 and PSD.IsActive=1 and PS.Type='CaseI'  and PS.AcademicID='" + AcademicID + "' and PSD.AcademicID='" + AcademicID + "'";
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
            if (ds.Tables[0].Rows[0]["ExamIdList1"].ToString()!="")
            {
                if (C2ALL_ExamNameIDs!="")
                {
                    C2ALL_ExamNameIDs = C2ALL_ExamNameIDs+"," + ds.Tables[0].Rows[0]["ExamIdList1"].ToString();
                }
                else
                {
                    C2ALL_ExamNameIDs = ds.Tables[0].Rows[0]["ExamIdList1"].ToString();
                }
            }

           

            if (ds.Tables[0].Rows[0]["ExamIdList2"].ToString() != "")
            {
                if (C2ALL_ExamNameIDs != "")
                {
                    C2ALL_ExamNameIDs = C2ALL_ExamNameIDs + "," + ds.Tables[0].Rows[0]["ExamIdList2"].ToString();
                }
                else
                {
                    C2ALL_ExamNameIDs = ds.Tables[0].Rows[0]["ExamIdList2"].ToString();
                }
            }

            if (ds.Tables[0].Rows[0]["ExamIdList3"].ToString() != "")
            {
                if (C2ALL_ExamNameIDs != "")
                {
                    C2ALL_ExamNameIDs = C2ALL_ExamNameIDs + "," + ds.Tables[0].Rows[0]["ExamIdList3"].ToString();
                }
                else
                {
                    C2ALL_ExamNameIDs = ds.Tables[0].Rows[0]["ExamIdList3"].ToString();
                }
            }

            if (ds.Tables[0].Rows[0]["ExamIdList4"].ToString() != "")
            {
                if (C2ALL_ExamNameIDs != "")
                {
                    C2ALL_ExamNameIDs = C2ALL_ExamNameIDs + "," + ds.Tables[0].Rows[0]["ExamIdList4"].ToString();
                }
                else
                {
                    C2ALL_ExamNameIDs = ds.Tables[0].Rows[0]["ExamIdList4"].ToString();
                }
            }
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
            if (C2ALL_ExamNameIDs!="")
            {
                ALL_ExamNameIDs = C1_ExamNameID + "," + C2ALL_ExamNameIDs;
            }
            else
            {
                ALL_ExamNameIDs = C1_ExamNameID;
            }
           
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
            ALL_ExamNameIDs = C1_ExamNameID+ "," + C2ALL_ExamNameIDs;
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
                chk = "true";
                if (chk == "true")
                {
                    Disp_SubjectList();
                    LOAD_Totdays();

                    C1_Disp_ExamNameID();
                    C2_Disp_ExamNameID();
                    C3_Disp_ExamNameID();

                    if (ddlType.Text == "General")
                    {
                        Disp_AllExamNameID_GENERAL();
                        LOAD_RESULT_GENERAL();
                    }

                    else
                    {
                        Disp_AllExamNameID_SAMACHEER();
                        LOAD_RESULT_SAMACHEER();
                    }
                }

            }


        }

        catch (Exception ex)
        {
            utl.ShowMessage("<script>AlertMessage('info', '" + ex.Message + "');</script>", this.Page);
        }
    }



    private void LOAD_RESULT_GENERAL_Export()
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

                DataSet dsGet = new DataSet();

                sqlstr = "sp_Promo_getCCEpromotion " + Session["strClassID"] + "," + Session["strSectionID"] + "," + "'" + ALL_ExamNameIDs + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + SubjectListID + "'" + "," + AcademicID;

                dsGet = utl.GetDataset(sqlstr);
                StringBuilder dvContent = new StringBuilder();

                dvContent.Append(Disp_SchoolName());//SchoolName Bind 

                if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                {
                    dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%>");
                    stroption += @"<thead><tr><th colspan='8'>&nbsp;</th>";

                    utl1 = new Utilities();
                    DataSet ds = new DataSet();
                    string query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
                    ds = utl1.GetDataset(query);

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<th  colspan='5'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></th>";
                        }
                    }

                    stroption += @"<th colspan='" + ds.Tables[0].Rows.Count + "'><b>Aggregate</b></th><th><b>Over All Total</b></th><th><b>% of Total</b></th><th>Total No. of Days Present</th><th>% of Attendance</th><th>Result</th><th>Remark</th></tr></thead>";

                    stroption += @"<tr> <td>Sl No</td><td>Adm No</td><td>Reg No</td><td>Exam No</td><td>Name of the student</td><td>Sex</td><td>Category</td><td>Date of birth</td>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td>" + C2EX1_ExamNames + "</td><td>" + C2EX2_ExamNames + "</td><td>" + C2EX3_ExamNames + "</td><td>" + C2EX4_ExamNames + "</td><td>Tot</td>";
                        }
                    }


                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            string subject = ds.Tables[0].Rows[j]["SubjectName"].ToString();
                            stroption += @"<td>" + subject[0] + "</td>";
                        }
                    }


                    stroption += @"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td colspan='8'>&nbsp;</td>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td>" + C2EX1_MarkPercn + "</td><td>" + C2EX2_MarkPercn + "</td><td>" + C2EX3_MarkPercn + "</td><td>" + C2EX4_MarkPercn + "</td><td>100</td>";
                        }
                    }


                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td>100</td>";
                        }
                    }


                    stroption += @"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";

                    //Subject List Load End

                    int p = 0;

                    for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                    {
                        decimal MarksPercetage = 0;
                        decimal overall = 0;

                        if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                        {
                            Tempstroption = string.Empty;

                            int Adjmark = Convert.ToInt32(C3_Passmark.ToString());
                            string chkstatus = string.Empty;
                            int p1cnt = 0;
                            int p2cnt = 0;
                            int p2modcnt = 0;
                            int Failcnt = 0;

                            proStatus = "";
                            p = p + 1;

                            stroption += "<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Sex"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["CommunityName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td>";


                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    decimal Sub_Total = 0;
                                    decimal SubjectMark = 0;
                                    decimal SubNew_Mark = 0;
                                    decimal disp_mark = 0;
                                    decimal Ex_Total = 0;
                                    decimal Ex_OverallTotal = 0;
                                    Calc_Mark = 0;

                                    //ExamIDList1 MidTerm Marks Calculation -Start
                                    string[] C2EX1_ExamNameID = C2EX1_ExamNameIDs.Split(',');
                                    int C2EX1_Length = C2EX1_ExamNameID.Length;

                                    foreach (string SEX1_ExamNameID in C2EX1_ExamNameID)
                                    {
                                        Max_Mark = 0;

                                        if (SEX1_ExamNameID != "")
                                        {


                                            DataRow[] drScroedMarkTOT = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drScroedMarkTOT.Length > 0)
                                            {
                                                if (drScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SubjectMark = Convert.ToDecimal(drScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    Max_Mark = Convert.ToDecimal(drScroedMarkTOT[0]["MaxMark"].ToString());
                                                }
                                                else
                                                {
                                                    SubjectMark = 0;
                                                }
                                            }

                                            else
                                            {
                                                SubjectMark = 0;
                                            }


                                            if (SubjectMark != 0)
                                            {
                                                SubNew_Mark = ((Convert.ToDecimal(SubjectMark / Max_Mark)) * Convert.ToDecimal(C2EX1_MarkPercn));
                                            }
                                            else
                                            {
                                                SubNew_Mark = 0;
                                            }

                                            Sub_Total += SubNew_Mark;
                                        }
                                    }

                                    if (Sub_Total != 0)
                                    {
                                        Calc_Mark += Convert.ToDecimal(C2EX1_MarkPercn);
                                    }
                                    if (C2EX1_Length != 0)
                                    {
                                        disp_mark = Sub_Total / C2EX1_Length;
                                    }

                                    Ex_Total += Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero));
                                    stroption += "<td>" + Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero)) + "</td>";
                                    //ExamIDList1 MidTerm Marks Calculation -End


                                    //ExamIDList2 MidTerm Marks Calculation -Start
                                    Sub_Total = 0;
                                    SubjectMark = 0;
                                    SubNew_Mark = 0;
                                    disp_mark = 0;


                                    string[] C2EX2_ExamNameID = C2EX2_ExamNameIDs.Split(',');
                                    int C2EX2_Length = C2EX2_ExamNameID.Length;

                                    foreach (string SEX2_ExamNameID in C2EX2_ExamNameID)
                                    {
                                        Max_Mark = 0;

                                        if (SEX2_ExamNameID != "")
                                        {

                                            DataRow[] drScroedMarkTOT = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX2_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drScroedMarkTOT.Length > 0)
                                            {
                                                if (drScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SubjectMark = Convert.ToDecimal(drScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    Max_Mark = Convert.ToDecimal(drScroedMarkTOT[0]["MaxMark"].ToString());
                                                }
                                                else
                                                {
                                                    SubjectMark = 0;
                                                }
                                            }

                                            else
                                            {
                                                SubjectMark = 0;
                                            }


                                            if (SubjectMark != 0)
                                            {
                                                SubNew_Mark = ((Convert.ToDecimal(SubjectMark / Max_Mark)) * Convert.ToDecimal(C2EX2_MarkPercn));
                                            }
                                            else
                                            {
                                                SubNew_Mark = 0;
                                            }

                                            Sub_Total += SubNew_Mark;
                                        }
                                    }

                                    if (Sub_Total != 0)
                                    {
                                        Calc_Mark += Convert.ToDecimal(C2EX2_MarkPercn);
                                    }
                                    if (C2EX2_Length != 0)
                                    {
                                        disp_mark = Sub_Total / C2EX2_Length;
                                    }

                                    Ex_Total += Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero));
                                    stroption += "<td>" + Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero)) + "</td>";
                                    //ExamIDList2 MidTerm Marks Calculation -End


                                    //ExamIDList3 MidTerm Marks Calculation -Start
                                    Sub_Total = 0;
                                    SubjectMark = 0;
                                    SubNew_Mark = 0;
                                    disp_mark = 0;


                                    string[] C2EX3_ExamNameID = C2EX3_ExamNameIDs.Split(',');
                                    int C2EX3_Length = C2EX3_ExamNameID.Length;

                                    foreach (string SEX3_ExamNameID in C2EX3_ExamNameID)
                                    {
                                        Max_Mark = 0;

                                        if (SEX3_ExamNameID != "")
                                        {


                                            DataRow[] drScroedMarkTOT = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX3_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drScroedMarkTOT.Length > 0)
                                            {
                                                if (drScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SubjectMark = Convert.ToDecimal(drScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    Max_Mark = Convert.ToDecimal(drScroedMarkTOT[0]["MaxMark"].ToString());
                                                }
                                                else
                                                {
                                                    SubjectMark = 0;
                                                }
                                            }

                                            else
                                            {
                                                SubjectMark = 0;
                                            }

                                            if (SubjectMark != 0)
                                            {
                                                SubNew_Mark = ((Convert.ToDecimal(SubjectMark / Max_Mark)) * Convert.ToDecimal(C2EX3_MarkPercn));
                                            }
                                            else
                                            {
                                                SubNew_Mark = 0;
                                            }
                                            Sub_Total += SubNew_Mark;
                                        }
                                    }

                                    if (Sub_Total != 0)
                                    {
                                        Calc_Mark += Convert.ToDecimal(C2EX3_MarkPercn);
                                    }
                                    if (C2EX3_Length != 0)
                                    {
                                        disp_mark = Sub_Total / C2EX3_Length;
                                    }

                                    Ex_Total += Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero));
                                    stroption += "<td>" + Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero)) + "</td>";
                                    //ExamIDList3 MidTerm Marks Calculation -End


                                    //ExamIDList4 MidTerm Marks Calculation -Start
                                    Sub_Total = 0;
                                    SubjectMark = 0;
                                    SubNew_Mark = 0;
                                    disp_mark = 0;

                                    string[] C2EX4_ExamNameID = C2EX4_ExamNameIDs.Split(',');
                                    int C2EX4_Length = C2EX4_ExamNameID.Length;

                                    foreach (string SEX4_ExamNameID in C2EX4_ExamNameID)
                                    {
                                        Max_Mark = 0;
                                        if (SEX4_ExamNameID != "")
                                        {


                                            DataRow[] drScroedMarkTOT = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX4_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drScroedMarkTOT.Length > 0)
                                            {
                                                if (drScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SubjectMark = Convert.ToDecimal(drScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    Max_Mark = Convert.ToDecimal(drScroedMarkTOT[0]["MaxMark"].ToString());
                                                }
                                                else
                                                {
                                                    SubjectMark = 0;
                                                }
                                            }

                                            else
                                            {
                                                SubjectMark = 0;
                                            }


                                            if (SubjectMark != 0)
                                            {
                                                SubNew_Mark = ((Convert.ToDecimal(SubjectMark / Max_Mark)) * Convert.ToDecimal(C2EX4_MarkPercn));
                                            }
                                            else
                                            {
                                                SubNew_Mark = 0;
                                            }

                                            Sub_Total += SubNew_Mark;
                                        }
                                    }

                                    if (Sub_Total != 0)
                                    {
                                        Calc_Mark += Convert.ToDecimal(C2EX4_MarkPercn);
                                    }
                                    if (C2EX4_Length != 0)
                                    {
                                        disp_mark = Sub_Total / C2EX4_Length;
                                    }

                                    Ex_Total += Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero));
                                    stroption += "<td>" + Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero)) + "</td>";
                                    //ExamIDList4 MidTerm Marks Calculation -End

                                    if (Ex_Total!=0)
                                    {
                                        Ex_OverallTotal = (Ex_Total / Calc_Mark) * 100;
                                    }
                                   
                                    Ex_OverallTotal = Convert.ToInt32(Math.Round(Ex_OverallTotal, 0, MidpointRounding.AwayFromZero));
                                    overall += Ex_OverallTotal;

                                    stroption += "<td>" + Ex_OverallTotal.ToString() + "</td>";

                                    Tempstroption += "<td>" + Ex_OverallTotal.ToString() + "</td>"; //Total Marks for Each Subject -START



                                    //Mark Check For Case1 -START

                                    DataRow[] drChkCase1 = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + C1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                    if (drChkCase1.Length > 0)
                                    {
                                        if (drChkCase1[0]["ScoredMarkTotal"].ToString() != "")
                                        {
                                            SubjectMark = Convert.ToDecimal(drChkCase1[0]["ScoredMarkTotal"].ToString());
                                            Max_Mark = Convert.ToDecimal(drChkCase1[0]["MaxMark"].ToString());

                                            SubjectMark = (SubjectMark / Max_Mark) * 100;
                                        }
                                        else
                                        {
                                            SubjectMark = 0;
                                        }
                                    }

                                    else
                                    {
                                        SubjectMark = 0;
                                    }
                                    SubjectMark = Convert.ToInt32(Math.Round(SubjectMark, 0, MidpointRounding.AwayFromZero));
                                    if (SubjectMark >= Convert.ToDecimal(C1_Passmark))
                                    {
                                        chkstatus = "P1";
                                    }
                                    else if (Ex_OverallTotal >= Convert.ToDecimal(C2_Passmark))
                                    {
                                        chkstatus = "P2";
                                    }
                                    else
                                    {
                                        int markDiff = Convert.ToInt32(C2_Passmark) - Convert.ToInt32(Ex_OverallTotal);
                                        int actualmark;

                                        if (Adjmark >= markDiff)
                                        {
                                            chkstatus = "P2Mod";
                                            actualmark = Convert.ToInt32(Ex_OverallTotal) + markDiff;
                                        }
                                        else
                                        {
                                            chkstatus = "Fail";

                                        }
                                    }
                                    //Mark Details Update to DB - End




                                    //Check Individual TotalMarks for Promotion -Start


                                    //  if (proStatus != "P2Mod" && proStatus != "P2" && proStatus != "Fail")
                                    //  {

                                    if (SubjectMark >= Convert.ToDecimal(C1_Passmark))
                                    {
                                        proStatus = "P1";
                                        p1cnt = p1cnt + 1;
                                    }
                                    else if (Ex_OverallTotal >= Convert.ToDecimal(C2_Passmark))
                                    {
                                        proStatus = "P2";
                                        p2cnt = p2cnt + 1;
                                    }
                                    else
                                    {
                                        int markDiff = (Convert.ToInt32(C2_Passmark) - Convert.ToInt32(Ex_OverallTotal));
                                        int actualmark;

                                        if (Adjmark >= markDiff)
                                        {
                                            proStatus = "P2Mod";
                                            actualmark = Convert.ToInt32(Ex_OverallTotal) + markDiff;
                                            Adjmark = Adjmark - markDiff;
                                            p2modcnt = p2modcnt + 1;
                                        }
                                        else
                                        {
                                            proStatus = "Fail";
                                            Failcnt = Failcnt + 1;
                                        }
                                    }

                                    //  }

                                    //Check Individual TotalMarks for Promotion -End                                   
                                    //Mark Check For Case1 -END

                                }

                                stroption += Tempstroption;
                                if (overall!=0)
                                {
                                    MarksPercetage = overall / ds.Tables[0].Rows.Count;
                                }
                              
                                stroption += "<td>" + overall.ToString() + "</td><td>" + Math.Round(MarksPercetage, 2) + "</td>";

                                string StudRegno = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                                string studAtt = Attenance(StudRegno);
                                double StudPresentdays = Convert.ToDouble(studAtt);
                                double Attpercentage = (StudPresentdays / totdays) * 100;

                                //if (proStatus == "Fail")
                                //{
                                //    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>DETAINED</td><td>&nbsp;</td></tr>";
                                //}
                                //else
                                //{
                                //    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>" + proStatus + "</td></tr>";
                                //}


                                if (Failcnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>DETAINED</td><td>&nbsp;</td></tr>";
                                }
                                else if (p2modcnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P2Mod</td></tr>";
                                }
                                else if (p2cnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P2</td></tr>";
                                }
                                else
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P1</td></tr>";
                                }


                            }
                            examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                        }

                    }

                    stroption += @"</table>";
                    dvContent.Append(stroption);


                    //Cumulative List -Start

                    string sqlquery = string.Empty;
                    DataSet dscnt = new DataSet();

                    sqlquery = "getPromotionCount " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
                    dscnt = utl.GetDataset(sqlquery);
                    if (dscnt.Tables.Count > 0)
                    {
                        dvContent.Append(@"<table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'> <thead><tr><th colspan='2'>&nbsp;</th><th colspan='3'><b>GENERAL</b></th><th colspan='3'><b>SC</b></th></tr></thead><tbody><tr><td colspan='2'>&nbsp;</td><td>Boys</td><td>Girls</td><td>Total</td><td>Boys</td><td>Girls</td><td>Total</td></tr><tr><td colspan='2'>Total No of Students</td><td>" + dscnt.Tables[0].Rows[0]["TotalBoys"].ToString() + "</td><td>" + dscnt.Tables[1].Rows[0]["TotalGirls"].ToString() + "</td><td>" + dscnt.Tables[2].Rows[0]["TotalStudents"].ToString() + "</td><td>" + dscnt.Tables[3].Rows[0]["TotalSCBoys"].ToString() + "</td><td>" + dscnt.Tables[4].Rows[0]["TotalSCGirls"].ToString() + "</td><td>" + dscnt.Tables[5].Rows[0]["TotalSCStudents"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Appeared</td><td>" + dscnt.Tables[6].Rows[0]["TotalBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[7].Rows[0]["TotalGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[8].Rows[0]["TotalStudentsAppeared"].ToString() + "</td><td>" + dscnt.Tables[9].Rows[0]["TotalSCBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[10].Rows[0]["TotalSCGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[11].Rows[0]["TotalSCStudentsAppeared"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Promoted</td><td>" + dscnt.Tables[12].Rows[0]["TotalBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[13].Rows[0]["TotalGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[14].Rows[0]["TotalStudentsPromoted"].ToString() + "</td><td>" + dscnt.Tables[15].Rows[0]["TotalSCBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[16].Rows[0]["TotalSCGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[17].Rows[0]["TotalSCStudentsPromoted"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Detained</td><td>" + dscnt.Tables[18].Rows[0]["TotalBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[19].Rows[0]["TotalGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[20].Rows[0]["TotalStudentsDetained"].ToString() + "</td><td>" + dscnt.Tables[21].Rows[0]["TotalSCBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[22].Rows[0]["TotalSCGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[23].Rows[0]["TotalSCStudentsDetained"].ToString() + "</td></tr></tbody></table>");
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
                    dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td colspan='6'>No Data</td></tr></table>");
                }

                dvC1_Content.InnerHtml = dvContent.ToString();
            }

            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Promotion Setup Not Created');</script>", false);
            }

        }
        catch (Exception)
        {
            throw;
        }
    }

    //Main Search Function
    string stroption;

    //C1 General Marks function -  Start
    private void LOAD_RESULT_GENERAL()
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

                DataSet dsGet = new DataSet();

                sqlstr = "sp_Promo_getCCEpromotion " + Session["strClassID"] + "," + Session["strSectionID"] + "," + "'" + ALL_ExamNameIDs + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + SubjectListID + "'" + "," + AcademicID;

                dsGet = utl.GetDataset(sqlstr);
                StringBuilder dvContent = new StringBuilder();

                dvContent.Append(Disp_SchoolName());//SchoolName Bind 

                if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                {
                    dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%>");
                    stroption += @"<thead><tr><th colspan='8'>&nbsp;</th>";

                    utl1 = new Utilities();
                    DataSet ds = new DataSet();
                    string query = "SP_Promo_GETLANGUAGELIST " + Convert.ToInt32(Session["strClassID"]) + ",'a','" + AcademicID + "'";
                    ds = utl1.GetDataset(query);

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<th  colspan='5'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></th>";
                        }
                    }

                    stroption += @"<th colspan='" + ds.Tables[0].Rows.Count + "'><b>Aggregate</b></th><th><b>Over All Total</b></th><th><b>% of Total</b></th><th>Total No. of Days Present</th><th>% of Attendance</th><th>Result</th><th>Remark</th></tr></thead>";

                    stroption += @"<tr> <td>Sl No</td><td>Adm No</td><td>Reg No</td><td>Exam No</td><td>Name of the student</td><td>Sex</td><td>Category</td><td>Date of birth</td>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td>" + C2EX1_ExamNames + "</td><td>" + C2EX2_ExamNames + "</td><td>" + C2EX3_ExamNames + "</td><td>" + C2EX4_ExamNames + "</td><td>Tot</td>";
                        }
                    }


                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            string subject = ds.Tables[0].Rows[j]["SubjectName"].ToString();
                            stroption += @"<td>" + subject[0] + "</td>";
                        }
                    }


                    stroption += @"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td colspan='8'>&nbsp;</td>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td>" + C2EX1_MarkPercn + "</td><td>" + C2EX2_MarkPercn + "</td><td>" + C2EX3_MarkPercn + "</td><td>" + C2EX4_MarkPercn + "</td><td>100</td>";
                        }
                    }


                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td>100</td>";
                        }
                    }


                    stroption += @"<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";

                    //Subject List Load End

                    int p = 0;

                    for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                    {
                        decimal MarksPercetage = 0;
                        decimal overall = 0;

                        if (examnochk != dsGet.Tables[0].Rows[i]["RegNo"].ToString())
                        {
                            Tempstroption = string.Empty;

                            int Adjmark = Convert.ToInt32(C3_Passmark.ToString());
                            string chkstatus = string.Empty;
                            int p1cnt = 0;
                            int p2cnt = 0;
                            int p2modcnt = 0;
                            int Failcnt = 0;

                            proStatus = "";
                            p = p + 1;

                            stroption += "<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Sex"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["CommunityName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td>";


                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    decimal Sub_Total = 0;
                                    decimal SubjectMark = 0;
                                    decimal SubNew_Mark = 0;
                                    decimal disp_mark = 0;
                                    decimal Ex_Total = 0;
                                    decimal Ex_OverallTotal = 0;
                                    Calc_Mark = 0;

                                    //ExamIDList1 MidTerm Marks Calculation -Start
                                    string[] C2EX1_ExamNameID = C2EX1_ExamNameIDs.Split(',');
                                    int C2EX1_Length = 0;

                                    foreach (string SEX1_ExamNameID in C2EX1_ExamNameID)
                                    {
                                        Max_Mark = 0;
                                        if (SEX1_ExamNameID != "")
                                        {
                                            DataRow[] drScroedMarkTOT = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drScroedMarkTOT.Length > 0)
                                            {
                                                if (drScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SubjectMark = Convert.ToDecimal(drScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    Max_Mark = Convert.ToDecimal(drScroedMarkTOT[0]["MaxMark"].ToString());
                                                    C2EX1_Length += 1;
                                                }
                                                else
                                                {
                                                    SubjectMark = 0;
                                                }
                                            }

                                            else
                                            {
                                                SubjectMark = 0;
                                            }


                                            if (SubjectMark != 0)
                                            {
                                                SubNew_Mark = ((Convert.ToDecimal(SubjectMark / Max_Mark)) * Convert.ToDecimal(C2EX1_MarkPercn));
                                            }
                                            else
                                            {
                                                SubNew_Mark = 0;
                                            }

                                            Sub_Total += SubNew_Mark;
                                        }
                                    }

                                    if (Sub_Total != 0)
                                    {
                                        Calc_Mark += Convert.ToDecimal(C2EX1_MarkPercn);
                                    }
                                    if (C2EX1_Length != 0)
                                    {
                                        disp_mark = Sub_Total / C2EX1_Length;
                                    }

                                    Ex_Total += Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero));
                                    stroption += "<td>" + Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero)) + "</td>";

                                    //ExamIDList1 MidTerm Marks Calculation -End


                                    //ExamIDList2 MidTerm Marks Calculation -Start
                                    Sub_Total = 0;
                                    SubjectMark = 0;
                                    SubNew_Mark = 0;
                                    disp_mark = 0;


                                    string[] C2EX2_ExamNameID = C2EX2_ExamNameIDs.Split(',');
                                    int C2EX2_Length = 0;

                                    foreach (string SEX2_ExamNameID in C2EX2_ExamNameID)
                                    {
                                        Max_Mark = 0;

                                        if (SEX2_ExamNameID != "")
                                        {


                                            DataRow[] drScroedMarkTOT = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX2_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drScroedMarkTOT.Length > 0)
                                            {
                                                if (drScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SubjectMark = Convert.ToDecimal(drScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    Max_Mark = Convert.ToDecimal(drScroedMarkTOT[0]["MaxMark"].ToString());
                                                    C2EX2_Length += 1;
                                                }
                                                else
                                                {
                                                    SubjectMark = 0;
                                                }
                                            }

                                            else
                                            {
                                                SubjectMark = 0;
                                            }


                                            if (SubjectMark != 0)
                                            {
                                                SubNew_Mark = ((Convert.ToDecimal(SubjectMark / Max_Mark)) * Convert.ToDecimal(C2EX2_MarkPercn));
                                            }
                                            else
                                            {
                                                SubNew_Mark = 0;
                                            }

                                            Sub_Total += SubNew_Mark;
                                        }
                                    }

                                    if (Sub_Total != 0)
                                    {
                                        Calc_Mark += Convert.ToDecimal(C2EX2_MarkPercn);
                                    }
                                    if (C2EX2_Length != 0)
                                    {
                                        disp_mark = Sub_Total / C2EX2_Length;
                                    }

                                    Ex_Total += Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero));
                                    stroption += "<td>" + Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero)) + "</td>";
                                    //ExamIDList2 MidTerm Marks Calculation -End


                                    //ExamIDList3 MidTerm Marks Calculation -Start
                                    Sub_Total = 0;
                                    SubjectMark = 0;
                                    SubNew_Mark = 0;
                                    disp_mark = 0;


                                    string[] C2EX3_ExamNameID = C2EX3_ExamNameIDs.Split(',');
                                    int C2EX3_Length = 0;

                                    foreach (string SEX3_ExamNameID in C2EX3_ExamNameID)
                                    {
                                        Max_Mark = 0;

                                        if (SEX3_ExamNameID != "")
                                        {


                                            DataRow[] drScroedMarkTOT = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX3_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drScroedMarkTOT.Length > 0)
                                            {
                                                if (drScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SubjectMark = Convert.ToDecimal(drScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    Max_Mark = Convert.ToDecimal(drScroedMarkTOT[0]["MaxMark"].ToString());
                                                    C2EX3_Length += 1;
                                                }
                                                else
                                                {
                                                    SubjectMark = 0;
                                                }
                                            }

                                            else
                                            {
                                                SubjectMark = 0;
                                            }

                                            if (SubjectMark != 0)
                                            {
                                                SubNew_Mark = ((Convert.ToDecimal(SubjectMark / Max_Mark)) * Convert.ToDecimal(C2EX3_MarkPercn));
                                            }
                                            else
                                            {
                                                SubNew_Mark = 0;
                                            }
                                            Sub_Total += SubNew_Mark;
                                        }
                                    }

                                    if (Sub_Total != 0)
                                    {
                                        Calc_Mark += Convert.ToDecimal(C2EX3_MarkPercn);
                                    }
                                    if (C2EX3_Length != 0)
                                    {
                                        disp_mark = Sub_Total / C2EX3_Length;
                                    }

                                    Ex_Total += Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero));
                                    stroption += "<td>" + Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero)) + "</td>";
                                    //ExamIDList3 MidTerm Marks Calculation -End


                                    //ExamIDList4 MidTerm Marks Calculation -Start
                                    Sub_Total = 0;
                                    SubjectMark = 0;
                                    SubNew_Mark = 0;
                                    disp_mark = 0;

                                    string[] C2EX4_ExamNameID = C2EX4_ExamNameIDs.Split(',');
                                    int C2EX4_Length = 0;

                                    foreach (string SEX4_ExamNameID in C2EX4_ExamNameID)
                                    {
                                        Max_Mark = 0;
                                        if (SEX4_ExamNameID != "")
                                        {


                                            DataRow[] drScroedMarkTOT = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX4_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drScroedMarkTOT.Length > 0)
                                            {
                                                if (drScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SubjectMark = Convert.ToDecimal(drScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    Max_Mark = Convert.ToDecimal(drScroedMarkTOT[0]["MaxMark"].ToString());
                                                    C2EX4_Length += 1;
                                                }
                                                else
                                                {
                                                    SubjectMark = 0;
                                                }
                                            }

                                            else
                                            {
                                                SubjectMark = 0;
                                            }


                                            if (SubjectMark != 0)
                                            {
                                                SubNew_Mark = ((Convert.ToDecimal(SubjectMark / Max_Mark)) * Convert.ToDecimal(C2EX4_MarkPercn));
                                            }
                                            else
                                            {
                                                SubNew_Mark = 0;
                                            }

                                            Sub_Total += SubNew_Mark;
                                        }
                                    }

                                    if (Sub_Total != 0)
                                    {
                                        Calc_Mark += Convert.ToDecimal(C2EX4_MarkPercn);
                                    }
                                    if (C2EX4_Length != 0)
                                    {
                                        disp_mark = Sub_Total / C2EX4_Length;
                                    }

                                    Ex_Total += Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero));
                                    stroption += "<td>" + Convert.ToInt32(Math.Round(disp_mark, 0, MidpointRounding.AwayFromZero)) + "</td>";
                                    //ExamIDList4 MidTerm Marks Calculation -End
                                    if (Ex_Total!=0)
                                    {
                                        Ex_OverallTotal = (Ex_Total / Calc_Mark) * 100;
                                    }
                                    
                                    Ex_OverallTotal = Convert.ToInt32(Math.Round(Ex_OverallTotal, 0, MidpointRounding.AwayFromZero));
                                    overall += Ex_OverallTotal;


                                    stroption += "<td>" + Ex_OverallTotal.ToString() + "</td>";

                                    Tempstroption += "<td>" + Ex_OverallTotal.ToString() + "</td>"; //Total Marks for Each Subject -START



                                    //Mark Check For Case1 -START

                                    DataRow[] drChkCase1 = dsGet.Tables[0].Select("RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + C1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                    if (drChkCase1.Length > 0)
                                    {
                                        if (drChkCase1[0]["ScoredMarkTotal"].ToString() != "")
                                        {
                                            SubjectMark = Convert.ToDecimal(drChkCase1[0]["ScoredMarkTotal"].ToString());
                                            Max_Mark = Convert.ToDecimal(drChkCase1[0]["MaxMark"].ToString());

                                            SubjectMark = (SubjectMark / Max_Mark) * 100;
                                        }
                                        else
                                        {
                                            SubjectMark = 0;
                                        }
                                    }

                                    else
                                    {
                                        SubjectMark = 0;
                                    }

                                    SubjectMark = Convert.ToInt32(Math.Round(SubjectMark, 0, MidpointRounding.AwayFromZero));

                                    //Mark Details Update to DB - START

                                    //values Insert to P_PromotionList Table [START]
                                    proInsertQuery = "sp_PromotionList_Insert '" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "','" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "','" + dsGet.Tables[0].Rows[i]["ClassID"].ToString() + "','" + dsGet.Tables[0].Rows[i]["SectionID"].ToString() + "','" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "','" + SubjectMark.ToString() + "','" + AcademicID + "','" + Userid + "'";
                                    utl.ExecuteQuery(proInsertQuery);
                                    //values Insert to P_PromotionList Table [END]                                                                      

                                    if (SubjectMark >= Convert.ToDecimal(C1_Passmark))
                                    {
                                        chkstatus = "P1";

                                        proUpdateQuery = "update p_promotionList set FinalMark='" + SubjectMark.ToString() + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' and SubjectId='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "' ";
                                        utl.ExecuteQuery(proUpdateQuery);

                                    }
                                    else if (Ex_OverallTotal >= Convert.ToDecimal(C2_Passmark))
                                    {
                                        chkstatus = "P2";

                                        proUpdateQuery = "update p_promotionList set P2 ='" + Ex_OverallTotal.ToString() + "',FinalMark='" + Ex_OverallTotal.ToString() + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' and SubjectId='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "' ";
                                        utl.ExecuteQuery(proUpdateQuery);

                                    }
                                    else
                                    {
                                        int markDiff = Convert.ToInt32(C2_Passmark) - Convert.ToInt32(Ex_OverallTotal);
                                        int actualmark;

                                        if (Adjmark >= markDiff)
                                        {
                                            chkstatus = "P2Mod";
                                            actualmark = Convert.ToInt32(Ex_OverallTotal) + markDiff;

                                            proUpdateQuery = "update p_promotionList set P2 ='" + Ex_OverallTotal.ToString() + "',P2Mod='" + actualmark.ToString() + "',FinalMark='" + actualmark.ToString() + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' and SubjectId='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "' ";
                                            utl.ExecuteQuery(proUpdateQuery);

                                        }
                                        else
                                        {
                                            chkstatus = "Fail";

                                            proUpdateQuery = "update p_promotionList set P2 ='" + Ex_OverallTotal.ToString() + "',P2Mod='" + Ex_OverallTotal.ToString() + "',FinalMark='" + Ex_OverallTotal.ToString() + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' and SubjectId='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "' ";
                                            utl.ExecuteQuery(proUpdateQuery);
                                        }
                                    }
                                    //Mark Details Update to DB - End




                                    //Check Individual TotalMarks for Promotion -Start



                                    if (SubjectMark >= Convert.ToDecimal(C1_Passmark))
                                    {
                                        proStatus = "P1";
                                        p1cnt = p1cnt + 1;
                                    }
                                    else if (Ex_OverallTotal >= Convert.ToDecimal(C2_Passmark))
                                    {
                                        proStatus = "P2";
                                        p2cnt = p2cnt + 1;
                                    }
                                    else
                                    {
                                        int markDiff = (Convert.ToInt32(C2_Passmark) - Convert.ToInt32(Ex_OverallTotal));
                                        int actualmark;

                                        if (Adjmark >= markDiff)
                                        {
                                            proStatus = "P2Mod";
                                            actualmark = Convert.ToInt32(Ex_OverallTotal) + markDiff;
                                            Adjmark = Adjmark - markDiff;
                                            p2modcnt = p2modcnt + 1;
                                        }
                                        else
                                        {
                                            proStatus = "Fail";
                                            Failcnt = Failcnt + 1;
                                        }
                                    }


                                    //Check Individual TotalMarks for Promotion -End                                   
                                    //Mark Check For Case1 -END

                                }

                                stroption += Tempstroption;
                                if (overall!=0)
                                {
                                    MarksPercetage = overall / ds.Tables[0].Rows.Count;
                                }
                              
                                stroption += "<td>" + overall.ToString() + "</td><td>" + Math.Round(MarksPercetage, 2) + "</td>";

                                string StudRegno = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                                string studAtt = Attenance(StudRegno);
                                double StudPresentdays = Convert.ToDouble(studAtt);
                                double Attpercentage = (StudPresentdays / totdays) * 100;


                                if (Failcnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>DETAINED</td><td>&nbsp;</td></tr>";

                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                    proUpdateQuery = "update p_promotionList set OverAllTotal='" + overall.ToString() + "', TotalPercn='" + Math.Round(MarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Status='Fail',Remarks='DETAINED' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                    utl.ExecuteQuery(proUpdateQuery);
                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]

                                }
                                else if (p2modcnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P2Mod</td></tr>";

                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                    proUpdateQuery = "update p_promotionList set OverAllTotal='" + overall.ToString() + "', TotalPercn='" + Math.Round(MarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Status='P2Mod',Remarks='PROMOTED' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                    utl.ExecuteQuery(proUpdateQuery);
                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]
                                }

                                else if (p2cnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P2</td></tr>";

                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                    proUpdateQuery = "update p_promotionList set OverAllTotal='" + overall.ToString() + "', TotalPercn='" + Math.Round(MarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Status='P2',Remarks='PROMOTED' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                    utl.ExecuteQuery(proUpdateQuery);
                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]
                                }

                                else
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P1</td></tr>";

                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                    proUpdateQuery = "update p_promotionList set OverAllTotal='" + overall.ToString() + "', TotalPercn='" + Math.Round(MarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Status='P1',Remarks='PROMOTED' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                    utl.ExecuteQuery(proUpdateQuery);
                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]
                                }


                            }
                            examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                        }

                    }

                    stroption += @"</table><br/><br/>";
                    dvContent.Append(stroption);

                    //Cumulative List -Start

                    string sqlquery = string.Empty;
                    DataSet dscnt = new DataSet();


                    sqlquery = "getPromotionCount " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
                    dscnt = utl.GetDataset(sqlquery);
                    if (dscnt.Tables.Count > 0)
                    {
                        dvContent.Append(@"<table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'> <thead><tr><th colspan='2'>&nbsp;</th><th colspan='3'><b>GENERAL</b></th><th colspan='3'><b>SC</b></th></tr></thead><tbody><tr><td colspan='2'>&nbsp;</td><td>Boys</td><td>Girls</td><td>Total</td><td>Boys</td><td>Girls</td><td>Total</td></tr><tr><td colspan='2'>Total No of Students</td><td>" + dscnt.Tables[0].Rows[0]["TotalBoys"].ToString() + "</td><td>" + dscnt.Tables[1].Rows[0]["TotalGirls"].ToString() + "</td><td>" + dscnt.Tables[2].Rows[0]["TotalStudents"].ToString() + "</td><td>" + dscnt.Tables[3].Rows[0]["TotalSCBoys"].ToString() + "</td><td>" + dscnt.Tables[4].Rows[0]["TotalSCGirls"].ToString() + "</td><td>" + dscnt.Tables[5].Rows[0]["TotalSCStudents"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Appeared</td><td>" + dscnt.Tables[6].Rows[0]["TotalBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[7].Rows[0]["TotalGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[8].Rows[0]["TotalStudentsAppeared"].ToString() + "</td><td>" + dscnt.Tables[9].Rows[0]["TotalSCBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[10].Rows[0]["TotalSCGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[11].Rows[0]["TotalSCStudentsAppeared"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Promoted</td><td>" + dscnt.Tables[12].Rows[0]["TotalBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[13].Rows[0]["TotalGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[14].Rows[0]["TotalStudentsPromoted"].ToString() + "</td><td>" + dscnt.Tables[15].Rows[0]["TotalSCBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[16].Rows[0]["TotalSCGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[17].Rows[0]["TotalSCStudentsPromoted"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Detained</td><td>" + dscnt.Tables[18].Rows[0]["TotalBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[19].Rows[0]["TotalGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[20].Rows[0]["TotalStudentsDetained"].ToString() + "</td><td>" + dscnt.Tables[21].Rows[0]["TotalSCBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[22].Rows[0]["TotalSCGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[23].Rows[0]["TotalSCStudentsDetained"].ToString() + "</td></tr></tbody></table>");
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
                    dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td colspan='6'>No Data</td></tr></table>");
                }

                dvC1_Content.InnerHtml = dvContent.ToString();
            }

            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('Promotion Setup Not Created');</script>", false);
            }

        }
        catch (Exception)
        {
            throw;
        }
    }

    //C1 General Marks function -  End


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

                DataSet dsGet = new DataSet(); //ALL_ExamNameIDs  SubjectListID C1_ExamNameID

                sqlstr = "sp_Promo_getCCEpromotion " + Session["strClassID"] + "," + Session["strSectionID"] + "," + "'" + ALL_ExamNameIDs + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + SubjectListID + "'" + "," + AcademicID;

                dsGet = utl.GetDataset(sqlstr);
                StringBuilder dvContent = new StringBuilder();

                dvContent.Append(Disp_SchoolName());//SchoolName Bind 

                int EXNamecount = 0;
                string[] ExamTypeName;


                if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                {
                    dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tbody>");

                    stroption += @"<tr><td rowspan='3'><b>Sl No</b></td><td rowspan='3'><b>Adm No</b></td><td rowspan='3'><b>Reg No</b></td><td rowspan='3'><b>Exam No</b></td><td rowspan='3'><b>Name of the student</b></td><td rowspan='3'><b>Sex</b></td><td rowspan='3'><b>Category</b></td><td rowspan='3'><b>Date of birth</b></td>";


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
                    int thlenght = (EXNamecount * 3) + 1;
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
                            stroption += @"<td colspan='" + thlenght + "' align='center'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></td>";
                        }
                    }

                    //Subject List Load END


                    //Aggregate TD START
                    int Aggcnt = ((ds.Tables[0].Rows.Count) * (EXNamecount + 1));
                    stroption += @"<td colspan='" + Aggcnt + "' align='center'><b>Aggregate</b></td><td rowspan='3'><b>Over All Total</b></td><td rowspan='3'><b>% of Total</b></td><td rowspan='3'><b>Total No. of Days Present</b></td><td rowspan='3'><b>% of Attendance</b></td><td rowspan='3'><b>Status</b></td><td rowspan='3'><b>Remark</b></td>";
                    //Aggregate TD END


                    //TERM LIST ROW -1 START 
                    stroption += @"<tr>";

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
                                    stroption += @"<td colspan='3' align='center'>" + ExTypeName + "</td>";
                                }
                            }

                            stroption += @"<td rowspan='2'>Marks % Avg</td>";
                        }
                    }


                    //Aggregate Subject List START

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td colspan='" + (EXNamecount + 1) + "' align='center'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></td>";
                        }
                    }

                    //Aggregate Subject List  End

                    stroption += @"</tr>";

                    //TERM LIST ROW -1 END


                    //TERM LIST ROW -2 START 

                    stroption += @"<tr>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            foreach (string EXTypeID in ExamTypeName)
                            {
                                if (EXTypeID != "")
                                {
                                    stroption += @"<td>FA(40)</td><td>SA(60)</td><td>Tot(100)</td>	";
                                }
                            }
                        }
                    }


                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td>" + C2EX2_ExamNames + "(" + C2EX2_MarkPercn + ")" + "</td><td>" + C2EX3_ExamNames + "(" + C2EX3_MarkPercn + ")" + "</td><td>" + C2EX4_ExamNames + "(" + C2EX4_MarkPercn + ")" + "</td><td>Tot(100)</td>";

                        }
                    }

                    stroption += @"</tr>";
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
                            int p1cnt = 0;
                            int p2cnt = 0;
                            int p2modcnt = 0;
                            int Failcnt = 0;
                            proStatus = "";

                            p = p + 1;

                            stroption += @"<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Sex"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["CommunityName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td>";

                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                //All Term Marks display [except P1,p2,p2 calc] - START
                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    double FAtot = 0;
                                    double FBtot = 0;
                                    double FABTotal = 0;
                                    double SAtot = 0;
                                    double Total = 0;
                                    double MarksPercetage = 0;
                                    double overall = 0;

                                    foreach (string EXTypeID in ExamTypeName)
                                    {
                                        if (EXTypeID != "")
                                        {
                                            SACnt = 0;
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
                                            stroption += @"<td>" + FABTotal.ToString() + "</td>";

                                            DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drSAScroedMarkTOT.Length > 0)
                                            {
                                                if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SACnt = 1;
                                                    SAtot = Convert.ToDouble(drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    SAtot = Convert.ToInt32(Math.Round(SAtot, 0, MidpointRounding.AwayFromZero));
                                                    stroption += @"<td>" + SAtot.ToString() + "</td>";

                                                }
                                                else
                                                {
                                                    stroption += @"<td>A</td>";
                                                    SAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                stroption += @"<td>A</td>";
                                                SAtot = 0;
                                            }

                                            if (SACnt == 0)
                                            {
                                                Total = (FABTotal / 40) * 100;
                                            }
                                            else
                                            {
                                                Total = FABTotal + SAtot;
                                            }
                                            Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));
                                            overall = overall + Total;

                                            stroption += @"<td>" + Total.ToString() + "</td>";
                                        }
                                    }

                                    MarksPercetage = overall / EXNamecount;
                                    stroption += @"<td>" + Math.Round(MarksPercetage, 1) + "</td>";
                                }
                                //All Term Marks display [except P1,p2,p2 calc] - END



                                //Mark Cal Culation for [Include P1,P2,P2Mod] - START
                                decimal Ex_OverallTotal = 0;

                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    double FAtot = 0;
                                    double FBtot = 0;
                                    double FABTotal = 0;
                                    double SAtot = 0;
                                    double Total = 0;

                                    decimal Ex_Total = 0;

                                    //ExamIDList2 MidTerm Marks Calculation -Start

                                    decimal Sub_Total = 0;
                                    decimal SubNew_Mark = 0;
                                    SACnt = 0;
                                    string[] C2EX2_ExamNameID = C2EX2_ExamNameIDs.Split(',');
                                    int C2EX2_Length = C2EX2_ExamNameID.Length;
                                    foreach (string SEX2_ExamNameID in C2EX2_ExamNameID)
                                    {
                                        DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX2_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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

                                        DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX2_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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
                                        DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX2_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                        if (drSAScroedMarkTOT.Length > 0)
                                        {
                                            if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                            {
                                                SACnt = 1;
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
                                        if (SACnt == 0)
                                        {
                                            Total = (FABTotal / 40) * 100;
                                        }
                                        else
                                        {
                                            Total = FABTotal + SAtot;
                                        }

                                        Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));

                                        if (Total != 0)
                                        {
                                            SubNew_Mark = ((Convert.ToDecimal(Total / 100)) * Convert.ToDecimal(C2EX2_MarkPercn));
                                        }

                                        else
                                        {
                                            SubNew_Mark = 0;
                                        }

                                        Sub_Total += SubNew_Mark;
                                    }
                                    Ex_Total += Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero));

                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";

                                    //ExamIDList2 MidTerm Marks Calculation -END

                                    //ExamIDList3 MidTerm Marks Calculation -START
                                    Sub_Total = 0;
                                    SubNew_Mark = 0;

                                    string[] C2EX3_ExamNameID = C2EX3_ExamNameIDs.Split(',');
                                    int C2EX3_Length = C2EX3_ExamNameID.Length;
                                    SACnt = 0;
                                    foreach (string SEX3_ExamNameID in C2EX3_ExamNameID)
                                    {
                                        DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX3_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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

                                        DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX3_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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
                                        DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX3_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                        if (drSAScroedMarkTOT.Length > 0)
                                        {
                                            if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                            {
                                                SACnt = 1;
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
                                        if (SACnt == 0)
                                        {
                                            Total = (FABTotal / 40) * 100;
                                        }
                                        else
                                        {
                                            Total = FABTotal + SAtot;
                                        }
                                        Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));



                                        if (Total != 0)
                                        {
                                            SubNew_Mark = ((Convert.ToDecimal(Total / 100)) * Convert.ToDecimal(C2EX3_MarkPercn));
                                        }

                                        else
                                        {
                                            SubNew_Mark = 0;
                                        }

                                        Sub_Total += SubNew_Mark;
                                    }
                                    Ex_Total += Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero));

                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";

                                    //ExamIDList3 MidTerm Marks Calculation -END


                                    //ExamIDList4 MidTerm Marks Calculation -START
                                    Sub_Total = 0;
                                    SubNew_Mark = 0;

                                    string[] C2EX4_ExamNameID = C2EX4_ExamNameIDs.Split(',');
                                    int C2EX4_Length = C2EX4_ExamNameID.Length;
                                    SACnt = 0;
                                    foreach (string SEX4_ExamNameID in C2EX4_ExamNameID)
                                    {
                                        DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX4_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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

                                        DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX4_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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
                                        DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX4_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                        if (drSAScroedMarkTOT.Length > 0)
                                        {
                                            if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                            {
                                                SACnt = 1;
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
                                        if (SACnt == 0)
                                        {
                                            Total = (FABTotal / 40) * 100;
                                        }
                                        else
                                        {
                                            Total = FABTotal + SAtot;
                                        }
                                        Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));

                                        if (Total != 0)
                                        {
                                            SubNew_Mark = ((Convert.ToDecimal(Total / 100)) * Convert.ToDecimal(C2EX4_MarkPercn));
                                        }

                                        else
                                        {
                                            SubNew_Mark = 0;
                                        }

                                        Sub_Total += SubNew_Mark;
                                    }
                                    Ex_Total += Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero));


                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";

                                    //ExamIDList4 MidTerm Marks Calculation -END

                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(Ex_Total, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";
                                    Ex_Total = Convert.ToInt32(Math.Round(Ex_Total, 0, MidpointRounding.AwayFromZero));
                                    Ex_OverallTotal += Ex_Total;



                                    //Mark Check For Case1 -START
                                    SACnt = 0;
                                    DataRow[] drChkFACase1 = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + C1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                    if (drChkFACase1.Length > 0)
                                    {
                                        if (drChkFACase1[0]["ScoredMarkTotal"].ToString() != "")
                                        {
                                            FAtot = Convert.ToDouble(drChkFACase1[0]["ScoredMarkTotal"].ToString());
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


                                    DataRow[] drChkFBCase1 = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + C1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                    if (drChkFBCase1.Length > 0)
                                    {
                                        if (drChkFBCase1[0]["ScoredMarkTotal"].ToString() != "")
                                        {
                                            FBtot = Convert.ToDouble(drChkFBCase1[0]["ScoredMarkTotal"].ToString());
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
                                    DataRow[] drChkSACase1 = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + C1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                    if (drChkSACase1.Length > 0)
                                    {
                                        if (drChkSACase1[0]["Mark"].ToString() != "")
                                        {
                                            SACnt = 1;
                                            SAtot = Convert.ToDouble(drChkSACase1[0]["Mark"].ToString());
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
                                    if (SACnt == 0)
                                    {
                                        Total = (FABTotal / 40) * 100;
                                    }
                                    else
                                    {
                                        Total = FABTotal + SAtot;
                                    }
                                    Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));
                                    //Mark Details Update to DB - START

                                    //values Insert to P_PromotionList Table [START]
                                    proInsertQuery = "sp_PromotionList_Insert '" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "','" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "','" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "','" + dsGet.Tables[0].Rows[i]["ClassID"].ToString() + "','" + dsGet.Tables[0].Rows[i]["SectionID"].ToString() + "','" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "','" + Total.ToString() + "','" + AcademicID + "','" + Userid + "'";
                                    utl.ExecuteQuery(proInsertQuery);
                                    //values Insert to P_PromotionList Table [END]   


                                    if (Total >= Convert.ToDouble(C1_Passmark))
                                    {
                                        chkstatus = "P1";

                                        proUpdateQuery = "update p_promotionList set FinalMark='" + Total.ToString() + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' and SubjectId='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "' ";
                                        utl.ExecuteQuery(proUpdateQuery);
                                    }

                                    else if (Ex_Total >= Convert.ToDecimal(C2_Passmark))
                                    {
                                        chkstatus = "P2";
                                        proUpdateQuery = "update p_promotionList set P2 ='" + Ex_Total.ToString() + "',FinalMark='" + Ex_Total.ToString() + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' and SubjectId='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "' ";
                                        utl.ExecuteQuery(proUpdateQuery);
                                    }
                                    else
                                    {
                                        int markDiff = Convert.ToInt32(C2_Passmark) - Convert.ToInt32(Ex_Total);
                                        int actualmark;
                                        if (Adjmark >= markDiff)
                                        {
                                            chkstatus = "P2Mod";
                                            actualmark = Convert.ToInt32(Ex_Total) + markDiff;

                                            proUpdateQuery = "update p_promotionList set P2 ='" + Ex_Total.ToString() + "',P2Mod='" + actualmark.ToString() + "',FinalMark='" + actualmark.ToString() + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' and SubjectId='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "' ";
                                            utl.ExecuteQuery(proUpdateQuery);

                                        }
                                        else
                                        {
                                            chkstatus = "Fail";

                                            proUpdateQuery = "update p_promotionList set P2 ='" + Ex_Total.ToString() + "',P2Mod='" + Ex_Total.ToString() + "',FinalMark='" + Ex_Total.ToString() + "' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' and SubjectId='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "' ";
                                            utl.ExecuteQuery(proUpdateQuery);
                                        }
                                    }
                                    //Mark Check For Case1 -END


                                    //Check Individual TotalMarks for Promotion -Start

                                    if (Total >= Convert.ToDouble(C1_Passmark))
                                    {
                                        proStatus = "P1";
                                        p1cnt = p1cnt + 1;
                                    }

                                    else if (Ex_Total >= Convert.ToDecimal(C2_Passmark))
                                    {
                                        proStatus = "P2";
                                        p2cnt = p2cnt + 1;
                                    }

                                    else
                                    {
                                        int markDiff = (Convert.ToInt32(C2_Passmark) - Convert.ToInt32(Ex_Total));
                                        int actualmark;

                                        if (Adjmark >= markDiff)
                                        {
                                            proStatus = "P2Mod";
                                            actualmark = Convert.ToInt32(Ex_Total) + markDiff;
                                            Adjmark = Adjmark - markDiff;
                                            p2modcnt = p2modcnt + 1;
                                        }
                                        else
                                        {
                                            proStatus = "Fail";
                                            Failcnt = Failcnt + 1;
                                        }
                                    }

                                    //Check Individual TotalMarks for Promotion -END                                    

                                }

                                TotMarksPercetage = Ex_OverallTotal / ds.Tables[0].Rows.Count;
                                stroption += "<td>" + Convert.ToInt32(Math.Round(Ex_OverallTotal, 0, MidpointRounding.AwayFromZero)).ToString() + "</td><td>" + Math.Round(TotMarksPercetage, 1) + "</td>";
                                string StudRegno = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                                string studAtt = Attenance(StudRegno);
                                double StudPresentdays = Convert.ToDouble(studAtt);
                                double Attpercentage = (StudPresentdays / totdays) * 100;

                                if (Failcnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>DETAINED</td><td>&nbsp;</td></tr>";

                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                    proUpdateQuery = "update p_promotionList set OverAllTotal='" + Ex_OverallTotal.ToString() + "', TotalPercn='" + Math.Round(TotMarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Status='Fail',Remarks='DETAINED' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                    utl.ExecuteQuery(proUpdateQuery);
                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]

                                }
                                else if (p2modcnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P2Mod</td></tr>";

                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                    proUpdateQuery = "update p_promotionList set OverAllTotal='" + Ex_OverallTotal.ToString() + "', TotalPercn='" + Math.Round(TotMarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Status='P2Mod',Remarks='PROMOTED' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                    utl.ExecuteQuery(proUpdateQuery);
                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]
                                }
                                else if (p2cnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P2</td></tr>";

                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                    proUpdateQuery = "update p_promotionList set OverAllTotal='" + Ex_OverallTotal.ToString() + "', TotalPercn='" + Math.Round(TotMarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Status='P2',Remarks='PROMOTED' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                    utl.ExecuteQuery(proUpdateQuery);
                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]
                                }
                                else
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P1</td></tr>";

                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [START]     
                                    proUpdateQuery = "update p_promotionList set OverAllTotal='" + Ex_OverallTotal.ToString() + "', TotalPercn='" + Math.Round(TotMarksPercetage, 2) + "',Presentdays='" + StudPresentdays.ToString() + "' ,AttendancePercn='" + Math.Round(Attpercentage, 1) + "' ,Status='P1',Remarks='PROMOTED' where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and ClassID='" + Session["strClassID"] + "' and SectionID='" + Session["strSectionID"] + "' and AcademicID='" + AcademicID + "' ";
                                    utl.ExecuteQuery(proUpdateQuery);
                                    //values [overall total,%total,Attpresentdays,%attendance,status,remark] Insert to P_PromotionList Table [END]

                                }
                                //Mark Cal Culation for [Include P1,P2,P2Mod] - END
                            }

                            examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();

                        }
                    }
                    //Student Mark Details - END

                    stroption += @"</tbody></table><br/><br/>";
                    dvContent.Append(stroption);

                    //Cumulative List -Start

                    string sqlquery = string.Empty;
                    DataSet dscnt = new DataSet();


                    sqlquery = "getPromotionCount " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
                    dscnt = utl.GetDataset(sqlquery);
                    if (dscnt.Tables.Count > 0)
                    {
                        dvContent.Append(@"<table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'> <thead><tr><th colspan='2'>&nbsp;</th><th colspan='3'><b>GENERAL</b></th><th colspan='3'><b>SC</b></th></tr></thead><tbody><tr><td colspan='2'>&nbsp;</td><td>Boys</td><td>Girls</td><td>Total</td><td>Boys</td><td>Girls</td><td>Total</td></tr><tr><td colspan='2'>Total No of Students</td><td>" + dscnt.Tables[0].Rows[0]["TotalBoys"].ToString() + "</td><td>" + dscnt.Tables[1].Rows[0]["TotalGirls"].ToString() + "</td><td>" + dscnt.Tables[2].Rows[0]["TotalStudents"].ToString() + "</td><td>" + dscnt.Tables[3].Rows[0]["TotalSCBoys"].ToString() + "</td><td>" + dscnt.Tables[4].Rows[0]["TotalSCGirls"].ToString() + "</td><td>" + dscnt.Tables[5].Rows[0]["TotalSCStudents"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Appeared</td><td>" + dscnt.Tables[6].Rows[0]["TotalBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[7].Rows[0]["TotalGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[8].Rows[0]["TotalStudentsAppeared"].ToString() + "</td><td>" + dscnt.Tables[9].Rows[0]["TotalSCBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[10].Rows[0]["TotalSCGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[11].Rows[0]["TotalSCStudentsAppeared"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Promoted</td><td>" + dscnt.Tables[12].Rows[0]["TotalBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[13].Rows[0]["TotalGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[14].Rows[0]["TotalStudentsPromoted"].ToString() + "</td><td>" + dscnt.Tables[15].Rows[0]["TotalSCBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[16].Rows[0]["TotalSCGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[17].Rows[0]["TotalSCStudentsPromoted"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Detained</td><td>" + dscnt.Tables[18].Rows[0]["TotalBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[19].Rows[0]["TotalGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[20].Rows[0]["TotalStudentsDetained"].ToString() + "</td><td>" + dscnt.Tables[21].Rows[0]["TotalSCBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[22].Rows[0]["TotalSCGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[23].Rows[0]["TotalSCStudentsDetained"].ToString() + "</td></tr></tbody></table>");
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
                    dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td colspan='6'>No Data</td></tr></table>");
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

                DataSet dsGet = new DataSet(); //ALL_ExamNameIDs  SubjectListID C1_ExamNameID

                sqlstr = "sp_Promo_getCCEpromotion " + Session["strClassID"] + "," + Session["strSectionID"] + "," + "'" + ALL_ExamNameIDs + "'" + "," + "'" + ddlType.SelectedItem.Text + "'" + "," + "'" + SubjectListID + "'" + "," + AcademicID;

                dsGet = utl.GetDataset(sqlstr);
                StringBuilder dvContent = new StringBuilder();

                dvContent.Append(Disp_SchoolName());//SchoolName Bind 

                int EXNamecount = 0;
                string[] ExamTypeName;


                if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                {
                    dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tbody>");

                    stroption += @"<tr><td rowspan='3'><b>Sl No</b></td><td rowspan='3'><b>Adm No</b></td><td rowspan='3'><b>Reg No</b></td><td rowspan='3'><b>Exam No</b></td><td rowspan='3'><b>Name of the student</b></td><td rowspan='3'><b>Sex</b></td><td rowspan='3'><b>Category</b></td><td rowspan='3'><b>Date of birth</b></td>";


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
                    int thlenght = (EXNamecount * 3) + 1;
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
                            stroption += @"<td colspan='" + thlenght + "' align='center'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></td>";
                        }
                    }

                    //Subject List Load END


                    //Aggregate TD START
                    int Aggcnt = ((ds.Tables[0].Rows.Count) * (EXNamecount + 1));
                    stroption += @"<td colspan='" + Aggcnt + "' align='center'><b>Aggregate</b></td><td rowspan='3'><b>Over All Total</b></td><td rowspan='3'><b>% of Total</b></td><td rowspan='3'><b>Total No. of Days Present</b></td><td rowspan='3'><b>% of Attendance</b></td><td rowspan='3'><b>Status</b></td><td rowspan='3'><b>Remark</b></td>";
                    //Aggregate TD END


                    //TERM LIST ROW -1 START 
                    stroption += @"<tr>";

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
                                    stroption += @"<td colspan='3' align='center'>" + ExTypeName + "</td>";
                                }
                            }

                            stroption += @"<td rowspan='2'>Marks % Avg</td>";
                        }
                    }


                    //Aggregate Subject List START

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td colspan='" + (EXNamecount + 1) + "' align='center'><b>" + ds.Tables[0].Rows[j]["SubjectName"].ToString() + "</b></td>";
                        }
                    }

                    //Aggregate Subject List  End

                    stroption += @"</tr>";

                    //TERM LIST ROW -1 END


                    //TERM LIST ROW -2 START 

                    stroption += @"<tr>";

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            foreach (string EXTypeID in ExamTypeName)
                            {
                                if (EXTypeID != "")
                                {
                                    stroption += @"<td>FA(40)</td><td>SA(60)</td><td>Tot(100)</td>	";
                                }
                            }
                        }
                    }


                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<td>" + C2EX2_ExamNames + "(" + C2EX2_MarkPercn + ")" + "</td><td>" + C2EX3_ExamNames + "(" + C2EX3_MarkPercn + ")" + "</td><td>" + C2EX4_ExamNames + "(" + C2EX4_MarkPercn + ")" + "</td><td>Tot(100)</td>";

                        }
                    }

                    stroption += @"</tr>";
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
                            int p1cnt = 0;
                            int p2cnt = 0;
                            int p2modcnt = 0;
                            int Failcnt = 0;
                            proStatus = "";

                            p = p + 1;

                            stroption += @"<tr><td>" + p.ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["AdmissionNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["ExamNo"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["StudentName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["Sex"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["CommunityName"].ToString() + "</td><td>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td>";

                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                //All Term Marks display [except P1,p2,p2 calc] - START
                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    double FAtot = 0;
                                    double FBtot = 0;
                                    double FABTotal = 0;
                                    double SAtot = 0;
                                    double Total = 0;
                                    double MarksPercetage = 0;
                                    double overall = 0;

                                    foreach (string EXTypeID in ExamTypeName)
                                    {
                                        if (EXTypeID != "")
                                        {
                                            SACnt = 0;
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
                                            stroption += @"<td>" + FABTotal.ToString() + "</td>";

                                            DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + EXTypeID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                            if (drSAScroedMarkTOT.Length > 0)
                                            {
                                                if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                                {
                                                    SACnt = 1;
                                                    SAtot = Convert.ToDouble(drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString());
                                                    SAtot = Convert.ToInt32(Math.Round(SAtot, 0, MidpointRounding.AwayFromZero));
                                                    stroption += @"<td>" + SAtot.ToString() + "</td>";
                                                }
                                                else
                                                {
                                                    stroption += @"<td>A</td>";
                                                    SAtot = 0;
                                                }
                                            }

                                            else
                                            {
                                                stroption += @"<td>A</td>";
                                                SAtot = 0;
                                            }


                                            if (SACnt == 0)
                                            {
                                                Total = (FABTotal / 40) * 100;
                                            }
                                            else
                                            {
                                                Total = FABTotal + SAtot;
                                            }
                                            Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));

                                            overall = overall + Total;

                                            stroption += @"<td>" + Total.ToString() + "</td>";
                                        }
                                    }

                                    MarksPercetage = overall / EXNamecount;
                                    stroption += @"<td>" + Math.Round(MarksPercetage, 1) + "</td>";
                                }
                                //All Term Marks display [except P1,p2,p2 calc] - END



                                //Mark Cal Culation for [Include P1,P2,P2Mod] - START
                                decimal Ex_OverallTotal = 0;

                                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                {
                                    double FAtot = 0;
                                    double FBtot = 0;
                                    double FABTotal = 0;
                                    double SAtot = 0;
                                    double Total = 0;

                                    decimal Ex_Total = 0;

                                    //ExamIDList2 MidTerm Marks Calculation -Start

                                    decimal Sub_Total = 0;
                                    decimal SubNew_Mark = 0;
                                    SACnt = 0;
                                    string[] C2EX2_ExamNameID = C2EX2_ExamNameIDs.Split(',');
                                    int C2EX2_Length = C2EX2_ExamNameID.Length;
                                    foreach (string SEX2_ExamNameID in C2EX2_ExamNameID)
                                    {
                                        DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX2_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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

                                        DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX2_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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
                                        DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX2_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                        if (drSAScroedMarkTOT.Length > 0)
                                        {
                                            if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                            {
                                                SACnt = 1;
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
                                        if (SACnt == 0)
                                        {
                                            Total = (FABTotal / 40) * 100;
                                        }
                                        else
                                        {
                                            Total = FABTotal + SAtot;
                                        }
                                        Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));

                                        if (Total != 0)
                                        {
                                            SubNew_Mark = ((Convert.ToDecimal(Total / 100)) * Convert.ToDecimal(C2EX2_MarkPercn));
                                        }

                                        else
                                        {
                                            SubNew_Mark = 0;
                                        }

                                        Sub_Total += SubNew_Mark;
                                    }
                                    Ex_Total += Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero));

                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";

                                    //ExamIDList2 MidTerm Marks Calculation -END

                                    //ExamIDList3 MidTerm Marks Calculation -START
                                    Sub_Total = 0;
                                    SubNew_Mark = 0;

                                    string[] C2EX3_ExamNameID = C2EX3_ExamNameIDs.Split(',');
                                    int C2EX3_Length = C2EX3_ExamNameID.Length;
                                    SACnt = 0;
                                    foreach (string SEX3_ExamNameID in C2EX3_ExamNameID)
                                    {
                                        DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX3_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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

                                        DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX3_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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
                                        DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX3_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                        if (drSAScroedMarkTOT.Length > 0)
                                        {
                                            if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                            {
                                                SACnt = 1;
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
                                        if (SACnt == 0)
                                        {
                                            Total = (FABTotal / 40) * 100;
                                        }
                                        else
                                        {
                                            Total = FABTotal + SAtot;
                                        }
                                        Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));

                                        if (Total != 0)
                                        {
                                            SubNew_Mark = ((Convert.ToDecimal(Total / 100)) * Convert.ToDecimal(C2EX3_MarkPercn));
                                        }

                                        else
                                        {
                                            SubNew_Mark = 0;
                                        }

                                        Sub_Total += SubNew_Mark;
                                    }
                                    Ex_Total += Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero));

                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";

                                    //ExamIDList3 MidTerm Marks Calculation -END


                                    //ExamIDList4 MidTerm Marks Calculation -START
                                    Sub_Total = 0;
                                    SubNew_Mark = 0;
                                    SACnt = 0;
                                    string[] C2EX4_ExamNameID = C2EX4_ExamNameIDs.Split(',');
                                    int C2EX4_Length = C2EX4_ExamNameID.Length;

                                    foreach (string SEX4_ExamNameID in C2EX4_ExamNameID)
                                    {
                                        DataRow[] drFAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX4_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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

                                        DataRow[] drFBScroedMarkTOT = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX4_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

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
                                        DataRow[] drSAScroedMarkTOT = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + SEX4_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                        if (drSAScroedMarkTOT.Length > 0)
                                        {
                                            if (drSAScroedMarkTOT[0]["ScoredMarkTotal"].ToString() != "")
                                            {
                                                SACnt = 1;
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
                                        if (SACnt == 0)
                                        {
                                            Total = (FABTotal / 40) * 100;
                                        }
                                        else
                                        {
                                            Total = FABTotal + SAtot;
                                        }
                                        Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));

                                        if (Total != 0)
                                        {
                                            SubNew_Mark = ((Convert.ToDecimal(Total / 100)) * Convert.ToDecimal(C2EX4_MarkPercn));
                                        }

                                        else
                                        {
                                            SubNew_Mark = 0;
                                        }

                                        Sub_Total += SubNew_Mark;
                                    }
                                    Ex_Total += Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero));


                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(Sub_Total, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";

                                    //ExamIDList4 MidTerm Marks Calculation -END

                                    stroption += @"<td>" + Convert.ToInt32(Math.Round(Ex_Total, 0, MidpointRounding.AwayFromZero)).ToString() + "</td>";
                                    Ex_Total = Convert.ToInt32(Math.Round(Ex_Total, 0, MidpointRounding.AwayFromZero));
                                    Ex_OverallTotal += Ex_Total;



                                    //Mark Check For Case1 -START
                                    SACnt = 0;
                                    DataRow[] drChkFACase1 = dsGet.Tables[0].Select("Pattern='FA(a)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + C1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                    if (drChkFACase1.Length > 0)
                                    {
                                        if (drChkFACase1[0]["ScoredMarkTotal"].ToString() != "")
                                        {
                                            FAtot = Convert.ToDouble(drChkFACase1[0]["ScoredMarkTotal"].ToString());
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


                                    DataRow[] drChkFBCase1 = dsGet.Tables[0].Select("Pattern='FA(b)' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + C1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                    if (drChkFBCase1.Length > 0)
                                    {
                                        if (drChkFBCase1[0]["ScoredMarkTotal"].ToString() != "")
                                        {
                                            FBtot = Convert.ToDouble(drChkFBCase1[0]["ScoredMarkTotal"].ToString());
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
                                    DataRow[] drChkSACase1 = dsGet.Tables[0].Select("Pattern='SA' and RegNo=" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + " and ExamNameID ='" + C1_ExamNameID + "' and SubExperienceid='" + ds.Tables[0].Rows[j]["SubjectId"].ToString() + "'");

                                    if (drChkSACase1.Length > 0)
                                    {
                                        if (drChkSACase1[0]["Mark"].ToString() != "")
                                        {
                                            SACnt = 1;
                                            SAtot = Convert.ToDouble(drChkSACase1[0]["Mark"].ToString());
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
                                    if (SACnt == 0)
                                    {
                                        Total = (FABTotal / 40) * 100;
                                    }
                                    else
                                    {
                                        Total = FABTotal + SAtot;
                                    }
                                    Total = Convert.ToInt32(Math.Round(Total, 0, MidpointRounding.AwayFromZero));
                                    //Mark Details Update to DB - START




                                    if (Total >= Convert.ToDouble(C1_Passmark))
                                    {
                                        chkstatus = "P1";
                                    }

                                    else if (Ex_Total >= Convert.ToDecimal(C2_Passmark))
                                    {
                                        chkstatus = "P2";
                                    }
                                    else
                                    {
                                        int markDiff = Convert.ToInt32(C2_Passmark) - Convert.ToInt32(Ex_Total);
                                        int actualmark;
                                        if (Adjmark >= markDiff)
                                        {
                                            chkstatus = "P2Mod";
                                            actualmark = Convert.ToInt32(Ex_Total) + markDiff;

                                        }
                                        else
                                        {
                                            chkstatus = "Fail";
                                        }
                                    }
                                    //Mark Check For Case1 -END


                                    //Check Individual TotalMarks for Promotion -Start

                                    if (Total >= Convert.ToDouble(C1_Passmark))
                                    {
                                        proStatus = "P1";
                                        p1cnt = p1cnt + 1;
                                    }

                                    else if (Ex_Total >= Convert.ToDecimal(C2_Passmark))
                                    {
                                        proStatus = "P2";
                                        p2cnt = p2cnt + 1;
                                    }

                                    else
                                    {
                                        int markDiff = (Convert.ToInt32(C2_Passmark) - Convert.ToInt32(Ex_Total));
                                        int actualmark;

                                        if (Adjmark >= markDiff)
                                        {
                                            proStatus = "P2Mod";
                                            actualmark = Convert.ToInt32(Ex_Total) + markDiff;
                                            Adjmark = Adjmark - markDiff;
                                            p2modcnt = p2modcnt + 1;
                                        }
                                        else
                                        {
                                            proStatus = "Fail";
                                            Failcnt = Failcnt + 1;
                                        }
                                    }

                                    //Check Individual TotalMarks for Promotion -END                                    

                                }

                                TotMarksPercetage = Ex_OverallTotal / ds.Tables[0].Rows.Count;
                                stroption += "<td>" + Convert.ToInt32(Math.Round(Ex_OverallTotal, 0, MidpointRounding.AwayFromZero)).ToString() + "</td><td>" + Math.Round(TotMarksPercetage, 2) + "</td>";
                                string StudRegno = dsGet.Tables[0].Rows[i]["RegNo"].ToString();
                                string studAtt = Attenance(StudRegno);
                                double StudPresentdays = Convert.ToDouble(studAtt);
                                double Attpercentage = (StudPresentdays / totdays) * 100;

                                if (Failcnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>DETAINED</td><td>&nbsp;</td></tr>";
                                }
                                else if (p2modcnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P2Mod</td></tr>";
                                }
                                else if (p2cnt != 0)
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P2</td></tr>";
                                }
                                else
                                {
                                    stroption += @"<td>" + StudPresentdays + "</td><td>" + Math.Round(Attpercentage, 1) + "</td><td>PROMOTED</td><td>P1</td></tr>";

                                }
                                //Mark Cal Culation for [Include P1,P2,P2Mod] - END
                            }

                            examnochk = dsGet.Tables[0].Rows[i]["RegNo"].ToString();

                        }
                    }
                    //Student Mark Details - END

                    stroption += @"</tbody></table><br/><br/>";
                    dvContent.Append(stroption);


                    //Cumulative List -Start

                    string sqlquery = string.Empty;
                    DataSet dscnt = new DataSet();

                    sqlquery = "getPromotionCount " + Session["strClassID"] + "," + Session["strSectionID"] + "," + AcademicID;
                    dscnt = utl.GetDataset(sqlquery);
                    if (dscnt.Tables.Count > 0)
                    {
                        dvContent.Append(@"<table class='performancedata' border='1' cellspacing='5' cellpadding='10' width='100%'> <thead><tr><th colspan='2'>&nbsp;</th><th colspan='3'><b>GENERAL</b></th><th colspan='3'><b>SC</b></th></tr></thead><tbody><tr><td colspan='2'>&nbsp;</td><td>Boys</td><td>Girls</td><td>Total</td><td>Boys</td><td>Girls</td><td>Total</td></tr><tr><td colspan='2'>Total No of Students</td><td>" + dscnt.Tables[0].Rows[0]["TotalBoys"].ToString() + "</td><td>" + dscnt.Tables[1].Rows[0]["TotalGirls"].ToString() + "</td><td>" + dscnt.Tables[2].Rows[0]["TotalStudents"].ToString() + "</td><td>" + dscnt.Tables[3].Rows[0]["TotalSCBoys"].ToString() + "</td><td>" + dscnt.Tables[4].Rows[0]["TotalSCGirls"].ToString() + "</td><td>" + dscnt.Tables[5].Rows[0]["TotalSCStudents"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Appeared</td><td>" + dscnt.Tables[6].Rows[0]["TotalBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[7].Rows[0]["TotalGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[8].Rows[0]["TotalStudentsAppeared"].ToString() + "</td><td>" + dscnt.Tables[9].Rows[0]["TotalSCBoysAppeared"].ToString() + "</td><td>" + dscnt.Tables[10].Rows[0]["TotalSCGirlsAppeared"].ToString() + "</td><td>" + dscnt.Tables[11].Rows[0]["TotalSCStudentsAppeared"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Promoted</td><td>" + dscnt.Tables[12].Rows[0]["TotalBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[13].Rows[0]["TotalGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[14].Rows[0]["TotalStudentsPromoted"].ToString() + "</td><td>" + dscnt.Tables[15].Rows[0]["TotalSCBoysPromoted"].ToString() + "</td><td>" + dscnt.Tables[16].Rows[0]["TotalSCGirlsPromoted"].ToString() + "</td><td>" + dscnt.Tables[17].Rows[0]["TotalSCStudentsPromoted"].ToString() + "</td></tr><tr><td colspan='2'>Total No of Detained</td><td>" + dscnt.Tables[18].Rows[0]["TotalBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[19].Rows[0]["TotalGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[20].Rows[0]["TotalStudentsDetained"].ToString() + "</td><td>" + dscnt.Tables[21].Rows[0]["TotalSCBoysDetained"].ToString() + "</td><td>" + dscnt.Tables[22].Rows[0]["TotalSCGirlsDetained"].ToString() + "</td><td>" + dscnt.Tables[23].Rows[0]["TotalSCStudentsDetained"].ToString() + "</td></tr></tbody></table>");
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
                    dvContent.Append(@"<table class=performancedata border =1, cellspacing='5' cellpadding='10' width=100%><tr><td colspan='6'>No Data</td></tr></table>");
                }

                dvC1_Content.InnerHtml = dvContent.ToString();
            }

        }
        catch (Exception)
        {
            throw;
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
                if (ddlClass.SelectedIndex != 0 && ddlClass.SelectedIndex != -1 && ddlSection.SelectedIndex != 0 && ddlSection.SelectedIndex != -1)
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
                    if (dvC1_Content.InnerHtml.Trim() != null && dvC1_Content.InnerHtml.Trim() != ""&&  dvC1_Content.InnerHtml.Trim() != "\r\n")
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

                        if (ddlType.Text == "General")
                        {
                            Disp_AllExamNameID_GENERAL();
                            LOAD_RESULT_GENERAL_Export();
                        }

                        else
                        {
                            LOAD_RESULT_SAMACHEER_Export();
                        }
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

}