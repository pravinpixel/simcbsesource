using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;

public partial class SMS_OldBulkSMS : System.Web.UI.Page
{
    string sqlquery = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindClass();
            BindTemplate();
            BindSMSCopyTo();
        }
    }

    private void BindClass()
    {
        string query = "[sp_GetClass]";

        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            chkClass.DataSource = dt;
            chkClass.DataTextField = "ClassName";
            chkClass.DataValueField = "ClassId";
            chkClass.DataBind();
        }
        else
        {
            chkClass.DataSource = null;
            chkClass.DataBind();
        }
        foreach (ListItem li in chkClass.Items)
            li.Attributes.Add("Classes", li.Value);
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
    private void BindSMSCopyTo()
    {
        string query = "sp_GetSMSCopy";

        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);
        if (dt != null && dt.Rows.Count > 0)
        {
            chkSmsCopy.DataSource = dt;
            chkSmsCopy.DataTextField = "StaffName";
            chkSmsCopy.DataValueField = "StaffID";
            chkSmsCopy.DataBind();
        }
        else
        {
            chkSmsCopy.DataSource = null;
            chkSmsCopy.DataBind();
        }
        foreach (ListItem li in chkSmsCopy.Items)
            li.Attributes.Add("Staffs", li.Value);
    }

    [WebMethod]
    public static string GetMessageTemplate(int MessTempID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetMessageTemplate " + "" + MessTempID + "";
        return utl.GetDatasetTable(query, "GetMessageTemplate").GetXml();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet dsGet = new DataSet();
            Utilities utl = new Utilities();
            string sendTO = ddlSendTo.Text;
            string query;
            string phNumber;
            string EXECquery;

            foreach (ListItem li in chkClass.Items)
            {
                if (li.Selected == true)
                {
                    sqlquery = "[sp_GetOldSMSStudentBySectionID] " + li.Value + ",''";
                    dsGet = utl.GetDataset(sqlquery);


                    if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
                    {
                        for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                        {
                            switch (sendTO)
                            {
                                case "P":
                                    query = "select case when priority=1 then FatherCell when priority=2 then mothercell when priority=3 then GPhno1 else FatherCell end as  Priority,FatherCell,MotherCell,GPhno1 from s_studentinfo where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                    phNumber = utl.ExecuteScalar(query);

                                    EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + phNumber + "','" + txtMessage.Text.Replace("'", "''") + "','Bulk','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(Session["UserId"].ToString()) + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "')";
                                    utl.ExecuteQuery(EXECquery);
                                    break;

                                case "F":
                                    query = "select FatherCell from s_studentinfo where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                    phNumber = utl.ExecuteScalar(query);

                                    EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + phNumber + "','" + txtMessage.Text.Replace("'", "''") + "','Bulk','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(Session["UserId"].ToString()) + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "')";
                                    utl.ExecuteQuery(EXECquery);
                                    break;

                                case "M":
                                    query = "select mothercell from s_studentinfo where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                    phNumber = utl.ExecuteScalar(query);

                                    EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + phNumber + "','" + txtMessage.Text.Replace("'", "''") + "','Bulk','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(Session["UserId"].ToString()) + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "')";
                                    utl.ExecuteQuery(EXECquery);
                                    break;

                                case "G":
                                    query = "select GPhno1 from s_studentinfo where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "' and AcademicYear='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
                                    phNumber = utl.ExecuteScalar(query);

                                    EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + phNumber + "','" + txtMessage.Text.Replace("'", "''") + "','Bulk','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(Session["UserId"].ToString()) + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "')";
                                    utl.ExecuteQuery(EXECquery);
                                    break;
                            }
                        }
                    }
                }
            }


            //SMS Copy To Staff

            if (dsGet.Tables[0].Rows.Count > 0)
            {
                foreach (ListItem li_staff in chkSmsCopy.Items)
                {
                    if (li_staff.Selected == true)
                    {
                        query = "select MobileNo from e_staffinfo where StaffId=" + li_staff.Value + "";
                        phNumber = utl.ExecuteScalar(query);

                        EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + phNumber + "','" + txtMessage.Text + "','Bulk','SMSCopy','U','" + li_staff.Value + "','" + Convert.ToInt32(Session["UserId"].ToString()) + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "')";
                        utl.ExecuteQuery(EXECquery);
                    }
                }

                ClientScript.RegisterStartupScript(this.GetType(), "", "<Script>SMS();</script>");
            }

        }

        catch (Exception ex)
        {
            Response.Write("<script>alert('" + ex.Message + "')</script>");
        }

    }

}