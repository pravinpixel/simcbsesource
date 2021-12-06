using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;

public partial class WellWisherSMS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            BindTemplate();
            BindDummyRow();
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
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("AddPrm");
            dummy.Columns.Add("WellWisherID");
            dummy.Columns.Add("WellWisherName");
            dummy.Columns.Add("MobileNo");
            dummy.Rows.Add();
            dgWellWisherList.DataSource = dummy;
            dgWellWisherList.DataBind();
        }
    }
   
   
    [WebMethod]
    public static string GetWellWishers(string AddressType)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();

        string query = "[GetWellWisherinfo] '" + AddressType  + "'";
        return utl.GetDatasetTable(query, "WellWisher").GetXml();
        
    }


    [WebMethod]
    public static string SaveSMS(string stafflist, string msg, string userid)
    {
        DataSet dsGet1 = new DataSet();
        Utilities utl = new Utilities();
        string sqlquery1;
        string EXECquery;

        sqlquery1 = "select AddressID,MobileNo1 as MobileNo from a_addressbook where AddressID IN(" + stafflist + ")";
        dsGet1 = utl.GetDataset(sqlquery1);
        if (dsGet1 != null && dsGet1.Tables.Count > 0 && dsGet1.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsGet1.Tables[0].Rows.Count; i++)
            {
                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + dsGet1.Tables[0].Rows[i]["MobileNo"].ToString() + "','" + msg + "','Well-Wisher','Well-Wisher','U','" + dsGet1.Tables[0].Rows[i]["AddressID"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";

                utl.ExecuteQuery(EXECquery);
            }
        }

        return "success";
    }
    
}