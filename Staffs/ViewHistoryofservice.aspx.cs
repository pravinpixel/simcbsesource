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
using System.Drawing.Printing;
using System.Drawing.Imaging;
using System.Text;
using System.Collections;


public partial class Staffs_ViewHistoryofservice : System.Web.UI.Page
{
    Utilities utl = new Utilities();
    public static int Userid = 0;
    public static int AcademicID = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        
        Master.chkUser();
        if (Session["UserId"] == null || Session["AcademicID"] == null)
        {
            Response.Redirect("Default.aspx?ses=expired");
        }

        else
        {            
            AcademicID = Convert.ToInt32(Session["AcademicID"]);
            Userid = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                BindStaffName();
                BindDepartment();
                BindBuilding();
            }
           
        }
    }

    private void BindStaffName()
    {
        Utilities utl = new Utilities();
        string query;
        query = "select distinct StaffName,StaffId from e_staffinfo where StaffId>1 and isactive=1 and presentstatus='Active' order by StaffName asc ";

        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);

        //ddlPlaceofwork.Items.Clear();
        //ddlPlaceofwork.Items.Add(new ListItem("-----Select-----", " "));

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlStaffName.DataSource = dt;
            ddlStaffName.DataTextField = "StaffName";
            ddlStaffName.DataValueField = "StaffId";
            ddlStaffName.DataBind();
        }
        else
        {
            ddlStaffName.DataSource = null;
            ddlStaffName.DataBind();
            ddlStaffName.SelectedIndex = -1;
        }

    }

    private void BindDepartment()
    {
        Utilities utl = new Utilities();
        string query;
        query = "select DepartmentId,DepartmentName from m_departments where IsActive=1";

        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);

        //ddlDepartment.Items.Clear();
        //ddlDepartment.Items.Add(new ListItem("-----Select-----", " "));

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

    private void BindBuilding()
    {
        Utilities utl = new Utilities();
        string query;
        query = "select BuildingID,Building from m_building where IsActive=1";
        DataTable dt = new DataTable();
        dt = utl.GetDataTable(query);
        
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlBuilding.DataSource = dt;
            ddlBuilding.DataTextField = "Building";
            ddlBuilding.DataValueField = "BuildingID";
            ddlBuilding.DataBind();
        }
        else
        {
            ddlBuilding.DataSource = null;
            ddlBuilding.DataBind();
            ddlBuilding.SelectedIndex = -1;
        }

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            Display_RESULT();
        }

        catch (Exception ex)
        {
            //Response.Write("<script>alert('"+ex.Message+"')</script>");
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "myfunction", "<script type='text/javascript'>jAlert('" + ex.Message + "','info');</script>", false);
        }
    }


    //Main Search Function
    string stroption;
    StringBuilder dvContent = new StringBuilder();
    DataSet dsGet = new DataSet();
    string sqlstr;

    private void Display_RESULT()
    {
        try
        {
            string StaffID = string.Empty;
            string departmentid = string.Empty;
            string buildingid = string.Empty;
            string staffname = "";
            string sqlquery_Leave;
            DataSet dsGetLeaveDetails = new DataSet();

            string sqlquery_Punishment;
            DataSet dsGetPunishmentDetails = new DataSet();

            string sqlquery_Resignation;
            DataSet dsGetResignationDetails = new DataSet();


            if (ddlStaffName.SelectedValue != "")
            {
                StaffID = ddlStaffName.SelectedValue;
            }

            if (ddlDepartment.SelectedValue != "")
            {
                departmentid = ddlDepartment.SelectedValue;
            }
            if (ddlBuilding.SelectedValue != "")
            {
                buildingid = ddlBuilding.SelectedValue;
            }


            sqlstr = "sp_getHistoryofService  " + AcademicID + ",'" + StaffID + "','" + departmentid + "','" + buildingid + "' ";
            dsGet = utl.GetDataset(sqlstr);

            if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
                {
                    staffname = dsGet.Tables[0].Rows[i]["StaffName"].ToString();
                    string profilephoto = utl.ExecuteScalar("select PhotoFile from e_staffinfo where StaffId='" + StaffID + "' ");

                    string strPhoto = "../Staffs/Uploads/ProfilePhotos/" + profilephoto;
                    if (!File.Exists(Server.MapPath(strPhoto)))
                    {
                        strPhoto = "../img/photo.jpg";
                    }
                                       
                    string Academicyear = utl.ExecuteScalar("select top 1 (convert(varchar(4),year(startdate))+'-'+ convert(varchar(4),year(enddate))) from m_academicyear where  academicid='" + Session["AcademicID"].ToString() + "' order by academicid desc");
                    string title = "HISTORY OF SERVICE ( " + Academicyear + " )";


                    stroption += @"<table width='100%' border='0' cellspacing='0' cellpadding='0' style='font-family:Arial, Helvetica, sans-serif;font-size:12px;'><tr><td colspan='2'><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td colspan='2' align='center' valign='middle'><img src='../img/login-school-logo.png' alt='' width='615' height='110' /></td></tr><tr><td colspan='3' style='font-size:18px;'><div align='center'><b>" + title + "</b></div></td></tr> <tr><td colspan='2'><table width='100%' border='0' cellspacing='4' cellpadding='3' style='font-family:Arial, Helvetica, sans-serif;font-size:12px;border:1px solid #000;'><tr><td colspan='5' style='background-color:#eee;font-size:14px;'><div align='center'><strong>STAFF DETAILS</strong></div></td></tr><tr><td width='2%'>1.</td><td width='18%'>Name of the Staff</td><td width='1%'><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["StaffName"].ToString() + "</td><td rowspan='5'><div align='center'><img style='border-radius:15px;border:1px solid #eee;' src='" + strPhoto + "' width='100' height='120'/></div></td></tr><tr><td>2.</td><td>Staff ID</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["EmpCode"].ToString() + "</td></tr><tr><td>3.</td><td>Designation</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["DesignationName"].ToString() + "</td></tr><tr><td>4</td><td>Residential Address</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["PermAddress"].ToString() + "</td></tr><tr><td>5.</td><td>Phone No.</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["PhoneNo"].ToString() + "</td></tr><tr><td>6.</td><td>Mobile No.</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["MobileNo"].ToString() + "</td></tr>";



                    //Service Details -START

                    sqlstr = "[sp_getServiceListDetails]  '" + StaffID + "','" + Session["AcademicID"] + "'";
                    DataSet dsService = new DataSet();
                    dsService = utl.GetDataset(sqlstr);
                    if (dsService != null && dsService.Tables.Count > 0 && dsService.Tables[0].Rows.Count > 0)
                    {
                        stroption += @"<tr><td colspan='5' style='background-color:#eee;font-size:14px;'><div align='center'><strong>SERVICE DETAILS</strong></div></td></tr><tr><td>7.</td><td>Order No.</td><td>:</td><td colspan='2'>" + dsService.Tables[0].Rows[0]["OrderNo"].ToString() + "</td></tr><tr><td>8.</td><td>Order Date </td><td>:</td><td colspan='2'>" + dsService.Tables[0].Rows[0]["AppoinmentDate"].ToString() + "</td></tr><tr><td  valign='top'>9.</td><td valign='top'>Description </td><td valign='top'>:</td><td colspan='2'>" + dsService.Tables[0].Rows[0]["Description"].ToString() + "</td></tr>";
                    }

                    else
                    {
                        stroption += @"<tr><td colspan='5' style='background-color:#eee;font-size:14px;'><div align='center'><strong>SERVICE DETAILS</strong></div></td></tr><tr><td>7.</td><td>Order No.</td><td>:</td><td colspan='2'>- NIL -</td></tr><tr><tr><td>8.</td><td>Order Date </td><td>:</td><td colspan='2'>- NIL -</td></tr><td  valign='top'>9.</td><td  valign='top'>Description </td><td  valign='top'>:</td><td colspan='2'>- NIL -</td></tr>";
                    }
                                   
                    //Service Details -END


                    //Salary Details -START                    

                    stroption += "<tr><td colspan='5'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='1' style='border:1px solid #ccc;font-family:Arial, Helvetica, sans-serif;font-size:12px;'><tr style='background-color:#eee;'><td colspan='13' style='font-size:14px;' ><div align='center'><strong>SALARY DETAILS</strong></div></td></tr> ";

                    string sqlquery = "";
                    sqlquery = "sp_getEmpSalaryList " + AcademicID + "," + dsGet.Tables[0].Rows[i]["EmpCode"].ToString() + "";
                    DataSet dsSal = new DataSet();
                    dsSal = utl.GetDataset(sqlquery);
                    if (dsSal != null && dsSal.Tables.Count > 0 && dsSal.Tables[0].Rows.Count > 0)
                    {
                        //Salary

                        stroption += "<tr style='background-color:#eee;'><td>Month</td>";
                        sqlquery = "sp_getsalaryheadlist ";
                        DataSet dssalary = new DataSet();
                        dssalary = utl.GetDataset(sqlquery);
                        if (dssalary != null && dssalary.Tables.Count > 0 && dssalary.Tables[0].Rows.Count > 0)
                        {
                            for (int k = 0; k < dssalary.Tables[0].Rows.Count; k++)
                            {
                                stroption += "<td><div align='center'>" + dssalary.Tables[0].Rows[k]["SalaryHeadName"].ToString() + "</div></td>";
                            }
                        }

                        stroption += "</tr>";

                        ArrayList al = new ArrayList();
                        string Chk = "";
                        for (int u = 0; u < dsSal.Tables[0].Rows.Count; u++)
                        {
                            string GetMonth = dsSal.Tables[0].Rows[u]["ForMonth"].ToString();

                            if (Chk != GetMonth && GetMonth != "")
                            {
                                if (al.Count == 0)
                                {
                                    DataRow[] drData = dsSal.Tables[0].Select("ForMonth='" + GetMonth + "'");
                                    stroption += "<tr ><td style='background-color:#eee;font-weight:bold;'>" + GetMonth + "</td>";
                                    for (int h = 0; h < drData.Length; h++)
                                    {
                                        stroption += "<td  style='border-top:1px  solid #ccc ; ' align='right'><div align='right'>" + Convert.ToString(Math.Round(Convert.ToDecimal(drData[h].ItemArray[4].ToString()), 0)) + "</div></td>";
                                    }
                                    stroption += "</tr>";
                                    Chk = GetMonth;
                                }
                                else if (al.Count > 0 && !al.Contains(GetMonth))
                                {
                                    DataRow[] drData = dsSal.Tables[0].Select("ForMonth='" + GetMonth + "'");
                                    stroption += "<tr><td style='background-color:#eee;font-weight:bold;'>" + GetMonth + "</td>";
                                    for (int h = 0; h < drData.Length; h++)
                                    {
                                        stroption += "<td  style='border-top:1px  solid #ccc ;' align='right'><div align='right'>" + Convert.ToString(Math.Round(Convert.ToDecimal(drData[h].ItemArray[4].ToString()), 0)) + "</div></td>";
                                    }
                                    stroption += "</tr>";
                                    Chk = GetMonth;
                                }

                                al.Add(GetMonth.ToString());
                            }
                        }

                        stroption += "<tr style='background-color:#eee;'><td><strong>Total</strong></td>";

                        string strsql = " select distinct SalaryHeadID from e_staffsalaryinfo where staffid='" + dsGet.Tables[0].Rows[i]["StaffID"].ToString() + "'";
                        DataTable dts = new DataTable();
                        dts = utl.GetDataTable(strsql);
                        if (dts.Rows.Count > 0)
                        {
                            for (int u = 0; u < dts.Rows.Count; u++)
                            {
                                string SalaryHead = dts.Rows[u]["SalaryHeadID"].ToString();
                                object sumObject;
                                sumObject = dsSal.Tables[0].Compute("Sum(Salary)", "SalaryHeadID='" + SalaryHead + "' and staffid='" + dsGet.Tables[0].Rows[i]["StaffID"].ToString() + "'");
                                stroption += "<td align='right'><div align='right'><strong>" + Convert.ToString(Math.Round(Convert.ToDecimal(sumObject.ToString()), 0)) + "</strong></div></td>";
                            }
                        }
                        stroption += "</tr>";
                        stroption += "</table></td></tr>";

                        if (dsService != null && dsService.Tables.Count > 0 && dsService.Tables[0].Rows.Count > 0)
                        {
                            if (dsService.Tables[0].Rows[0]["SalaryDescription"].ToString() != "")
                            {
                                stroption += "<tr><td  valign='top'>10.</td><td  valign='top'><div width='10px'>Salary Description <div> </td><td  valign='top'>:</td><td>" + dsService.Tables[0].Rows[0]["SalaryDescription"].ToString() + "</td><td  valign='top'>&nbsp;</td></tr>";
                            }
                            else
                            {
                                stroption += "<tr><td  valign='top'>10.</td><td  valign='top'>Salary Description </td><td  valign='top'>:</td><td colspan='2'>- NIL -</td></tr>";
                            }
                        }
                        else
                        {
                            stroption += "<tr><td  valign='top'>10.</td><td valign='top'>Salary Description </td><td  valign='top'>:</td><td colspan='2'>- NIL -</td></tr>";
                        }
                        stroption += "</table>";
                    }
                    else
                    {
                        stroption += "<tr><td align='center' colspan='8'>- NIL -</td></tr></table></td></tr>";
                        if (dsService != null && dsService.Tables.Count > 0 && dsService.Tables[0].Rows.Count > 0)
                        {
                            if (dsService.Tables[0].Rows[0]["SalaryDescription"].ToString() != "")
                            {
                                stroption += "<tr><td  valign='top'>10.</td><td  valign='top'><div width='10px'>Salary Description <div> </td><td  valign='top'>:</td><td>" + dsService.Tables[0].Rows[0]["SalaryDescription"].ToString() + "</td><td  valign='top'>&nbsp;</td></tr>";
                            }
                            else
                            {
                                stroption += "<tr><td  valign='top'>10.</td><td  valign='top'>Salary Description </td><td  valign='top'>:</td><td colspan='2'>- NIL -</td></tr>";
                            }
                        }
                        else
                        {
                            stroption += "<tr><td  valign='top'>10.</td><td  valign='top'>Salary Description </td><td  valign='top'>:</td><td colspan='2'>- NIL -</td></tr>";
                        }
                        stroption += "</table>";
                    }
                    
                  
                    //Salary Details -END
                 //   stroption += @"<br><br><br><br><br><br><table width='100%' border='0' cellspacing='4' cellpadding='3' style='font-family:Arial, Helvetica, sans-serif;font-size:12px;border:1px solid #000;'>";
                    //stroption += @"<tr><td align='center' colspan='8'><p class='pagebreakhere' style='mso-special-character:line-break;'></p></td></tr>";
                    //stroption += @"<tr><td align='center' colspan='8'><p class='pagebreakhere' style='mso-special-character:line-break;'></p></td></tr>";
                    //stroption += @"<tr><td align='center' colspan='8'><p class='pagebreakhere' style='mso-special-character:line-break;'></p></td></tr>";
                    stroption += @"<p class='pagebreakhere' style='page-break-after: always; color: Red;'></p>";

                    //Leave Details Display -Start

                    //stroption += @"</td></tr><tr><td colspan='2'><br/><table width='100%' border='0' cellspacing='4' cellpadding='3' style='font-family:Arial, Helvetica, sans-serif;font-size:12px;border:1px solid #000;'>";
                    //if (dsService != null && dsService.Tables.Count > 0 && dsService.Tables[0].Rows.Count > 0)
                    //{
                    //    if (dsService.Tables[0].Rows[0]["SalaryDescription"].ToString() != "")
                    //    {
                    //        stroption += "<tr><td  valign='top'>10.</td><td  valign='top'><div width='10px'>Salary Description <div> </td><td  valign='top'>:</td><td>" + dsService.Tables[0].Rows[0]["SalaryDescription"].ToString() + "</td><td  valign='top'>&nbsp;</td></tr>";
                    //    }
                    //    else
                    //    {
                    //        stroption += "<tr><td  valign='top'>10.</td><td  valign='top'>Salary Description </td><td  valign='top'>:</td><td colspan='2'>- NIL -</td></tr>";
                    //    }
                    //}
                    //else
                    //{
                    //    stroption += "<tr><td  valign='top'>10.</td><td  valign='top'>Salary Description </td><td  valign='top'>:</td><td colspan='2'>- NIL -</td></tr>";
                    //}



                    string getsqlstr = "sp_GetLeave";
                    DataTable dtsleave = new DataTable();
                    dtsleave=utl.GetDataTable(getsqlstr);
                    if (dtsleave.Rows.Count > 0)
                    {
                        for (int p = 0; p < dtsleave.Rows.Count; p++)
                        {
                            sqlquery_Leave = "select L.LeaveName,SL.Reason,convert(varchar(MAX),SL.LeaveFrom,103) as leavefrom,convert(varchar(MAX),SL.LeaveTo,103) as leaveto,sl.[NoOfLeaves/Hours] as NoofLeaves ,SL.AcademicYear  from e_staffleave SL inner join m_leave L on SL.LeaveId =L.LeaveId where SL.StaffId='" + dsGet.Tables[0].Rows[i]["StaffId"].ToString() + "' and SL.AcademicYear=" + AcademicID + " and SL.LeaveID='" + dtsleave.Rows[p]["LeaveId"].ToString() + "' and SL.IsActive=1 and SL.StatusId=1";

                            if (dtsleave.Rows[p]["LeaveName"].ToString().ToUpper() == "EARNED")
                            {
                                string ELAccumulated = string.Empty;
                                string ELAvailableLeave = string.Empty;
                                string ELtotal = string.Empty;

                                string ELleavequery = "select Accumulated,AvailableLeave from e_staffleaveallocation where staffId='" + dsGet.Tables[0].Rows[i]["StaffId"].ToString() + "' and AcademicID='" + Session["AcademicID"] + "' and LeaveID='" + dtsleave.Rows[p]["LeaveId"].ToString() + "' and Isactive=1";
                                DataSet dsELleave = utl.GetDataset(ELleavequery);
                               
                                if (dsELleave != null && dsELleave.Tables.Count > 0 && dsELleave.Tables[0].Rows.Count > 0)
                                {
                                    ELAccumulated = dsELleave.Tables[0].Rows[0]["Accumulated"].ToString();
                                    ELAvailableLeave = dsELleave.Tables[0].Rows[0]["AvailableLeave"].ToString();
                                    ELtotal = (Convert.ToInt32(ELAccumulated) + Convert.ToInt32(ELAvailableLeave)).ToString();
                                }

                                else
                                {
                                    ELAccumulated = "0";
                                    ELAvailableLeave = "0";
                                    ELtotal = "0";
                                }                                


                                stroption += @"<tr><td colspan='5'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='1' style='border:1px solid #ccc; font-family:Arial, Helvetica, sans-serif;font-size:12px;'><tr style='background-color:#eee;'><td colspan='6' style='font-size:14px;'><div align='center'><strong>" + dtsleave.Rows[p]["LeaveName"].ToString().ToUpper() + " LEAVE  DETAILS</strong></div></td></tr>";

                                stroption += @"<tr><td><div align='center'>a.</div></td><td colspan='4'><div align='left'>EL Accumulated</div></td><td align='center' >" + ELAccumulated + "</td></tr><tr><td ><div align='center'>b.</div></td><td colspan='4'><div align='left'>EL Sanctioned for...(Current Year)</div></td><td align='center'>" + ELAvailableLeave + "</td></tr><tr><td ><div align='center'>c.</div></td><td colspan='4'><div align='left'>EL Total (a+b)</div></td><td align='center'>" + ELtotal + "</td></tr>";


                                stroption += @"<tr style='background-color:#eee;'><td ><div align='center'>Sl. No</div></td><td ><div align='center'>Reason</div></td><td ><div align='center'>From</div></td><td ><div align='center'>To</div></td><td>&nbsp;</td><td><div align='center'>No. of Days</div></td></tr>";

                                DataSet dsEarnedLeave = new DataSet();
                                dsEarnedLeave = utl.GetDataset(sqlquery_Leave);
                                if (dsEarnedLeave != null && dsEarnedLeave.Tables.Count > 0 && dsEarnedLeave.Tables[0].Rows.Count > 0)
                                {
                                    for (int j = 0; j < dsEarnedLeave.Tables[0].Rows.Count; j++)
                                    {
                                        stroption += @"<tr><td><div align='center'>" + Convert.ToInt32(j + 1).ToString() + "</div></td><td ><div align='center'>" + dsEarnedLeave.Tables[0].Rows[j]["Reason"].ToString() + "</div></td><td ><div align='center'>" + dsEarnedLeave.Tables[0].Rows[j]["leavefrom"].ToString() + "</div></td><td><div align='center'>" + dsEarnedLeave.Tables[0].Rows[j]["leaveto"].ToString() + "</div></td><td>&nbsp;</td><td><div align='center'>" + dsEarnedLeave.Tables[0].Rows[j]["NoofLeaves"].ToString() + "</div></td></tr>";

                                    }                                   
                                }

                                else
                                {
                                   // stroption += @"<tr><td align='center' colspan='6'>- NIL -</td></tr>";
                                }

                                string strleave = "select isnull(sum(SL.[NoOfLeaves/Hours]),0) as noofleaves from e_staffleave SL inner join m_leave L on SL.LeaveId =L.LeaveId where SL.StaffId='" + dsGet.Tables[0].Rows[i]["StaffId"].ToString() + "' and SL.AcademicYear=" + AcademicID + " and SL.LeaveID='" + dtsleave.Rows[p]["LeaveId"].ToString() + "' and SL.IsActive=1 and SL.StatusId=1";
                                string totLeave = Convert.ToString(utl.ExecuteScalar(strleave));
                                string ELbalance = (Convert.ToInt32(ELtotal) - Convert.ToInt32(totLeave)).ToString();

                                stroption += @"<tr><td><div align='center'>d.</div></td><td ><div align='left'>EL Availed</div></td><td ><div align='center'>&nbsp;</div></td><td ><div align='center'>&nbsp;</div></td><td>&nbsp;</td><td><div  align='center'>" + totLeave + "</div></td></tr>";
                                stroption += @"<tr><td><div align='center'>e.</div></td><td ><div align='left'>EL Balance (c-d)</div></td><td ><div align='center'>&nbsp;</div></td><td ><div align='center'>&nbsp;</div></td><td>&nbsp;</td><td><div  align='center'>" + ELbalance + "</div></td></tr>";

                                stroption += @"</table></td></tr></table></td></tr>";
                            }
                            else
                            {
                                stroption += @"<tr><td colspan='5'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='1' style='border:1px solid #ccc; font-family:Arial, Helvetica, sans-serif;font-size:12px;'><tr style='background-color:#eee;'><td colspan='5' style='font-size:14px;'><div align='center'><strong>" + dtsleave.Rows[p]["LeaveName"].ToString().ToUpper() + " DETAILS</strong></div></td></tr>";

                                dsGetLeaveDetails = utl.GetDataset(sqlquery_Leave);
                                if (dsGetLeaveDetails != null && dsGetLeaveDetails.Tables.Count > 0 && dsGetLeaveDetails.Tables[0].Rows.Count > 0)
                                {
                                    stroption += @"<tr style='background-color:#eee;'><td ><div align='center'>Sl. No</div></td><td ><div align='center'>Reason</div></td><td ><div align='center'>From</div></td><td ><div align='center'>To</div></td><td><div align='center'>No. of Days</div></td></tr>";

                                    for (int j = 0; j < dsGetLeaveDetails.Tables[0].Rows.Count; j++)
                                    {
                                        stroption += @"<tr><td><div align='center'>" + Convert.ToInt32(j + 1).ToString() + "</div></td><td ><div align='center'>" + dsGetLeaveDetails.Tables[0].Rows[j]["Reason"].ToString() + "</div></td><td ><div align='center'>" + dsGetLeaveDetails.Tables[0].Rows[j]["leavefrom"].ToString() + "</div></td><td><div align='center'>" + dsGetLeaveDetails.Tables[0].Rows[j]["leaveto"].ToString() + "</div></td><td><div align='center'>" + dsGetLeaveDetails.Tables[0].Rows[j]["NoofLeaves"].ToString() + "</div></td></tr>";
                                        
                                    }
                                    string strleave = "select isnull(sum(SL.[NoOfLeaves/Hours]),0) as noofleaves from e_staffleave SL inner join m_leave L on SL.LeaveId =L.LeaveId where SL.StaffId='" + dsGet.Tables[0].Rows[i]["StaffId"].ToString() + "' and SL.AcademicYear=" + AcademicID + " and SL.LeaveID='" + dtsleave.Rows[p]["LeaveId"].ToString() + "' and SL.IsActive=1 and SL.StatusId=1";
                                    string totLeave = Convert.ToString(utl.ExecuteScalar(strleave));

                                    stroption += @"<tr><td>&nbsp;</td><td align='left' colspan='3'><b>Total</b></td><td><div align='center'>" + totLeave.ToString() + "</div></td></tr>";
                                    stroption += @"</table></td></tr>";
                                }

                                else
                                {
                                    stroption += @"<tr><td align='center' colspan='5'>- NIL -</td></tr></table></td></tr>";
                                }
                            }
                        }
                    }
                    
                    //Leave Details Display -END



                    //Punishment Details Display -Start
                   
                    sqlquery_Punishment = "select convert(varchar(MAX),SP.PunishDate,103)as PunishDate ,SC.OrderNo,SP.PunishReason from e_staffpunishment SP inner join e_staffcareerservice SC on SP.StaffId = SC.StaffId inner join m_academicyear AY on convert(varchar(4),year(SP.PunishDate)) = convert(varchar(4),year(AY.startdate)) where 1=1 and  SP.IsActive=1 and SC.IsActive=1 and AY.IsActive=1 and AY.AcademicId=" + AcademicID + " and SP.StaffId='" + dsGet.Tables[0].Rows[i]["StaffId"].ToString() + "'";

                    stroption += @"<tr><td colspan='5'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='1' style='border:1px solid #ccc;font-family:Arial, Helvetica, sans-serif;font-size:12px;'><tr style='background-color:#eee;'><td colspan='4' style='font-size:14px;'><div align='center'><strong>DISCIPLINARY ACTION</strong></div></td></tr>";

                    dsGetPunishmentDetails = utl.GetDataset(sqlquery_Punishment);
                    if (dsGetPunishmentDetails != null && dsGetPunishmentDetails.Tables.Count > 0 && dsGetPunishmentDetails.Tables[0].Rows.Count > 0)
                    {
                        stroption += @"<tr style='background-color:#eee;'><td ><div align='center'>Sl. No</div></td><td ><div align='center'>Date</div></td><td ><div align='center'>Order No</div></td><td ><div align='center'>Details</div></td></tr>";

                        for (int j = 0; j < dsGetPunishmentDetails.Tables[0].Rows.Count; j++)
                        {
                            stroption += @"<tr><td><div align='center'>" + Convert.ToInt32(j + 1).ToString() + "</div></td><td><div align='center'>" + dsGetPunishmentDetails.Tables[0].Rows[j]["PunishDate"].ToString() + "</div></td><td ><div align='center'>" + dsGetPunishmentDetails.Tables[0].Rows[j]["OrderNo"].ToString() + "</div></td><td ><div align='left'>" + dsGetPunishmentDetails.Tables[0].Rows[j]["PunishReason"].ToString() + "</div></td></tr>";
                        }
                        stroption += @"</table></td></tr>";
                    }

                    else
                    {
                        stroption += @"<tr><td align='center' colspan='4'>- NIL -</td></tr></table></td></tr>";
                    }

                    //Punishment Details Display -END

                    //Resignation Details Display -Start  
                  
                    sqlquery_Resignation = "select SR.StaffId,convert(varchar(MAX),SR.ResignDate,103)as ResignDate,SR.Reason from e_staffresign SR inner join m_academicyear AY on convert(varchar(4),year(SR.CreatedDate)) = convert(varchar(4),year(AY.startdate)) where 1=1 and AY.IsActive=1 and SR.IsActive=1 and AY.AcademicId =" + AcademicID + " and SR.StaffId='" + dsGet.Tables[0].Rows[i]["StaffId"].ToString() + "'";
                    dsGetResignationDetails = utl.GetDataset(sqlquery_Resignation);

                    stroption += @"<tr><td colspan='5'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='1' style='border:1px solid #ccc;font-family:Arial, Helvetica, sans-serif;font-size:12px;'><tr style='background-color:#eee;'><td colspan='2' style='font-size:14px;'><div align='center'><strong>RESIGNATION DETAILS</strong></div></td></tr>";

                    if (dsGetResignationDetails != null && dsGetResignationDetails.Tables.Count > 0 && dsGetResignationDetails.Tables[0].Rows.Count > 0)
                    {
                        stroption += @"<tr style='background-color:#eee;'><td width='20%'><div align='center'>Date of Resignation</div></td><td width='80%'><div align='center'>Reason</div></td></tr>";

                        for (int j = 0; j < dsGetResignationDetails.Tables[0].Rows.Count; j++)
                        { 
                            stroption += @"<tr><td width='20%'><div align='center'>" + dsGetResignationDetails.Tables[0].Rows[j]["Resigndate"].ToString() + "</div></td><td width='80%'><div align='center'>" + dsGetResignationDetails.Tables[0].Rows[j]["Reason"].ToString() + "</div></td></tr>";
                        }

                        stroption += @"</table></td></tr>";
                    }

                    else
                    {                        
                        stroption += @"<tr><td align='center' colspan='2'>- NIL -</td></tr></table></td></tr>";
                    }

                    //Resignation Details Display -END 

                    //General Remarks - START
                    stroption += @"<tr><td colspan='5'><table width='100%' border='0' align='center' cellpadding='3' cellspacing='1' style='border:1px solid #ccc;'><tr style='background-color:#eee;'><td style='font-size:14px;'><div align='center'><div align='center'><strong>GENERAL REMARKS</strong></div></div></td></tr><tr><td ><div align='left'><br /><br /><br /></div><div align='center'></div></td></tr><tr></tr></table></td></tr>";

                    //General Remarks - END

                    stroption += @"</table></td></tr><tr><td style='text-align: justify;' colspan='2'> <p>I, " + staffname + " hereby confirm that all the information  furnished above are true to the best of my knowledge and belief and in  acceptance to the same I affix my signature below.<br /><br /><br /><br /><br /></p></td></tr><tr><td width='50%'><b style='text-align: left;'>Signature of the Staff</b></td><td width='50%'><b style='padding-left: 325px'>Signature of the Principal with Seal</b><br /><br /><br /></td></tr></table>";
                                        
                    stroption += @"</td></tr></table><p class='pagebreakhere' style='page-break-after: always; color: Red;'></p>";

                }
            }

            dvContent.Append(stroption);
            printContent.InnerHtml = dvContent.ToString();
        }
        catch (Exception)
        {
            throw;
        }
    }



    
}