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
using Microsoft.Reporting.WebForms;
using System.Drawing.Printing;
using System.Drawing.Imaging;
using System.Text;


public partial class Reports_StaffList : System.Web.UI.Page
{
    Utilities utl = null;
    public static int Userid = 0;
    public static int AcademicID = 0;
    public static string UserName = string.Empty;
    private static int PageSize = 10;
    string sqlstr = "";

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
        }

    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            LOAD_RESULT();
        }

        catch (Exception ex)
        {
            //Response.Write("<script>alert('"+ex.Message+"')</script>");
            ClientScript.RegisterClientScriptBlock(this.GetType(), "bnn", "<script>jAlert('" + ex.Message + "')</script>");
        }
    }



    private void LOAD_RESULT()
    {
        utl = new Utilities();
        DataSet dsGetStaffID = new DataSet();
        string sqlstaffid;
        //sqlstaffid = "select StaffID from e_staffinfo where StaffID IN('653','298')";
        //dsGetStaffID = utl.GetDataset(sqlstaffid);

        sqlstaffid = "sp_stafflistreport '" + ddlType.SelectedValue + "','" + txtSearch.Text + "'";
        dsGetStaffID = utl.GetDataset(sqlstaffid);

        string strmaintable = string.Empty;

        //Declaration for string table for each details - START
        string tblpersonalinfo, tblacademic, tblfamilydet, tblnomineedet, tblmedicalrecords, tblservdetAPP, tblservdetSUBJ, tblservdetLANG, tblservdetRegularization, tblservdetInvigilation, tblservdetResignation, tblremarkdet, tblretriementdet, tblrelativestaffdet, tbleducation;


        if (dsGetStaffID != null && dsGetStaffID.Tables.Count > 0 && dsGetStaffID.Tables[0].Rows.Count > 0)
        {
            strmaintable = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Sl.No.</th><th>Name</th><th>Emp Code</th><th>DOB</th><th>DOJ</th><th>Sex</th><th>MotherTongue</th><th>Place of Birth</th><th>Religion</th><th>Nationality</th><th>Community</th><th>Caste</th><th>Marital Status</th><th>Permanent Address</th><th>Contact Address</th><th>Email Id</th><th>Phone No</th><th>Pan Card No</th><th>Mobile No</th><th>Aadhaar No</th><th>Date Of Retirement</th><th>Present Status</th><th>Ration Card</th><th>Smart Card</th><th>File No</th><th>Locker No</th><th>No. of Brothers</th><th>No. of Sisters</th><th>Blood Group</th><th>Disease /Allergy</th><th>Height</th><th>Weight</th><th>Emergency Ph.No</th><th>Family Doctor Name</th><th>Doctor Address</th><th>Doctor Ph.No</th><th>Identification Marks</th><th>Physically Handicapped</th><th>Bank Status</th><th>Bank Name</th><th>Branch Code</th><th>Acc No</th><th>EPF Code</th><th>Academic Details</th><th>Family Details</th><th>Nominee Details</th><th>Medical Remarks</th><th>ServiceDetails Intial Appoinments</th><th>ServiceDetails_Subjects</th><th>ServiceDetails_LanguageKnown</th><th>ServiceDetails_Regularization</th><th>ServiceDetails_Invigilation</th><th>ServiceDetails_Resignation</th><th>Remarks Details</th><th>Retriement Details</th><th>RelativeStaff Details</th><th>Education Details</th></tr></thead><tbody>";

            int k = 0;

            for (int i = 0; i < dsGetStaffID.Tables[0].Rows.Count; i++)
            {

                //PersonalDetails,Medical Details,BankDetails -START 

                tblpersonalinfo = string.Empty;
                DataSet dsGetStaffPersonalInfo = new DataSet();
                string sqlstaffpersonalinfo;
                sqlstaffpersonalinfo = "sp_GetStaffPersonalInfo " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffPersonalInfo = utl.GetDataset(sqlstaffpersonalinfo);

                if (dsGetStaffPersonalInfo != null && dsGetStaffPersonalInfo.Tables.Count > 0 && dsGetStaffPersonalInfo.Tables[0].Rows.Count > 0)
                {
                    for (int p = 0; p < dsGetStaffPersonalInfo.Tables[0].Rows.Count; p++)
                    {
                        k = k + 1;
                        tblpersonalinfo = "<td>" + (k).ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["StaffName"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["EmpCode"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["DOBFORMAT"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["DOJFORMAT"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["Sex"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["MotherTongue"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["PlaceOfBirth"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["ReligionName"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["Nationality"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["CommunityName"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["CasteName"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["MaritalStatus"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["PermAddress"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["ContactAddress"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["EmailId"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["PhoneNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["PanCardNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["MobileNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["AadhaarNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["DateOfRetirementFormat"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["PresentStatus"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["RationCardNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["SmartCardNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["FileNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["LockerNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["WorkingCount"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["SistersCount"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["BloodGroupName"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["Disorders"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["Height"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["Weight"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["EmergencyPhNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["Doctor"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["DocAddr"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["DocPhNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["IdMarks"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["HandicapDetails"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["BankStatus"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["BankName"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["BankBranchCode"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["AccNo"].ToString() + "</td><td>" + dsGetStaffPersonalInfo.Tables[0].Rows[p]["EPFCode"].ToString() + "</td>";
                    }

                }

                else
                {
                    tblpersonalinfo = "No Data";
                }

                //PersonalDetails,Medical Details,BankDetails -END                                 



                //AcademicDetails -START

                tblacademic = string.Empty;
                DataSet dsGetStaffAcademic = new DataSet();
                string sqlstaffacademic;
                sqlstaffacademic = "sp_GetStaffAcademicInfo " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffAcademic = utl.GetDataset(sqlstaffacademic);

                if (dsGetStaffAcademic != null && dsGetStaffAcademic.Tables.Count > 0 && dsGetStaffAcademic.Tables[0].Rows.Count > 0)
                {
                    tblacademic = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Course Completed</th><th>Board/University</th><th>Year Of Completion</th><th>Main Subject</th><th>Ancillary Subject</th><th>Certificate No</th><th>Submitted Date</th><th>Returned Date</th><th>Academic Type</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffAcademic.Tables[0].Rows.Count; p++)
                    {
                        tblacademic = tblacademic + "<tr><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["CourseCompleted"].ToString() + "</td><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["BoardOrUniv"].ToString() + "</td><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["YOCFORMAT"].ToString() + "</td><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["MainSubName"].ToString() + "</td><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["AncillarySubName"].ToString() + "</td><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["CertNo"].ToString() + "</td><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["SDFORMAT"].ToString() + "</td><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["RDFORMAT"].ToString() + "</td><td>" + dsGetStaffAcademic.Tables[0].Rows[p]["Type"].ToString() + "</td></tr>";
                    }

                    tblacademic = tblacademic + "</tbody></table>";
                }

                else
                {
                    tblacademic = "No Data";
                }

                //AcademicDetails -END

                //FamilyDetails -START

                tblfamilydet = string.Empty;
                DataSet dsGetStaffFamily = new DataSet();
                string sqlstafffamily;
                sqlstafffamily = "GetStaffFamilyById " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffFamily = utl.GetDataset(sqlstafffamily);

                if (dsGetStaffFamily != null && dsGetStaffFamily.Tables.Count > 0 && dsGetStaffFamily.Tables[0].Rows.Count > 0)
                {
                    tblfamilydet = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Name</th><th>Relationship</th><th>ContactNo</th><th>Occupation</th><th>Qualification</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffFamily.Tables[0].Rows.Count; p++)
                    {
                        tblfamilydet = tblfamilydet + "<tr><td>" + dsGetStaffFamily.Tables[0].Rows[p]["Name"].ToString() + "</td><td>" + dsGetStaffFamily.Tables[0].Rows[p]["RelationShipName"].ToString() + "</td><td>" + dsGetStaffFamily.Tables[0].Rows[p]["ContactNo"].ToString() + "</td><td>" + dsGetStaffFamily.Tables[0].Rows[p]["Occupation"].ToString() + "</td><td>" + dsGetStaffFamily.Tables[0].Rows[p]["Qualification"].ToString() + "</td></tr>";
                    }

                    tblfamilydet = tblfamilydet + "</tbody></table>";
                }

                else
                {
                    tblacademic = "No Data";
                }

                //FamilyDetails -END 


                //NomineeDetails -START
                tblnomineedet = string.Empty;
                DataSet dsGetStaffnominee = new DataSet();
                string sqlstaffnominee;
                sqlstaffnominee = "GetStaffNomineeById " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffnominee = utl.GetDataset(sqlstaffnominee);

                if (dsGetStaffnominee != null && dsGetStaffnominee.Tables.Count > 0 && dsGetStaffnominee.Tables[0].Rows.Count > 0)
                {
                    tblnomineedet = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Nominee Name</th><th>ContactNo</th><th>Relationship</th><th>Address</th><th>Nominee Type</th><th>Share%</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffnominee.Tables[0].Rows.Count; p++)
                    {
                        tblnomineedet = tblnomineedet + "<tr><td>" + dsGetStaffnominee.Tables[0].Rows[p]["Name"].ToString() + "</td><td>" + dsGetStaffnominee.Tables[0].Rows[p]["ContactNo"].ToString() + "</td><td>" + dsGetStaffnominee.Tables[0].Rows[p]["RelationshipName"].ToString() + "</td><td>" + dsGetStaffnominee.Tables[0].Rows[p]["Address"].ToString() + "</td><td>" + dsGetStaffnominee.Tables[0].Rows[p]["Type"].ToString() + "</td><td>" + dsGetStaffnominee.Tables[0].Rows[p]["Share"].ToString() + "</td></tr>";
                    }

                    tblnomineedet = tblnomineedet + "</tbody></table>";
                }

                else
                {
                    tblnomineedet = "No Data";
                }
                //NomineeDetails -END 


                //MedicalRemarks -START
                tblmedicalrecords = string.Empty;
                DataSet dsGetStaffmedicalrecords = new DataSet();
                string sqlstaffmedicalrecords;
                sqlstaffmedicalrecords = "sp_GetStaffMedicalRecords " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffmedicalrecords = utl.GetDataset(sqlstaffmedicalrecords);

                if (dsGetStaffmedicalrecords != null && dsGetStaffmedicalrecords.Tables.Count > 0 && dsGetStaffmedicalrecords.Tables[0].Rows.Count > 0)
                {
                    tblmedicalrecords = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Date</th><th>Reason</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffmedicalrecords.Tables[0].Rows.Count; p++)
                    {
                        tblmedicalrecords = tblmedicalrecords + "<tr><td>" + dsGetStaffmedicalrecords.Tables[0].Rows[p]["DateFormat"].ToString() + "</td><td>" + dsGetStaffmedicalrecords.Tables[0].Rows[p]["Reason"].ToString() + "</td></tr>";
                    }
                    tblmedicalrecords = tblmedicalrecords + "</tbody></table>";
                }

                else
                {
                    tblmedicalrecords = "No Data";
                }
                //MedicalRemarks -END 



                //ServiceDetails -START                

                //ServiceDetails_Intial Appoinments -START

                tblservdetAPP = string.Empty;
                DataSet dsGetStaffservdetAPP = new DataSet();
                string sqlstaffservdetAPP;
                sqlstaffservdetAPP = "sp_GetServiceAppDetails " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffservdetAPP = utl.GetDataset(sqlstaffservdetAPP);

                if (dsGetStaffservdetAPP != null && dsGetStaffservdetAPP.Tables.Count > 0 && dsGetStaffservdetAPP.Tables[0].Rows.Count > 0)
                {
                    tblservdetAPP = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Intital Joining Date</th><th>Designation</th><th>Department</th><th>Place Of Work</th><th>Subject Handling Type</th><th>Class Allocated</th><th>Mode</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffservdetAPP.Tables[0].Rows.Count; p++)
                    {
                        tblservdetAPP = tblservdetAPP + "<tr><td>" + dsGetStaffservdetAPP.Tables[0].Rows[p]["DOJ"].ToString() + "</td><td>" + dsGetStaffservdetAPP.Tables[0].Rows[p]["DesignationName"].ToString() + "</td><td>" + dsGetStaffservdetAPP.Tables[0].Rows[p]["DepartmentName"].ToString() + "</td><td>" + dsGetStaffservdetAPP.Tables[0].Rows[p]["PlaceOfWork"].ToString() + "</td><td>" + dsGetStaffservdetAPP.Tables[0].Rows[p]["SubHandling"].ToString() + "</td><td>" + dsGetStaffservdetAPP.Tables[0].Rows[p]["ClassName"].ToString() + "</td><td>" + dsGetStaffservdetAPP.Tables[0].Rows[p]["ModeName"].ToString() + "</td></tr>";
                    }

                    tblservdetAPP = tblservdetAPP + "</tbody></table>";
                }

                else
                {
                    tblservdetAPP = "No Data";
                }

                //ServiceDetails_Intial Appoinments -END 


                //ServiceDetails_Subjects -START

                tblservdetSUBJ = string.Empty;
                DataSet dsGetStaffservdetSUBJ = new DataSet();
                string sqlstaffservdetSUBJ;
                sqlstaffservdetSUBJ = "sp_GetStaffSubjectDetails " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffservdetSUBJ = utl.GetDataset(sqlstaffservdetSUBJ);

                if (dsGetStaffservdetSUBJ != null && dsGetStaffservdetSUBJ.Tables.Count > 0 && dsGetStaffservdetSUBJ.Tables[0].Rows.Count > 0)
                {
                    tblservdetSUBJ = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Subjects</th><th>Studied Upto</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffservdetSUBJ.Tables[0].Rows.Count; p++)
                    {
                        tblservdetSUBJ = tblservdetSUBJ + "<tr><td>" + dsGetStaffservdetSUBJ.Tables[0].Rows[p]["SubExperienceName"].ToString() + "</td><td>" + dsGetStaffservdetSUBJ.Tables[0].Rows[p]["StudiedUpto"].ToString() + "</td></tr>";
                    }

                    tblservdetSUBJ = tblservdetSUBJ + "</tbody></table>";
                }

                else
                {
                    tblservdetSUBJ = "No Data";
                }

                //ServiceDetails_Subjects -END 

                //ServiceDetails_Language -START

                tblservdetLANG = string.Empty;
                DataSet dsGetStaffservdetLANG = new DataSet();
                string sqlstaffservdetLANG;
                sqlstaffservdetLANG = "sp_GetStaffLangKnownDetails " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffservdetLANG = utl.GetDataset(sqlstaffservdetLANG);

                if (dsGetStaffservdetLANG != null && dsGetStaffservdetLANG.Tables.Count > 0 && dsGetStaffservdetLANG.Tables[0].Rows.Count > 0)
                {
                    tblservdetLANG = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Language Known</th><th>Read</th><th>Write</th><th>Speak</th></tr></thead><tbody>";
                    for (int p = 0; p < dsGetStaffservdetLANG.Tables[0].Rows.Count; p++)
                    {
                        tblservdetLANG = tblservdetLANG + "<tr><td>" + dsGetStaffservdetLANG.Tables[0].Rows[p]["LanguageName"].ToString() + "</td><td>" + dsGetStaffservdetLANG.Tables[0].Rows[p]["Read"].ToString() + "</td><td>" + dsGetStaffservdetLANG.Tables[0].Rows[p]["Write"].ToString() + "</td><td>" + dsGetStaffservdetLANG.Tables[0].Rows[p]["Speak"].ToString() + "</td></tr>";
                    }
                    tblservdetLANG = tblservdetLANG + "</tbody></table>";
                }

                else
                {
                    tblservdetLANG = "No Data";
                }

                //ServiceDetails_Language -END 

                //ServiceDetails_Regularization -START
                tblservdetRegularization = string.Empty;
                DataSet dsGetStaffservdetRegularization = new DataSet();
                string sqlstaffservdetRegularization;
                sqlstaffservdetRegularization = "sp_GetStaffCareerDetails " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffservdetRegularization = utl.GetDataset(sqlstaffservdetRegularization);

                if (dsGetStaffservdetRegularization != null && dsGetStaffservdetRegularization.Tables.Count > 0 && dsGetStaffservdetRegularization.Tables[0].Rows.Count > 0)
                {
                    tblservdetRegularization = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Date</th><th>Order No</th><th>Designation</th><th>Placeofwork</th><th>Probation Period</th><th>Completion Date</th><th>Completion Order</th><th>From</th><th>To</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffservdetRegularization.Tables[0].Rows.Count; p++)
                    {
                        tblservdetRegularization = tblservdetRegularization + "<tr><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["CSFORMAT"].ToString() + "</td><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["OrderNo"].ToString() + "</td><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["DesignationName"].ToString() + "</td><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["Placeofwork"].ToString() + "</td><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["ProbationPeriod"].ToString() + "</td><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["CompletionDateFormat"].ToString() + "</td><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["CompletionOrderNo"].ToString() + "</td><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["AcdFromDate"].ToString() + "</td><td>" + dsGetStaffservdetRegularization.Tables[0].Rows[p]["AcdToDate"].ToString() + "</td></tr>";
                    }
                    tblservdetRegularization = tblservdetRegularization + "</tbody></table>";
                }

                else
                {
                    tblservdetRegularization = "No Data";
                }

                //ServiceDetails_Regularization -END 


                //ServiceDetails_Invigilation -START
                tblservdetInvigilation = string.Empty;
                DataSet dsGetStaffservdetInvigilation = new DataSet();
                string sqlstaffservdetInvigilation;
                sqlstaffservdetInvigilation = "sp_GetStaffInvigilationDetails " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffservdetInvigilation = utl.GetDataset(sqlstaffservdetInvigilation);


                if (dsGetStaffservdetInvigilation != null && dsGetStaffservdetInvigilation.Tables.Count > 0 && dsGetStaffservdetInvigilation.Tables[0].Rows.Count > 0)
                {
                    tblservdetInvigilation = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Year</th><th>School</th><th>Place</th><th>Invigilation Type</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffservdetInvigilation.Tables[0].Rows.Count; p++)
                    {
                        tblservdetInvigilation = tblservdetInvigilation + "<tr><td>" + dsGetStaffservdetInvigilation.Tables[0].Rows[p]["Year"].ToString() + "</td><td>" + dsGetStaffservdetInvigilation.Tables[0].Rows[p]["SchoolName"].ToString() + "</td><td>" + dsGetStaffservdetInvigilation.Tables[0].Rows[p]["Place"].ToString() + "</td><td>" + dsGetStaffservdetInvigilation.Tables[0].Rows[p]["InvigilationType"].ToString() + "</td></tr>";
                    }

                    tblservdetInvigilation = tblservdetInvigilation + "</tbody></table>";
                }
                else
                {
                    tblservdetInvigilation = "No Data";
                }


                //ServiceDetails_Invigilation -END 

                //ServiceDetails_Resignation -START
                tblservdetResignation = string.Empty;
                DataSet dsGetStaffservdetResignation = new DataSet();
                string sqlstaffservdetResignation;
                sqlstaffservdetResignation = "sp_GetStaffResignDetails " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffservdetResignation = utl.GetDataset(sqlstaffservdetResignation);


                if (dsGetStaffservdetResignation != null && dsGetStaffservdetResignation.Tables.Count > 0 && dsGetStaffservdetResignation.Tables[0].Rows.Count > 0)
                {
                    tblservdetResignation = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Year</th><th>Reason</th><th>Certificate Issued On</th><th>Resigned On</th></tr></thead><tbody>";

                    for (int p = 0; p < dsGetStaffservdetResignation.Tables[0].Rows.Count; p++)
                    {
                        tblservdetResignation = tblservdetResignation + "<tr><td>" + dsGetStaffservdetResignation.Tables[0].Rows[p]["Year"].ToString() + "</td><td>" + dsGetStaffservdetResignation.Tables[0].Rows[p]["Reason"].ToString() + "</td><td>" + dsGetStaffservdetResignation.Tables[0].Rows[p]["CERTFORMAT"].ToString() + "</td><td>" + dsGetStaffservdetResignation.Tables[0].Rows[p]["RESFORMAT"].ToString() + "</td></tr>";
                    }
                    tblservdetResignation = tblservdetResignation + "</tbody></table>";
                }
                else
                {
                    tblservdetResignation = "No Data";
                }

                //ServiceDetails_Resignation -END 

                //ServiceDetails -END 


                //RemarksDetails -START
                tblremarkdet = string.Empty;
                DataSet dsGetStaffremarkdet = new DataSet();
                string sqlstaffremarkdet;
                sqlstaffremarkdet = "sp_GetStaffRemark " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffremarkdet = utl.GetDataset(sqlstaffremarkdet);

                if (dsGetStaffremarkdet != null && dsGetStaffremarkdet.Tables.Count > 0 && dsGetStaffremarkdet.Tables[0].Rows.Count > 0)
                {
                    tblremarkdet = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Date</th><th>Title</th><th>Reason</th></tr></thead><tbody>";
                    for (int p = 0; p < dsGetStaffremarkdet.Tables[0].Rows.Count; p++)
                    {
                        tblremarkdet = tblremarkdet + "<tr><td>" + dsGetStaffremarkdet.Tables[0].Rows[p]["RemarkDateFormat"].ToString() + "</td><td>" + dsGetStaffremarkdet.Tables[0].Rows[p]["RemarkTitle"].ToString() + "</td><td>" + dsGetStaffremarkdet.Tables[0].Rows[p]["Reason"].ToString() + "</td></tr>";
                    }
                    tblremarkdet = tblremarkdet + "</tbody></table>";
                }
                else
                {
                    tblremarkdet = "No Data";
                }

                //RemarksDetails -END 


                //RetriementDetails -START
                tblretriementdet = string.Empty;
                DataSet dsGetStaffretriementdet = new DataSet();
                string sqlstaffretriementdet;
                sqlstaffretriementdet = "sp_GetStaffRetire " + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString();
                dsGetStaffretriementdet = utl.GetDataset(sqlstaffretriementdet);

                if (dsGetStaffretriementdet != null && dsGetStaffretriementdet.Tables.Count > 0 && dsGetStaffretriementdet.Tables[0].Rows.Count > 0)
                {
                    tblretriementdet = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Retr.Date</th><th>Title</th><th>Reason</th></tr></thead><tbody>";
                    for (int p = 0; p < dsGetStaffretriementdet.Tables[0].Rows.Count; p++)
                    {
                        tblretriementdet = tblretriementdet + "<tr><td>" + dsGetStaffretriementdet.Tables[0].Rows[p]["RetirementDateFormat"].ToString() + "</td><td>" + dsGetStaffretriementdet.Tables[0].Rows[p]["RetirementTitle"].ToString() + "</td><td>" + dsGetStaffretriementdet.Tables[0].Rows[p]["RetirementReason"].ToString() + "</td></tr>";
                    }
                    tblretriementdet = tblretriementdet + "</tbody></table>";
                }

                else
                {
                    tblretriementdet = "No Data";
                }

                //RetriementDetails -END 

                //RelativeStaffDetails -START
                tblrelativestaffdet = string.Empty;
                DataSet dsGetStaffrelativestaffdet = new DataSet();
                string sqlstaffrelativestaffdet;

                sqlstaffrelativestaffdet = "sp_GetStaffRelationInfo " + "''" + "," + "''" + "," + "" + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString() + "";
                dsGetStaffrelativestaffdet = utl.GetDataset(sqlstaffrelativestaffdet);

                if (dsGetStaffrelativestaffdet != null && dsGetStaffrelativestaffdet.Tables.Count > 0 && dsGetStaffrelativestaffdet.Tables[0].Rows.Count > 0)
                {
                    tblrelativestaffdet = "<table border='1' cellspacing='0' cellpadding='0' ><thead><tr><th>Relation Name</th><th>Relationship</th></tr></thead><tbody>";
                    for (int p = 0; p < dsGetStaffrelativestaffdet.Tables[0].Rows.Count; p++)
                    {
                        tblrelativestaffdet = tblrelativestaffdet + "<tr><td>" + dsGetStaffrelativestaffdet.Tables[0].Rows[p]["RelationName"].ToString() + "</td><td>" + dsGetStaffrelativestaffdet.Tables[0].Rows[p]["Relationship"].ToString() + "</td></tr>";
                    }
                    tblrelativestaffdet = tblrelativestaffdet + "</tbody></table>";
                }

                else
                {
                    tblrelativestaffdet = "No Data";
                }

                //RelativeStaffDetails -END 


                tbleducation = string.Empty;
                string sqlstaffeducation = string.Empty;
                string staffeducation=string.Empty;
                sqlstaffeducation = "select dbo.[fn_getStaffCompleteQualification](" + dsGetStaffID.Tables[0].Rows[i]["StaffID"].ToString() + ")";
                staffeducation = utl.ExecuteScalar(sqlstaffeducation);
                if (staffeducation != "")
                {
                    tbleducation = staffeducation.ToString();
                }
                else
                {
                    tbleducation = "No Data";
                }

                //Main Table Append
                strmaintable = strmaintable + "<tr>" + tblpersonalinfo + "<td valign='top'>" + tblacademic + "</td><td valign='top'>" + tblfamilydet + "</td><td valign='top'>" + tblnomineedet + "</td><td valign='top'>" + tblmedicalrecords + "</td><td valign='top'>" + tblservdetAPP + "</td><td valign='top'>" + tblservdetSUBJ + "</td><td valign='top'>" + tblservdetLANG + "</td><td valign='top'>" + tblservdetRegularization + "</td><td valign='top'>" + tblservdetInvigilation + "</td><td valign='top'>" + tblservdetResignation + "</td><td valign='top'>" + tblremarkdet + "</td><td valign='top'>" + tblretriementdet + "</td><td valign='top'>" + tblrelativestaffdet + "</td><td valign='top'>" + tbleducation + "</td></tr>";

            }

            strmaintable = strmaintable + "</tbody></table>";

            dvCard.InnerHtml = strmaintable;

        }


    }
}