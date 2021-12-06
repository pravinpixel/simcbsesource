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

public partial class Reports_StudentList : System.Web.UI.Page
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
        try
        {
            utl = new Utilities();
            DataSet dsGetStudentList = new DataSet();
            string sqlstudentRegno_list;
            //sqlstaffid = "select StaffID from e_staffinfo where StaffID IN('653','298')";
            //dsGetStaffID = utl.GetDataset(sqlstaffid);

            sqlstudentRegno_list = "sp_Studentlistreport '" + ddlType.SelectedValue + "','" + HttpContext.Current.Session["AcademicID"].ToString() + "','" + txtSearch.Text + "'";
            dsGetStudentList = utl.GetDataset(sqlstudentRegno_list);

            string strmaintable = string.Empty;

            //Declaration for string table for each details - START
            string tblpersonalinfo, tblguardiandet, tblbrothersisdet, tblmedicalremarksdet, tblscholarshipdet, tblacademicremarksdet, tblhosteldet, tblbusdet, tblconcessiondet, tbloldschooldet, tblnationalitydet;

            if (dsGetStudentList != null && dsGetStudentList.Tables.Count > 0 && dsGetStudentList.Tables[0].Rows.Count > 0)
            {
                strmaintable = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>S.No.</th><th>Student Name</th><th>Register No</th><th>Admission No</th><th>Sex</th><th>Class</th><th>Section</th><th>Date of Birth</th><th>Mother Tongue</th><th>Religion</th><th>Community</th><th>Caste</th><th>Aadhaar card</th><th>Temporary Address</th><th>Permanent Address</th><th>Email</th><th>Phone No</th><th>Date of Join</th><th>Smart Card No</th><th>Ration Card No</th><th>Admitted Class</th><th>Admitted Section</th><th>Date of Admission</th><th>Mode of Transport</th><th>Medium</th><th>First Language</th><th>Second language</th><th>Present Status</th><th>Father Name</th><th>Father Qualification</th><th>Father Occupation</th><th>Father Address</th><th>Father Income</th><th>Father Cell</th><th>Father Email</th><th>Mother Name</th><th>Mother Qualification</th><th>Mother Occupation</th><th>Mother Address</th><th>Mother Income</th><th>Mother Cell</th><th>Mother Email</th><th>Blood Group</th><th>Disease /Allergy</th><th>Height</th><th>Weight</th><th>Emergency Ph.No</th><th>Family Doctor Name</th><th>Doctor Address</th><th>Doctor Ph.No</th><th>Identification Marks</th><th>Physically Handicapped</th><th>HandicaptDetails</th><th>Guardian Details</th><th>Brother/Sister Details</th><th>MedicalRemarks Details</th><th>Scholarship Details</th><th>Academic Remarks Details</th><th>Hostel Details</th><th>Bus Details</th><th>Concession Details</th><th>Old-school Details</th></tr></thead><tbody>";

                int k = 0;
                for (int i = 0; i < dsGetStudentList.Tables[0].Rows.Count; i++)
                {
                    //PersonalDetails,Family Details,Academic Details -START
                    tblpersonalinfo = string.Empty;
                    DataSet dsGetStudPersInfo = new DataSet();
                    string sqlstudentpersonalinfo;
                    sqlstudentpersonalinfo = "sp_GetStudentInfo_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudPersInfo = utl.GetDataset(sqlstudentpersonalinfo);
                    if (dsGetStudPersInfo != null && dsGetStudPersInfo.Tables.Count > 0 && dsGetStudPersInfo.Tables[0].Rows.Count > 0)
                    {
                        for (int p = 0; p < dsGetStudPersInfo.Tables[0].Rows.Count; p++)
                        {
                            k = k + 1;
                            tblpersonalinfo = "<td>" + (k).ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["StudentName"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["RegNo"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["AdmissionNo"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Sex"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Class"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Section"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["DOB"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["MotherTongue"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Religion"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Community"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Caste"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["AadhaarNo"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["TempAddr"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["PerAddr"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Email"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["PhoneNo"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["DOJ"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["SmartCardNo"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["RationCardNo"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["AdClass"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["AdSection"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["DOA"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["TransportName"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Medium"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Firstlang"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Seclang"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Active"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["FName"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["FQual"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["FOccupation"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["FOccAddress"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["FIncome"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["FatherCell"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["FEmail"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["MName"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["MQual"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["MOccupation"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["MOccAddress"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["MIncome"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["MotherCell"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["MEmail"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["BloodGroup"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["DisOrders"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Height"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Weight"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["EmerPhNo"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Doctor"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["DocAddr"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["DocPhNo"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["IdMarks"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["Handicap"].ToString() + "</td><td>" + dsGetStudPersInfo.Tables[0].Rows[p]["HandicaptDetails"].ToString() + "</td>";

                        }
                    }

                    else
                    {
                        tblpersonalinfo = "No Data";
                    }

                    //PersonalDetails,Family Details,Academic Details -END


                    //Guardian Details -START

                    tblguardiandet = string.Empty;
                    DataSet dsGetStudGuardian = new DataSet();
                    string sqlstudguardianDet;
                    sqlstudguardianDet = "sp_GetStudGuardianList_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudGuardian = utl.GetDataset(sqlstudguardianDet);

                    if (dsGetStudGuardian != null && dsGetStudGuardian.Tables.Count > 0 && dsGetStudGuardian.Tables[0].Rows.Count > 0)
                    {
                        tblguardiandet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>Name</th><th>Qualification</th><th>Annual Income</th><th>Occupation</th><th>Email</th><th>ContactNo</th><th>Address</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudGuardian.Tables[0].Rows.Count; p++)
                        {
                            tblguardiandet = tblguardiandet + "<tr><td>" + dsGetStudGuardian.Tables[0].Rows[p]["GName"].ToString() + "</td><td>" + dsGetStudGuardian.Tables[0].Rows[p]["GQual"].ToString() + "</td><td>" + dsGetStudGuardian.Tables[0].Rows[p]["GInc"].ToString() + "</td><td>" + dsGetStudGuardian.Tables[0].Rows[p]["GOcc"].ToString() + "</td><td>" + dsGetStudGuardian.Tables[0].Rows[p]["GEmail"].ToString() + "</td><td>" + dsGetStudGuardian.Tables[0].Rows[p]["GPhno"].ToString() + "</td><td>" + dsGetStudGuardian.Tables[0].Rows[p]["GAddr"].ToString() + "</td></tr>";
                        }

                        tblguardiandet = tblguardiandet + "</tbody></table>";
                    }

                    else
                    {
                        tblguardiandet = "No Data";
                    }

                    //Guardian Details -END


                    //Brother-sister Details -START

                    tblbrothersisdet = string.Empty;
                    DataSet dsGetStudbrothersis = new DataSet();
                    string sqlstudbrothersisDet;
                    sqlstudbrothersisDet = "sp_GetStudbrosisList_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudbrothersis = utl.GetDataset(sqlstudbrothersisDet);

                    if (dsGetStudbrothersis != null && dsGetStudbrothersis.Tables.Count > 0 && dsGetStudbrothersis.Tables[0].Rows.Count > 0)
                    {
                        tblbrothersisdet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>S.No</th><th>RegNo</th><th>Relationship</th><th>Name</th><th>Class</th><th>Section</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudbrothersis.Tables[0].Rows.Count; p++)
                        {
                            tblbrothersisdet = tblbrothersisdet + "<tr><td>" + dsGetStudbrothersis.Tables[0].Rows[p]["SNO"].ToString() + "</td><td>" + dsGetStudbrothersis.Tables[0].Rows[p]["RegNo"].ToString() + "</td><td>" + dsGetStudbrothersis.Tables[0].Rows[p]["Relation"].ToString() + "</td><td>" + dsGetStudbrothersis.Tables[0].Rows[p]["StName"].ToString() + "</td><td>" + dsGetStudbrothersis.Tables[0].Rows[p]["ClassName"].ToString() + "</td><td>" + dsGetStudbrothersis.Tables[0].Rows[p]["SectionName"].ToString() + "</td></tr>";
                        }

                        tblbrothersisdet = tblbrothersisdet + "</tbody></table>";

                    }

                    else
                    {
                        tblbrothersisdet = "No Data";
                    }

                    //Brother-sister Details -END


                    //Medical Remarks Details -START

                    tblmedicalremarksdet = string.Empty;
                    DataSet dsGetStudMedicalRmrks = new DataSet();
                    string sqlstudMedicalRmrksDet;
                    sqlstudMedicalRmrksDet = "sp_GetStudMedicalRemarks_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudMedicalRmrks = utl.GetDataset(sqlstudMedicalRmrksDet);

                    if (dsGetStudMedicalRmrks != null && dsGetStudMedicalRmrks.Tables.Count > 0 && dsGetStudMedicalRmrks.Tables[0].Rows.Count > 0)
                    {
                        tblmedicalremarksdet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>S.No</th><th>Date</th><th>Reason</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudMedicalRmrks.Tables[0].Rows.Count; p++)
                        {
                            tblmedicalremarksdet = tblmedicalremarksdet + "<tr><td>" + dsGetStudMedicalRmrks.Tables[0].Rows[p]["SNO"].ToString() + "</td><td>" + dsGetStudMedicalRmrks.Tables[0].Rows[p]["Remarkdate"].ToString() + "</td><td>" + dsGetStudMedicalRmrks.Tables[0].Rows[p]["Description"].ToString() + "</td></tr>";
                        }

                        tblmedicalremarksdet = tblmedicalremarksdet + "</tbody></table>";

                    }

                    else
                    {
                        tblmedicalremarksdet = "No Data";
                    }

                    //Medical Remarks Details -END  


                    //Scholarship Details -START

                    tblscholarshipdet = string.Empty;
                    DataSet dsGetStudScholarship = new DataSet();
                    string sqlstudScholarshipDet;
                    sqlstudScholarshipDet = "sp_GetStudScholarship_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudScholarship = utl.GetDataset(sqlstudScholarshipDet);

                    if (dsGetStudScholarship != null && dsGetStudScholarship.Tables.Count > 0 && dsGetStudScholarship.Tables[0].Rows.Count > 0)
                    {
                        tblscholarshipdet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>S.No</th><th>Scholarship Name</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudScholarship.Tables[0].Rows.Count; p++)
                        {
                            tblscholarshipdet = tblscholarshipdet + "<tr><td>" + dsGetStudScholarship.Tables[0].Rows[p]["SNO"].ToString() + "</td><td>" + dsGetStudScholarship.Tables[0].Rows[p]["ScholarshipName"].ToString() + "</td></tr>";
                        }

                        tblscholarshipdet = tblscholarshipdet + "</tbody></table>";

                    }

                    else
                    {
                        tblscholarshipdet = "No Data";
                    }

                    //Scholarship Details -END  


                    //Academic Remarks Details -START

                    tblacademicremarksdet = string.Empty;
                    DataSet dsGetStudAcademicRmrks = new DataSet();
                    string sqlstudAcademicRmrksDet;
                    sqlstudAcademicRmrksDet = "sp_GetStudAcademicRemarks_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudAcademicRmrks = utl.GetDataset(sqlstudAcademicRmrksDet);

                    if (dsGetStudAcademicRmrks != null && dsGetStudAcademicRmrks.Tables.Count > 0 && dsGetStudAcademicRmrks.Tables[0].Rows.Count > 0)
                    {
                        tblacademicremarksdet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>S.No</th><th>Date</th><th>Remarks</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudAcademicRmrks.Tables[0].Rows.Count; p++)
                        {
                            tblacademicremarksdet = tblacademicremarksdet + "<tr><td>" + dsGetStudAcademicRmrks.Tables[0].Rows[p]["SNO"].ToString() + "</td><td>" + dsGetStudAcademicRmrks.Tables[0].Rows[p]["RemarkDate"].ToString() + "</td><td>" + dsGetStudAcademicRmrks.Tables[0].Rows[p]["Remarks"].ToString() + "</td></tr>";
                        }

                        tblacademicremarksdet = tblacademicremarksdet + "</tbody></table>";

                    }

                    else
                    {
                        tblacademicremarksdet = "No Data";
                    }

                    //Academic Remarks Details -END  

                    //Hostel Details -START

                    tblhosteldet = string.Empty;
                    DataSet dsGetStudHostelDet = new DataSet();
                    string sqlstudHostelDet;
                    sqlstudHostelDet = "sp_GetStudHostel_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudHostelDet = utl.GetDataset(sqlstudHostelDet);

                    if (dsGetStudHostelDet != null && dsGetStudHostelDet.Tables.Count > 0 && dsGetStudHostelDet.Tables[0].Rows.Count > 0)
                    {
                        tblhosteldet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>Hostel Name</th><th>Block Name</th><th>Room No</th><th>Admission Date</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudHostelDet.Tables[0].Rows.Count; p++)
                        {
                            tblhosteldet = tblhosteldet + "<tr><td>" + dsGetStudHostelDet.Tables[0].Rows[p]["HostelName"].ToString() + "</td><td>" + dsGetStudHostelDet.Tables[0].Rows[p]["BlockName"].ToString() + "</td><td>" + dsGetStudHostelDet.Tables[0].Rows[p]["RoomName"].ToString() + "</td><td>" + dsGetStudHostelDet.Tables[0].Rows[p]["AdmissionDate"].ToString() + "</td></tr>";
                        }

                        tblhosteldet = tblhosteldet + "</tbody></table>";

                    }

                    else
                    {
                        tblhosteldet = "No Data";
                    }

                    //Hostel Details -END  



                    //Bus Details -START

                    tblbusdet = string.Empty;
                    DataSet dsGetStudBusDet = new DataSet();
                    string sqlstudBusDet;
                    sqlstudBusDet = "sp_GetStudBus_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudBusDet = utl.GetDataset(sqlstudBusDet);

                    if (dsGetStudBusDet != null && dsGetStudBusDet.Tables.Count > 0 && dsGetStudBusDet.Tables[0].Rows.Count > 0)
                    {
                        tblbusdet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>Vehicle Code</th><th>BusRoute Name</th><th>BusRoute Code</th><th>Timings</th><th>BusCharge</th><th>DateofJoining</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudBusDet.Tables[0].Rows.Count; p++)
                        {
                            tblbusdet = tblbusdet + "<tr><td>" + dsGetStudBusDet.Tables[0].Rows[p]["VehicleCode"].ToString() + "</td><td>" + dsGetStudBusDet.Tables[0].Rows[p]["RouteName"].ToString() + "</td><td>" + dsGetStudBusDet.Tables[0].Rows[p]["RouteCode"].ToString() + "</td><td>" + dsGetStudBusDet.Tables[0].Rows[p]["Timings"].ToString() + "</td><td>" + dsGetStudBusDet.Tables[0].Rows[p]["BusCharge"].ToString() + "</td><td>" + dsGetStudBusDet.Tables[0].Rows[p]["Dateofjoining"].ToString() + "</td></tr>";
                        }

                        tblbusdet = tblbusdet + "</tbody></table>";
                    }

                    else
                    {
                        tblbusdet = "No Data";
                    }

                    //Bus Details -END


                    //Concession Details -START

                    tblconcessiondet = string.Empty;
                    DataSet dsGetStudConcessionDet = new DataSet();
                    string sqlstudConcessionDet;
                    sqlstudConcessionDet = "sp_GetStudConcession_Rpt '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudConcessionDet = utl.GetDataset(sqlstudConcessionDet);

                    if (dsGetStudConcessionDet != null && dsGetStudConcessionDet.Tables.Count > 0 && dsGetStudConcessionDet.Tables[0].Rows.Count > 0)
                    {
                        tblconcessiondet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>SNo</th><th>ConcessType</th><th>ConcessAmt</th><th>Reason</th><th>FeesHeadName</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudConcessionDet.Tables[0].Rows.Count; p++)
                        {
                            tblconcessiondet = tblconcessiondet + "<tr><td>" + dsGetStudConcessionDet.Tables[0].Rows[p]["SNO"].ToString() + "</td><td>" + dsGetStudConcessionDet.Tables[0].Rows[p]["ConcessType"].ToString() + "</td><td>" + dsGetStudConcessionDet.Tables[0].Rows[p]["ConcessAmt"].ToString() + "</td><td>" + dsGetStudConcessionDet.Tables[0].Rows[p]["Reason"].ToString() + "</td><td>" + dsGetStudConcessionDet.Tables[0].Rows[p]["FeesHeadName"].ToString() + "</td></tr>";

                        }

                        tblconcessiondet = tblconcessiondet + "</tbody></table>";
                    }

                    else
                    {
                        tblconcessiondet = "No Data";
                    }

                    //Concession Details -END


                    //Old-School Details -START

                    tbloldschooldet = string.Empty;
                    DataSet dsGetStudOldSchoolDet = new DataSet();
                    string sqlstudStudOldSchoolDet;
                    sqlstudStudOldSchoolDet = "sp_GetStudOldschoolInfo '" + dsGetStudentList.Tables[0].Rows[i]["RegNo"].ToString() + "'";
                    dsGetStudOldSchoolDet = utl.GetDataset(sqlstudStudOldSchoolDet);

                    if (dsGetStudOldSchoolDet != null && dsGetStudOldSchoolDet.Tables.Count > 0 && dsGetStudOldSchoolDet.Tables[0].Rows.Count > 0)
                    {
                        tbloldschooldet = "<table border='1' cellspacing='0' cellpadding='0'><thead><tr><th>S.No.</th><th>School Name</th><th>Academic Year</th><th>Std Studied</th><th>Ist Language</th><th>Medium</th><th>TC No</th><th>TC Date</th><th>TC Received Date</th></tr></thead><tbody>";

                        for (int p = 0; p < dsGetStudOldSchoolDet.Tables[0].Rows.Count; p++)
                        {
                            tbloldschooldet = tbloldschooldet + "<tr><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["SNO"].ToString() + "</td><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["SchoolName"].ToString() + "</td><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["Academicyear"].ToString() + "</td><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["StdStudied"].ToString() + "</td><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["Firstlanguage"].ToString() + "</td><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["Medium"].ToString() + "</td><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["TCNo"].ToString() + "</td><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["TCDate"].ToString() + "</td><td>" + dsGetStudOldSchoolDet.Tables[0].Rows[p]["TCReceivedDate"].ToString() + "</td></tr>";

                        }

                        tbloldschooldet = tbloldschooldet + "</tbody></table>";
                    }

                    else
                    {
                        tbloldschooldet = "No Data";
                    }

                    //Old-School Details -END


                    //Main Table Append     
                    strmaintable = strmaintable + "<tr>" + tblpersonalinfo + "<td valign='top'>" + tblguardiandet + "</td><td valign='top'>" + tblbrothersisdet + "</td><td valign='top'>" + tblmedicalremarksdet + "</td><td valign='top'>" + tblscholarshipdet + "</td><td valign='top'>" + tblacademicremarksdet + "</td><td valign='top'>" + tblhosteldet + "</td><td valign='top'>" + tblbusdet + "</td><td valign='top'>" + tblconcessiondet + "</td><td valign='top'>" + tbloldschooldet + "</td></tr>";

                }

                strmaintable = strmaintable + "</tbody></table>";
                dvCard.InnerHtml = strmaintable;
            }
        }

        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }
}