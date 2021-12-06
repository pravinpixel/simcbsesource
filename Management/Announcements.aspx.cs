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

public partial class Management_Announcements : System.Web.UI.Page
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
            BindDummyRow();
            BindRole();
          
        }
        if (!IsPostBack)
        {
              txtDOI.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
        }
       
    }

    private void BindRole()
    {
        utl = new Utilities();
        sqlstr = "sp_GetRole";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSendTo.DataSource = dt;
            ddlSendTo.DataTextField = "RoleName";
            ddlSendTo.DataValueField = "RoleID";
            ddlSendTo.DataBind();
        }
        else
        {
            ddlSendTo.DataSource = null;
            ddlSendTo.DataBind();
            ddlSendTo.SelectedIndex = 0;
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("SlNo");
            dummy.Columns.Add("DOI");
            dummy.Columns.Add("Title");
            dummy.Columns.Add("Message");
            dummy.Columns.Add("RoleName");
            dummy.Columns.Add("AnnouncementsID");
            dummy.Rows.Add();
            dgAnnouncementsInfo.DataSource = dummy;
            dgAnnouncementsInfo.DataBind();


            dummy = new DataTable();
            dummy.Columns.Add("SlNo");
            dummy.Columns.Add("DOI");
            dummy.Columns.Add("Title");
            dummy.Columns.Add("StaffName");
            dummy.Rows.Add();
            dgCount.DataSource = dummy;
            dgCount.DataBind();
        }
    }
    public static DataSet GetData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMCBSEConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "AnnouncementsInfo");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }
    [WebMethod]
    public static string GetAnnouncementsLog(int AnnouncementsID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetAnnouncementsLog '" + AnnouncementsID + "'";
        ds = utl.GetDatasetTable(query, "AnnouncementsLog");
        return ds.GetXml();

    }
    [WebMethod]
    public static string GetAnnouncementsInfo(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetAnnouncements_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();

    }
    [WebMethod]
    public static string GetModuleId(string path)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModuleMenuIdByPath '" + path + "'," + Userid + "";
        ds = utl.GetDatasetTable(query, "ModuleMenusByPath");
        return ds.GetXml();
    }

    [WebMethod]
    public static string GetAnnouncements(int AnnouncementsID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetAnnouncements " + "" + AnnouncementsID + "";
        return utl.GetDatasetTable(query, "EditAnnouncementsInfo").GetXml();
    }
    

    [WebMethod]
    public static string DeleteAnnouncementsInfo(string AnnouncementsInfoID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteAnnouncements " + "" + AnnouncementsInfoID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string SaveAnnouncements(string AnnouncementsID, string DOI, string Title, string Message, string SendTo)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (DOI != "")
        {
            string[] myDateTimeString = DOI.Split('/');
            DOI = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        

        if (!string.IsNullOrEmpty(AnnouncementsID))
        {
            sqlstr = "select isnull(count(*),0) from a_Announcements where Title='" + Title.Replace("'", "''") + "' and DOI=" + DOI + " and Message='" + Message.Replace("'", "''") + "' and SendTo='" + SendTo.Replace("'", "''") + "'  and AnnouncementsID!='" + AnnouncementsID + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateAnnouncements " + "'" + AnnouncementsID + "','" + Title.Replace("'", "''") + "'," + DOI + ",'" + Message.Replace("'", "''") + "','" + SendTo.Replace("'", "''") + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Exists, Update";
            }
        }
        else
        {
            sqlstr = "select isnull(count(*),0) from a_Announcements where Title='" + Title.Replace("'", "''") + "' and DOI=" + DOI+ " and Message='" + Message.Replace("'", "''") + "' and SendTo='" + SendTo.Replace("'", "''") + "'  and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertAnnouncements '" + Title.Replace("'", "''") + "'," + DOI + ",'" + Message.Replace("'", "''") + "','" + SendTo.Replace("'", "''") + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }
}