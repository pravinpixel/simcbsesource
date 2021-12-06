<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StaffInfo.aspx.cs" Inherits="StaffInfo" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
     <script type="text/javascript" src="../js/maxlength.js"></script>
    <%--Document Ready--%>
    <script type="text/javascript">
        $(document).ready(function () {
            setAlternateDatePicker();
            setDatePicker("[id*=txtSubDate]");
            setDatePicker("[id*=txtRetDate]");
            setDatePicker("[id*=txtFamDOB]");
            setDatePicker("[id*=txtFrom]");
            setDatePicker("[id*=txtTo]");
            setDatePicker("[id*=txtNomDOB]");
            setDatePicker("[id*=txtRemDate]");
            setDatePicker("[id*=txtPunishDate]");
            setDatePicker("[id*=txtRetireDate]");
            setDatePicker("[id*=txtYOC]");
            setDatePicker("[id*=txtDOJ]");
            setDatePicker("[id*=txtUgYOC]");
            setDatePicker("[id*=txtDateRem]");
            setDatePicker("[id*=txtregDate]");
            setDatePicker("[id*=txtregCompDate]");
            setDatePicker("[id*=txtResCert]");
            setDatePicker("[id*=txtResCert]");
            setDatePicker("[id*=txtResignDate]");
            $("[name*=rd1]").click(function () {
                if ($(this).val() == 'Y') { $(".ishandicap").show(); }
                else { $(".ishandicap").hide(); }
            });
            $("[name*=rd1]").click(function () {
                if ($(this).val() == 'Y') { $(".ishandicap").show(); }
                else { $(".ishandicap").hide(); }
            });
            $('input:radio[name=brd1]:nth(1)').click(function () {
                $("[id*=txtHandicap]").val('');
                $(".bankForm").hide("slow");
            });
            $('input:radio[name=brd1]:nth(0)').click(function () {
                $(".bankForm").show("slow");
            });
        }); 
    </script>
    <script type="text/javascript">
        function CheckAll() {
            if ($("[id*=chkContact]").is(':checked')) {
                $("[id*=txtContactAddress]").val($("[id*=txtPermanentAddress]").val());
                $("[id*=txtContactAddress]").attr("disabled", true);
            }
            else {
                $("[id*=txtContactAddress]").attr("disabled", false);
            }
        }
    </script>
    <%--On load--%>
    <script type="text/javascript">
        var subDetails = new Array();
        var langDetails = new Array();
        var courseDetails = new Array();
        var medDetails = new Array();

        var subIndex = 0;
        var langIndex = 0;
        var courseIndex = 0;
        var medIndex = 0;
        $(function () {
            $(".ishandicap").hide();
            $(".bankForm").hide("slow");
            $('input:radio[name=brd1]:nth(1)').attr('checked', true);
            for (i = new Date().getFullYear()+50; i > 1950; i--) {
                $('#txtregFrom').append($('<option />').val(i).html(i));
                $('#txtregTo').append($('<option />').val(i).html(i));
                $('#txtInvYear').append($('<option />').val(i).html(i));
                $('#txtResYear').append($('<option />').val(i).html(i));
            }
            changeAccordion(0);
            if ($("[id*=hdnStaffId]").val() != '') {
                GetPersonalDetails();
                GetAcademicDetails();
                GetCourseDetails();
                GetFamilyDetails();
                GetNomineeDetails();
                GetMedicalRemarks();
                GetServiceDetails();
                GetCareerDetails();
                GetInvDetails();
                GetResignDetails();
                GetLangKnownDetails();
                GetLeaveDetails();
                GetRemarkDetails();
                GetPunishDetails();
                GetRetireDetails();
                GetSubjectDetails();
                var staffID = $("[id*=hdnStaffId]").val();
                GetStaffRelationInfo(staffID);
            }

        });
        function changeAccordion(value) {
            $(".john-accord").accordion({
                "header": "a.menuitem",
                "collapsible": true,
                "active": parseInt(value),
                "autoHeight": false

            });
        }
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
                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffImage", input.files[0]);
                }
            }

        }

        function readAcdURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffAcdSC", input.files[0]);
                }
            }
        }
        function readMedRemURL(input) {

            if (window.FormData) {
                formdata = new FormData();
            }

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffMedical", input.files[0]);
                }
            }
        }

        function readLeaveURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffLeave", input.files[0]);
                }
            }

        }
        function readRemarkURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffRemark", input.files[0]);
                }
            }

        }
        function readPunishURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffPunish", input.files[0]);
                }
            }

        }
        function readRetireURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffRetire", input.files[0]);
                }
            }

        }
    </script>
    <%--Get Personal Details--%>
    <script type="text/javascript">
        function GetPersonalDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetPersonalDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetPersonalSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetPersonalSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Personal");
            $.each(menus, function () {

                $("[id*=hdnStaffId]").val($(this).find("StaffId").text());
                $("[id*=txtEmpCode]").val($(this).find("EmpCode").text());
                $("[id*=txtStaffName]").val($(this).find("StaffName").text());
                $("[id*=txtShortName]").val($(this).find("StaffShortName").text());
                //                if($(this).find("Sex").text()=='M')
                //                    $('input:radio[name=rb1]:nth(0)').attr('checked', true);
                //                else
                //                    $('input:radio[name=rb1]:nth(1)').attr('checked', true);
                //$("[name*=rb1]").val();
                var Gender = $(this).find("Sex").text();

                if (Gender == "Male" || Gender == "M") {
                    $("[id*=rbtnMale]").attr("checked", true);
                }
                else if (Gender == "Female" || Gender == "F") {
                    $("[id*=rbtnFemale]").attr("checked", true);
                }
                $("[id*=datepicker]").val($(this).find("DOBFORMAT").text());
                $("[id*=txtPlaceOfBirth]").val($(this).find("PlaceOfBirth").text());
                $("[id*=txtMotherTongue]").val($(this).find("MotherTongue").text());
                $("[id*=txtNationality]").val($(this).find("Nationality").text());
                $("[id*=ddlReligion]").val($(this).find("ReligionId").text());
                $("[id*=ddlCommunity]").val($(this).find("CommunityId").text());
                $("[id*=ddlCaste]").val($(this).find("Caste").text());
                $("[id*=txtPermanentAddress]").val($(this).find("PermAddress").text());
                $("[id*=txtContactAddress]").val($(this).find("ContactAddress").text());
                $("[id*=dpDownMaraital]").val($(this).find("MaritalStatus").text());
                $("[id*=txtPhoneNo]").val($(this).find("PhoneNo").text());
                $("[id*=txtEmailAddress]").val($(this).find("EmailId").text());
                $("[id*=txtMobileNo]").val($(this).find("MobileNo").text());
                $("[id*=txtPanCard]").val($(this).find("PanCardNo").text());
                $("[id*=txtAadhaar]").val($(this).find("AadhaarNo").text());
                $("[id*=txtSmartCardNo]").val($(this).find("SmartCardNo").text());
                $("[id*=txtRationCardNo]").val($(this).find("RationCardNo").text());
                $("[id*=txtFileNo]").val($(this).find("FileNo").text());
                $("[id*=txtLockerNo]").val($(this).find("LockerNo").text());
                $("[id*=txtDOR]").val($(this).find("DateOfRetirementFormat").text());

                $("[id*=ddlBloodGroup]").val($(this).find("BloodGroupId").text());
                $("[id*=txtDisease]").val($(this).find("Disorders").text());
                $("[id*=txtHeight]").val($(this).find("Height").text());
                $("[id*=txtWeight]").val($(this).find("Weight").text());
                $("[id*=txtEmergency]").val($(this).find("EmergencyPhNo").text());
                $("[id*=txtDrAddress]").val($(this).find("DocAddr").text());
                $("[id*=txtDocName]").val($(this).find("Doctor").text());
                $("[id*=txtDocPhoneNo]").val($(this).find("DocPhNo").text());
                var strSplit = $(this).find("IdMarks").text();
                var split = strSplit.split(";");
                $("[id*=txtIdMark1]").val(split[0]);
                $("[id*=txtIdMark2]").val(split[1]);
                if ($(this).find("IsHandicap").text() == 'Y') {
                    $('input:radio[name=mrd1]:nth(1)').attr('checked', true);
                    $("[id*=txtHandicap]").val($(this).find("HandicapDetails").text());
                    $(".ishandicap").show();
                }
                else {
                    $('input:radio[name=mrd1]:nth(0)').attr('checked', true);
                    $(".ishandicap").hide();
                }


                if ($(this).find("BankStatus").text() == 'Y') {
                    $('input:radio[name=brd1]:nth(0)').attr('checked', true);
                    $(".bankForm").show("slow");
                }
                else {
                    $('input:radio[name=brd1]:nth(1)').attr('checked', true);
                    $(".bankForm").hide("slow");
                }
                $("[id*=txtDisease]").val();
                $("[id*=txtBankName]").val($(this).find("BankName").text());
                $("[id*=txtBranch]").val($(this).find("BankBranchCode").text());
                $("[id*=txtAccNo]").val($(this).find("AccNo").text());
                $("[id*=txtEPF]").val($(this).find("EPFCode").text());
                $("[id*=txtDOJ]").val($(this).find("DOJFORMAT").text());
                $("[id*=ddlStatus]").val($(this).find("PresentStatus").text());
                $("[id*=txtBrothers]").val($(this).find("WorkingCount").text());
                $("[id*=txtSisters]").val($(this).find("SistersCount").text());
                
                var newSrc = '';
                if ($(this).find("PhotoFile").text() == "")
                    newSrc = "../img/photo.jpg";
                else
                    newSrc = "../Staffs/Uploads/ProfilePhotos/" + $(this).find("PhotoFile").text();
                $("[id*=img_prev]").attr('src', newSrc);
            });
        }

    </script>
    <%--Get Academic Details--%>
    <script type="text/javascript">
        function GetAcademicDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","staffAcdId": "' + "" + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetAcademicDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetAcademicSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetAcademicSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Academic");
            var row = $("[id*=dgAcdDetails] tr:last-child").clone(true);
            $("[id*=dgAcdDetails] tr").not($("[id*=dgAcdDetails] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditAcademic('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteAcademic('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffAcdId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffAcdId").text() + danchorEnd;
                    row.addClass("even");
                    var type = '';
                    if ($(this).find("Type").text() == "1")
                        type = "Proffessional";
                    else if ($(this).find("Type").text() == "2")
                        type = "Academic";

                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("CourseCompleted").text());
                    $("td", row).eq(2).html($(this).find("BoardOrUniv").text());
                    $("td", row).eq(3).html($(this).find("YOCFORMAT").text());
                    $("td", row).eq(4).html($(this).find("MainSubName").text());
                    $("td", row).eq(5).html($(this).find("AncillarySubName").text());
                    $("td", row).eq(6).html($(this).find("CertNo").text());
                    $("td", row).eq(7).html($(this).find("SDFORMAT").text());
                    $("td", row).eq(8).html($(this).find("RDFORMAT").text());
                    $("td", row).eq(9).html(type);
                    if ($(this).find("FileName").text() != "") {
                        $("td", row).eq(10).html("<a target='_blank' href=../Staffs/Uploads/AcademicRecords/" + $(this).find("FileName").text() + ">" + $(this).find("FileName").text() + "</a>").addClass("download-links");
                    }
                    else {
                        $("td", row).eq(10).html($(this).find("FileName").text()).removeClass("download-links"); ; 
                    }
                   
                    $("td", row).eq(11).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(12).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgAcdDetails]").append(row);
                    row = $("[id*=dgAcdDetails] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('');
                $("td", row).eq(5).html('');
                $("td", row).eq(6).html('No Records Found');
                $("td", row).eq(7).html('');
                $("td", row).eq(8).html('');
                $("td", row).eq(9).html('');
                $("td", row).eq(10).html('');
                $("td", row).eq(11).html('');
                $("td", row).eq(12).html('');
                $("[id*=dgAcdDetails]").append(row);
                row.addClass("even");
                row = $("[id*=dgAcdDetails] tr:last-child").clone(true);
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                $('.deleteacc').hide();
            }
            else {
                $('.deleteacc').show();
            }
        }
        function GetCourseDetails() {

            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';

            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetCourseDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetCourseSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetCourseSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var courseMenu = xml.find("StaffCourse");

            $("[id*=tblCourseUg] tbody").children().remove();
            if (courseMenu.length > 0) {
                $.each(courseMenu, function () {
                    AppendCourse($(this).find("Course").text(), $(this).find("BoardOrUniv").text(), $(this).find("MainSub").text(), $(this).find("DepartmentName").text(), $(this).find("YearOfCompletion").text(), $(this).find("StaffUndGngId").text(), $(this).find("RowNumber").text());
                });
            }
            else {
                var row = "<tr><td></td><td></td><td></td><td>No records found</td><<td></td><td></td></tr>";
                $("[id*=tblCourseUg] tbody").append(row);
            }
        }
        function AppendCourse(course, board, main, mainText, yoc, courseIndex, courseSlNo) {
            if (main == '')
                mainText = '';
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteCourse('";
                danchorEnd = "');\">Delete</a>";
            }

            var ehref = eanchor + courseIndex + eanchorEnd;
            var dhref = danchor + courseIndex + danchorEnd;
            var row = "<tr><td>" + courseSlNo + "</td><td>" + course + "</td><td>" + board + "</td><td>" + mainText + "</td><<td>" + yoc + "</td><td class=\"deleteacc delete-links\">" + dhref + "</td></tr>";
            $("[id*=tblCourseUg] tbody").append(row);
        }
    </script>
    <%--Get Family Details--%>
    <script type="text/javascript">
        function GetFamilyDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetFamilyDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetFamilySuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetFamilySuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Family");
            var row = $("[id*=dgFamily] tr:last-child").clone(true);
            $("[id*=dgFamily] tr").not($("[id*=dgFamily] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditFamily('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteFamily('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffFamilyId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffFamilyId").text() + danchorEnd;
                    row.addClass("even");
                    var sex = '';
                    if ($(this).find("Sex").text() == "F")
                        sex = "Female";
                    else if ($(this).find("Sex").text() == "M")
                        sex = "Male";
                    $("td", row).eq(0).html($(this).find("RelationShipName").text());
                    $("td", row).eq(1).html($(this).find("Name").text());
                    $("td", row).eq(2).html($(this).find("DOBFORMAT").text());
                    $("td", row).eq(3).html(sex);
                    $("td", row).eq(4).html($(this).find("Qualification").text());
                    $("td", row).eq(5).html($(this).find("Occupation").text());
                    $("td", row).eq(6).html($(this).find("Address").text());
                    $("td", row).eq(7).html($(this).find("ContactNo").text());
                    $("td", row).eq(8).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgFamily]").append(row);
                    row = $("[id*=dgFamily] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('No records found');
                $("td", row).eq(5).html('');
                $("td", row).eq(6).html('');
                $("td", row).eq(7).html('');
                $("td", row).eq(8).html('');
                $("td", row).eq(9).html('');
                $("[id*=dgFamily]").append(row);
                row = $("[id*=dgFamily] tr:last-child").clone(true);
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
        }
        function EditFamily(id) {
            var parameters = '{"StaffFamilyId": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/EditFamilyDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditFamilySuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnEditFamilySuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("EditFamily");
            if (menus.length > 0) {
                $.each(menus, function () {
                    $("[id*=hdnFamilyID]").val($(this).find("StaffFamilyId").text());
                    $("[id*=ddRelations]").val($(this).find("RelationShipId").text());
                    $("[id*=txtName]").val($(this).find("Name").text());
                    $("[id*=txtFamDOB]").val($(this).find("DOBFORMAT").text());
                    $("[id*=ddlSex]").val($(this).find("Sex").text());
                    $("[id*=txtOccupation]").val($(this).find("Occupation").text());
                    $("[id*=txtAddress]").val($(this).find("Address").text());
                    $("[id*=txtQualification]").val($(this).find("Qualification").text());
                    $("[id*=txtContactNo]").val($(this).find("ContactNo").text());
                });
            }
        }

        function DeleteFamily(id) {
            var parameters = '{"staffFamilyId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteFamilyDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteFamilySuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteFamilySuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetFamilyDetails($("[id*=hdnStaffId]").val());
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
    </script>
    <%--Get Nominee Details--%>
    <script type="text/javascript">
        function GetNomineeDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetNomineeDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetNomineeSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetNomineeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Nominee");
            var row = $("[id*=dgNominee] tr:last-child").clone(true);
            $("[id*=dgNominee] tr").not($("[id*=dgNominee] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';

            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteNominee('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffNomineeId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffNomineeId").text() + danchorEnd;
                    row.addClass("even");
                    var sex = '';
                    if ($(this).find("Sex").text() == 'F')
                        sex = "Female";
                    else
                        sex = "Male";
                    $("td", row).eq(0).html($(this).find("Name").text());
                    $("td", row).eq(1).html($(this).find("Address").text());
                    $("td", row).eq(2).html($(this).find("RelationshipName").text());
                    $("td", row).eq(3).html($(this).find("DOBFORMAT").text());
                    $("td", row).eq(4).html(sex);
                    $("td", row).eq(5).html($(this).find("Share").text());
                    $("td", row).eq(6).html($(this).find("Type").text());
                    $("td", row).eq(7).html($(this).find("ContactNo").text());
                    //$("td", row).eq(7).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(8).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgNominee]").append(row);
                    row = $("[id*=dgNominee] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('No Records Found');
                $("td", row).eq(4).html('');
                $("td", row).eq(5).html('');
                $("td", row).eq(6).html('');
                //$("td", row).eq(7).html(ehref).addClass("editacc edit-links");
                $("td", row).eq(7).html('');
                $("[id*=dgNominee]").append(row);
                row = $("[id*=dgNominee] tr:last-child").clone(true);
            }


            if ($("[id*=hfDeletePrm]").val() == 'false') {
                $('.deleteacc').hide();
            }
            else {
                $('.deleteacc').show();
            }
        }

        function DeleteNominee(id) {
            var parameters = '{"staffNomineeId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteNomineeDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteNomineeSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteNomineeSuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetNomineeDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
    </script>
    <%--Get Service Details--%>
    <script type="text/javascript">
        function GetServiceDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetServiceDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetServiceSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetServiceSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Service");
            var row = $("[id*=dgService] tr:last-child").clone(true);
            $("[id*=dgService] tr").not($("[id*=dgService] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditService('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteService('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffAcdServiceId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffAcdServiceId").text() + danchorEnd;
                    row.addClass("even");

                   // $("td", row).eq(0).html($(this).find("AcademicYear").text());
                    $("td", row).eq(0).html($(this).find("DOJ").text());
                    $("td", row).eq(1).html($(this).find("DesignationName").text());
                    $("td", row).eq(2).html($(this).find("DepartmentName").text());
                    $("td", row).eq(3).html($(this).find("PlaceOfWork").text());
                    $("td", row).eq(4).html($(this).find("SubHandling").text());
                    $("td", row).eq(5).html($(this).find("ClassName").text());
                    $("td", row).eq(6).html($(this).find("ModeName").text());
                    $("td", row).eq(7).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(8).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgService]").append(row);
                    row = $("[id*=dgService] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html($(this).find("DesignationName").text());
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('No Records Found');
                $("td", row).eq(5).html('');
                $("td", row).eq(6).html('');
                $("td", row).eq(7).html('');
                $("td", row).eq(8).html('');
                $("td", row).eq(9).html('');
                $("[id*=dgService]").append(row);
                row = $("[id*=dgService] tr:last-child").clone(true);
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                $('.deleteacc').hide();
            }
            else {
                $('.deleteacc').show();
            }
        }

        function EditService(id) {

            var parameters = '{"staffServiceId": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/EditServiceDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditServiceSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnEditServiceSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("EditService");
            $.each(menus, function () {

                $("[id*=hdnStaffAcdId]").val($(this).find("StaffAcdServiceId").text());
                $("[id*=ddlDesignation]").val($(this).find("DesignationId").text());
                $("[id*=ddlServiceDepartment]").val($(this).find("DepartmentID").text());
                $("[id*=ddlPlaceofWork]").val($(this).find("PlaceOfWorkID").text());
                $("[id*=ddlSubject]").val($(this).find("SubjectHandling").text());
                $("[id*=ddlClass]").val($(this).find("ClassAllocated").text());
                $("[id*=ddlModes]").val($(this).find("Mode").text());
                $("[id*=btnServiceSubmit]").val('Update');

            });
        }

        function DeleteService(id) {
            var parameters = '{"staffAcdServiceId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteServiceDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteServiceSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteServiceSuccess(response) {

            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetServiceDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
    </script>
    <%--Get Subject Details--%>
    <script type="text/javascript">
        function GetSubjectDetails() {

            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';

            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetSubjectDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetSubjectDetailSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetSubjectDetailSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menu = xml.find("SubjectDetails");

            $("[id*=tblSubDetais] tbody").children().remove();
            if (menu.length > 0) {
                $.each(menu, function () {
                    AppendSub($(this).find("DepartmentName").text(), $(this).find("StudiedUpto").text(), $(this).find("StaffLangServiceId").text(), $(this).find("RowNumber").text())
                });
            }
            else {
                var row = "<tr><td></td><td></td><td>No records found</td><td></td></td></tr>";
                $("[id*=tblSubDetais] tbody").append(row);
            }
        }
    </script>
    <%--Get Career Details--%>
    <script type="text/javascript">
        function GetCareerDetails() {
            CancelCareerDetails();
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","staffCareerServiceId": ""}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetCareerDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetCareerSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetCareerSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("CareerService");
            var row = $("[id*=dgCareer] tr:last-child").clone(true);
            $("[id*=dgCareer] tr").not($("[id*=dgCareer] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditCareer('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteCareer('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffCareerServiceId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffCareerServiceId").text() + danchorEnd;
                    row.addClass("even");

                    $("td", row).eq(0).html($(this).find("CSFORMAT").text());
                    $("td", row).eq(1).html($(this).find("OrderNo").text());
                    $("td", row).eq(2).html($(this).find("DesignationName").text());
                    $("td", row).eq(3).html($(this).find("Placeofwork").text());
                    $("td", row).eq(4).html($(this).find("Building").text());
                    $("td", row).eq(5).html($(this).find("ProbationPeriod").text());
                    $("td", row).eq(6).html($(this).find("CompletionDateFormat").text());
                    $("td", row).eq(7).html($(this).find("CompletionOrderNo").text());
                    $("td", row).eq(8).html($(this).find("AcdFromDate").text());
                    $("td", row).eq(9).html($(this).find("AcdToDate").text());
                    $("td", row).eq(10).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(11).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgCareer]").append(row);
                    row = $("[id*=dgCareer] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('No Records Found');
                $("td", row).eq(5).html('');
                $("td", row).eq(6).html('');
                $("td", row).eq(7).html('');
                $("td", row).eq(8).html('');
                $("td", row).eq(9).html('');
                $("td", row).eq(10).html('');
                $("td", row).eq(11).html('');
                $("[id*=dgCareer]").append(row);
                row.addClass("even");
                row = $("[id*=dgCareer] tr:last-child").clone(true);
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                $('.deleteacc').hide();
            }
            else {
                $('.deleteacc').show();
            }
        }

        function EditCareer(id) {

            var parameters = '{"staffId": "","staffCareerServiceId": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetCareerDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditCareerSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnEditCareerSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("CareerService");
            $.each(menus, function () {
                $("[id*=hdnStaffCareerId]").val($(this).find("StaffCareerServiceId").text());
                $("[id*=txtregDate]").val($(this).find("CSFORMAT").text());
                $("[id*=ddlPlaceofWork1]").val($(this).find("PlaceofworkID").text());
                $("[id*=ddlBuilding]").val($(this).find("BuildingID").text());
                $("[id*=txtregOrder]").val($(this).find("OrderNo").text());
                $("[id*=ddlregDesignation]").val($(this).find("DesignationId").text());
                $("[id*=txtregProbPeriod]").val($(this).find("ProbationPeriod").text());
                $("[id*=txtregCompOrder]").val($(this).find("CompletionOrderNo").text());
                $("[id*=txtregCompDate]").val($(this).find("CompletionDateFormat").text());
                $("[id*=txtregFrom]").val($(this).find("AcdFromDate").text());
                $("[id*=txtregTo]").val($(this).find("AcdToDate").text());
                $("[id*=txtDescription]").val($(this).find("Description").text());
                $("[id*=txtSalaryDescription]").val($(this).find("SalaryDescription").text());
            });
        }

        function DeleteCareer(id) {
            var parameters = '{"staffAcdServiceId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteCareerDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteCareerSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteCareerSuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetCareerDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
    </script>
    <%--Get Invigilation Details--%>
    <script type="text/javascript">
        function GetInvDetails() {

            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","staffExtInvId": ""}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetInvDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetInvSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetInvSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("InvService");
            var row = $("[id*=dgInv] tr:last-child").clone(true);
            $("[id*=dgInv] tr").not($("[id*=dgInv] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditInv('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteInv('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffExtInvId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffExtInvId").text() + danchorEnd;
                    row.addClass("even");

                    $("td", row).eq(0).html($(this).find("Year").text());
                    $("td", row).eq(1).html($(this).find("SchoolName").text());
                    $("td", row).eq(2).html($(this).find("Place").text());
                    $("td", row).eq(3).html($(this).find("InvigilationType").text());
                    $("td", row).eq(4).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(5).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgInv]").append(row);
                    row = $("[id*=dgInv] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('No Records Found');
                $("td", row).eq(4).html('');
                $("td", row).eq(5).html('');
                row.addClass("even");
                $("[id*=dgInv]").append(row);
                row = $("[id*=dgInv] tr:last-child").clone(true);
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                $('.deleteacc').hide();
            }
            else {
                $('.deleteacc').show();
            }
        }

        function EditInv(id) {

            var parameters = '{"staffId": "","staffExtInvId": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetInvDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditInvSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnEditInvSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("InvService");
            $.each(menus, function () {
                $("[id*=txtInvYear]").val($(this).find("Year").text());
                $("[id*=txtInvSchool]").val($(this).find("SchoolName").text());
                $("[id*=txtInvPlace]").val($(this).find("Place").text());
                $("[id*=ddlInvTypes]").val($(this).find("InvigilationId").text());
                $("[id*=hdnStaffExtInvId]").val($(this).find("StaffExtInvId").text());

            });
        }

        function DeleteInv(id) {
            var parameters = '{"staffExtInvId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteInvDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteInvSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteInvSuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetInvDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
    </script>
    <%--Get Resign Details--%>
    <script type="text/javascript">
        function GetResignDetails() {

            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetResignDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetResignSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetResignSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Resign");

            $.each(menus, function () {
                $("[id*=txtResYear]").val($(this).find("Year").text());
                $("[id*=txtResReason]").val($(this).find("Reason").text());
                $("[id*=txtResCert]").val($(this).find("CERTFORMAT").text());
                $("[id*=txtResignDate]").val($(this).find("RESFORMAT").text());
                $("[id*=hdnResignId]").val($(this).find("[StaffResignId]").text());
            });

        }

    </script>
    <%--Get Retire Details--%>
    <script type="text/javascript">
        function GetRetireDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetRetireDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetRetireSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetRetireSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Retire");
            var row = $("[id*=dgRetire] tr:last-child").clone(true);
            $("[id*=dgRetire] tr").not($("[id*=dgRetire] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditRetire('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteRetire('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffRetirementId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffRetirementId").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RetirementDateFormat").text());
                    $("td", row).eq(1).html($(this).find("RetirementTitle").text());
                    $("td", row).eq(2).html($(this).find("RetirementReason").text());
                    $("td", row).eq(3).html($(this).find("FileName").text());
                    $("td", row).eq(4).html(dhref).addClass("deleteacc");
                    $("[id*=dgRetire]").append(row);
                    row = $("[id*=dgRetire] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('No records found');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('');

                $("[id*=dgRetire]").append(row);
                row = $("[id*=dgRetire] tr:last-child").clone(true);
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
        }
    </script>
    <%--Save Personal Details--%>
    <script type="text/javascript">


        function SavePersonalDetails() {
            if ($('#aspnetForm').valid()) {
                var Gender;
                if ($("[id*=rbtnMale]").is(':checked')) {
                    Gender = "M";
                }

                else if ($("[id*=rbtnFemale]").is(':checked')) {
                    Gender = "F";
                }
                var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","staffName": "' + $("[id*=txtStaffName]").val() + '","staffShortName": "' + $("[id*=txtShortName]").val() + '","empCode": "' + $("[id*=txtEmpCode]").val() + '","sex": "' + Gender + '","dob": "' + $("[id*=datepicker]").val() + '","pob": "' + $("[id*=txtPlaceOfBirth]").val() + '","motherTongue": "' + $("[id*=txtMotherTongue]").val() + '","nationality": "' + $("[id*=txtNationality]").val() + '","religionId": "' + $("[id*=ddlReligion]").val() + '","communityId": "' + $("[id*=ddlCommunity]").val() + '","caste": "' + $("[id*=ddlCaste]").val() + '","maritalStatus": "' + $("[id*=dpDownMaraital]").val() + '","permAddress": "' + $("[id*=txtPermanentAddress]").val() + '","contactAddress": "' + $("[id*=txtContactAddress]").val() + '","phoneNo": "' + $("[id*=txtPhoneNo]").val() + '","emailId": "' + $("[id*=txtEmailAddress]").val() + '","mobileNo": "' + $("[id*=txtMobileNo]").val() + '","panCard": "' + $("[id*=txtPanCard]").val() + '","aadhaarNo": "' + $("[id*=txtAadhaar]").val() + '","RationCard": "' + $("[id*=txtRationCardNo]").val() + '","SmartCard": "' + $("[id*=txtSmartCardNo]").val() + '","FileNo": "' + $("[id*=txtFileNo]").val() + '","LockerNo": "' + $("[id*=txtLockerNo]").val() + '","photoFile": "' + $("[id*=userPhoto]").val().replace(/C:\\fakepath\\/i, '') + '","dateOfRetirement": "' + $("[id*=txtDOR]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '","PresentStatus": "' + $("[id*=ddlStatus]").val() + '","WorkingCount": "' + $("[id*=txtBrothers]").val() + '","SistersCount": "' + $("[id*=txtSisters]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffInfo.aspx/InsertStaff",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSaveSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnSaveSuccess(response) {
            var stId = response.d.StaffId;
            $("[id*=hdnStaffId]").val(stId);
            if (response.d.Status == "Updated") {
                AlertMessage('success', "Updated");
                CancelPersonalPanel();
                GetPersonalDetails();
                changeAccordion(1);
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }

            else if (response.d.Status == "Insert Failed") {
                AlertMessage('fail', "Insert");
            }
            else {
                AlertMessage('success', "Inserted");
                changeAccordion(1);
            }

            var staffId = $("[id*=hdnStaffId]").val();
            formdata.append("StaffId", staffId);
            if (formdata) {
                $.ajax({
                    url: "../Staffs/StaffInfo.aspx",
                    type: "POST",
                    data: formdata,
                    processData: false,
                    contentType: false,
                    success: function (res) {
                        formdata = new FormData();
                        // alert(res)
                    }
                });
            }
        }
        
    </script>
    <%--Save Academic Details--%>
    <script type="text/javascript">
        function GetStaffRelationInfo(StaffID) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffInfo.aspx/GetStaffRelationInfo",
                    data: '{StaffID: ' + StaffID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetStaffRelationInfoSuccess,
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
        function OnGetStaffRelationInfoSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var staffchild = xml.find("StaffRelations");
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
                eanchor = "<a  href=\"javascript:EditStaffRelationInfo('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteStaffRelationInfo('";
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
                    var ehref = eanchor + $(this).find("StaffRelID").text() + "','" + $(this).find("Relationship").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffRelID").text() + danchorEnd;
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RelationName").text());
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

        function EditStaffRelationInfo(StaffRelID, Relationship) {

            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $("[id*=hfStaffRelID]").val(StaffRelID);
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffInfo.aspx/EditStaffRelationInfo",
                    data: '{StaffRelID: ' + StaffRelID + ',"Relationship": "' + Relationship + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditStaffRelationSuccess,
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

        function OnEditStaffRelationSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var rel = xml.find("StaffRelation");
            $.each(rel, function () {

                $("[id*=ddlStaff1] option[value='" + $(this).find("RelationID").text() + "']").attr("selected", "true");
                $("[id*=ddlRelationship1] option[value='" + $(this).find("Relationship").text() + "']").attr("selected", "true");
               

            });
        };

        function DeleteStaffRelationInfo(StaffRelID, Relation) {

            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/DeleteStaffRelationInfo",
                        data: '{StaffRelID: ' + StaffRelID + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteStaffRelationInfoSuccess,
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
        function OnDeleteStaffRelationInfoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                var staffID = $("[id*=hdnStaffId]").val();
                if (staffID != "") {
                    GetStaffRelationInfo(staffID);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        };

        function SaveRelativeDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    var hdnStaffId = $("[id*=hdnStaffId]").val();
                    var RelationID = $("[id*=ddlStaff1]").val();
                    var Relationship = $("[id*=ddlRelationship1]").val();
                    var StaffRelId = $("[id*=hfStaffRelID]").val();
                    var parameters = '{"staffId": "' + hdnStaffId + '","RelationID": "' + RelationID + '","Relationship": "' + Relationship + '","StaffRelId": "' + StaffRelId + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateStaffRelativeDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnStaffRelativeSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnStaffRelativeSuccess(response) {
            if (response.d.Status == "Updated") {
                AlertMessage('success', "Updated");
                $("[id*=hfStaffRelID]").val("");
                var staffID = $("[id*=hdnStaffId]").val();
                GetStaffRelationInfo(staffID);
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }

            else if (response.d.Status == "Insert Failed") {
                AlertMessage('fail', "Insert");
            }
            else {
                AlertMessage('success', "Inserted");
                var staffID = $("[id*=hdnStaffId]").val();
                $("[id*=hfStaffRelID]").val("");
                GetStaffRelationInfo(staffID);
            }
        }
        function SaveAcademicDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    var otherparameters = '"staffId": "' + $("[id*=hdnStaffId]").val() + '","coursecomp": "' + $("[id*=txtCourseCom]").val() + '","board": "' + $("[id*=txtBoard]").val() + '","yoc": "' + $("[id*=ddlYOC]").val() + '","mainSub": "' + $("[id*=ddlDepartment]").val() + '","ancSub": "' + $("[id*=ddlDepartment2]").val() + '","certNo": "' + $("[id*=txtCertNo]").val() + '","subDate": "' + $("[id*=txtSubDate]").val() + '","retDate": "' + $("[id*=txtRetDate]").val() + '","type": "' + $("[id*=ddlType]").val() + '","filePath": "","fileName": "' + $("[id*=fileSC]").val().replace(/C:\\fakepath\\/i, '') + '", "userId": "' + $("[id*=hdnUserId]").val() + '","staffAcdId": "' + $("[id*=hdnAcdDetails]").val() + '"';
                    var jsonText = JSON.stringify(courseDetails);
                    var parameters = '{"courseDetails":' + jsonText + ',' + otherparameters + '}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateAcademicDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveAcademicDetSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveAcademicDetSuccess(response) {
            if (response.d != '') {
                AlertMessage('success', "Updated");
                CancelAcademicDetails();
                GetAcademicDetails();
                if (response.d != "-1") {
                    formdata.append("FileName", response.d);
                    if (formdata) {

                        $.ajax({
                            url: "../Staffs/StaffInfo.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                                formdata = new FormData();
                            }
                        });
                    }
                }
            }
            else {
                AlertMessage('fail', "Update");
            }
        }

        function EditAcademic(id) {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","staffAcdId": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetAcademicDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditAcdSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnEditAcdSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Academic");
            $.each(menus, function () {
                $("[id*=hdnAcdDetails]").val($(this).find("StaffAcdId").text());
                $("[id*=txtCourseCom]").val($(this).find("CourseCompleted").text());
                $("[id*=txtBoard]").val($(this).find("BoardOrUniv").text());
                $("[id*=ddlYOC]").val($(this).find("YearOfCompletion").text());
                $("[id*=ddlDepartment]").val($(this).find("MainSub").text());
                $("[id*=ddlDepartment2]").val($(this).find("AncillarySub").text());
                $("[id*=txtCertNo]").val($(this).find("CertNo").text());
                $("[id*=txtSubDate]").val($(this).find("SDFORMAT").text());
                $("[id*=txtRetDate]").val($(this).find("RDFORMAT").text());
                $("[id*=ddlType]").val($(this).find("Type").text());
            });
        }

        function DeleteAcademic(id) {
            var parameters = '{"userId": "' + $("[id*=hdnUserId]").val() + '","staffAcdId": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteAcademicDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteAcdSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteAcdSuccess(response) {
            if (response.d == "Delete") {
                AlertMessage('success', "Deleted");
                GetAcademicDetails();
            }
            else if (response.d == "Failed") {
                AlertMessage('fail', "Delete Failed");
            }
        }

        function SaveCourseUgDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($("[id*=txtCourseUg]").val() != '' && $("[id*=txtUgBoard]").val() != '') {
                    var staffId = $("[id*=hdnStaffId]").val();
                    var course = $("[id*=txtCourseUg]").val();
                    var board = $("[id*=txtUgBoard]").val();
                    var mainCourse = $("[id*=ddlMainCourse]").val();
                    var yoc = $("[id*=ddlUgYOC]").val();
                    var userid = $("[id*=hdnUserId]").val();
                    CancelCourseDetails();
                    var parameters = '{"staffUndGngId": "","staffId": "' + staffId + '","course": "' + course + '","board": "' + board + '","main": "' + mainCourse + '","yoc": "' + yoc + '","userid": "' + userid + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateCourseDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveCourseSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });

                }

                else {
                    AlertMessage('info', "Please select course and Board/University");
                }
            }
            else {
                AlertMessage('info', "Please enter personal details first");
            }
        }

        function OnSaveCourseSuccess(response) {
            if (response.d == "Updated") {
                GetCourseDetails();
                AlertMessage('success', "Updated");
                changeAccordion(2);
            }
            else
                AlertMessage('fail', "Update Failed");
        }
        function DeleteCourse(id) {
            var parameters = '{"staffUndGngId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteCourseDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteCourseSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteCourseSuccess(response) {
            if (response.d == "Delete") {
                AlertMessage('success', "Deleted");
                GetCourseDetails();
            }
            else if (response.d == "Failed") {
                AlertMessage('fail', "Delete Failed");
            }
        }
    </script>
    <%--Save Family Details--%>
    <script type="text/javascript">
        function SaveFamilyDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {

                    var parameters = '{"staffFamilyId": "' + $("[id*=hdnFamilyID]").val() + '","staffId": "' + $("[id*=hdnStaffId]").val() + '","relId": "' + $("[id*=ddRelations]").val() + '","name": "' + $("[id*=txtName]").val() + '","dob": "' + $("[id*=txtFamDOB]").val() + '","sex": "' + $("[id*=ddlSex]").val() + '","qaul": "' + $("[id*=txtQualification]").val() + '","occup": "' + $("[id*=txtOccupation]").val() + '","addr": "' + $("[id*=txtAddress]").val() + '","contno": "' + $("[id*=txtContactNo]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateFamilyDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveFamilyDetSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveFamilyDetSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                GetFamilyDetails();
                changeAccordion(3);
                CancelFamily();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }

        }
    </script>
    <%--Save Nominee Details--%>
    <script type="text/javascript">
        function SaveNomineeDetails() {

            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","relId": "' + $("[id*=ddlStaffRelationship]").val() + '","name": "' + $("[id*=txtNomineeName]").val() + '","addr": "' + $("[id*=txtNomAddr]").val() + '","dob": "' + $("[id*=txtNomDOB]").val() + '","sex": "' + $("[id*=ddlNomSex]").val() + '","share": "' + $("[id*=txtShare]").val() + '","type": "' + $("[id*=ddlNominees]").val() + '","contactNo": "' + $("[id*=txtNomContact]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateNomineeDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveNomineeDetSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveNomineeDetSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                GetNomineeDetails();
                CancelNomineeDetails();
                //changeAccordion(4);
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }

        }
    </script>
    <%--Save Medical Details--%>
    <script type="text/javascript">
        function SaveMedicalDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    var chkVal = '';
                    if ($("[id*=radio1]").is(':checked'))
                        chkVal = $("[id*=radio1]").val();
                    else
                        chkVal = $("[id*=radio2]").val();
                    var otherparameters = '"staffId": "' + $("[id*=hdnStaffId]").val() + '","bloodGroupId": "' + $("[id*=ddlBloodGroup]").val() + '","disorders": "' + $("[id*=txtDisease]").val() + '","height": "' + $("[id*=txtHeight]").val() + '","weight": "' + $("[id*=txtWeight]").val() + '","emergencyPhNo": "' + $("[id*=txtEmergency]").val() + '","doctor": "' + $("[id*=txtDocName]").val() + '","docAddr": "' + $("[id*=txtDrAddress]").val() + '","docPhNo": "' + $("[id*=txtDocPhoneNo]").val() + '","idMarks": "' + $("[id*=txtIdMark1]").val() + ";" + $("[id*=txtIdMark2]").val() + '","isHandicap": "' + chkVal + '","handicapDetail": " ' + $("[id*=txtHandicap]").val() + ' ", "userId": "' + $("[id*=hdnUserId]").val() + '"';
                    var jsonText = JSON.stringify(medDetails);
                    var parameters = '{"medDetails":' + jsonText + ',' + otherparameters + '}';

                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateMedicalDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveAcademicDetSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveMedicalDetSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }


        }

        function SaveMedicalRemarks() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($("[id*=txtDateRem]").val() != '' && $("[id*=txtReason]").val() != '') {
                    var staffId = $("[id*=hdnStaffId]").val();
                    var date = $("[id*=txtDateRem]").val();
                    var reason = $("[id*=txtReason]").val();
                    var userid = $("[id*=hdnUserId]").val();

                    var parameters = '{"staffMedRecId": "","staffId": "' + staffId + '","reason": "' + reason + '","recordDate": "' + date + '","fileName": "' + $("[id*=fileAttach]").val().replace(/C:\\fakepath\\/i, '') + '","filePath": "no file path","userId": "' + userid + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateMedicalRemarkDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveMedicalRemSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
                else {
                    AlertMessage('info', "Please select Date and Reason");
                }
            }
            else {
                AlertMessage('info', "Please enter personal details first");
            }
        }
        function OnSaveMedicalRemSuccess(response) {
            if (response.d != '') {
                GetMedicalRemarks();
                changeAccordion(5);
                CancelMedRemarks();
                AlertMessage('success', "Updated");
                if (response.d != '-1') {
                    formdata.append("FileName", response.d);
                    if (formdata) {
                        $.ajax({
                            url: "../Staffs/StaffInfo.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                                formdata = new FormData();
                                //alert(res)
                            }
                        });
                    }
                }

            }
            else if (response.d == "Failed")
                AlertMessage('fail', "Update Failed");
        }
        function DeleteMed(id) {
            var userid = $("[id*=hdnUserId]").val();
            var parameters = '{"staffMedRecId": "' + id + '","userId": "' + userid + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteMedicalRemarkDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteMedicalRemSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteMedicalRemSuccess(response) {
            if (response.d == "Delete") {
                AlertMessage('success', "Deleted");
                GetMedicalRemarks();
            }
            else if (response.d == "Failed") {
                AlertMessage('fail', "Delete Failed");
            }
        }

        function GetMedicalRemarks() {

            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';

            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetMedicalRemarks",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetMedicalRemarkSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetMedicalRemarkSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menu = xml.find("MedicalRecords");

            $("[id*=tblMedDetais] tbody").children().remove();
            if (menu.length > 0) {
                $.each(menu, function () {
                    AppendMed($(this).find("DateFormat").text(), $(this).find("Reason").text(), $(this).find("FileName").text(), $(this).find("FilePath").text(), $(this).find("StaffMedRecId").text(), $(this).find("RowNumber").text());
                });
            }
            else {
                var row = "<tr class=\"even\"><td></td><td></td><td></td><td>No records found</td><<td></td><td></td></tr>";
                $("[id*=tblMedDetais] tbody").append(row);
            }
        }
        function AppendMed(date, reason, filename, filepath, medIndex, medSlIndex) {
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteMed('";
                danchorEnd = "');\">Delete</a>";
            }

            var ehref = eanchor + medIndex + eanchorEnd;
            var dhref = danchor + medIndex + danchorEnd;
            var row = "<tr class=\"even\"><td>" + medSlIndex + "</td><td>" + date + "</td><td>" + reason + "</td><td>" + filename + "</td><td class=\"deleteacc delete-links\">" + dhref + "</td></tr>";
            $("[id*=tblMedDetais] tbody").append(row);
        }

    </script>
    <%--Save Service Details--%>
    <script type="text/javascript">
        function SaveServiceAppDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                var parameters = '{"staffAcdServiceId": "' + $("[id*=hdnStaffAcdId]").val() + '","staffId": "' + $("[id*=hdnStaffId]").val() + '","acdId": "' + $("[id*=hdnAcd]").val() + '","doj": "' + $("[id*=txtDOJ]").val() + '","desg": "' + $("[id*=ddlDesignation]").val() + '","dept": "' + $("[id*=ddlServiceDepartment]").val() + '","pow": "' + $("[id*=ddlPlaceofWork]").val() + '","subHandle": "' + $("[id*=ddlSubject]").val() + '","classAllocate": "' + $("[id*=ddlClass]").val() + '","mode": "' + $("[id*=ddlModes]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffInfo.aspx/UpdateServiceAppDetails",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSaveServiceAppSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveServiceAppSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                CancelServiceAppDetails();
                GetServiceDetails();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }
        }
    </script>
    <%--Save Service Subject Details--%>
    <script type="text/javascript">
        function SaveSubDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($("[id*=ddlLangs]").val() != '' && $("[id*=ddlStudiedUpto]").val() != '') {
                    var text = $("[id*=ddlLangs] option:selected").text();
                    var langId = $("[id*=ddlLangs]").val();
                    var studId = $("[id*=ddlStudiedUpto]").val();
                    var stud = $("[id*=ddlStudiedUpto] option:selected").text();

                    var parameters = '{"staffLangServiceId": "","staffId": "' + $("[id*=hdnStaffId]").val() + '","language": "' + langId + '","studied": "' + studId + '","userId": "' + $("[id*=hdnUserId ]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateStaffLanguageDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveSubDetailSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
                else {
                    AlertMessage('info', "Please select Language and StudiedUtpo");
                }
            }
            else {
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }

        function OnSaveSubDetailSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                CancelSubDetails();
                GetSubjectDetails();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update Failed');
            }
        }

        function AppendSub(lang, studupto, subIndex, row) {
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteSub('";
                danchorEnd = "');\">Delete</a>";
            }

            var ehref = eanchor + subIndex + eanchorEnd;
            var dhref = danchor + subIndex + danchorEnd;
            var row = "<tr class=\"even\"><td>" + row + "</td><td>" + lang + "</td><td>" + studupto + "</td><td class=\"deleteacc delete-links\">" + dhref + "</td></tr>";
            $("[id*=tblSubDetais] tbody").append(row);
        }
        function DeleteSub(id) {

            var parameters = '{"staffLangServiceId": "' + id + '","userId": "' + $("[id*=hdnUserId ]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteSubDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteSubSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnDeleteSubSuccess(response) {
            if (response.d == "Delete") {
                AlertMessage('success', 'Deleted');
                GetSubjectDetails();
            }
            else if (response.d == "Failed") {
                AlertMessage('fail', 'Delete Failed');
            }
        }
     
    </script>
    <%--Save Service Lang Known Details--%>
    <script type="text/javascript">
        function SaveLangDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($("[id*=ddlLanguagesKnown]").val() != '') {
                    var text = $("[id*=ddlLanguagesKnown] option:selected").text();
                    var langId = $("[id*=ddlLanguagesKnown]").val();
                    var lang = text;
                    var read = $("[id*=ddlRead] option:selected").text();
                    if (read == "Yes")
                        read = "True";
                    else
                        read = "False";
                    var write = $("[id*=ddlWrite] option:selected").text();
                    if (write == "Yes")
                        write = "True";
                    else
                        write = "False";
                    var speak = $("[id*=ddlSpeak] option:selected").text();
                    if (speak == "Yes")
                        speak = "True";
                    else
                        speak = "False";
                    langIndex = parseInt(langIndex) + 1;


                    var parameters = '{"staffLangKnownId": "","staffId": "' + $("[id*=hdnStaffId]").val() + '","language": "' + $("[id*=ddlLanguagesKnown]").val() + '","isRead": "' + read + '","isWrite": "' + write + '","isSpeak": "' + speak + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateLangKnown",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnUpdateLangKnownSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });


                }
                else
                    AlertMessage('info', "Please select Language Known");
            }

            else {
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }

        function OnUpdateLangKnownSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                CancelLangDetails();
                GetLangKnownDetails();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }
        }

        function GetLangKnownDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetLangKnown",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnLangKnownSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnLangKnownSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("LangKnownDetails");
            $("[id*=tblLangDetails] tbody").children().remove();

            if (menus.length > 0) {
                $.each(menus, function () {
                    var read = '';
                    var write = '';
                    var speak = '';
                    if ($(this).find("IsRead").text() == "true")
                        read = "Yes";
                    else
                        read = "No";

                    if ($(this).find("IsWrite").text() == "true")
                        write = "Yes";
                    else
                        write = "No";

                    if ($(this).find("IsSpeek").text() == "true")
                        speak = "Yes";
                    else
                        speak = "No";

                    AppendLangKnown($(this).find("LanguageName").text(), read, write, speak, $(this).find("StaffLangKnownId").text(), $(this).find("RowNumber").text());
                });
            }
            else {
                var row = "<tr class=\"even\"><td></td><td></td><td>No records found</td><td></td><td></td><td></td></tr>";
                $("[id*=tblLangDetails] tbody").append(row);
            }
        }
        function AppendLangKnown(lang, read, write, speak, langIndex, row) {
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';

            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteLangKwn('";
                danchorEnd = "');\">Delete</a>";
            }

            var ehref = eanchor + langIndex + eanchorEnd;
            var dhref = danchor + langIndex + danchorEnd;

            var row = "<tr class=\"even\"><td>" + row + "</td><td>" + lang + "</td><td>" + read + "</td><td>" + write + "</td><td>" + speak + "</td><td class=\"deleteacc delete-links\">" + dhref + "</td></tr>";
            $("[id*=tblLangDetails] tbody").append(row);
        }
        function DeleteLangKwn(id) {
            var parameters = '{"staffLangKnownId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteLangKnownDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteLangKnownSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteLangKnownSuccess(response) {
            if (response.d == "Delete") {
                AlertMessage('success', 'Deleted');
                GetLangKnownDetails();
            }
            else if (response.d == "Failed") {
                AlertMessage('fail', 'Delete Failed');
            }
        }
    </script>
    <%--Save Career Details--%>
    <script type="text/javascript">
        function SaveCareerDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($("[id*=txtregDate]").val() != '' && $("[id*=txtregOrder]").val() != '' && $("[id*=ddlregDesignation]").val() != '') {
                    var parameters = '{"staffCareerServiceId": "' + $("[id*=hdnStaffCareerId]").val() + '","staffId": "' + $("[id*=hdnStaffId]").val() + '","orderNo": "' + $("[id*=txtregOrder]").val() + '","careerServiceDate": "' + $("[id*=txtregDate]").val() + '","placeofwork": "' + $("[id*=ddlPlaceofWork1]").val() + '","designationId": "' + $("[id*=ddlregDesignation]").val() + '","probationPeriod": "' + $("[id*=txtregProbPeriod]").val() + '","completionOrderNo": "' + $("[id*=txtregCompOrder]").val() + '","completionDate": "' + $("[id*=txtregCompDate]").val() + '","acdFromDate": "' + $("[id*=txtregFrom]").val() + '","acdToDate": "' + $("[id*=txtregTo]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '","description": "' + $("[id*=txtDescription]").val() + '","salarydescription": "' + $("[id*=txtSalaryDescription]").val() + '","building": "' + $("[id*=ddlBuilding]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateCareerDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveCareerSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
                else {
                    AlertMessage('info', 'Please enter Date, Order No and Designation');
                }
            }
            else {
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveCareerSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                $("[id*=hdnStaffCareerId]").val("");
                GetCareerDetails();
                GetPersonalDetails();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }
        }
    </script>
    <%--Save Invigilation Details--%>
    <script type="text/javascript">
        function SaveInvDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {

                if ($("[id*=txtInvYear]").val() != '' && $("[id*=txtInvSchool]").val() != '') {
                    var parameters = '{"staffExtInvId": "' + $("[id*=StaffExtInvId]").val() + '","staffId": "' + $("[id*=hdnStaffId]").val() + '","year": "' + $("[id*=txtInvYear]").val() + '","schoolName": "' + $("[id*=txtInvSchool]").val() + '","place": "' + $("[id*=txtInvPlace]").val() + '","invId": "' + $("[id*=ddlInvTypes]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateInvDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveInvigilationSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
                else {
                    AlertMessage('info', "Please enter year and school details");
                }

            }
            else {
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveInvigilationSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                CancelInvDetails();
                GetInvDetails();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }
        }
    </script>
    <%--Save Resign Details--%>
    <script type="text/javascript">
        function SaveResignDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($("[id*=txtResYear]").val() != '' && $("[id*=txtResignDate]").val() != '') {
                    var parameters = '{"staffResignId": "' + $("[id*=hdnResignId]").val() + '","staffId": "' + $("[id*=hdnStaffId]").val() + '","year": "' + $("[id*=txtResYear]").val() + '","reason": "' + $("[id*=txtResReason]").val() + '","certDate": "' + $("[id*=txtResCert]").val() + '","resDate": "' + $("[id*=txtResignDate]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateResignDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveResignSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
                else {
                    AlertMessage('info', "Please enter year and resigned date");
                }
            }
            else {
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveResignSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                changeAccordion(6);
                CancelResignDetails();
                GetResignDetails();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }
        }
    </script>
    <%--Save Bank Details--%>
    <script type="text/javascript">
        function SaveBankDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","bankStatus": "' + $('input:radio[name=brd1]:checked').val() + '","bankName": "' + $("[id*=txtBankName]").val() + '","bankBranchCode": "' + $("[id*=txtBranch]").val() + '","accNo": "' + $("[id*=txtAccNo]").val() + '","epfCode": "' + $("[id*=txtEPF]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateBankDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveBankSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveBankSuccess(response) {
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");

                changeAccordion(7);

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }
        }
    </script>
    <%--Save Leave Details--%>
    <script type="text/javascript">
        function ShowInstitution() {
            if (document.getElementById('rbtnInsYes').checked == true) {
                $("#dvInstitution").slideDown("slow");
            }
            if (document.getElementById('rbtnInsNo').checked == true) {
                $("#dvInstitution").slideUp("slow");
            }
        }
        function SaveLeaveDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    val = $("[id*=hdnStaffLeaveId]").val();
                    var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","acdYear": "' + $("[id*=hdnAcd]").val() + '","leaveId": "' + $("[id*=ddlLeave]").val() + '","reason": "' + $("[id*=txtLeaveReason]").val() + '","from": "' + $("[id*=txtFrom]").val() + '","to": "' + $("[id*=txtTo]").val() + '","noOfLeave": "' + $("[id*=txtNop]").val() + '","fileName":  "' + $("[id*=leaveFile]").val().replace(/C:\\fakepath\\/i, '') + '","filePath": "no file path","userId": "' + $("[id*=hdnUserId]").val() + '","staffLeaveId": "' + val + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateLeaveDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveLeaveSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveLeaveSuccess(response) {
            if (response.d != '') {
                AlertMessage('success', "Updated");
                $("[id*=hdnStaffLeaveId]").val('');
                GetLeaveDetails();
                changeAccordion(8);
                CancelLeaveDetails();
                if (response.d != '-1') {
                    formdata.append("FileName", response.d);
                    if (formdata) {
                        $.ajax({
                            url: "../Staffs/StaffInfo.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                                formdata = new FormData();
                                //alert(res)
                            }
                        });
                    }
                }
            }
            else if (response.d == '') {
                AlertMessage('fail', "Update");
                CancelLeaveDetails();
            }
        }
        function GetLeaveDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","academicId": "' + $("[id*=hdnAcd]").val() + '","staffLeaveId": ""}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetLeaveDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetLeaveSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetLeaveSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Leave");
            var row = $("[id*=dgLeave] tr:last-child").clone(true);
            $("[id*=dgLeave] tr").not($("[id*=dgLeave] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditLeave('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteLeave('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffLeaveId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffLeaveId").text() + danchorEnd;
                    row.addClass("even");
                    var cls = $(this).find("StatusName").text().toLowerCase();
                    $("td", row).eq(0).html($(this).find("AcademicYearFormat").text());
                    $("td", row).eq(1).html($(this).find("LeaveName").text());
                    $("td", row).eq(2).html($(this).find("Reason").text());
                    $("td", row).eq(3).html($(this).find("FROMFORMAT").text());
                    $("td", row).eq(4).html($(this).find("TOFORMAT").text());
                    $("td", row).eq(5).html($(this).find("NOP").text());
                    $("td", row).eq(6).html($(this).find("FileName").text());
                    $("td", row).eq(7).html("<span class=\"" + cls + "\">" + $(this).find("StatusName").text() + "</span>");
                    $("td", row).eq(8).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgLeave]").append(row);
                    row = $("[id*=dgLeave] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('No records found');
                $("td", row).eq(5).html('');
                $("td", row).eq(6).html('');
                $("td", row).eq(7).html('');
                $("td", row).eq(8).html('');
                $("[id*=dgLeave]").append(row);
                row = $("[id*=dgLeave] tr:last-child").clone(true);
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
        }
        function EditLeave(id) {

            var parameters = '{"staffId": "' + "" + '","academicId": "' + "" + '","staffLeaveId": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetLeaveDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditLeaveSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnEditLeaveSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Leave");
            $.each(menus, function () {

                $("[id*=hdnStaffLeaveId]").val($(this).find("StaffLeaveId").text());
                $("[id*=txtAcademic]").val($(this).find("AcademicYearFormat").text());
                $("[id*=ddlLeave]").val($(this).find("LeaveId").text());
                $("[id*=txtLeaveReason]").val($(this).find("Reason").text());
                $("[id*=txtFrom]").val($(this).find("FROMFORMAT").text());
                $("[id*=txtTo]").val($(this).find("TOFORMAT").text());
                $("[id*=txtNop]").val($(this).find("NOP").text());
            });
        }
        function DeleteLeave(id) {
            var parameters = '{"staffLeaveId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteLeaveDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteLeaveSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteLeaveSuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetLeaveDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
        
    </script>
    <%--Save Remark Details--%>
    <script type="text/javascript">
        function SaveRemarkDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","remDate": "' + $("[id*=txtRemDate]").val() + '","title": "' + $("[id*=txtRemTitle]").val() + '","reason": "' + $("[id*=txtRemReason]").val() + '","fileName": "' + $("[id*=fileRem]").val().replace(/C:\\fakepath\\/i, '') + '","filePath": "no file path","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateRemarkDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveRemarkSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveRemarkSuccess(response) {
            if (response.d != '') {
                AlertMessage('success', "Updated");
                GetRemarkDetails();
                changeAccordion(9);
                CancelRemarkDetails();
                if (response.d != '-1') {

                    formdata.append("FileName", response.d);
                    if (formdata) {
                        $.ajax({
                            url: "../Staffs/StaffInfo.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                                formdata = new FormData();
                                //alert(res)
                            }
                        });
                    }
                }
            }
            else if (response.d == '') {
                AlertMessage('fail', "Update");
            }
        }
        function GetRemarkDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetRemarkDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetRemarkSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetRemarkSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Remark");
            var row = $("[id*=dgRemark] tr:last-child").clone(true);
            $("[id*=dgRemark] tr").not($("[id*=dgRemark] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditRemark('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteRemark('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffRemarkId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffRemarkId").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RemarkDateFormat").text());
                    $("td", row).eq(1).html($(this).find("RemarkTitle").text());
                    $("td", row).eq(2).html($(this).find("Reason").text());
                   if ($(this).find("FileName").text() != "") {
                        $("td", row).eq(3).html("<a target='_blank' href=../Staffs/Uploads/Remarks/" + $(this).find("FileName").text() + ">" + $(this).find("FileName").text() + "</a>").addClass("download-links");
                    }
                    else {
                        $("td", row).eq(3).html($(this).find("FileName").text()).removeClass("download-links"); ;
                    }
                    $("td", row).eq(4).html(dhref).addClass("deleteacc");
                    $("[id*=dgRemark]").append(row);
                    row = $("[id*=dgRemark] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('No records found');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('');

                $("[id*=dgRemark]").append(row);
                row = $("[id*=dgRemark] tr:last-child").clone(true);
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
        }
        function DeleteRemark(id) {
            var parameters = '{"staffRemarkId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteRemarkDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteRemarkSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteRemarkSuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetRemarkDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
    </script>
    <%--Save Punishment Details--%>
    <script type="text/javascript">
        function SavePunishmentDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","punishDate": "' + $("[id*=txtPunishDate]").val() + '","title": "' + $("[id*=txtPunishTitle]").val() + '","reason": "' + $("[id*=txtPunishReason]").val() + '","fileName":"' + $("[id*=filePunishment]").val().replace(/C:\\fakepath\\/i, '') + '","filePath": "no file path","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdatePunishementDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSavePunishSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSavePunishSuccess(response) {
            if (response.d != '') {
                AlertMessage('success', "Updated");
                changeAccordion(10);
                GetPunishDetails();
                CancelPunishmentDetails();
                if (response.d != '-1') {
                    formdata.append("FileName", response.d);
                    if (formdata) {
                        $.ajax({
                            url: "../Staffs/StaffInfo.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                                formdata = new FormData();
                                //alert(res)
                            }
                        });
                    }
                }
            }
            else {
                AlertMessage('fail', "Update");
            }
        }
        function GetPunishDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/GetPunishDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetPunishSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetPunishSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Punish");
            var row = $("[id*=dgPunish] tr:last-child").clone(true);
            $("[id*=dgPunish] tr").not($("[id*=dgPunish] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditPunish('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeletePunish('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffPunishId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffPunishId").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("PunishDateFormat").text());
                    $("td", row).eq(1).html($(this).find("PunishTitle").text());
                    $("td", row).eq(2).html($(this).find("PunishReason").text());
                    $("td", row).eq(3).html($(this).find("FileName").text());
                    $("td", row).eq(4).html(dhref).addClass("deleteacc");
                    $("[id*=dgPunish]").append(row);
                    row = $("[id*=dgPunish] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('No records found');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('');

                $("[id*=dgPunish]").append(row);
                row = $("[id*=dgPunish] tr:last-child").clone(true);
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
        }
        function DeletePunish(id) {
            var parameters = '{"staffPunishId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeletePunishDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeletePunishSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeletePunishSuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetPunishDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
    </script>
    <%--Save Retirement Details--%>
    <script type="text/javascript">
        function SaveRetirementDetails() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {
                    var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","retDate": "' + $("[id*=txtRetireDate]").val() + '","title": "' + $("[id*=txtRetireTitle]").val() + '","reason": "' + $("[id*=txtRetireReason]").val() + '","fileName":"' + $("[id*=fileRetire]").val().replace(/C:\\fakepath\\/i, '') + '","filePath": "no file path","userId": "' + $("[id*=hdnUserId]").val() + '"}';
                    CancelRetirementDetails();
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffInfo.aspx/UpdateRetirementDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveRetirementSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveRetirementSuccess(response) {
            if (response.d != '') {
                AlertMessage('success', "Updated");
                GetRetireDetails();
                if (response.d != '-1') {
                    formdata.append("FileName", response.d);
                    if (formdata) {
                        $.ajax({
                            url: "../Staffs/StaffInfo.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                                formdata = new FormData();
                                //alert(res)
                            }
                        });
                    }
                }

            }
            else {
                AlertMessage('fail', "Update");
            }
        }

        function DeleteRetire(id) {
            var parameters = '{"staffRetireId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteRetireDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteRetireSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteRetireSuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetRetireDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
    </script>
    <%--Check for contact details--%><%--    <script type="text/javascript">
        function CheckAll() {
            if ($("[id*=chkContact]").is(':checked')) {
                $("[id*=txtContactAddress]").val($("[id*=txtPermanentAddress]").val());
            }
            else {
                $("[id*=txtContactAddress]").val('');
            }
        }
    </script>--%><%--Cancel Control--%>
    <script type="text/javascript">
        function CancelPersonalPanel() {
            $("[id*=txtStaffName]").val('');
            $("[id*=txtShortName]").val('');
            $("[name*=rb1]")[0].checked = true;
            $("[id*=datepicker]").val('');
            $("[id*=txtPlaceOfBirth]").val('');
            $("[id*=txtMotherTongue]").val('');
            $("[id*=txtNationality]").val('');
            $("[id*=ddlReligion]").val('');
            $("[id*=ddlCommunity]").val('');
            $("[id*=txtPermanentAddress]").val('');
            $("[id*=txtContactAddress]").val('');
            $("[id*=txtEmailAddress]").val('');
            $("[id*=txtMobileNo]").val('');
            $("[id*=dpDownMaraital]").val('');
            $("[id*=txtPhoneNo]").val('');
            $("[id*=txtPanCard]").val('');
            $("[id*=txtAadhaar]").val('');
            $("[id*=txtDOR]").val('');
            $("[id*=txtBrothers]").val('');
            $("[id*=txtSisters]").val('');
            $("[id*=chkContact]").attr('checked', false);
            $('#aspnetForm').validate().resetForm();
            // $("[id*=hdnStaffId]").val('');
        }

        function CancelAcademicDetails() {
            $("[id*=txtCourseCom]").val('');
            $("[id*=txtBoard]").val('');
            $("[id*=txtYOC]").val('');
            $("[id*=ddlDepartment]").val('');
            $("[id*=ddlDepartment2]").val('');
            $("[id*=txtCertNo]").val('');
            $("[id*=txtSubDate]").val('');
            $("[id*=txtRetDate]").val('');
            $("[id*=ddlType]").val('');
            $("[id*=fileSC]").val('');
            $("[id*=hdnAcdDetails]").val('');
            $('#aspnetForm').validate().resetForm();
        }

        function CancelFamily() {
            $("[id*=ddRelations]").val('');
            $("[id*=txtName]").val('');
            $("[id*=txtFamDOB]").val('');
            $("[id*=ddlSex]").val('');
            $("[id*=txtQualification]").val('');
            $("[id*=txtOccupation]").val('');
            $("[id*=txtAddress]").val('');
            $("[id*=txtContactNo]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelMedicalDetails() {

            $("[id*=ddlBloodGroup]").val('');
            $("[id*=txtDisease]").val('');
            $("[id*=txtHeight]").val('');
            $("[id*=txtWeight]").val('');
            $("[id*=txtEmergency]").val('');
            $("[id*=txtDocName]").val('');
            $("[id*=txtAddress]").val('');
            $("[id*=txtDocPhoneNo]").val('');
            $("[id*=txtIdMark1]").val('');
            $("[id*=txtIdMark2]").val('');
            $("[id*=radio1]").attr('checked', 'checked');
            $(".ishandicap").hide();
            $('#aspnetForm').validate().resetForm();
        }

        function CancelBankDetails() {
            $("[id*=txtBankName]").val('');
            $("[id*=txtBranch]").val('');
            $("[id*=txtAccNo]").val('');
            $("[id*=txtEPF]").val('');
            $('#aspnetForm').validate().resetForm();
        }

        function CancelLeaveDetails() {
            $("[id*=ddlLeave]").val('');
            $("[id*=txtLeaveReason]").val('');
            $("[id*=txtFrom]").val('');
            $("[id*=txtTo]").val('');
            $("[id*=txtNop]").val('');
            $("[id*=leaveFile]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelRemarkDetails() {
            $("[id*=txtRemDate]").val('');
            $("[id*=txtRemTitle]").val('');
            $("[id*=txtRemReason]").val('');
            $("[id*=filePunishment]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function RelativeDetailsClear() {
            $("[id*=ddlStaff1]").val('');
            $("[id*=ddlRelationship1]").val('');

            $('#aspnetForm').validate().resetForm();
        }

        function CancelPunishmentDetails() {

            $("[id*=txtPunishDate]").val('');
            $("[id*=txtPunishTitle]").val('');
            $("[id*=txtPunishReason]").val('');
            $("[id*=txtPunishReason]").val('');
            $("[id*=filePunishment]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelRetirementDetails() {
            $("[id*=txtRetireDate]").val('');
            $("[id*=txtRetireTitle]").val('');
            $("[id*=txtRetireReason]").val('');
            $("[id*=fileRetire]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelCourseDetails() {
            $("[id*=txtCourseUg]").val('');
            $("[id*=txtUgBoard]").val('');
            $("[id*=ddlMainCourse]").val('');
            $("[id*=txtUgYOC]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelNomineeDetails() {
            $("[id*=txtNomineeName]").val('');
            $("[id*=txtNomAddr]").val('');
            $("[id*=txtNomDOB]").val('');
            $("[id*=ddlNomSex]").val('');
            $("[id*=txtShare]").val('');
            $("[id*=ddlNominees]").val('');
            $("[id*=txtNomContact]").val('');
            $("[id*=ddlStaffRelationship]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelServiceAppDetails() {
            //$("[id*=txtDOJ]").val('');
            $("[id*=ddlDesignation]").val('');
            $("[id*=ddlServiceDepartment]").val('');
            $("[id*=ddlPlaceofWork]").val('');
            $("[id*=ddlSubject]").val('');
            $("[id*=ddlClass]").val('');
            $("[id*=ddlModes]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelCareerDetails() {
            $("[id*=txtregDate]").val('');
            $("[id*=txtregOrder]").val('');
            $("[id*=txtPlaceofwork]").val('');
            $("[id*=txtDescription]").val('');
            $("[id*=txtSalaryDescription]").val('');
            $("[id*=ddlregDesignation]").val('');
            $("[id*=txtregProbPeriod]").val('');
            $("[id*=txtregCompOrder]").val('');
            $("[id*=txtregCompDate]").val('');
            $("[id*=txtregFrom]").val('');
            $("[id*=txtregTo]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelInvDetails() {
            $("[id*=txtInvYear]").val('');
            $("[id*=txtInvSchool]").val('');
            $("[id*=txtInvPlace]").val('');
            $("[id*=ddlInvTypes]").val('');
            $("[id*=hdnStaffExtInvId]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelResignDetails() {
            $("[id*=txtResYear]").val('');
            $("[id*=txtResReason]").val('');
            $("[id*=txtResCert]").val('');
            $("[id*=txtResignDate]").val('');
            $("[id*=hdnResignId]").val('');
        }

        function CancelMedRemarks() {
            $("[id*=txtDateRem]").val('');
            $("[id*=txtReason]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelSubDetails() {
            $("[id*=ddlLangs]").val('');
            $("[id*=ddlStudiedUpto]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelLangDetails() {
            $("[id*=ddlLanguagesKnown]").val('');
            $("[id*=ddlRead]").val('');
            $("[id*=ddlWrite]").val('');
            $("[id*=ddlSpeak]").val('');
            $('#aspnetForm').validate().resetForm();
        }

    </script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="ContentHead2" ContentPlaceHolderID="head2" runat="server">
    <!--Autocomplete script starts here -->
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <!--Autocomplete script ends here -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Add/Edit Staff Information
                <div id="jSuccess-info">
                    Emp Code :
                    <asp:Label ID="lblEmpCode" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    Staff Name :
                    <asp:Label ID="lblStaffName" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Designation:
                    <asp:Label ID="lblDesg" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Present
                    Status :
                    <asp:Label ID="lblStatus" runat="server"></asp:Label></div>
            </h2>
            <asp:HiddenField ID="hdnStaffId" runat="server" />
            <asp:HiddenField ID="hdnUserId" runat="server" />
            <asp:HiddenField ID="hdnAcd" runat="server" />
            <div class="clear">
            </div>
            <div class="block1">
                <div class="box sidemenu" style="height: auto;">
                    <div class="block john-accord content-wrapper4">
                        <ul class="section menu">
                            <li><a class="menuitem">Personal Details</a>
                                <ul class="johnmenu" style="height: 680px;">
                                    <li>
                                        <div class="frm-block" style="height: 680px;">
                                            <div style="float: right; margin-top: 5px;">
                                                <img id="img_prev" src="../img/photo.jpg" alt="Profile Photo" width="114" height="114" />
                                            </div>
                                            <div style="float: left; width: 80%;">
                                                <table class="form">
                                                    <tr>
                                                        <td width="20%" class="col1">
                                                            <label>
                                                                Employee Code :</label>
                                                        </td>
                                                        <td width="26%" class="col2">
                                                            <asp:TextBox ID="txtEmpCode" runat="server" ReadOnly="true"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <span class="col1"><span style="color: Red">*</span>
                                                                <label>
                                                                    Name :</label>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtStaffName" CssClass="jsrequired" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%" class="col1">
                                                            <label>
                                                                Staff Short Name :</label>
                                                        </td>
                                                        <td width="26%" class="col2">
                                                            <asp:TextBox ID="txtShortName"  runat="server"></asp:TextBox>
                                                        </td>
                                                        <td width="20%" class="col1">
                                                            <label>
                                                                <span style="color: Red">*</span> Date of Birth :</label>
                                                        </td>
                                                        <td width="26%" class="col2">
                                                            <input id="datepicker" type="text" class="jsrequired" onblur="setAltDate()" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="14%" class="col2">
                                                            <span class="col1">
                                                                <label>
                                                                    Sex :</label>
                                                            </span>
                                                        </td>
                                                        <td class="col2">
                                                            <label>
                                                                <input type="radio" name="rb1" id="rbtnMale" value="M" checked="checked" />
                                                                Male</label>
                                                            <label>
                                                                <input type="radio" name="rb1" id="rbtnFemale" value="F" />
                                                                Female</label>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Mother Tongue :
                                                            </label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtMotherTongue" CssClass="" runat="server"></asp:TextBox>
                                                            <%--<asp:TextBox ID="txtDOB" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>--%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Place of Birth :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtPlaceOfBirth" CssClass="" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Religion :</label>
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlReligion" CssClass="" runat="server" AppendDataBoundItems="True">
                                                                <asp:ListItem Selected="True" Value="">----Select---</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Nationality :</label>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="Text1" value="" style="display: none" />
                                                            <asp:TextBox ID="txtNationality" CssClass="" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Caste :</label>
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlCaste" CssClass="" runat="server" AppendDataBoundItems="True">
                                                                <asp:ListItem Selected="True" Value="">----Select---</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Community :</label>
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlCommunity" CssClass="" runat="server" AppendDataBoundItems="True">
                                                                <asp:ListItem Selected="True" Value="">----Select---</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Marital Status :</label>
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="dpDownMaraital" runat="server">
                                                                <asp:ListItem Value="" Text="----Select---" Selected="True"></asp:ListItem>
                                                                <asp:ListItem Value="Single" Text="Single"></asp:ListItem>
                                                                <asp:ListItem Value="Married" Text="Married"></asp:ListItem>
                                                                <asp:ListItem Value="Widowed" Text="Widow"></asp:ListItem>
                                                                <asp:ListItem Value="Divorced" Text="Divorced"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top">
                                                            <label>
                                                                Permanent Address :</label>
                                                        </td>
                                                        <td valign="top">
                                                            <asp:TextBox ID="txtPermanentAddress" TextMode="MultiLine" runat="server" Columns="30"
                                                                Rows="5" onchange="CheckAll();"></asp:TextBox>
                                                        </td>
                                                        <td valign="top">
                                                            <label>
                                                                Contact Address :</label>
                                                        </td>
                                                        <td valign="top">
                                                            <asp:TextBox ID="txtContactAddress" TextMode="MultiLine" runat="server" Columns="30"
                                                                Rows="5" onchange="CheckAll();"></asp:TextBox>
                                                            <br />
                                                            <label>
                                                                <input type="checkbox" name="chkContact" id="chkContact" value="contact" onchange="CheckAll();" />
                                                                <span class="sameas">Same as Permanent Address</span></label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Email Id :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtEmailAddress" CssClass="email" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Phone No :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtPhoneNo" CssClass="numbersonly" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Pan Card No :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtPanCard" CssClass="" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                <span style="color: Red">*</span> Mobile No :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtMobileNo" CssClass="jsrequired numbersonly" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Aadhaar No :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtAadhaar" CssClass="" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Date Of Retirement :</label>
                                                        </td>
                                                        <td>
                                                            <input name="text" type="text" id="txtDOR" size="30" readonly="readonly" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Upload Image :</label>
                                                        </td>
                                                        <td>
                                                            <input type='file' style="width: 180px;" id="userPhoto" onchange="readURL(this);" />
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Present Status :&nbsp;</label>
                                                        </td>
                                                        <td>
                                                            <%--<asp:TextBox ID="txtDOR"  runat="server"></asp:TextBox>--%>
                                                            <asp:DropDownList ID="ddlStatus" runat="server">
                                                                <asp:ListItem Value="" Text="----Select---" Selected="True"></asp:ListItem>
                                                                <asp:ListItem>Active</asp:ListItem>
                                                                <asp:ListItem>Discontinued</asp:ListItem>
                                                                <asp:ListItem>Resigned</asp:ListItem>
                                                                <asp:ListItem>Suspended</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                Ration Card :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtRationCardNo" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Smart Card :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtSmartCardNo" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                File No :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtFileNo" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <label>
                                                                Locker No :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtLockerNo" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label>
                                                                No. of Brothers :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBrothers" runat="server"></asp:TextBox>
                                                        </td>
                                                         <td>
                                                            <label>
                                                                No. of Sisters :</label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtSisters" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40">
                                                        </td>
                                                        <td colspan="3">
                                                            <br />
                                                            <button id="btnPersonalSubmit" type="button" class="btn-icon btn-orange btn-saving"
                                                                onclick="SavePersonalDetails();">
                                                                <span></span>
                                                                <div id="spSubmit">
                                                                    Save</div>
                                                            </button>
                                                            <button id="btnPersonalCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                runat="server" onclick="return CancelPersonalPanel();">
                                                                <span></span>Cancel</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Academic Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <asp:HiddenField ID="hdnAcdDetails" runat="server" />
                                            <table class="form">
                                                <tr>
                                                    <td class="col2">
                                                        <label>
                                                            Course Completed :</label>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Board/University :</label>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Year Of Completion :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Main Subject :</label>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="211" class="col2">
                                                        <label>
                                                        </label>
                                                        <input type="text" id="txtCourseCom" class="jsrequired" />
                                                    </td>
                                                    <td width="247" class="col2">
                                                        <label>
                                                        </label>
                                                        <asp:TextBox ID="txtBoard" runat="server" CssClass="jsrequired"></asp:TextBox>
                                                    </td>
                                                    <td width="201" class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <asp:DropDownList ID="ddlYOC" runat="server">
                                                            <asp:ListItem Selected="True" Value="">----Select---</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="214" class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <asp:DropDownList ID="ddlDepartment" CssClass="jsrequired" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Ancillary Subject :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Certificate No :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2" style="vertical-align: middle;">
                                                        <span class="col1">
                                                            <label>
                                                                Submitted Date :</label>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="col2"><span class="col1">
                                                            <label>
                                                                Returned Date :</label>
                                                        </span></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <asp:DropDownList ID="ddlDepartment2" CssClass="" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtCertNo" />
                                                    </td>
                                                    <td class="col2" style="vertical-align: middle;">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtSubDate" class="dateNL date-picker" />
                                                    </td>
                                                    <td>
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtRetDate" class="dateNL date-picker" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Type :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Scanned Copy :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        &nbsp;
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col2">
                                                        <select id="ddlType">
                                                            <option value="2">Academic</option>
                                                            <option value="1">Proffessional</option>
                                                         
                                                        </select>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                <input type="file" id="fileSC" onchange="readAcdURL(this);" />
                                                            </label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <button id="btnAcdSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveAcademicDetails();">
                                                            <span></span>
                                                            <div id="spAcdSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnAcdCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                            onclick="return CancelAcademicDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgAcdDetails" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="SlNo" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="CourseCompleted" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Course Completed" SortExpression="CourseCompleted">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Board/University" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Board/University" SortExpression="Board/University">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="YearOfCompletion" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Year Of Completion" SortExpression="YearOfCompletion">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="MainSubject" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Main Subject" SortExpression="MainSubject">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="AncillarySubject" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Ancillary Subject" SortExpression="AncillarySubject">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="CertificateNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Certificate No" SortExpression="CertificateNo">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="SubmittedDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Submitted Date" SortExpression="SubmittedDate">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ReturnedDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Returned Date" SortExpression="ReturnedDate">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Type" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Type" SortExpression="Type">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ScannedCopy" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Scanned Copy" SortExpression="ScannedCopy">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Edit" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Delete" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td colspan="3">
                                                    </td>
                                                </tr>
                                            </table>
                                            <p>
                                            </p>
                                            <table class="form">
                                                <tr>
                                                    <td colspan="5" class="col1 formsubheading">
                                                        Course Undergoing
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1">
                                                        <label>
                                                            Course</label>
                                                    </td>
                                                    <td class="col1">
                                                        <label>
                                                            Board/Univ:</label>
                                                    </td>
                                                    <td class="col1">
                                                        <label>
                                                            Main Subject:</label>
                                                    </td>
                                                    <td class="col1">
                                                        <label>
                                                            Year Of Completion:</label>
                                                    </td>
                                                    <td width="12%" class="col1">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="26%" class="col2">
                                                        <asp:TextBox ID="txtCourseUg" CssClass="" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td class="col2" width="26%">
                                                        <asp:TextBox ID="txtUgBoard" runat="server" CssClass=""></asp:TextBox>
                                                    </td>
                                                    <td class="col2" width="10%">
                                                        <asp:DropDownList ID="ddlMainCourse" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="col2" width="26%">
                                                        <asp:DropDownList ID="ddlUgYOC" runat="server">
                                                            <asp:ListItem Selected="True" Value="">----Select---</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td align="left">
                                                        <button id="btnCourseUg" type="button" class="btn-icon btn-navy btn-save" onclick="SaveCourseUgDetails();">
                                                            <span></span>
                                                            <div id="spCourseSubmit" style="flot: left;">
                                                                Add</div>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="5">
                                                        <table class="display" id="tblCourseUg" style="width: 100%;">
                                                            <thead>
                                                                <tr>
                                                                    <th width="10%" class="sorting_mod">
                                                                        SL.No
                                                                    </th>
                                                                    <th width="12%" class="sorting_mod">
                                                                        Course
                                                                    </th>
                                                                    <th width="15%" class="sorting_mod">
                                                                        Board/Univ
                                                                    </th>
                                                                    <th width="15%" class="sorting_mod">
                                                                        Main Subject
                                                                    </th>
                                                                    <th width="15%" class="sorting_mod">
                                                                        Year Of Completion
                                                                    </th>
                                                                    <th width="9%" class="sorting_mod">
                                                                        Delete
                                                                    </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                        No Records found
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Family Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <table class="form">
                                                <tr>
                                                    <td class="col2">
                                                        <label>
                                                            Relationship :</label>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Name :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                DOB :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Sex :</label>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col2">
                                                        <label>
                                                        </label>
                                                        <asp:DropDownList ID="ddRelations" CssClass="jsrequired" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtName" class="jsrequired" />
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtFamDOB" class="dateNL date-picker" />
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <select id="ddlSex" class="jsrequired">
                                                            <option value='M'>Male</option>
                                                            <option value='F'>Female</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Qualification :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Occupation :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Address :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Contact No :</label>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input id="txtQualification" type="text" />
                                                    </td>
                                                    <td valign="top" class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input id="txtOccupation" type="text" />
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <textarea id="txtAddress" rows="5" cols="30" style="vertical-align: middle;"></textarea>
                                                    </td>
                                                    <td valign="top" class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtContactNo" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <button id="btnFamilySubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveFamilyDetails();">
                                                            <span></span>
                                                            <div id="spFamilySubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnFamilyCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                            runat="server" onclick="return CancelFamily();">
                                                            <span></span>Cancel</button>
                                                        <asp:HiddenField ID="hdnFamilyID" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgFamily" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="RelationshipId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Relationship Name" SortExpression="RelationshipId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Name" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Name" SortExpression="Name">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="DOB" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="DOB" SortExpression="DOB">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Sex" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Sex" SortExpression="Sex">
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
                                                                <asp:BoundField DataField="Address" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Address" SortExpression="Address">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ContactNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="ContactNo" SortExpression="ContactNo">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Edit" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Delete" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Nominee Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <table class="form">
                                                <tr>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Name :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Relationship:</label>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                DOB :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Sex :</label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtNomineeName" class="jsrequired" />
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                        </label>
                                                        <asp:DropDownList ID="ddlStaffRelationship" CssClass="jsrequired" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtNomDOB" class="dateNL date-picker" />
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <asp:DropDownList ID="ddlNomSex" CssClass="jsrequired" runat="server">
                                                            <asp:ListItem Text="--Select--" Value=""></asp:ListItem>
                                                            <asp:ListItem Text="Male" Value="M"></asp:ListItem>
                                                            <asp:ListItem Text="Female" Value="F"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Share % :</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Nominee Type :</label>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Address :</label>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Contact No :</label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" class="col2">
                                                        <span class="col1">
                                                            <label>
                                                            </label>
                                                        </span>
                                                        <input type="text" id="txtShare" class="numbersonly" />
                                                    </td>
                                                    <td valign="top" class="col2">
                                                        <select id="ddlNominees" class="jsrequired">
                                                            <option value='Family'>Family</option>
                                                            <option value='Guardian'>Guardian</option>
                                                        </select>
                                                    </td>
                                                    <td valign="top">
                                                        <textarea id="txtNomAddr" rows="5" cols="30" style="vertical-align: middle;"></textarea>
                                                    </td>
                                                    <td valign="top">
                                                        <input type="text" id="txtNomContact" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <button id="btnNominee" type="button" class="btn-icon btn-navy btn-update" onclick="SaveNomineeDetails();">
                                                            <span></span>
                                                            <div id="spNominee">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnCancelNominee" type="button" class="btn-icon btn-navy btn-cancel1"
                                                            runat="server" onclick="return CancelNomineeDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgNominee" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="Name" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Nominee Name" SortExpression="Name">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Address" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Address" SortExpression="Address">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Relationship" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Relationship" SortExpression="Relationship">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="DOB" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="DOB" SortExpression="DOB">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Sex" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Sex" SortExpression="Sex">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Share" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Share" SortExpression="Share">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Type" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Nominee Type" SortExpression="Type">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ContactNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Contact No" SortExpression="ContactNo">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Delete" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Medical Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <table class="form">
                                                <tr>
                                                    <td width="20%" class="col1">
                                                        <label>
                                                            Blood Group :</label>
                                                    </td>
                                                    <td width="28%" class="col2">
                                                        <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="jsrequired">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="19%" class="col2">
                                                        <label>
                                                            Disease /Allergy :</label>
                                                    </td>
                                                    <td width="33%" class="col2">
                                                        <input type="text" id="txtDisease" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Height (cm) :</label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtHeight" class="numericswithdecimals" />
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Weight (Kg) :
                                                        </label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtWeight" class="numericswithdecimals" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Emergency Phone No :
                                                        </label>
                                                    </td>
                                                    <td>
                                                        <span class="col2">
                                                            <input type="text" id="txtEmergency" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Family Doctor Name :</label>
                                                    </td>
                                                    <td>
                                                        <span class="col2">
                                                            <input type="text" id="txtDocName" class="" />
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr valign="top">
                                                    <td>
                                                        <label>
                                                            Address :</label>
                                                    </td>
                                                    <td>
                                                        <textarea name="textarea5" id="txtDrAddress" cols="30" rows="5"></textarea>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Doctor Phone No :</label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtDocPhoneNo" class="numbersonly" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Identification Marks :</label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtIdMark1" value="" />
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Physically Handicapped :</label>
                                                    </td>
                                                    <td>
                                                        <span class="col2">
                                                            <input type="radio" name="mrd1" value="N" checked="checked" id="radio1" />
                                                            No
                                                            <input type="radio" name="mrd1" value="Y" id="radio2" />
                                                            Yes </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtIdMark2" value="" />
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtHandicap" class="ishandicap" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <button id="btnMedicalSubmit" type="button" class="btn-icon btn-navy btn-update"
                                                            onclick="SaveMedicalDetails();">
                                                            <span></span>
                                                            <div id="spMedicalSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnMedicalCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                            runat="server" onclick="return CancelMedicalDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <table class="form">
                                                            <tr>
                                                                <td colspan="5" class="col1 formsubheading">
                                                                    Medical Remarks
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col2">
                                                                    <span class="col1">
                                                                        <label>
                                                                            Date :</label>
                                                                    </span>
                                                                </td>
                                                                <td class="col2">
                                                                    <label>
                                                                        Reason:
                                                                    </label>
                                                                </td>
                                                                <td class="col2">
                                                                    <span class="col1">
                                                                        <label>
                                                                            Upload Attachment:</label>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col2">
                                                                    <span class="col1">
                                                                        <label>
                                                                        </label>
                                                                    </span>
                                                                    <input type="text" id="txtDateRem" />
                                                                </td>
                                                                <td class="col2">
                                                                    <label>
                                                                    </label>
                                                                    <textarea rows="5" cols="30" id="txtReason" style="vertical-align: top;"></textarea>
                                                                </td>
                                                                <td class="col2">
                                                                    <span class="col1">
                                                                        <label>
                                                                        </label>
                                                                    </span>
                                                                    <input type="file" id="fileAttach" onchange="readMedRemURL(this)" />&nbsp;&nbsp;&nbsp;
                                                                </td>
                                                                <td class="col2">
                                                                    <span class="col1">
                                                                        <label>
                                                                        </label>
                                                                    </span>
                                                                    <button id="btnMedRemUpdate" type="button" class="btn-icon btn-navy btn-update" onclick="SaveMedicalRemarks();">
                                                                        <span></span>
                                                                        <div id="spMedRemarkUpdate">
                                                                            Update</div>
                                                                    </button>
                                                                    <button id="Button1" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                                        onclick="return CancelMedRemarks();">
                                                                        <span></span>Cancel</button>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="4">
                                                                    <table class="display" id="tblMedDetais" style="width: 100%;">
                                                                        <thead>
                                                                            <tr>
                                                                                <th width="18%" class="sorting_mod">
                                                                                    Sl No
                                                                                </th>
                                                                                <th width="11%" class="sorting_mod">
                                                                                    Date
                                                                                </th>
                                                                                <th width="25%" class="sorting_mod">
                                                                                    Reason
                                                                                </th>
                                                                                <th width="9%" class="sorting_mod">
                                                                                    Attachments
                                                                                </th>
                                                                                <th width="9%" class="sorting_mod">
                                                                                    Delete
                                                                                </th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                        </tbody>
                                                                    </table>
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
                            <li><a class="menuitem">Service Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <div class="formsubheading">
                                                Initial Appointments</div>
                                            <asp:HiddenField ID="hdnStaffAcdId" runat="server" />
                                            <table class="form">
                                                <tr>
                                                    <td class="col2">
                                                        <label>
                                                            Date of initial joining :</label>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Designation :</label>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Department :</label>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Place of work :
                                                        </label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="26%" class="col1">
                                                        <asp:TextBox ID="txtDOJ" runat="server" CssClass="jsrequired"></asp:TextBox>
                                                    </td>
                                                    <td width="28%" class="col2">
                                                        <asp:DropDownList ID="ddlDesignation" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="25%" class="col2">
                                                        <asp:DropDownList ID="ddlServiceDepartment" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="21%" class="col2">
                                                     <asp:DropDownList ID="ddlPlaceofWork" runat="server">
                                                        </asp:DropDownList>
                                                      <%--  <asp:TextBox ID="txtpow" runat="server">
                                                        </asp:TextBox>--%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Subject Handling :
                                                        </label>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Class Allocated :</label>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Mode :</label>
                                                    </td>
                                                    <td>
                                                      
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:DropDownList ID="ddlSubject" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlClass" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlModes" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" align="center">
                                                         <button id="btnServiceSubmit" type="button" class="btn-icon btn-navy btn-update"
                                                            onclick="SaveServiceAppDetails();">
                                                            <span></span>
                                                            <div id="spServiceSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnServiceCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                            runat="server" onclick="return CancelServiceAppDetails();">
                                                            <span></span>Cancel</button></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgService" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="AcademicYear" Visible="false" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="AcademicYear" SortExpression="AcademicYear">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                 <asp:BoundField DataField="DOJ" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Date of Intital Joining" SortExpression="DOJ">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Designation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Designation" SortExpression="Designation">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Department" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Department" SortExpression="Department">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="PlaceOfWork" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Place Of Work" SortExpression="PlaceOfWork">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="SubjectHandling" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Subject Handling" SortExpression="SubjectHandling">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ClassAllocated" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Class Allocated" SortExpression="ClassAllocated">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Mode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Mode" SortExpression="Mode">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Edit" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Delete" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div class="formsubheading">
                                                Subject Details</div>
                                            <table class="form">
                                                <tr>
                                                    <td width="55%" class="col1">
                                                        <label>
                                                            Subjects :
                                                        </label>
                                                        <asp:DropDownList ID="ddlLangs" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="col2" width="34%">
                                                        <label>
                                                            Studied Upto :</label>
                                                        <asp:DropDownList ID="ddlStudiedUpto" runat="server">
                                                            <asp:ListItem Selected="True" Value="">----Select---</asp:ListItem>
                                                            <asp:ListItem Selected="False" Value="Below X">Below X</asp:ListItem>
                                                            <asp:ListItem Selected="False" Value="X">X</asp:ListItem>
                                                            <asp:ListItem Selected="False" Value="XII">XII</asp:ListItem>
                                                            <asp:ListItem Selected="False" Value="UG">UG</asp:ListItem>
                                                            <asp:ListItem Selected="False" Value="PG">PG</asp:ListItem>
                                                            <asp:ListItem Selected="False" Value="Higher">Higher</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="11%" align="left">
                                                        <button id="btnSubDetails" type="button" class="btn-icon btn-navy btn-update" onclick="SaveSubDetails();">
                                                            <span></span>
                                                            <div id="spSubDetails">
                                                                Update</div>
                                                        </button>
                                                        <button id="Button2" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                            onclick="return CancelSubDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">
                                                        <table width="100%" class="display" id="tblSubDetais">
                                                            <thead>
                                                                <tr>
                                                                    <th width="18%" class="sorting_mod">
                                                                        Sl No
                                                                    </th>
                                                                    <th width="11%" class="sorting_mod">
                                                                        Subjects
                                                                    </th>
                                                                    <th width="25%" class="sorting_mod">
                                                                        Studied Upto
                                                                    </th>
                                                                    <th width="9%" class="sorting_mod">
                                                                        Delete
                                                                    </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr class="even">
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                        No Records Found
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <p>
                                            </p>
                                            <div class="formsubheading">
                                                Languages Known</div>
                                            <table class="form">
                                                <tr>
                                                    <td class="col2">
                                                        <span class="col1">
                                                            <label>
                                                                Languages</label>
                                                        </span>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Read:</label>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Write:</label>
                                                    </td>
                                                    <td class="col2">
                                                        <label>
                                                            Speak:</label>
                                                    </td>
                                                    <td width="10%">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="24%" class="col2">
                                                        <asp:DropDownList ID="ddlLanguagesKnown" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="23%" class="col2">
                                                        <label>
                                                        </label>
                                                        <asp:DropDownList ID="ddlRead" runat="server">
                                                            <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                                            <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="21%" class="col2">
                                                        <label>
                                                        </label>
                                                        <asp:DropDownList ID="ddlWrite" runat="server">
                                                            <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                                            <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="22%" class="col2">
                                                        <label>
                                                        </label>
                                                        <asp:DropDownList ID="ddlSpeak" runat="server">
                                                            <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                                            <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td style="float: left;">
                                                        <button id="btnLangKnown" type="button" class="btn-icon btn-navy btn-update" onclick="SaveLangDetails();">
                                                            <span></span>
                                                            <div id="spLangKnown">
                                                                Update</div>
                                                        </button>
                                                        <button id="Button3" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                            onclick="return CancelLangDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="5">
                                                        <table width="100%" class="display" id="tblLangDetails">
                                                            <thead>
                                                                <tr>
                                                                    <th width="12%" class="sorting_mod">
                                                                        Sl No
                                                                    </th>
                                                                    <th width="30%" class="sorting_mod">
                                                                        Language Known
                                                                    </th>
                                                                    <th width="11%" class="sorting_mod">
                                                                        Read
                                                                    </th>
                                                                    <th width="11%" class="sorting_mod">
                                                                        Write
                                                                    </th>
                                                                    <th width="11%" class="sorting_mod">
                                                                        Speak
                                                                    </th>
                                                                    <th width="9%" class="sorting_mod">
                                                                        Delete
                                                                    </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr class="even">
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                        No Records Found
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <p>
                                            </p>
                                            <div class="formsubheading">
                                                Regularization</div>
                                            <asp:HiddenField ID="hdnStaffCareerId" runat="server" />
                                            <table class="form">
                                                <tr>
                                                    <td width="20%" class="col1">
                                                        <label>
                                                            Date :
                                                        </label>
                                                    </td>
                                                    <td width="20%" class="col2">
                                                        <label>
                                                            Order No :</label>
                                                    </td>
                                                    <td width="19%" class="col2">
                                                        <label>
                                                            Designation :</label>
                                                    </td>
                                                    <td width="19%" class="col2">
                                                        <label>
                                                            Probation Period :
                                                        </label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="20%">
                                                        <asp:TextBox ID="txtregDate" runat="server" CssClass="jsrequired"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtregOrder" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlregDesignation" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtregProbPeriod" runat="server">
                                                        </asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Completion Order No :
                                                        </label>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Completion Date :</label>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Academic Year From :</label>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Academic Year To :</label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:TextBox ID="txtregCompOrder" runat="server">
                                                        </asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtregCompDate" runat="server">
                                                        </asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <select name="txtregFrom" id="txtregFrom">
                                                            <option value="">----Select---</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select name="txtregTo" id="txtregTo">
                                                            <option value="">----Select---</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                       <label>Place of Work :</label></td>
                                                        <td>
                                                        <label>Building :</label></td>
                                                    <td>
                                                        <label>Description :</label></td>
                                                    <td>
                                                        <label>Salary Description :</label></td>
                                                   
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <asp:DropDownList ID="ddlPlaceofWork1" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                     <td valign="top">
                                                        <asp:DropDownList ID="ddlBuilding" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                    <textarea rows="6" cols="40" id="txtDescription" data-maxsize="350" data-output="status1"
                                            wrap="virtual"></textarea><br />
                                        <div id="status1" class="status1">
                                        </div>

                                                      <%--      <asp:TextBox ID="txtDescription" TextMode="MultiLine" runat="server" Columns="40"
                                                                Rows="5" MaxLength="350"></asp:TextBox>--%>
                                                        <%--&nbsp;<br />
                                                            (Max. 350 Characters)</td>--%>
                                                    <td>
                                                       <textarea rows="6" cols="40" id="txtSalaryDescription" data-maxsize="250" data-output="status2"
                                            wrap="virtual"></textarea><br />
                                        <div id="status2" class="status2">
                                        </div>
                                                           <%-- <asp:TextBox ID="txtSalaryDescription" TextMode="MultiLine" runat="server" Columns="40"
                                                                Rows="5" MaxLength="250"></asp:TextBox>
                                                            <br />
                                                            (Max. 250 Characters)--%>
                                                            </td>
                                                   
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <button id="btnCareerSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveCareerDetails();">
                                                            <span></span>
                                                            <div id="spCareerSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnCareerCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                            runat="server" onclick="return CancelCareerDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgCareer" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="Date" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Date" SortExpression="Date">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="OrderNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Order No" SortExpression="OrderNo">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Designation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Designation" SortExpression="Designation">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Placeofwork" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Placeofwork" SortExpression="Placeofwork">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                  <asp:BoundField DataField="Building" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Building" SortExpression="Building">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Probation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Probation Period" SortExpression="Probation">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="CompletionDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Completion Date" SortExpression="CompletionDate">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="CompletionOrder" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Completion Order" SortExpression="CompletionOrder">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="From" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="From" SortExpression="From">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="To" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="To" SortExpression="To">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Edit" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Delete" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div class="formsubheading">
                                                Invigilation</div>
                                            <asp:HiddenField ID="hdnStaffExtInvId" runat="server" />
                                            <table class="form">
                                                <tr>
                                                    <td width="18%" class="col1">
                                                        <label>
                                                            Year :
                                                        </label>
                                                    </td>
                                                    <td width="25%" class="col2">
                                                        <label>
                                                            School :</label>
                                                    </td>
                                                    <td width="21%" class="col2">
                                                        <label>
                                                            Place :</label>
                                                    </td>
                                                    <td width="16%" class="col2">
                                                        <label>
                                                            Type :
                                                        </label>
                                                    </td>
                                                    <td width="20%" class="col2">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <select name="txtInvYear" id="txtInvYear">
                                                            <option value="">----Select---</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtInvSchool" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtInvPlace" runat="server">
                                                        </asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlInvTypes" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <button id="btnInvSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveInvDetails();">
                                                            <span></span>
                                                            <div id="spInvSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="Button4" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                            onclick="return CancelInvDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="5">
                                                        <asp:GridView ID="dgInv" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="Year" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Year" SortExpression="Year">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="School" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="School" SortExpression="School">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Place" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Place" SortExpression="Place">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Type" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Type" SortExpression="Type">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Edit" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="StaffId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Delete" SortExpression="StaffId">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                            <p>
                                            </p>
                                            <div class="formsubheading">
                                                Resignation</div>
                                            <asp:HiddenField ID="hdnResignId" runat="server" />
                                            <table class="form">
                                                <tr>
                                                    <td width="20%" class="col1">
                                                        <label>
                                                            Year:
                                                        </label>
                                                    </td>
                                                    <td width="28%" class="col2">
                                                        <select name="txtResYear" id="txtResYear">
                                                            <option value="">----Select---</option>
                                                        </select>
                                                    </td>
                                                    <td width="19%" class="col2">
                                                        <label>
                                                            Reason:</label>
                                                    </td>
                                                    <td width="33%" class="col2">
                                                        <asp:TextBox ID="txtResReason" runat="server"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Certificate Issued 
                                                        On:</label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtResCert" runat="server">
                                                        </asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Resigned On:
                                                        </label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtResignDate" runat="server">
                                                        </asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <button id="btnResignSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveResignDetails();">
                                                            <span></span>
                                                            <div id="spResignSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                            onclick="return CancelResignDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Bank/EPF Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <table class="form">
                                                <tr>
                                                    <td width="19%">
                                                        <label>
                                                            Bank Status</label>
                                                        :
                                                    </td>
                                                    <td width="75%">
                                                        <input type="radio" name="brd1" value="Y" id="bradio1" checked="checked" />
                                                        Yes
                                                        <input type="radio" name="brd1" value="N" id="bradio2" />
                                                        No
                                                    </td>
                                                    <td width="6%">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr class="bankForm">
                                                    <td class="col2">
                                                        <label>
                                                            Bank Name :</label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtBankName" class="" />
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr class="bankForm">
                                                    <td class="col2">
                                                        <label>
                                                            Branch Code :</label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtBranch" />
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr class="bankForm">
                                                    <td class="col2">
                                                        <label>
                                                            Acc No. :</label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtAccNo" />
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr class="bankForm">
                                                    <td class="col2">
                                                        <label>
                                                            EPF Code :</label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtEPF" />
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr class="bankForm">
                                                    <td>
                                                    </td>
                                                    <td colspan="2">
                                                        <button id="btnBankSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveBankDetails();">
                                                            <span></span>
                                                            <div id="spBankSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnBankCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                            onclick="return CancelBankDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Leave Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <table class="form">
                                                <asp:HiddenField ID="hdnStaffLeaveId" runat="server" />
                                                <tr>
                                                    <td width="25%" class="co11">
                                                        <label>
                                                            Academic Year:</label>
                                                    </td>
                                                    <td width="25%" class="co11">
                                                        <label>
                                                            Leave:</label>
                                                    </td>
                                                    <td width="25%" class="co11">
                                                        <label>
                                                            No of Leaves/Hours</label>
                                                    </td>
                                                    <td width="25%" class="co12">
                                                        <label>
                                                            Reason:</label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:TextBox ID="txtAcademic" ReadOnly="true" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td width="10%">
                                                        <asp:DropDownList ID="ddlLeave" runat="server" CssClass="jsrequired">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="30%">
                                                        <asp:TextBox ID="txtNop" CssClass="numericswithdecimals" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td width="24%">
                                                        <textarea rows="5" cols="30" id="txtLeaveReason" class="jsrequired" runat="server"
                                                            style="vertical-align: middle;"></textarea>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            From:</label>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            To:</label>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Uploads/Attachments</label>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:TextBox ID="txtFrom" CssClass="dateNL date-picker jsrequired" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtTo" runat="server" CssClass="dateNL date-picker jsrequired"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <input type="file" id="leaveFile" onchange="readLeaveURL(this)" />
                                                    </td>
                                                    <td>
                                                        <button id="btnLeaveSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveLeaveDetails();">
                                                            <span></span>
                                                            <div id="spLeaveSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnLeaveCancel" type="button" class="btn-icon btn-navy btn-cancel1" onclick="return CancelLeaveDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgLeave" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="AcademicYear" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Academic Year" SortExpression="AcademicYear">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Leave" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Leave" SortExpression="Leave">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Reason" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Reason" SortExpression="Reason">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="From" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="From" SortExpression="From">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="To" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="To" SortExpression="To">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="NoOfLeaves" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="No Of Leaves/Permission" SortExpression="NoOfLeaves">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Uploads" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Uploads" SortExpression="Uploads">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Status" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Status" SortExpression="Status">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                                                    <HeaderTemplate>
                                                                        Edit</HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StaffId") %>'
                                                                            CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                    <HeaderTemplate>
                                                                        Delete</HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StaffId") %>'
                                                                            CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Remark Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <table class="form">
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Date</label>
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txtRemDate" class="jsrequired date-picker" />
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Title
                                                        </label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtRemTitle" runat="server" CssClass="jsrequired"> </asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Reason</label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtRemReason" runat="server" CssClass="jsrequired" TextMode="MultiLine"
                                                            Rows="3" Columns="18"> </asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Upload/Attachment</label>
                                                    </td>
                                                    <td>
                                                        <input type="file" id="fileRem" onchange="readRemarkURL(this)" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="40">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="3">
                                                        <button id="btnRemarkSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveRemarkDetails();">
                                                            <span></span>
                                                            <div id="spRemarkSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnRemarkCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                            runat="server" onclick="return CancelRemarkDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgRemark" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="Date" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Date" SortExpression="Date">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Title" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Title" SortExpression="Title">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Reason" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Reason" SortExpression="Reason">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Uploads" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Uploads" SortExpression="Uploads">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                    <HeaderTemplate>
                                                                        Delete</HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StaffId") %>'
                                                                            CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Punishment Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <table class="form">
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Date</label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtPunishDate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Title
                                                        </label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtPunishTitle" CssClass="jsrequired" runat="server"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Reason</label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtPunishReason" TextMode="MultiLine" Rows="3" Columns="18" CssClass="jsrequired"
                                                            runat="server"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Upload/Attachment</label>
                                                    </td>
                                                    <td>
                                                        <input type="file" id="filePunishment" onchange="readPunishURL(this)" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="40">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="3">
                                                        <button id="btnPunishSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SavePunishmentDetails();">
                                                            <span></span>
                                                            <div id="spPunishSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnPunishCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                            runat="server" onclick="return CancelPunishmentDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgPunish" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="Date" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Date" SortExpression="Date">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Title" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Title" SortExpression="Title">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Reason" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Reason" SortExpression="Reason">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Uploads" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Uploads" SortExpression="Uploads">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                    <HeaderTemplate>
                                                                        Delete</HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StaffId") %>'
                                                                            CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a class="menuitem">Retirement Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div class="frm-block">
                                            <table class="form">
                                                <tr>
                                                    <td width="56">
                                                        <label>
                                                            Date</label>
                                                        :
                                                    </td>
                                                    <td width="151">
                                                        <input id="txtRetireDate" class="jsrequired dateNL date-picker" type="text" />
                                                    </td>
                                                    <td width="122">
                                                        <label>
                                                            Title :
                                                        </label>
                                                    </td>
                                                    <td width="225">
                                                        <asp:TextBox ID="txtRetireTitle" runat="server" CssClass="jsrequired"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Reason</label>
                                                        :
                                                    </td>
                                                    <td>
                                                        <textarea id="txtRetireReason" rows="5" cols="30"></textarea>
                                                    </td>
                                                    <td>
                                                        <label>
                                                            Upload/Attachment</label>
                                                        :
                                                    </td>
                                                    <td>
                                                        <input type="file" id="fileRetire" onchange="readRetireURL(this)" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="40">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="3">
                                                        <button id="btnRetSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="SaveRetirementDetails();">
                                                            <span></span>
                                                            <div id="spRetSubmit">
                                                                Update</div>
                                                        </button>
                                                        <button id="btnRetCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                            onclick="return CancelRetirementDetails();">
                                                            <span></span>Cancel</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgRetire" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="Date" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Date" SortExpression="Date">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Title" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Title" SortExpression="Title">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Reason" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Reason" SortExpression="Reason">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="Uploads" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Uploads" SortExpression="Uploads">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                    <HeaderTemplate>
                                                                        Delete</HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StaffId") %>'
                                                                            CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </li>
                                </ul>
                            </li>
                            <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                                Relative Staff Details</a>
                                <ul class="johnmenu">
                                    <li>
                                        <div id="Div5" style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                            <table class="form" width="100%">
                                                <tr>
                                                    <td width="30%">
                                                        <label>
                                                            If Relatives Working in this Institution:</label>
                                                    </td>
                                                    <td>
                                                        <span class="col2">
                                                            <input type="radio" name="bb1" id="rbtnInsNo" value="No" checked="checked" onclick="javascript:ShowInstitution();" />No
                                                            <input type="radio" name="bb1" id="rbtnInsYes" value="Yes" onclick="javascript:ShowInstitution();" />Yes</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <div id="dvInstitution" style="display: none;">
                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td>
                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td width="20%">
                                                                                    <label>
                                                                                        Emp Id/Name:</label>
                                                                                </td>
                                                                                <td width="20%">
                                                                                    <asp:DropDownList ID="ddlStaff1" runat="server" AppendDataBoundItems="True">
                                                                                        <asp:ListItem Selected="True" Value="">----Select---</asp:ListItem>
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                                <td width="20%" align="center">
                                                                                    <label>
                                                                                        Relationship:</label>
                                                                                </td>
                                                                                <td width="20%">
                                                                                    <asp:DropDownList ID="ddlRelationship1" runat="server" AppendDataBoundItems="True">
                                                                                        <asp:ListItem Selected="True" Value="">----Select---</asp:ListItem>
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                                <td width="22%" align="left">
                                                                                    <button id="btnRelativeAdd" type="button" class="btn-icon btn-navy btn-update" onclick="SaveRelativeDetails();">
                                                                                        <span></span>Update</button>&nbsp;
                                                                                    <button id="btnRelativeCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                                        runat="server" onclick="return RelativeDetailsClear();">
                                                                                        <span></span>Cancel</button>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                        <asp:HiddenField ID="hfStaffRelID" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:GridView ID="dgInstitution" runat="server" Width="100%" AutoGenerateColumns="False"
                                                            AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                            <Columns>
                                                                <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="SlNo" SortExpression="SlNo">
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="RelationName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                    HeaderText="Relation Name" SortExpression="RelationName">
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
                                                                        <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StaffRelID") %>'
                                                                            CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                    HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                    <HeaderTemplate>
                                                                        Delete</HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StaffRelID") %>'
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
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
