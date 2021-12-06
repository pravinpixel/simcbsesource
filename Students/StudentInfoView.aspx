<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StudentInfoView.aspx.cs"
    Inherits="StudentInfoView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/view.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
    <%="<link href='" + ResolveUrl("~/css/layout.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
    <script type="text/javascript">

        $(function () {
            var StudentID = $("[id*=hfStudentInfoID]").val();
            if (StudentID != "") {
                GetStudentInfo(StudentID);
            }
            else {
                GetStudentInfo(-1);
                var StudentInfos = "";

                row = $("[id*=dgRelationship] tr:last-child").clone(true);
                $("[id*=dgRelationship] tr").not($("[id*=dgRelationship] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a  href=\"javascript:EditRelationshipInfo('";
                    eanchorEnd = "');\">Edit</a>";
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteRelationshipInfo('";
                    danchorEnd = "');\">Delete</a>";
                }

                if (StudentInfos.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("");
                    $("td", row).eq(3).html("No Records Found").attr("align", "center");
                    $("td", row).eq(4).html("");
                    $("td", row).eq(5).html("");
                    $("td", row).eq(6).html("");
                    $("td", row).eq(7).html("");
                    $("td", row).eq(8).html("");
                    $("td", row).eq(9).html("");
                    // $("td", row).eq(10).html("");
                    $("[id*=dgRelationship]").append(row);
                    row = $("[id*=dgRelationship] tr:last-child").clone(true);

                }


                var BroSis = "";
                var row = $("[id*=dgBroSis] tr:last-child").clone(true);
                $("[id*=dgBroSis] tr").not($("[id*=dgBroSis] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a  href=\"javascript:EditBroSisInfo('";
                    eanchorEnd = "');\">Edit</a>";
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteBroSisInfo('";
                    danchorEnd = "');\">Delete</a>";
                }
                $("#chkBroSis").attr("checked", "false");
                showbrosis();
                if (BroSis.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("");
                    $("td", row).eq(3).html("No Records Found").attr("align", "center");
                    $("td", row).eq(4).html("");
                    $("td", row).eq(5).html("");
                    $("td", row).eq(6).html("").removeClass("editacc edit-links");
                    $("td", row).eq(7).html("").removeClass("deleteacc delete-links"); ;
                    $("[id*=dgBroSis]").append(row);
                    row = $("[id*=dgBroSis] tr:last-child").clone(true);

                }
                var staffchild = "";
                var row = $("[id*=dgInstitution] tr:last-child").clone(true);
                $("[id*=dgInstitution] tr").not($("[id*=dgInstitution] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a  href=\"javascript:EditStaffChildrenInfo('";
                    eanchorEnd = "');\">Edit</a>";
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteStaffChildrenInfo('";
                    danchorEnd = "');\">Delete</a>";
                }


                if (staffchild.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("No Records Found").attr("align", "center");
                    $("td", row).eq(3).html("").removeClass("editacc edit-links"); ;
                    $("td", row).eq(4).html("").removeClass("deleteacc delete-links"); ;
                    $("td", row).eq(5).html("");
                    $("[id*=dgInstitution]").append(row);
                    row = $("[id*=dgInstitution] tr:last-child").clone(true);

                }

                var MedRem = "";
                var row = $("[id*=dgMedRemarks] tr:last-child").clone(true);
                $("[id*=dgMedRemarks] tr").not($("[id*=dgMedRemarks] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a  href=\"javascript:EditMedRemarksInfo('";
                    eanchorEnd = "');\">Edit</a>";
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteMedRemarksInfo('";
                    danchorEnd = "');\">Delete</a>";
                }


                if (MedRem.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("");
                    $("td", row).eq(3).html("No Records Found").attr("align", "center");
                    $("td", row).eq(4).html("");
                    $("td", row).eq(5).html("").removeClass("deleteacc delete-links");
                    $("td", row).eq(6).html("");
                    $("[id*=dgMedRemarks]").append(row);
                    row = $("[id*=dgMedRemarks] tr:last-child").clone(true);

                }


                var MedRem = "";
                var row = $("[id*=dgAcademicRemarks] tr:last-child").clone(true);
                $("[id*=dgAcademicRemarks] tr").not($("[id*=dgAcademicRemarks] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a  href=\"javascript:EditAcademicRemarksInfo('";
                    eanchorEnd = "');\">Edit</a>";
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteAcademicRemarksInfo('";
                    danchorEnd = "');\">Delete</a>";
                }


                if (MedRem.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("No Records Found").attr("align", "left");
                    $("td", row).eq(3).html();
                    $("td", row).eq(4).html("").removeClass("deleteacc delete-links"); ;
                    $("[id*=dgAcademicRemarks]").append(row);
                    row = $("[id*=dgAcademicRemarks] tr:last-child").clone(true);

                }
                var BusRoutes = "";
                var row = $("[id*=dgBusRoute] tr:last-child").clone(true);
                $("[id*=dgBusRoute] tr").not($("[id*=dgBusRoute] tr:first-child")).remove();

                var danchor = ''
                var danchorEnd = '';

                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteBusRouteInfo('";
                    danchorEnd = "');\">Delete</a>";
                }

                if (BusRoutes.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("No Records").attr("align", "center");
                    $("td", row).eq(3).html("");
                    $("td", row).eq(4).html("");
                    $("td", row).eq(5).html("");
                    $("td", row).eq(6).html("").removeClass("deleteacc delete-links"); ;
                    $("[id*=dgBusRoute]").append(row);
                    row = $("[id*=dgBusRoute] tr:last-child").clone(true);

                }


                var oldschool = "";
                var row = $("[id*=dgOldSchool] tr:last-child").clone(true);
                $("[id*=dgOldSchool] tr").not($("[id*=dgOldSchool] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a  href=\"javascript:EditOldSchoolInfo('";
                    eanchorEnd = "');\">Edit</a>";
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteOldSchoolInfo('";
                    danchorEnd = "');\">Delete</a>";
                }


                if (oldschool.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("");
                    $("td", row).eq(3).html("");
                    $("td", row).eq(4).html("No Records Found").attr("align", "left");
                    $("td", row).eq(5).html("");
                    $("td", row).eq(6).html("");
                    $("td", row).eq(7).html("");
                    // $("td", row).eq(8).html("").removeClass("editacc edit-links"); ;
                    $("td", row).eq(8).html("").removeClass("deleteacc delete-links"); ;
                    $("td", row).eq(9).html("");
                    $("[id*=dgOldSchool]").append(row);
                    row = $("[id*=dgOldSchool] tr:last-child").clone(true);

                }

                var attachment = "";
                var row = $("[id*=dgAttachmentDetails] tr:last-child").clone(true);
                $("[id*=dgAttachmentDetails] tr").not($("[id*=dgAttachmentDetails] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a  href=\"javascript:EditAttachmentInfo('";
                    eanchorEnd = "');\">Edit</a>";
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteAttachmentInfo('";
                    danchorEnd = "');\">Delete</a>";
                }


                if (attachment.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("No Records Found").attr("align", "center");
                    $("td", row).eq(3).html("");
                    $("td", row).eq(4).html("").removeClass("deleteacc delete-links");
                    $("[id*=dgAttachmentDetails]").append(row);
                    row = $("[id*=dgAttachmentDetails] tr:last-child").clone(true);

                }
            }
        });


        function GetBusRouteDetails(ID) {
            var RegNo = $("[id*=hfRegNo]").val();
            if (ID == "0") {
                ID = "";
            }
            $.ajax({

                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetBusRouteInfo",
                data: '{"routecode": "' + ID + '","regno": "' + RegNo + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetBusRouteInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetBusRouteInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var BusRoutes = xml.find("BusRoutes");
            var row = $("[id*=dgBusRoute] tr:last-child").clone(true);
            $("[id*=dgBusRoute] tr").not($("[id*=dgBusRoute] tr:first-child")).remove();
            row.addClass("even");
            var danchor = ''
            var danchorEnd = '';

            if (BusRoutes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records").attr("align", "left");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");
                $("[id*=dgBusRoute]").append(row);
                row = $("[id*=dgBusRoute] tr:last-child").clone(true);

            }
            else {
                $.each(BusRoutes, function () {
                    var BusRoute = $(this);

                    $("td", row).eq(0).html($(this).find("VehicleCode").text());
                    $("td", row).eq(1).html($(this).find("BusRouteName").text());
                    $("td", row).eq(2).html($(this).find("BusRouteCode").text());
                    $("td", row).eq(3).html($(this).find("Timings").text());
                    $("td", row).eq(4).html($(this).find("BusCharge").text());
                    $("td", row).eq(5).html($(this).find("DateofRegistration").text());

                    var busroute = $(this).find("BusRouteCode").text();

                    $("[id*=lblRouteCode]").html(busroute);
                    $("[id*=lblDateofBusReg]").html($(this).find("DateofRegistration").text());
                    $("[id*=dgBusRoute] tr:has(td)").remove();
                    $("[id*=dgBusRoute]").append(row);


                });
            }
            var pager = xml.find("Pager");

            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(pager.find("PageIndex").text()),
                PageSize: parseInt(pager.find("PageSize").text()),
                RecordCount: parseInt(pager.find("RecordCount").text())
            });
        };

        //        GetStudentInfos Function

        function GetStudentInfo(ID) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetStudentInfo",
                data: '{studentid: ' + ID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        var FlagSectionID = -1;
        var FlagAdSectionID = -1;
        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var StudentInfos = xml.find("StudentInfo");
            var relation = xml.find("FRelation");
            row = $("[id*=dgRelationship] tr:last-child").clone(true);
            $("[id*=dgRelationship] tr").not($("[id*=dgRelationship] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditRelationshipInfo('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteRelationshipInfo('";
                danchorEnd = "');\">Delete</a>";
            }
            if (StudentInfos.length == 0) {
                $("[id*=dgRelationship] tr").not($("[id*=dgRelationship] tr:first-child")).remove();
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Records Found").attr("align", "center");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("td", row).eq(8).html("");
                $("td", row).eq(9).html("");
                $("td", row).eq(10).html("");
                $("[id*=dgRelationship]").append(row);
                // row = $("[id*=dgRelationship] tr:last-child").clone(true);

            }
            else {
                $.each(StudentInfos, function () {

                    $("[id*=lblClass]").html($(this).find("Class").text());
                    $("[id*=lblSection]").html($(this).find("Section").text());
                    if ($(this).find("Sex").text() == "M") {
                        $("[id*=lblgender]").html("Male");
                    }
                    else if ($(this).find("Sex").text() == "F") {
                        $("[id*=lblgender]").html("Female");
                    }
                    $("[id*=hfStudentInfoID]").val($(this).find("StudentID").text());
                    $("[id*=hfRegNo]").val($(this).find("RegNo").text());
                    $("[id*=lblStudentName]").html($(this).find("StudentName").text());

                    $("[id*=lblRegNo]").html($(this).find("RegNo").text());

                    var Gender = $(this).find("Gender").text();
                    $("[id*=lblDOB]").html($(this).find("DOB").text());
                    $("[id*=lblMotherTongue]").html($(this).find("MotherTongue").text());

                    $("[id*=lblReligion]").html($(this).find("Religion").text());
                    $("[id*=lblCommunity]").html($(this).find("Community").text());
                    $("[id*=lblCaste]").html($(this).find("Caste").text());
                    $("[id*=lblAadhaar]").html($(this).find("AadhaarNo").text());
                    $("[id*=lblTempAddress]").html($(this).find("TempAddr").text());
                    $("[id*=lblPerAddress]").html($(this).find("PerAddr").text());
                    $("[id*=lblEmail]").html($(this).find("Email").text());
                    $("[id*=lblPhoneNo]").html($(this).find("PhoneNo").text());
                    var PhotoFile = $(this).find("PhotoFile").text();
                    if (PhotoFile) {
                        $("[id*=img_prev]").attr('src', "../Students/Photos/" + PhotoFile.toString()).width(114).height(114);
                    }
                    else {
                        $("[id*=img_prev]").attr('src', "../img/Photo.jpg").width(114).height(114);
                    }

                    $("[id*=lblBloodGroup]").html($(this).find("BloodGroupID").text());
                    $("[id*=lblDisease]").html($(this).find("DisOrders").text());
                    $("[id*=lblHeight]").html($(this).find("Height").text());
                    $("[id*=lblWeight]").html($(this).find("Weight").text());
                    $("[id*=lblEmergencyPhNo]").html($(this).find("EmerPhNo").text());
                    $("[id*=lblFamilyDocName]").html($(this).find("Doctor").text());
                    $("[id*=lblFamilyDocAdd]").html($(this).find("DocAddr").text());
                    $("[id*=lblFamilyDocPhNo]").html($(this).find("DocPhNo").text());
                    if ($(this).find("IdMarks").text() != "") {
                        var IDnMarks = $(this).find("IdMarks").text().split(":");
                        if (IDnMarks.length > 1) {
                            $("[id*=lblIdentificationMarks1]").html(IDnMarks[0]);
                            $("[id*=lblIdentificationMarks2]").html(IDnMarks[1]);
                        }
                        else {
                            $("[id*=lblIdentificationMarks1]").html(IDnMarks[0]);
                            $("[id*=lblIdentificationMarks2]").html("");
                        }
                    }
                    $("[id*=lblPhysicalHandicapped]").html($(this).find("HandicaptDetails").text());
                    $("[id*=lblAdmissionNo]").html($(this).find("AdmissionNo").text());
                    $("[id*=lblAdClass]").html($(this).find("AdClass").text());
                    $("[id*=lblAdSection]").html($(this).find("AdSection").text());
                    $("[id*=lblDOJ]").html($(this).find("DOJ").text());
                    $("[id*=lblModeofTrans]").html($(this).find("TransportName").text());
                    $("[id*=lblSchoolMedium]").html($(this).find("mediumID").text());
                    $("[id*=lblFirstlang]").html($(this).find("Firstlang").text());
                    $("[id*=lblSeclang]").html($(this).find("Seclang").text());
                    $("[id*=lblScholarship]").html($(this).find("ScholarshipName").text());
                    $("[id*=hfAcademicyear]").val($(this).find("AcademicYear").text());

                    row.addClass("even");
                    if ($(this).find("FRelation").text() == "Father") {
                        isRelationExist = 1;
                        var ehref = eanchor + $(this).find("StudentID").text() + "','" + $(this).find("FRelation").text() + eanchorEnd;
                        var dhref = danchor + $(this).find("StudentID").text() + "','" + $(this).find("FRelation").text() + danchorEnd;
                        $("td", row).eq(0).html($(this).find("FRelation").text());
                        $("td", row).eq(1).html($(this).find("FName").text());
                        $("td", row).eq(2).html($(this).find("FQual").text());
                        $("td", row).eq(3).html($(this).find("FOccupation").text());
                        $("td", row).eq(4).html($(this).find("FIncome").text());
                        $("td", row).eq(5).html($(this).find("FOccAddress").text());
                        $("td", row).eq(6).html($(this).find("FEmail").text());
                        $("td", row).eq(7).html($(this).find("FatherCell").text());
                        $("td", row).eq(8).html(ehref).addClass("editacc edit-links");
                        $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links");
                        $("[id*=dgRelationship]").append(row);
                        row = $("[id*=dgRelationship] tr:last-child").clone(true);
                    }

                    if ($(this).find("MRelation").text() == "Mother") {
                        isRelationExist = 1;
                        var ehref = eanchor + $(this).find("StudentID").text() + "','" + $(this).find("MRelation").text() + eanchorEnd;
                        var dhref = danchor + $(this).find("StudentID").text() + "','" + $(this).find("MRelation").text() + danchorEnd;
                        $("td", row).eq(0).html($(this).find("MRelation").text());
                        $("td", row).eq(1).html($(this).find("MName").text());
                        $("td", row).eq(2).html($(this).find("MQual").text());
                        $("td", row).eq(3).html($(this).find("MOccupation").text());
                        $("td", row).eq(4).html($(this).find("MIncome").text());
                        $("td", row).eq(5).html($(this).find("MOccAddress").text());
                        $("td", row).eq(6).html($(this).find("MEmail").text());
                        $("td", row).eq(7).html($(this).find("MotherCell").text());
                        $("td", row).eq(8).html(ehref).addClass("editacc edit-links");
                        $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links");
                        $("[id*=dgRelationship]").append(row);
                        row = $("[id*=dgRelationship] tr:last-child").clone(true);
                    }

                    var pager = xml.find("Pager");

                    $(".Pager").ASPSnippets_Pager({
                        ActiveCssClass: "current",
                        PagerCssClass: "pager",
                        PageIndex: parseInt(pager.find("PageIndex").text()),
                        PageSize: parseInt(pager.find("PageSize").text()),
                        RecordCount: parseInt(pager.find("RecordCount").text())
                    });
                });
            }
            var RegNo = $("[id*=hfRegNo]").val();
            if (RegNo != "") {
                GetBroSisInfo(RegNo);
                GetMedicalRemarkInfo(RegNo);
                GetAcademicRemarkInfo(RegNo);
                GetHostelInfo(RegNo);
                GetBusRouteDetails(0);
                GetStaffChildrenInfo(RegNo);
                GetOldSchoolInfo(RegNo);
                GetConcessionInfo(RegNo);
                GetNationalityInfo(RegNo);
                GetAttachmentInfo(RegNo);
            }
        };
            

        function GetConcessionInfo(RegNo) {

            var StudentID = $("[id*=hfStudentInfoID]").val();
            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetConcessionInfo",
                data: '{StudentID: ' + StudentID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetConcessionInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnGetConcessionInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var feescathead = xml.find("ConcessionInfo");
            $.each(feescathead, function () {
                var StudConcessID = $(this).find("StudConcessID").text();
                var ConcessionAmount = $(this).find("ConcessionAmount").text();
                var ConcessType = $(this).find("ConcessType").text();
                if (ConcessType == "F") {
                    ConcessType = "Full";
                }
                else if (ConcessType == "P") {
                    ConcessType = "Partial";
                }
                $("[id*=lblConcession]").html(ConcessType);
                var ApprovalStatus = $(this).find("ApprovalStatus").text();
                $(".even").each(function () {
                    var dgStudConcessID = $(this).find('td.StudConcessID').html();
                    if ((dgStudConcessID != null && StudConcessID != null) && (StudConcessID == dgStudConcessID)) {
                        $(this).find('input.ConcessionAmt').val(ConcessionAmount);
                        return false;
                    }
                });
                $("[id*=lblConcessStatus]").html(ApprovalStatus);
                if (ApprovalStatus == "Approved") {
                    $("[id*=lblConcessStatus]").addClass("approved");
                }
                else if (ApprovalStatus == "Denied") {
                    $("[id*=lblConcessStatus]").addClass("denied");
                }
                else if (ApprovalStatus == "Pending") {
                    $("[id*=lblConcessStatus]").addClass("pending");
                }

            });

        };

        function GetHostelInfo(RegNo) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetHostelInfo",
                data: '{regno: ' + RegNo + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetHostelInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }
        var FlgBlockID = -1;
        var FlgRoomID = -1;
        function OnGetHostelInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var rel = xml.find("HostelInfo");
            $.each(rel, function () {
                var HostelStatus;
                HostelStatus = $(this).find("HostelStatus").text();

                $("[id*=lblHostel]").html($(this).find("HostelName").text());
                $("[id*=lblRoom]").html($(this).find("RoomName").text());
                $("[id*=lblBlock]").html($(this).find("BlockName").text());
                $("[id*=lblDateofHostelAdmn]").html($(this).find("DateofJoining").text());
            });
        };


        function GetAttachmentInfo(RegNo) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetAttachmentInfo",
                data: '{regno: ' + RegNo + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetAttachmentInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }


        function OnGetAttachmentInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var attachment = xml.find("Attachment");
            var row = $("[id*=dgAttachmentDetails] tr:last-child").clone(true);
            $("[id*=dgAttachmentDetails] tr").not($("[id*=dgAttachmentDetails] tr:first-child")).remove();
            row.addClass("even");
            
                if (attachment.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("No Records").attr("align", "left");
                    $("td", row).eq(3).html("");
                    $("td", row).eq(4).html("");
                    $("[id*=dgAttachmentDetails]").append(row);
                    row = $("[id*=dgAttachmentDetails] tr:last-child").clone(true);

                }
                else {
            $.each(attachment, function () {
              
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';


                   
                       

                        $("td", row).eq(0).html($(this).find("RowNumber").text());
                        $("td", row).eq(1).html($(this).find("Title").text());
                        $("td", row).eq(2).html($(this).find("Description").text());
                        $("td", row).eq(3).html($(this).find("FileName").text());
                        $("[id*=dgAttachmentDetails]").append(row);
                        row = $("[id*=dgAttachmentDetails] tr:last-child").clone(true);


                    });

                    var pager = xml.find("Pager");

                    $(".Pager").ASPSnippets_Pager({
                        ActiveCssClass: "current",
                        PagerCssClass: "pager",
                        PageIndex: parseInt(pager.find("PageIndex").text()),
                        PageSize: parseInt(pager.find("PageSize").text()),
                        RecordCount: parseInt(pager.find("RecordCount").text())
                    });
                }
            
        }



        function GetNationalityInfo(RegNo) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetNationalityInfo",
                data: '{regno: ' + RegNo + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetNationalityInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }
        function OnGetNationalityInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var rel = xml.find("National");
            $.each(rel, function () {
                var IsNative;
                IsNative = $(this).find("IsNatIndia").text();

                $("[id*=lblNationality]").html($(this).find("Nationality").text());
                $("[id*=lblPassportNo]").html($(this).find("PassPortNo").text());
                $("[id*=lblPPDateofIssue]").html($(this).find("DateOfIssue").text());
                $("[id*=lblPPExpDate]").html($(this).find("ExpiryDate").text());
                $("[id*=lblVisaNumber]").html($(this).find("VisaNo").text());
                $("[id*=lblVisaIssuedDate]").html($(this).find("VisaIssueDate").text());
                $("[id*=lblVisaExpiryDate]").html($(this).find("VisaExpiryDate").text());
                $("[id*=lblVisaType]").html($(this).find("VisaType").text());
                $("[id*=lblPurpose]").html($(this).find("PurposeOfVisit").text());
                $("[id*=lblNoOfEntry]").html($(this).find("NoOfEntry").text());
                $("[id*=lblValidity]").html($(this).find("Validity").text());
                $("[id*=lblRemark]").html($(this).find("Remarks").text());
            });
        };
        var FlgFeesType = "";
        function GetConcession(FeesType) {
            FlgFeesType = $("[id*=lblConcession]").val();
            if (FlgFeesType == "F") {
                $(".even").each(function () {
                    var AcutalAmt = $(this).find('.ActualAmount').html();
                    if (AcutalAmt != "" && AcutalAmt != null) {
                        $(this).find('.ConcessionAmt').val(AcutalAmt);
                    }
                });
            }
            else {
                $(".even").each(function () {
                    $(this).find('.ConcessionAmt').val("");
                });
            }

        }

        function GetOldSchoolInfo(RegNo) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetOldSchoolInfo",
                data: '{regno: ' + RegNo + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetOldSchoolInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnGetOldSchoolInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var oldschool = xml.find("OldSchool");
            var row = $("[id*=dgOldSchool] tr:last-child").clone(true);
            $("[id*=dgOldSchool] tr").not($("[id*=dgOldSchool] tr:first-child")).remove();
            row.addClass("even");
            if (oldschool.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("No Records").attr("align", "left");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("td", row).eq(8).html("");

                $("[id*=dgOldSchool]").append(row);
                row = $("[id*=dgOldSchool] tr:last-child").clone(true);

            }
            else {
                $.each(oldschool, function () {

                    var eanchor = ''
                    var eanchorEnd = '';
                    var danchor = ''
                    var danchorEnd = '';


                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("SchoolName").text());
                    $("td", row).eq(2).html($(this).find("Academicyear").text());
                    $("td", row).eq(3).html($(this).find("StdStudied").text());
                    $("td", row).eq(4).html($(this).find("Firstlanguage").text());
                    $("td", row).eq(5).html($(this).find("Medium").text());
                    $("td", row).eq(6).html($(this).find("TCNo").text());
                    $("td", row).eq(7).html($(this).find("TCReceivedDate").text());

                    $("[id*=dgOldSchool]").append(row);
                    row = $("[id*=dgOldSchool] tr:last-child").clone(true);


                });


                var pager = xml.find("Pager");

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }
        }

        function GetStaffChildrenInfo(RegNo) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetStaffChildrenInfo",
                data: '{regno: ' + RegNo + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetStaffChildrenInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnGetStaffChildrenInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var staffchild = xml.find("StaffChildren");
            var row = $("[id*=dgInstitution] tr:last-child").clone(true);
            $("[id*=dgInstitution] tr").not($("[id*=dgInstitution] tr:first-child")).remove();
            if (staffchild.length == 0) {
                row.addClass("even");
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records").attr("align", "left");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");

                $("[id*=dgInstitution]").append(row);
                row = $("[id*=dgInstitution] tr:last-child").clone(true);

            }
            else {
                $.each(staffchild, function () {

                    var eanchor = ''
                    var eanchorEnd = '';
                    var danchor = ''
                    var danchorEnd = '';

                    row.addClass("even");

                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("StaffName").text());
                    $("td", row).eq(2).html($(this).find("Relationship").text());

                    $("[id*=dgInstitution]").append(row);
                    row = $("[id*=dgInstitution] tr:last-child").clone(true);


                });

                var pager = xml.find("Pager");

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }
        }


        function GetMedicalRemarkInfo(RegNo) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetMedicalRemarkInfo",
                data: '{regno: ' + RegNo + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetMedicalRemarkInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnGetMedicalRemarkInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var MedRem = xml.find("MedicalRemark");
            var row = $("[id*=dgMedRemarks] tr:last-child").clone(true);
            $("[id*=dgMedRemarks] tr").not($("[id*=dgMedRemarks] tr:first-child")).remove();
            if (MedRem.length == 0) {
                row.addClass("even");
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records").attr("align", "left");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");

                $("[id*=dgMedRemarks]").append(row);
                row = $("[id*=dgMedRemarks] tr:last-child").clone(true);

            }
            else {
                $.each(MedRem, function () {

                    var eanchor = ''
                    var eanchorEnd = '';
                    var danchor = ''
                    var danchorEnd = '';

                    row.addClass("even");

                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("RemarkDate").text());
                    $("td", row).eq(3).html($(this).find("Description").text());
                    $("td", row).eq(4).html($(this).find("FileName").text());

                    $("[id*=dgMedRemarks]").append(row);
                    row = $("[id*=dgMedRemarks] tr:last-child").clone(true);


                });


                var pager = xml.find("Pager");

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }

        }


        function GetAcademicRemarkInfo(RegNo) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetAcademicRemarkInfo",
                data: '{regno: ' + RegNo + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetAcademicRemarkInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnGetAcademicRemarkInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var MedRem = xml.find("AcademicRemark");
            var row = $("[id*=dgAcademicRemarks] tr:last-child").clone(true);
            $("[id*=dgAcademicRemarks] tr").not($("[id*=dgAcademicRemarks] tr:first-child")).remove();
            if (MedRem.length == 0) {
                row.addClass("even");
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Record Found").attr("align", "left");
                $("td", row).eq(3).html();
                $("td", row).eq(4).html("");
                $("[id*=dgAcademicRemarks]").append(row);
                row = $("[id*=dgAcademicRemarks] tr:last-child").clone(true);

            }
            else {
                $.each(MedRem, function () {


                    var eanchor = ''
                    var eanchorEnd = '';
                    var danchor = ''
                    var danchorEnd = '';


                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("RemarkDate").text());
                    $("td", row).eq(3).html($(this).find("Remarks").text());
                    $("[id*=dgAcademicRemarks]").append(row);
                    row = $("[id*=dgAcademicRemarks] tr:last-child").clone(true);


                });


                var pager = xml.find("Pager");

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }

        }


        function GetBroSisInfo(RegNo) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfoView.aspx/GetBroSisInfo",
                data: '{regno: ' + RegNo + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetBroSisInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnGetBroSisInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var BroSis = xml.find("BroSis");
            var row = $("[id*=dgBroSis] tr:last-child").clone(true);
            $("[id*=dgBroSis] tr").not($("[id*=dgBroSis] tr:first-child")).remove();
            if (BroSis.length == 0) {
                row.addClass("even");
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");

                $("[id*=dgBroSis]").append(row);
                row = $("[id*=dgBroSis] tr:last-child").clone(true);

            }
            else {

                $.each(BroSis, function () {

                    var eanchor = ''
                    var eanchorEnd = '';
                    var danchor = ''
                    var danchorEnd = '';
                    row.addClass("even");
                    var ehref = eanchor + $(this).find("RegNo").text() + "','" + $(this).find("StudRelID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StudRelID").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("Relation").text());
                    $("td", row).eq(3).html($(this).find("StudentName").text());
                    $("td", row).eq(4).html($(this).find("Class").text());
                    $("td", row).eq(5).html($(this).find("Section").text());

                    $("[id*=dgBroSis]").append(row);
                    row = $("[id*=dgBroSis] tr:last-child").clone(true);


                });


                var pager = xml.find("Pager");

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }
        }
        
    </script>
    <style type="text/css">
        article, aside, figure, footer, header, hgroup, menu, nav, section
        {
            display: block;
        }
    </style>
