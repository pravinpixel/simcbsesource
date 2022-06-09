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

public partial class StudentInfo : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    public static int Userid = 0;
    private static int PageSize = 10;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.RequestType == "POST")
        {
            if (Request.Files["StudentImage"] != null && Request.Files["StudentImage"].ContentLength > 0 && Request.Form["StudenInfoId"] != null && Request.Form["StudenInfoId"].Length > 0)
            {

                HttpPostedFile PostedFile = Request.Files["StudentImage"];
                string id = Request.Form["StudenInfoId"].ToString();
                string extension = PostedFile.FileName.Substring(PostedFile.FileName.LastIndexOf('.'));
                if (File.Exists(Server.MapPath("~/Students/Photos/" + id + extension)))
                {
                    File.Delete(Server.MapPath("~/Students/Photos/" + id + extension));
                }
                PostedFile.SaveAs(Server.MapPath("~/Students/Photos/" + id + extension));
            }
            if (Request.Files["MedicalRemarks"] != null && Request.Files["MedicalRemarks"].ContentLength > 0 && Request.Form["StudenInfoId"] != null && Request.Form["StudenInfoId"].Length > 0 && Request.Form["MedRemDate"] != null && Request.Form["MedRemDate"].Length > 0 && Request.Form["MaxId"] != null && Request.Form["MaxId"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["MedicalRemarks"];
                string id = Request.Form["StudenInfoId"].ToString();
                string MedRemDate = Request.Form["MedRemDate"].ToString();
                string MaxId = Request.Form["MaxId"].ToString();
                string extension = PostedFile.FileName.Substring(PostedFile.FileName.LastIndexOf('.'));
                if (MedRemDate != "")
                {
                    string[] myDateTimeString = MedRemDate.Split('/');
                    MedRemDate = "" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "";
                }
                PostedFile.SaveAs(Server.MapPath("~/Students/MedicalRemarks/" + MedRemDate.Replace("/", "") + "_" + id + "_" + MaxId + extension));
            }
            if (Request.Files["Attachment"] != null && Request.Files["Attachment"].ContentLength > 0 && Request.Form["StudenInfoId"] != null && Request.Form["StudenInfoId"].Length > 0 && Request.Form["MaxId"] != null && Request.Form["MaxId"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["Attachment"];
                string id = Request.Form["StudenInfoId"].ToString();
                string MaxId = Request.Form["MaxId"].ToString();
                string extension = PostedFile.FileName.Substring(PostedFile.FileName.LastIndexOf('.'));
                PostedFile.SaveAs(Server.MapPath("~/Students/Attachments/" + id + "_" + MaxId + extension));
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
            string Academicyear = "";
            utl = new Utilities();
            //Academicyear = utl.ExecuteScalar("select top 1 (convert(varchar(4),year(startdate))+'-'+ convert(varchar(4),year(enddate))) from m_academicyear where isactive=1 order by academicid desc");
            if (Session["AcademicID"].ToString() != "")
            {
                Academicyear = utl.ExecuteScalar("select top 1 academicid from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
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
                BindYearDropdowns();
                BindHostel();
                BindBusRoute();
                BindReligion();
                BindCaste();
                BindCommunity();
                BindClass();
                BindModeofTransport();
                BindFamilyRelationship();
                BindBroSisRelationship();
                BindRelationship();
                BindScholarship();
                BindBloodGroup();
                BindSchoolAcademicYear();
                BindLanguage();
                BindMedium();
                BindEmployeeName();
                BindDummyRow();
                BindGridView();
                BindHostelDetails();
                txtDOB.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtMedRemDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtDOJ.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtDateofHostelAdmn.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtDateofBusReg.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtAcaRemDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtTCDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtTCReceivedDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtPPDateofIssue.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtPPExpDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtVisaIssuedDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtVisaExpiryDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtValidity.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                txtDOJ.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
            }
           // txtFirstlang.Text = "English";
        }
    }
    
    private void BindYearDropdowns()
    {
        for (int i = 1975; i <= Convert.ToInt32(System.DateTime.Now.AddYears(5).ToString("yyyy")); i++)
        {
            ddlSSLC.Items.Add(i.ToString());
            ddlHSC.Items.Add(i.ToString());
            ddlSSLC.SelectedIndex = 0;
            ddlHSC.SelectedIndex = 0;
        }
    }

    private void BindEmployeeName()
    {
        Utilities utl = new Utilities();
        DataTable dt = new DataTable();
        dt = utl.GetDataTable("sp_GetStaffParents");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlStaff1.DataSource = dt;
            ddlStaff1.DataTextField = "StaffName";
            ddlStaff1.DataValueField = "EmpCode";
            ddlStaff1.DataBind();
        }

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlStaff2.DataSource = dt;
            ddlStaff2.DataTextField = "StaffName";
            ddlStaff2.DataValueField = "EmpCode";
            ddlStaff2.DataBind();
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
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_getstudentinfo " + hfStudentInfoID.Value;
        }
        else
        {
            query = "sp_getpromostudentinfo " + hfStudentInfoID.Value;
        }

        dt = utl.GetDataTable(query);
        if (dt.Rows.Count > 0)
        {

            sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
            Isactive = utl.ExecuteScalar(sqlstr);
            query = "";
            if (Isactive == "True")
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
            else
            {
                dta = utl.GetDataTable("sp_GetOldConcessionInfo " + hfStudentInfoID.Value + "," + Session["AcademicID"] + "");
                if (dta.Rows.Count > 0)
                {
                    dt = utl.GetDataTable("sp_GetOldConcessionInfo " + hfStudentInfoID.Value + "," + Session["AcademicID"] + "");

                }
                else
                {
                    dt = utl.GetDataTable("sp_getfeesAmount " + dt.Rows[0]["ClassID"] + ",'" + dt.Rows[0]["Active"] + "',''," + Session["AcademicID"] + "");
                    dt.Columns.Add("ConcessionAmount", typeof(string));
                }
            }





        }


        return dt;
    }
    private DataTable GetHostelFees()
    {

        Utilities utl = new Utilities();
        DataSet dts = new DataSet();
        DataTable dt = new DataTable();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_getstudentinfo " + hfStudentInfoID.Value;
        }
        else
        {
            query = "sp_getpromostudentinfo " + hfStudentInfoID.Value;
        }
        dt = utl.GetDataTable(query);
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
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        if (Isactive == "True")
        {
            query = "sp_getstudentinfo " + StudentInfoID;
        }
        else
        {
            query = "sp_getpromostudentinfo " + StudentInfoID;
        }
        dt = utl.GetDataTable(query);
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
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_GetStudentBySection '" + Class + "','" + Section + "','" + HttpContext.Current.Session["AcademicID"] + "'";
        }
        else
        {
            query = "sp_GetPromoStudentBySection '" + Class + "','" + Section + "','" + HttpContext.Current.Session["AcademicID"] + "'";
        }
        return utl.GetDatasetTable(query, "StudentBySection").GetXml();

    }

    private void BindHostelDetails()
    {
        var dti = GetHostelFees();
        //dti.Columns.Remove("userid");
        dgHostel.Columns.Clear();
        dgHostel.ShowFooter = true;

        var boundField = new BoundField();

        if (dti.Columns.Count > 0)
        {
            boundField.DataField = dti.Columns[1].ColumnName;
            boundField.HeaderText = dti.Columns[1].ColumnName;
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderStyle.CssClass = "sorting_mod";
            dgHostel.Columns.Add(boundField);
            boundField.Visible = false;
        }
        if (dti.Columns.Count > 1)
        {
            boundField = new BoundField();
            boundField.DataField = dti.Columns[3].ColumnName;
            boundField.HeaderText = dti.Columns[3].ColumnName;
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderStyle.CssClass = "sorting_mod";
            dgHostel.Columns.Add(boundField);
        }
        if (dti.Columns.Count > 2)
        {
            boundField = new BoundField();
            boundField.DataField = dti.Columns[4].ColumnName;
            boundField.HeaderText = dti.Columns[4].ColumnName;
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderStyle.CssClass = "sorting_mod";
            dgHostel.Columns.Add(boundField);
        }
        if (dti.Columns.Count > 3)
        {
            boundField = new BoundField();
            boundField.DataField = dti.Columns[5].ColumnName;
            boundField.HeaderText = dti.Columns[5].ColumnName;
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderText = "Actual Amt/Month";
            boundField.HeaderStyle.CssClass = "sorting_mod";
            dgHostel.Columns.Add(boundField);
        }

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
        if (dti.Columns.Count > 0)
        {
            boundField.DataField = dti.Columns[0].ColumnName;
            boundField.HeaderText = "StudConcessID";
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderStyle.CssClass = "StudConcessID";
            boundField.ItemStyle.CssClass = "StudConcessID";
            GridView1.Columns.Add(boundField);
        }

        if (dti.Columns.Count > 1)
        {
            boundField = new BoundField();
            boundField.DataField = dti.Columns[1].ColumnName;
            boundField.HeaderText = "FeesHeadID";
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderStyle.CssClass = "FeesHeadID";
            boundField.ItemStyle.CssClass = "FeesHeadID";
            GridView1.Columns.Add(boundField);
        }

        if (dti.Columns.Count > 2)
        {
            boundField = new BoundField();
            boundField.DataField = dti.Columns[3].ColumnName;
            boundField.HeaderText = dti.Columns[3].ColumnName;
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderStyle.CssClass = "sorting_mod";
            boundField.ItemStyle.CssClass = "FeesHeadName";
            GridView1.Columns.Add(boundField);
        }

        if (dti.Columns.Count > 3)
        {
            boundField = new BoundField();
            boundField.DataField = dti.Columns[4].ColumnName;
            boundField.HeaderText = dti.Columns[4].ColumnName;
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderStyle.CssClass = "sorting_mod";
            boundField.ItemStyle.CssClass = "ForMonth";
            GridView1.Columns.Add(boundField);
        }
        if (dti.Columns.Count > 4)
        {
            boundField = new BoundField();
            boundField.DataField = dti.Columns[5].ColumnName;
            boundField.HeaderText = dti.Columns[5].ColumnName;
            boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            boundField.HeaderText = "Actual Amt/Month";
            boundField.HeaderStyle.CssClass = "sorting_mod";
            boundField.ItemStyle.CssClass = dti.Columns[5].ColumnName;
            GridView1.Columns.Add(boundField);
        }
        if (dti.Columns.Count > 6)
        {
            CreateCustomTemplateField(GridView1, dti.Columns[6].ToString());
        }
        GridView1.DataSource = dti;
        GridView1.DataBind();


    }
    private void CreateCustomTemplateField(GridView gv, string headerText)
    {
        var customField = new TemplateField();
        customField.HeaderTemplate = new CustomTemplate(DataControlRowType.Header, "Concession Amt/Month");
        customField.ItemTemplate = new CustomTemplate(DataControlRowType.DataRow, "ConcessionAmt");
        customField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        customField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        customField.HeaderStyle.CssClass = "sorting_mod";
        customField.ItemStyle.CssClass = "ConcessionAmount";
        gv.Columns.Add(customField);
    }
    public class CustomTemplate : ITemplate
    {
        private DataControlRowType _rowType;
        private string _headerText;

        public CustomTemplate(DataControlRowType rowType, string headerText)
        {
            _rowType = rowType;
            _headerText = headerText;
        }

        public void InstantiateIn(Control container)
        {
            switch (_rowType)
            {
                case DataControlRowType.Header:
                    var header = new Literal();
                    header.Text = _headerText;
                    container.Controls.Add(header);
                    break;
                case DataControlRowType.DataRow:
                    var data = new TextBox();
                    data.Attributes.Add("class", _headerText);
                    data.DataBinding += DataRowLiteral_DataBinding;
                    data.Width = 75;
                    container.Controls.Add(data);
                    break;
            }
        }

        private void DataRowLiteral_DataBinding(object sender, EventArgs e)
        {
            var data = (TextBox)sender;
            var row = (GridViewRow)data.NamingContainer;
            data.Text = "";
        }
    }
    private void BindScholarship()
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        sqlstr = "sp_GetScholarship ";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlScholarship.DataSource = dt;
            ddlScholarship.DataTextField = "ScholarshipName";
            ddlScholarship.DataValueField = "ScholarshipID";
            ddlScholarship.DataBind();
        }
        else
        {
            ddlScholarship.DataSource = null;
            ddlScholarship.DataBind();
            ddlScholarship.SelectedIndex = 0;
        }
    }
    private void BindSchoolAcademicYear()
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        sqlstr = "sp_getAcademinYear ";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);



        for (int i = Convert.ToInt32(System.DateTime.Now.AddYears(5).ToString("yyyy")); i >= 1950; i--)
        {
            ddlStartAcademicYr.Items.Add(i.ToString());
            ddlEndAcademicYr.Items.Add(i.ToString());
            if (i.ToString().Trim() == System.DateTime.Now.Year.ToString().Trim())
            {
                ddlStartAcademicYr.SelectedValue = i.ToString();
                ddlEndAcademicYr.SelectedValue = i.ToString();
            }

        }

    }
    //private void BindSchoolAcademicYear()
    //{
    //    Utilities utl = new Utilities();
    //    DataSet ds = new DataSet();
    //    sqlstr = "sp_getAcademinYear ";
    //    DataTable dt = new DataTable();
    //    dt = utl.GetDataTable(sqlstr);
    //    for (int i = 1950; i <= Convert.ToInt32(System.DateTime.Now.Year); i++)
    //    {
    //        ddlStartAcademicYr.Items.Add(i.ToString());
    //        ddlEndAcademicYr.Items.Add(i.ToString());
    //        ddlStartAcademicYr.SelectedIndex = 0;
    //        ddlEndAcademicYr.SelectedIndex = 0;
    //    }

    //}
    private void BindBusRoute()
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        sqlstr = "sp_GetBusRouteDetails " + "''";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlRouteCode.DataSource = dt;
            ddlRouteCode.DataTextField = "BusRouteName";
            ddlRouteCode.DataValueField = "BusRouteID";
            ddlRouteCode.DataBind();
        }
        else
        {
            ddlRouteCode.DataSource = null;
            ddlRouteCode.DataBind();
            ddlRouteCode.SelectedIndex = 0;
        }
    }
    private void BindHostel()
    {
        utl = new Utilities();
        sqlstr = "sp_GetHostel";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlHostel.DataSource = dt;
            ddlHostel.DataTextField = "HostelName";
            ddlHostel.DataValueField = "HostelID";
            ddlHostel.DataBind();
        }
        else
        {
            ddlHostel.DataSource = null;
            ddlHostel.DataBind();
            ddlHostel.SelectedIndex = 0;
        }


    }
    private void BindDummyRow()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");
        if (hdnID.Value.ToLower() == "true")
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
            dummy.Columns.Add("TCDate");
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

            dummy = new DataTable();
            dummy.Columns.Add("SNO");
            dummy.Columns.Add("ScholarshipId");
            dummy.Columns.Add("ScholarshipName");
            dummy.Columns.Add("StudScholId");
            dummy.Rows.Add();
            dgScholarship.DataSource = dummy;
            dgScholarship.DataBind();


            dummy = new DataTable();
            dummy.Columns.Add("SNO");
            dummy.Columns.Add("ScholarshipId");
            dummy.Columns.Add("ScholarshipName");
            dummy.Columns.Add("StudScholId");
            dummy.Rows.Add();
            dgScholarship.DataSource = dummy;
            dgScholarship.DataBind();

            dummy = new DataTable();
            dummy.Columns.Add("SportId");
            dummy.Columns.Add("SportName");
            dummy.Columns.Add("StudSportId");
            dummy.Rows.Add();
            dgSports.DataSource = dummy;
            dgSports.DataBind();

            dummy = new DataTable();
            dummy.Columns.Add("FineArtId");
            dummy.Columns.Add("FineArtName");
            dummy.Columns.Add("StudFineArtId");
            dummy.Rows.Add();
            dgFineArts.DataSource = dummy;
            dgFineArts.DataBind();
        }
    }
    private void BindFamilyRelationship()
    {
        utl = new Utilities();
        sqlstr = "sp_GetFamilyRelationship";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlRelationship.DataSource = dt;
            ddlRelationship.DataTextField = "RelationshipName";
            ddlRelationship.DataValueField = "RelationshipName";
            ddlRelationship.DataBind();
        }
        else
        {
            ddlRelationship.DataSource = null;
            ddlRelationship.DataBind();
        }

    }



    private void BindRelationship()
    {
        utl = new Utilities();
        sqlstr = "sp_GetRelationship";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlRelationship1.DataSource = dt;
            ddlRelationship1.DataTextField = "RelationshipName";
            ddlRelationship1.DataValueField = "RelationshipName";
            ddlRelationship1.DataBind();
        }
        else
        {
            ddlRelationship1.DataSource = null;
            ddlRelationship1.DataBind();
        }

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlRelationship2.DataSource = dt;
            ddlRelationship2.DataTextField = "RelationshipName";
            ddlRelationship2.DataValueField = "RelationshipName";
            ddlRelationship2.DataBind();
        }
        else
        {
            ddlRelationship2.DataSource = null;
            ddlRelationship2.DataBind();
        }

    }
    private void BindBroSisRelationship()
    {
        utl = new Utilities();
        sqlstr = "sp_GetBroSisRelationship";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlBroSisRelation.DataSource = dt;
            ddlBroSisRelation.DataTextField = "RelationshipName";
            ddlBroSisRelation.DataValueField = "RelationshipName";
            ddlBroSisRelation.DataBind();
        }
        else
        {
            ddlBroSisRelation.DataSource = null;
            ddlBroSisRelation.DataBind();
        }

    }
    private void BindReligion()
    {
        utl = new Utilities();
        sqlstr = "sp_GetReligion";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlReligion.DataSource = dt;
            ddlReligion.DataTextField = "ReligionName";
            ddlReligion.DataValueField = "ReligionID";
            ddlReligion.DataBind();
        }
        else
        {
            ddlReligion.DataSource = null;
            ddlReligion.DataBind();
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


            ddlAdClass.DataSource = dt;
            ddlAdClass.DataTextField = "ClassName";
            ddlAdClass.DataValueField = "ClassID";
            ddlAdClass.DataBind();


            ddlBroSisClass.DataSource = dt;
            ddlBroSisClass.DataTextField = "ClassName";
            ddlBroSisClass.DataValueField = "ClassID";
            ddlBroSisClass.DataBind();




        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataBind();

            ddlAdClass.DataSource = null;
            ddlAdClass.DataBind();

            ddlBroSisClass.DataSource = null;
            ddlBroSisClass.DataBind();




        }

    }
    private void BindMedium()
    {
        utl = new Utilities();
        sqlstr = "sp_GetMedium";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlMedium.DataSource = dt;
            ddlMedium.DataTextField = "MediumName";
            ddlMedium.DataValueField = "MediumName";
            ddlMedium.DataBind();

        }
        else
        {
            ddlMedium.DataSource = null;
            ddlMedium.DataBind();
        }


        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSchoolMedium.DataSource = dt;
            ddlSchoolMedium.DataTextField = "MediumName";
            ddlSchoolMedium.DataValueField = "MediumId";
            ddlSchoolMedium.DataBind();
        }
        else
        {
            ddlSchoolMedium.DataSource = null;
            ddlSchoolMedium.DataBind();
        }

    }

    private void BindLanguage()
    {
        utl = new Utilities();
        sqlstr = "sp_GetLanguage";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlFirstLang.DataSource = dt;
            ddlFirstLang.DataTextField = "LanguageName";
            ddlFirstLang.DataValueField = "LanguageName";
            ddlFirstLang.DataBind();
        }
        else
        {
            ddlFirstLang.DataSource = null;
            ddlFirstLang.DataBind();
        }

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSeclang.DataSource = dt;
            ddlSeclang.DataTextField = "LanguageName";
            ddlSeclang.DataValueField = "LanguageName";
            ddlSeclang.DataBind();
        }
        else
        {
            ddlSeclang.DataSource = null;
            ddlSeclang.DataBind();
        }

        if (dt != null && dt.Rows.Count > 0)
        {
            txtFirstlang.DataSource = dt;
            txtFirstlang.DataTextField = "LanguageName";
            txtFirstlang.DataValueField = "LanguageName";
            txtFirstlang.DataBind();
        }
        else
        {
            txtFirstlang.DataSource = null;
            txtFirstlang.DataBind();
        }

    }
    private void BindModeofTransport()
    {
        utl = new Utilities();
        sqlstr = "sp_GetTransport";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlModeofTrans.DataSource = dt;
            ddlModeofTrans.DataTextField = "TransportName";
            ddlModeofTrans.DataValueField = "TransportID";
            ddlModeofTrans.DataBind();
        }
        else
        {
            ddlModeofTrans.DataSource = null;
            ddlModeofTrans.DataBind();
        }

    }
    private void BindCommunity()
    {
        utl = new Utilities();
        sqlstr = "sp_GetCommunity";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCommunity.DataSource = dt;
            ddlCommunity.DataTextField = "CommunityName";
            ddlCommunity.DataValueField = "CommunityID";
            ddlCommunity.DataBind();
        }
        else
        {
            ddlCommunity.DataSource = null;
            ddlCommunity.DataBind();
        }

    }
    private void BindCaste()
    {
        utl = new Utilities();
        sqlstr = "sp_GetCaste";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCaste.DataSource = dt;
            ddlCaste.DataTextField = "CasteName";
            ddlCaste.DataValueField = "CasteID";
            ddlCaste.DataBind();
        }
        else
        {
            ddlCaste.DataSource = null;
            ddlCaste.DataBind();
        }

    }
    private void BindBloodGroup()
    {
        utl = new Utilities();
        sqlstr = "sp_GetBloodGroup";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlBloodGroup.DataSource = dt;
            ddlBloodGroup.DataTextField = "BloodGroupName";
            ddlBloodGroup.DataValueField = "BloodGroupID";
            ddlBloodGroup.DataBind();
        }
        else
        {
            ddlBloodGroup.DataSource = null;
            ddlBloodGroup.DataBind();
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
    public static string GetRoomByBlock(string blockid, string hostelid)
    {

        Utilities utl = new Utilities();
        string query = "[sp_GetRoom] ''," + hostelid + "," + blockid + "";
        return utl.GetDatasetTable(query, "RoomByBlock").GetXml();


    }

    [WebMethod]
    public static string GetBlockByHostelID(int HostelID)
    {
        Utilities utl = new Utilities();
        string query = "sp_GetBlockByHostel " + HostelID + "";
        return utl.GetDatasetTable(query, "BlockByHostel").GetXml();
    }

    [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }

    [WebMethod]
    public static string GetAdSectionByAdClassID(int ClassID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "AdSectionByAdClass").GetXml();

    }
    [WebMethod]
    public static string GetPresentSectionByPresentClassID(int ClassID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "PresentSectionByPresentClass").GetXml();

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
    public static string GetScholarshipInfo(string regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStudentScholarship '','" + regno + "'";
        return utl.GetDatasetTable(query, "Scholarships").GetXml();
    }

    [WebMethod]
    public static string GetStudentInfo(int studentid)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string sqlstr = "select isactive from m_academicyear where AcademicID='" + HttpContext.Current.Session["AcademicID"].ToString() + "'";
        string Isactive = utl.ExecuteScalar(sqlstr);
        string query = "";
        if (Isactive == "True")
        {
            query = "sp_GetStudentInfo " + studentid + "";
        }
        else
        {
            query = "sp_GetPromoStudentInfo " + HttpContext.Current.Session["AcademicID"] + ",'" + studentid + "'";
        }
        return utl.GetDatasetTable(query, "StudentInfo").GetXml();
    }

    [WebMethod]
    public static string SaveStudentInfo(string id, string studentname, string classname, string classid, string sectionname, string gender, string dob, string doj, string religion, string mtongue, string community, string caste, string aadhaar, string tempaddress, string peraddress, string email, string phoneno, string smartcard, string rationcard, string photopath, string photofile, string sslcno, string sslcyear, string hscno, string hscyear, string suid, string tamilname, string academicyear, string sstatus, string userid)
    {

        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        if (dob != "")
        {
            string[] myDateTimeString = dob.Split('/');
            dob = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (doj != "")
        {
            string[] myDateTimeString = doj.Split('/');
            doj = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }

        if (!string.IsNullOrEmpty(id) && id != "0")
        {

            sqlstr = "sp_UpdateStudentInfo " + "'" + id + "','" + studentname.Replace("'", "''") + "','" + classname + "','" + classid + "','" + sectionname + "','" + gender + "'," + dob + "," + doj + ",'" + religion + "','" + mtongue + "','" + community + "','" + caste + "','" + aadhaar + "','" + tempaddress.Replace("'", "''") + "','" + peraddress.Replace("'", "''") + "','" + email.Replace("'", "''") + "','" + phoneno.Replace("'", "''") + "','" + smartcard.Replace("'", "''") + "','" + rationcard.Replace("'", "''") + "','" + photofile.Replace("'", "''") + "','" + sslcno.Replace("'", "''") + "','" + sslcyear.Replace("'", "''") + "','" + hscno.Replace("'", "''") + "','" + hscyear.Replace("'", "''") + "','" + academicyear + "','" + userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (photofile != "")
            {
                string extension = photofile.Substring(photofile.LastIndexOf('.'));
                sqlstr = "select regno from  s_studentinfo where studentid='" + id + "'";
                string regno = utl.ExecuteScalar(sqlstr);
                sqlstr = "update s_studentinfo set photofile= convert(varchar,'" + regno + extension + "'),Active='" + sstatus + "',student_uid='" + suid + "',tamilname=N'" + tamilname + "' where regno='" + regno + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
            }
            else
            {
                sqlstr = "select regno from  s_studentinfo where studentid='" + id + "'";
                string regno = utl.ExecuteScalar(sqlstr);
                sqlstr = "update s_studentinfo set Active='" + sstatus + "',student_uid='" + suid + "',tamilname=N'" + tamilname + "' where regno='" + regno + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
            }
            if (strQueryStatus == "")
            {
                return "Updated";
            }
            else
                return "Update Failed";

        }
        else
        {
            sqlstr = "sp_InsertStudentInfo " + "'" + studentname.Replace("'", "''") + "','" + classname + "','" + classid + "','" + sectionname + "','" + gender + "'," + dob + "," + doj + ",'" + religion + "','" + mtongue + "','" + community + "','" + caste + "','" + aadhaar + "','" + tempaddress.Replace("'", "''") + "','" + peraddress.Replace("'", "''") + "','" + email.Replace("'", "''") + "','" + phoneno.Replace("'", "''") + "','" + smartcard.Replace("'", "''") + "','" + rationcard.Replace("'", "''") + "','" + photofile.Replace("'", "''") + "','" + sslcno.Replace("'", "''") + "','" + sslcyear.Replace("'", "''") + "','" + hscno.Replace("'", "''") + "','" + hscyear.Replace("'", "''") + "','" + academicyear + "','" + userid + "'";
            strQueryStatus = utl.ExecuteScalar(sqlstr);
            string regno = strQueryStatus;
            //sqlstr = "select studentid from s_studentinfo where regno='" + regno + "'";
            //string studentid = utl.ExecuteScalar(sqlstr);
            //string returnVal = "";
            //if (sectionname=="")
            //{
            //    returnVal = utl.ExecuteScalar("exec sp_StudAdmissionApprovalNew " + regno + ",NULL," + classid + ",'" + academicyear + "'," + userid);
                
            //}
            //else
            //{
            //    returnVal = utl.ExecuteScalar("exec sp_StudAdmissionApprovalNew " + regno + ",'" + sectionname + "'," + classid + ",'" + academicyear + "'," + userid);
            //}
          
            //regno = returnVal;

            if (regno != "")
            {
                sqlstr = "select studentid from  s_studentinfo where regno='" + regno + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
                if (photofile != "")
                {
                    string extension = photofile.Substring(photofile.LastIndexOf('.'));
                    sqlstr = "update s_studentinfo set photofile= convert(varchar,'" + regno + extension + "'),Active='N',student_uid='" + suid + "',tamilname=N'" + tamilname + "' where regno='" + regno + "'";
                    utl.ExecuteQuery(sqlstr);

                }
                else
                {
                    sqlstr = "update s_studentinfo set Active='N',student_uid='" + suid + "',tamilname=N'" + tamilname + "' where regno='" + regno + "'";
                    strQueryStatus = utl.ExecuteScalar(sqlstr);
                }
                sqlstr = "select studentid from s_studentinfo where regno='" + regno + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
                regno = regno + "," + strQueryStatus;
                return regno;
            }
            else
            {
                return "Insert Failed";

            }
        }

    }

    [WebMethod]
    public static string SaveandPayAdvanceFees(string id, string studentname, string classname, string classid, string sectionname, string gender, string dob, string doj, string religion, string mtongue, string community, string caste, string aadhaar, string tempaddress, string peraddress, string email, string phoneno, string smartcard, string rationcard, string photopath, string photofile, string sslcno, string sslcyear, string hscno, string hscyear, string suid, string tamilname, string academicyear)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (dob != "")
        {
            string[] myDateTimeString = dob.Split('/');
            dob = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        else
        {
            dob = "''";
        }
        if (doj != "")
        {
            string[] myDateTimeString = doj.Split('/');
            doj = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        else
        {
            doj = "''";
        }
        if (!string.IsNullOrEmpty(id) && id != "0")
        {

            sqlstr = "sp_UpdateStudentInfo " + "'" + id + "','" + studentname.Replace("'", "''") + "','" + classname + "','" + classid + "','" + sectionname + "','" + gender + "'," + dob + "," + doj + ",'" + religion + "','" + mtongue + "','" + community + "','" + caste + "','" + aadhaar + "','" + tempaddress.Replace("'", "''") + "','" + peraddress.Replace("'", "''") + "','" + email.Replace("'", "''") + "','" + phoneno.Replace("'", "''") + "','" + smartcard.Replace("'", "''") + "','" + rationcard.Replace("'", "''") + "','" + photofile.Replace("'", "''") + "','" + sslcno.Replace("'", "''") + "','" + sslcyear.Replace("'", "''") + "','" + hscno.Replace("'", "''") + "','" + hscyear.Replace("'", "''") + "','" + academicyear + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (photofile != "")
            {
                string extension = photofile.Substring(photofile.LastIndexOf('.'));
                sqlstr = "update s_studentinfo set photofile= convert(varchar,'" + id + extension + "'),student_uid='" + suid + "',tamilname=N'" + tamilname + "' where studentid='" + id + "'";
                strQueryStatus = utl.ExecuteScalar(sqlstr);
            }
            if (strQueryStatus == "")
            {
                return "Updated";
            }
            else
                return "Update Failed";

        }
        else
        {
            sqlstr = "sp_InsertStudentInfo " + "'" + studentname.Replace("'", "''") + "','" + classname + "','" + classid + "','" + sectionname + "','" + gender + "'," + dob + "," + doj + ",'" + religion + "','" + mtongue + "','" + community + "','" + caste + "','" + aadhaar + "','" + tempaddress.Replace("'", "''") + "','" + peraddress.Replace("'", "''") + "','" + email.Replace("'", "''") + "','" + phoneno.Replace("'", "''") + "','" + smartcard.Replace("'", "''") + "','" + rationcard.Replace("'", "''") + "','" + photofile.Replace("'", "''") + "','" + sslcno.Replace("'", "''") + "','" + sslcyear.Replace("'", "''") + "','" + hscno.Replace("'", "''") + "','" + hscyear.Replace("'", "''") + "','" + academicyear + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteScalar(sqlstr);
            string regno = strQueryStatus;


            if (regno != "")
            {
                sqlstr = "select studentid from  s_studentinfo where regno='" + regno + "'";
                string studentid = utl.ExecuteScalar(sqlstr);
                if (photofile != "")
                {
                    string extension = photofile.Substring(photofile.LastIndexOf('.'));
                    sqlstr = "update s_studentinfo set regno='" + studentid + "',Active='F',photofile= convert(varchar,'" + id + extension + "'),student_uid='" + suid + "',tamilname=N'" + tamilname + "' where studentid='" + studentid + "'";
                    utl.ExecuteQuery(sqlstr);
                    regno = studentid;

                }
                else
                {
                    sqlstr = "update s_studentinfo set regno='" + studentid + "',Active='F',student_uid='" + suid + "',tamilname=N'" + tamilname + "' where studentid='" + studentid + "'";
                    utl.ExecuteQuery(sqlstr);
                    regno = studentid;
                }
                return regno;
            }
            else
            {
                return "Insert Failed";

            }
        }
    }

    [WebMethod]

    public static string SaveFamilyInfo(string id, string relationship, string name, string qual, string inc, string occ, string email, string cell, string addr, string priority, string caretaker)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "sp_UpdateFamilyInfo " + "'" + id + "','" + relationship.Replace("'", "''") + "','N','" + name + "','" + qual + "','" + inc + "','" + occ + "','" + email + "','" + cell + "','" + addr + "','" + priority + "','" + caretaker + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Updated";
            else
                return "Update Failed";
        }
        else
        {
            return "";
        }
    }


    [WebMethod]


    public static string SaveGuardianInfo(string id, string gname, string gaddr, string gphno, string priority, string qual, string inc, string occ, string email)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "sp_UpdateGuardianInfo " + "'" + id + "','" + gname.Replace("'", "''") + "','" + gaddr + "','" + gphno + "','" + priority + "','" + qual + "','" + inc + "','" + occ + "','" + email + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Updated";
            else
                return "Update Failed";
        }
        else
        {
            return "";
        }
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
    public static string DeleteMedicalRemarkInfo(int MedRemarkId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteMedicalRemarkInfo " + "" + MedRemarkId + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
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
    public static string DeleteAcademicRemarkInfo(int RemarkId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteAcademicRemarkInfo " + "" + RemarkId + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    [WebMethod]

    public static string SaveMedicalRemarkInfo(string id, string academicid, string remarkdate, string description, string filename)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (remarkdate != "")
        {
            string[] myDateTimeString = remarkdate.Split('/');
            remarkdate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (!string.IsNullOrEmpty(id))
        {

            sqlstr = "sp_UpdateMedicalRemarkInfo " + "'" + id + "','" + academicid.Replace("'", "''") + "'," + remarkdate + ",'" + description + "','" + filename + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteScalar(sqlstr);
            if (strQueryStatus != "")
                return strQueryStatus;
            else
                return "Update Failed";

        }
        else
        {
            return "";
        }
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
    public static string GetFamilyInfo(int StudentID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetFamilyInfo " + StudentID + "";
        return utl.GetDatasetTable(query, "Family").GetXml();
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
    public static string GetSportsInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSportsInfo " + regno + ","+ HttpContext.Current.Session["AcademicID"].ToString();
        return utl.GetDatasetTable(query, "Sports").GetXml();
    }

    [WebMethod]
    public static string ManageSports(string regno, string sportid, string status)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (status == "Add")
        {
            strQueryStatus = utl.ExecuteQuery("sp_AddSports " + regno + ",'" + HttpContext.Current.Session["AcademicID"].ToString() + "'," + sportid + ",'" + Userid + "'");
            if (strQueryStatus == "")
            {
                strQueryStatus = "Inserted Sucessfully";
            }
            else
                strQueryStatus = "Insert Failed";
        }
        else if (status == "Update")
        {
            strQueryStatus = utl.ExecuteQuery("sp_UpdateSports " + regno + ",'" + HttpContext.Current.Session["AcademicID"].ToString() + "'," + sportid + ",'" + Userid + "'");
            if (strQueryStatus == "")
            {
                strQueryStatus = "Updated Sucessfully";
            }
            else
                strQueryStatus = "Update Failed";
        }
        return strQueryStatus;
    }
    
    [WebMethod]
    public static string SaveCurricularDetails(string regno, string type, string curricularremarks)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        string icnt = string.Empty;
        if (type == "Sports")
        {
           icnt= utl.ExecuteScalar("select count(*) from s_studentsports where academicID='" + HttpContext.Current.Session["AcademicID"] + "' and regno='" + regno + "' and isactive=1");
           if (icnt=="" || icnt=="0")
           {
               strQueryStatus = "Fail";
               
           }
           else
           {
               utl.ExecuteQuery("update s_studentinfo set Sports=1,FineArts=0,CurricularRemarks='" + curricularremarks.Replace("'", "''") + "' where regno='" + regno + "'");
               strQueryStatus =  "Success";
           }
           
        }
        else if (type == "FineArts")
        {
            icnt = utl.ExecuteScalar("select count(*) from s_studentfinearts where academicID='" + HttpContext.Current.Session["AcademicID"] + "' and regno='" + regno + "' and isactive=1");
            if (icnt == "" || icnt == "0")
            {
                strQueryStatus = "Fail";
            }
            else
            {
                utl.ExecuteQuery("update s_studentinfo set Sports=0,FineArts=1,CurricularRemarks='" + curricularremarks.Replace("'", "''") + "' where regno='" + regno + "'");
                strQueryStatus = "Success";
            }
        }
        return strQueryStatus;
       
    }
    
    [WebMethod]
    public static string ManageFineArts(string regno, string fineartsid, string status)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (status == "Add")
        {
            strQueryStatus = utl.ExecuteQuery("sp_AddFineArts " + regno + ",'" + HttpContext.Current.Session["AcademicID"].ToString() + "'," + fineartsid + ",'" + Userid + "'");
            if (strQueryStatus == "")
            {
                strQueryStatus = "Inserted Sucessfully";
            }
            else
                strQueryStatus = "Insert Failed";
        }
        else if (status == "Update")
        {
            strQueryStatus = utl.ExecuteQuery("sp_UpdateFineArts " + regno + ",'" + HttpContext.Current.Session["AcademicID"].ToString() + "'," + fineartsid + ",'" + Userid + "'");
            if (strQueryStatus == "")
            {
                strQueryStatus = "Updated Sucessfully";
            }
            else
                strQueryStatus = "Update Failed";
        }
        return strQueryStatus;
    }
    
    [WebMethod]
    public static string GetFineArtsInfo(int regno)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetFineArtsInfo " + regno + "," + HttpContext.Current.Session["AcademicID"].ToString();
        return utl.GetDatasetTable(query, "FineArts").GetXml();
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
    public static string chkpriority(string str)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        return utl.GetDatasetTable(str, "priority").GetXml();

    }

    [WebMethod]
    public static string GetConcessionInfo(int StudentID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetConcessionInfo " + StudentID + "," + HttpContext.Current.Session["AcademicID"] + "";
        return utl.GetDatasetTable(query, "ConcessionInfo").GetXml();

    }

    [WebMethod]

    public static string SaveBroSisInfo(string id, string relationid, string relation)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        if (!string.IsNullOrEmpty(id))
        {

            sqlstr = "update s_studentinfo set BroSis='Y' where regno='" + id + "'";
            utl.ExecuteQuery(sqlstr);
            sqlstr = "sp_UpdateBroSisInfo " + "'" + id + "','" + relationid.Replace("'", "''") + "','" + relation + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Updated";
            else
                return "Update Failed";

        }
        else
        {
            return "";
        }
    }

    [WebMethod]
    public static string EditRelationshipInfo(int studentid, string type)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "";
        if (type == "Father")
        {
            type = "1";
            query = "sp_GetRelationshipInfo " + "" + studentid + "," + type + "";
        }
        else if (type == "Mother")
        {
            type = "2";
            query = "sp_GetRelationshipInfo " + "" + studentid + "," + type + "";
        }
        else if (type == "Guardian I")
        {
            type = "3";
            query = "sp_GetRelationshipInfo " + "" + studentid + "," + type + "";
        }
        else if (type == "Guardian II")
        {
            type = "4";
            query = "sp_GetRelationshipInfo " + "" + studentid + "," + type + "";
        }
        else
        {
            query = "sp_GetFamilyInfo " + "" + studentid + "";

        }
        return utl.GetDatasetTable(query, "EditRelationship").GetXml();
    }

    [WebMethod]
    public static string EditStaffChildrenInfo(int StudStaffID, string Relationship)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();

        string query = "sp_GetStaffChildrenInfo " + StudStaffID + ",'" + Relationship + "'" + "," + "''";
        return utl.GetDatasetTable(query, "StaffChildren").GetXml();
    }
    [WebMethod]
    public static string EditOldSchoolInfo(int StudOldSchID, string RegNo)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();

        string query = "sp_GetOldSchoolInfo " + RegNo + ",'" + StudOldSchID + "'";
        return utl.GetDatasetTable(query, "OldSchool").GetXml();
    }

    [WebMethod]
    public static string EditBroSisInfo(int regno, int relationId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();

        string query = "sp_GetBroSisInfo " + "''" + "," + relationId + "";
        return utl.GetDatasetTable(query, "EditBroSis").GetXml();
    }
    [WebMethod]

    public static string SaveMedicalInfo(string id, string bloodgroup, string disease, string height, string weight, string emergencyphno, string familydocname, string familydocadd, string familydocphno, string identificationmarks, string physical, string physicalhandicapped)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "sp_UpdateMedicalInfo " + "'" + id + "','" + bloodgroup.Replace("'", "''") + "','" + disease + "','" + height + "','" + weight + "','" + emergencyphno + "','" + familydocname + "','" + familydocadd + "','" + familydocphno + "','" + identificationmarks + "','" + physical + "','" + physicalhandicapped + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Updated";
            else
                return "Update Failed";
        }
        else
        {
            return "";
        }
    }

    [WebMethod]

    public static string SaveAcademicInfo(string id, string admissionno, string adclassname, string adsectionname, string doa, string modeoftrans, string medium, string firstlang, string seclang, string academicid, string emp1, string emp2, string relation1, string relation2, string sstatus)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        if (doa != "")
        {
            string[] myDateTimeString = doa.Split('/');
            doa = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        else
        {
            doa = "null";
        }
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "sp_UpdateAcademicInfo " + "'" + id + "','" + admissionno.Replace("'", "''") + "','" + adclassname + "','" + adsectionname + "'," + doa + ",'" + modeoftrans + "','" + medium + "','" + firstlang + "','" + seclang + "','" + sstatus + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
            {
                //if (scholar == "Y")
                //{
                //    sqlstr = "sp_UpdateScholarshipInfo " + "'" + id + "','" + academicid.Replace("'", "''") + "','" + scholarship + "','" + Userid + "'";
                //    strQueryStatus = utl.ExecuteQuery(sqlstr);
                //}
                //else if (scholar == "N")
                //{
                //    sqlstr = " update s_studentscholarship set isactive=0 where  regno=" + id + " and academicid=" + academicid + " and scholarshipid=" + scholarship + "";
                //    strQueryStatus = utl.ExecuteQuery(sqlstr);
                //}

                sqlstr = "update s_studentinfo set Staff='Y' where regno='" + id + "'";
                utl.ExecuteQuery(sqlstr);

                if (emp1 != "")
                {
                    sqlstr = "sp_UpdateStaffChildrenInfo " + "'" + id + "','" + emp1.Replace("'", "''") + "','" + relation1 + "','" + Userid + "'";
                    utl.ExecuteQuery(sqlstr);
                }
                if (emp2 != "")
                {
                    sqlstr = "sp_UpdateStaffChildrenInfo " + "'" + id + "','" + emp2.Replace("'", "''") + "','" + relation2 + "','" + Userid + "'";
                    utl.ExecuteQuery(sqlstr);
                }
                return "Updated";

            }
            else
            {
                return "Update Failed";
            }
        }
        else
        {
            return "";
        }
    }

    [WebMethod]
    public static string SaveScholarshipInfo(string id, string academicid, string scholar, string scholarship)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (!string.IsNullOrEmpty(id))
        {
            sqlstr = "select isnull(count(*),0) from s_studentscholarship where RegNo='" + id + "' and AcademicId='" + academicid + "'  and ScholarshipId='" + scholarship + "' and isactive=1";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));

            if (iCount == "0")
            {

                if (scholar == "Y")
                {
                    sqlstr = "sp_UpdateScholarshipInfo " + "'" + id + "','" + academicid.Replace("'", "''") + "','" + scholarship + "','" + Userid + "'";
                    strQueryStatus = utl.ExecuteQuery(sqlstr);

                    sqlstr = "update s_studentinfo set Scholar='Y' where RegNo='" + id + "' ";
                    strQueryStatus = utl.ExecuteQuery(sqlstr);
                }
                else if (scholar == "N")
                {
                    sqlstr = " update s_studentscholarship set isactive=0 where  regno=" + id + " and academicid=" + academicid + " and scholarshipid=" + scholarship + "";
                    strQueryStatus = utl.ExecuteQuery(sqlstr);

                    sqlstr = "update s_studentinfo set Scholar='N' where RegNo='" + id + "' ";
                    strQueryStatus = utl.ExecuteQuery(sqlstr);
                }
            }

            else
            {
                return "AlreadyExists";
            }
        }
        return "Updated";
    }


    [WebMethod]

    public static string SaveAcademicRemarkInfo(string id, string academicid, string remarkdate, string remarks)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (remarkdate != "")
        {
            string[] myDateTimeString = remarkdate.Split('/');
            remarkdate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (!string.IsNullOrEmpty(id))
        {

            sqlstr = "sp_UpdateAcademicRemarkInfo " + "'" + id + "','" + academicid.Replace("'", "''") + "'," + remarkdate + ",'" + remarks + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Updated";
            else
                return "Update Failed";

        }
        else
        {
            return "";
        }
    }

    [WebMethod]

    public static string SaveBusRouteInfo(string id, string academicid, string routeid, string regdate, string status)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (regdate != "")
        {
            string[] myDateTimeString = regdate.Split('/');
            regdate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        else
        {
            regdate = "''";
        }

        sqlstr = "SELECT convert(varchar(3),DATENAME(month, " + regdate + "))";
        string strmonthname = utl.ExecuteScalar(sqlstr);
        if (!string.IsNullOrEmpty(id))
        {

            sqlstr = "select count(*) from f_studentbillmaster a inner join f_studentbills b on a.billid=b.billid inner join m_feescategoryhead c on c.feescatheadid=b.feescatheadid inner join m_feeshead d on d.feesheadid=c.feesheadid inner join s_studentinfo e on e.regno=a.regno  where e.active in('C','N') and a.isactive=1 and b.isactive=1 and c.isactive=1 and d.isactive=1  and d.feesheadcode='B' and convert(varchar(3),a.billmonth)='" + strmonthname + "' and a.regno=" + id + " and b.AcademicID='" + academicid.Replace("'", "''") + "' ";
            string iCount = utl.ExecuteScalar(sqlstr);
            if (iCount == "0" || iCount == "")
            {


                sqlstr = "update s_studentinfo set BusFacility='" + status + "' where regno='" + id + "'";
                utl.ExecuteQuery(sqlstr);

                sqlstr = "sp_UpdateBusRouteInfo " + "'" + id + "','" + academicid.Replace("'", "''") + "','" + routeid + "'," + regdate + ",'" + Userid + "','" + status + "'";
                strQueryStatus = utl.ExecuteQuery(sqlstr);
                if (strQueryStatus == "")
                    return "Updated";
                else
                    return "Update Failed";
            }
            else
            {
                return "Already Fees paid for this month.!  Can't Register !!!";
            }

        }
        else
        {
            return "";
        }
    }


    [WebMethod]
    public static string DeleteBusRouteInfo(int RegNo, int BusRouteId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        sqlstr = "update s_studentinfo set BusFacility='N' where regno='" + RegNo + "'";
        utl.ExecuteQuery(sqlstr);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteBusRouteInfo " + BusRouteId + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    [WebMethod]
    public static string SaveHostelInfo(string id, string academicid, string hostelid, string blockid, string roomid, string regdate, string status)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (regdate != "")
        {
            string[] myDateTimeString = regdate.Split('/');
            regdate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        else
        {
            regdate = "''";
        }
        if (!string.IsNullOrEmpty(id))
        {

            sqlstr = "update s_studentinfo set Hostel='" + status + "' where regno='" + id + "'";
            utl.ExecuteQuery(sqlstr);

            sqlstr = "sp_UpdateHostelInfo " + "'" + id + "','" + academicid.Replace("'", "''") + "','" + hostelid + "','" + blockid + "','" + roomid + "'," + regdate + ",'" + Userid + "','" + status + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Updated";
            else
                return "Update Failed";

        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string SaveOldSchoolInfo(string ID, string SchoolName, string StartAcademicYr, string EndAcademicYr, string StdFrom, string FirstLang, string iMedium, string TCNo, string TCDate, string TCReceivedDate)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (TCDate != "")
        {
            string[] myDateTimeString = TCDate.Split('/');
            TCDate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        else
        {
            TCDate = "''";
        }
        if (TCReceivedDate != "")
        {
            string[] myDateTimeString = TCReceivedDate.Split('/');
            TCReceivedDate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        else
        {
            TCReceivedDate = "''";
        }
        if (!string.IsNullOrEmpty(ID))
        {
            sqlstr = "update s_studentinfo set OldSchool='Y' where regno='" + ID + "'";
            utl.ExecuteQuery(sqlstr);

            sqlstr = "sp_UpdateOldSchoolInfo " + "'" + ID + "','" + SchoolName.Replace("'", "''") + "','" + StartAcademicYr + "','" + EndAcademicYr + "','" + StdFrom + "','" + FirstLang + "','" + iMedium + "','" + TCNo + "'," + TCDate + "," + TCReceivedDate + ",'" + Userid + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
                return "Updated";
            else
                return "Update Failed";

        }
        else
        {
            return "";
        }
    }


    [WebMethod]
    public static string SaveNationalityInfo(string ID, string IsNative, string Nationality, string PassportNo, string PPDateofIssue, string VisaNumber, string PPExpDate, string VisaType, string VisaIssuedDate, string VisaExpiryDate, string NoOfEntry, string Validity, string Purpose, string Remark)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (PPDateofIssue != "")
        {
            string[] myDateTimeString = PPDateofIssue.Split('/');
            PPDateofIssue = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (PPExpDate != "")
        {
            string[] myDateTimeString = PPExpDate.Split('/');
            PPExpDate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (VisaIssuedDate != "")
        {
            string[] myDateTimeString = VisaIssuedDate.Split('/');
            VisaIssuedDate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (VisaExpiryDate != "")
        {
            string[] myDateTimeString = VisaExpiryDate.Split('/');
            VisaExpiryDate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (Validity != "")
        {
            string[] myDateTimeString = Validity.Split('/');
            Validity = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }
        if (!string.IsNullOrEmpty(ID))
        {

            sqlstr = "update s_studentinfo set IsNatIndia='" + IsNative + "',Nationality='" + Nationality + "' where regno='" + ID + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
            if (strQueryStatus == "")
            {
                if (IsNative == "N")
                {
                    sqlstr = "sp_UpdateNationalityInfo " + "'" + ID + "','" + PassportNo.Replace("'", "''") + "'," + PPDateofIssue + ",'" + VisaNumber + "'," + PPExpDate + ",'" + VisaType + "'," + VisaIssuedDate + "," + VisaExpiryDate + ",'" + NoOfEntry + "'," + Validity + ",'" + Purpose + "','" + Remark + "','" + Userid + "'";
                    strQueryStatus = utl.ExecuteQuery(sqlstr);
                    if (strQueryStatus == "")
                        return "Updated";
                    else
                        return "Update Failed";
                }
                else
                {
                    return "Updated";
                }
            }
            else
            {
                return "Update Failed";
            }

        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string SaveAttachmentInfo(string id, string Title, string Description, string Filename)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);

        if (!string.IsNullOrEmpty(id))
        {

            sqlstr = "sp_UpdateAttachmentInfo " + "'" + id + "','" + Title.Replace("'", "''") + "','" + Description + "','" + Filename + "','" + Userid + "'";
            strQueryStatus = utl.ExecuteScalar(sqlstr);
            if (strQueryStatus != "")
                return strQueryStatus;
            else
                return "Update Failed";

        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string SaveConcessionFeesDetails(string query, string ConcessReason, string RegNo, string Concess)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        int AcademicID = Convert.ToInt32(HttpContext.Current.Session["AcademicID"]);
        sqlstr = "select count(*) from  s_studentconcession  where regno='" + RegNo + "' and isactive=1  and academicid=" + AcademicID + "";
        string iCount = utl.ExecuteScalar(sqlstr);

        sqlstr = "delete  from  s_studentconcession  where regno='" + RegNo + "' and academicid=" + AcademicID + "";
        utl.ExecuteQuery(sqlstr);

        strQueryStatus = utl.ExecuteQuery(query);
        if (strQueryStatus == "")
        {
            sqlstr = "update s_studentinfo set Concession='" + Concess + "',reason='" + ConcessReason + "' where regno='" + RegNo + "' and academicyear=" + AcademicID + "";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
        }
        sqlstr = "select count(*) from s_staffchildren where RegNo='" + RegNo + "'";
        string Icnt = Convert.ToString(utl.ExecuteScalar(sqlstr));
        if (Icnt != "" && Icnt != "0")
        {
            sqlstr = @"Update s set s.reason='Staff - ' +  e.staffname  from s_studentinfo s inner join s_studentconcession t on (T.regno=S.regno) inner join  s_staffchildren c on t.regno=c.regno  inner join e_staffinfo e on e.empcode=c.empcode where s.regno='" + RegNo + "'";
            strQueryStatus = utl.ExecuteQuery(sqlstr);
        }
        return "Updated";
    }

    [WebMethod]
    public static string DeleteAttachmentInfo(int StudAttachID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteAttachmentInfo " + "" + StudAttachID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeleteOldSchoolInfo(int StudOldSchID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteOldSchoolInfo " + "" + StudOldSchID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }
    [WebMethod]
    public static string DeleteHostelInfo(int HostelId)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteHostelInfo " + "" + HostelId + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    [WebMethod]
    public static string DeleteStaffChildrenInfo(int StudStaffID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteStaffChildrenInfo " + StudStaffID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    [WebMethod]
    public static string DeleteBroSisInfo(int StudRelID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteBroSisInfo " + StudRelID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    [WebMethod]
    public static string DeleteScholarshipInfo(int StudScholID)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        strQueryStatus = utl.ExecuteQuery("sp_DeleteStudScholarshipInfo " + StudScholID + "," + Userid + "");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    [WebMethod]
    public static string DeleteRelationshipInfo(int studentid, string type)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;

        strQueryStatus = utl.ExecuteQuery("sp_DeleteRelationshipInfo " + "" + studentid + ",'" + type + "'");
        if (strQueryStatus == "")
            return "Deleted";
        else
            return "Delete Failed";
    }

    [WebMethod]
    public static string GetModuleMenuId(string path, string UserId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetModuleMenuId '" + path + "'," + UserId;
        return utl.GetDatasetTable(query, "ModuleMenu").GetXml();
    }

    protected void txtTempAddress_TextChanged(object sender, EventArgs e)
    {
        txtPerAddress.Text = txtTempAddress.Text;
    }
}
