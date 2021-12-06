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



public partial class ApproveSMSView : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {

        string Academicyear = "";
        utl = new Utilities();
        if (Session["AcademicID"] != null)
        {
            if (Session["AcademicID"].ToString() != "")
            {
                Academicyear = utl.ExecuteScalar("select top 1 academicid from m_academicyear where   academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
                if (Academicyear != "")
                {
                    hfAcademicyear.Value = Academicyear.ToString();
                }
            }
        }

        Userid = Convert.ToInt32(Session["UserId"]);
        hfUserId.Value = Userid.ToString();
        if (Request.Params["msgType"] != null)
            hfmsgType.Value = Request.Params["msgType"].ToString();
        else
            hfmsgType.Value = "";
        if (Request.Params["ReceiverType"] != null)
            hfReceiverType.Value = Request.Params["ReceiverType"].ToString();
        else
            hfReceiverType.Value = "";
        if (Request.Params["MsgDate"] != null)
            hfMsgDate.Value = Request.Params["MsgDate"].ToString();
        else
            hfMsgDate.Value = "";

        

        if (!IsPostBack)
        {

            BindDummyRow();
        }

    }

    private void BindDummyRow()
    {

        DataTable dummy = new DataTable();
        dummy.Columns.Add("Select");
        dummy.Columns.Add("RegNo");
        dummy.Columns.Add("StudentName");
        dummy.Columns.Add("ReceiverType");
        dummy.Columns.Add("MobileNumber");
        dummy.Columns.Add("Message");
        dummy.Columns.Add("MessageID");
        dummy.Rows.Add();
        dgSMSList.DataSource = dummy;
        dgSMSList.DataBind();

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
                    sda.Fill(ds, "StudentInfos");
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
    public static string DeleteMessage(string MessageID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_DeleteMessage '" + MessageID + "'";
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
        {
            return "Deleted";
        }
        else
        {
            return "Delete Failed";
        }
    }
    [WebMethod]
    public static string BulkDelete(string query)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
        {
            return "Deleted";
        }
        else
        {
            return "Delete Failed";
        }
    }

    [WebMethod]
    public static string GetSMSListByType(string msgType,string ReceiverType, string MsgDate)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "GetSMSListByType '" + msgType + "','" + ReceiverType + "','" + MsgDate + "'";
        return utl.GetDatasetTable(query, "SMSList").GetXml();
    }

}
