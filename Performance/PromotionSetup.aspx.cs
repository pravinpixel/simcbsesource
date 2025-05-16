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
using System.Drawing.Printing;
using System.Drawing;
using System.Text;

public partial class Performance_PromotionSetup : System.Web.UI.Page
{
    string strClass = "";
    string strClassID = "";
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    public static int AcademicID = 0;
    public static string UserName = string.Empty;
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
            AcademicID = Convert.ToInt32(Session["AcademicID"]);
            hfAcademicID.Value = AcademicID.ToString();
            hfUserId.Value = Userid.ToString();
            if (!IsPostBack)
            {
                BindClass();
                BindDummyRow();
                BindExamNameList();
            }

        }
    }

    private void BindExamNameList()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        string query = "sp_GetExamNameList " + "''" + "," + AcademicID;
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            rbtnList1.DataSource = dt;
            rbtnList1.DataTextField = "ExamName";
            rbtnList1.DataValueField = "ExamNameID";
            rbtnList1.DataBind();


            rbtnList2.DataSource = dt;
            rbtnList2.DataTextField = "ExamName";
            rbtnList2.DataValueField = "ExamNameID";
            rbtnList2.DataBind();

            rbtnList3.DataSource = dt;
            rbtnList3.DataTextField = "ExamName";
            rbtnList3.DataValueField = "ExamNameID";
            rbtnList3.DataBind();

            rbtnList4.DataSource = dt;
            rbtnList4.DataTextField = "ExamName";
            rbtnList4.DataValueField = "ExamNameID";
            rbtnList4.DataBind();

        }
        else
        {
            rbtnList1.DataSource = null;
            rbtnList1.DataBind();

            rbtnList2.DataSource = null;
            rbtnList2.DataBind();

            rbtnList3.DataSource = null;
            rbtnList3.DataBind();

            rbtnList4.DataSource = null;
            rbtnList4.DataBind();
        }
        foreach (ListItem li in rbtnList1.Items)
            li.Attributes.Add("Classes", "NameList1");

        foreach (ListItem li in rbtnList2.Items)
            li.Attributes.Add("Classes", "NameList2");

        foreach (ListItem li in rbtnList3.Items)
            li.Attributes.Add("Classes", "NameList3");

        foreach (ListItem li in rbtnList4.Items)
            li.Attributes.Add("Classes", "NameList4");
    }



    protected string BindGroup1()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        string query = "sp_GetExamNameList " + "''" + "," + AcademicID;
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                sb.Append("<div class=\"group1\"><input id=\"rd_" + dr["ExamNameID"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkExamName1\" name=\"chkExamName1\" value=\"" + dr["ExamNameID"].ToString() + "\" />");
                sb.Append("<label name=\"lblExamName\" id=\"lbl_rd_" + dr["ExamNameID"].ToString() + "\" for=\"rd_" + dr["ExamNameID"].ToString() + "\">" + dr["ExamName"].ToString() + "</label></div>");
            }

        }
        return sb.ToString();
         
    }


    protected string BindGroup2()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        string query = "sp_GetExamNameList " + "''" + "," + AcademicID;
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                sb.Append("<div class=\"group2\"><input id=\"rd_" + dr["ExamNameID"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkExamName2\" name=\"chkExamName2\" value=\"" + dr["ExamNameID"].ToString() + "\" />");
                sb.Append("<label name=\"lblExamName\" id=\"lbl_rd_" + dr["ExamNameID"].ToString() + "\" for=\"rd_" + dr["ExamNameID"].ToString() + "\">" + dr["ExamName"].ToString() + "</label></div>");
            }

        }
        // return sb.ToString();
        return "";

    }


    protected string BindGroup3()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        string query = "sp_GetExamNameList " + "''" + "," + AcademicID;
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                sb.Append("<div class=\"group3\"><input id=\"rd_" + dr["ExamNameID"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkExamName3\" name=\"chkExamName3\" value=\"" + dr["ExamNameID"].ToString() + "\" />");
                sb.Append("<label name=\"lblExamName\" id=\"lbl_rd_" + dr["ExamNameID"].ToString() + "\" for=\"rd_" + dr["ExamNameID"].ToString() + "\">" + dr["ExamName"].ToString() + "</label></div>");
            }

        }
        // return sb.ToString();
        return "";

    }

    protected string BindGroup4()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        string query = "sp_GetExamNameList " + "''" + "," + AcademicID;
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                sb.Append("<div class=\"group4\"><input id=\"rd_" + dr["ExamNameID"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkExamName4\" name=\"chkExamName4\" value=\"" + dr["ExamNameID"].ToString() + "\" />");
                sb.Append("<label name=\"lblExamName\" id=\"lbl_rd_" + dr["ExamNameID"].ToString() + "\" for=\"rd_" + dr["ExamNameID"].ToString() + "\">" + dr["ExamName"].ToString() + "</label></div>");
            }

        }
        // return sb.ToString();
        return "";

    }

    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();


            dummy = new DataTable();
            dummy.Columns.Add("ExamName");
            dummy.Columns.Add("Description");
            dummy.Columns.Add("StartDate");
            dummy.Columns.Add("EndDate");
            dummy.Columns.Add("ExamNameID");
            dummy.Rows.Add();


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
    [WebMethod]
    public static string GetPromotionCriteria(string ClassID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetPromotionCriteria " + ClassID + "," + HttpContext.Current.Session["AcademicID"].ToString();
        ds = utl.GetDataset(query);
        return ds.GetXml();
    }

    [WebMethod]
    public static string SavePromotion(string ClassID, string CaseI, string CaseII, string CaseIII)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        AcademicID = Convert.ToInt32(HttpContext.Current.Session["AcademicID"]);
        string SubjectType = "";
        string ExamName1= "";
        string ExamName2 = "";
        string ExamName3 = "";
        string ExamName4 = "";
        sqlstr = "select count(*) from p_promotionsetup where isactive=1 and AcademicID='" + AcademicID + "' and ClassID='" + ClassID + "'";
        string icnt = "";
        icnt = utl.ExecuteScalarValue(sqlstr);

        if (icnt != "0")
        {
            utl.ExecuteQuery("delete from p_promotionsetupdetails where  AcademicID='" + AcademicID + "' and ClassID='" + ClassID + "'");
            utl.ExecuteQuery("delete from p_promotionsetup where  AcademicID='" + AcademicID + "' and ClassID='" + ClassID + "'");
        }
            string[] strCaseI = new string[3];
            strCaseI = CaseI.ToString().Split('-');
            if (strCaseI.Length > 0)
            {
                sqlstr = "sp_InsertPromotion '" + ClassID + "','CaseI','" + strCaseI[1].ToString() + "','" + strCaseI[2].ToString() + "','" + AcademicID + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
                if (strQueryStatus != string.Empty)
                {
                    sqlstr = " select distinct SubjectType  from p_classsubjects  where ClassID='" + ClassID + "' and SubjectType in ('Samacheer','General') and AcademicID ='" + AcademicID + "' and IsActive=1 ";
                    SubjectType=utl.ExecuteScalarValue(sqlstr);
                    if (SubjectType=="General")
                    {
                        sqlstr = "sp_InsertPromotionDetails '" + strQueryStatus + "','" + ClassID + "','" + strCaseI[0].ToString() + "','A','" + strCaseI[1].ToString() + "','" + AcademicID + "','" + Userid + "'";
                        utl.ExecuteQuery(sqlstr);
                    }
                    else if (SubjectType=="Samacheer")
                    {
                        sqlstr = "select ExamName from p_examnamelist where ExamNameID='" + strCaseI[0].ToString() + "'";
                        ExamName1 = utl.ExecuteScalarValue(sqlstr);
                        sqlstr = "sp_InsertPromotionDetails '" + strQueryStatus + "','" + ClassID + "','" + strCaseI[0].ToString() + "','" + ExamName1 + "','" + strCaseI[1].ToString() + "','" + AcademicID + "','" + Userid + "'";
                        utl.ExecuteQuery(sqlstr);
                    }
                  
                }
            }

            string[] strCaseII = new string[10];
            strCaseII = CaseII.ToString().Split('-');
            if (strCaseII.Length > 0)
            {
                sqlstr = "sp_InsertPromotion '" + ClassID + "','CaseII','" + strCaseII[8].ToString() + "','" + strCaseII[9].ToString() + "','" + AcademicID + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
                if (strQueryStatus != string.Empty)
                {
                    sqlstr = " select distinct SubjectType  from p_classsubjects  where ClassID='" + ClassID + "' and SubjectType in ('Samacheer','General') and AcademicID ='" + AcademicID + "' and IsActive=1 ";
                    SubjectType=utl.ExecuteScalarValue(sqlstr);
                    if (SubjectType == "General")
                    { 
                        sqlstr = "sp_InsertPromotionCaseIIDetails '" + strQueryStatus + "','" + ClassID + "','" + strCaseII[0].ToString() + "','" + strCaseII[1].ToString() + "','M','" + strCaseII[2].ToString() + "','" + strCaseII[3].ToString() + "','Q','" + strCaseII[4].ToString() + "','" + strCaseII[5].ToString() + "','H','" + strCaseII[6].ToString() + "','" + strCaseII[7].ToString() + "','A','" + AcademicID + "','" + Userid + "'";
                        utl.ExecuteQuery(sqlstr);
                    }
                    else if (SubjectType == "Samacheer")
                    {
                        sqlstr = "select ExamName from p_examnamelist where ExamNameID='" + strCaseII[2].ToString() + "'";
                        ExamName2 = utl.ExecuteScalarValue(sqlstr);

                        sqlstr = "select ExamName from p_examnamelist where ExamNameID='" + strCaseII[4].ToString() + "'";
                        ExamName3 = utl.ExecuteScalarValue(sqlstr);

                        sqlstr = "select ExamName from p_examnamelist where ExamNameID='" + strCaseII[6].ToString() + "'";
                        ExamName4 = utl.ExecuteScalarValue(sqlstr);

                        sqlstr = "sp_InsertPromotionCaseIIDetails '" + strQueryStatus + "','" + ClassID + "','" + strCaseII[0].ToString() + "','" + strCaseII[1].ToString() + "','','" + strCaseII[2].ToString() + "','" + strCaseII[3].ToString() + "','" + ExamName2 + "','" + strCaseII[4].ToString() + "','" + strCaseII[5].ToString() + "','" + ExamName3 + "','" + strCaseII[6].ToString() + "','" + strCaseII[7].ToString() + "','" + ExamName4 + "','" + AcademicID + "','" + Userid + "'";
                        utl.ExecuteQuery(sqlstr);
                    }
                }
            }

            string[] strCaseIII = new string[3];
            strCaseIII = CaseIII.ToString().Split('-');
            if (strCaseIII.Length > 0)
            {
                sqlstr = "sp_InsertPromotion '" + ClassID + "','CaseIII','" + strCaseIII[1].ToString() + "','" + strCaseIII[2].ToString() + "','" + AcademicID + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
                if (strQueryStatus != string.Empty)
                {
                    sqlstr = "select ExamName from p_examnamelist where ExamNameID='" + strCaseII[2].ToString() + "'";
                    ExamName2 = utl.ExecuteScalarValue(sqlstr);

                    sqlstr = "select ExamName from p_examnamelist where ExamNameID='" + strCaseII[4].ToString() + "'";
                    ExamName3 = utl.ExecuteScalarValue(sqlstr);

                    sqlstr = "select ExamName from p_examnamelist where ExamNameID='" + strCaseII[6].ToString() + "'";
                    ExamName4 = utl.ExecuteScalarValue(sqlstr);

                    sqlstr = "sp_InsertPromotionCaseIIDetails '" + strQueryStatus + "','" + ClassID + "','" + strCaseII[0].ToString() + "','" + strCaseII[1].ToString() + "','','" + strCaseII[2].ToString() + "','" + strCaseII[3].ToString() + "','" + ExamName2 + "','" + strCaseII[4].ToString() + "','" + strCaseII[5].ToString() + "','" + ExamName3 + "','" + strCaseII[6].ToString() + "','" + strCaseII[7].ToString() + "','" + ExamName4 + "','" + AcademicID + "','" + Userid + "'";
                   strQueryStatus= utl.ExecuteQuery(sqlstr);

                }
            }
        

        if (strQueryStatus == "")
            return "Inserted";
        else
            return "Insert Failed";

    }    
}