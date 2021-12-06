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
using System.Web.UI.HtmlControls;

public partial class Masters_GenerateFees : System.Web.UI.Page
{
    public static int Userid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }
        else
        {
            if (Request.Params["AddFrm"] != null)
            {
                if (Request.Params["AddFrm"] == "true")
                {
                    btnSubmit.Visible = true;
                }
                else
                {
                    btnSubmit.Visible = false;
                }
            }
            if (Request.Params["EditFrm"] != null)
            {
                if (Request.Params["EditFrm"] == "true")
                {
                    btnSubmit.Visible = true;
                }
                else
                {
                    btnSubmit.Visible = false;
                }
            }

            if (Request.Params["FeesCatHeadID"] != null && Request.Params["FeesCatHeadID"] != "")
                hfFeesCatHeadId.Value = Request.Params["FeesCatHeadID"].ToString();
            else
                hfFeesCatHeadId.Value = "0";

            if (Request.Params["FeesHeadID"] != null && Request.Params["FeesHeadID"] != "")
                hfFeesHeadId.Value = Request.Params["FeesHeadID"].ToString();
            else
                hfFeesHeadId.Value = "0";
            if (Request.Params["SchoolTypeID"] != null && Request.Params["SchoolTypeID"] != "")
                hfSchoolTypeId.Value = Request.Params["SchoolTypeID"].ToString();
            else
                hfSchoolTypeId.Value = "0";

            if (Request.Params["ClassID"] != null && Request.Params["ClassID"] != "")
                hfClassId.Value = Request.Params["ClassID"].ToString();
            else
                hfClassId.Value = "0";

            if (Request.Params["FeesCategoryID"] != null && Request.Params["FeesCategoryID"] != "")
                hfFeesCategoryId.Value = Request.Params["FeesCategoryID"].ToString();
            else
                hfFeesCategoryId.Value = "0";

            Utilities utl = new Utilities();

            DataSet dsfeescat = new DataSet();
            dsfeescat = utl.GetDataset("sp_getfeescategory " + hfFeesCategoryId.Value);
            if (dsfeescat != null && dsfeescat.Tables.Count > 0 && dsfeescat.Tables[0].Rows.Count > 0)
            {
                lblFeesCategoryName.Text = dsfeescat.Tables[0].Rows[0]["FeesCategoryName"].ToString();
            }
            else
            {
                lblFeesCategoryName.Text = "";
            }
            DataSet dsclass = new DataSet();
            dsclass = utl.GetDataset("sp_getclass " + hfClassId.Value);
            if (dsclass.Tables[0].Rows.Count > 0)
            {
                lblSchoolTypeName.Text = dsclass.Tables[0].Rows[0]["SchoolTypeName"].ToString();
                lblClassName.Text = dsclass.Tables[0].Rows[0]["ClassName"].ToString();
                lblFeesType.Text = dsclass.Tables[0].Rows[0]["FeesType"].ToString();
            }

            Userid = Convert.ToInt32(Session["UserId"]);
            hfUserId.Value = Userid.ToString();
            if (!IsPostBack)
            {
                BindGridView();
                utl = new Utilities();
                string Academicyear, academicid = "";
                Academicyear = utl.ExecuteScalar("  select top 1 (convert(varchar(4),year(startdate))+'-'+ convert(varchar(4),year(enddate))) from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
                if (Academicyear != "")
                {
                    lblAcademicyear.Text = "FEES STRUCTURE FOR THE ACADEMIC YEAR " + Academicyear.ToString();
                }
                academicid = utl.ExecuteScalar("select top 1 academicid from m_academicyear where academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
                if (academicid != "")
                {
                    hfAcademicYear.Value = academicid.ToString();
                }
                else
                {
                    hfAcademicYear.Value = "0";
                }
                DataTable dt = new DataTable();
                dt = utl.GetDataTable("select top 1 convert(varchar,startdate,121)startdate,convert(Varchar,enddate,121)enddate from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
                if (dt.Rows.Count > 0)
                {
                    hfStartDate.Value = dt.Rows[0]["startdate"].ToString();
                    hfEndDate.Value = dt.Rows[0]["enddate"].ToString();
                }

            }
        }
    }
    private DataTable GetDataTable()
    {
        Utilities utl = new Utilities();
        DataSet dts = new DataSet();
        DataTable dt = new DataTable();
        //dts = utl.GetDataset("sp_GetFeesCatHead " + hfFeesCatHeadId.Value);
        //string feesHeadid = "";
        //string formonth = "";
        //string amount = "";
        //if (dts.Tables[0].Rows.Count > 0)
        //{
        //    feesHeadid = dts.Tables[0].Rows[0]["FeesHeadID"].ToString();
        //    formonth = dts.Tables[0].Rows[0]["ForMonth"].ToString();
        //    amount = dts.Tables[0].Rows[0]["Amount"].ToString();
        //}
        if (hfFeesHeadId.Value != "" && hfFeesHeadId.Value != "0")
        {
            dt = utl.GetDataTable("sp_GetFeesHead " + hfFeesHeadId.Value + "");
        }
        else
        {
            dt = utl.GetDataTable("sp_GetUnBindFeesHead ");
        }


        DateTime dtStart = DateTime.Now, dtEnd = DateTime.Now;
        DataSet dsAc = new DataSet();
        dsAc = utl.GetDataset("  select top 1 startdate,enddate from m_academicyear where academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
        if (dsAc.Tables[0].Rows.Count > 0)
        {
            dtStart = Convert.ToDateTime(dsAc.Tables[0].Rows[0]["startdate"]);
            dtEnd = Convert.ToDateTime(dsAc.Tables[0].Rows[0]["enddate"]);
        }
        string month = "";
        for (int i = 0; i < 12; i++)
        {
            if (i == 0)
            {
                month = dtStart.ToString("MMM");
            }
            else
            {
                month = dtStart.AddMonths(i).ToString("MMM");
            }
            dt.Columns.Add(month, typeof(string));
        }
        dt.Columns.Add("Amount", typeof(string));

        return dt;
    }

    private void BindGridView()
    {
        var dti = GetDataTable();
        //dti.Columns.Remove("userid");
        GridView1.Columns.Clear();
        GridView1.ShowFooter = true;


        var boundField = new BoundField();

        boundField.DataField = dti.Columns[0].ColumnName;
        boundField.HeaderText = dti.Columns[0].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "FeesCatHeadID";
        boundField.ItemStyle.CssClass = "FeesCatHeadID";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Columns[1].ColumnName;
        boundField.HeaderText = dti.Columns[1].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "FeesHeadID";
        boundField.ItemStyle.CssClass = "FeesHeadID";
        GridView1.Columns.Add(boundField);


        boundField = new BoundField();
        boundField.DataField = dti.Columns[2].ColumnName;
        boundField.HeaderText = dti.Columns[2].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "FeesHeadName";
        GridView1.Columns.Add(boundField);



        for (int index = 3; index < dti.Columns.Count - 1; index++)
        {
            CreateCustomTemplateField(GridView1, dti.Columns[index].ToString());

        }
        for (int index = dti.Columns.Count - 1; index < dti.Columns.Count; index++)
        {
            CreateCustomTemplateField1(GridView1, dti.Columns[index].ToString());

        }

        GridView1.DataSource = dti;
        GridView1.DataBind();

    }

    private void CreateCustomTemplateField(GridView gv, string headerText)
    {
        var customField = new TemplateField();
        customField.HeaderTemplate = new CustomTemplate(DataControlRowType.Header, headerText);
        customField.ItemTemplate = new CustomTemplate(DataControlRowType.DataRow, headerText);
        customField.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
        customField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        customField.HeaderStyle.CssClass = "sorting_mod";
        gv.Columns.Add(customField);
    }
    private void CreateCustomTemplateField1(GridView gv, string headerText)
    {
        var customField = new TemplateField();
        customField.HeaderTemplate = new CustomTemplate1(DataControlRowType.Header, headerText);
        customField.ItemTemplate = new CustomTemplate1(DataControlRowType.DataRow, headerText);
        customField.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
        customField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        customField.HeaderStyle.CssClass = "sorting_mod";
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
                    var data = new HtmlInputCheckBox();
                    data.Attributes.Add("class", _headerText);
                    data.DataBinding += DataRowLiteral_DataBinding;
                    container.Controls.Add(data);
                    break;
            }
        }

        private void DataRowLiteral_DataBinding(object sender, EventArgs e)
        {
            var data = (HtmlInputCheckBox)sender;
            var row = (GridViewRow)data.NamingContainer;
            data.Checked = false;
        }
    }


    public class CustomTemplate1 : ITemplate
    {
        private DataControlRowType _rowType;
        private string _headerText;

        public CustomTemplate1(DataControlRowType rowType, string headerText)
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
                    data.DataBinding += DataRowLiteral_DataBinding;
                    data.Width = 75;
                    data.Attributes.Add("class", _headerText);
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

    [WebMethod]
    public static string SaveFees(string query, string type)
    {
        Utilities utl = new Utilities();
        string sqlstr = string.Empty;
        string strQueryStatus = string.Empty;
        string message = string.Empty;
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        string Value = "";
        strQueryStatus = utl.ExecuteQuery(query.Replace("|", "''"));
        if (strQueryStatus == "")
        {
            if (type == "Insert")
            {
                Value = "Inserted";
            }
            else if (type == "Update")
            {
                Value = "Updated";
            }
        }
        else
        {
            if (type == "Insert")
            {
                Value = "Insert Failed";
            }
            else if (type == "Update")
            {
                Value = "Update Failed";
            }

        }
        return Value;
    }

    [WebMethod]
    public static string GetFees(string feescatheadid, string feesheadid, string schooltypeid, string classid, string feescategoryid, string academicid)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetFeesCatHead " + feescatheadid + "," + feesheadid + "," + schooltypeid + "," + classid + "," + feescategoryid + "," + academicid + "";
        return utl.GetDatasetTable(query, "FeesCatHead").GetXml();
    }
    [WebMethod]
    public static string GetUnBindFees(int schooltypeid, int classid, int feescategoryid, int academicid)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetUnBindFeesHead " + schooltypeid + "," + classid + "," + feescategoryid + "," + academicid + "";
        return utl.GetDatasetTable(query, "UnBindFeesHead").GetXml();
    }


    [WebMethod]
    public static string GetMonths(string startdate, string enddate)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "select * from dbo.[fn_getMonth]( '" + startdate + "','" + enddate + "')";
        return utl.GetDatasetTable(query, "Months").GetXml();
    }
}