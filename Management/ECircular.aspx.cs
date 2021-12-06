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

public partial class Management_ECircular : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.RequestType == "POST")
        {
            if (Request.Files["ECircular"] != null && Request.Files["ECircular"].ContentLength > 0 && Request.Form["ECircularID"] != null && Request.Form["ECircularID"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["ECircular"];
                string id = Request.Form["ECircularID"].ToString();
                string extension = PostedFile.FileName.Substring(PostedFile.FileName.LastIndexOf('.'));
                PostedFile.SaveAs(Server.MapPath("~/Management/ECirculars/" + System.DateTime.Now.ToString("yyyyMMdd")+"_" + id + extension));
            }
            return;
        }
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            utl = new Utilities();
            Userid = Convert.ToInt32(Session["UserId"]);
            sqlstr = "select roleid from m_users where userID =" + Userid;
            hfRoleID.Value= utl.ExecuteScalar(sqlstr);
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
            dummy.Columns.Add("FileName");
            dummy.Columns.Add("ECircularID");
            dummy.Rows.Add();
            dgECircularInfo.DataSource = dummy;
            dgECircularInfo.DataBind();


            dummy = new DataTable();
            //dummy.Columns.Add("SlNo");
            //dummy.Columns.Add("DOI");
            //dummy.Columns.Add("Title");
            dummy.Columns.Add("StaffName");
            dummy.Columns.Add("Message");
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
                    sda.Fill(ds, "ECircularInfo");
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
    public static string GetECircularLog(int ECircularID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetECircularLog '" + ECircularID + "'";
        ds = utl.GetDatasetTable(query, "ECircularLog");
        return ds.GetXml();

    }
    [WebMethod]
    public static string GetECircularInfo(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetECircular_Pager]";
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
    public static string GetECircular(int ECircularID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetECircular " + "" + ECircularID + "";
        return utl.GetDatasetTable(query, "EditECircularInfo").GetXml();
    }
    [WebMethod]
    public static string EditECircularInfo(int ECircularID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetECircular " + "" + ECircularID + "";
        return utl.GetDatasetTable(query, "EditECircular").GetXml();
    }

    [WebMethod]
    public static string DeleteECircularInfo(string ECircularInfoID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteECircular " + "" + ECircularInfoID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string SaveECircularLog(string ECircularID)
    {

        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        sqlstr = "select ECircularLogID from a_ECircularLog where StaffId='" + Userid + "'  and ECircularID='" + ECircularID + "'";
        string ECircularLogID = Convert.ToString(utl.ExecuteScalar(sqlstr));
        if (ECircularLogID == "")
            {
                sqlstr = "insert into a_ECircularLog(ECircularID,IsViewed,StaffId)values('" + ECircularID + "',1,'" + Userid + "')";
            }
            else
            {
                sqlstr = "update  a_ECircularLog set isviewed=1,StaffId='" + Userid + "' where  ECircularID='" + ECircularID + "' and ECircularLogID='" + ECircularLogID + "'";
            }
        strQueryStatus = Convert.ToString(utl.ExecuteQuery(sqlstr));
        if (strQueryStatus == "")
            return "E-Circular Viewed";
        else
            return "Viewed Failed";

    }
    [WebMethod]
    public static string SaveECircular(string ECircularID, string DOI, string Title, string Message, string SendTo, string FileName)
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
        

        if (!string.IsNullOrEmpty(ECircularID))
        {
            sqlstr = "select isnull(count(*),0) from a_ECircular where Title='" + Title.Replace("'", "''") + "' and DOI=" + DOI + " and Message='" + Message.Replace("'", "''") + "' and SendTo='" + SendTo.Replace("'", "''") + "' and FileName='" + FileName.Replace("'", "''") + "'   and ECircularID!='" + ECircularID + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateECircular " + "'" + ECircularID + "','" + Title.Replace("'", "''") + "'," + DOI + ",'" + Message.Replace("'", "''") + "','" + SendTo.Replace("'", "''") + "','" + FileName.Replace("'", "''") + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
                if (strQueryStatus != "")
                    return strQueryStatus;
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
            sqlstr = "select isnull(count(*),0) from a_ECircular where Title='" + Title.Replace("'", "''") + "' and DOI=" + DOI+ " and Message='" + Message.Replace("'", "''") + "' and SendTo='" + SendTo.Replace("'", "''") + "' and FileName='" + FileName.Replace("'", "''") + "'  and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertECircular '" + Title.Replace("'", "''") + "'," + DOI + ",'" + Message.Replace("'", "''") + "','" + SendTo.Replace("'", "''") + "','" + FileName.Replace("'", "''") + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
                if (strQueryStatus != "")
                    return strQueryStatus;
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