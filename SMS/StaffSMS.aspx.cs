using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;

public partial class StaffSMS : System.Web.UI.Page
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
            BndPlaceofwork();
            BindDummyRow();
        }
    }

    private void BndPlaceofwork()
    {
        Utilities utl = new Utilities();
        string query;
        query = "select  Placeofwork,PlaceofworkID from  m_placeofwork  where IsActive=1 ";

        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);


        if (dt != null && dt.Rows.Count > 0)
        {
            ddlPlace.DataSource = dt;
            ddlPlace.DataTextField = "Placeofwork";
            ddlPlace.DataValueField = "PlaceofworkID";
            ddlPlace.DataBind();
        }
        else
        {
            ddlPlace.DataSource = null;
            ddlPlace.DataBind();
            ddlPlace.SelectedIndex = -1;
        }
      ddlPlace.Items.Insert(0, "---Select---");
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
            dummy.Columns.Add("EmpCode");
            dummy.Columns.Add("StaffName");
            dummy.Columns.Add("MobileNo");
            dummy.Columns.Add("DesignationName");
            dummy.Rows.Add();
            dgStaffList.DataSource = dummy;
            dgStaffList.DataBind();
        }
    }
   
   
    [WebMethod]
    public static string GetStaffs(string place)
    {
        
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();

        string query = "[GetStaffSMSInfo] '" + place + "'";
        return utl.GetDatasetTable(query, "Staff").GetXml();
    }

    [WebMethod]
    public static string SaveSMS(string stafflist, string msg, string userid)
    {
        DataSet dsGet1 = new DataSet();
        Utilities utl = new Utilities();
        string sqlquery1;
        string EXECquery;

        sqlquery1 = "select Empcode,MobileNo from e_staffinfo where Empcode IN(" + stafflist + ")";
        dsGet1 = utl.GetDataset(sqlquery1);
        if (dsGet1 != null && dsGet1.Tables.Count > 0 && dsGet1.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsGet1.Tables[0].Rows.Count; i++)
            {
                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + dsGet1.Tables[0].Rows[i]["MobileNo"].ToString() + "','" + msg + "','Staff','Staff','U','" + dsGet1.Tables[0].Rows[i]["Empcode"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";

                utl.ExecuteQuery(EXECquery);
            }
        }

        return "success";
    }
    
}