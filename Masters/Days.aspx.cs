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
using System.Text;
using System.IO;
using System.Xml.Serialization;

public partial class Days : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    public static int AcademicID = 0;
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
            AcademicID = Convert.ToInt32(Session["AcademicID"]);
            if (!IsPostBack)
            {
                BindDummyRow();
                BindClass();
                BindMonths();
               // BindDays();
            }
        }
    }
    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("sp_GetClass");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass.DataSource = dsClass;
            ddlClass.DataTextField = "ClassName";
            ddlClass.DataValueField = "ClassID";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataTextField = "";
            ddlClass.DataValueField = "";
            ddlClass.DataBind();
        }
        ddlClass.Items.Insert(0, "---Select---");
    }

    //protected string BindDays()
    //{
    //    utl = new Utilities();
    //    DataTable dt = new DataTable();
    //    StringBuilder sb = new StringBuilder();

    //    for (int i = 1; i <= 31; i++)
    //    {
    //        string strDate = "";
    //        if (ddlMonth.SelectedValue!="---Select---")
    //        {
    //             strDate = "'" + Convert.ToString(System.DateTime.Now.Year) + "-" + Convert.ToString(ddlMonth.SelectedValue) + "-" + Convert.ToString(i) + "'";
    //             sqlstr = "select datename(WEEKDAY," + strDate + ")";
    //             string Weekday = utl.ExecuteScalar(sqlstr);
    //             if (Weekday == "Sunday")
    //             {
    //                 sb.Append("<div class=\"checkbox2\"><input id=\"rd_" + i.ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkDays\" name=\"chkDays\" value=\"" + i.ToString() + "\" />");
    //                 sb.Append("<label name=\"lblSubjects\" id=\"lbl_rd_" + i.ToString() + "\" style=\"border:0px;color:Red;font-weight:bold\" for=\"rd_" + i.ToString() + "\">" + i.ToString() + "</label></div>");
    //             }
    //             else
    //             {
    //                 sb.Append("<div class=\"checkbox2\"><input id=\"rd_" + i.ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkDays\" name=\"chkDays\" value=\"" + i.ToString() + "\" />");
    //                 sb.Append("<label name=\"lblSubjects\" id=\"lbl_rd_" + i.ToString() + "\" style=\"border:0px;color:black;font-weight:bold\" for=\"rd_" + i.ToString() + "\">" + i.ToString() + "</label></div>");
    //             }
    //        }
          
    //    }
    //    return sb.ToString();

    //}
    [WebMethod]
    public static string NoofBindDays(string MonthID)
    {
        Utilities utl = new Utilities();
        StringBuilder sb = new StringBuilder();

        for (int i = 1; i <= 31; i++)
        {
            string strDate = "";
            string sqlstr = "select DATEPART(mm, StartDate) as sm,DATEPART(mm, EndDate) as em from m_academicyear where AcademicId='" + AcademicID + "' and IsActive=1";
             DataTable dt1=new DataTable();
            dt1=utl.GetDataTable(sqlstr);
            int stdmnth=0;
            int endmnth=0;
            if (dt1.Rows.Count > 0)
            {
                stdmnth = Convert.ToInt32(dt1.Rows[0]["sm"].ToString());
                endmnth = Convert.ToInt32(dt1.Rows[0]["em"].ToString());
            }
            if (Convert.ToInt32(MonthID) >= stdmnth)
            {
                sqlstr = "select year(startdate) from m_academicyear where AcademicId='" + AcademicID + "'";
            }
            else if (Convert.ToInt32(MonthID) <= endmnth)
            {
                sqlstr = "select year(enddate) from m_academicyear where AcademicId='" + AcademicID + "'";
            }
            
            string StDate = utl.ExecuteScalar(sqlstr);
            strDate = "'" + Convert.ToString(StDate) + "-" + Convert.ToString(MonthID) + "-" + Convert.ToString(i) + "'";
              sqlstr = "select datename(WEEKDAY," + strDate + ")";
                string Weekday = utl.ExecuteScalar(sqlstr);
                if (Weekday == "Sunday")
                {
                    sb.Append("<div class=\"checkbox2\"><input id=\"rd_" + i.ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkDays\" name=\"chkDays\" value=\"" + i.ToString() + "\" />");
                    sb.Append("<label name=\"lblSubjects\" id=\"lbl_rd_" + i.ToString() + "\" style=\"border:0px;color:Red;font-weight:bold\" for=\"rd_" + i.ToString() + "\">" + i.ToString() + "</label></div>");
                }
                else
                {
                    sb.Append("<div class=\"checkbox2\"><input id=\"rd_" + i.ToString() + "\" style=\"border:0px;\" type=\"checkbox\" class=\"chkDays\" name=\"chkDays\" value=\"" + i.ToString() + "\" />");
                    sb.Append("<label name=\"lblSubjects\" id=\"lbl_rd_" + i.ToString() + "\" style=\"border:0px;color:black;font-weight:bold\" for=\"rd_" + i.ToString() + "\">" + i.ToString() + "</label></div>");
                }
            

        }
        DataSet ds = new DataSet();
        DataTable dt = new DataTable("FirstContent");
        dt.Columns.Add(new DataColumn("firsthtml", typeof(string)));

        DataRow dr = dt.NewRow();
        dr["firsthtml"] = sb.ToString();
        dt.Rows.Add(dr);
        ds.Tables.Add(dt);
        return ds.GetXml();

    }
     
    private void BindMonths()
    {
        utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable("select top 1 convert(varchar,startdate,121)startdate,convert(Varchar,enddate,121)enddate from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
        if (dt.Rows.Count > 0)
        {
            DataTable dtmon = new DataTable();
            dtmon = utl.GetDataTable("exec sp_getacademicmonths '" + dt.Rows[0]["startdate"].ToString() + "','" + dt.Rows[0]["enddate"].ToString() + "'");
            if (dtmon != null && dtmon.Rows.Count > 0)
            {
                ddlMonth.DataSource = dtmon;
                ddlMonth.DataTextField = "fullmonth";
                ddlMonth.DataValueField = "MonthID";
                ddlMonth.DataBind();
            }
            else
            {
                ddlMonth.DataSource = null;
                ddlMonth.DataTextField = "";
                ddlMonth.DataValueField = "";
                ddlMonth.DataBind();
            }
            ddlMonth.Items.Insert(0, new ListItem("---Select---", ""));
        }        
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("Class");
            dummy.Columns.Add("MonthName");
            dummy.Columns.Add("NoofDays");
            dummy.Columns.Add("DaysID");
            dummy.Rows.Add();
            dgDays.DataSource = dummy;
            dgDays.DataBind();
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
                    sda.Fill(ds, "Days");
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
    public static string GetDays(int pageIndex)
    {
        Utilities utl = new Utilities();
        string query = "[GetDays_Pager]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.AddWithValue("@AcademicID", AcademicID);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return GetData(cmd, pageIndex).GetXml();
    }

    [WebMethod]
    public static string EditDays(int DaysID)
    {
        
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetDays " + DaysID ;
        return utl.GetDatasetTable(query, "EditDays").GetXml();
    }
    [WebMethod]
    public static string GetDaysList(string ClassID,string MonthID)
    {  
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetDaysList "  + ClassID + ","  + MonthID + "," + AcademicID;
        return utl.GetDatasetTable(query, "DaysList").GetXml();
    }
    [WebMethod]
    public static string SaveDays(string id, string ClassID, string Days, string MonthID, string DayValue)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from m_daysinmonths where ClassID= '" + ClassID + "' and MonthID='" + MonthID + "'  and AcademicID='" + AcademicID + "'  and DaysID!='" + id + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_UpdateDays " + "'" + id + "','" + Days.Replace("'", "''") + "','" + ClassID + "','" + MonthID + "','" + AcademicID + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                {
                    sqlstr = "delete from m_dayslist where ClassID= '" + ClassID + "' and  MonthID='" + MonthID + "' and AcademicID='" + AcademicID + "'";
                    utl.ExecuteQuery(sqlstr);
                    string[] str = new string[31];
                    str = DayValue.Split(',');
                    for (int i = 0; i < str.Length; i++)
                    {
                        if (str[i] != "")
                        {  
                            sqlstr = "insert into m_dayslist(classid,monthid,dayvalue,academicid,isactive,userid)values('" + ClassID + "','" + MonthID + "','" + str[i].ToString() + "','" + AcademicID + "',1," + Userid + ")";
                            utl.ExecuteQuery(sqlstr);
                        }
                    }
                    return "Updated";
                }
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
            sqlstr = "select isnull(count(*),0) from m_daysinmonths where ClassID= '" + ClassID + "' and MonthID='" + MonthID + "' and AcademicID='" + AcademicID + "'  and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "0")
            {
                sqlstr = "sp_InsertDays " + "'" + Days.Replace("'", "''") + "','" + ClassID + "','" + MonthID + "','" + AcademicID + "','" + Userid + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                {
                    sqlstr = "delete from m_dayslist where ClassID= '" + ClassID + "' and monthid='" + MonthID + "' and AcademicID='" + AcademicID + "'";
                    utl.ExecuteQuery(sqlstr);
                    string[] str = new string[31];
                    str = DayValue.Split(',');
                    for (int i = 0; i < str.Length; i++)
                    {
                        if (str[i] != "")
                        {
                            sqlstr = "insert into m_dayslist(classid,monthid,dayvalue,academicid,isactive,userid)values('" + ClassID + "','" + MonthID + "','" + str[i].ToString() + "','" + AcademicID + "',1," + Userid + ")";
                            utl.ExecuteQuery(sqlstr);
                        }
                    }
                    return "Inserted";
                }
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
    public static string DeleteDays(string DaysID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteScalar("sp_DeleteDays " + "" + DaysID + ",'" + Userid + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return strQueryStatus;
    }


    protected void ddlMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        //BindDays();
    }
}