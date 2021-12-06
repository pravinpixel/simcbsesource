<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true" CodeFile="StaffList.aspx.cs" Inherits="Reports_StaffList" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("[id$=btnExport]").click(function (e) {
                window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=dvCard]').html()));
                e.preventDefault();
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <script type="text/javascript">
     function print() {

         $(".IDprint").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 15px 0px 20px;color:#000;font-family:Arial, Helvetica, sans-serif; font-size:5px; text-align: left; !important;'

            }
            , overrideElementCSS: [
                    '../css/layout.css',
                    { href: '../css/performance-print.css', media: 'print'}]
            });
     }

    </script>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Staff List Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">            
                        <table align="center">
                            <tr align="center">
                                <td width="200px">
                                    <asp:DropDownList ID="ddlType" runat="server">
                                        <asp:ListItem Value="">---Select Type---</asp:ListItem>
                                        <asp:ListItem Value="StaffName">Staff Name</asp:ListItem>
                                        <asp:ListItem Value="EmpCode">Emp Code</asp:ListItem>
                                        <asp:ListItem Value="Sex">Sex</asp:ListItem>
                                        <asp:ListItem Value="DOB">Date of Birth</asp:ListItem>                                        
                                        <asp:ListItem Value="DOJ">Date Of Joining</asp:ListItem>
                                        <asp:ListItem Value="MotherTongue">Mother Tongue</asp:ListItem>
                                        <asp:ListItem Value="PlaceOfBirth">Place Of Birth</asp:ListItem>
                                        <asp:ListItem Value="Religion">Religion</asp:ListItem>
                                         <asp:ListItem Value="Nationality">Nationality</asp:ListItem>
                                        <asp:ListItem Value="Community">Community</asp:ListItem>
                                        <asp:ListItem Value="Caste">Caste</asp:ListItem>
                                        <asp:ListItem Value="MaritalStatus">MaritalStatus</asp:ListItem>
                                        <asp:ListItem Value="PermAddress">Permanent Address</asp:ListItem>
                                         <asp:ListItem Value="ContactAddress">Contact Address</asp:ListItem>
                                        <asp:ListItem Value="EmailId">Email Id</asp:ListItem>
                                        <asp:ListItem Value="PhoneNo">Phone No</asp:ListItem>
                                        <asp:ListItem Value="PanCardNo">PanCardNo</asp:ListItem>
                                        <asp:ListItem Value="MobileNo">Mobile No</asp:ListItem>
                                         <asp:ListItem Value="AadhaarNo">Aadhaar No</asp:ListItem>
                                        <asp:ListItem Value="DateOfRetirement">Date Of Retirement</asp:ListItem>
                                         <asp:ListItem Value="PresentStatus">PresentStatus</asp:ListItem>
                                        <asp:ListItem Value="RationCardNo">RationCardNo</asp:ListItem>
                                        <asp:ListItem Value="SmartCardNo">SmartCardNo</asp:ListItem>
                                        <asp:ListItem Value="FileNo">FileNo</asp:ListItem>
                                        <asp:ListItem Value="LockerNo">LockerNo</asp:ListItem>
                                        <asp:ListItem Value="WorkingCount">Brothers Count</asp:ListItem>
                                        <asp:ListItem Value="SistersCount">Sister Count</asp:ListItem>
                                        <asp:ListItem Value="BloodGroup">BloodGroup</asp:ListItem>
                                        <asp:ListItem Value="Disorders">Disease /Allergy</asp:ListItem>
                                         <asp:ListItem Value="Weight">Weight</asp:ListItem>
                                        <asp:ListItem Value="Height">Height</asp:ListItem>
                                        <asp:ListItem Value="EmergencyPhNo">EmergencyPhNo</asp:ListItem>
                                        <asp:ListItem Value="Doctor">Family Doctor Name</asp:ListItem>
                                        <asp:ListItem Value="DocAddr">Doctor Address</asp:ListItem>
                                         <asp:ListItem Value="DocPhNo">Doctor Ph.No</asp:ListItem>
                                        <asp:ListItem Value="BankName">Bank Name</asp:ListItem>
                                        <asp:ListItem Value="BankBranchCode">Branch Code</asp:ListItem>
                                        <asp:ListItem Value="AccNo">AccNo</asp:ListItem>
                                        <asp:ListItem Value="EPFCode">EPFCode</asp:ListItem>
                                         <asp:ListItem Value="FamilyName">Family Person Name</asp:ListItem>
                                        <asp:ListItem Value="FamilyRelationship">Family Relationship</asp:ListItem>
                                        <asp:ListItem Value="FamilyContactno">Family Person Contactno</asp:ListItem>
                                        <asp:ListItem Value="FamilyOccupation">Family Person Occupation</asp:ListItem>
                                        <asp:ListItem Value="FamilyQualification">Family Person Qualification</asp:ListItem>
                                        <asp:ListItem Value="AcademicCourseCompleted">Course Completed</asp:ListItem>
                                        <asp:ListItem Value="AcademicBoardOrUniv">Board/University</asp:ListItem>
                                        <asp:ListItem Value="AcademicYearOfCompletion">Year Of Completion</asp:ListItem>
                                        <asp:ListItem Value="AcademicMainSubject">Main Subject</asp:ListItem>
                                        <asp:ListItem Value="AcademicAncillarySubject">Ancillary Subject</asp:ListItem>
                                         <asp:ListItem Value="AcademicCertificateNo">Certificate No</asp:ListItem>
                                        <asp:ListItem Value="AcademicSubmitedDate">Submitted Date</asp:ListItem>
                                        <asp:ListItem Value="AcademicReturnDate">Returned Date</asp:ListItem>
                                        <asp:ListItem Value="AcademicType">Academic Type</asp:ListItem>
                                        <asp:ListItem Value="NomineeName">Nominee Name</asp:ListItem>
                                         <asp:ListItem Value="NomineeContactNo">Nominee ContactNo</asp:ListItem>
                                        <asp:ListItem Value="NomineeRelationship">Nominee Relationship</asp:ListItem>
                                        <asp:ListItem Value="NomineeAddress">Nominee Address</asp:ListItem>
                                        <asp:ListItem Value="NomineeType">Nominee Type</asp:ListItem>
                                        <asp:ListItem Value="NomineeShare">Nominee Share(%)</asp:ListItem>
                                         <asp:ListItem Value="MedicalRecordsDate">Medical Records Date</asp:ListItem>
                                        <asp:ListItem Value="MedicalRecordsReason">Medical Records Reason</asp:ListItem>
                                        <asp:ListItem Value="ServAppInitialJoingDate">Date of Intital Joining</asp:ListItem>
                                        <asp:ListItem Value="ServAppDesignation">Appoinment Designation</asp:ListItem>
                                        <asp:ListItem Value="ServAppDepartment">Appoinment Department</asp:ListItem>
                                         <asp:ListItem Value="ServAppPlaceofwork">Place Of Work</asp:ListItem>
                                        <asp:ListItem Value="ServAppSubjectHandling">Subject Handling</asp:ListItem>
                                        <asp:ListItem Value="ServAppClassAllocated">Class Allocated</asp:ListItem>
                                        <asp:ListItem Value="ServAppMode">Mode</asp:ListItem>
                                        <asp:ListItem Value="ServSubjectName">Subject Name</asp:ListItem>
                                         <asp:ListItem Value="ServStudiedUpto">Studied Upto</asp:ListItem>
                                        <asp:ListItem Value="ServRegularizationDate">Regularization Date</asp:ListItem>
                                        <asp:ListItem Value="ServRegularizationOrderno">Regularization Orderno</asp:ListItem>
                                        <asp:ListItem Value="ServRegularizationDesignation">Regularization Designation</asp:ListItem>
                                        <asp:ListItem Value="ServRegularizationPlaceofwork">Regularization Placeofwork</asp:ListItem>
                                         <asp:ListItem Value="ServRegularizationProbationPeriod">Regularization ProbationPeriod</asp:ListItem>
                                        <asp:ListItem Value="ServRegularizationCompletionDate">Regularization CompletionDate</asp:ListItem>
                                        <asp:ListItem Value="ServRegularizationCompletionOrderNo">Regularization CompletionOrderNo</asp:ListItem>
                                        <asp:ListItem Value="ServRegularizationAccFrom">Regularization AccFrom</asp:ListItem>
                                        <asp:ListItem Value="ServRegularizationAccTo">Regularization AccTo</asp:ListItem>
                                        <asp:ListItem Value="ServInvigilationYear">Invigilation Year</asp:ListItem>
                                        <asp:ListItem Value="ServInvigilationSchoolName">Invigilation SchoolName</asp:ListItem>
                                        <asp:ListItem Value="ServInvigilationPlace">Invigilation Place</asp:ListItem>
                                        <asp:ListItem Value="ServInvigilationType">Invigilation Type</asp:ListItem>
                                        <asp:ListItem Value="ServResignationYear">Resignation Year</asp:ListItem>
                                        <asp:ListItem Value="ServResignationReason">Resignation Reason</asp:ListItem>
                                        <asp:ListItem Value="ServResignationCertificateIssued">Certificate Issued Date</asp:ListItem>
                                        <asp:ListItem Value="ServResignationDate">Resignation Date</asp:ListItem>
                                        <asp:ListItem Value="RemarkDate">Remark Date</asp:ListItem>
                                        <asp:ListItem Value="RemarkTitle">Remark Title</asp:ListItem>
                                        <asp:ListItem Value="RemarkReason">Remark Reason</asp:ListItem>
                                        <asp:ListItem Value="RetirementDate">Retirement Date</asp:ListItem>
                                        <asp:ListItem Value="RetirementTitle">Retirement Title</asp:ListItem>
                                        <asp:ListItem Value="Retirement Reason">Retirement Reason</asp:ListItem>
                                        <asp:ListItem Value="RelationName">Relation Staff Name</asp:ListItem>
                                        <asp:ListItem Value="Relationship">Staff Relationship</asp:ListItem>                                        
                                    </asp:DropDownList>
                                </td>

                                <td width="200px">                                  
                                    <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
                                </td>

                                <td width="200px">
                                   <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Show" 
                                        runat="server" onclick="btnSearch_Click" />&nbsp;
                                   <input type="button" id="btnExport" value="Export" class="btn-icon button-exprots" />
                                </td>
                            </tr>                            
                        </table>                   
           
           <br />

            <div style="overflow:scroll;">            
                        <table align="center">
                            <tr align="center">
                                <td>
                                    <div class="IDprint">
                                        <div id="dvCard" runat="server" class="staff-list-report">
                                        </div>
                                    </div>
            
                                </td>
                            </tr>                            
                        </table>                   
            </div>
 </div>
            

        </div>
    </div>


</asp:Content>

