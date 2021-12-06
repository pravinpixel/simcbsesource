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

public partial class Staffs_StaffAttendance : System.Web.UI.Page
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
                BindGridView();

            }
        }
    }

    private DataSet GetDataTable()
    {
        Utilities utl = new Utilities();
        DataSet dts = new DataSet();
        DataSet dss = new DataSet();
        string query = "[sp_GetStaffAttendanceList]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", 1);
        cmd.Parameters.AddWithValue("@PageSize", 50);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@staffname", "");
        cmd.Parameters.AddWithValue("@Attdate", txtAttDate.Text);
        cmd.Parameters.AddWithValue("@AcademicID", HttpContext.Current.Session["AcademicID"].ToString());
        return utl.GetData(cmd, 1, "StaffAttendanceList", 50);
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
        boundField.DataField = dti.Tables[0].Columns["StaffId"].ColumnName;
        boundField.HeaderText = "EMP NO";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "StaffId";
        boundField.ItemStyle.CssClass = "StaffId";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Tables[0].Columns["EmpCode"].ColumnName;
        boundField.HeaderText = "EMP CODE";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "EmpCode";
        GridView1.Columns.Add(boundField);

        boundField = new BoundField();
        boundField.DataField = dti.Tables[0].Columns["StaffName"].ColumnName;
        boundField.HeaderText = "STAFF NAME";
        boundField.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
        boundField.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        boundField.HeaderStyle.CssClass = "sorting_mod";
        boundField.ItemStyle.CssClass = "staffname";
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


    [WebMethod]
    public static string GetSectionByClassID(int ClassID)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "sp_GetSectionByClass " + ClassID;
        return utl.GetDatasetTable(query, "SectionByClass").GetXml();

    }
    [WebMethod]
    public static string GetStaffAttendanceList(int pageIndex, string StaffName, string attdate)
    {

        Utilities utl = new Utilities();

        string query = "[sp_GetStaffAttendanceList]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", PageSize);
        cmd.Parameters.Add("@RecordCount", SqlDbType.Int, 4).Direction = ParameterDirection.Output;
        cmd.Parameters.AddWithValue("@StaffName", StaffName);
        cmd.Parameters.AddWithValue("@Attdate", attdate);
        cmd.Parameters.AddWithValue("@AcademicID", HttpContext.Current.Session["AcademicID"].ToString());
        return utl.GetData(cmd, pageIndex, "StaffAttendanceList", PageSize).GetXml();


    }

    [WebMethod]
    public static string UpdateStaffAttendance(string StaffId, string status, string AttDate, int userId)
    {
        Utilities utl = new Utilities();
        Userid = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
        if (AttDate != "")
        {
            string[] myDateTimeString = AttDate.Split('/');
            AttDate = "'" + myDateTimeString[2] + "/" + myDateTimeString[1] + "/" + myDateTimeString[0] + "'";
        }

        if (status == "forenoon")
        {
            string sqlstr = "select isnull(forenoon,0) from e_StaffAttendance where EmpId='" + StaffId + "' and AttDate=" + AttDate + "and AcademicID=" + HttpContext.Current.Session["AcademicID"] + "";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "")
            {
                utl.ExecuteQuery("insert into  e_StaffAttendance(EmpId,attdate,forenoon,userid,AcademicID)values('" + StaffId + "'," + AttDate + ",'true'," + userId + "," + HttpContext.Current.Session["AcademicID"] + ")");
                return "Inserted";

            }
            else
            {
                if (iCount == "True")
                {
                    utl.ExecuteQuery("update e_StaffAttendance set forenoon=null where AcademicID=" + HttpContext.Current.Session["AcademicID"] + "  and EmpId='" + StaffId + "' and attdate=" + AttDate + "");
                }
                else if (iCount == "False")
                {
                    utl.ExecuteQuery("update e_StaffAttendance set forenoon='true'where AcademicID=" + HttpContext.Current.Session["AcademicID"] + " and EmpId='" + StaffId + "' and attdate=" + AttDate + "");
                }


                return "Updated";
            }
        }
        else if (status == "afternoon")
        {
            string sqlstr = "select isnull(afternoon,0) from e_StaffAttendance where EmpId='" + StaffId + "' and AttDate=" + AttDate + " and AcademicID=" + HttpContext.Current.Session["AcademicID"] + "";
            string iCount = Convert.ToString(utl.ExecuteScalar(sqlstr));
            if (iCount == "")
            {
                utl.ExecuteQuery("insert into  e_StaffAttendance(EmpId,attdate,afternoon,userid,AcademicID)values('" + StaffId + "'," + AttDate + ",'true'," + userId + "," + HttpContext.Current.Session["AcademicID"] + ")");
                return "Inserted";

            }
            else
            {
                if (iCount == "True")
                {
                    utl.ExecuteQuery("update e_StaffAttendance set afternoon=null where AcademicID=" + HttpContext.Current.Session["AcademicID"] + " and  EmpId='" + StaffId + "' and attdate=" + AttDate + "");
                }
                else if (iCount == "False")
                {
                    utl.ExecuteQuery("update e_StaffAttendance set afternoon='true' where AcademicID=" + HttpContext.Current.Session["AcademicID"] + " and EmpId='" + StaffId + "' and attdate=" + AttDate + "");
                }


                return "Updated";
            }
        }
        else
        {
            return "Failed";
        }
    }
}