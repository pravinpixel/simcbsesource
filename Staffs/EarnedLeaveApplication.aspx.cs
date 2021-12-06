using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;

public partial class Staffs_EarnedLeaveApplication : System.Web.UI.Page
{
    Utilities utl = null;
    string sqlstr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        
        Master.chkUser();
        if (Session["UserId"] != null)
        {
           
            if (Request.Params["StaffLeaveId"] != null)
                hfStaffLeaveId.Value = Request.Params["StaffLeaveId"].ToString();

            else
                hfStaffLeaveId.Value = "";

            if (Request.Params["LeaveId"] != null)
                hfLeaveId.Value = Request.Params["LeaveId"].ToString();

            else
                hfLeaveId.Value = "";
        }
       
    }
    [WebMethod]
    public static string GetLeaveApproval(string StaffLeaveId, string LeaveId)
    {
        Utilities utl = new Utilities();
        DataSet ds = new DataSet();
        string query = "SP_GetStaffEarnedleaveDetails " + StaffLeaveId + "," + LeaveId;
        return utl.GetDatasetTable(query, "Staffleave").GetXml();

    }
    [WebMethod]
    public static string UpdateLeave(string Remarks,string NoofLeave,string StaffLeaveId)
    {
        Utilities utl = new Utilities();
        string sqlstr = "update e_staffleave set remarks='" + Remarks + "',LeaveGranted='" + NoofLeave + "',ApprovedBy='" + HttpContext.Current.Session["UserId"].ToString() + "' where staffleaveid='" + StaffLeaveId + "'";
        string retval =utl.ExecuteQuery(sqlstr);
        return retval;
        
    }
    
}