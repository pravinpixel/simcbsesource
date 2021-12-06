using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.IO;
using System.Xml.Serialization;
using System.Text;

public partial class Performance_MarkEntry : System.Web.UI.Page
{
    string strClass = "";
    string strSection = "";
    string strClassID = "";
    string strSectionID = "";
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
                               
            hfUserId.Value = Userid.ToString();
            if (!IsPostBack)
            {
                BindTemplate();
                //BindClass();
                BindExamNames();
                BindDummyRow();
                BindSubjects();
            }

        }
    }

    private void BindSubjects()
    {
        utl = new Utilities();
        DataSet dsSubjects = new DataSet();
        dsSubjects = utl.GetDataset("sp_GetSubExperience");
        if (dsSubjects != null && dsSubjects.Tables.Count > 0 && dsSubjects.Tables[0].Rows.Count > 0)
        {
            ddlSubjects.DataSource = dsSubjects;
            ddlSubjects.DataTextField = "SubExperienceName";
            ddlSubjects.DataValueField = "SubExperienceID";
            ddlSubjects.DataBind();
        }
        else
        {
            ddlSubjects.DataSource = null;
            ddlSubjects.DataTextField = "";
            ddlSubjects.DataValueField = "";
            ddlSubjects.DataBind();
        }
    }

    private void BindExamNames()
    {
        Utilities utl = new Utilities();
        string sqlstr = "SP_GETExamNameList " + "'','"+ AcademicID +"'";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlExamName.DataSource = dt;
            ddlExamName.DataTextField = "ExamName";
            ddlExamName.DataValueField = "ExamNameID";
            ddlExamName.DataBind();
        }
        else
        {
            ddlExamName.DataSource = null;
            ddlExamName.DataBind();
            ddlExamName.SelectedIndex = 0;
        }
    }

    protected void ddlExamName_SelectedIndexChanged(object sender, EventArgs e)
    {
        Utilities utl = new Utilities();
        string sqlstr = "[sp_GetExamNameByType] " + "'" + ddlExamName.SelectedValue + "','" + AcademicID + "'";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);
        ddlExamType.Items.Clear();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlExamType.DataSource = dt;
            ddlExamType.DataTextField = "ExamTypeName";
            ddlExamType.DataValueField = "ExamTypeID";
            ddlExamType.DataBind();
        }
        else
        {
            ddlExamType.DataSource = null;
            ddlExamType.DataBind();
            ddlExamType.SelectedIndex = -1;
        }
        ddlExamType.Items.Insert(0, "---Select---");
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
    public static string GetList(string classid, string section, string type, string academicId, string examTypeId)
    {
        string text = @"<?xml version=""1.0"" encoding=""utf-16""?>";

        if (classid == string.Empty)
            classid = "''";
        if (section == string.Empty)
            section = "''";

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SP_GETLANGUAGELIST " + classid + ",'" + type + "'";
        ds = utl.GetDataset(query);

        Utilities utld = new Utilities();
        DataTable dt = new DataTable();
        string qry = "SP_GETSTUDENTMARKSBYCLASS " + classid + "," + section + "," + examTypeId + "," + type + "," + academicId + "";
        dt = utl.GetDataTable(qry);
        ds.Tables.Add(dt);
        System.Xml.XmlReader xr = new System.Xml.XmlTextReader(new System.IO.StringReader(text));
        //ds.ReadXml(xr);
        var xmlString = ToXml(ds);
        return ds.GetXml();
    }

    public static string ToXml(DataSet ds)
    {
        using (var memoryStream = new MemoryStream())
        {
            using (TextWriter streamWriter = new StreamWriter(memoryStream))
            {
                var xmlSerializer = new XmlSerializer(typeof(DataSet));
                xmlSerializer.Serialize(streamWriter, ds);
                return Encoding.UTF8.GetString(memoryStream.ToArray());
            }
        }
    }

    public class MarkList
    {
        public string examId { get; set; }
        public string type { get; set; }
        public string classID { get; set; }
        public string sectionId { get; set; }
        public string regNo { get; set; }
        public string subId { get; set; }
        public string marks { get; set; }
        public string academicId { get; set; }
        public string userId { get; set; }
    }

    [WebMethod]
    public static string BindClassByExamType(int ExamTypeID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_getexamtypes " + "" + ExamTypeID + "";
        return utl.GetDatasetTable(query, "ClassByExamType").GetXml();
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

    //protected string BindSMScopy()
    //{
    //    utl = new Utilities();
    //    DataTable dt = new DataTable();
    //    StringBuilder sb = new StringBuilder();

    //    dt = utl.GetDataTable("sp_GetSMSCopy");
    //    if (dt != null && dt.Rows.Count > 0)
    //    {
    //        foreach (DataRow dr in dt.Rows)
    //        {
    //            sb.Append("<div class=\"checkbox1\"><input id=\"rd_" + dr["StaffID"].ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkSmscopy\" name=\"chkSmscopy\" value=\"" + dr["StaffID"].ToString() + "\" />");
    //            sb.Append("<label name=\"lblSmscopy\" id=\"lbl_rd_" + dr["StaffID"].ToString() + "\" for=\"rd_" + dr["StaffID"].ToString() + "\">" + dr["StaffName"].ToString() + "</label></div>");
    //        }

    //    }
    //    return sb.ToString();
    //}

    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("AddPrm");
            dummy.Columns.Add("RegNo");
            dummy.Columns.Add("StudentName");
            dummy.Columns.Add("Mark");

            dummy.Rows.Add();
            dgStudentList.DataSource = dummy;
            dgStudentList.DataBind();
        }
        
    }


    [WebMethod]
    public static string GetStudents(string classId, string sectionId, string ExamName, string type, string subject, string ExamTypeID, string AcadmID, string MarkFrom,string MarkTo)
    {
        
        if (classId == string.Empty)
            classId = "''";
        if (sectionId == string.Empty)
            sectionId = "''";

        string[] Marks = new string[2];
        if (MarkFrom != "" && MarkFrom != null)
        {
            Marks[0] = MarkFrom;
        }
        else
        {
            Marks[0] = "";
        }
        if (MarkTo != "" && MarkTo != null)
        {
            Marks[1] = MarkTo;
        }
        else
        {
            Marks[1] = "";
        }
        string query = "";
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();

        if (classId != "''" && sectionId != "''" && ExamName != "''" && type != "''" && subject != "''" && ExamTypeID != "''" && AcadmID != "''")
        {
            query = "[sp_SMSMarkList] " + classId + "," + sectionId + ",'" + ExamName + "' ,'" + type + "','" + subject + "' ," + ExamTypeID + "," + AcadmID + ",'" + Marks[0].ToString() + "','" + Marks[1].ToString() + "'";
        }

        return utl.GetDatasetTable(query, "StudentByResult").GetXml();
    }



    [WebMethod]
    public static string SaveSMS(string studlist, string sendto, string msg, string userid, string classId, string sectionId, string ExamName, string type, string subject, string ExamTypeID, string AcadmID,string MarkFrom,string MarkTo)
    {
        try
        {
            string[] splitRegno = studlist.Split(',');
            string[] Marks = new string[2];
            if (MarkFrom != "" && MarkFrom != null)
            {
                Marks[0] = MarkFrom;
            }
            else
            {
                Marks[0] = "";
            }
            if (MarkTo != "" && MarkTo != null)
            {
                Marks[1] = MarkTo;
            }
            else
            {
                Marks[1] = "";
            }
            
            string phNumber;
            string EXECquery;
            string query;
            string res ="";

            DataSet dsGet = new DataSet();
            Utilities utl = new Utilities();

            DateTime Datetime = DateTime.Now;           
            string format = "MMM-d ";

            query = "[sp_SMSMarkList] " + classId + "," + sectionId + ",'" + ExamName + "' ,'" + type + "','" + subject + "' ," + ExamTypeID + "," + AcadmID + ",'" + Marks[0] + "','" + Marks[1] + "'";

                dsGet = utl.GetDataset(query);

                DataRow[] drStud = dsGet.Tables[0].Select("RegNo IN(" + studlist + ")");

                if (drStud.Length > 0)
                {
                    for (int i = 0; i < drStud.Length; i++)
                    {
                        res += Datetime.ToString(format) + "-" + drStud[i]["ExamTypeName"].ToString() + ", ObtainedMark-(" + drStud[i]["Mark"].ToString() + "/" + drStud[i]["MaxMark"].ToString() + ")" + "-";
                        res += msg;

                        switch (sendto)
                        {
                            case "P":
                                query = "select case when priority=1 then FatherCell when priority=2 then mothercell when priority=3 then gphno else FatherCell end as                                 Priority,FatherCell,MotherCell,GPhno from vw_getstudent where RegNo='" + drStud[i]["RegNo"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + res + "','SlipTest','Student','U','" + drStud[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "F":
                                query = "select FatherCell from vw_getstudent where RegNo='" + drStud[i]["RegNo"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + res + "','SlipTest','Student','U','" + drStud[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "M":
                                query = "select mothercell from vw_getstudent where RegNo='" + drStud[i]["RegNo"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + res + "','SlipTest','Student','U','" + drStud[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;

                            case "G":
                                query = "select GPhno from vw_getstudent where RegNo='" + drStud[i]["RegNo"].ToString() + "'";
                                phNumber = utl.ExecuteScalar(query);

                                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + res + "','SlipTest','Student','U','" + drStud[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                                utl.ExecuteQuery(EXECquery);
                                break;
                        }

                        res = "";
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