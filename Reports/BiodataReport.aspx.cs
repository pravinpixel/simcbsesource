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

public partial class Reports_BiodataReport : System.Web.UI.Page
{
    Utilities utl = new Utilities();
    public static int Userid = 0;
    public static int AcademicID = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.chkUser();
        if (Session["UserId"] != null)
        {
            Display();
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


        sqlstr = "select StaffId,EmpCode,StaffName,DOB,Nationality,Religion,Caste,Community,Height,IdMarks,TempAddr,AadhaarNo,PanCardNo,PhotoFile from Vw_GetBioData where IsActive=1";
        dsGet = utl.GetDataset(sqlstr);

        if (dsGet != null && dsGet.Tables.Count > 0 && dsGet.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsGet.Tables[0].Rows.Count; i++)
            {
                string strPhoto = "../Staffs/Uploads/ProfilePhotos/" + dsGet.Tables[0].Rows[i]["PhotoFile"].ToString();

                //StaffName and Dob Details [Logo and Heading] - Start
                stroption += @"<table class='formtc' width='100%'><tr><td height='120' align='center' class='tctext'><img src='../img/amalorpavam-tc-logotext.png' alt='' width='615' height='110' /></td></tr><tr><td align='center' valign='bottom' style='padding-top: 0px;'><span class='leave-title'>BIO - DATA</span></td></tr><tr><td  align='center' valign='bottom' style='padding-top: 0px;' height='10'></td></tr><tr><td height='30'><div class='user-details'> <div class='user-photo' ><img src='" + strPhoto + "' width='120' height='120' border='1px' /></div><table border='0' cellspacing='0' cellpadding='5' width='100%' class='leaveapp'><tr><td height='30' width='4%' class='leaveapp-brd-tl'>1</td><td class='leaveapp-brd-tl' width='30%'>Name in Full</td><td width='4%' class='leaveapp-brd-tl'>:</td><td width='62%' class='leaveapp-brd-tlr'>" + dsGet.Tables[0].Rows[i]["StaffName"].ToString() + "</td></tr><tr><td height='30' class='leaveapp-brd-tl'>2</td><td class='leaveapp-brd-tl'>Date of Birth</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGet.Tables[0].Rows[i]["DOB"].ToString() + "</td></tr>";
                //StaffName and Dob Details [Logo and Heading] - End


                //Name Details Display [Father Name,Monther Name and Spouse Name]-Start
                sqlquery_Names = "select SF.StaffFamilyId,SF.StaffId,SF.RelationShipId,RL.RelationShipName,SF.Name,SF.ContactNo from e_stafffamilyinfo SF inner join m_relationships RL on SF.RelationShipId=RL.RelationShipId where 1=1 and SF.IsActive=1 and RL.IsActive=1 and RL.RelationShipId IN(1,2,6,7) and SF.IsActive=1 and RL.IsActive=1 and SF.StaffId=" + dsGet.Tables[0].Rows[i]["StaffId"].ToString() + " order by RL.RelationShipId";
                dsGetNameDetails = utl.GetDataset(sqlquery_Names);

                //Name Available
                if (dsGetNameDetails != null && dsGetNameDetails.Tables.Count > 0 && dsGetNameDetails.Tables[0].Rows.Count > 0)
                {
                    for (int j = 0; j < dsGetNameDetails.Tables[0].Rows.Count; j++)
                    {
                        if (j == 0)
                        {
                            stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>3</td><td class='leaveapp-brd-tl'>Name of the Father</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                        }
                        else if (j == 1)
                        {
                            stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>4</td><td class='leaveapp-brd-tl'>Name of the Mother</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                        }

                        else if (j == 2)
                        {
                            stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>5</td><td class='leaveapp-brd-tl'>Name of the spouse, if Married</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGetNameDetails.Tables[0].Rows[j]["Name"].ToString() + "</td></tr>";
                        }
                    }
                }

               //Name Not Available
                else
                {
                    stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>3</td><td class='leaveapp-brd-tl'>Name of the Father</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>&nbsp;</td></tr><tr><td height='30' class='leaveapp-brd-tl'>4</td><td class='leaveapp-brd-tl'>Name of the Mother</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>&nbsp;</td></tr><tr><td height='30' class='leaveapp-brd-tl'>5</td><td class='leaveapp-brd-tl'>Name of the spouse, if Married</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>&nbsp;</td></tr>";
                }
                //Name Details Display [Father Name,Monther Name and Spouse Name]-End


                //Other Details [Nationality,Religion,Caste,Community] -Start
                stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>6</td><td class='leaveapp-brd-tl'>Nationality</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGet.Tables[0].Rows[i]["Nationality"].ToString() + "</td></tr><tr><td height='30' class='leaveapp-brd-tl'>7</td><td class='leaveapp-brd-tl'>Religion</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGet.Tables[0].Rows[i]["Religion"].ToString() + "</td></tr><tr><td height='30' class='leaveapp-brd-tl'>8</td><td class='leaveapp-brd-tl'>Caste</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGet.Tables[0].Rows[i]["Caste"].ToString() + "</td></tr><tr><td height='30' class='leaveapp-brd-tl'>9</td><td class='leaveapp-brd-tl'>Community</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGet.Tables[0].Rows[i]["Community"].ToString() + "</td></tr>";
                //Other Details [Nationality,Religion,Caste,Community] -End


                //Education Details Display-Start
                sqlquery_Education = "select StaffId,CourseCompleted,BoardOrUniv,YearOfCompletion from e_staffacademicinfo where StaffId=" + dsGet.Tables[0].Rows[i]["StaffId"].ToString() + " and IsActive=1";
                dsGetEducationDetails = utl.GetDataset(sqlquery_Education);

                stroption += @"<tr><td height='30' class='leaveapp-brd-tl' >10</td><td colspan='3' class='leaveapp-brd-tlr' >Educational Qualification</td></tr><tr><td height='30' class='leaveapp-brd-tl'>&nbsp;</td><td class='leaveapp-brd-tl'>&nbsp;</td><td class='leaveapp-brd-tl'>&nbsp;</td><td class='leaveapp-brd-tlr'><table width='100%' border='0' cellspacing='0' cellpadding='0' class='qualific'><tr bgcolor='#999999'><td width='10%' class='leaveapp-brd-tl'  >Sl.No</td><td width='20%' class='leaveapp-brd-tl'>Qualicfication</td><td width='51%' class='leaveapp-brd-tl'>Board of Exam</td><td width='19%' class='leaveapp-brd-tlr'>Year of Pass</td></tr>";

                //Education Details Available
                if (dsGetEducationDetails != null && dsGetEducationDetails.Tables.Count > 0 && dsGetEducationDetails.Tables[0].Rows.Count > 0)
                {
                    for (int j = 0; j < dsGetEducationDetails.Tables[0].Rows.Count; j++)
                    {
                        if (j != dsGetEducationDetails.Tables[0].Rows.Count - 1)
                        {
                            stroption += @"<tr><td class='leaveapp-brd-tl'>" + (j + 1).ToString() + "</td><td class='leaveapp-brd-tl'>" + dsGetEducationDetails.Tables[0].Rows[j]["CourseCompleted"].ToString() + "</td><td class='leaveapp-brd-tl'>" + dsGetEducationDetails.Tables[0].Rows[j]["BoardOrUniv"].ToString() + "</td><td class='leaveapp-brd-tlr'>" + dsGetEducationDetails.Tables[0].Rows[j]["YearOfCompletion"].ToString() + "</td></tr>";
                        }
                        else
                        {
                            stroption += @"<tr><td class='leaveapp-brd-tlb'>" + (j + 1).ToString() + "</td><td class='leaveapp-brd-tlb'>" + dsGetEducationDetails.Tables[0].Rows[j]["CourseCompleted"].ToString() + "</td><td class='leaveapp-brd-tlb'>" + dsGetEducationDetails.Tables[0].Rows[j]["BoardOrUniv"].ToString() + "</td><td class='leaveapp-brd-tlrb'>" + dsGetEducationDetails.Tables[0].Rows[j]["YearOfCompletion"].ToString() + "</td></tr>";
                        }
                    }
                }

                //Education Details Not Available
                else
                {
                    stroption += @"<tr><td class='leaveapp-brd-tlb'>&nbsp;</td><td class='leaveapp-brd-tlb'>&nbsp;</td><td class='leaveapp-brd-tlb'>&nbsp;</td><td class='leaveapp-brd-tlrb'>&nbsp;</td></tr>";
                }
                stroption += @"</table></td></tr>";
                //Education Details Display-End


                //Height measurement Details Display-Start
                stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>11</td><td class='leaveapp-brd-tl'>Exact height measurement in cm</td><td class='leaveapp-brd-tl'>&nbsp;</td><td class='leaveapp-brd-tlr'>" + dsGet.Tables[0].Rows[i]["Height"].ToString() + " cm</td></tr>";
                //Height measurement Details Display-End


                //Personal marks of identification Details Display-Start
                int chk = 0;
                string Content = dsGet.Tables[0].Rows[i]["IdMarks"].ToString();
                string[] IdMarks = Content.Split(';');

                if (IdMarks.Length > 0)
                {
                    foreach (string Id in IdMarks)
                    {
                        if (chk == 0)
                        {
                            chk = 1;
                            stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>12</td><td class='leaveapp-brd-tl'>Personal marks of identification</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>- &nbsp;" + Id + "</td></tr>";
                        }

                        else
                        {
                            stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>&nbsp;</td><td class='leaveapp-brd-tl'>&nbsp;</td><td class='leaveapp-brd-tl'>&nbsp;</td><td class='leaveapp-brd-tlr'>- &nbsp;" + Id + "</td></tr>";
                        }
                    }
                }

                else
                {
                    stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>12</td><td class='leaveapp-brd-tl'>Personal marks of identification</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>&nbsp;</td></tr>";
                }

                //Personal marks of identification Details Display-End



                //Other Details Display[Address,AatharNo,Pancard]-Start
                stroption += @"<tr><td height='30' class='leaveapp-brd-tl'>13</td><td class='leaveapp-brd-tl'>Residential Address</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>&nbsp;" + dsGet.Tables[0].Rows[i]["TempAddr"].ToString() + "</td></tr><tr><td height='30' class='leaveapp-brd-tl'>14</td><td class='leaveapp-brd-tl'> Aaadhar No.</td><td class='leaveapp-brd-tl'>:</td><td class='leaveapp-brd-tlr'>" + dsGet.Tables[0].Rows[i]["AadhaarNo"].ToString() + "</td></tr><tr><td height='30' class='leaveapp-brd-tlb'>15</td><td class='leaveapp-brd-tlb'>PAN No.</td><td class='leaveapp-brd-tlb'>:</td><td class='leaveapp-brd-tlrb'>" + dsGet.Tables[0].Rows[i]["PanCardNo"].ToString() + "</td></tr></table></div></td></tr><tr><td style='vertical-align: top; padding-top: 9px;' class='leave-staff' ><br />Sign of the Staff</td></tr><tr><td height='70' style='vertical-align: top;  padding-top: 9px;' class='leave-staff'><br />Sign of the Head of theInstitution with Seal</td></tr></table>";
                //Other Details Display[Address,AatharNo,Pancard] -End


                stroption += @"<p class='pagebreakhere' style='page-break-after: always; color: Red;'></p>";
            }
        }

        dvContent.Append(stroption);
        printContent.InnerHtml = dvContent.ToString();
    }



}