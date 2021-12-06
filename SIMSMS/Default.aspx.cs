using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Configuration;

public partial class _Default : System.Web.UI.Page
{
    Utilities utl = new Utilities();
    protected void Page_Load(object sender, EventArgs e)
    {
        sms_send_list();
    }


    public string sms_send_list()
    {       
        DataSet dt_smsgroup = new DataSet();

        /*
        string sms_list_group = " select MessageType,ReceiverType,COUNT(messageid)  as MessageCount  from o_message where CONVERT(varchar(10),messagedate,103)='05/12/2016' and status='U' group by messagetype,ReceiverType ";

        dt_smsgroup = utl.GetDataset(sms_list_group);

        if (dt_smsgroup != null && dt_smsgroup.Tables.Count > 0 && dt_smsgroup.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dt_smsgroup.Tables[0].Rows.Count; i++)
            {

            }
        }
         * */

        string sms_list_group = " select * from O_Message where 1=1 and [Status]='U' and CONVERT(varchar(10),messagedate,103)=CONVERT(varchar(10),GETDATE(),103)  ";
       //  string sms_list_group = " select * from O_Message where 1=1 and [Status]='U' ";
        dt_smsgroup = utl.GetDataset(sms_list_group);
       
        if (dt_smsgroup != null && dt_smsgroup.Tables.Count > 0 && dt_smsgroup.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dt_smsgroup.Tables[0].Rows.Count; i++)
            {
                string RegNo = dt_smsgroup.Tables[0].Rows[i]["RegNo"].ToString();
                string cusmobile = dt_smsgroup.Tables[0].Rows[i]["MobileNumber"].ToString();
                string username = ConfigurationManager.AppSettings["sms_username"].ToString();
                string password = ConfigurationManager.AppSettings["sms_password"].ToString();
                string sender_id = ConfigurationManager.AppSettings["sms_senderid"].ToString();
                string message = dt_smsgroup.Tables[0].Rows[i]["Message"].ToString();
                string securitykey = ConfigurationManager.AppSettings["securitykey"].ToString();
                cusmobile = "9786188270";
                //string createdURL = "http://www.1message.com/services/sendmessage.aspx?account=" + username + "&password=" + password + "&sender=" + sender_id + "&message=" + message + "&mobile=" + cusmobile + "";
                string createdURL = "http://1message.com/apis/api/quicksendmessage?securitykey=" + securitykey + "&mobile=" + cusmobile + "&message=" + Server.UrlEncode(message) + "&sender=" + sender_id + "";

                System.Net.HttpWebRequest myReq = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(createdURL);
                System.Net.HttpWebResponse myResp = (System.Net.HttpWebResponse)myReq.GetResponse();
                System.IO.StreamReader respStreamReader = new System.IO.StreamReader(myResp.GetResponseStream());
                string responseString = respStreamReader.ReadToEnd();
                respStreamReader.Close();
                myResp.Close();   

                //update o_message table if message send
                string str_update_qry = "update O_Message set [Status]='A', ModifiedDate=GETDATE() where MessageId='" + dt_smsgroup.Tables[0].Rows[i]["MessageId"].ToString() + "'  ";
                utl.ExecuteQuery(str_update_qry);
            }
        }
        

        return "success";
    }


    /*
    public class MessageList
    {
        public string MessageId { get; set; }       
    }



    [WebMethod]
    public static List<MessageList> get_sms_to_list_json()
    {
        List<MessageList> Message_ids = new List<MessageList>();

       // return customers;

    }


    [WebMethod]
    public static string sms_send_to1message()
    {
        Page page = HttpContext.Current.Handler as Page;
        Label lbl_totsms_cnt1 = (Label)page.FindControl("lbl_totsms_cnt");
        Label lbl_sentsms_cnt1 = (Label)page.FindControl("lbl_sentsms_cnt");

        lbl_totsms_cnt1.Text = "10";

        for (int i = 0; i < 10; i++)
        {
            lbl_sentsms_cnt1.Text = i.ToString();
        }

        return "succ";
    }
      
    */


}