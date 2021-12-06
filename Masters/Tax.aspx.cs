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

public partial class Tax : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
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
                BindDummyRow();
                BindFeeHead();
            }
        }
    }
    private void BindFeeHead()
    {
        utl = new Utilities();
        sqlstr = "sp_GetTaxFeeshead";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlFeeHead.DataSource = dt;
            ddlFeeHead.DataTextField = "FeesHeadName";
            ddlFeeHead.DataValueField = "FeesHeadID";
            ddlFeeHead.DataBind();
        }
        else
        {
            ddlFeeHead.DataSource = null;
            ddlFeeHead.DataBind();
        }
        ddlFeeHead.Items.Insert(0,"Select");
        ddlFeeHead.SelectedIndex = 0;

    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("FeesHeadName");
            dummy.Columns.Add("TaxName");
            dummy.Columns.Add("Percentage");
            dummy.Columns.Add("TaxID");

            dummy.Rows.Add();
            dgTax.DataSource = dummy;
            dgTax.DataBind();
        }
    }

    [WebMethod]
    public static string GetTax(int pageIndex)
    {
        string query = "[GetTax_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@AcademicID", HttpContext.Current.Session["AcademicID"]);
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditTax(int TaxID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetTaxMaster " + "" + TaxID + "";
        return utl.GetDatasetTable(query, "EditTax").GetXml();
    }

    [WebMethod]
    public static string SaveTax(string id, string feeheadid, string name, string percentage)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_Tax where academicID=" + HttpContext.Current.Session["AcademicID"] + " and feeheadid='" + feeheadid.Replace("'", "''") + "' and Taxname='" + name.Replace("'", "''") + "' and Taxid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateTax " + "'" + id + "','" + feeheadid + "','" + name + "','" + percentage + "'," + HttpContext.Current.Session["AcademicID"] + "," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
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
            sqlstr = "select isnull(count(*),0) from m_Tax where  academicID=" + HttpContext.Current.Session["AcademicID"] + " and feeheadid='" + feeheadid.Replace("'", "''") + "' and Taxname='" + name.Replace("'", "''") + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {

                sqlstr = "sp_InsertTax " + "'" + feeheadid + "','" + name + "','" + percentage + "'," + HttpContext.Current.Session["AcademicID"] + "," + Userid + "";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Inserted";
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
    public static string DeleteTax(string TaxID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteTax " + "" + TaxID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }
    public static DataSet GetData(SqlCommand cmd, int pageIndex)
    {

        string strConnString = ConfigurationManager.AppSettings["SIMConnection"].ToString();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                sda.SelectCommand = cmd;
                using (DataSet ds = new DataSet())
                {
                    sda.Fill(ds, "Taxs");
                    DataTable dt = new DataTable("Pager");
                    dt.Columns.Add("PageIndex");
                    dt.Columns.Add("PageSize");
                    dt.Columns.Add("RecordCount");
                    dt.Columns.Add("AcademicID");
                    dt.Rows.Add();
                    dt.Rows[0]["PageIndex"] = pageIndex;
                    dt.Rows[0]["PageSize"] = PageSize;
                    dt.Rows[0]["RecordCount"] = cmd.Parameters["@RecordCount"].Value;
                    dt.Rows[0]["AcademicID"] = HttpContext.Current.Session["AcademicID"];
                    ds.Tables.Add(dt);
                    return ds;
                }
            }
        }
    }
}