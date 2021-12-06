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
using System.Text;
using System.Web.UI.HtmlControls;
using System.Drawing;
using System.Collections;

public partial class SMSCopy : System.Web.UI.Page
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
            if (!IsPostBack)
            {
                BindStaffs();
                BindDummyRow();
            }
        }
    }
    protected string BindStaffs()
    {
        StringBuilder sb = new StringBuilder();
        utl = new Utilities();
        DataTable dt = new DataTable();
        string sqlstr = "exec [GetSMSStaffInfo]";
        dt = utl.GetDataTable(sqlstr);
        Session["Count"] = dt.Rows.Count.ToString();
        if (dt != null && dt.Rows.Count > 0)
        {
            chkStaff.DataSource = dt;
            chkStaff.DataTextField = "StaffName";
            chkStaff.DataValueField = "StaffId";
            chkStaff.DataBind();
        }
        foreach (ListItem li in chkStaff.Items)
            li.Attributes.Add("Staffs", li.Value);

        return sb.ToString();
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffName");
            dummy.Columns.Add("StaffID");

            dummy.Rows.Add();
            dgSMSCopy.DataSource = dummy;
            dgSMSCopy.DataBind();
        }
    }

    [WebMethod]
    public static string GetSMSCopy(int pageIndex)
    {
        string query = "[GetSMSCopy_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    

    [WebMethod]
    public static string SaveSMSCopy(string staffID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        sqlstr = "update e_staffinfo set SMSCopy=1 where StaffID in (" + staffID + ")";
        strQueryStatus = utl.ExecuteScalar(sqlstr);
        if (strQueryStatus == "")      
            return "Inserted";     
        else
            return "Insert Failed";

    }
    [WebMethod]
    public static string DeleteSMSCopy(string StaffID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        sqlstr = "update e_staffinfo set SMSCopy=0 where StaffID = '" + StaffID + "'";
        strQueryStatus = utl.ExecuteScalar(sqlstr);
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
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
                    sda.Fill(ds, "SMSCopys");
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
}