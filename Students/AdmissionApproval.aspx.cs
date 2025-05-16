using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Data.SqlClient;

public partial class Students_AdmissionApproval : System.Web.UI.Page
{
    Utilities utl = null;
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
                hdnAcademicId.Value = Session["AcademicID"].ToString();
            }
            else
            {
                Utilities utl = new Utilities();
                hdnAcademicId.Value = utl.ExecuteScalar("select top 1 academicid from m_academicyear where isactive=1 order by academicid desc");
            }


            if (!IsPostBack)
            {
                BindDummyRow();
                BindClass();
                BindAcademicYear();

            }
        }
    }

    private void BindAcademicYear()
    {
        utl = new Utilities();
        DataTable dtAcademicYear = utl.GetDataTable("exec sp_getAdmissionBelongYear");
        if (dtAcademicYear != null && dtAcademicYear.Rows.Count > 0)
        {
            ListItem currentYear = new ListItem(dtAcademicYear.Rows[0]["currentacd"].ToString(), dtAcademicYear.Rows[0]["academicid"].ToString());
            currentYear.Selected = true;
            radlAcademicYear.Items.Add(currentYear);
            DataTable dt = new DataTable();
            dt = utl.GetDataTable("sELECT AcademicId+1 nextacd, convert(varchar(10),year(startdate)+1)+'-'+convert(varchar(10),year(enddate)+1) as Year   FROM m_academicyear where isactive='true'");
           if (dt!=null && dt.Rows.Count>0)
           {
               ListItem nextYear = new ListItem(dt.Rows[0]["Year"].ToString(), dt.Rows[0]["nextacd"].ToString());
               radlAcademicYear.Items.Add(nextYear);
               
           }
           
        }
    }

    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("Register No");
            dummy.Columns.Add("Student Name");
            dummy.Columns.Add("Class");
            dummy.Columns.Add("Section");
            dummy.Rows.Add();
            grdAdmissionApproval.DataSource = dummy;
            grdAdmissionApproval.DataBind();
        }
    }

    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("exec sp_GetAdmissionApprovalClass");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass.DataSource = dsClass;
            ddlClass.DataTextField = "class";
            ddlClass.DataValueField = "classid";
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
    public static string GetAdmissionApprovalStudList(int pageIndex, string regNo, string Class, string studentName, string AcademicId)
    {
        Utilities utl = new Utilities();
        string query = "[sp_GetAdmissionStudList]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@regno", regNo);
        cmd.Parameters.AddWithValue("@classname", Class);
        cmd.Parameters.AddWithValue("@studentname", studentName);
        cmd.Parameters.AddWithValue("@AcademicId", AcademicId);
        return utl.GetData(cmd, pageIndex, "AdmissionStudList", PageSize).GetXml();

    }

    [WebMethod]
    public static string GetAdmissionApprovalStudClassbySection(string regNo, string Classid)
    {

        Utilities utl = new Utilities();
        DataSet dsSection = new DataSet();
        StringBuilder strSection = new StringBuilder();
        SqlCommand cmd = new SqlCommand("sp_GetSectionByClass");

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@ClassId", Classid);
        dsSection = utl.GetDataset("exec sp_GetSectionByClass " + Classid);
        strSection.Append("<select id=\"" + regNo + "\" onchange=\"updateSection('" + regNo.Trim() + "','" + Classid + "');\"><option value=\"\">---Select---</option>");
        if (dsSection != null && dsSection.Tables.Count > 0 && dsSection.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsSection.Tables[0].Rows.Count; i++)
                strSection.Append("<option value=\"" + dsSection.Tables[0].Rows[i]["sectionid"].ToString() + "\">" + dsSection.Tables[0].Rows[i]["sectionname"].ToString() + "</option>");

        }
        strSection.Append("</select>");
        return strSection.ToString();
    }

    [WebMethod]
    public static string UpdateStudentSection(string regNo, string sectionId, string Classid, string AcademicYearId, int userId)
    {
        Utilities utl = new Utilities();

        string sqlstr = "select studentid from s_studentinfo where regno='" + regNo + "' and (adminno is null or adminno = 0)";
        string studentid = utl.ExecuteScalar(sqlstr);
        string returnVal = "";
        string Actual = "";
        if (studentid == "")
        {
            sqlstr = "select regNo from s_studentinfo where regno='" + regNo + "'";
            Actual = utl.ExecuteScalar(sqlstr);


            returnVal = "Already Admission is Approved, Please find the Actual Regno:" + Actual;
        }
        else if (studentid == regNo)
        {
            returnVal = utl.ExecuteScalar("exec sp_StudAdmissionApprovalNew " + regNo + "," + sectionId + "," + Classid + ",'" + AcademicYearId + "'," + userId);
        }
        else
        {
            returnVal = utl.ExecuteScalar("exec sp_StudAdmissionApproval " + regNo + "," + sectionId + "," + Classid + ",'" + AcademicYearId + "'," + userId);
        }
        string reg = returnVal;

        utl.ExecuteQuery("update s_studentinfo set regNo=" + returnVal + ",active='N' where academicyear='" + AcademicYearId + "' and regno=" + regNo + "");

        utl.ExecuteQuery("update f_studentbillmaster set refno=" + regNo + ",regno=" + returnVal + " where academicID='" + AcademicYearId + "' and regno=" + regNo + "");

        string applicationno = utl.ExecuteScalar("select applicationno from s_studentinfo where regno='" + returnVal + "'");

        utl.ExecuteAPPQuery("update studentapplications set regno='" + returnVal + "' where ApplicationNo='" + applicationno.ToString().Trim() + "'");

        returnVal = utl.ExecuteScalar("select 'The Approved Student Register no is : ' + CONVERT(varchar(max), RegNo) + ' and Admission no is :  ' + CONVERT(varchar(max), AdminNo) + ' ' from s_studentinfo where RegNo='" + reg + "'");
        if (returnVal=="")
        {
            return returnVal;
        }
        else
        {
            return returnVal;
        }       
    }

    [WebMethod]
    public static string getApplicationdetail(string regNo)
    {
        Utilities utl = new Utilities();
        string returnVal = "";
        utl = new Utilities();
        DataSet dsapp = new DataSet();

        string applicationNo = utl.ExecuteScalar("select applicationno from s_studentinfo where regno='" + regNo + "' ");
        dsapp = utl.GetAPPDataset(@"select ApplicationNo,TempNo,case when isCancel=1 then 'In-Active' else 'Active' end as status,d.PaymentDate,d.TempRecNo,d.Amount,e.name,case when d.deleted_at is null then 'Paid' else 'Not-Paid' end as paidStatus  from studentapplications a inner join institutions b on b.ID=a.SchoolID 
inner join student_classes c on c.ClassId=a.ClassRequested and a.SchoolID=c.InstitutionId 
left join s_payment_receipts d on d.ApplicationID=a.ApplicationID  
left join users e on d.UserId=e.id
where a.isactive=1 and a.AcademicID=(select AcademicID from academicyears where IsActive=1) and c.IsActive=1 and SchoolID=2 and ReturnDate is not null and a.applicationNo='" + applicationNo + "' order by a.ApplicationID asc");
        if (dsapp != null && dsapp.Tables.Count > 0 && dsapp.Tables[0].Rows.Count > 0)
        {
            if (dsapp.Tables[0].Rows.Count > 0)
            {
                if (dsapp.Tables[0].Rows[0]["status"].ToString() == "Active" && dsapp.Tables[0].Rows[0]["paidStatus"].ToString() == "Paid")
                {
                    returnVal = "The selected student with the Application no: " + applicationNo + " is '" + dsapp.Tables[0].Rows[0]["status"].ToString() + "' and the New Admission payment in SIMAPP is '" + dsapp.Tables[0].Rows[0]["paidStatus"].ToString() + "'<br/> Details -  Date: " + dsapp.Tables[0].Rows[0]["PaymentDate"].ToString() + " , Receipt No: " + dsapp.Tables[0].Rows[0]["TempRecNo"].ToString() + ", Receipt Amount:" + dsapp.Tables[0].Rows[0]["Amount"].ToString() + ", Received By:" + dsapp.Tables[0].Rows[0]["name"].ToString() + ", You can proceed to Approve the admission!";
                }
                else
                {
                    returnVal = "failed";
                }
            }
        }
        return returnVal;
    }
}