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

public partial class IndividualSMS : System.Web.UI.Page
{
    Utilities utl = new Utilities();
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
                BindTemplate();
                BindClass();
                // BindSMSCopyTo();
                BindDummyRow();
            }

        }
    }
    private void BindTemplate()
    {
        string query = "sp_GetMessageTemplate";

        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlTemplate.DataSource = dt;
            ddlTemplate.DataTextField = "MessageTemplateName";
            ddlTemplate.DataValueField = "MessageTemplateID";
            ddlTemplate.DataBind();

        }
        else
        {
            ddlTemplate.DataSource = null;
            ddlTemplate.DataBind();
            ddlTemplate.Items.Clear();
        }
        ddlTemplate.SelectedIndex = 0;
    }
    [WebMethod]
    public static string GetMessageTemplate(int MessTempID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetMessageTemplate " + "" + MessTempID + "";
        return utl.GetDatasetTable(query, "GetMessageTemplate").GetXml();
    }


    protected string BindSMScopy()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();

        dt = utl.GetDataTable("sp_GetSMSCopy");
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                sb.Append("<div class=\"checkbox1\"><input id=\"rd_" + dr["StaffID"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkSmscopy\" name=\"chkSmscopy\" value=\"" + dr["StaffID"].ToString() + "\" />");
                sb.Append("<label name=\"lblSmscopy\" id=\"lbl_rd_" + dr["StaffID"].ToString() + "\" for=\"rd_" + dr["StaffID"].ToString() + "\">" + dr["StaffName"].ToString() + "</label></div>");
            }

        }
        return sb.ToString();

    }



    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("AddPrm");
            dummy.Columns.Add("RegNo");
            dummy.Columns.Add("StudentName");

            dummy.Rows.Add();
            dgStudentList.DataSource = dummy;
            dgStudentList.DataBind();
        }
    }
    private void BindClass()
    {
        Utilities utl = new Utilities();
        string sqlstr = "sp_GetClass";
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
    public static string GetStudents(string classId, string sectionId)
    {
        if (classId == string.Empty)
            classId = "''";
        if (sectionId == string.Empty)
            sectionId = "''";
        string query = "";
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        if (classId != "''" && sectionId != "''")
        {
            query = "[sp_GetStudentBySectionID] " + classId + "," + sectionId + "";

        }

        return utl.GetDatasetTable(query, "StudentBySection").GetXml();
    }

    [WebMethod]
    public static string SaveSMS(string studlist, string sendto, string msg, string userid, string stafflist)
    {
        try
        {
            string sqlquery;
            string phNumber;
            string EXECquery;
            string query;

            DataSet dsGet = new DataSet();
            Utilities utl = new Utilities();

            string sqlquery1;
            DataSet dsGet1 = new DataSet();

            string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
            string Isactive = utl.ExecuteScalar(sqlstr);
            if (Isactive == "True")
            {
                sqlquery = "select * from vw_getstudent where RegNo IN(" + studlist + ") and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";

                dsGet = utl.GetDataset(sqlquery);
                if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                    {
                        switch (sendto)
                        {
                            case "P":
                                query = "select case when priority=1 then FatherCell when priority=2 then mothercell when priority=3 then gphno else FatherCell end as Priority,FatherCell,MotherCell,GPhno from vw_getstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Individual','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "F":
                                query = "select FatherCell from vw_getstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Individual','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "M":
                                query = "select mothercell from vw_getstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Individual','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "G":
                                query = "select GPhno from vw_getstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Individual','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;
                        }
                    }
                }
            }
            else
            {
                sqlquery = "select * from vw_getOldstudent where RegNo IN(" + studlist + ") and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";

                dsGet = utl.GetDataset(sqlquery);
                if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                    {
                        switch (sendto)
                        {
                            case "P":
                                query = "select case when priority=1 then FatherCell when priority=2 then mothercell when priority=3 then gphno else FatherCell end as Priority,FatherCell,MotherCell,GPhno from vw_getOldstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Individual','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "F":
                                query = "select FatherCell from vw_getOldstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Individual','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "M":
                                query = "select mothercell from vw_getOldstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Individual','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "G":
                                query = "select GPhno from vw_getOldstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Individual','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;
                        }
                    }
                }
            }
             
            

            //SMS Copy To Staff
            sqlquery1 = "select StaffId,MobileNo from e_staffinfo where StaffId IN(" + stafflist + ")";
            dsGet1 = utl.GetDataset(sqlquery1);
            if (dsGet1 != null && dsGet1.Tables.Count > 0 && dsGet1.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < dsGet1.Tables[0].Rows.Count; i++)
                {
                    EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + dsGet1.Tables[0].Rows[i]["MobileNo"].ToString() + "','" + msg + "','Individual','SMSCopy','U','" + dsGet1.Tables[0].Rows[i]["StaffId"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";

                    utl.ExecuteQuery(EXECquery);
                }
            }
        }

        catch (Exception ex)
        {
            return "InsertFailed";
        }

        return "success";
    }

}
