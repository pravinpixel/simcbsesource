using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Globalization;
using System.IO;
using System.Text;
using System.Xml.Serialization;

public partial class BirthdaySMS : System.Web.UI.Page
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
            dummy.Columns.Add("RegNo");
            dummy.Columns.Add("StudentName");

            dummy.Rows.Add();
            dgStudentList.DataSource = dummy;
            dgStudentList.DataBind();


            dummy = new DataTable();
            dummy.Columns.Add("AddPrm");
            dummy.Columns.Add("Empcode");
            dummy.Columns.Add("StaffName");

            dummy.Rows.Add();
            dgStaffList.DataSource = dummy;
            dgStaffList.DataBind();
        }
    }


    [WebMethod]
    public static string GetList()
    {
        string text = @"<?xml version=""1.0"" encoding=""utf-16""?>";
        string date = System.DateTime.Now.ToString("dd/MM/yyyy");
        Utilities utl = new Utilities();
        string query = string.Empty;
        string formattedDate = string.Empty;
        string[] formats = { "dd/MM/yyyy" };
        formattedDate = DateTime.ParseExact(date, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        query = "[SP_GETBIRTHDAYLIST] '" + formattedDate + "'";
        DataSet ds = new DataSet();
        ds = utl.GetDataset(query);
        System.Xml.XmlReader xr = new System.Xml.XmlTextReader(new System.IO.StringReader(text));
        //ds.ReadXml(xr);
        var xmlString = ToXml(ds);
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
    public static string SaveSMS(string studlist, string sendto, string msg, string userid, string stafflist)
    {
        string sqlquery;
        string phNumber;
        string EXECquery;
        string query;

        DataSet dsGet = new DataSet();
        Utilities utl = new Utilities();

        string sqlquery1;
        DataSet dsGet1 = new DataSet();

        sqlquery = "select * from vw_getstudent where RegNo IN(" + studlist + ")";
        dsGet = utl.GetDataset(sqlquery);
        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {
                switch (sendto)
                {
                    case "P":
                        query = "select case when priority=1 then FatherCell when priority=2 then mothercell when priority=3 then gphno else FatherCell end as                                 Priority,FatherCell,MotherCell,GPhno from vw_getstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                        phNumber = utl.ExecuteScalar(query);

                        EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Birthday','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                        utl.ExecuteQuery(EXECquery);
                        break;

                    case "F":
                        query = "select FatherCell from vw_getstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                        phNumber = utl.ExecuteScalar(query);

                        EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate)values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Birthday','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                        utl.ExecuteQuery(EXECquery);
                        break;

                    case "M":
                        query = "select mothercell from vw_getstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                        phNumber = utl.ExecuteScalar(query);

                        EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Birthday','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                        utl.ExecuteQuery(EXECquery);
                        break;

                    case "G":
                        query = "select GPhno from vw_getstudent where RegNo='" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                        phNumber = utl.ExecuteScalar(query);

                        EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + phNumber + "','" + msg + "','Birthday','Student','U','" + dsGet.Tables[0].Rows[i]["RegNo"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";
                        utl.ExecuteQuery(EXECquery);
                        break;
                }
            }
        }

        //SMS Copy To Staff
        sqlquery1 = "select StaffId,MobileNo from e_staffinfo where StaffId IN(" + stafflist + ")";
        dsGet1 = utl.GetDataset(sqlquery1);
        if (dsGet1 != null && dsGet1.Tables.Count > 0 && dsGet1.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsGet1.Tables[0].Rows.Count; i++)
            {
                EXECquery = "insert into O_message(MessageDate,MobileNumber,Message,MessageType,ReceiverType,Status,Regno,Userid,createddate,modifiedDate) values('" + DateTime.Now + "','" + dsGet1.Tables[0].Rows[i]["MobileNo"].ToString() + "','" + msg + "','Birthday','Staff','U','" + dsGet1.Tables[0].Rows[i]["StaffId"].ToString() + "','" + Convert.ToInt32(userid) + "','" + DateTime.Now + "','" + DateTime.Now + "')";

                utl.ExecuteQuery(EXECquery);
            }
        }

        return "success";
    }



}