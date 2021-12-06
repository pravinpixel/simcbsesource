using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Globalization;

public partial class Staffs_LeaveEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.RequestType == "POST")
        {
            if (Request.Files["StaffLeave"] != null && Request.Files["StaffLeave"].ContentLength > 0
                && Request.Form["FileName"] != null && Request.Form["FileName"].Length > 0)
            {
                HttpPostedFile PostedFile = Request.Files["StaffLeave"];
                string fileName = Request.Form["FileName"].ToString();
                PostedFile.SaveAs(Server.MapPath("~/Staffs/Uploads/LeaveRecords/" + fileName));
            }
        }

        Master.chkUser();
        if (Session["UserId"] != null)
        {
            hdnUserId.Value = Session["UserId"].ToString();
            GetAccumulatedLeave(hdnStaffId.Value);
        }
        if (Request.QueryString["AcademicYear"] != null)
        {
            hdnAcd.Value = Request.QueryString["AcademicYear"].ToString();
        }
        BindDummyLeaves();
        BindLeaves();
    }

    private void BindLeaves()
    {
        Utilities utl = new Utilities();
        string sqlstr = "sp_GetLeave";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(sqlstr);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlLeave.DataSource = dt;
            ddlLeave.DataTextField = "LeaveName";
            ddlLeave.DataValueField = "LeaveId";
            ddlLeave.DataBind();
        }
        else
        {
            ddlLeave.DataSource = null;
            ddlLeave.DataBind();
        }
        ddlLeave.Items.Insert(0, new ListItem("--Select---", ""));
    }
    private void BindDummyLeaves()
    {
        HiddenField hdnID = (HiddenField)Page.Master.FindControl("hfViewPrm");

        if (hdnID.Value.ToLower() == "true")
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("StaffId");
          //  dummy.Columns.Add("AcademicYear");
            dummy.Columns.Add("EmpCode");
            dummy.Columns.Add("StaffName");
            dummy.Columns.Add("Leave");
            dummy.Columns.Add("Reason");
            dummy.Columns.Add("From");
            dummy.Columns.Add("To");
            dummy.Columns.Add("NoOfLeaves");
            dummy.Columns.Add("Uploads");
            dummy.Columns.Add("Status");

            dummy.Rows.Add();
            dgLeave.DataSource = dummy;
            dgLeave.DataBind();
        }
    }
    [WebMethod]
    public static string GetStaffInfo(string code, string name)
    {
        Utilities utl = new Utilities();
        if (string.IsNullOrEmpty(code)) code = "null"; else code = "'" + code + "'";
        if (string.IsNullOrEmpty(name)) name = "null"; else name = "'" + name.Replace("'", "''") + "'";
        string query = "[GetStaffInfo] " + code + ",'',''," + name + "";
        DataSet ds = utl.GetDatasetTable(query, "StaffInfo");
        return ds.GetXml();

    }

    private void GetAccumulatedLeave(string userId)
    {
        Utilities utl = new Utilities();

        string query = "select Accumulated,AvailableLeave from e_staffleave where StaffID='" + userId + "' and  academicyear='" +  Session["AcademicID"].ToString() + "'";
        DataSet ds = utl.GetDataset(query);
        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            lblElaccumulated.Text = ds.Tables[0].Rows[0]["Accumulated"].ToString();
            lblElaccumulatedcuryear.Text = ds.Tables[0].Rows[0]["AvailableLeave"].ToString();
        }
        else
        {
            lblElaccumulated.Text = "0";
            lblElaccumulatedcuryear.Text = "0";
        }
    }

    


    [WebMethod]
    public static string GetLeaveDetails(string staffId, string academicId, string staffLeaveId)
    {
        Utilities utl = new Utilities();
        string query = string.Empty;
        if (staffLeaveId == string.Empty)
            query = "[sp_GetStaffLeaveId] '" + staffId + "'," + academicId + ",''";
        else
            query = "[sp_GetStaffLeaveId] '',''," + staffLeaveId + "";

        return utl.GetDatasetTable(query, "Leave").GetXml();
    }
    [WebMethod]
    public static string GetEmployee(string staffName, string empCode)
    {
        Utilities utl = new Utilities();
        string query = "[sp_GetEmployee] '','" + staffName.Replace("'", "''") + "','" + empCode + "'";
        DataSet ds = utl.GetDatasetTable(query, "Employee");
        
        return ds.GetXml();
    }
    [WebMethod]
    public static string UpdateLeaveDetails(string staffId, string acdYear, string leaveId, string reason, string from, string to, string noOfLeave, string fileName, string filePath, string userId, string staffLeaveId)
    {
        string[] formats = { "dd/MM/yyyy" };
        string fFrom = DateTime.ParseExact(from, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string fTo = DateTime.ParseExact(to, formats, new CultureInfo("en-US"), DateTimeStyles.None).ToShortDateString();
        string fileExtension = fileName.Substring(fileName.LastIndexOf('.') + 1);

        if (string.IsNullOrEmpty(fFrom)) fFrom = "null"; else fFrom = "'" + fFrom + "'";
        if (string.IsNullOrEmpty(fTo)) fTo = "null"; else fTo = "'" + fTo + "'";
        if (string.IsNullOrEmpty(noOfLeave)) noOfLeave = "null"; else noOfLeave = "" + noOfLeave + "";
        if (string.IsNullOrEmpty(fileName)) fileName = "null"; else fileName = "'" + fileName + "'";
        if (string.IsNullOrEmpty(filePath)) filePath = "null"; else filePath = "'" + filePath + "'";
        if (string.IsNullOrEmpty(staffLeaveId)) staffLeaveId = "null"; else staffLeaveId = "'" + staffLeaveId + "'";
        if (string.IsNullOrEmpty(fileExtension)) fileExtension = "null"; else fileExtension = "'" + fileExtension + "'";
        string query = "[sp_UpdateStaffLeaveDetails] " + staffId + ",'" + acdYear + "'," + leaveId + ",'" + reason + "'," + fFrom + "," + fTo + "," + noOfLeave + "," + fileName + "," + filePath + "," + userId + "," + staffLeaveId + "," + fileExtension + ",0";
        string sqlstr = string.Empty;
        Utilities utl = new Utilities();
        sqlstr = utl.ExecuteScalar(query);
        if (sqlstr != string.Empty)
            return sqlstr;
        else
            return "";
    }
   
}