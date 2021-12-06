using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Data.SqlClient;
using System.Web.UI.HtmlControls;

public partial class Students_StudentAttendance : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    private static int PageSize = 50;
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
            hdnUserId.Value = Session["UserId"].ToString();
            if (!IsPostBack)
            {
                txtAttDate.Text = System.DateTime.Now.ToString("dd/MM/yyyy");
                BindClass();
                BindGridView();
               
            }
        }
    }

    private DataSet GetDataTable()
    {
        string attdate = "";
        if (txtAttDate.Text != "")
        {

            string[] myDateTimeString = txtAttDate.Text.ToString().Split('/');
            attdate = "" + myDateTimeString[0] + "-" + myDateTimeString[1] + "-" + myDateTimeString[2] + "";

        }
        Utilities utl = new Utilities();
        DataSet dts = new DataSet();
        DataSet dss = new DataSet();
        string query = "[sp_GetStudentAttendanceStudList]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", 1);
        cmd.Parameters.AddWithValue("@PageSize", 50);
        cmd.Parameters.AddWithValue("@regno", "");
        cmd.Parameters.AddWithValue("@classname", "");
        cmd.Parameters.AddWithValue("@Sectionname", "");
        cmd.Parameters.AddWithValue("@studentname", "");
        cmd.Parameters.AddWithValue("@Attdate", attdate);
        cmd.Parameters.AddWithValue("@AcademicId", HttpContext.Current.Session["AcademicID"].ToString());
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return utl.GetData(cmd, 1, "StudentAttendanceStudList", 50);
    }

    public void BindGridView()
    {
        var dti = GetDataTable();
        //dti.Columns.Remove("userid");
        GridView1.Columns.Clear();
        GridView1.ShowFooter = true;


        var boundField = new BoundField();

        boundField.DataField = dti.Tables[0].Columns["AttendanceID"].ColumnName;
        boundField.HeaderText = dti.Tables[0].Columns["AttendanceID"].ColumnName;
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "AttendanceID";
        boundField.ItemStyle.CssClass = "AttendanceID";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Tables[0].Columns["Regno"].ColumnName;
        boundField.HeaderText = "REG NO";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "RegNo";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Tables[0].Columns[4].ColumnName;
        boundField.HeaderText = "STUDENT NAME";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "stname";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Tables[0].Columns[5].ColumnName;
        boundField.HeaderText = "CLASS";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "class";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Tables[0].Columns[7].ColumnName;
        boundField.HeaderText = "SECTION";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "section";
        GridView1.Columns.Add(boundField);


        for (int index = dti.Tables[0].Columns.Count - 3; index < dti.Tables[0].Columns.Count - 1; index++)
        {
            CreateCustomTemplateField(GridView1, dti.Tables[0].Columns[index].ToString());

        }


        GridView1.DataSource = dti;
        GridView1.DataBind();

    }

    private void CreateCustomTemplateField(GridView gv, string headerText)
    {
        var customField = new TemplateField();
        customField.HeaderTemplate = new CustomTemplate(DataControlRowType.Header, headerText);
        customField.ItemTemplate = new CustomTemplate(DataControlRowType.DataRow, headerText);
        customField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        customField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        customField.HeaderStyle.CssClass = "sorting_mod";
        gv.Columns.Add(customField);
    }
    private void CreateCustomTemplateField1(GridView gv, string headerText)
    {
        var customField = new TemplateField();
        customField.HeaderTemplate = new CustomTemplate1(DataControlRowType.Header, headerText);
        customField.ItemTemplate = new CustomTemplate1(DataControlRowType.DataRow, headerText);
        customField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
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
                    header.Text = _headerText.ToUpper();
                    container.Controls.Add(header);
                    break;
                case DataControlRowType.DataRow:
                    var data = new HtmlInputCheckBox();
                    data.Attributes.Add("class", _headerText);
                    data.Attributes.Add("onchange", container.ID);
                    data.DataBinding += DataRowLiteral_DataBinding;
                    container.Controls.Add(data);
                    break;
            }
        }

        private void DataRowLiteral_DataBinding(object sender, EventArgs e)
        {
            var data = (HtmlInputCheckBox)sender;
            var row = (GridViewRow)data.NamingContainer;
            data.Checked = true;
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
                    header.Text = _headerText.ToUpper();
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
   
    protected void BindClass()
    {
        utl = new Utilities();
        DataSet dsClass = new DataSet();
        dsClass = utl.GetDataset("exec sp_GetStudentAttendanceClass");
        if (dsClass != null && dsClass.Tables.Count > 0 && dsClass.Tables[0].Rows.Count > 0)
        {
            ddlClass.DataSource = dsClass;
            ddlClass.DataTextField = "class";
            ddlClass.DataValueField = "classid";
            ddlClass.DataBind();
        }
        else
        {
            ddlClass.DataSource = null;
            ddlClass.DataTextField = "";
            ddlClass.DataValueField = "";
            ddlClass.DataBind();
        }
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
    public static string GetStudentAttendanceStudList(int pageIndex, string regNo, string Class, string Section, string studentName,string attdate)
    {
        if (attdate != "")
        {
            string[] myDateTimeString = attdate.ToString().Split('/');
            attdate = "" + myDateTimeString[2]  + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "";
        }
        Utilities utl = new Utilities();
        string query = "[sp_GetStudentAttendanceStudList]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.AddWithValue("@regno", regNo);
        cmd.Parameters.AddWithValue("@classname", Class);
        cmd.Parameters.AddWithValue("@sectionname", Section);
        cmd.Parameters.AddWithValue("@studentname", studentName);
        cmd.Parameters.AddWithValue("@Attdate", attdate);
        cmd.Parameters.AddWithValue("@AcademicId", HttpContext.Current.Session["AcademicID"].ToString());
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        return utl.GetData(cmd, pageIndex, "StudentAttendanceStudList", PageSize).GetXml();


    }


    [WebMethod]
    public static string UpdateStudentAttendance(string regno, string status, string AttDate, int userId)
    {
        Utilities utl = new Utilities();
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (AttDate != "")
        {
            string[] myDateTimeString = AttDate.Split('/');
            AttDate = "'" + myDateTimeString[2] + "-" + myDateTimeString[1] + "-" + myDateTimeString[0] + "'";
        }


        if (status == "forenoon")
        {
            string sqlstr = "select isnull(forenoon,0) from s_studentattendance where regno='" + regno + "' and AttDate=" + AttDate + " and AcademicId=" + HttpContext.Current.Session["ACademicID"] + "";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "")
            {
                utl.ExecuteQuery("insert into  s_studentattendance(regno,attdate,forenoon,userid,academicid)values('" + regno + "'," + AttDate + ",'true'," + userId + "," + HttpContext.Current.Session["ACademicID"] + ")");
                return "Inserted";

            }
            else
            {
                if (iCount == "True")
                {
                    utl.ExecuteQuery("update s_studentattendance set forenoon=null,modifieddate=getdate() where regno='" + regno + "' and academicid=" + HttpContext.Current.Session["ACademicID"] + " and attdate=" + AttDate + "");
                }
                else if (iCount == "False")
                {
                    utl.ExecuteQuery("update s_studentattendance set forenoon='true',modifieddate=getdate() where regno='" + regno + "'and academicid=" + HttpContext.Current.Session["ACademicID"] + " and attdate=" + AttDate + "");
                }
              

                return "Updated";
            }
        }
        else if (status == "afternoon")
        {
            string sqlstr = "select isnull(afternoon,0) from s_studentattendance where regno='" + regno + "' and AttDate=" + AttDate + " and AcademicId=" + HttpContext.Current.Session["ACademicID"] + "";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "")
            {
                utl.ExecuteQuery("insert into  s_studentattendance(regno,attdate,afternoon,userid,academicid)values('" + regno + "'," + AttDate + ",'true'," + userId + "," + HttpContext.Current.Session["ACademicID"] + ")");
                return "Inserted";

            }
            else
            {
                if (iCount == "True")
                {
                    utl.ExecuteQuery("update s_studentattendance set afternoon=null,modifieddate=getdate() where regno='" + regno + "' and academicid=" + HttpContext.Current.Session["ACademicID"] + " and attdate=" + AttDate + "");
                }
                else if (iCount == "False")
                {
                    utl.ExecuteQuery("update s_studentattendance set afternoon='true',modifieddate=getdate() where regno='" + regno + "' and academicid=" + HttpContext.Current.Session["ACademicID"] + " and attdate=" + AttDate + "");
                }


                return "Updated";
            }
        }
        else
        {
            return "Failed";
        }
    }

    [WebMethod]
    public static string GetStudent(string StudentName, string RegNo)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetStudentInfo " + "''"+",'" + RegNo + "','" + StudentName + "'";
        return utl.GetDatasetTable(query, "Student").GetXml();
    }

    [WebMethod]
    public static string GetDay(string Date)
    {
        if (Date != "")
        {
            string[] myDateTimeString = Date.ToString().Split('/');
            Date = "" + myDateTimeString[1] + "/" + myDateTimeString[0] + "/" + myDateTimeString[2] + "";
        }
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SELECT DATENAME(WEEKDAY,'" + Date + "') AS 'DAYNAME'";
        return utl.GetDatasetTable(query, "DayofWeek").GetXml();
    }
}