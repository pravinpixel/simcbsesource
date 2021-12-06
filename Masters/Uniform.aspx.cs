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
public partial class Uniform : System.Web.UI.Page
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
                BindClass();
                BindDummyRow();
            }
        }
    }

    private void BindClass()
    {
        utl = new Utilities();
        sqlstr = "sp_GetClass";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlClass.DataSource = dt;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();

        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataBind();

        }
    }
  
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("ClassName");
            dummy.Columns.Add("BoysCnt");
            dummy.Columns.Add("GirlsCnt");
            dummy.Columns.Add("BoysRate");
            dummy.Columns.Add("GirlsRate");
            dummy.Columns.Add("TotalRate");
            dummy.Columns.Add("Quantity");
            dummy.Columns.Add("UniformID");

            dummy.Rows.Add();
            dgUniform.DataSource = dummy;
            dgUniform.DataBind();
        }
    }

    [WebMethod]
    public static string GetUniform(int pageIndex)
    {
        string query = "[GetUniform_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@AcademicID", HttpContext.Current.Session["AcademicID"]);
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditUniform(int UniformID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetUniform " + "" + UniformID + "";
        return utl.GetDatasetTable(query, "EditUniform").GetXml();
    }

    [WebMethod]
    public static string SaveUniform(string id, string classid, string boyscnt, string girlscnt, string boysrate, string girlsrate, string totalrate, string qty)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        //if (entrydate != "")
        //{
        //    string[] myDateTimeString = entrydate.Split('/');
        //    entrydate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        //}


        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_Uniforms where academicID=" +HttpContext.Current.Session["AcademicID"] + " and classid='" + classid + "' and Uniformid!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateUniform " + "'" + id + "'," + HttpContext.Current.Session["AcademicID"] + "," + classid + ",'" + boyscnt + "','" + girlscnt + "','" + boysrate + "','" + girlsrate + "','" + totalrate + "','" + qty + "'," + Userid + "";
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
            sqlstr = "select isnull(count(*),0) from m_Uniforms where  academicID=" + HttpContext.Current.Session["AcademicID"] + " and classid='" + classid + "' and isactive=1 ";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertUniform " + "" + HttpContext.Current.Session["AcademicID"] + "," + classid + ",'" + boyscnt + "','" + girlscnt + "','" + boysrate + "','" + girlsrate + "','" + totalrate + "','" + qty + "'," + Userid + "";
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
    public static string DeleteUniform(string UniformID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteUniform " + "" + UniformID + "," + Userid + "");
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
                    sda.Fill(ds, "Uniforms");
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

    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlClass.SelectedIndex != -1 && ddlClass.SelectedValue != "0")
        {

            utl = new Utilities();
            DataSet ds = new DataSet();
            ds = utl.GetDataset("[sp_GetClasswiseStudentCount] " + ddlClass.SelectedValue);
            if (ds!=null && ds.Tables.Count>0)
            {
                if (ds.Tables[0].Rows.Count>0)
                {
                    txtGirlsCnt.Text = ds.Tables[0].Rows[0]["TOTALFEMALE"].ToString();
                    txtBoysCnt.Text = ds.Tables[1].Rows[0]["TOTALMALE"].ToString();
                    calculatetotal();
                }
            }

        }
    }
    protected void txtBoysRate_TextChanged(object sender, EventArgs e)
    {
        ddlClass_SelectedIndexChanged(sender, e);
        calculatetotal();
    }

    private void calculatetotal()
    {
        decimal boyscnt = 0;
        decimal girlscnt = 0;
        decimal boysrate = 0;
        decimal girlsrate = 0;

        if (txtBoysCnt.Text=="")
        {
            txtBoysCnt.Text = "0";
        }
        if (txtGirlsCnt.Text == "")
        {
            txtGirlsCnt.Text = "0";
        }
        if (txtBoysRate.Text == "")
        {
            txtBoysRate.Text = "0";
        }
        if (txtGirlsRate.Text == "")
        {
            txtGirlsRate.Text = "0";
        }
        if (txtQty.Text == "")
        {
            txtQty.Text = "0";
        }
        txtTotalRate.Text = Convert.ToString(Convert.ToDecimal(Convert.ToDecimal(txtBoysCnt.Text) * Convert.ToDecimal(txtBoysRate.Text) + (Convert.ToDecimal(txtGirlsCnt.Text) * Convert.ToDecimal(txtGirlsRate.Text))) * Convert.ToDecimal(txtQty.Text)); 
    }
    protected void txtGirlsRate_TextChanged(object sender, EventArgs e)
    {
        ddlClass_SelectedIndexChanged(sender, e);
        calculatetotal();
    }
    protected void txtBoysCnt_TextChanged(object sender, EventArgs e)
    {
        ddlClass_SelectedIndexChanged(sender, e);
        calculatetotal();
    }
    protected void txtGirlsCnt_TextChanged(object sender, EventArgs e)
    {
        ddlClass_SelectedIndexChanged(sender, e);
        calculatetotal();
    }
    protected void txtQty_TextChanged(object sender, EventArgs e)
    {
        ddlClass_SelectedIndexChanged(sender, e);
        calculatetotal();
    }
}