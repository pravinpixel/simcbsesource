using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.IO;
using System.Xml.Serialization;
using System.Text;
using System.Xml;
using System.Data.OleDb;

public partial class Performance_SalaryEntry : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    public static int AcademicID = 0;
    public static string UserName = string.Empty;
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
            hfUserId.Value = Userid.ToString();
            if (!IsPostBack)
            {

                BindAcademicMonths();
                BindPlaceofwork();
                BindDepartment();
                BindDummyRow();
            }

        }
    }
    private void BindAcademicMonths()
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
                ddlMonth.DataValueField = "shortmonth";
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
    private void BindPlaceofwork()
    {
        Utilities utl = new Utilities();
        string query;
        query = "select  Placeofwork,PlaceofworkID from  m_placeofwork  where IsActive=1 ";

        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);


        if (dt != null && dt.Rows.Count > 0)
        {
            ddlPlaceofwork.DataSource = dt;
            ddlPlaceofwork.DataTextField = "Placeofwork";
            ddlPlaceofwork.DataValueField = "PlaceofworkID";
            ddlPlaceofwork.DataBind();
        }
        else
        {
            ddlPlaceofwork.DataSource = null;
            ddlPlaceofwork.DataBind();
            ddlPlaceofwork.SelectedIndex = -1;
        }

    }

    private void BindDepartment()
    {
        Utilities utl = new Utilities();
        string query;
        query = "select DepartmentId,DepartmentName from m_departments where IsActive=1";

        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "DepartmentName";
            ddlDepartment.DataValueField = "DepartmentId";
            ddlDepartment.DataBind();
        }
        else
        {
            ddlDepartment.DataSource = null;
            ddlDepartment.DataBind();
            ddlDepartment.SelectedIndex = -1;
        }

    }
   
    
    [WebMethod]
    public static string GetMaxsalarys(string query)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        return utl.GetDatasetTable(query, "Salary").GetXml();
    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("EmpCode");
            dummy.Columns.Add("Name");
            dummy.Rows.Add();
            grdList.DataSource = dummy;
            grdList.DataBind();
        }
    }

   
    [WebMethod]
    public static string GetList(string placeofwork, string departmentid, string academicId, string formonth)
    {
        string text = string.Empty;
        text= @"<?xml version=""1.0"" encoding=""utf-16""?>";

         
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "[SP_GetSalaryHeadList] ";
        ds = utl.GetDataset(query);
        
        Utilities utld = new Utilities();
        DataTable dt = new DataTable();
        string qry = "[sp_getStafflistforsalary]  " + academicId + ",'" + placeofwork + "','" + departmentid + "','" + formonth + "'";
        dt = utl.GetDataTable(qry);
        ds.Tables.Add(dt);

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
    public static string SaveSalary(List<SalaryList> salarylist)
    {
        if (salarylist != null && salarylist.Count > 0)
        {
            Utilities utl = new Utilities();
            string query = string.Empty;

            foreach (SalaryList salary in salarylist)
            {
                string[] salaryid = salary.salaryheadid.Split(new[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
                string[] salaries = salary.salary.Split('|');

                int i = 0;
                foreach (string str in salaryid)
                {
                    string replace = salaries[i];
                    if (salaries[i] == string.Empty)
                        replace = "null";

                    string qry = utl.ExecuteScalar("ISStaffSalaryEXISTS " + salary.staffid + ",'" + salary.formonth + "'," + salary.academicId + "," + str + "");

                    if (qry == "1")
                    {
                        query += "UPDATE e_staffsalaryinfo SET Salary=" + replace + ",modifieddate='" + System.DateTime.Now.ToString("yyyy-MM-dd") + "' WHERE SalaryHeadID=" + str + " and StaffID=" + salary.staffid + " and ForMonth='" + salary.formonth + "'  and AcademicID='" + salary.academicId + "'";
                    }
                    else
                    {
                        query += "INSERT INTO [e_staffsalaryinfo]([SalaryHeadID],[StaffID],[ForMonth],[Salary],[AcademicID]" +
          ",[UserId],[IsActive],createddate)VALUES(" + str + "," + salary.staffid + ",'" + salary.formonth + "'" +
          "," + replace + ",'" + salary.academicId + "'," + salary.userId + ",1,'" + System.DateTime.Now.ToString("yyyy-MM-dd") + "')";
                    }
                    i++;

                }
            }
            string err = utl.ExecuteQuery(query);

        }
        return "";
    }

    public class SalaryList
    {
        public string formonth { get; set; }
        public string staffid { get; set; }
        public string salaryheadid { get; set; }
        public string salary { get; set; }
        public string academicId { get; set; }
        public string userId { get; set; }
    }




  
}