</head>
<body style="overflow: auto;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td valign="middle">
                <form id="form1" runat="server">
                <div class="grid_10">
                    <div class="box round first fullpage">
                        <h2>
                            Student Information View</h2>
                        <div class="clear">
                        </div>
                        <div class="block john-accord content-wrapper2">
                            <ul class="section menu">
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Personal Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div style="border-bottom-style: none; border-bottom-width: 0px;" id="dvPersonal"
                                                class="frm-block">
                                                <table class="form" width="100%">
                                                    <div style="float: left; width: 120px; right: 60px; margin-top: 5px;">
                                                        <img id="img_prev" src="../img/photo.jpg" alt="Profile Photo" width="114" height="114" />
                                                    </div>
                                                    <tr>
                                                        <td width="20%" class="col1">
                                                            <label>
                                                                Student Name :</label>
                                                        </td>
                                                        <td width="26%" class="col2">
                                                            <asp:Label ID="lblStudentName" runat="server"></asp:Label>
                                                        </td>
                                                        <td width="14%" class="col2">
                                                            <span class="col1">
                                                                <label>
                                                                    Sex :</label>
                                                            </span>
                                                        </td>
                                                        <td class="col2">
                                                            <asp:Label ID="lblgender" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="9%">
                                                            <label>
                                                                Class :</label>
                                                        </td>
                                                        <td width="18%">
                                                            <asp:Label ID="lblClass" runat="server"></asp:Label>
                                                        </td>
                                                        <td width="11%">
                                                            <label>
                                                                Section :</label>
                                                        </td>
                                                        <td width="20%">
                                                            <asp:Label ID="lblSection" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Date of Birth :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblDOB" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Mother Tongue :
                                                            </label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblMotherTongue" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Religion :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblReligion" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Community :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblCommunity" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Caste :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblCaste" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Aadhaar card :</label>
                                                        </td>
                                                        <td>
                                                            <label for="textarea">
                                                            </label>
                                                            <asp:Label ID="lblAadhaar" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top">
                                                            <label>
                                                                Temporary Address :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblTempAddress" style="line-height: 25px;" runat="server"></asp:Label>
                                                        </td>
                                                        <td valign="top">
                                                            <label>
                                                                Permanent Address :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblPerAddress" style="line-height: 25px;" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Email :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblEmail" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Phone No :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblPhoneNo" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40">
                                                            <asp:HiddenField ID="hfStudentInfoID" runat="server" />
                                                            <asp:HiddenField ID="hfAcademicyear" runat="server" />
                                                            <asp:HiddenField ID="hfRegNo" runat="server" />
                                                            <asp:HiddenField ID="hfUserId" runat="server" />
                                                        </td>
                                                        <td colspan="3">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Parents / Guardian Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="dvFamily" style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td colspan="4">
                                                            <div class="block">
                                                                <table width="100%">
                                                                    <tr valign="top">
                                                                        <td valign="top">
                                                                            <asp:GridView ID="dgRelationship" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                <Columns>
                                                                                    <asp:BoundField DataField="Relationship" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Relationship" SortExpression="Relationship">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Name" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Name" SortExpression="Name">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Qualification" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Qualification" SortExpression="Qualification">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Occupation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Occupation" SortExpression="Occupation">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Income" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Income" SortExpression="Income">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Address" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Address" SortExpression="Address">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Email" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Email" SortExpression="Email">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Mobile" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Mobile" SortExpression="Mobile">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                </Columns>
                                                                            </asp:GridView>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div class="Pager">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Brother / Sister Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="Div5" style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td colspan="4">
                                                            <div class="block">
                                                                <table width="100%">
                                                                    <tr valign="top">
                                                                        <td valign="top">
                                                                            <asp:GridView ID="dgBroSis" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                <Columns>
                                                                                    <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Sl. No." SortExpression="SlNo">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="RegNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="RegNo" SortExpression="RegNo">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Relation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Relationship" SortExpression="Relation">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Name" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Name" SortExpression="Name">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Class" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Class" SortExpression="Class">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Section" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Section" SortExpression="Section">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                </Columns>
                                                                            </asp:GridView>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div class="Pager">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Medical Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="dvMedical" style="border-bottom-style: none; border-bottom-width: 0px;"
                                                class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td width="20%" class="col1">
                                                            <label>
                                                                Blood Group:</label>
                                                        </td>
                                                        <td width="28%" class="col2">
                                                            <asp:Label ID="lblBloodGroup" runat="server"></asp:Label>
                                                        </td>
                                                        <td width="19%" class="col2">
                                                            <label>
                                                                Disease /Allergy:</label>
                                                        </td>
                                                        <td width="33%" class="col2">
                                                            <asp:Label ID="lblDisease" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Height (cm):</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblHeight" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Weight (Kg):
                                                            </label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblWeight" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Emergency Phone No
                                                            </label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblEmergencyPhNo" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Family Doctor Name:</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblFamilyDocName" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Address:</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblFamilyDocAdd" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Doctor Phone No:</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblFamilyDocPhNo" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Identification Marks:</label>
                                                        </td>
                                                        <td>
                                                            1.
                                                            <asp:Label ID="lblIdentificationMarks1" style="line-height: 18px;" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Physically Handicapped</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblPhysicalHandicapped" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            &nbsp;
                                                        </td>
                                                        <td>
                                                            2.
                                                            <asp:Label ID="lblIdentificationMarks2" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            &nbsp;
                                                        </td>
                                                        <td>
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" align="center">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Medical Remarks Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="Div3" style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td colspan="4">
                                                            <table class="form">
                                                                <tr>
                                                                    <td>
                                                                        <div id="dvMedicalRecord" style="position: relative; width: 100%">
                                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                <tr>
                                                                                    <td colspan="5">
                                                                                        <div class="block">
                                                                                            <table width="100%">
                                                                                                <tr valign="top">
                                                                                                    <td valign="top">
                                                                                                        <asp:GridView ID="dgMedRemarks" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                                            <Columns>
                                                                                                                <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="Sl. No." SortExpression="SlNo">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                                <asp:BoundField DataField="RegNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="RegNo" SortExpression="RegNo">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                                <asp:BoundField DataField="RemarkDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="RemarkDate" SortExpression="RemarkDate">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                                <asp:BoundField DataField="Description" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="Description" SortExpression="Description">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                                <asp:BoundField DataField="FileName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="FileName" SortExpression="FileName">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                            </Columns>
                                                                                                        </asp:GridView>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <div class="Pager">
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Academic Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="dvAcademic" style="border-bottom-style: none; border-bottom-width: 0px;"
                                                class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td width="22%" class="col1">
                                                            <label>
                                                                Register No:</label>
                                                        </td>
                                                        <td width="27%" class="col2">
                                                            <asp:Label ID="lblRegNo" runat="server"></asp:Label>
                                                        </td>
                                                        <td width="22%" class="col2">
                                                            <label>
                                                                Admission No:</label>
                                                        </td>
                                                        <td width="29%" class="col2">
                                                            <asp:Label ID="lblAdmissionNo" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Admitted Class</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblAdClass" runat="server"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Admitted Section</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblAdSection" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="22%" class="col2">
                                                            <label>
                                                                Date of Join:</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblDOJ" runat="server"></asp:Label>
                                                        </td>
                                                        <td width="29%" class="col2">
                                                            <label>
                                                                Mode of Transport:</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblModeofTrans" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="22%" class="col1">
                                                            <label>
                                                                Medium:</label>
                                                        </td>
                                                        <td width="27%" class="col2">
                                                            <asp:Label ID="lblSchoolMedium" runat="server"></asp:Label>
                                                        </td>
                                                        <td width="22%" class="col2">
                                                            <label>
                                                                First Language:</label>
                                                        </td>
                                                        <td width="29%" class="col2">
                                                            <asp:Label ID="lblFirstlang" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Second language :</label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblSeclang" runat="server"></asp:Label>
                                                        </td>
                                                        <td width="27%">
                                                            <label>
                                                                Scholarship Name:</label>
                                                        </td>
                                                        <td width="43%">
                                                            <asp:Label ID="lblScholarship" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                If Parents Working in this Institution:</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4">
                                                            <div id="dvInstitution" style="display: block;">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td width="48%">
                                                                            <asp:GridView ID="dgInstitution" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                <Columns>
                                                                                    <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="SlNo" SortExpression="SlNo">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="StaffName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="StaffName" SortExpression="StaffName">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="Relationship" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="Relationship" SortExpression="Relationship">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                </Columns>
                                                                            </asp:GridView>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40">
                                                            &nbsp;
                                                        </td>
                                                        <td colspan="3">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Academic Remarks Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="Div4" style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td colspan="4">
                                                            <table class="form">
                                                                <tr>
                                                                    <td>
                                                                        <div id="dvAcaRemarks" style="position: relative; width: 100%">
                                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                <tr>
                                                                                    <td colspan="5">
                                                                                        <div class="block">
                                                                                            <table width="100%">
                                                                                                <tr valign="top">
                                                                                                    <td valign="top">
                                                                                                        <asp:GridView ID="dgAcademicRemarks" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                                            <Columns>
                                                                                                                <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="Sl. No." SortExpression="SlNo">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                                <asp:BoundField DataField="RegNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="RegNo" SortExpression="RegNo">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                                <asp:BoundField DataField="RemarkDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="RemarkDate" SortExpression="RemarkDate">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                                <asp:BoundField DataField="Remarks" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                                    HeaderText="Remarks" SortExpression="Remarks">
                                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                                </asp:BoundField>
                                                                                                            </Columns>
                                                                                                        </asp:GridView>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <div class="Pager">
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Hostel Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="dvHostelDetails" style="border-bottom-style: none; border-bottom-width: 0px;"
                                                class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td colspan="4">
                                                            <div id="dvHostel" style="display: block;">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td width="48%">
                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td width="45%">
                                                                                        <label>
                                                                                            Hotel Name</label>
                                                                                    </td>
                                                                                    <td width="55%">
                                                                                        <asp:Label ID="lblHostel" runat="server"></asp:Label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <label>
                                                                                            Block Name</label>
                                                                                    </td>
                                                                                    <td width="55%">
                                                                                        <asp:Label ID="lblBlock" runat="server"></asp:Label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <label>
                                                                                            Room No</label>
                                                                                    </td>
                                                                                    <td width="55%">
                                                                                        <asp:Label ID="lblRooms" runat="server"></asp:Label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="45%">
                                                                                        <label>
                                                                                            Date of Admission</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:Label ID="lblDateofHostelAdmn" runat="server"></asp:Label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td width="52%" style="padding: 10px;">
                                                                            <div class="block">
                                                                                <table width="100%">
                                                                                    <tr valign="top">
                                                                                        <td valign="top">
                                                                                            <asp:GridView ID="dgHostel" runat="server" AutoGenerateColumns="false" Width="100%"
                                                                                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                                AlternatingRowStyle-CssClass="even" EnableModelValidation="True" CssClass="display" />
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Bus Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="dvBusDetails" style="border-bottom-style: none; border-bottom-width: 0px;"
                                                class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td colspan="4">
                                                            <div id="dvBus" style="display: block;">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td width="48%">
                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td width="45%">
                                                                                        <label>
                                                                                            Boarding Point :</label>
                                                                                    </td>
                                                                                    <td width="55%">
                                                                                        <asp:Label ID="lblRouteCode" runat="server"></asp:Label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <label>
                                                                                            Date of Registration</label>
                                                                                    </td>
                                                                                    <td width="55%">
                                                                                        <asp:Label ID="lblDateofBusReg" runat="server"></asp:Label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td>
                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td colspan="2">
                                                                                        <label>
                                                                                            Bus Route Details</label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="2">
                                                                                        <asp:GridView ID="dgBusRoute" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                            <Columns>
                                                                                                <asp:BoundField DataField="VehicleCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                    HeaderText="VehicleCode" SortExpression="VehicleName">
                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="BusRouteName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                    HeaderText="BusRouteName" SortExpression="BusRouteName">
                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="BusRouteCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                    HeaderText="BusRouteCode" SortExpression="BusRouteCode">
                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="Timings" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                    HeaderText="Timings" SortExpression="Timings">
                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="BusCharge" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                    HeaderText="BusCharge" SortExpression="BusCharge">
                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="DateofRegistration" HeaderStyle-CssClass="sorting_mod"
                                                                                                    ItemStyle-HorizontalAlign="Center" HeaderText="DateofRegistration" SortExpression="DateofRegistration">
                                                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                </asp:BoundField>
                                                                                            </Columns>
                                                                                        </asp:GridView>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <div class="Pager">
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" align="center">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Concession Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div id="dvConcessionDetails" style="border-bottom-style: none; border-bottom-width: 0px;"
                                                class="frm-block">
                                                <table class="form" width="100%">
                                                    <tr>
                                                        <td colspan="4">
                                                            <div class="" id="dvConcession" style="display: block;">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td width="12%">
                                                                            <label>
                                                                                Concession Type:</label>
                                                                        </td>
                                                                        <td width="30%">
                                                                            <strong>
                                                                                <asp:Label ID="lblConcession" runat="server"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="12%">
                                                                            <label>
                                                                                Concession Status:</label>
                                                                        </td>
                                                                        <td width="30%">
                                                                            <asp:Label ID="lblConcessStatus" runat="server"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4">
                                                                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" 
                                                                                Width="100%" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                AlternatingRowStyle-CssClass="even" EnableModelValidation="True" 
                                                                                CssClass="display" PageSize="50" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div class="Pager">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" align="center">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Old School Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div class="frm-block">
                                                <table class="form">
                                                    <tr>
                                                        <td colspan="4">
                                                            <div class="">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <div class="block">
                                                                                <asp:GridView ID="dgOldSchool" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                    <Columns>
                                                                                        <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                            HeaderText="Sl.No." SortExpression="SlNo">
                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                        </asp:BoundField>
                                                                                        <asp:BoundField DataField="SchoolName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                            HeaderText="School Name" SortExpression="SchoolName">
                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                        </asp:BoundField>
                                                                                        <asp:BoundField DataField="Academicyear" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                            HeaderText="Academic Year" SortExpression="Academicyear">
                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                        </asp:BoundField>
                                                                                        <asp:BoundField DataField="StdStudied" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                            HeaderText="Std Studied" SortExpression="StdStudied">
                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                        </asp:BoundField>
                                                                                        <asp:BoundField DataField="Firstlang" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                            HeaderText="Ist Language" SortExpression="Firstlang">
                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                        </asp:BoundField>
                                                                                        <asp:BoundField DataField="Medium" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                            HeaderText="Medium" SortExpression="Medium">
                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                        </asp:BoundField>
                                                                                        <asp:BoundField DataField="TCNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                            HeaderText="TC No" SortExpression="TCNo">
                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                        </asp:BoundField>
                                                                                        <asp:BoundField DataField="TCReceivedDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                            HeaderText="TC Received Date" SortExpression="TCReceivedDate">
                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                        </asp:BoundField>
                                                                                    </Columns>
                                                                                </asp:GridView>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div class="Pager">
                                                                            </div>
                                                                            <br />
                                                                            <br />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Nationality Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div class="frm-block">
                                                <table class="form">
                                                    <tr>
                                                        <td colspan="4">
                                                            <div id="dvNationality" style="display: block;">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td width="19%" class="col2">
                                                                            <label>
                                                                                Nationality</label>
                                                                        </td>
                                                                        <td width="33%" class="col2">
                                                                            <asp:Label ID="lblNationality" runat="server"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <label>
                                                                                Passport Number</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblPassportNo" runat="server"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <label>
                                                                                Date of Issue
                                                                            </label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblPPDateofIssue" runat="server"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <label>
                                                                                Visa Number</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblVisaNumber" runat="server"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <label>
                                                                                Expiry Date</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblPPExpDate" runat="server"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <label>
                                                                                Visa Type</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblVisaType" runat="server"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <label>
                                                                                Visa Issue Date</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblVisaIssuedDate" runat="server"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <label>
                                                                                Visa Expiry Date</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblVisaExpiryDate" runat="server"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <label>
                                                                                No of Entry</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblNoOfEntry" runat="server"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <label>
                                                                                Validity</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblValidity" runat="server"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <label>
                                                                                Purpose of Visit</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblPurpose" runat="server"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <label>
                                                                                Remark</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblRemark" runat="server"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40">
                                                            &nbsp;
                                                        </td>
                                                        <td colspan="4">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                    Attachment Details</a>
                                    <ul class="johnmenu">
                                        <li>
                                            <div class="frm-block">
                                                <table class="form">
                                                    <tr>
                                                        <td>
                                                            <div id="Div8" style="position: relative; width: 100%">
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <div class="block">
                                                                                <table width="100%">
                                                                                    <tr valign="top">
                                                                                        <td valign="top">
                                                                                            <div>
                                                                                                <asp:GridView ID="dgAttachmentDetails" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                                    <Columns>
                                                                                                        <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                            HeaderText="Sl. No." SortExpression="SlNo">
                                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                        </asp:BoundField>
                                                                                                        <asp:BoundField DataField="Title" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                            HeaderText="Title" SortExpression="Title">
                                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                        </asp:BoundField>
                                                                                                        <asp:BoundField DataField="Description" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                            HeaderText="Description" SortExpression="Description">
                                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                        </asp:BoundField>
                                                                                                        <asp:BoundField DataField="FileName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                                            HeaderText="FileName" SortExpression="FileName">
                                                                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                                        </asp:BoundField>
                                                                                                    </Columns>
                                                                                                </asp:GridView>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <div class="Pager">
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                </form>
            </td>
        </tr>
    </table>
</body>
</html>
