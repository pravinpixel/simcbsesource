using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Globalization;
using System.Text;
using System.IO;
public partial class Staffs_BioData : System.Web.UI.Page
{

    Utilities utl = new Utilities();
    public static int Userid = 0;
    public static int AcademicID = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] != null)
        {
            BindStaffName();
            BindDepartment();
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

    string stroption;
    StringBuilder dvContent = new StringBuilder();

    private void Display()
    {
        string sqlstr;
        DataSet dsGet = new DataSet();

        string sqlquery_Names;
        DataSet dsGetNameDetails = new DataSet();

        string sqlquery_Education;
        DataSet dsGetEducationDetails = new DataSet();

        string StaffID = string.Empty;
        string departmentid = string.Empty;

        sqlstr = "";
        if (ddlStaffName.SelectedIndex != 0 && ddlDepartment.SelectedIndex == 0)
        {
            StaffID = ddlStaffName.SelectedValue;
            sqlstr = "select EmpCode,StaffName,DOB,Nationality,Religion,Caste,Community,Height,IdMarks,TempAddr,AadhaarNo,PanCardNo,PhotoFile,StaffID from Vw_GetBioData where IsActive=1 and staffID='" + StaffID + "'  order by CONVERT(INT,empcode) ASC";
            dsGet = utl.GetDataset(sqlstr);
        }
        else if (ddlStaffName.SelectedIndex == 0 && ddlDepartment.SelectedIndex != 0)
        {
            departmentid = ddlDepartment.SelectedItem.Text;
            sqlstr = "select EmpCode,StaffName,DOB,Nationality,Religion,Caste,Community,Height,IdMarks,TempAddr,AadhaarNo,PanCardNo,PhotoFile,StaffID from Vw_GetBioData where IsActive=1 and DepartmentName='" + departmentid + "'  order by CONVERT(INT,empcode) ASC";
            dsGet = utl.GetDataset(sqlstr);
        }
        else if (ddlStaffName.SelectedIndex != 0 && ddlDepartment.SelectedIndex != 0)
        {
            departmentid = ddlDepartment.Text;
            sqlstr = "select EmpCode,StaffName,DOB,Nationality,Religion,Caste,Community,Height,IdMarks,TempAddr,AadhaarNo,PanCardNo,PhotoFile,StaffID from Vw_GetBioData where IsActive=1 and DepartmentName='" + departmentid + "' and staffID='" + StaffID + "'   order by CONVERT(INT,empcode) ASC";
            dsGet = utl.GetDataset(sqlstr);
        }
        else if (ddlStaffName.SelectedIndex == 0 && ddlDepartment.SelectedIndex == 0)
        {
            departmentid = ddlDepartment.Text;
            sqlstr = "select EmpCode,StaffName,DOB,Nationality,Religion,Caste,Community,Height,IdMarks,TempAddr,AadhaarNo,PanCardNo,PhotoFile,StaffID from Vw_GetBioData where IsActive=1    order by CONVERT(INT,empcode) ASC";
            dsGet = utl.GetDataset(sqlstr);
        }


        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {
                string strPhoto = "../Staffs/Uploads/ProfilePhotos/" + dsGet.Tables[0].Rows[i]["PhotoFile"].ToString().Trim();
                if (!File.Exists(Server.MapPath(strPhoto)))
                {
                    strPhoto = "../img/photo.jpg";
                }

                //StaffName and Dob Details [Logo and Heading] - Start            

                stroption += @"<table width='100%' border='0' cellspacing='0' cellpadding='2' style='font-family:Arial, Helvetica, sans-serif;font-size:12px;'><tr><td><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td colspan='2' align='center' valign='middle'><img src='../img/login-school-logo.png' alt='' width='615' height='110' /></td></tr><tr><td colspan='2' style='font-size:18px;'><div align='center'><b>Staff Bio - Data</b></div></td></tr> <tr><td colspan='2'><table width='100%' border='0' cellspacing='4' cellpadding='4' style='font-family:Arial, Helvetica, sans-serif;font-size:12px;border:1px solid #000;'> <tr><td width='2%'>1.</td><td width='18%'>Name in Full</td><td width='1%'><div align='center'>:</div></td><td width='39%'>" + dsGet.Tables[0].Rows[i]["StaffName"].ToString() + "</td><td width='40%' rowspan='9' style='text-align:center;'><img style='border-radius:15px;border:1px solid #eee;' src='" + strPhoto + "' alt='Profile Photo' width='114' height='114'/></td></tr><tr><td>2.</td><td>Date of Birth</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td></tr>";

                //StaffName and Dob Details [Logo and Heading] - End


                //Name Details Display [Father Name,Monther Name and Spouse Name]-Start
                sqlquery_Names = "select SF.StaffFamilyId,SF.StaffId,SF.RelationShipId,RL.RelationShipName,SF.Name,SF.ContactNo from e_stafffamilyinfo SF inner join m_relationships RL on SF.RelationShipId=RL.RelationShipId where 1=1 and SF.IsActive=1 and RL.IsActive=1 and RL.RelationShipId IN(1,2,6,7) and SF.IsActive=1 and RL.IsActive=1 and SF.StaffId=" + dsGet.Tables[0].Rows[i]["StaffID"].ToString() + " order by RL.RelationShipId";
                dsGetNameDetails = utl.GetDataset(sqlquery_Names);

                //Name Available
                if (dsGetNameDetails != null && dsGetNameDetails.Tables.Count > 0 && dsGetNameDetails.Tables[0].Rows.Count > 0)
                {
                    string fathername = "<tr><td>3.</td><td>Name of Father</td><td><div align='center'>:</div></td><td>&nbsp;</td></tr>";
                    string mothername = "<tr><td>4.</td><td>Name of Mother</td><td><div align='center'>:</div></td><td>&nbsp;</td></tr>";
                    string spousename = "<tr><td>5.</td><td>Name of the spouse, if Married</td><td><div align='center' valign='top'>:</div></td><td>&nbsp;</td></tr>";

                    for (int j = 0; j < dsGetNameDetails.Tables[0].Rows.Count; j++)
                    {
                        if (j == 0)
                        {
                            if (dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "" && dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Father")
                            {
                                fathername = "<tr><td>3.</td><td>Name of Father</td><td><div align='center'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }

                            if (dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "" && dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Mother")
                            {
                                mothername = "<tr><td>4.</td><td>Name of Mother</td><td><div align='center'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }

                            if ((dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "") && (dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Husband" || dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Wife"))
                            {
                                spousename = "<tr><td>5.</td><td>Name of the spouse, if Married</td><td><div align='center' valign='top'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }

                        }

                        if (j == 1)
                        {
                            if (dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "" && dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Father")
                            {
                                fathername = "<tr><td>3.</td><td>Name of Father</td><td><div align='center'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }

                            if (dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "" && dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Mother")
                            {
                                mothername = "<tr><td>4.</td><td>Name of Mother</td><td><div align='center'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }

                            if ((dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "") && (dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Husband" || dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Wife"))
                            {
                                spousename = "<tr><td>5.</td><td>Name of the spouse, if Married</td><td><div align='center' valign='top'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }

                        }


                        if (j == 2)
                        {

                            if (dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "" && dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Father")
                            {
                                fathername = "<tr><td>3.</td><td>Name of Father</td><td><div align='center'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }

                            if (dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "" && dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Mother")
                            {
                                mothername = "<tr><td>4.</td><td>Name of Mother</td><td><div align='center'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }

                            if ((dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != null && dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() != "") && (dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Husband" || dsGetNameDetails.Tables[0].Rows[j]["RelationShipName"].ToString() == "Wife"))
                            {
                                spousename = "<tr><td>5.</td><td>Name of the spouse, if Married</td><td><div align='center' valign='top'>:</div></td><td>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                            }
                        }


                    }

                    stroption += fathername + mothername + spousename;

                }

               //Name Not Available
                else
                {
                    stroption += @"<tr><td>3.</td><td>Name of Father</td><td><div align='center'>:</div></td><td>&nbsp;</td></tr><tr><td>4.</td><td>Name of Mother</td><td><div align='center'>:</div></td><td>&nbsp;</td></tr><tr><td>5.</td><td>Name of the spouse, if Married</td><td><div align='center'>:</div></td><td>&nbsp;</td></tr>";
                }
                //Name Details Display [Father Name,Monther Name and Spouse Name]-End


                //Other Details [Nationality,Religion,Caste,Community] -Start                
                stroption += @"<tr><td>6.</td><td>Nationality</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["Nationality"].ToString() + "</td></tr><tr><td>7.</td><td>Religion</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["Religion"].ToString() + "</td></tr> <tr><td>8.</td><td>Caste</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["Caste"].ToString() + "</td></tr><tr><td>9.</td><td>Community</td><td><div align='center'>:</div></td><td>" + dsGet.Tables[0].Rows[i]["Community"].ToString() + "</td></tr>";
                //Other Details [Nationality,Religion,Caste,Community] -End


                //Education Details Display-Start
                sqlquery_Education = "select StaffId,CourseCompleted,BoardOrUniv,YearOfCompletion from e_staffacademicinfo where StaffId=" + dsGet.Tables[0].Rows[i]["StaffID"].ToString() + " and IsActive=1 order by YearOfCompletion desc";
                dsGetEducationDetails = utl.GetDataset(sqlquery_Education);

                stroption += @"<tr>";


                //Education Details Available
                if (dsGetEducationDetails != null && dsGetEducationDetails.Tables.Count > 0 && dsGetEducationDetails.Tables[0].Rows.Count > 0)
                {
                    stroption += @"<td valign='top'>10.</td><td colspan='4' valign='top'>Educational Qualification&nbsp;&nbsp;&nbsp;&nbsp;: <br /><br /><table width='600' border='0' cellspacing='1' cellpadding='3' style='border:1px solid #ccc;font-family:Arial, Helvetica, sans-serif;font-size:11px;'><tr></tr><tr bgcolor='#eeeeee' style='background-color:#eee;'><td >Sl.No</td><td >Qualification</td><td>Board of Exam</td><td>Year of Pass</td></tr>";

                    for (int j = 0; j < dsGetEducationDetails.Tables[0].Rows.Count; j++)
                    {

                        stroption += @"<tr><td>" + (j + 1).ToString() + "</td><td>" + dsGetEducationDetails.Tables[0].Rows[j]["CourseCompleted"].ToString() + "</td><td>" + dsGetEducationDetails.Tables[0].Rows[j]["BoardOrUniv"].ToString() + "</td><td>" + dsGetEducationDetails.Tables[0].Rows[j]["YearOfCompletion"].ToString() + "</td></tr>";

                    }

                    stroption += @"</table></td>";
                }

                //Education Details Not Available
                else
                {
                    stroption += @" <td valign='top'>10.</td><td colspan='4' valign='top'>Educational Qualification&nbsp;&nbsp;&nbsp;&nbsp;: <br /><br /></td>";
                }

                stroption += @"</tr>";
                //Education Details Display-End


                //Height measurement Details Display-Start
                stroption += @"<tr><td>11.</td><td>Exact height (in CM)</td><td><div align='center' valign='top'>:</div></td><td colspan='2'>" + dsGet.Tables[0].Rows[i]["Height"].ToString() + " cm</td></tr>";
                //Height measurement Details Display-End


                //Personal marks of identification Details Display-Start
                int chk = 0;
                string Content = dsGet.Tables[0].Rows[i]["IdMarks"].ToString();
                string[] IdMarks = Content.Split(';');

                if (IdMarks.Length > 0)
                {
                    stroption += @" <tr><td>12.</td><td>Personal marks of identification</td><td><div align='center' valign='top'>:</div></td>";

                    foreach (string Id in IdMarks)
                    {
                        if (chk == 0)
                        {
                            chk = 1;
                            stroption += @"<td> &nbsp;" + Id + "<br>";
                        }

                        else
                        {
                            stroption += @" &nbsp;" + Id + "<br>";
                        }
                    }

                    stroption += @"</td></tr>";
                }

                else
                {
                    stroption += @" <tr><td>12.</td><td>Personal marks of identification</td><td><div align='center'>:</div></td><td>- &nbsp;</td></tr>";
                }

                //Personal marks of identification Details Display-End



                //Other Details Display[Address,AatharNo,Pancard]-Start 
                stroption += @"<tr><td>13.</td><td>Residential Address</td><td><div align='center' valign='top'>:</div></td><td colspan='2'>&nbsp;" + dsGet.Tables[0].Rows[i]["TempAddr"].ToString() + "</td></tr><tr><td>14.</td><td>Aadhaar No.</td><td><div align='center'>:</div></td><td colspan='2'>" + dsGet.Tables[0].Rows[i]["AadhaarNo"].ToString() + "</td></tr><tr><td>15.</td><td>PAN No.</td><td><div align='center'>:</div></td><td colspan='2'>" + dsGet.Tables[0].Rows[i]["PanCardNo"].ToString() + "</td></tr></table></td></tr> <tr><td colspan='2'><br /><br /><br /><br /></td></tr><tr><td width='50%'><b>Signature of the Staff<br /><br /><br /></b></td><td width='50%'><div align='right'><b>Signature of the Principal with Seal</b><br /><br /><br /></div></td></tr></table></td></tr></table>";
                //Other Details Display[Address,AatharNo,Pancard] -End


                stroption += "<p class='pagebreakhere' style='page-break-after: always; color: Red;'></p>";
            }
        }

        dvContent.Append(stroption);
        printContent.InnerHtml = dvContent.ToString();
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        ddlDepartment.SelectedIndex = 0;
        ddlStaffName.SelectedIndex = 0;
        printContent.InnerHtml = string.Empty;
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Display();
    }
}
