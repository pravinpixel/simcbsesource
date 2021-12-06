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

public partial class SMS_ApproveSMS : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            BindDummyRow();
            txtDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("MessageType");
            dummy.Columns.Add("ReceiverType");
            dummy.Columns.Add("MessageCount");
            dummy.Rows.Add();
            dgSMSList.DataSource = dummy;
            dgSMSList.DataBind();
        }
    }
    [WebMethod]
    public static string GetMessageList(string MessageDate)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "GetUnApprovedSMSList '" + MessageDate + "'";
        return utl.GetDatasetTable(query, "SMS").GetXml();
    }
    [WebMethod]
    public static string ViewList(string msgType, string ReceiverType, string MsgDate)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "GetSMSListByType '" + msgType + "','" + ReceiverType + "','" + MsgDate + "'";
        return utl.GetDatasetTable(query, "SMSList").GetXml();
    }

    [WebMethod]
    public static string SendSMS(string MsgDate)
    {
        //Utilities utl = new Utilities();
        //DataSet ds = new DataSet();
        //string query = "GetSMSListByType '','','" + MsgDate + "'";
        //DataTable dt = new DataTable();
        //dt = utl.GetDataTable(query);
        //if (dt != null && dt.Rows.Count > 0)
        //{
        //    for (int i = 0; i < dt.Rows.Count; i++)
        //    {
        //        query = "Insert into MessageQ(MobileNumber,Message,MessageTime) Values('" + dt.Rows[i]["MobileNumber"].ToString() + "','" + dt.Rows[i]["Message"].ToString().Replace("'","''") + "','" + System.DateTime.Now.ToString("HH:mm:ss") + "')";
        //        utl.ExecuteSMSQuery(query);
        //        query = "update o_message set Status='A' where regno='" + dt.Rows[i]["RegNo"].ToString() + "' and convert(varchar,MessageDate,103)='" + MsgDate + "' and MobileNumber='" + dt.Rows[i]["MobileNumber"].ToString() + "'";
        //        utl.ExecuteQuery(query);
        //    }
        //}

        return "SMS Sent";

    }
}