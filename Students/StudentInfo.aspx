<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StudentInfo.aspx.cs" Inherits="StudentInfo" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtDOB]");
            setDatePicker("[id*=txtMedRemDate]");
            setDatePicker("[id*=txtDOJ]");
            setDatePicker("[id*=txtDateofHostelAdmn]");
            setDatePicker("[id*=txtDateofBusReg]");
            setDatePicker("[id*=txtAcaRemDate]");
            setDatePicker("[id*=txtTCDate]");
            setDatePicker("[id*=txtTCReceivedDate]");
            setDatePicker("[id*=txtPPDateofIssue]");
            setDatePicker("[id*=txtPPExpDate]");
            setDatePicker("[id*=txtVisaIssuedDate]");
            setDatePicker("[id*=txtVisaExpiryDate]");
            setDatePicker("[id*=txtValidity]");
            setDatePicker("[id*=txtDOA]");
            setDatePicker("[id*=txtCancellationDate]");

        }); 
    </script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">

        $(function () {

            if (window.FormData) {
                formdata = new FormData();
            }
            GetModuleMenuID('Fees/AdvanceFees.aspx');
            //        GetStudentInfos Function on page load
            $(".brosis").hide();

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                var StudentID = $("[id*=hfStudentInfoID]").val();
            if (StudentID != "" && StudentID != "0") {
                GetStudentInfo(StudentID);
                $("[id*=btnAdvanceFees]").css("display", "none");
                $("[id*=spFeesSubmit]").html("Save & Pay Advance Fees");
                $("[id*=spPersonalSubmit]").html("Update");
                $("[id*=ddlStatus]").attr("disabled", false);
            }
            else {
                // GetStudentInfo("0");
                //                GetBroSisInfo("-1");
                //                GetFamilyInfo("-1");
                //                GetMedicalRemarkInfo("-1");
                //                GetAcademicRemarkInfo("-1");
                //                GetHostelInfo("-1");
                //                GetBusRouteDetails("-1");
                //                GetStaffChildrenInfo("-1");
                //                GetOldSchoolInfo("-1");
                //                GetConcessionInfo("-1");
                //                GetNationalityInfo("-1");
                //                GetAttachmentInfo("-1");

                GetSportsInfo("0");
                GetFineArtsInfo("0");
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
                    $("td", row).eq(7).html("").removeClass("deleteacc delete-links");
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


                var Scholarships = "";
                var row = $("[id*=dgScholarship] tr:last-child").clone(true);
                $("[id*=dgScholarship] tr").not($("[id*=dgScholarship] tr:first-child")).remove();

                var danchor = ''
                var danchorEnd = '';

                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    danchor = "<a>";
                    danchorEnd = "</a>";
                }
                else {
                    danchor = "<a  href=\"javascript:DeleteScholarshipInfo('";
                    danchorEnd = "');\">Delete</a>";
                }

                if (BusRoutes.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("No Records").attr("align", "center");
                    $("td", row).eq(3).html("").removeClass("deleteacc delete-links"); ;
                    $("[id*=dgScholarship]").append(row);
                    row = $("[id*=dgScholarship] tr:last-child").clone(true);
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

                $("[id*=btnAdvanceFees]").css("display", "inline-block");
                $("[id*=spFeesSubmit]").html("Save & Pay Advance Fees");
                $("[id*=spPersonalSubmit]").html("Save");

            }

            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else {
                $("table.form :input").prop('disabled', false);
            }

            // $("[id*=ddlAdSection]").attr("disabled", true);
            //  $("[id*=ddlAdClass]").attr("disabled", true);
            if (StudentID != "") {
                $("[id*=ddlStatus]").attr("disabled", false);
            } else {
                $("[id*=ddlStatus]").attr("disabled", true);
            }
           // $("[id*=txtFirstlang]").val("English");
           // $("[id*=txtFirstlang]").html("English");
            //$("[id*=txtDOA]").attr("disabled", true);
        });

        function GetSectionByClass() {
            var Class = $("[id*=ddlClass]").val();
            if (Class != "") {

                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetSectionByClassID",
                    data: '{ClassID: ' + Class + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetSectionByClassSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }


        function OnGetSectionByClassSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("SectionByClass");
            var select = $("[id*=ddlSection]");
            select.children().remove();
            select.append($("<option>").val('').text('Select'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));

            });
            //            $("[id*=ddlSection]").attr("disabled", true);
            if (FlagSectionID != -1)
                $("[id*=ddlSection] option[value='" + FlagSectionID + "']").attr("selected", "true");
        };

        function GetAdSectionByAdClass() {
            var Class = $("[id*=ddlAdClass]").val();
            if (Class != "") {

                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetAdSectionByAdClassID",
                    data: '{ClassID: ' + Class + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetAdSectionByAdClassSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }


        function OnGetAdSectionByAdClassSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("AdSectionByAdClass");
            var select = $("[id*=ddlAdSection]");
            select.children().remove();
            select.append($("<option>").val('').text('Select'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));

            });
            //            $("[id*=ddlAdSection]").attr("disabled", true);

            if (FlagAdSectionID != -1)
                $("[id*=ddlAdSection] option[value='" + FlagAdSectionID + "']").attr("selected", "true");
        };



        function GetBroSisSectionByBroSisClass() {
            var Class = $("[id*=ddlBroSisClass]").val();
            if (Class != "") {

                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetSectionByClassID",
                    data: '{ClassID: ' + Class + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetBroSisSectionByBroSisClassSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });

            }
        }
        function GetBlockByHostel(ID) {
            $.ajax({
                type: "POST",
                url: "../Students/StudentInfo.aspx/GetBlockByHostelID",
                data: '{HostelID: ' + ID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetBlockByHostelIDSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetBlockByHostelIDSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("BlockByHostel");
            var select = $("[id*=ddlBlock]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var BlockID = $(this).find("BlockID").text();
                var BlockName = $(this).find("BlockName").text();
                select.append($("<option>").val(BlockID).text(BlockName));
            });
            if (FlgBlockID != -1)
                $("[id*=ddlBlock] option[value='" + FlgBlockID + "']").attr("selected", "true");
            GetRoomByBlock();
        };
        function GetBusRouteDetails(ID) {
            var RegNo = $("[id*=hfRegNo]").val();
            if (ID == "0") {
                ID = "";
            }
            $.ajax({

                type: "POST",
                url: "../Students/StudentInfo.aspx/GetBusRouteInfo",
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
            var iroute = "";
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var BusRoutes = xml.find("BusRoutes");
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
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Records").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("").removeClass("deleteacc delete-links"); ;
                $("[id*=dgBusRoute]").append(row);
                row = $("[id*=dgBusRoute] tr:last-child").clone(true);

            }
            else {
                $.each(BusRoutes, function () {

                    var BusRoute = $(this);
                    var dhref = danchor + $(this).find("BusRouteID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("VehicleCode").text());
                    $("td", row).eq(1).html($(this).find("BusRouteName").text());
                    $("td", row).eq(2).html($(this).find("BusRouteCode").text());
                    $("td", row).eq(3).html($(this).find("Timings").text());
                    $("td", row).eq(4).html($(this).find("BusCharge").text());
                    $("td", row).eq(5).html($(this).find("DateofRegistration").text());
                    $("td", row).eq(6).html(dhref).addClass("deleteacc delete-links");
                    iroute = $(this).find("BusRouteID").text();

                    if ($("[id*=hfDeletePrm]").val() == 'false') {
                        $('.deleteacc').hide();
                    }
                    else {
                        $('.deleteacc').show();
                    }
                    $("[id*=ddlRouteCode]").val(iroute);
                    $("[id*=txtDateofBusReg]").val($(this).find("DateofRegistration").text());
                    $("[id*=dgBusRoute] tr:has(td)").remove();
                    $("[id*=dgBusRoute]").append(row);


                });
            }

            if (iroute) {
                $("[id*=rbtnBusYes]").attr("checked", true);
                ShowBus();
            }
            else {
                $("[id*=rbtnBusNo]").attr("checked", true);
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

        //        function GetStudentBusRouteDetails(ID) {
        //            var RegNo = $("[id*=hfRegNo]").val();
        //            $.ajax({

        //                type: "POST",
        //                url: "../Students/StudentInfo.aspx/GetStudentBusRouteInfo",
        //                data: '{"regno": "' + RegNo + '"}',
        //                contentType: "application/json; charset=utf-8",
        //                dataType: "json",
        //                success: OnGetStudentBusRouteInfoSuccess,
        //                failure: function (response) {
        //                    AlertMessage('info', response.d);
        //                },
        //                error: function (response) {
        //                    AlertMessage('info', response.d);
        //                }
        //            });
        //        }
        //        function OnGetStudentBusRouteInfoSuccess(response) {
        //            var xmlDoc = $.parseXML(response.d);
        //            var xml = $(xmlDoc);
        //            var BusRoutes = xml.find("StudentBusRoutes");
        //            var row = $("[id*=dgBusRoute] tr:last-child").clone(true);
        //            $("[id*=dgBusRoute] tr").not($("[id*=dgBusRoute] tr:first-child")).remove();
        //            $.each(BusRoutes, function () {
        //                var BusRoute = $(this);
        //                row.addClass("even");
        //                $("td", row).eq(0).html($(this).find("VehicleCode").text());
        //                $("td", row).eq(1).html($(this).find("BusRouteName").text());
        //                $("td", row).eq(2).html($(this).find("BusRouteCode").text());
        //                $("td", row).eq(3).html($(this).find("Timings").text());
        //                $("td", row).eq(4).html($(this).find("BusCharge").text());
        //                $("td", row).eq(5).html($(this).find("DateofRegistration").text());
        //                $("[id*=dgBusRoute]").append(row);
        //                row = $("[id*=dgBusRoute] tr:last-child").clone(true);
        //            });
        //            var pager = xml.find("Pager");

        //            $(".Pager").ASPSnippets_Pager({
        //                ActiveCssClass: "current",
        //                PagerCssClass: "pager",
        //                PageIndex: parseInt(pager.find("PageIndex").text()),
        //                PageSize: parseInt(pager.find("PageSize").text()),
        //                RecordCount: parseInt(pager.find("RecordCount").text())
        //            });
        //        };

        function GetRoomByBlock() {
            var HostelID = $("[id*=ddlHostel]").val();
            var BlockID = $("[id*=ddlBlock]").val();
            $.ajax({
                type: "POST",
                url: "../Students/StudentInfo.aspx/GetRoomByBlock",
                data: '{"hostelid": "' + HostelID + '","blockid": "' + BlockID + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetRoomByBlockSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetRoomByBlockSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("RoomByBlock");
            var select = $("[id*=ddlRooms]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var RoomID = $(this).find("RoomID").text();
                var RoomName = $(this).find("RoomName").text();
                select.append($("<option>").val(RoomID).text(RoomName));
            });
            if (FlgRoomID != -1)
                $("[id*=ddlRooms] option[value='" + FlgRoomID + "']").attr("selected", "true");
        };


        function OnGetBroSisSectionByBroSisClassSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("SectionByClass");
            var select = $("[id*=ddlBroSisSection]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));

            });
            if (BroSisFlagSectionID != -1)
                $("[id*=ddlBroSisSection] option[value='" + BroSisFlagSectionID + "']").attr("selected", "true");
            GetBroSisStudentByBroSisSection();
        };


        function GetBroSisStudentByBroSisSection() {
            var Class = $("[id*=ddlBroSisClass]").val();
            var Section = $("[id*=ddlBroSisSection]").val();
            var Classname = $("[id*=ddlBroSisClass] option[value='" + Class + "']").html();
            var Sectionname = $("[id*=ddlBroSisSection] option[value='" + Section + "']").html();
            $.ajax({
                type: "POST",
                url: "../Students/StudentInfo.aspx/GetStudentBySection",
                data: '{"Class": "' + Classname + '","Section": "' + Sectionname + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetBroSisStudentByBroSisSectionSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnGetBroSisStudentByBroSisSectionSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("StudentBySection");
            var select = $("[id*=ddlBroSisStudentName]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var StudentID = $(this).find("RegNo").text();
                var StudentName = $(this).find("StudentName").text();
                select.append($("<option>").val(StudentID).text(StudentName));

            });
            if (BroSisFlagStudentID != -1)
                $("[id*=ddlBroSisStudentName] option[value='" + BroSisFlagStudentID + "']").attr("selected", "true");
        };



        //GetStudentInfos Function

        function GetStudentInfo(ID) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetStudentInfo",
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
            else {
                return false;
            }
        }
        var row = "";
        var FlagSectionID = -1;
        var FlagAdSectionID = -1;
        var isRelationExist = 0;
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

                    var ClassID = $(this).find("ClassID").text();
                    $("[id*=ddlClass] option[value='" + ClassID + "']").attr("selected", "true");
                    FlagSectionID = $(this).find("SectionID").text();
                    GetSectionByClass();

                    $("[id*=hfStudentInfoID]").val($(this).find("StudentID").text());
                    $("[id*=hfRegNo]").val($(this).find("RegNo").text());
                    $("[id*=lblRegNo]").html($(this).find("RegNo").text());
                    $("[id*=lblStudentName]").html($(this).find("StudentName").text());
                    if ($(this).find("SectionID").text() == "") {
                        $("[id*=lblClass]").html($(this).find("Class").text() + " / " + "New")
                    }
                    else {
                        $("[id*=lblClass]").html($(this).find("Class").text() + " / " + $(this).find("Section").text())
                    }
                    $("[id*=txtStudentName]").val($(this).find("StudentName").text());


                    $("[id*=txtRegNo]").val($(this).find("RegNo").text());
                    $("[id*=txtConcessionReason]").val($(this).find("Reason").text());
                    var Gender = $(this).find("Gender").text();

                    if (Gender == "Male" || Gender == "M") {
                        $("[id*=rbtnMale]").attr("checked", true);
                    }
                    else if (Gender == "Female" || Gender == "F") {
                        $("[id*=rbtnFemale]").attr("checked", true);
                    }
                    $("[id*=txtDOB]").val($(this).find("DOB").text());
                    $("[id*=txtMotherTongue]").val($(this).find("MotherTongue").text());


                    var Religion = $(this).find("ReligionID").text();
                    $("[id*=ddlReligion] option[value='" + Religion + "']").attr("selected", "true");

                    var Community = $(this).find("CommunityID").text();
                    $("[id*=ddlCommunity] option[value='" + Community + "']").attr("selected", "true");

                    var Caste = $(this).find("CasteID").text();
                    $("[id*=ddlCaste] option[value='" + Caste + "']").attr("selected", "true");

                    $("[id*=txtAadhaar]").val($(this).find("AadhaarNo").text());
                    $("[id*=txtTempAddress]").val($(this).find("TempAddr").text());
                    $("[id*=txtPerAddress]").val($(this).find("PerAddr").text());
                    $("[id*=txtEmail]").val($(this).find("Email").text());
                    $("[id*=txtPhoneNo]").val($(this).find("PhoneNo").text());
                    $("[id*=txtRationCardNo]").val($(this).find("RationCardNo").text());
                    $("[id*=txtSmartCardNo]").val($(this).find("SmartCardNo").text());
                    $("[id*=txtSSLC]").val($(this).find("SSLCNo").text());
                    $("[id*=ddlSSLC]").val($(this).find("SSLCYear").text());
                    $("[id*=txtHSC]").val($(this).find("HSCNo").text());
                    $("[id*=ddlHSC]").val($(this).find("HSCYear").text());
                    $("[id*=txtSUID]").val($(this).find("SUID").text());
                    $("[id*=txtTamilname]").val($(this).find("tamilname").text());
                    var CareTaker = $(this).find("CareTaker").text();

                    if (CareTaker == "Parent") {
                        $("[id*=rbtnParent]").attr("checked", true);
                    }
                    else if (CareTaker == "Guardian") {
                        $("[id*=rbtnGuardian]").attr("checked", true);
                    }
                    var Sports = $(this).find("Sports").text();
                    if (Sports == "true") {
                        $("[id*=rbtnSports]").attr("checked", true);
                    }
                    else {
                        $("[id*=rbtnFine]").attr("checked", true);
                    }

                    var FineArts = $(this).find("FineArts").text();
                    if (FineArts == "true") {
                        $("[id*=rbtnFine]").attr("checked", true);
                    }
                    else {
                        $("[id*=rbtnSports]").attr("checked", true);
                    }

                    $("[id*=txtCurricularRemarks]").val($(this).find("CurricularRemarks").text());

                    var PhotoFile = $(this).find("PhotoFile").text();
                    if (PhotoFile) {
                        $("[id*=img_prev]").attr('src', "../Students/Photos/" + PhotoFile.toString()).width(114).height(114);
                    }
                    else {
                        $("[id*=img_prev]").attr('src', "../img/Photo.jpg").width(114).height(114);
                    }
                    $("[id*=ddlBloodGroup]").val($(this).find("BloodGroupID").text());
                    $("[id*=txtDisease]").val($(this).find("DisOrders").text());
                    $("[id*=txtHeight]").val($(this).find("Height").text());
                    $("[id*=txtWeight]").val($(this).find("Weight").text());
                    $("[id*=txtEmergencyPhNo]").val($(this).find("EmerPhNo").text());
                    $("[id*=txtFamilyDocName]").val($(this).find("Doctor").text());
                    $("[id*=txtFamilyDocAdd]").val($(this).find("DocAddr").text());
                    $("[id*=txtFamilyDocPhNo]").val($(this).find("DocPhNo").text());
                    if ($(this).find("IdMarks").text() != "") {
                        var IDnMarks = $(this).find("IdMarks").text().split(":");
                        if (IDnMarks.length > 1) {
                            $("[id*=txtIdentificationMarks1]").val(IDnMarks[0]);
                            $("[id*=txtIdentificationMarks2]").val(IDnMarks[1]);
                        }
                        else {
                            $("[id*=txtIdentificationMarks1]").val(IDnMarks[0]);
                            $("[id*=txtIdentificationMarks2]").val("");
                        }
                    }
                    if ($(this).find("Handicap").text() == "Y") {
                        $("[id*=rbtnPHYes]").attr('checked', true);
                    }
                    else {
                        $("[id*=rbtnNoPH]").attr('checked', true);
                    }
                    showphysical();
                    $("[id*=txtPhysicalHandicapped]").val($(this).find("HandicaptDetails").text());
                    $("[id*=txtAdmissionNo]").val($(this).find("AdmissionNo").text());

                    var AdClassID = $(this).find("AdClassID").text();
                    $("[id*=ddlAdClass] option[value='" + AdClassID + "']").attr("selected", "true");
                    FlagAdSectionID = $(this).find("AdSectionID").text();
                    GetAdSectionByAdClass();

                    $("[id*=txtDOJ]").val($(this).find("DOJ").text());
                    $("[id*=txtDOA]").val($(this).find("DOA").text());

                    var Mode = $(this).find("TransportId").text();
                    $("[id*=ddlModeofTrans] option[value='" + Mode + "']").attr("selected", "true");

                    $("[id*=ddlSchoolMedium]").val($(this).find("mediumID").text());
                    $("[id*=txtFirstlang]").val($(this).find("Firstlang").text());
                   // $("[id*=txtFirstlang]").html($(this).find("Firstlang").text());
                    $("[id*=ddlSeclang]").val($(this).find("Seclang").text());
                    var Scholar = $(this).find("Scholar").text();
                    if (Scholar == "Y") {
                        $("[id*=rbtnScholarYes]").attr("checked", true);
                    }
                    else {
                        $("[id*=rbtnNoScholar]").attr("checked", true);
                    }
                    ShowScholarship();

                    var Concession = $(this).find("Concession").text();

                    if (Concession == "Y") {
                        $("[id*=rbtnConcessYes]").attr("checked", true);
                    }
                    else {
                        $("[id*=rbtnNoConcess]").attr("checked", true);
                    }
                    ShowConcession();


                    var ScholarshipId = $(this).find("ScholarshipId").text();
                    // $("[id*=ddlScholarship] option[value='" + ScholarshipId + "']").attr("selected", "true");

                    $("[id*=hfAcademicyear]").val($(this).find("AcademicYear").text());
                    $("[id*=ddlStatus]").val($(this).find("Active").text());
                    $("[id*=lblStatus]").html($(this).find("Status").text());
                    row.addClass("even");
                    if ($(this).find("FRelation").text() == "Father") {
                        isRelationExist = 1;
                        var ehref = eanchor + $(this).find("StudentID").text() + "','" + $(this).find("FRelation").text() + eanchorEnd;
                        var dhref = danchor + $(this).find("StudentID").text() + "','" + $(this).find("FRelation").text() + danchorEnd;
                        $("td", row).eq(0).html($(this).find("FRelation").text()).attr("valign", "top");
                        $("td", row).eq(1).html($(this).find("FName").text()).attr("valign", "top");
                        $("td", row).eq(2).html($(this).find("FQual").text()).attr("valign", "top");
                        $("td", row).eq(3).html($(this).find("FOccupation").text()).attr("valign", "top");
                        $("td", row).eq(4).html($(this).find("FIncome").text()).attr("valign", "top");
                        $("td", row).eq(5).html("<p style='word-wrap: break-word; width:300px;'>" + $(this).find("FOccAddress").text() + "</p>");
                        $("td", row).eq(6).html($(this).find("FEmail").text()).attr("valign", "top");
                        $("td", row).eq(7).html($(this).find("FatherCell").text()).attr("valign", "top");
                        $("td", row).eq(8).html(ehref).addClass("editacc edit-links").attr("valign", "top");
                        $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links").attr("valign", "top");
                        $("[id*=dgRelationship]").append(row);
                        row = $("[id*=dgRelationship] tr:last-child").clone(true);
                    }

                    if ($(this).find("MRelation").text() == "Mother") {
                        isRelationExist = 1;
                        var ehref = eanchor + $(this).find("StudentID").text() + "','" + $(this).find("MRelation").text() + eanchorEnd;
                        var dhref = danchor + $(this).find("StudentID").text() + "','" + $(this).find("MRelation").text() + danchorEnd;
                        $("td", row).eq(0).html($(this).find("MRelation").text()).attr("valign", "top");
                        $("td", row).eq(1).html($(this).find("MName").text()).attr("valign", "top");
                        $("td", row).eq(2).html($(this).find("MQual").text()).attr("valign", "top");
                        $("td", row).eq(3).html($(this).find("MOccupation").text()).attr("valign", "top");
                        $("td", row).eq(4).html($(this).find("MIncome").text()).attr("valign", "top");
                        $("td", row).eq(5).html("<p style='word-wrap: break-word;'>" + $(this).find("MOccAddress").text() + "</p>");
                        $("td", row).eq(6).html($(this).find("MEmail").text()).attr("valign", "top");
                        $("td", row).eq(7).html($(this).find("MotherCell").text()).attr("valign", "top");
                        $("td", row).eq(8).html(ehref).addClass("editacc edit-links").attr("valign", "top");
                        $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links").attr("valign", "top");
                        $("[id*=dgRelationship]").append(row);
                        row = $("[id*=dgRelationship] tr:last-child").clone(true);
                    }

                    if ($(this).find("Guardian1").text() == "Guardian I") {
                        isRelationExist = 1;
                        var ehref = eanchor + $(this).find("StudentID").text() + "','" + $(this).find("Guardian1").text() + eanchorEnd;
                        var dhref = danchor + $(this).find("StudentID").text() + "','" + $(this).find("Guardian1").text() + danchorEnd;
                        $("td", row).eq(0).html($(this).find("Guardian1").text()).attr("valign", "top");
                        $("td", row).eq(1).html($(this).find("GName1").text()).attr("valign", "top");
                        $("td", row).eq(2).html($(this).find("GQual1").text()).attr("valign", "top");
                        $("td", row).eq(3).html($(this).find("GOcc1").text()).attr("valign", "top");
                        $("td", row).eq(4).html($(this).find("GInc1").text()).attr("valign", "top");
                        $("td", row).eq(5).html("<p style='word-wrap: break-word; width:300px;'>" + $(this).find("GAddr1").text() + "</p>");
                        $("td", row).eq(6).html($(this).find("GEmail1").text()).attr("valign", "top");
                        $("td", row).eq(7).html($(this).find("GPhno1").text()).attr("valign", "top");
                        $("td", row).eq(8).html(ehref).addClass("editacc edit-links").attr("valign", "top");
                        $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links").attr("valign", "top");
                        $("[id*=dgRelationship]").append(row);
                        row = $("[id*=dgRelationship] tr:last-child").clone(true);
                    }

                    if ($(this).find("Guardian2").text() == "Guardian II") {
                        isRelationExist = 1;
                        var ehref = eanchor + $(this).find("StudentID").text() + "','" + $(this).find("Guardian2").text() + eanchorEnd;
                        var dhref = danchor + $(this).find("StudentID").text() + "','" + $(this).find("Guardian2").text() + danchorEnd;
                        $("td", row).eq(0).html($(this).find("Guardian2").text()).attr("valign", "top");
                        $("td", row).eq(1).html($(this).find("GName2").text()).attr("valign", "top");
                        $("td", row).eq(2).html($(this).find("GQual2").text()).attr("valign", "top");
                        $("td", row).eq(3).html($(this).find("GOcc2").text()).attr("valign", "top");
                        $("td", row).eq(4).html($(this).find("GInc2").text()).attr("valign", "top");
                        $("td", row).eq(5).html("<p style='word-wrap: break-word; width:300px;'>" + $(this).find("GAddr2").text() + "</p>");
                        $("td", row).eq(6).html($(this).find("GEmail2").text()).attr("valign", "top");
                        $("td", row).eq(7).html($(this).find("GPhno2").text()).attr("valign", "top");
                        $("td", row).eq(8).html(ehref).addClass("editacc edit-links").attr("valign", "top");
                        $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links").attr("valign", "top");
                        $("[id*=dgRelationship]").append(row);
                        row = $("[id*=dgRelationship] tr:last-child").clone(true);
                    }

                    if ($("[id*=hfEditPrm]").val() == 'false') {
                        $('.editacc').hide();
                    }
                    else {
                        $('.editacc').show();
                    }
                    if ($("[id*=hfDeletePrm]").val() == 'false') {
                        $('.deleteacc').hide();
                    }
                    else {
                        $('.deleteacc').show();
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
                //  GetFamilyInfo(RegNo);
                ShowCurricular();
                GetSportsInfo(RegNo);
                GetFineArtsInfo(RegNo);
                GetMedicalRemarkInfo(RegNo);
                GetAcademicRemarkInfo(RegNo);
                GetHostelInfo(RegNo);
                GetBusRouteDetails(0);
                GetStaffChildrenInfo(RegNo);
                GetOldSchoolInfo(RegNo);
                GetConcessionInfo(RegNo);
                GetNationalityInfo(RegNo);
                GetAttachmentInfo(RegNo);
                GetScholarshipInfo(RegNo);
            }
            else {
                GetBroSisInfo("-1");
                //  GetFamilyInfo("-1");
                GetMedicalRemarkInfo("-1");
                ShowCurricular();
                GetSportsInfo("-1");
                GetFineArtsInfo("-1");
                GetAcademicRemarkInfo("-1");
                GetHostelInfo("-1");
                GetBusRouteDetails("-1");
                GetStaffChildrenInfo("-1");
                GetOldSchoolInfo("-1");
                GetConcessionInfo("-1");
                GetNationalityInfo("-1");
                GetAttachmentInfo("-1");
                GetScholarshipInfo("-1");

            }
        };

        function GetFamilyInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var StudentID = $("[id*=hfStudentInfoID]").val();
                if (StudentID == "") {
                    StudentID = "-1";
                }
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetFamilyInfo",
                    data: '{StudentID: ' + StudentID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetFamilyInfoSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                return false;
            }
        }



        function OnGetFamilyInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var family = xml.find("Family");
            // row = $("[id*=dgRelationship] tr:last-child").clone(true);

            //   $("[id*=dgRelationship] tr").not($("[id*=dgRelationship] tr:first-child")).remove();
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
            row.addClass("even");

            if (family.length == 0 && isRelationExist == 0) {


                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Records Found").attr("align", "center");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("td", row).eq(8).html("");
                //  $("td", row).eq(9).html("");

                $("[id*=dgRelationship]").append(row);
                // row = $("[id*=dgRelationship] tr:last-child").clone(true);

            }
            else {


                $.each(family, function () {

                    var ehref = eanchor + $(this).find("StudentID").text() + "','" + $(this).find("Relation").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StudentID").text() + "','" + $(this).find("Relation").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("Relation").text()).attr("valign", "top");
                    $("td", row).eq(1).html($(this).find("Name").text()).attr("valign", "top");
                    $("td", row).eq(2).html($(this).find("Qual").text()).attr("valign", "top");
                    $("td", row).eq(3).html($(this).find("Occupation").text()).attr("valign", "top");
                    $("td", row).eq(4).html($(this).find("Income").text()).attr("valign", "top");
                    $("td", row).eq(5).html("<p style='word-wrap: break-word; width:300px;'>" + $(this).find("OccAddress").text() + "</p>");
                    $("td", row).eq(6).html($(this).find("RelEmail").text()).attr("valign", "top");
                    $("td", row).eq(7).html($(this).find("Cell").text()).attr("valign", "top");
                    $("td", row).eq(8).html(ehref).addClass("editacc edit-links").attr("valign", "top");
                    $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links").attr("valign", "top");

                    $("[id*=dgRelationship]").append(row);
                    row = $("[id*=dgRelationship] tr:last-child").clone(true);

                });
            }
            if ($("[id*=hfEditPrm]").val() == 'false') {
                $('.editacc').hide();
            }
            else {
                $('.editacc').show();
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                $('.deleteacc').hide();
            }
            else {
                $('.deleteacc').show();
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




        function GetConcessionInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var StudentID = $("[id*=hfStudentInfoID]").val();
                if (StudentID == "") {
                    StudentID = "-1";
                }

                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetConcessionInfo",
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
            else {
                return false;
            }
        }
        function OnGetConcessionInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var feescathead = xml.find("ConcessionInfo");

            $.each(feescathead, function () {
                var StudConcessID = $(this).find("StudConcessID").text();
                var ConcessionAmount = $(this).find("ConcessionAmount").text();
                var ConcessType = $(this).find("ConcessType").text();
                var ApprovalStatus = $(this).find("ApprovalStatus").text();
                $(".even").each(function () {
                    if (ConcessType == "F") {
                        var dgStudConcessID = $(this).find('td.StudConcessID').html();
                        if ((dgStudConcessID != null && StudConcessID != null) && (StudConcessID == dgStudConcessID)) {
                            $(this).find('input.ConcessionAmt').val(ConcessionAmount);
                            $(this).find('input.ConcessionAmt').attr("disabled", true);
                            return false;
                        }
                    }
                    else if (ConcessType == "P") {
                        var dgStudConcessID = $(this).find('td.StudConcessID').html();
                        if ((dgStudConcessID != null && StudConcessID != null) && (StudConcessID == dgStudConcessID)) {
                            $(this).find('input.ConcessionAmt').val(ConcessionAmount);
                            $(this).find('input.ConcessionAmt').attr("disabled", false);
                            return false;
                        }
                    }
                });
                if (ApprovalStatus) {
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

                }
                $("[id*=ddlConcession] option[value=" + ConcessType + "]").attr("selected", "true");

                ShowConcession();
            });

        };

        function GetHostelInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetHostelInfo",
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
            else {
                return false;
            }
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
                if (HostelStatus == "Y") {
                    $("[id*=rbtnHostelYes]").attr("checked", true);
                    ShowHostel();
                }
                else {
                    $("[id*=rbtnHostelNo]").attr("checked", true);
                }

                $("[id*=ddlHostel]").val($(this).find("HostelID").text());
                GetBlockByHostel($(this).find("HostelID").text());
                FlgBlockID = $(this).find("BlockID").text();
                FlgRoomID = $(this).find("RoomID").text();
                $("[id*=txtDateofHostelAdmn]").val($(this).find("DateofJoining").text());
            });
        };


        function GetAttachmentInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetAttachmentInfo",
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
            else {
                return false;
            }
        }


        function OnGetAttachmentInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var attachment = xml.find("Attachment");
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
                $("td", row).eq(3).html("").removeClass("download-links");
                $("td", row).eq(4).html("").removeClass("deleteacc delete-links");
                $("[id*=dgAttachmentDetails]").append(row);
                row = $("[id*=dgAttachmentDetails] tr:last-child").clone(true);

            }


            else {
                $.each(attachment, function () {
                    row.addClass("even");
                    var ehref = eanchor + $(this).find("StudAttachID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StudAttachID").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("Title").text());
                    $("td", row).eq(2).html($(this).find("Description").text());
                    $("td", row).eq(3).html("<a target='_blank' href=../Students/Attachments/" + $(this).find("FileName").text() + ">" + $(this).find("FileName").text() + "</a>").addClass("download-links");
                    // $("td", row).eq(4).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgAttachmentDetails]").append(row);
                    row = $("[id*=dgAttachmentDetails] tr:last-child").clone(true);


                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    $('.deleteacc').hide();
                }
                else {
                    $('.deleteacc').show();
                }
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
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetNationalityInfo",
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
            else {
                return false;
            }
        }
        function OnGetNationalityInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var rel = xml.find("National");
            $.each(rel, function () {
                var IsNative;
                IsNative = $(this).find("IsNatIndia").text();
                if (IsNative == "Y") {
                    $("[id*=rbtnIndian]").attr("checked", true);
                    $("[id*=rbtnOverseas]").attr("checked", false);
                }
                else {
                    $("[id*=rbtnIndian]").attr("checked", false);
                    $("[id*=rbtnOverseas]").attr("checked", true);
                }
                ShowNationality();
                $("[id*=txtNationality]").val($(this).find("Nationality").text());
                $("[id*=txtPassportNo]").val($(this).find("PassPortNo").text());
                $("[id*=txtPPDateofIssue]").val($(this).find("DateOfIssue").text());
                $("[id*=txtPPExpDate]").val($(this).find("ExpiryDate").text());
                $("[id*=txtVisaNumber]").val($(this).find("VisaNo").text());
                $("[id*=txtVisaIssuedDate]").val($(this).find("VisaIssueDate").text());
                $("[id*=txtVisaExpiryDate]").val($(this).find("VisaExpiryDate").text());
                $("[id*=txtVisaType]").val($(this).find("VisaType").text());
                $("[id*=txtPurpose]").val($(this).find("PurposeOfVisit").text());
                $("[id*=txtNoOfEntry]").val($(this).find("NoOfEntry").text());
                $("[id*=txtValidity]").val($(this).find("Validity").text());
                $("[id*=txtRemark]").val($(this).find("Remarks").text());
            });
        };
        var FlgFeesType = "";
        function GetConcession(FeesType) {

            FlgFeesType = $("[id*=ddlConcession]").val();
            if (FlgFeesType == "F") {
                $(".even").each(function () {
                    var AcutalAmt = $(this).find('.ActualAmount').html();
                    if (AcutalAmt != "" && AcutalAmt != null) {
                        $(this).find('.ConcessionAmt').val(AcutalAmt);
                        $(this).find('input.ConcessionAmt').attr("disabled", true);

                    }
                });

            }
            else {
                $(".even").each(function () {
                    $(this).find('.ConcessionAmt').val("");
                    $(this).find('input.ConcessionAmt').attr("disabled", false);
                });
            }

        }

        function SaveConcessionFees() {
            if ($("[id*=ddlConcession]").val() == "") {
                AlertMessage('info', "Select Concession Type !!! ");
            }
            else {
                var AdmissionNo = $("[id*=ddlSection]").val(); //txtAdmissionNo
                if (AdmissionNo != "0" && AdmissionNo != "") {
                    GetInsertQuery();
                }
                else {
                    AlertMessage('info', "This student not yet admitted, Concession can't applicable !!! ");
                }
            }


        }
        function GetInsertQuery() {
            var RegNo = $("[id*=hfRegNo]").val();
            var StudentInfoID = $("[id*=hfStudentInfoID]").val();
            var Academicyear = $("[id*=hfAcademicyear]").val();

            var parameters = '{"StudentInfoID": "' + StudentInfoID + '"}';
            $.ajax({
                type: "POST",
                url: "../Students/StudentInfo.aspx/GetFeesAmount",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetFeesAmountSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        };
        function OnGetFeesAmountSuccess(response) {
            var iCount = 0;
            var sqlstr = "";
            var subQuery = "";
            var MonthName = "";
            var formonth = "";
            var mon = response.d;
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            $(".even").each(function () {
                var dgStudConcessID = $(this).find('td.StudConcessID').html();
                var FeesHeadID = $(this).find('td.FeesHeadID').html();
                var Academicyear = $("[id*=hfAcademicyear]").val();
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                var ConcessAmt = $(this).find('input.ConcessionAmt').val();
                var concessFeesType = $("[id*=ddlConcession]").val();
                var UserId = $("[id*=hfUserId]").val();
                if (ConcessAmt == "") {
                    ConcessAmt = "0.00";
                }

                //                if (dgStudConcessID != null && dgStudConcessID != "" && dgStudConcessID != "&nbsp;") {
                //                    if (ConcessAmt != "" && ConcessAmt != null) {
                //                        iCount = iCount + 1;
                //                        subQuery = "update s_studentconcession set [AcademicId]='" + Academicyear + "',[FeesCatHeadId]='" + FeesHeadID + "',[ConcessType]='" + concessFeesType + "',[RegNo]='" + RegNo + "',[ConcessAmt]='" + ConcessAmt + "',[IsActive]=1,[UserId]='" + UserId + "' where StudConcessID='" + dgStudConcessID + "'";
                //                        sqlstr += subQuery;
                //                    }
                //                }
                //                else {
                //                    if (ConcessAmt != "" && ConcessAmt != null) {
                //                        iCount = iCount + 1;
                //                        subQuery = "insert into s_studentconcession ([AcademicId],[FeesCatHeadId],[ConcessType],[RegNo],[ConcessAmt],[IsActive],[UserId]) values('" + Academicyear + "','" + FeesHeadID + "','" + concessFeesType + "','" + RegNo + "','" + ConcessAmt + "','1','" + UserId + "');";
                //                        sqlstr += subQuery;
                //                    }
                //                }

                if (ConcessAmt != "" && ConcessAmt != null) {
                    iCount = iCount + 1;
                    subQuery = "insert into s_studentconcession ([AcademicId],[FeesCatHeadId],[ConcessType],[RegNo],[ConcessAmt],[IsActive],[UserId]) values('" + Academicyear + "','" + FeesHeadID + "','" + concessFeesType + "','" + RegNo + "','" + ConcessAmt + "','0','" + UserId + "');";
                    sqlstr += subQuery;
                }

            });
            if (iCount == 0) {
                AlertMessage('info', 'Enter Any Concession Amount !');
            }
            else {
                var RegNo = $("[id*=hfRegNo]").val();
                var ConcessReason = $("[id*=txtConcessionReason]").val();
                var Concess;
                if ($("[id*=rbtnConcessYes]").is(':checked')) {
                    Concess = "Y";
                }

                else if ($("[id*=rbtnNoConcess]").is(':checked')) {
                    Concess = "N";
                }
                var parameters = '{"query": "' + sqlstr + '","ConcessReason": "' + ConcessReason + '","RegNo": "' + RegNo + '","Concess": "' + Concess + '"}';
                sqlstr = "";
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/SaveConcessionFeesDetails",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSaveConcessionFeesDetailsSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }

        function OnSaveConcessionFeesDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                GetStudentInfo(StudentID);
                changeAccordion(10);

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                GetStudentInfo(StudentID);
                changeAccordion(10);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }
        };

        function GetOldSchoolInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetOldSchoolInfo",
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
            else {
                return false;
            }
        }

        function OnGetOldSchoolInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var oldschool = xml.find("OldSchool");
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
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("No Records Found").attr("align", "center");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                //  $("td", row).eq(8).html("").removeClass("editacc edit-links"); ;
                $("td", row).eq(8).html("").removeClass("deleteacc delete-links"); ;
                $("td", row).eq(9).html("");
                $("[id*=dgOldSchool]").append(row);
                row = $("[id*=dgOldSchool] tr:last-child").clone(true);

            }


            else {
                $.each(oldschool, function () {
                    row.addClass("even");
                    var ehref = eanchor + $(this).find("StudOldSchID").text() + "','" + $(this).find("RegNo").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StudOldSchID").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("SchoolName").text());
                    $("td", row).eq(2).html($(this).find("Academicyear").text());
                    $("td", row).eq(3).html($(this).find("StdStudied").text());
                    $("td", row).eq(4).html($(this).find("Firstlanguage").text());
                    $("td", row).eq(5).html($(this).find("Medium").text());
                    $("td", row).eq(6).html($(this).find("TCNo").text());
                    $("td", row).eq(7).html($(this).find("TCDate").text());
                    $("td", row).eq(8).html($(this).find("TCReceivedDate").text());
                    //   $("td", row).eq(8).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgOldSchool]").append(row);
                    row = $("[id*=dgOldSchool] tr:last-child").clone(true);


                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    $('.deleteacc').hide();
                }
                else {
                    $('.deleteacc').show();
                }
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

        function EditOldSchoolInfo(StudOldSchID, RegNo) {

            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/EditOldSchoolInfo",
                    data: '{StudOldSchID: ' + StudOldSchID + ',"RegNo": "' + RegNo + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditOldSchoolInfoSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                $("table.form :input").prop('disabled', true);
                return false;
            }
        }

        function OnEditOldSchoolInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var rel = xml.find("OldSchool");
            $.each(rel, function () {
                $("[id*=txtSchoolName]").val($(this).find("SchoolName").text());
                $("[id*=ddlFirstLang]").val($(this).find("Firstlanguage").text());
                $("[id*=ddlMedium]").val($(this).find("Medium").text());
                $("[id*=ddlStartAcademicYr]").val($(this).find("StartAcademicyear").text());
                $("[id*=ddlEndAcademicYr]").val($(this).find("EndAcademicyear").text());
                $("[id*=txtStdFrom]").val($(this).find("StdStudied").text());
                $("[id*=txtTCNo]").val($(this).find("TCNo").text());
                $("[id*=txtTCReceivedDate]").val($(this).find("TCReceivedDate").text());
                $("[id*=txtTCDate]").val($(this).find("TCDate").text());
            });
        };

        function DeleteBusRouteInfo(BusRouteId) {
            var RegNo = $("[id*=hfRegNo]").val();
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Students/StudentInfo.aspx/DeleteBusRouteInfo",
                        data: '{RegNo: ' + RegNo + ',BusRouteId: ' + BusRouteId + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteBusRouteInfoSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }

                    });
                }

            })) {
            }

        }
        function OnDeleteBusRouteInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    $("[id*=ddlRouteCode]").val("");
                    $("[id*=txtDateofBusReg]").val("");
                    GetBusRouteDetails(0);

                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };


        function DeleteAttachmentInfo(StudAttachID) {

            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/StudentInfo.aspx/DeleteAttachmentInfo",
                        data: '{StudAttachID: ' + StudAttachID + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteAttachmentInfoSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }

                    });
                }

            })) {
            }

        }
        function OnDeleteAttachmentInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    GetAttachmentInfo(RegNo);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };


        function DeleteBroSisInfo(StudRelID) {

            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/StudentInfo.aspx/DeleteBroSisInfo",
                        data: '{StudRelID: ' + StudRelID + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteBroSisInfoSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }

                    });
                }

            })) {
            }

        }
        function OnDeleteBroSisInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    GetBroSisInfo(RegNo);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };



        function DeleteOldSchoolInfo(StudOldSchID) {

            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/StudentInfo.aspx/DeleteOldSchoolInfo",
                        data: '{StudOldSchID: ' + StudOldSchID + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteOldSchoolInfoSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }

                    });
                }

            })) {
            }

        }
        function OnDeleteOldSchoolInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    GetOldSchoolInfo(RegNo);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };
        function GetStaffChildrenInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetStaffChildrenInfo",
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
            else {
                return false;
            }
        }
        function EditStaffChildrenInfo(StudStaffID, Relationship) {

            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/EditStaffChildrenInfo",
                    data: '{StudStaffID: ' + StudStaffID + ',"Relationship": "' + Relationship + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditStaffChildrenSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                $("table.form :input").prop('disabled', true);
                return false;
            }
        }

        function OnEditStaffChildrenSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var rel = xml.find("StaffChildren");
            $.each(rel, function () {

                $("[id*=ddlStaff1] option[value='" + $(this).find("EmpCode").text() + "']").attr("selected", "true");
                $("[id*=ddlRelationship1] option[value='" + $(this).find("Relationship").text() + "']").attr("selected", "true");



            });
        };
        function chkpriority() {
            if ($("[id*=hfRegNo]").val() != '') {
                var regno = $("[id*=hfRegNo]").val();
                var str = "select isnull(priority,0) as smspriority from s_studentinfo where regno=" + regno;
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/chkpriority",
                    data: '{str: "' + str + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var xmlDoc = $.parseXML(response.d);
                        var xml = $(xmlDoc);
                        var rel = xml.find("priority");
                        $.each(rel, function () {
                            if ($(this).find("smspriority").text() == "0") {
                                AlertMessage('info', "SMS Prioriy is not yet Set, Do You Want to Set For " + $("[id*=dlRelationship]").val() + "? ");
                                $("[id*=dlSMSPriority]").focus();
                            }
                        });
                    }
                });
            }

        }

        function OnGetStaffChildrenInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var staffchild = xml.find("StaffChildren");
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

            else {
                $.each(staffchild, function () {
                    row.addClass("even");
                    $("#rbtnInsNo").attr("checked", false);
                    $("#rbtnInsYes").attr("checked", true);
                    ShowInstitution();
                    var ehref = eanchor + $(this).find("StudStaffID").text() + "','" + $(this).find("Relationship").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StudStaffID").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("StaffName").text());
                    $("td", row).eq(2).html($(this).find("Relationship").text());
                    $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgInstitution]").append(row);
                    row = $("[id*=dgInstitution] tr:last-child").clone(true);


                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    $('.deleteacc').hide();
                }
                else {
                    $('.deleteacc').show();
                }
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

        function DeleteStaffChildrenInfo(StudStaffID, Relation) {

            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/StudentInfo.aspx/DeleteStaffChildrenInfo",
                        data: '{StudStaffID: ' + StudStaffID + ',"Relation": "' + Relation + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteStaffChildrenInfoSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }

                    });
                }

            })) {
            }

        }
        function OnDeleteStaffChildrenInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    GetStaffChildrenInfo(RegNo);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };




        function GetMedicalRemarkInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetMedicalRemarkInfo",
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
            else {
                return false;
            }
        }

        function OnGetMedicalRemarkInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var MedRem = xml.find("MedicalRemark");
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
                $("td", row).eq(4).html("").removeClass("download-links");
                $("td", row).eq(5).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(6).html("");
                $("[id*=dgMedRemarks]").append(row);
                row = $("[id*=dgMedRemarks] tr:last-child").clone(true);

            }
            else {

                $.each(MedRem, function () {
                    row.addClass("even");
                    var ehref = eanchor + $(this).find("MedRemarkID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("MedRemarkID").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("RemarkDate").text());
                    $("td", row).eq(3).html($(this).find("Description").text());
                    $("td", row).eq(4).html("<a target='_blank' href=../Students/MedicalRemarks/" + $(this).find("FileName").text() + ">" + $(this).find("FileName").text() + "</a>").addClass("download-links");
                    // $("td", row).eq(6).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(5).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgMedRemarks]").append(row);
                    row = $("[id*=dgMedRemarks] tr:last-child").clone(true);


                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    $('.deleteacc').hide();
                }
                else {
                    $('.deleteacc').show();
                }
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

        function DeleteMedRemarksInfo(MedRemarkId) {
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/StudentInfo.aspx/DeleteMedicalRemarkInfo",
                        data: '{MedRemarkId: ' + MedRemarkId + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteMedicalRemarkSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }

                    });
                }

            })) {
            }

        }
        function OnDeleteMedicalRemarkSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    GetMedicalRemarkInfo(RegNo);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };




        function GetAcademicRemarkInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetAcademicRemarkInfo",
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
            else {
                return false;
            }
        }

        function OnGetAcademicRemarkInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var MedRem = xml.find("AcademicRemark");
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

            else {
                $.each(MedRem, function () {
                    row.addClass("even");
                    var ehref = eanchor + $(this).find("RemarkID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("RemarkID").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("RemarkDate").text());
                    $("td", row).eq(3).html($(this).find("Remarks").text());
                    // $("td", row).eq(6).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgAcademicRemarks]").append(row);
                    row = $("[id*=dgAcademicRemarks] tr:last-child").clone(true);


                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    $('.deleteacc').hide();
                }
                else {
                    $('.deleteacc').show();
                }
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

        function DeleteAcademicRemarksInfo(RemarkId) {
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/StudentInfo.aspx/DeleteAcademicRemarkInfo",
                        data: '{RemarkId: ' + RemarkId + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteAcademicRemarkSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }

                    });
                }

            })) {
            }

        }
        function OnDeleteAcademicRemarkSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    GetAcademicRemarkInfo(RegNo);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };



        function GetBroSisInfo(RegNo) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetBroSisInfo",
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
            else {
                return false;
            }
        }

        function OnGetBroSisInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var BroSis = xml.find("BroSis");
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
            else {
                $("#chkBroSis").attr("checked", "true");
                showbrosis();
                $.each(BroSis, function () {
                    row.addClass("even");
                    var ehref = eanchor + $(this).find("RegNo").text() + "','" + $(this).find("StudRelID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StudRelID").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("Relation").text());
                    $("td", row).eq(3).html($(this).find("StudentName").text());
                    $("td", row).eq(4).html($(this).find("Class").text());
                    $("td", row).eq(5).html($(this).find("Section").text());
                    $("td", row).eq(6).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(7).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgBroSis]").append(row);
                    row = $("[id*=dgBroSis] tr:last-child").clone(true);


                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    $('.deleteacc').hide();
                }
                else {
                    $('.deleteacc').show();
                }
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

        function EditBroSisInfo(ID, relationId) {
            if (ID == "" || ID == null) {
                ID = "0";
            }
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({

                    type: "POST",
                    url: "../Students/StudentInfo.aspx/EditBroSisInfo",
                    data: '{regno: ' + ID + ',"relationId": "' + relationId + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditBroSisSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                $("table.form :input").prop('disabled', true);
                return false;
            }
        }
        var BroSisFlagSectionID = -1;
        var BroSisFlagStudentID = -1;
        function OnEditBroSisSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var rel = xml.find("EditBroSis");
            $.each(rel, function () {
                var ClassID = $(this).find("ClassID").text();
                $("[id*=ddlBroSisClass] option[value='" + ClassID + "']").attr("selected", "true");
                BroSisFlagSectionID = $(this).find("SectionID").text();
                GetBroSisSectionByBroSisClass();
                var StudentRelationID = $(this).find("StudentRelationID").text();
                BroSisFlagStudentID = StudentRelationID;


                var Relation = $(this).find("Relation").text();
                $("[id*=ddlBroSisRelation] option[value='" + Relation.toUpperCase() + "']").attr("selected", "true");

            });
        };

        function DeleteRelationshipInfo(ID, type) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({

                    type: "POST",
                    url: "../Students/StudentInfo.aspx/DeleteRelationshipInfo",
                    data: '{studentid: ' + ID + ',"type": "' + type + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnDeleteRelationshipSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                $("table.form :input").prop('disabled', true);
                return false;
            }
        }

        function OnDeleteRelationshipSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var StudentID = $("[id*=hfStudentInfoID]").val();
                GetStudentInfo(StudentID);

            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };

        function EditRelationshipInfo(ID, type) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({

                    type: "POST",
                    url: "../Students/StudentInfo.aspx/EditRelationshipInfo",
                    data: '{studentid: ' + ID + ',"type": "' + type + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditRelationshipSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                $("table.form :input").prop('disabled', true);
                return false;
            }
        }

        function OnEditRelationshipSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var rel = xml.find("EditRelationship");
            $.each(rel, function () {
                if ($(this).find("Relation").text() == "Father") {
                    $("[id*=ddlRelationship] option[value='" + $(this).find("Relation").text() + "']").attr("selected", "true");
                    $("[id*=ddlSMSPriority] option[value='" + $(this).find("Priority").text() + "']").attr("selected", "true");
                }
                else if ($(this).find("Relation").text() == "Mother") {
                    $("[id*=ddlRelationship] option[value='" + $(this).find("Relation").text() + "']").attr("selected", "true");
                    $("[id*=ddlSMSPriority] option[value='" + $(this).find("Priority").text() + "']").attr("selected", "true");
                }
                else {
                    $("[id*=ddlRelationship] option[value='" + $(this).find("Relation").text() + "']").attr("selected", "true");
                    $("[id*=ddlSMSPriority] option[value='" + $(this).find("Priority").text() + "']").attr("selected", "true");
                }
                $("[id*=txtName]").val($(this).find("Name").text());
                $("[id*=txtOccupation]").val($(this).find("Occupation").text());
                $("[id*=txtIncome]").val($(this).find("Income").text());
                $("[id*=txtOccAddress]").val($(this).find("OccAddress").text());
                $("[id*=txtQualification]").val($(this).find("Qual").text());
                $("[id*=txtRelMobile]").val($(this).find("Cell").text());
                $("[id*=txtRelEmail]").val($(this).find("RelEmail").text());

            });
        };


        function SaveandPayAdvanceFees() {
            if (($("[id*=hfAddPrm]").val() == 'true') || ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnAdvanceFees]").attr("disabled", "true");
                    var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                    var StudentName = $("[id*=txtStudentName]").val();
                    var Gender;
                    if ($("[id*=rbtnMale]").is(':checked')) {
                        Gender = "M";
                    }

                    else if ($("[id*=rbtnFemale]").is(':checked')) {
                        Gender = "F";
                    }
                    var Class = $("[id*=ddlClass]").val();
                    var Classname = $("[id*=ddlClass] option[value='" + Class + "']").html();

                    var Section = $("[id*=ddlSection]").val();
                    var Sectionname = $("[id*=ddlSection] option[value='" + Section + "']").html();

                    var DOB = $("[id*=txtDOB]").val();
                    var DOJ = $("[id*=txtDOJ]").val();
                    var MotherTongue = $("[id*=txtMotherTongue]").val();
                    var Religion = $("[id*=ddlReligion]").val();
                    var Community = $("[id*=ddlCommunity]").val();
                    var Caste = $("[id*=ddlCaste]").val();
                    var Aadhaar = $("[id*=txtAadhaar]").val();
                    var TempAddress = $("[id*=txtTempAddress]").val();
                    var PerAddress = $("[id*=txtPerAddress]").val();
                    var Email = $("[id*=txtEmail]").val();
                    var PhoneNo = $("[id*=txtPhoneNo]").val();
                    var RationCard = $("[id*=txtRationCardNo]").val();
                    var SmartCard = $("[id*=txtSmartCardNo]").val();
                    var tempfile = $('#FuPhoto').val().replace(/C:\\fakepath\\/i, ''); ;
                    var PhotoFile = tempfile.substring(tempfile.lastIndexOf('\\') + 1);
                    var PhotoPath = $('#FuPhoto').val().replace(/C:\\fakepath\\/i, ''); ;
                    var SSLCNo = $("[id*=txtSSLC]").val();
                    var SSLCYear = $("[id*=ddlSSLC]").val();
                    var HSCNo = $("[id*=txtHSC]").val();
                    var HSCYear = $("[id*=ddlHSC]").val();
                    var SUID = $("[id*=txtSUID]").val();
                    var Tamilname = $("[id*=txtTamilname]").val();
                    if (Section == "New") {
                        Section = "";
                    }
                    var Academicyear = $("[id*=hfAcademicyear]").val();
                    var parameters = '{"id": "' + StudentInfoID + '","studentname": "' + StudentName + '","classname": "' + Classname + '","classid": "' + Class + '","sectionname": "' + Section + '","gender": "' + Gender + '","dob": "' + DOB + '","doj": "' + DOJ + '","religion": "' + Religion + '","mtongue": "' + MotherTongue + '","community": "' + Community + '","caste": "' + Caste + '","aadhaar": "' + Aadhaar + '","tempaddress": "' + TempAddress + '","peraddress": "' + PerAddress + '","email": "' + Email + '","phoneno": "' + PhoneNo + '","smartcard": "' + SmartCard + '","rationcard": "' + RationCard + '","photopath": "' + PhotoPath + '","photofile": "' + PhotoFile + '","sslcno": "' + SSLCNo + '","sslcyear": "' + SSLCYear + '","hscno": "' + HSCNo + '","hscyear": "' + HSCYear + '","suid": "' + SUID + '","tamilname": "' + Tamilname + '","academicyear": "' + Academicyear + '","academicyear": "' + Academicyear + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Students/StudentInfo.aspx/SaveandPayAdvanceFees",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveandPayAdvanceFeesSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
            }
            else {
                return false;
            }
        }

        // Save On Success
        function OnSaveandPayAdvanceFeesSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d) {
                AlertMessage('success', 'Inserted');
                $("[id*=hfRegNo]").val(response.d);
                var RegNo = $("[id*=hfRegNo]").val();
                var url = "../Fees/AdvanceFees.aspx?menuId=" + $("[id*=hfAdvMenuId]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfAdvModuleID]").val() + "&RegNo=" + RegNo + "";
                $(location).attr('href', url)
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }


        };



        // Save StudentInfo
        function SavePersonalDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') || ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnPersonalSubmit]").attr("disabled", "true");
                    var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                    var StudentName = $("[id*=txtStudentName]").val();
                    var Gender;
                    if ($("[id*=rbtnMale]").is(':checked')) {
                        Gender = "M";
                    }

                    else if ($("[id*=rbtnFemale]").is(':checked')) {
                        Gender = "F";
                    }
                    var Class = $("[id*=ddlClass]").val();
                    var Classname = $("[id*=ddlClass] option[value='" + Class + "']").html();

                    var Section = $("[id*=ddlSection]").val();
                    var Sectionname = $("[id*=ddlSection] option[value='" + Section + "']").html();

                    var DOB = $("[id*=txtDOB]").val();
                    var DOJ = $("[id*=txtDOJ]").val();
                    var MotherTongue = $("[id*=txtMotherTongue]").val();
                    var Religion = $("[id*=ddlReligion]").val();
                    var Community = $("[id*=ddlCommunity]").val();
                    var Caste = $("[id*=ddlCaste]").val();
                    var Aadhaar = $("[id*=txtAadhaar]").val();
                    var TempAddress = $("[id*=txtTempAddress]").val();
                    var PerAddress = $("[id*=txtPerAddress]").val();
                    var Email = $("[id*=txtEmail]").val();
                    var PhoneNo = $("[id*=txtPhoneNo]").val();
                    var RationCard = $("[id*=txtRationCardNo]").val();
                    var SmartCard = $("[id*=txtSmartCardNo]").val();
                    var tempfile = $('#FuPhoto').val().replace(/C:\\fakepath\\/i, ''); ;
                    var PhotoFile = tempfile.substring(tempfile.lastIndexOf('\\') + 1);
                    var PhotoPath = $('#FuPhoto').val().replace(/C:\\fakepath\\/i, ''); ;
                    var sstatus = $("[id*=ddlStatus]").val();
                    var SSLCNo = $("[id*=txtSSLC]").val();
                    var SSLCYear = $("[id*=ddlSSLC]").val();
                    var HSCNo = $("[id*=txtHSC]").val();
                    var HSCYear = $("[id*=ddlHSC]").val();
                    var SUID = $("[id*=txtSUID]").val();
                    var Tamilname = $("[id*=txtTamilname]").val();
                    if (Section == "New") {
                        Section = "";
                    }
                    if (sstatus == "---Select---") {
                        sstatus = "";
                    }

                    var Academicyear = $("[id*=hfAcademicyear]").val();
                    var parameters = '{"id": "' + StudentInfoID + '","studentname": "' + StudentName + '","classname": "' + Classname + '","classid": "' + Class + '","sectionname": "' + Section + '","gender": "' + Gender + '","dob": "' + DOB + '","doj": "' + DOJ + '","religion": "' + Religion + '","mtongue": "' + MotherTongue + '","community": "' + Community + '","caste": "' + Caste + '","aadhaar": "' + Aadhaar + '","tempaddress": "' + TempAddress + '","peraddress": "' + PerAddress + '","email": "' + Email + '","phoneno": "' + PhoneNo + '","smartcard": "' + SmartCard + '","rationcard": "' + RationCard + '","photopath": "' + PhotoPath + '","photofile": "' + PhotoFile + '","sslcno": "' + SSLCNo + '","sslcyear": "' + SSLCYear + '","hscno": "' + HSCNo + '","hscyear": "' + HSCYear + '","suid": "' + SUID + '","tamilname": "' + Tamilname + '","academicyear": "' + Academicyear + '","sstatus": "' + sstatus + '","userid": "' + $("[id*=hfuserid]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Students/StudentInfo.aspx/SaveStudentInfo",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSavePersonalDetailsSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
            }
            else {
                return false;
            }
        }

        // Save On Success
        function OnSavePersonalDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {

                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                if (formdata) {
                    formdata.append("StudenInfoId", RegNo);
                    if (formdata) {
                        $.ajax({
                            url: "../Students/StudentInfo.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                            }
                        });
                    }
                }
                PersonalDetailsClear();
                GetStudentInfo($("[id*=hfStudentInfoID]").val());
                changeAccordion(1);
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d) {
                var strRegNo = response.d.toString().split(",");
                AlertMessage('success', 'Inserted');
                $("[id*=hfRegNo]").val(strRegNo[0]);
                $("[id*=hfStudentInfoID]").val(strRegNo[1]);
                var RegNo = $("[id*=hfRegNo]").val();

                if (formdata) {
                    formdata.append("StudenInfoId", RegNo);
                    if (formdata) {
                        $.ajax({
                            url: "../Students/StudentInfo.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                            }
                        });
                    }
                }
                PersonalDetailsClear();
                GetStudentInfo($("[id*=hfStudentInfoID]").val());
                changeAccordion(1);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }


        };

        function SaveFamilyDetails() {

            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                //#aspnetForm
                if ($("[id*=hfRegNo]").val() != '') {

                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnRelationshipSubmit]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var Relationship = $("[id*=ddlRelationship]").val();
                        var RelName = $("[id*=txtName]").val();
                        var RelQualification = $("[id*=txtQualification]").val();
                        var RelIncome = $("[id*=txtIncome]").val();
                        var RelOccupation = $("[id*=txtOccupation]").val();
                        var RelEmail = $("[id*=txtRelEmail]").val();
                        var RelMobile = $("[id*=txtRelMobile]").val();
                        var OccAddress = $("[id*=txtOccAddress]").val();
                        var SMSPriority = $("[id*=ddlSMSPriority]").val();
                        var Caretaker;
                        if ($("[id*=rbtnParent]").is(':checked')) {
                            Caretaker = "Parent";
                        }

                        else if ($("[id*=rbtnGaurdian]").is(':checked')) {
                            Caretaker = "Guardian";
                        }
                        if (Relationship == "Father" || Relationship == "Mother" || Relationship == "Guardian I" || Relationship == "Guardian II") {

                            var parameters = '{"id": "' + RegNo + '","relationship": "' + Relationship + '","name": "' + RelName + '","qual": "' + RelQualification + '","inc": "' + RelIncome + '","occ": "' + RelOccupation + '","email": "' + RelEmail + '","cell": "' + RelMobile + '","addr": "' + OccAddress + '","priority": "' + SMSPriority + '","caretaker": "' + Caretaker + '"}';
                            var baseurl = "../Students/StudentInfo.aspx/SaveFamilyInfo";
                        }
                        // else {
                        //  var parameters = '{"id": "' + RegNo + '","gname": "' + RelName + '","gaddr": "' + OccAddress + '","gphno": "' + RelMobile + '","priority": "' + SMSPriority + '","qual": "' + RelQualification + '","inc": "' + RelIncome + '","occ": "' + RelOccupation + '","email": "' + RelEmail + '"}';
                        //  var baseurl = "../Students/StudentInfo.aspx/SaveGuardianInfo";
                        //  }
                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveFamilyDetailsSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }


        // Save On Success
        function OnSaveFamilyDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {

                AlertMessage('success', 'Updated');
                var StudentID = $("[id*=hfStudentInfoID]").val();
                FamilyDetailsClear();
                GetStudentInfo(StudentID);
                //changeAccordion(2);
                $("#chkBroSis").attr("checked", "false");
                showbrosis();

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d) {
                AlertMessage('success', 'Inserted');
                var StudentID = $("[id*=hfStudentInfoID]").val();
                FamilyDetailsClear();
                GetStudentInfo(StudentID);
                //changeAccordion(2);
                $("#chkBroSis").attr("checked", "false");
                showbrosis();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }


        };



        function SaveBroSisDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnBroSisAdd]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var Class = $("[id*=ddlBroSisClass]").val();
                        var Section = $("[id*=ddlBroSisSection]").val();
                        var RelationId = $("[id*=ddlBroSisStudentName]").val();
                        var Relation = $("[id*=ddlBroSisRelation]").val();

                        var parameters = '{"id": "' + RegNo + '","relationid": "' + RelationId + '","relation": "' + Relation + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveBroSisInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveBroSisDetailsSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }
        // Save On Success
        function OnSaveBroSisDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                BroSisDetailsClear();
                GetStudentInfo(StudentID);
                // changeAccordion(3);


            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                BroSisDetailsClear();
                GetStudentInfo(StudentID);
                //changeAccordion(3);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };


        function SaveMedicalDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnMedicalSave]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var BloodGroup = $("[id*=ddlBloodGroup]").val();
                        var Disease = $("[id*=txtDisease]").val();
                        var Height = $("[id*=txtHeight]").val();
                        var Weight = $("[id*=txtWeight]").val();
                        var EmergencyPhNo = $("[id*=txtEmergencyPhNo]").val();
                        var FamilyDocName = $("[id*=txtFamilyDocName]").val();
                        var FamilyDocAdd = $("[id*=txtFamilyDocAdd]").val();
                        var FamilyDocPhNo = $("[id*=txtFamilyDocPhNo]").val();
                        var IdentificationMarks = $("[id*=txtIdentificationMarks1]").val() + ":" + $("[id*=txtIdentificationMarks2]").val();
                        var Physical;
                        if ($("[id*=rbtnPHYes]").is(':checked')) {
                            Physical = "Y";
                        }

                        else if ($("[id*=rbtnNoPH]").is(':checked')) {
                            Physical = "N";
                        }
                        var PhysicalHandicapped = $("[id*=txtPhysicalHandicapped]").val();

                        var parameters = '{"id": "' + RegNo + '","bloodgroup": "' + BloodGroup + '","disease": "' + Disease + '","height": "' + Height + '","weight": "' + Weight + '","emergencyphno": "' + EmergencyPhNo + '","familydocname": "' + FamilyDocName + '","familydocadd": "' + FamilyDocAdd + '","familydocphno": "' + FamilyDocPhNo + '","identificationmarks": "' + IdentificationMarks + '","physical": "' + Physical + '","physicalhandicapped": "' + PhysicalHandicapped + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveMedicalInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveMedicalDetailsSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveMedicalDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                MedicalDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(4);


            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                MedicalDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(4);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };

        function SaveMedRemDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnMedRemSave]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var MedRemDate = $("[id*=txtMedRemDate]").val();
                        var MedRemReason = $("[id*=txtMedRemReason]").val();
                        var filename = $("[id*=fuMedRem]").val().replace(/C:\\fakepath\\/i, '');
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        var parameters = '{"id": "' + RegNo + '","academicid": "' + Academicyear + '","remarkdate": "' + MedRemDate + '","description": "' + MedRemReason + '","filename": "' + filename + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveMedicalRemarkInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveMedicalRemarkDetailsSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveMedicalRemarkDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d) {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                var MedRemDate = $("[id*=txtMedRemDate]").val();
                var MaxId = response.d;
                formdata.append("StudenInfoId", StudentID);
                formdata.append("MedRemDate", MedRemDate);
                formdata.append("MaxId", MaxId);
                if (formdata) {
                    $.ajax({
                        url: "../Students/StudentInfo.aspx",
                        type: "POST",
                        data: formdata,
                        processData: false,
                        contentType: false,
                        success: function (res) {
                        }
                    });
                }
                MedicalDetailsClear();
                GetStudentInfo(StudentID);
                // changeAccordion(5);


            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                var MedRemDate = $("[id*=txtMedRemDate]").val();
                var MaxId = response.d;
                formdata.append("StudenInfoId", StudentID);
                formdata.append("MedRemDate", MedRemDate);
                formdata.append("MaxId", MaxId);
                if (formdata) {
                    $.ajax({
                        url: "../Students/StudentInfo.aspx",
                        type: "POST",
                        data: formdata,
                        processData: false,
                        contentType: false,
                        success: function (res) {
                        }
                    });
                }
                MedicalDetailsClear();
                GetStudentInfo(StudentID);
                // changeAccordion(5);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };



        function SaveAcademicDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnAcademicDetailsSubmit]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var AdmissionNo = $("[id*=txtAdmissionNo]").val();

                        var Class = $("[id*=ddlAdClass]").val();
                        var Classname = $("[id*=ddlAdClass] option[value='" + Class + "']").html();

                        var Section = $("[id*=ddlAdSection]").val();
                        var Sectionname = $("[id*=ddlAdSection] option[value='" + Section + "']").html();


                        var DOA = $("[id*=txtDOA]").val();
                        var Mode = $("[id*=ddlModeofTrans]").val();
                        var ModeofTrans = $("[id*=ddlModeofTrans] option[value='" + Mode + "']").html();

                        var Medium = $("[id*=ddlSchoolMedium]").val();
                        var Firstlang = $("[id*=txtFirstlang]").val();
                        var Seclang = $("[id*=ddlSeclang]").val();
                        //                        var Scholar;
                        //                        if ($("[id*=rbtnScholarYes]").is(':checked')) {
                        //                            Scholar = "Y";
                        //                        }

                        //                        else if ($("[id*=rbtnNoScholar]").is(':checked')) {
                        //                            Scholar = "N";
                        //                        }
                        //                        var Scholarship = $("[id*=ddlScholarship]").val();
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        if (Sectionname == "New") {
                            Sectionname = "";
                        }
                        if (Classname == "---Select---") {
                            Classname = "";
                        }

                        var emp1 = $("[id*=ddlStaff1]").val();
                        var emp2 = $("[id*=ddlStaff2]").val();
                        var relation1 = $("[id*=ddlRelationship1]").val();
                        var relation2 = $("[id*=ddlRelationship2]").val();
                        var sstatus = $("[id*=ddlStatus]").val();
                        var parameters = '{"id": "' + RegNo + '","admissionno": "' + AdmissionNo + '","adclassname": "' + Class + '","adsectionname": "' + Section + '","doa": "' + DOA + '","modeoftrans": "' + Mode + '","medium": "' + Medium + '","firstlang": "' + Firstlang + '","seclang": "' + Seclang + '","academicid": "' + Academicyear + '","emp1": "' + emp1 + '","emp2": "' + emp2 + '","relation1": "' + relation1 + '","relation2": "' + relation2 + '","sstatus": "' + sstatus + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveAcademicInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveAcademicDetailsSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveAcademicDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                AcademicDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(6);


            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                AcademicDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(6);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };

        function SaveScholarshipDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnScholarshipSubmit]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();

                        var Scholar;
                        if ($("[id*=rbtnScholarYes]").is(':checked')) {
                            Scholar = "Y";
                        }

                        else if ($("[id*=rbtnNoScholar]").is(':checked')) {
                            Scholar = "N";
                        }
                        var Scholarship = $("[id*=ddlScholarship]").val();
                        var Academicyear = $("[id*=hfAcademicyear]").val();

                        var parameters = '{"id": "' + RegNo + '","academicid": "' + Academicyear + '","scholar": "' + Scholar + '","scholarship": "' + Scholarship + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveScholarshipInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveScholarshipDetailsSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveScholarshipDetailsSuccess(response) {
            if (response.d == "Updated") {
                var RegNo = $("[id*=hfRegNo]").val();
                GetScholarshipInfo(RegNo);
            }
            else {
                alert(response.d);
            }
        }

        function SaveAcademicRemarkDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnAAcademicRemarks]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var RemDate = $("[id*=txtAcaRemDate]").val();
                        var RemReason = $("[id*=txtAcaRemarks]").val();
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        var parameters = '{"id": "' + RegNo + '","academicid": "' + Academicyear + '","remarkdate": "' + RemDate + '","remarks": "' + RemReason + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveAcademicRemarkInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveAcademicRemarkDetailsSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveAcademicRemarkDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                AcademicRemarksDetailsClear();
                GetStudentInfo(StudentID);
                // changeAccordion(7);


            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                AcademicRemarksDetailsClear();
                GetStudentInfo(StudentID);
                // changeAccordion(7);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };


        function SaveBusRouteDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnBusRouteSubmit]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var BusFacility;
                        if ($("[id*=rbtnBusYes]").is(':checked')) {
                            BusFacility = "Y";
                        }

                        else if ($("[id*=rbtnBusNo]").is(':checked')) {
                            BusFacility = "N";
                        }
                        var RouteCode = $("[id*=ddlRouteCode]").val();
                        var RegDate = $("[id*=txtDateofBusReg]").val();
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        var parameters = '{"id": "' + RegNo + '","academicid": "' + Academicyear + '","routeid": "' + RouteCode + '","Busfacility": "' + BusFacility + '","regdate": "' + RegDate + '","status": "' + BusFacility + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveBusRouteInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveBusRouteDetailsSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveBusRouteDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                BusRouteDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(9);

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                BusRouteDetailsClear();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                GetStudentInfo(StudentID);
                changeAccordion(9);

            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }
            else {
                AlertMessage('info', response.d);
                $("[id*=btnBusRouteSubmit]").attr("disabled", "false");
            }

        };



        function SaveHostelDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnHostelSubmit]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var Hostel;
                        if ($("[id*=rbtnHostelYes]").is(':checked')) {
                            Hostel = "Y";
                        }

                        else if ($("[id*=rbtnHostelNo]").is(':checked')) {
                            Hostel = "N";
                        }
                        var hostelid = $("[id*=ddlHostel]").val();
                        var blockid = $("[id*=ddlBlock]").val();
                        var roomid = $("[id*=ddlRooms]").val();
                        var RegDate = $("[id*=txtDateofHostelAdmn]").val();
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        var parameters = '{"id": "' + RegNo + '","academicid": "' + Academicyear + '","hostelid": "' + hostelid + '","blockid": "' + blockid + '","roomid": "' + roomid + '","regdate": "' + RegDate + '","status": "' + Hostel + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveHostelInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveHostelInfoSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveHostelInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                HostelDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(8);

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                HostelDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(8);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };

        function SaveOldSchoolDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnTCSave]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var SchoolName = $("[id*=txtSchoolName]").val();
                        var StartAcademicYr = $("[id*=ddlStartAcademicYr]").val();
                        var EndAcademicYr = $("[id*=ddlEndAcademicYr]").val();
                        var StdFrom = $("[id*=txtStdFrom]").val();
                        var FirstLang = $("[id*=ddlFirstLang]").val();
                        var Medium = $("[id*=ddlMedium]").val();
                        var TCNo = $("[id*=txtTCNo]").val();
                        var TCDate = $("[id*=txtTCDate]").val();
                        var TCReceivedDate = $("[id*=txtTCReceivedDate]").val();
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        var parameters = '{"ID": "' + RegNo + '","SchoolName": "' + SchoolName + '","StartAcademicYr": "' + StartAcademicYr + '","EndAcademicYr": "' + EndAcademicYr + '","StdFrom": "' + StdFrom + '","FirstLang": "' + FirstLang + '","iMedium": "' + Medium + '","TCNo": "' + TCNo + '","TCDate": "' + TCDate + '","TCReceivedDate": "' + TCReceivedDate + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveOldSchoolInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveOldSchoolInfoSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveOldSchoolInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                OldSchoolDetailsClear();
                GetStudentInfo(StudentID);
                //  changeAccordion(11);

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                OldSchoolDetailsClear();
                GetStudentInfo(StudentID);
                // changeAccordion(11);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };

        function SaveNationalityDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnNationalitySave]").attr("disabled", "true");
                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var IsNative;
                        var Nationality;
                        if ($("[id*=rbtnIndian]").is(':checked')) {
                            IsNative = "Y";
                            Nationality = "Indian";
                        }
                        else if ($("[id*=rbtnOverseas]").is(':checked')) {
                            IsNative = "N";
                            Nationality = $("[id*=txtNationality]").val();
                        }

                        var PassportNo = $("[id*=txtPassportNo]").val();
                        var PPDateofIssue = $("[id*=txtPPDateofIssue]").val();
                        var VisaNumber = $("[id*=txtVisaNumber]").val();
                        var PPExpDate = $("[id*=txtPPExpDate]").val();
                        var VisaType = $("[id*=txtVisaType]").val();
                        var VisaIssuedDate = $("[id*=txtVisaIssuedDate]").val();
                        var VisaExpiryDate = $("[id*=txtVisaExpiryDate]").val();
                        var NoOfEntry = $("[id*=txtNoOfEntry]").val();
                        var Validity = $("[id*=txtValidity]").val();
                        var Purpose = $("[id*=txtPurpose]").val();
                        var Remark = $("[id*=txtRemark]").val();
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        var parameters = '{"ID": "' + RegNo + '","IsNative": "' + IsNative + '","Nationality": "' + Nationality + '","PassportNo": "' + PassportNo + '","PPDateofIssue": "' + PPDateofIssue + '","VisaNumber": "' + VisaNumber + '","PPExpDate": "' + PPExpDate + '","VisaType": "' + VisaType + '","VisaIssuedDate": "' + VisaIssuedDate + '","VisaExpiryDate": "' + VisaExpiryDate + '","NoOfEntry": "' + NoOfEntry + '","Validity": "' + Validity + '","Purpose": "' + Purpose + '","Remark": "' + Remark + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveNationalityInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveNationalityInfoSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveNationalityInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                NationalityDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(12);

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                NationalityDetailsClear();
                GetStudentInfo(StudentID);
                changeAccordion(12);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };



        function SaveAttachmentDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnAttachmentSave]").attr("disabled", "true");

                        var StudentInfoID = $("[id*=hfStudentInfoID]").val();
                        var RegNo = $("[id*=hfRegNo]").val();
                        var Title = $("[id*=txtAttTitle]").val();
                        var Description = $("[id*=txtAttDescription]").val();
                        var Filename = $("[id*=AttFile1]").val().replace(/C:\\fakepath\\/i, '');
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        var parameters = '{"id": "' + RegNo + '","Title": "' + Title + '","Description": "' + Description + '","Filename": "' + Filename + '"}';
                        var baseurl = "../Students/StudentInfo.aspx/SaveAttachmentInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveAttachmentInfoSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveAttachmentInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d) {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                var MaxId = response.d;
                formdata.append("StudenInfoId", StudentID);
                formdata.append("MaxId", MaxId);
                if (formdata) {
                    $.ajax({
                        url: "../Students/StudentInfo.aspx",
                        type: "POST",
                        data: formdata,
                        processData: false,
                        contentType: false,
                        success: function (res) {
                        }
                    });
                }
                AttachmentInfoClear();
                GetStudentInfo(StudentID);
                //  changeAccordion(12);


            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hfRegNo]").val();
                var StudentID = $("[id*=hfStudentInfoID]").val();
                var MaxId = response.d;
                formdata.append("StudenInfoId", StudentID);
                formdata.append("MaxId", MaxId);
                if (formdata) {
                    $.ajax({
                        url: "../Students/StudentInfo.aspx",
                        type: "POST",
                        data: formdata,
                        processData: false,
                        contentType: false,
                        success: function (res) {
                        }
                    });
                }
                AttachmentInfoClear();
                GetStudentInfo(StudentID);
                //  changeAccordion(12);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }

        };




        function PersonalDetailsClear() {

            $('#img_prev').attr('src', "../img/photo.jpg");
            $("[id*=txtStudentName]").val("");
            $("[id*=txtDOB]").val("");
            $("[id*=txtMotherTongue]").val("");
            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            $("[id*=ddlReligion]").val("");
            $("[id*=ddlCommunity]").val("");
            $("[id*=ddlCaste]").val("");
            $("[id*=txtAadhaar]").val("");
            $("[id*=txtTempAddress]").val("");
            $("[id*=txtPerAddress]").val("");
            $("[id*=txtEmail]").val("");
            $("[id*=txtPhoneNo]").val("");
            $("[id*=txtHSC]").val("");
            $("[id*=txtSSLC]").val("");
            $("[id*=ddlSSLC]").val("");
            $("[id*=ddlHSC]").val("");
            $("[id*=txtSUID]").val("");
            $("[id*=txtTamilname]").val("");
            
            $("[id*=FuPhoto]").val("");
            $("[id*=btnPersonalSubmit]").attr("disabled", "false");
            $("[id*=btnAdvanceFees]").attr("disabled", "false");

            $("[id*=spPersonalSubmit]").html("Save");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
            $('#aspnetForm').validate().resetForm();
        }
        function FamilyDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=ddlRelationship]").val("");
            $("[id*=txtName]").val("");
            $("[id*=txtQualification]").val("");
            $("[id*=txtIncome]").val("");
            $("[id*=txtRelEmail]").val("");
            $("[id*=txtOccupation]").val("");
            $("[id*=txtRelMobile]").val("");
            $("[id*=txtOccAddress]").val("");
            $("[id*=ddlSMSPriority]").val("");
            $("[id*=btnRelationshipSubmit]").attr("disabled", "false");
            $("#chkBroSis").attr("checked", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        }

        function BroSisDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=ddlBroSisClass]").val("");
            $("[id*=ddlBroSisSection]").val("");
            $("[id*=ddlBroSisStudentName]").val("");
            $("[id*=ddlBroSisRelation]").val("");
            $("[id*=btnBroSisAdd]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
        function MedicalDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=ddlBloodGroup]").val("");
            $("[id*=txtDisease]").val("");
            $("[id*=txtHeight]").val("");
            $("[id*=txtWeight]").val("");
            $("[id*=txtEmergencyPhNo]").val("");
            $("[id*=txtFamilyDocName]").val("");
            $("[id*=txtFamilyDocAdd]").val("");
            $("[id*=txtFamilyDocPhNo]").val("");
            $("[id*=txtIdentificationMarks1]").val("");
            $("[id*=txtIdentificationMarks2]").val("");
            $("[id*=txtPhysicalHandicapped]").val("");
            $("[id*=txtPhysicalHandicapped]").val("");
            $("[id*=txtMedRemDate]").val("");
            $("[id*=txtMedRemReason]").val("");
            $("[id*=btnMedicalSave]").attr("disabled", "false");
            $("[id*=btnMedRemSave]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function AcademicDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtAdmissionNo]").val("");
            $("[id*=ddlAdClass]").val("");
            $("[id*=ddlAdSection]").val("");
            $("[id*=txtDOJ]").val("");
            $("[id*=ddlModeofTrans]").val("");
            $("[id*=ddlSchoolMedium]").val("");
            $("[id*=txtFirstlang]").val("");
            $("[id*=ddlSeclang]").val("");
            $("[id*=ddlStaff1]").val("");
            $("[id*=ddlStaff2]").val("");
            $("[id*=ddlRelationship1]").val("");
            $("[id*=ddlRelationship2]").val("");
            $("[id*=btnAcademicDetailsSubmit]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function MedRemDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtMedRemDate]").val("");
            $("[id*=txtMedRemReason]").val("");
            $("[id*=fuMedRem]").val("");
            $("[id*=btnMedRemSave]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function AcademicRemarksDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtAcaRemDate]").val("");
            $("[id*=txtAcaRemarks]").val("");
            $("[id*=btnAAcademicRemarks]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function BusRouteDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=ddlRouteCode]").val("");
            $("[id*=txtDateofBusReg]").val("");
            $("[id*=btnBusRouteSubmit]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
        function OldSchoolDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtSchoolName]").val("");
            $("[id*=ddlStartAcademicYr]").val("");
            $("[id*=ddlEndAcademicYr]").val("");
            $("[id*=txtStdFrom]").val("");
            $("[id*=ddlFirstLang]").val("");
            $("[id*=ddlMedium]").val("");
            $("[id*=txtTCNo]").val("");
            $("[id*=txtTCDate]").val("");
            $("[id*=txtTCReceivedDate]").val("");
            $("[id*=btnTCSave]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
        function HostelDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=ddlHostel]").val("");
            $("[id*=ddlBlock]").val("");
            $("[id*=ddlRooms]").val("");
            $("[id*=txtDateofHostelAdmn]").val("");
            $("[id*=rbtnHostelNo]").attr("checked", true);
            ShowHostel();
            $("[id*=btnHostelSubmit]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function NationalityDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtNationality]").val("");
            $("[id*=txtPassportNo]").val("");
            $("[id*=txtPPDateofIssue]").val("");
            $("[id*=txtVisaNumber]").val("");
            $("[id*=txtPPExpDate]").val("");
            $("[id*=txtVisaType]").val("");
            $("[id*=txtVisaIssuedDate]").val("");
            $("[id*=txtVisaExpiryDate]").val("");
            $("[id*=txtNoOfEntry]").val("");
            $("[id*=txtValidity]").val("");
            $("[id*=txtPurpose]").val("");
            $("[id*=txtRemark]").val("");
            $("[id*=btnNationalitySave]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function AttachmentInfoClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtAttTitle]").val("");
            $("[id*=txtAttDescription]").val("");
            $("[id*=AttFile1]").val("");
            $("[id*=btnAttachmentSave]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };



        function GetScholarshipInfo(ID) {
            var RegNo = $("[id*=hfRegNo]").val();
            if (ID == "0") {
                ID = "";
            }
            $.ajax({

                type: "POST",
                url: "../Students/StudentInfo.aspx/GetScholarshipInfo",
                data: '{"regno": "' + RegNo + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetScholarshipInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetScholarshipInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Scholarships = xml.find("Scholarships");
            var row = $("[id*=dgScholarship] tr:last-child").clone(true);
            $("[id*=dgScholarship] tr").not($("[id*=dgScholarship] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditScholarship('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteScholarship('";
                danchorEnd = "');\">Delete</a>";
            }
            // $("#chkBroSis").attr("checked", "true");        
            // ShowScholarship();
            if (Scholarships.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records Found").attr("align", "center");
                $("td", row).eq(3).html("").removeClass("editacc edit-links");
                $("td", row).eq(4).html("").removeClass("deleteacc delete-links"); ;
                $("[id*=dgScholarship]").append(row);
                row = $("[id*=dgScholarship] tr:last-child").clone(true);

            }
            else {
                // $("#chkBroSis").attr("checked", "true");
                //ShowScholarship();
                $.each(Scholarships, function () {
                    row.addClass("even");
                    var ehref = eanchor + $(this).find("RegNo").text() + "','" + $(this).find("StudScholId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StudScholId").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("SNO").text());
                    $("td", row).eq(1).html($(this).find("ScholarshipId").text());
                    $("td", row).eq(2).html($(this).find("ScholarshipName").text());
                    $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgScholarship]").append(row);
                    row = $("[id*=dgScholarship] tr:last-child").clone(true);


                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    $('.deleteacc').hide();
                }
                else {
                    $('.deleteacc').show();
                }
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



        function ScholarshipDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=ddlScholarship]").val("");
            $("[id*=btnScholarshipSubmit]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        }


        function DeleteScholarship(StudScholID) {

            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/StudentInfo.aspx/DeleteScholarshipInfo",
                        data: '{StudScholID: ' + StudScholID + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteScholarshipInfoSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }

                    });
                }

            })) {
            }
        }

        function OnDeleteScholarshipInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    GetScholarshipInfo(RegNo);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };


        function GetSportsInfo(ID) {
            var RegNo = $("[id*=hfRegNo]").val();
            if (ID == "0") {
                ID = "";
                RegNo = "0";
            }
            $.ajax({

                type: "POST",
                url: "../Students/StudentInfo.aspx/GetSportsInfo",
                data: '{"regno": "' + RegNo + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetSportsInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        var ApporvalStatus;
        function OnGetSportsInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var sports = xml.find("Sports");
            var row = $("[id*=dgSports] tr:last-child").clone(true);
            $("[id*=dgSports] tr").not($("[id*=dgSports] tr:first-child")).remove();
            if (sports.length == 0) {
                $("td", row).eq(0).html("No Records Found").attr("align", "left");
                $("td", row).eq(1).html("").removeClass("editacc edit-links").removeClass("deleteacc delete-links");
                $("[id*=dgSports]").append(row);
                row = $("[id*=dgSports] tr:last-child").clone(true);

            }
            else {
                $.each(sports, function () {
                    
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("SportName").text());
                    var recstatus = "";
                    $("td", row).eq(1).html('').removeClass("editacc edit-links").removeClass("deleteacc delete-links");
                    if ($(this).find("StudSportId").text() != null && $(this).find("StudSportId").text() != "") {
                        recstatus = "Update";
                        ApporvalStatus = '<a href="javascript:void(0)" onclick="ManageSports(\'' + $(this).find("RegNo").text() + '\',\'' + $(this).find("SportId").text() + '\',\'' + recstatus + '\');" ><span class="tcsend">Delete</span> </a>';
                        $("td", row).eq(1).html(ApporvalStatus).addClass("deleteacc delete-links");
                    }
                    else {
                        recstatus = "Add";
                        ApporvalStatus = '<a href="javascript:void(0)" onclick="ManageSports(\'' + $(this).find("RegNo").text() + '\',\'' + $(this).find("SportId").text() + '\',\'' + recstatus + '\');" ><span class="tcsend">Add</span> </a>';
                        $("td", row).eq(1).html(ApporvalStatus).addClass("editacc edit-links");
                    }
                    $("[id*=dgSports]").append(row);
                    row = $("[id*=dgSports] tr:last-child").clone(true);


                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
            }
        }

        function ManageSports(RegNo, SportId, Status) {

            $.ajax({
                type: "POST",
                url: "../Students/StudentInfo.aspx/ManageSports",
                data: '{"regno": "' + RegNo + '","sportid" : "' + SportId + '","status" : "' + Status + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    GetSportsInfo(RegNo);
                },
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function SaveCurricularDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') || ($("[id*=hfEditPrm]").val() == 'true')) {
                if ($("[id*=hfRegNo]").val() != '') {
                    var RegNo = $("[id*=hfRegNo]").val();
                    if (document.getElementById('rbtnSports').checked == true) {
                        var Curi = "Sports";
                    }
                    else if (document.getElementById('rbtnFine').checked == true) {
                        var Curi = "FineArts";
                    }
                    $.ajax({
                        type: "POST",
                        url: "../Students/StudentInfo.aspx/SaveCurricularDetails",
                        data: '{"regno": "' + RegNo + '","type": "' + Curi + '","curricularremarks" : "' + $("[id*=txtCurricularRemarks]").val() + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d == "Success") {
                                AlertMessage('success', "Updated");
                                GetStudentInfo(RegNo);
                                changeAccordion(7);
                            }
                            else {
                                AlertMessage('info', "Select any data for " + Curi + "");
                            }

                        },
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
                else {
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
            
        }

        function GetFineArtsInfo(ID) {
            var RegNo = $("[id*=hfRegNo]").val();
            if (ID == "0") {
                ID = "";
                RegNo = "0";
            }
            $.ajax({

                type: "POST",
                url: "../Students/StudentInfo.aspx/GetFineArtsInfo",
                data: '{"regno": "' + RegNo + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetFineArtsInfoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        var ApporvalStatus = "";
        function OnGetFineArtsInfoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var finearts = xml.find("FineArts");
            var row = $("[id*=dgFineArts] tr:last-child").clone(true);
            $("[id*=dgFineArts] tr").not($("[id*=dgFineArts] tr:first-child")).remove();
            var recstatus = "";
            if (finearts.length == 0) {
                $("td", row).eq(0).html("No Records Found").attr("align", "left");
                $("td", row).eq(1).html("").removeClass("editacc edit-links");
                $("[id*=dgFineArts]").append(row);
                row = $("[id*=dgFineArts] tr:last-child").clone(true);

            }
            else {

                $.each(finearts, function () {
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("FineArtName").text());
                    $("td", row).eq(1).html('').removeClass("editacc edit-links").removeClass("deleteacc delete-links");
                    if ($(this).find("StudFineArtId").text() != null && $(this).find("StudFineArtId").text() != "") {
                        recstatus = "Update";
                        ApporvalStatus = '<a href="javascript:void(0)" onclick="ManageFineArts(\'' + $(this).find("RegNo").text() + '\',\'' + $(this).find("FineArtId").text() + '\',\'' + recstatus + '\');" ><span class="tcsend">Delete</span> </a>';
                        $("td", row).eq(1).html(ApporvalStatus).addClass("deleteacc delete-links");
                    }
                    else {
                        recstatus = "Add";
                        ApporvalStatus = '<a href="javascript:void(0)" onclick="ManageFineArts(\'' + $(this).find("RegNo").text() + '\',\'' + $(this).find("FineArtId").text() + '\',\'' + recstatus + '\');" ><span class="tcsend">Add</span> </a>';
                        $("td", row).eq(1).html(ApporvalStatus).addClass("editacc edit-links");
                    }
                    $("td", row).eq(1).html(ApporvalStatus);
                    $("[id*=dgFineArts]").append(row);
                    row = $("[id*=dgFineArts] tr:last-child").clone(true);

                });

                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
                }
            }
        }

        function ManageFineArts(RegNo, FineArtsID, Status) {
            $.ajax({
                type: "POST",
                url: "../Students/StudentInfo.aspx/ManageFineArts",
                data: '{"regno": "' + RegNo + '","fineartsid" : "' + FineArtsID + '","status" : "' + Status + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    GetFineArtsInfo(RegNo);
                },
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
         
    </script>
    <script type="text/javascript">

        function showbrosis() {
            if (document.getElementById('chkBroSis').checked == true) {
                $(".brosis").slideDown("slow");
            }
            if (document.getElementById('chkBroSis').checked == false) {
                $(".brosis").slideUp("slow");
            }
        }
        function ShowNationality() {
            if (document.getElementById('rbtnOverseas').checked == true) {
                $("#dvNationality").slideDown("slow");
            }
            if (document.getElementById('rbtnIndian').checked == true) {
                $("#dvNationality").slideUp("slow");
            }
        }
        function showphysical() {
            if (document.getElementById('rbtnPHYes').checked == true) {
                $("#dvPhy").slideDown("slow");
            }
            if (document.getElementById('rbtnNoPH').checked == true) {
                $("#dvPhy").slideUp("slow");
            }
        }
        function ShowScholarship() {
            if (document.getElementById('rbtnScholarYes').checked == true) {
                $("#dvScholar").slideDown("slow");
            }
            if (document.getElementById('rbtnNoScholar').checked == true) {
                $("#dvScholar").slideUp("slow");
            }
        }
        function ShowConcession() {
            if (document.getElementById('rbtnConcessYes').checked == true) {
                $("#dvConcession").slideDown("slow");
            }
            if (document.getElementById('rbtnNoConcess').checked == true) {
                $("#dvConcession").slideUp("slow");
            }
        }

        function ShowHostel() {
            if (document.getElementById('rbtnHostelYes').checked == true) {
                $("#dvHostel").slideDown("slow");
            }
            if (document.getElementById('rbtnHostelNo').checked == true) {
                $("#dvHostel").slideUp("slow");
            }
        }
        function ShowCurricular() {
            if (document.getElementById('rbtnSports').checked == true) {
                $("#dvSports").css("display", "block");
                $("#dvFineArts").css("display", "none");
            }
            if (document.getElementById('rbtnFine').checked == true) {
                $("#dvFineArts").css("display", "block");
                $("#dvSports").css("display", "none");
            }
        }
        function ShowBus() {
            if (document.getElementById('rbtnBusYes').checked == true) {
                $("#dvBus").slideDown("slow");
            }
            if (document.getElementById('rbtnBusNo').checked == true) {
                $("#dvBus").slideUp("slow");
            }
        }
        function ShowInstitution() {
            if (document.getElementById('rbtnInsYes').checked == true) {
                $("#dvInstitution").slideDown("slow");
            }
            if (document.getElementById('rbtnInsNo').checked == true) {
                $("#dvInstitution").slideUp("slow");
            }
        } 
    </script>
    <script type="text/javascript">
        function CheckAll() {
            if ($("[id*=chkContact]").is(':checked')) {
                $("[id*=txtPerAddress]").val($("[id*=txtTempAddress]").val());
                $("[id*=txtPerAddress]").attr("disabled", true);
            }
            else {
                $("[id*=txtPerAddress]").attr("disabled", false);
                $("[id*=txtPerAddress]").val('');
            }
        }
    </script>
    <script type="text/javascript">
        var formdata;
        function readURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#img_prev').attr('src', e.target.result).width(114).height(114);

                };
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StudentImage", input.files[0]);
                }
            }
        }
        function readMedRemURL(input) {

            if (window.FormData) {
                formdata = new FormData();
            }
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("MedicalRemarks", input.files[0]);
                }
            }
        }
        function readAttFileURL(input) {

            if (window.FormData) {
                formdata = new FormData();
            }
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("Attachment", input.files[0]);
                }
            }
        }
        function changeAccordion(value) {
            $(".john-accord").accordion({
                "header": "a.menuitem",
                "collapsible": true,
                "active": parseInt(value),
                "autoHeight": false

            });
        }

    </script>
    <script type="text/javascript">
        function GetModuleMenuID(path) {
            $.ajax({
                type: "POST",
                url: "../Students/Studentinfo.aspx/GetModuleMenuId",
                data: '{"path": "' + path + '","UserId":"' + $("[id*=hfUserId]").val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnModuleMenuIDSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }
        function OnModuleMenuIDSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var modmenu = xml.find("ModuleMenu");
            $("[id*=hfAdvMenuId]").val(modmenu.find("menuid").text());
            $("[id*=hfAdvModuleID]").val(modmenu.find("modulemenuid").text());
            //        alert($("[id*=hfAdvMenuId]").val());
            //        alert($("[id*=hfAdvModuleID]").val());
        }


    </script>
    <style type="text/css">
        article, aside, figure, footer, header, hgroup, menu, nav, section
        {
            display: block;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head2" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Student Information
                <div id="jSuccess-info">
                    Registration No :
                    <asp:Label ID="lblRegNo" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Student
                    Name :
                    <asp:Label ID="lblStudentName" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Class
                    & Section :
                    <asp:Label ID="lblClass" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Present
                    Status :
                    <asp:Label ID="lblStatus" runat="server"></asp:Label></div>
            </h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper4">
                <ul class="section menu">
                    <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                        Personal Details</a>
                        <ul class="johnmenu">
                            <li>
                                <div style="border-bottom-style: none; border-bottom-width: 0px;" id="dvPersonal"
                                    class="frm-block">
                                    <table class="form" width="100%">
                                        <tr>
                                            <td align="center" colspan="4">
                                                <div style="float: left; width: 120px; right: 60px; margin-top: 5px;">
                                                    <img id="img_prev" src="../img/photo.jpg" class='zoom' alt="Profile Photo" width="114"
                                                        height="114" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" class="col1">
                                                <span style="color: Red">*</span>
                                                <label>
                                                    Student Name :</label>
                                            </td>
                                            <td width="26%" class="col2">
                                                <asp:TextBox ID="txtStudentName" CssClass="jsrequired" runat="server"></asp:TextBox>
                                            </td>
                                            <td width="14%" class="col2">
                                                <span class="col1">
                                                    <label>
                                                        Sex :</label>
                                                </span>
                                            </td>
                                            <td class="col2">
                                                <label>
                                                    <input type="radio" name="rb1" id="rbtnMale" value="Male" checked="checked" />Male</label>
                                                <label>
                                                    <input type="radio" name="rb1" id="rbtnFemale" value="Female" />Female</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="9%">
                                                <span style="color: Red">*</span>
                                                <label>
                                                    Class :</label>
                                            </td>
                                            <td width="18%">
                                                <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                    onchange="GetSectionByClass();">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td width="11%">
                                                <label>
                                                    Section :</label>
                                            </td>
                                            <td width="20%">
                                                <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True">
                                                  <asp:ListItem Selected="True" Value="">Select</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    <span style="color: Red">*</span> Date of Birth :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDOB" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Mother Tongue :
                                                </label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtMotherTongue" CssClass="" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Religion :</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlReligion" CssClass="" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <label>
                                                    Community :</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlCommunity" CssClass="" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Caste :</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlCaste" CssClass="" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <label>
                                                    Aadhaar card :</label>
                                            </td>
                                            <td>
                                                <label for="textarea">
                                                </label>
                                                <asp:TextBox ID="txtAadhaar" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Temporary Address :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtTempAddress" TextMode="MultiLine" Rows="5" Columns="30" onchange="CheckAll();"
                                                    runat="server" OnTextChanged="txtTempAddress_TextChanged"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Permanent Address :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtPerAddress" TextMode="MultiLine" Rows="5" Columns="30" runat="server"></asp:TextBox>
                                                <br />
                                                <label>
                                                    <input type="checkbox" name="chkContact" id="chkContact" value="contact" onchange="CheckAll();"
                                                        checked="checked" />
                                                    Same as Temporary Address</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Email :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtEmail" CssClass="email" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    <span style="color: Red">*</span> Phone No :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtPhoneNo" CssClass="jsrequired" Text="" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Upload Image :</label>
                                            </td>
                                            <td>
                                                <input type='file' id="FuPhoto" onchange="readURL(this);" />
                                            </td>
                                            <td>
                                                <span style="color: Red">*</span>
                                                <label>
                                                    Date of Join:</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDOJ" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Smart Card No :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtSmartCardNo" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Ration Card No :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtRationCardNo" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    SSLC certificate No. :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtSSLC" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Year of Passing :</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlSSLC" runat="server">
                                                    <asp:ListItem Value="">Select</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    HSC certificate No. :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtHSC" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Year of Passing :</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlHSC" runat="server">
                                                    <asp:ListItem Value="">Select</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td>
                                                <label>
                                                    Student Unique No. :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtSUID" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Student Name in Tamil :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtTamilname" CssClass="text_tam" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;</td>
                                            <td>
                                                &nbsp;</td>
                                            <td>
                                                &nbsp;</td>
                                            <td>
                                                &nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <asp:HiddenField ID="hfStudentInfoID" runat="server" />
                                                            <asp:HiddenField ID="hfAcademicyear" runat="server" />
                                                            <asp:HiddenField ID="hfRegNo" runat="server" />
                                                            <asp:HiddenField ID="hfUserId" runat="server" />
                                                        </td>
                                                        <td>
                                                            <button id="btnPersonalSubmit" type="button" class="btn-icon btn-orange btn-saving"
                                                                onclick="SavePersonalDetails();">
                                                                <span></span>
                                                                <div id="spPersonalSubmit">
                                                                    Save</div>
                                                            </button>
                                                            &nbsp;
                                                        </td>
                                                        <td>
                                                            <button id="btnPersonalCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                runat="server" onclick="return PersonalDetailsClear();">
                                                                <span></span>Cancel</button>&nbsp;
                                                        </td>
                                                        <td style="padding-top: 0px;">
                                                            &nbsp;
                                                            <button id="btnAdvanceFees" type="button" class="btn-icon btn-orange btn-saving"
                                                                onclick="SaveandPayAdvanceFees();">
                                                                <span></span>
                                                                <div id="spFeesSubmit">
                                                                    Save & Pay Advance Fees</div>
                                                            </button>
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
                        Parents / Guardian Details</a>
                        <ul class="johnmenu">
                            <li>
                                <div id="dvFamily" style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                    <table class="form" width="100%">
                                        <tr>
                                            <td width="20%" class="col1">
                                                <label>
                                                    <span style="color: Red">*</span> Relationship :</label>
                                            </td>
                                            <td width="28%" class="col2">
                                                <asp:DropDownList ID="ddlRelationship" CssClass="jsrequired" runat="server" onchange="chkpriority();"
                                                    AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td width="20%" class="col1">
                                                <label>
                                                    <span style="color: Red">*</span> Name :</label>
                                            </td>
                                            <td width="28%" class="col2">
                                                <asp:TextBox ID="txtName" CssClass="jsrequired" Text="" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="19%" class="col2">
                                                <span class="col1">
                                                    <label>
                                                        Qualification :</label>
                                                </span>
                                            </td>
                                            <td width="33%" class="col2">
                                                <asp:TextBox ID="txtQualification" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Annual Income :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtIncome" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Occupation :
                                                </label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtOccupation" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Email :</label>
                                            </td>
                                            <td>
                                                <span class="col2">
                                                    <asp:TextBox ID="txtRelEmail" CssClass="email" runat="server"></asp:TextBox>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    <span style="color: Red">*</span> Mobile :</label>
                                            </td>
                                            <td>
                                                <span class="col2">
                                                    <asp:TextBox ID="txtRelMobile" CssClass="jsrequired numbersonly" runat="server"></asp:TextBox>
                                                </span>
                                            </td>
                                            <td>
                                                <label>
                                                    Occupational Address:</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtOccAddress" TextMode="MultiLine" Rows="5" Columns="30" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    <span style="color: Red">*</span> SMS Priority :</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlSMSPriority" CssClass="" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    <asp:ListItem Value="1">Father</asp:ListItem>
                                                    <asp:ListItem Value="2">Mother</asp:ListItem>
                                                    <asp:ListItem Value="3">Guardian I</asp:ListItem>
                                                    <asp:ListItem Value="4">Guardian II</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <label>
                                                    Care Taker :</label>
                                            </td>
                                            <td>
                                                <span class="col2">
                                                    <input type="radio" id="rbtnParent" value="Parent" name="rbtnCare" checked="checked" />
                                                    Parent
                                                    <input type="radio" id="rbtnGaurdian" value="Gaurdian" name="rbtnCare" />
                                                    Gaurdian</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <button id="btnRelationshipSubmit" type="button" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveFamilyDetails();">
                                                    <span></span>Update</button>
                                                <button id="btnRelationshipCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    runat="server" onclick="return FamilyDetailsClear();">
                                                    <span></span>Cancel</button>
                                            </td>
                                        </tr>
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
                                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                            HeaderStyle-CssClass="sorting_mod editacc">
                                                                            <HeaderTemplate>
                                                                                Edit</HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StudentId") %>'
                                                                                    CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                            HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                            <HeaderTemplate>
                                                                                Delete</HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StudentId") %>'
                                                                                    CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
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
                                                <table width="100%" class="form">
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Is Brothers/Sisters Studying In Same Institution Address :</label>&nbsp;&nbsp;
                                                            <input type="checkbox" id="chkBroSis" onclick="javascript:showbrosis();" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div class="brosis" id="dvBroSis" style="position: relative; width: 100%">
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td width="21%">
                                                                            <label>
                                                                                Class</label>
                                                                        </td>
                                                                        <td width="21%">
                                                                            <label>
                                                                                Section</label>
                                                                        </td>
                                                                        <td width="20%">
                                                                            <label>
                                                                                Student</label>
                                                                        </td>
                                                                        <td>
                                                                            <label>
                                                                                Relationship</label>
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:DropDownList ID="ddlBroSisClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                                onchange="GetBroSisSectionByBroSisClass();">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td>
                                                                            <asp:DropDownList ID="ddlBroSisSection" CssClass="" runat="server" AppendDataBoundItems="True"
                                                                                onchange="GetBroSisStudentByBroSisSection();">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td>
                                                                            <asp:DropDownList ID="ddlBroSisStudentName" CssClass="jsrequired" runat="server"
                                                                                AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td width="16%">
                                                                            <asp:DropDownList ID="ddlBroSisRelation" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td width="22%" align="left">
                                                                            <button id="btnBroSisAdd" type="button" class="btn-icon btn-navy btn-update" onclick="SaveBroSisDetails();">
                                                                                <span></span>Update</button>&nbsp;
                                                                            <button id="btnBroSisCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                                runat="server" onclick="return BroSisDetailsClear();">
                                                                                <span></span>Cancel</button>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
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
                                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                            HeaderStyle-CssClass="sorting_mod editacc">
                                                                            <HeaderTemplate>
                                                                                Edit</HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StudRelID") %>'
                                                                                    CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                            HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                            <HeaderTemplate>
                                                                                Delete</HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StudRelID") %>'
                                                                                    CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
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
                                                <span style="color: Red">*</span>
                                                <label>
                                                    Blood Group:</label>
                                            </td>
                                            <td width="28%" class="col2">
                                                <asp:DropDownList ID="ddlBloodGroup" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td width="19%" class="col2">
                                                <label>
                                                    Disease /Allergy:</label>
                                            </td>
                                            <td width="33%" class="col2">
                                                <asp:TextBox ID="txtDisease" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Height (cm):</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtHeight" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Weight (Kg):
                                                </label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtWeight" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Emergency Phone No
                                                </label>
                                            </td>
                                            <td>
                                                <span class="col2">
                                                    <asp:TextBox ID="txtEmergencyPhNo" runat="server"></asp:TextBox>
                                                </span>
                                            </td>
                                            <td>
                                                <label>
                                                    Family Doctor Name:</label>
                                            </td>
                                            <td>
                                                <span class="col2">
                                                    <asp:TextBox ID="txtFamilyDocName" runat="server"></asp:TextBox>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Address:</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtFamilyDocAdd" TextMode="MultiLine" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Doctor Phone No:</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtFamilyDocPhNo" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Identification Marks:</label>
                                            </td>
                                            <td>
                                                1.
                                                <asp:TextBox ID="txtIdentificationMarks1" CssClass="idn-marks" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Physically Handicapped</label>
                                            </td>
                                            <td>
                                                <span class="col2">
                                                    <input type="radio" id="rbtnNoPH" name="rbPhysical" onclick="javascript:showphysical();"
                                                        checked="checked" />
                                                    No
                                                    <input type="radio" id="rbtnPHYes" name="rbPhysical" onclick="javascript:showphysical();" />
                                                    Yes</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                2.
                                                <asp:TextBox ID="txtIdentificationMarks2" CssClass="idn-marks" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <div id="dvPhy" style="display: none;">
                                                    <asp:TextBox ID="txtPhysicalHandicapped" runat="server"></asp:TextBox>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <button id="btnMedicalSave" type="button" class="btn-icon btn-navy btn-update" onclick="SaveMedicalDetails();">
                                                    <span></span>Update</button>&nbsp;
                                                <button id="btnMedicalCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    runat="server" onclick="return MedicalDetailsClear();">
                                                    <span></span>Cancel</button>
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
                                                        <td class="col1 formsubheading">
                                                            Medical Record Remarks :
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div id="dvMedicalRecord" style="position: relative; width: 100%">
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td width="21%">
                                                                            <label>
                                                                                Date</label>
                                                                        </td>
                                                                        <td width="21%">
                                                                            <label>
                                                                                Reason</label>
                                                                        </td>
                                                                        <td width="21%">
                                                                            <label>
                                                                                Upload Attachment</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox ID="txtMedRemDate" CssClass="dateNL date-picker" runat="server"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtMedRemReason" runat="server"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                            <input type='file' id="fuMedRem" onchange="readMedRemURL(this);" />&nbsp;&nbsp;&nbsp;&nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <button id="btnMedRemSave" type="button" class="btn-icon btn-navy btn-update" onclick="SaveMedRemDetails();">
                                                                                <span></span>Update</button>&nbsp;
                                                                            <button id="btnMedRemCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                                runat="server" onclick="return MedRemDetailsClear();">
                                                                                <span></span>Cancel</button>
                                                                        </td>
                                                                    </tr>
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
                                                                                                        HeaderText="Remark Date" SortExpression="RemarkDate">
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
                                                                                                    <asp:TemplateField Visible="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                                        HeaderStyle-CssClass="sorting_mod editacc">
                                                                                                        <HeaderTemplate>
                                                                                                            Edit</HeaderTemplate>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("MedRemarkID") %>'
                                                                                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateField>
                                                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                                                        <HeaderTemplate>
                                                                                                            Delete</HeaderTemplate>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("MedRemarkID") %>'
                                                                                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateField>
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
                                                <asp:TextBox ID="txtRegNo" ReadOnly="true" runat="server"></asp:TextBox>
                                            </td>
                                            <td width="22%" class="col2">
                                                <label>
                                                    Admission No:</label>
                                            </td>
                                            <td width="29%" class="col2">
                                                <asp:TextBox ID="txtAdmissionNo" ReadOnly="true" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Admitted Class</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlAdClass" CssClass="" runat="server" AppendDataBoundItems="True"
                                                    onchange="GetAdSectionByAdClass(this.value);">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <label>
                                                    Admitted Section</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlAdSection" CssClass="" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">New</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="22%" class="col2">
                                                <label>
                                                    Date of Admission:</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDOA" CssClass="dateNL date-picker" Enabled="false" runat="server"></asp:TextBox>
                                            </td>
                                            <td width="29%" class="col2">
                                                <label>
                                                    Mode of Transport:</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlModeofTrans" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="22%" class="col1">
                                                <label>
                                                    Medium:</label>
                                            </td>
                                            <td width="27%" class="col2">
                                                <asp:DropDownList ID="ddlSchoolMedium" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                </asp:DropDownList>
                                            </td>
                                            <td width="22%" class="col2">
                                                <label>
                                                    First Language:</label>
                                            </td>
                                            <td width="29%" class="col2">
                                              <asp:DropDownList ID="txtFirstlang" CssClass="" runat="server" AppendDataBoundItems="True">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Second language :</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlSeclang" CssClass="" runat="server" AppendDataBoundItems="True">
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <label>
                                                    Present Status:</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlStatus" CssClass="jsrequired" runat="server">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    <asp:ListItem Value="N">New</asp:ListItem>
                                                    <asp:ListItem Value="C">Current</asp:ListItem>
                                                    <asp:ListItem Value="O">Old</asp:ListItem>
                                                    <asp:ListItem Value="D">Discontinued</asp:ListItem>
                                                    <asp:ListItem Value="F">Temproray</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    If Parents Working in this Institution:</label>
                                            </td>
                                            <td>
                                                <span class="col2">
                                                    <input type="radio" name="bb1" id="rbtnInsNo" value="No" checked="checked" onclick="javascript:ShowInstitution();" />No
                                                    <input type="radio" name="bb1" id="rbtnInsYes" value="Yes" onclick="javascript:ShowInstitution();" />Yes</span>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td width="43%">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <div id="dvInstitution" style="display: none;">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td width="48%">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td width="22%">
                                                                            <label>
                                                                                Emp Id/Name:</label>
                                                                        </td>
                                                                        <td width="27%">
                                                                            <asp:DropDownList ID="ddlStaff1" runat="server" AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td width="25%" align="center">
                                                                            <label>
                                                                                Relationship:</label>
                                                                        </td>
                                                                        <td width="27%">
                                                                            <asp:DropDownList ID="ddlRelationship1" runat="server" AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width="22%">
                                                                            <label>
                                                                                Emp Id/Name:</label>
                                                                        </td>
                                                                        <td width="27%">
                                                                            <asp:DropDownList ID="ddlStaff2" runat="server" AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td width="25%" align="center">
                                                                            <label>
                                                                                Relationship:</label>
                                                                        </td>
                                                                        <td width="27%">
                                                                            <asp:DropDownList ID="ddlRelationship2" runat="server" AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td width="2%">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <label>
                                                                                Parent/Guardian Details</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">
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
                                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                        HeaderStyle-CssClass="sorting_mod editacc">
                                                                                        <HeaderTemplate>
                                                                                            Edit</HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StudStaffID") %>'
                                                                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateField>
                                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                                        <HeaderTemplate>
                                                                                            Delete</HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StudStaffID") %>'
                                                                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateField>
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
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="40">
                                                &nbsp;
                                            </td>
                                            <td colspan="3">
                                                <button id="btnAcademicDetailsSubmit" type="button" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveAcademicDetails();">
                                                    <span></span>
                                                    <div id="spAcaSubmit">
                                                        Update</div>
                                                </button>
                                                <button id="btnAcademicDetailsCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    runat="server" onclick="return AcademicDetailsClear();">
                                                    <span></span>Cancel</button>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                        Co-Curricular Details</a>
                        <ul class="johnmenu">
                            <li>
                                <div id="dvCurricular" style="border-bottom-style: none; border-bottom-width: 0px;"
                                    class="frm-block">
                                    <table class="form" width="100%">
                                        <tr>
                                            <td width="22%" class="col1">
                                                <label>
                                                    Select any one option
                                                </label>
                                            </td>
                                            <td class="col2">
                                                <input type="radio" name="cbtnCurricular" id="rbtnSports" value="Sports"
                                                    onclick="javascript:ShowCurricular();" />Sports
                                                <input type="radio" name="cbtnCurricular" id="rbtnFine" value="Fine Arts" onclick="javascript:ShowCurricular();" />Fine
                                                Arts
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Remarks</label>
                                            </td>
                                            <td valign="top">
                                                <asp:TextBox ID="txtCurricularRemarks" TextMode="MultiLine" Rows="3" Columns="30" runat="server"></asp:TextBox>
                                                 &nbsp;
                                                <button id="btnCuri" type="button" runat="server" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveCurricularDetails();">
                                                    <span></span>
                                                    <div id="dpCurricular">
                                                        Save</div>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div id="dvSports" style="display: none; float: left; width: 100%">
                                                    <asp:GridView ID="dgSports" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even" AlternatingRowStyle-CssClass="odd"
                                                        EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="SportName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Sports Name" SortExpression="SportName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Option</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Option" CommandArgument='<%# Eval("StudSportId") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                                <div id="dvFineArts" style="display: none; float: left; width: 100%">
                                                    <asp:GridView ID="dgFineArts" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="FineArtName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Fine Arts Name" SortExpression="FineArtName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Option</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Option" CommandArgument='<%# Eval("StudFineArtId") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                        Scholarship Details</a>
                        <ul class="johnmenu">
                            <li>
                                <div id="dvscholarshipDetails" style="border-bottom-style: none; border-bottom-width: 0px;"
                                    class="frm-block">
                                    <table class="form" width="100%">
                                        <tr>
                                            <td width="22%" class="col1">
                                                <label>
                                                    Is Student Eligible For scholarship</label>
                                            </td>
                                            <td>
                                                <input type="radio" name="sch1" id="rbtnNoScholar" value="No" checked="checked" onclick="javascript:ShowScholarship();" />No
                                                <input type="radio" name="sch1" id="rbtnScholarYes" value="Yes" onclick="javascript:ShowScholarship();" />Yes
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <div id="dvScholar" style="display: none;">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td width="48%">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td width="45%">
                                                                            <label>
                                                                                Scholarship Name :</label>
                                                                        </td>
                                                                        <td width="55%">
                                                                            <asp:DropDownList ID="ddlScholarship" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td>
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <label>
                                                                                Scholarship Details</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <asp:GridView ID="dgScholarship" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                                <Columns>
                                                                                    <asp:BoundField DataField="SNO" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="SlNo" SortExpression="SNO">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="ScholarshipId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="ScholarshipId" SortExpression="ScholarshipId">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:BoundField DataField="ScholarshipName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderText="ScholarshipName" SortExpression="ScholarshipName">
                                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                                    </asp:BoundField>
                                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                        HeaderStyle-CssClass="sorting_mod editacc">
                                                                                        <HeaderTemplate>
                                                                                            Edit</HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StudScholId") %>'
                                                                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateField>
                                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                                        <HeaderTemplate>
                                                                                            Delete</HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StudScholId") %>'
                                                                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateField>
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
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="left">
                                                <button id="btnScholarshipSubmit" type="button" runat="server" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveScholarshipDetails();">
                                                    <span></span>
                                                    <div id="Div9">
                                                        Update</div>
                                                </button>
                                                <button id="btnScholarshipCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    runat="server" onclick="return ScholarshipDetailsClear();">
                                                    <span></span>Cancel</button>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
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
                                                        <td class="col1 formsubheading">
                                                            <label>
                                                                Academic Remarks :</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div id="dvAcaRemarks" style="position: relative; width: 100%">
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td width="21%">
                                                                            <label>
                                                                                Date</label>
                                                                        </td>
                                                                        <td width="21%">
                                                                            <label>
                                                                                Remarks</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox ID="txtAcaRemDate" CssClass="dateNL date-picker" runat="server"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtAcaRemarks" runat="server"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                            <button id="btnAAcademicRemarks" type="button" class="btn-icon btn-navy btn-update"
                                                                                onclick="SaveAcademicRemarkDetails();">
                                                                                <span></span>Update</button>&nbsp;
                                                                            <button id="btnAcademicRemCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                                runat="server" onclick="return AcademicRemDetailsClear();">
                                                                                <span></span>Cancel</button>
                                                                        </td>
                                                                    </tr>
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
                                                                                                    <asp:TemplateField Visible="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                                        HeaderStyle-CssClass="sorting_mod editacc">
                                                                                                        <HeaderTemplate>
                                                                                                            Edit</HeaderTemplate>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("RemarkID") %>'
                                                                                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateField>
                                                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                                                        <HeaderTemplate>
                                                                                                            Delete</HeaderTemplate>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("RemarkID") %>'
                                                                                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateField>
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
                                            <td width="22%" class="col1">
                                                <label>
                                                    Is Hostel Students
                                                </label>
                                            </td>
                                            <td class="col2">
                                                <input type="radio" name="hb1" id="rbtnHostelNo" value="No" checked="checked" onclick="javascript:ShowHostel();" />No
                                                <input type="radio" name="hb1" id="rbtnHostelYes" value="Yes" onclick="javascript:ShowHostel();" />Yes
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <div id="dvHostel" style="display: none;">
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
                                                                            <asp:DropDownList ID="ddlHostel" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                                onchange="GetBlockByHostel(this.value);">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <label>
                                                                                Block Name</label>
                                                                        </td>
                                                                        <td width="55%">
                                                                            <asp:DropDownList ID="ddlBlock" CssClass="jsrequired" runat="server" onchange="javascript:GetRoomByBlock();"
                                                                                AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <label>
                                                                                Room No</label>
                                                                        </td>
                                                                        <td width="55%">
                                                                            <asp:DropDownList ID="ddlRooms" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width="45%">
                                                                            <label>
                                                                                Date of Admission</label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtDateofHostelAdmn" CssClass="dateNL date-picker" runat="server"></asp:TextBox>
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
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="left">
                                                <button id="btnHostelSubmit" type="button" runat="server" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveHostelDetails();">
                                                    <span></span>
                                                    <div id="Div2">
                                                        Update</div>
                                                </button>
                                                <button id="btnHostelCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    runat="server" onclick="return HostelDetailsClear();">
                                                    <span></span>Cancel</button>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
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
                                            <td width="22%" class="col1">
                                                <label>
                                                    Is Bus Students</label>
                                            </td>
                                            <td>
                                                <input type="radio" name="bb1" id="rbtnBusNo" value="No" checked="checked" onclick="javascript:ShowBus();" />No
                                                <input type="radio" name="bb1" id="rbtnBusYes" value="Yes" onclick="javascript:ShowBus();" />Yes
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <div id="dvBus" style="display: none;">
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
                                                                            <asp:DropDownList ID="ddlRouteCode" CssClass="jsrequired" runat="server" onchange="javascript:GetBusRouteDetails(this.value);"
                                                                                AppendDataBoundItems="True">
                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <label>
                                                                                Date of Registration</label>
                                                                        </td>
                                                                        <td width="55%">
                                                                            <asp:TextBox ID="txtDateofBusReg" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
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
                                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                                        <HeaderTemplate>
                                                                                            Delete</HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("BusRouteID")%>'
                                                                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateField>
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
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="left">
                                                <button id="btnBusRouteSubmit" type="button" runat="server" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveBusRouteDetails();">
                                                    <span></span>
                                                    <div id="Div1">
                                                        Update</div>
                                                </button>
                                                <button id="btnBusRouteCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    runat="server" onclick="return BusRouteDetailsClear();">
                                                    <span></span>Cancel</button>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
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
                                            <td width="22%" class="col1">
                                                <label>
                                                    Is Student Eligible For Concession</label>
                                            </td>
                                            <td>
                                                <label for="textarea2">
                                                </label>
                                                <span class="col2">
                                                    <input type="radio" name="Concess" id="rbtnNoConcess" value="No" checked="checked"
                                                        onclick="javascript:ShowConcession();" />No
                                                    <input type="radio" name="Concess" id="rbtnConcessYes" value="Yes" onclick="javascript:ShowConcession();" />Yes</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <div class="" id="dvConcession" style="display: none;">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td width="12%">
                                                                <label>
                                                                    Concession Type:</label>
                                                            </td>
                                                            <td width="30%">
                                                                <asp:DropDownList ID="ddlConcession" CssClass="jsrequired" runat="server" onchange="javascript:GetConcession(this.value);">
                                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="F">Full</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="P">Partial</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td width="12%">
                                                                <label>
                                                                    Concession Reason:</label>
                                                            </td>
                                                            <td width="30%">
                                                                <asp:TextBox ID="txtConcessionReason" Style="width: 250px;" runat="server"></asp:TextBox>
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
                                                            <td colspan="6">
                                                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" Width="100%"
                                                                    AllowPaging="false" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                    AlternatingRowStyle-CssClass="even" EnableModelValidation="True" CssClass="display"
                                                                    PageSize="50" />
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
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="left">
                                                <button id="btnConcessionSubmit" type="button" runat="server" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveConcessionFees();">
                                                    <span></span>
                                                    <div id="spSubmit">
                                                        Update</div>
                                                </button>
                                                <button id="btnConcessionCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    runat="server" onclick="return ConcessionCancel();">
                                                    <span></span>Cancel</button>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
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
                                                            <td width="100%" height="10" colspan="5">
                                                                <table class="form">
                                                                    <tr>
                                                                        <td colspan="4">
                                                                            <div class="">
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <label>
                                                                                                Name of the School:</label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <label>
                                                                                                Academic year</label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <label>
                                                                                                Standard Studied</label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <label>
                                                                                                1st Language</label>
                                                                                        </td>
                                                                                        <td>
                                                                                            &nbsp;
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:TextBox ID="txtSchoolName" runat="server" CssClass="jsrequired"></asp:TextBox>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:DropDownList ID="ddlStartAcademicYr" CssClass="jsrequired" runat="server" Width="75px"
                                                                                                AppendDataBoundItems="True">
                                                                                                <asp:ListItem Selected="True" Value="">Select</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            <asp:DropDownList ID="ddlEndAcademicYr" CssClass="jsrequired" Width="75px" runat="server"
                                                                                                AppendDataBoundItems="True">
                                                                                                <asp:ListItem Selected="True" Value="">Select</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:TextBox ID="txtStdFrom" runat="server" CssClass="jsrequired"></asp:TextBox>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:DropDownList ID="ddlFirstLang" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                        </td>
                                                                                        <td>
                                                                                            &nbsp;
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <label>
                                                                                                Medium</label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <label>
                                                                                                TC No</label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <label>
                                                                                                TC Date</label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <label>
                                                                                                TC Received Date</label>
                                                                                        </td>
                                                                                        <td>
                                                                                            &nbsp;
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:DropDownList ID="ddlMedium" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:TextBox ID="txtTCNo" runat="server" CssClass="jsrequired"></asp:TextBox>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:TextBox ID="txtTCDate" runat="server" CssClass="jsrequired dateNL date-picker"></asp:TextBox>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:TextBox ID="txtTCReceivedDate" runat="server" CssClass="jsrequired dateNL date-picker"></asp:TextBox>
                                                                                        </td>
                                                                                        <td>
                                                                                            <button id="btnTCSave" type="button" runat="server" class="btn-icon btn-navy btn-update"
                                                                                                onclick="SaveOldSchoolDetails();">
                                                                                                <span></span>
                                                                                                <div id="Div6">
                                                                                                    Update</div>
                                                                                            </button>
                                                                                            <button id="btnTCCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                                                                onclick="return TCCancel();">
                                                                                                <span></span>Cancel</button>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="10" colspan="5">
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
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
                                                                            <asp:BoundField DataField="TCDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                HeaderText="TC Date" SortExpression="TCDate">
                                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                            </asp:BoundField>
                                                                            <asp:BoundField DataField="TCReceivedDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                                HeaderText="TC Received Date" SortExpression="TCReceivedDate">
                                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                            </asp:BoundField>
                                                                            <asp:TemplateField Visible="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                                <HeaderTemplate>
                                                                                    Edit</HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StudOldSchID") %>'
                                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                                <HeaderTemplate>
                                                                                    Delete</HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StudOldSchID")%>'
                                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
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
                                            <td width="20%" class="col1">
                                                <label>
                                                    Citizenship</label>
                                            </td>
                                            <td class="col2">
                                                <input type="radio" name="Nb1" id="rbtnIndian" value="Indian" checked="checked" onclick="javascript:ShowNationality();" />Indian
                                                <input type="radio" name="Nb1" id="rbtnOverseas" value="Overseas" onclick="javascript:ShowNationality();" />Overseas
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <div id="dvNationality" style="display: none;">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td width="19%" class="col2">
                                                                <label>
                                                                    Nationality</label>
                                                            </td>
                                                            <td width="33%" class="col2">
                                                                <asp:TextBox ID="txtNationality" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <label>
                                                                    Passport Number</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtPassportNo" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <label>
                                                                    Date of Issue
                                                                </label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtPPDateofIssue" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <label>
                                                                    Visa Number</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtVisaNumber" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <label>
                                                                    Expiry Date</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtPPExpDate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <label>
                                                                    Visa Type</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtVisaType" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <label>
                                                                    Visa Issue Date</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtVisaIssuedDate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <label>
                                                                    Visa Expiry Date</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtVisaExpiryDate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <label>
                                                                    No of Entry</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtNoOfEntry" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <label>
                                                                    Validity</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtValidity" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <label>
                                                                    Purpose of Visit</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtPurpose" TextMode="MultiLine" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <label>
                                                                    Remark</label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtRemark" TextMode="MultiLine" runat="server"></asp:TextBox>
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
                                                <button id="btnNationalitySave" type="button" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveNationalityDetails();">
                                                    <span></span>
                                                    <div id="Div7">
                                                        Update</div>
                                                </button>
                                                <button id="btnNationalityCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    onclick="return NationalityDetailsClear();">
                                                    <span></span>Cancel</button>
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
                                            <td class="col1 formsubheading">
                                                <label>
                                                    Attachments :</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div id="Div8" style="position: relative; width: 100%">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td width="21%">
                                                                <label>
                                                                    Title</label>
                                                            </td>
                                                            <td width="21%">
                                                                <label>
                                                                    Description</label>
                                                            </td>
                                                            <td width="21%">
                                                                <label>
                                                                    Upload Attachment</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <input name="txtAttTitle" type="text" id="txtAttTitle" />
                                                            </td>
                                                            <td>
                                                                <input name="txtAttDescription" type="text" id="txtAttDescription" />
                                                            </td>
                                                            <td>
                                                                <input type='file' id="AttFile1" onchange="readAttFileURL(this);" />&nbsp;&nbsp;&nbsp;&nbsp;
                                                            </td>
                                                            <td>
                                                                <button id="btnAttachmentSave" type="button" class="btn-icon btn-navy btn-update"
                                                                    onclick="SaveAttachmentDetails();">
                                                                    <span></span>Update</button>&nbsp;
                                                                <button id="btnAttachementCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                    onclick="return AttachmentInfoClear();">
                                                                    <span></span>Cancel</button>
                                                            </td>
                                                        </tr>
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
                                                                                            <asp:TemplateField Visible="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                                                <HeaderTemplate>
                                                                                                    Edit</HeaderTemplate>
                                                                                                <ItemTemplate>
                                                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StudAttachID") %>'
                                                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                                </ItemTemplate>
                                                                                            </asp:TemplateField>
                                                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                                                HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                                                <HeaderTemplate>
                                                                                                    Delete</HeaderTemplate>
                                                                                                <ItemTemplate>
                                                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StudAttachID") %>'
                                                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                                                </ItemTemplate>
                                                                                            </asp:TemplateField>
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
    <asp:HiddenField ID="hfAdvModuleID" runat="server" />
    <asp:HiddenField ID="hfAdvMenuId" runat="server" />
    <asp:HiddenField ID="hfConcession" runat="server" />
</asp:Content>
