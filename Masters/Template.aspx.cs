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

public partial class Template : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.RequestType == "POST")
        {
            if (Request.Files["TemplateImage"] != null && Request.Files["TemplateImage"].ContentLength > 0 && Request.Form["TemplateID"] != null && Request.Form["TemplateID"].Length > 0)
            {

                HttpPostedFile PostedFile = Request.Files["TemplateImage"];
                string id = Request.Form["TemplateID"].ToString();
                string extension = PostedFile.FileName.Substring(PostedFile.FileName.LastIndexOf('.'));
                if (File.Exists(Server.MapPath("~/Masters/Templates/" + id + extension)))
                {
                    File.Delete(Server.MapPath("~/Masters/Templates/" + id + extension));
                }
                PostedFile.SaveAs(Server.MapPath("~/Masters/Templates/" + id + extension));
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
            Userid = Convert.ToInt32(Session["UserId"]);
            if (!IsPostBack)
            {
                BindDummyRow();
                BindCertificateType();
            }
        }
    }
    private void BindCertificateType()
    {
        utl = new Utilities();
        sqlstr = "sp_GetCertificateType";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCertificateType.DataSource = dt;
            ddlCertificateType.DataTextField = "CertificateTypeName";
            ddlCertificateType.DataValueField = "CertificateTypeID";
            ddlCertificateType.DataBind();
        }
        else
        {
            ddlCertificateType.DataSource = null;
            ddlCertificateType.DataBind();
        }
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("CertificateTypeName");
            dummy.Columns.Add("TemplateName");
            dummy.Columns.Add("TemplateID");
            dummy.Rows.Add();
            dgTemplate.DataSource = dummy;
            dgTemplate.DataBind();
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
                    sda.Fill(ds, "Templates");
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
    public static string GetTemplate(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetTemplate_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditTemplate(int TemplateID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetTemplate " + "" + TemplateID + "";
        return utl.GetDatasetTable(query, "EditTemplate").GetXml();
    }

    [WebMethod]
    public static string SaveTemplate(string id, string Templatename, string CertificateTypeid)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_Templates where Templatename='" + Templatename.Replace("'", "''") + "' and CertificateTypeid='" + CertificateTypeid + "'  and Templateid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateTemplate " + "'" + id + "','" + Templatename.Replace("'", "''") + "','" + CertificateTypeid + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);

                if (Templatename != "")
                {
                    string extension = Templatename.Substring(Templatename.LastIndexOf('.'));
                    sqlstr = "update m_Templates set Templatename= convert(varchar,'" + id + extension + "') where Templateid='" + id + "'";
                    strQueryStatus = utl.ExecuteScalar(sqlstr);
                }

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
            sqlstr = "select isnull(count(*),0) from m_Templates where Templatename='" + Templatename.Replace("'", "''") + "' and CertificateTypeid='" + CertificateTypeid + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertTemplate " + "'" + Templatename.Replace("'", "''") + "','" + CertificateTypeid + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
                string tempID = strQueryStatus;
                if (Templatename != "" && tempID != "")
                {
                    string extension = Templatename.Substring(Templatename.LastIndexOf('.'));
                    sqlstr = "update m_Templates set Templatename= convert(varchar,'" + tempID + extension + "') where Templateid='" + tempID + "'";
                    strQueryStatus = utl.ExecuteScalar(sqlstr);
                }
                if (tempID != "")
                    return tempID;
                else
                    return "Insert Failed";
            }
            else
            {
                return "Already Exists, Insert";
            }
        }
    }

    [WebMethod]
    public static string DeleteTemplate(string TemplateID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteTemplate " + "" + TemplateID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }

}