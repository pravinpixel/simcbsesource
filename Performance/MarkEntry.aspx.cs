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
using System.Xml;

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
                BindClass();
                BindExamNames();
                BindDummyRow();
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
        
         //ddlClassSearch1.Items.Insert(0, "---Select---");
    }


    private void BindExamNames()
    {
        Utilities utl = new Utilities();
        string sqlstr = "SP_GETExamNameList " + "'','"+ HttpContext.Current.Session["AcademicID"] +"'";
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


    [WebMethod]
    public static string GetExamTypeByExamName(string ExamNameID, string ClassID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetExamTypeByExamName_Filter " + ExamNameID + "," + ClassID + "," + HttpContext.Current.Session["AcademicID"] + "";
        return utl.GetDatasetTable(query, "ExamTypeByExamName").GetXml();
    }


    [WebMethod]
    public static string GetExamNameByType(int ExamNameID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetExamNameByType " + ExamNameID+ "," + HttpContext.Current.Session["AcademicID"] + "";
        return utl.GetDatasetTable(query, "ExamNameByType").GetXml();
    }
    [WebMethod]
    public static string GetMaxmarks(string query)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        return utl.GetDatasetTable(query, "Mark").GetXml();
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("RegNo");
            dummy.Columns.Add("Name");
            dummy.Rows.Add();
            grdList.DataSource = dummy;
            grdList.DataBind();
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
    public static string GetList(string classid, string section, string type, string academicId, string examTypeId)
    {
        string text = @"<?xml version=""1.0"" encoding=""utf-16""?>";

        if (classid == string.Empty)
            classid = "''";
        if (section == string.Empty)
            section = "''";

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SP_GETLANGUAGELIST " + classid + ",'" + type + "','" + HttpContext.Current.Session["AcademicID"] + "'";
        ds = utl.GetDataset(query);
        
        Utilities utld = new Utilities();
        DataTable dt = new DataTable();
        string qry = "SP_GETSTUDENTMARKSBYCLASS " + classid + "," + section + "," + examTypeId + ",'" + type + "'," + HttpContext.Current.Session["AcademicID"] + "";
        dt = utl.GetDataTable(qry);
        ds.Tables.Add(dt);

        DataTable dt1 = new DataTable();
        qry = "sp_GetBindExamSetup " + examTypeId + "," + "''" + "," + "" + HttpContext.Current.Session["AcademicID"] + "";
        dt1 = utl.GetDataTable(qry);
        ds.Tables.Add(dt1);
        if (ds.Tables.Count > 1)
        {
            for (int i = 0; i < ds.Tables[1].Columns.Count; i++)
            {
                string name2 = XmlConvert.EncodeLocalName(ds.Tables[1].Columns[i].ToString());
               name2= XmlConvert.DecodeName(name2);
                ds.Tables[1].Columns[i].ColumnName.Replace(ds.Tables[1].Columns[i].ToString(), name2);
                ds.AcceptChanges();
            }            
        }     
       
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

    [WebMethod]
    public static string SaveMarks(List<MarkList> marklist)
    {
        if (marklist != null && marklist.Count > 0)
        {
            Utilities utl = new Utilities();
            string query = string.Empty;

            foreach (MarkList mark in marklist)
            {
                string[] subject = mark.subId.Split(new[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
                string[] marks = mark.marks.Split('|');

                int i = 0;
                foreach (string str in subject)
                {
                    string replace = marks[i];

                    if (marks[i] == string.Empty)
                        replace = "null";

                    string qry = utl.ExecuteScalar("ISSTUDENTEXAMMARKEXISTS " + mark.examId + "," + mark.regNo + "," + mark.classID + "," + mark.sectionId + ",'" + mark.type + "'," + str + ",'" + HttpContext.Current.Session["AcademicID"] + "'");

                    if (qry == "1")
                    {
                        query += "UPDATE p_exammarks SET Mark=" + replace + ",modifieddate='" + System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE ExamTypeId=" + mark.examId + " and RegNo=" + mark.regNo + " and ClassId=" + mark.classID + " and SectionId=" + mark.sectionId + "" + " and Type='" + mark.type + "' and AcademicID='" + HttpContext.Current.Session["AcademicID"] + "'  and ClassSubjectId=" + str + "";
                    }
                    else
                    {
                        query += "INSERT INTO [p_exammarks]([ExamTypeId],[RegNo],[ClassId],[SectionId],[Type],[ClassSubjectId],[Mark]" +
          ",[UserId],[IsActive],AcademicID,createddate)VALUES(" + mark.examId + "," + mark.regNo + "," + mark.classID + "," + mark.sectionId + "" +
          ",'" + mark.type + "'," + str + "," + replace + "," + mark.userId + ",1,'" + HttpContext.Current.Session["AcademicID"] + "','" + System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')";
                    }
                    // query="SP_UPDATEMARKLIST "+id+","+mark.regNo+","+str+",'"+replace+"',"+mark.userId+"";
                    i++;
                }
            }
            string err = utl.ExecuteQuery(query);
        }
        return "";
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

    //[WebMethod]
    //public static string BindClassByExamType(int ExamTypeID)
    //{
    //    Utilities utl = new Utilities();
    //    DataSet ds = new DataSet();
    //    string query = "sp_getexamtypes " + ExamTypeID + ","+ HttpContext.Current.Session["AcademicID"];
    //    return utl.GetDatasetTable(query, "ClassByExamType").GetXml();
    //}

    
}