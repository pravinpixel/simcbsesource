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

public partial class StudentInfoView : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
         
            string Academicyear = "";
            utl = new Utilities();
            if (Session["AcademicID"].ToString() != "")
            {
                Academicyear = utl.ExecuteScalar("select top 1 academicid from m_academicyear where   academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
                if (Academicyear != "")
                {
                    hfAcademicyear.Value = Academicyear.ToString();
                }
            }
            Userid = Convert.ToInt32(Session["UserId"]);
            hfUserId.Value = Userid.ToString();
            if (Request.Params["StudentID"] != null)
                hfStudentInfoID.Value = Request.Params["StudentID"].ToString();

            else
                hfStudentInfoID.Value = "";

            if (!IsPostBack)
            {

                BindDummyRow();
                BindGridView();
                BindHostelDetails();
            }
        
    }

    private DataTable GetDataTable()
    {

        Utilities utl = new Utilities();
        DataSet dts = new DataSet();
        DataTable dt = new DataTable();
        DataTable dta = new DataTable();
        if (hfStudentInfoID.Value == "")
        {
            hfStudentInfoID.Value = "0";
        }
        dt = utl.GetDataTable("sp_getstudentinfo " + hfStudentInfoID.Value);
        if (dt.Rows.Count > 0)
        {
            dta = utl.GetDataTable("sp_GetConcessionInfo " + hfStudentInfoID.Value + "," + Session["AcademicID"] + "");
            if (dta.Rows.Count > 0)
            {
                dt = utl.GetDataTable("sp_GetConcessionInfo " + hfStudentInfoID.Value + "," + Session["AcademicID"] + "");

            }
            else
            {
                dt = utl.GetDataTable("sp_getfeesAmount " + dt.Rows[0]["ClassID"] + ",'" + dt.Rows[0]["Active"] + "',''," + Session["AcademicID"] + "");
                dt.Columns.Add("ConcessionAmount", typeof(string));
            }

        }


        return dt;
    }
    private DataTable GetHostelFees()
    {


        Utilities utl = new Utilities();
        DataSet dts = new DataSet();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable("sp_getstudentinfo " + hfStudentInfoID.Value);
        if (dt.Rows.Count > 0)
        {
            dt = utl.GetDataTable("sp_getfeesAmount " + dt.Rows[0]["ClassID"] + ",'" + dt.Rows[0]["Active"] + "','H'," + Session["AcademicID"] + "");
        }


        return dt;
    }
    
    [WebMethod]
    public static string GetFeesAmount(string StudentInfoID)
    {
        Utilities utl = new Utilities();
        DataSet dts = new DataSet();
        DataTable dt = new DataTable();
        string query = "";
        dt = utl.GetDataTable("sp_getstudentinfo " + StudentInfoID);
        if (dt.Rows.Count > 0)
        {
            query = "sp_getfeesAmount '" + dt.Rows[0]["ClassID"] + "," + "''" + "," + "''" + "," + HttpContext.Current.Session["AcademicID"] + "";

        }
        return utl.GetDatasetTable(query, "FeesAmt").GetXml();

    }

    [WebMethod]
    public static string GetStudentBySection(string Class, string Section)
    {

        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStudentBySection '" + Class + "','" + Section + "'";
        return utl.GetDatasetTable(query, "StudentBySection").GetXml();

    }

    private void BindHostelDetails()
    {
        var dti = GetHostelFees();
        //dti.Columns.Remove("userid");
        dgHostel.Columns.Clear();
        dgHostel.ShowFooter = true;

        var boundField = new BoundField();
        boundField.DataField = dti.Columns[1].ColumnName;
        boundField.HeaderText = dti.Columns[1].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        dgHostel.Columns.Add(boundField);
        boundField.Visible = false;

        boundField = new BoundField();
        boundField.DataField = dti.Columns[3].ColumnName;
        boundField.HeaderText = dti.Columns[3].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        dgHostel.Columns.Add(boundField);


        boundField = new BoundField();
        boundField.DataField = dti.Columns[4].ColumnName;
        boundField.HeaderText = dti.Columns[4].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        dgHostel.Columns.Add(boundField);


        boundField = new BoundField();
        boundField.DataField = dti.Columns[5].ColumnName;
        boundField.HeaderText = dti.Columns[5].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderText = "Actual Amt";
        boundField.HeaderStyle.CssClass = "sorting_mod";
        dgHostel.Columns.Add(boundField);


        dgHostel.DataSource = dti;
        dgHostel.DataBind();



    }

    private void BindGridView()
    {

        var dti = GetDataTable();
        //dti.Columns.Remove("userid");
        GridView1.Columns.Clear();
        GridView1.ShowFooter = true;

        var boundField = new BoundField();
        boundField.DataField = dti.Columns[0].ColumnName;
        boundField.HeaderText = "StudConcessID";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "StudConcessID";
        boundField.ItemStyle.CssClass = "StudConcessID";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Columns[1].ColumnName;
        boundField.HeaderText = "FeesHeadID";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "FeesHeadID";
        boundField.ItemStyle.CssClass = "FeesHeadID";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Columns[3].ColumnName;
        boundField.HeaderText = dti.Columns[3].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "FeesHeadName";
        GridView1.Columns.Add(boundField);


        boundField = new BoundField();
        boundField.DataField = dti.Columns[4].ColumnName;
        boundField.HeaderText = dti.Columns[4].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "ForMonth";
        GridView1.Columns.Add(boundField);


        boundField = new BoundField();
        boundField.DataField = dti.Columns[5].ColumnName;
        boundField.HeaderText = dti.Columns[5].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderText = "Actual Amt/Month";
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = dti.Columns[5].ColumnName;
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Columns[6].ColumnName;
        boundField.HeaderText = dti.Columns[6].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderText = "Concession Amt";
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = dti.Columns[6].ColumnName;
        GridView1.Columns.Add(boundField);

        GridView1.DataSource = dti;
        GridView1.DataBind();      


    }


    private void BindDummyRow()
    {

        DataTable dummy = new DataTable();
        dummy.Columns.Add("Relationship");
        dummy.Columns.Add("Name");
        dummy.Columns.Add("Qualification");
        dummy.Columns.Add("Occupation");
        dummy.Columns.Add("Income");
        dummy.Columns.Add("Address");
        dummy.Columns.Add("Email");
        dummy.Columns.Add("Mobile");
        dummy.Columns.Add("StudentId");
        dummy.Rows.Add();
        dgRelationship.DataSource = dummy;
        dgRelationship.DataBind();


        dummy = new DataTable();
        dummy.Columns.Add("SlNo");
        dummy.Columns.Add("RegNo");
        dummy.Columns.Add("Relation");
        dummy.Columns.Add("Name");
        dummy.Columns.Add("Class");
        dummy.Columns.Add("Section");
        dummy.Columns.Add("StudRelId");
        dummy.Rows.Add();
        dgBroSis.DataSource = dummy;
        dgBroSis.DataBind();


        dummy = new DataTable();
        dummy.Columns.Add("SlNo");
        dummy.Columns.Add("RegNo");
        dummy.Columns.Add("RemarkDate");
        dummy.Columns.Add("Description");
        dummy.Columns.Add("FileName");
        dummy.Columns.Add("MedRemarkID");
        dummy.Rows.Add();
        dgMedRemarks.DataSource = dummy;
        dgMedRemarks.DataBind();

        dummy = new DataTable();
        dummy.Columns.Add("BusRouteName");
        dummy.Columns.Add("BusRouteCode");
        dummy.Columns.Add("VehicleCode");
        dummy.Columns.Add("Timings");
        dummy.Columns.Add("BusCharge");
        dummy.Columns.Add("BusRouteID");
        dummy.Columns.Add("DateofRegistration");
        dummy.Rows.Add();
        dgBusRoute.DataSource = dummy;
        dgBusRoute.DataBind();

        dummy = new DataTable();
        dummy.Columns.Add("SlNo");
        dummy.Columns.Add("StaffName");
        dummy.Columns.Add("Relationship");
        dummy.Columns.Add("StudStaffID");
        dummy.Rows.Add();
        dgInstitution.DataSource = dummy;
        dgInstitution.DataBind();


        dummy = new DataTable();
        dummy.Columns.Add("SlNo");
        dummy.Columns.Add("RegNo");
        dummy.Columns.Add("RemarkDate");
        dummy.Columns.Add("Remarks");
        dummy.Columns.Add("RemarkID");
        dummy.Rows.Add();
        dgAcademicRemarks.DataSource = dummy;
        dgAcademicRemarks.DataBind();


        dummy = new DataTable();
        dummy.Columns.Add("SlNo");
        dummy.Columns.Add("SchoolName");
        dummy.Columns.Add("Academicyear");
        dummy.Columns.Add("StdStudied");
        dummy.Columns.Add("Firstlang");
        dummy.Columns.Add("Medium");
        dummy.Columns.Add("TCNo");
        dummy.Columns.Add("TCReceivedDate");
        dummy.Columns.Add("StudOldSchID");
        dummy.Rows.Add();
        dgOldSchool.DataSource = dummy;
        dgOldSchool.DataBind();

        dummy = new DataTable();
        dummy.Columns.Add("SlNo");
        dummy.Columns.Add("Title");
        dummy.Columns.Add("Description");
        dummy.Columns.Add("FileName");
        dummy.Columns.Add("StudAttachID");
        dummy.Rows.Add();
        dgAttachmentDetails.DataSource = dummy;
        dgAttachmentDetails.DataBind();

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
                    sda.Fill(ds, "StudentInfos");
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
    public static string GetBusRouteInfo(string routecode, string regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetBusRoute '" + routecode + "','" + regno + "'";
        return utl.GetDatasetTable(query, "BusRoutes").GetXml();
    }
    [WebMethod]
    public static string GetHostelInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetHostelInfo " + regno + "";
        return utl.GetDatasetTable(query, "HostelInfo").GetXml();
    }

    [WebMethod]
    public static string GetStudentInfo(int studentid)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStudentInfo " + studentid + "";
        return utl.GetDatasetTable(query, "StudentInfo").GetXml();
    }

    [WebMethod]
    public static string GetMedicalRemarkInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetMedicalRemarkInfo " + "" + regno + "";
        return utl.GetDatasetTable(query, "MedicalRemark").GetXml();
    }

    [WebMethod]
    public static string GetAcademicRemarkInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetAcademicRemarkInfo " + "" + regno + "";
        return utl.GetDatasetTable(query, "AcademicRemark").GetXml();
    }

    [WebMethod]
    public static string GetBroSisInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetBroSisInfo " + regno + "";
        return utl.GetDatasetTable(query, "BroSis").GetXml();
    }

    [WebMethod]
    public static string GetStaffChildrenInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStaffChildrenInfo " + "''" + "," + "''" + "," + "" + regno + "";
        return utl.GetDatasetTable(query, "StaffChildren").GetXml();
    }
    [WebMethod]
    public static string GetNationalityInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "GetNationalityInfo " + regno + "";
        return utl.GetDatasetTable(query, "National").GetXml();
    }

    [WebMethod]
    public static string GetAttachmentInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetAttachmentInfo " + regno + "";
        return utl.GetDatasetTable(query, "Attachment").GetXml();
    }
    [WebMethod]
    public static string GetOldSchoolInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetOldSchoolInfo " + regno + "";
        return utl.GetDatasetTable(query, "OldSchool").GetXml();
    }

    [WebMethod]
    public static string GetConcessionInfo(int StudentID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetConcessionInfo " + StudentID + "," + HttpContext.Current.Session["AcademicID"] + "";
        return utl.GetDatasetTable(query, "ConcessionInfo").GetXml();

    }
}
