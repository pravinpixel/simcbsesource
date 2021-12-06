<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StaffAttendance.aspx.cs" Inherits="Staffs_StaffAttendance" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <script type="text/javascript">

        $(function () {
            setDatePicker("[id*=txtAttDate]");
            //        GetStudentInfos Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetStaffsDetail(1);
            //        GetModuleID('Staffs/TCSearch.aspx');
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);


        });

        function GetStaffsDetail(pageIndex) {

            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffAttendance.aspx/GetStaffAttendanceList",
                    data: '{"pageIndex":"' + pageIndex + '","StaffName":"' + $("[id*=txtStaffName]").val() + '","attdate":"' + $("[id*=txtAttDate]").val() + '"}',
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

        function GetStaffsDetails(pageIndex) {

            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffAttendance.aspx/GetStaffAttendanceList",
                    data: '{"pageIndex":"' + pageIndex + '","StaffName":"' + $("[id*=txtStaffName]").val() + '","attdate":"' + $("[id*=txtAttDate]").val() + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetStaffsDetailSuccess,
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

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var changeofsectionStudList = xml.find("StaffAttendanceList");

            if (changeofsectionStudList.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("[id*=GridView1]").append(row);
                row = $("[id*=GridView1] tr:last-child").clone(true);

                var pager = xml.find("Pager");
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(1),
                    PageSize: parseInt(1),
                    RecordCount: parseInt(0)
                });
            }
            else {
                $.each(changeofsectionStudList, function () {
                    var slno = $(this).find("RowNumber").text();
                    var EmpCode = $(this).find("EmpCode").text();
                    var StaffId = $(this).find("StaffId").text();
                    var StaffName = $(this).find("StaffName").text();
                    var forenoon = $(this).find("forenoon").text();
                    var afternoon = $(this).find("afternoon").text();
                    var AttendanceID = $(this).find("AttendanceID").text();
                    $("[id*=hfStaffId]").val($(this).find("StaffId").text());
                    $("[id*=hfAttendanceId]").val($(this).find("AttendanceID").text());

                    $(".even").each(function () {
                        var tdStaffId = $(this).find('td.StaffId').html();
                        var tdAttendanceID = $(this).find('td.AttendanceID').html();
                        if (tdAttendanceID == $("[id*=hfAttendanceId]").val() && tdStaffId == $("[id*=hfStaffId]").val()) {
                            if (forenoon == 'true') {
                                $(this).find('input.forenoon').attr('checked', false);
                                var callfuntion = "updateStatus(" + tdStaffId + ",'forenoon')";
                                $(this).find('input.forenoon').attr('onclick', callfuntion);
                            }
                            else {
                                $(this).find('input.forenoon').attr("checked", true);
                                var callfuntion = "updateStatus(" + tdStaffId + ",'forenoon')";
                                $(this).find('input.forenoon').attr('onclick', callfuntion);
                            }
                        }
                        else {
                            var callfuntion = "updateStatus(" + tdStaffId + ",'forenoon')";
                            $(this).find('input.forenoon').attr('onclick', callfuntion);
                        }
                        if (tdAttendanceID == $("[id*=hfAttendanceId]").val() && tdStaffId == $("[id*=hfStaffId]").val()) {
                            if (afternoon == 'true') {
                                $(this).find('input.afternoon').attr("checked", false);
                                var callfuntion = "updateStatus(" + tdStaffId + ",'afternoon')";
                                $(this).find('input.afternoon').attr('onclick', callfuntion);
                            }
                            else {
                                $(this).find('input.afternoon').attr("checked", true);
                                var callfuntion = "updateStatus(" + tdStaffId + ",'afternoon')";
                                $(this).find('input.afternoon').attr('onclick', callfuntion);
                            }
                        }
                        else {
                            var callfuntion = "updateStatus(" + tdStaffId + ",'afternoon')";
                            $(this).find('input.afternoon').attr('onclick', callfuntion);
                        }

                    });
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
        $(".Pager .page").live("click", function (e) {
            GetStaffsDetails(parseInt($(this).attr('page')));
        });

        function OnGetStaffsDetailSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var changeofsectionStudList = xml.find("StaffAttendanceList");
            var row = $("[id*=GridView1] tr:last-child").clone(true);
            $("[id*=GridView1] tr").not($("[id*=GridView1] tr:first-child")).remove();
            var hfAttendanceId = "";
            var hfStaffId = "";
            var slno = "";
            var EmpCode = "";
            var StaffId = "";
            var adminno = "";
            var StaffName = "";
            var class1 = "";
            var classid = "";
            var section1 = "";
            var sectionid = "";
            var forenoon = "";
            var afternoon = "";
            var AttendanceID = "";
            if (changeofsectionStudList.length == 0) {

                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Record Found").attr("align", "left");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("[id*=GridView1]").append(row);
                row = $("[id*=GridView1] tr:last-child").clone(true);

            }
            else {

                $.each(changeofsectionStudList, function () {

                    var ehref = "<input type='checkbox' onclick=updateStatus(" + $(this).find('StaffId').text() + ",'forenoon') class='forenoon' id= " + $(this).find("StaffId").text() + "></input>";
                    var dhref = "<input type='checkbox' onclick=updateStatus(" + $(this).find('StaffId').text() + ",'afternoon') class='afternoon' id= " + $(this).find("StaffId").text() + "></input>";
                    row.addClass("even");
                    slno = $(this).find("RowNumber").text();
                    EmpCode = $(this).find("EmpCode").text();
                    StaffId = $(this).find("StaffId").text();
                    StaffName = $(this).find("StaffName").text();
                    forenoon = $(this).find("forenoon").text();
                    afternoon = $(this).find("afternoon").text();
                    AttendanceID = $(this).find("AttendanceID").text();

                    $("[id*=hfStaffId]").val($(this).find("StaffId").text());
                    $("[id*=hfAttendanceId]").val($(this).find("AttendanceID").text());
                    hfAttendanceId = $("[id*=hfAttendanceId]").val();
                    hfStaffId = $("[id*=hfStaffId]").val();

                    $("td", row).eq(0).html($(this).find("AttendanceID").text()).attr("class", "AttendanceID");
                    $("td", row).eq(1).html($(this).find("StaffId").text()).attr("class", "StaffId");
                    $("td", row).eq(2).html($(this).find("EmpCode").text()).attr("class", "EmpCode");
                    $("td", row).eq(3).html($(this).find("StaffName").text());
                    $("td", row).eq(4).html(ehref);
                    $("td", row).eq(5).html(dhref);
                    if (forenoon == 'true') {
                        $("td", row).find('input.forenoon').attr('checked', false);
                    }
                    else {
                        $("td", row).find('input.forenoon').attr('checked', true);
                    }
                    if (afternoon == 'true') {
                        $("td", row).find('input.afternoon').attr("checked", false);
                    }
                    else {
                        $("td", row).find('input.afternoon').attr('checked', true);
                    }

                    $("[id*=GridView1]").append(row);
                    row = $("[id*=GridView1] tr:last-child").clone(true);

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

        function updateStatus(StaffId, status) {
            if (jConfirm('Are you sure to update the attendance status ?', 'Confirm', function (r) {
                if (r) {
                    var iStaffId = "";
                    if ($("[id*=" + StaffId + "]").is(':checked')) {
                        iStaffId = "1";
                    }
                    else {
                        iStaffId = "0";
                    }
                    var AttDate = $("[id*=txtAttDate]").val();
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/StaffAttendance.aspx/UpdateStaffAttendance",

                        data: '{"StaffId":"' + StaffId + '","status":"' + status + '","AttDate":"' + AttDate + '","userId":"' + $('#<%= hdnUserId.ClientID %>').val() + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            AlertMessage('success', response.d);
                            //                            GetStaffsDetail(parseInt($("[id*=currentPage]").text()));
                        },
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

        function Cancel() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtStaffName]").val("");
            $("[id*=txtEmpCode]").val("");
            GetStaffsDetails(1);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Staff Attendance</h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table class="form">
                    <tr>
                        <td>
                            <div style="display: block;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="9%">
                                            <label>
                                                Date :</label>
                                        </td>
                                        <td width="15%">
                                            <asp:TextBox ID="txtAttDate" CssClass="jsrequired DateNL date-picker" runat="server"></asp:TextBox>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Staff Code :</label>
                                        </td>
                                        <td width="15%">
                                            <input type="text" id="testid" value="" style="display: none" />
                                            <asp:TextBox ID="txtEmpCode" CssClass="bloodgroup" runat="server" onblur="GetEmpByCode()"></asp:TextBox>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Staff Name :</label>
                                        </td>
                                        <td width="15%">
                                            <asp:TextBox ID="txtStaffName" onblur="GetEmpByName()" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            .
                        </td>
                    </tr>
                    <tr>
                        <td class="col1">
                        </td>
                    </tr>
                    <tr>
                        <td class="col1">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" align="center">
                            <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStaffsDetails(1);">
                                <span></span>Search</button>
                            &nbsp;
                            <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return Cancel();">
                                <span></span>Cancel</button>
                            &nbsp;
                            <asp:HiddenField ID="hfStaffId" runat="server" />
                            <asp:HiddenField ID="hfModuleID" runat="server" />
                            <asp:HiddenField ID="hfAttendanceId" runat="server" />
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False"
                                ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even" AlternatingRowStyle-CssClass="even"
                                EnableModelValidation="True" CssClass="display">
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
        </div>
    </div>
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetEmployee.ashx?type=code&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            callback: function (obj) { GetEmpByCode(); }
        };
        var options_xml2 = {
            script: function (input) { return "../Handlers/GetEmployee.ashx?type=name&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            callback: function (obj) { GetEmpByName(); }
        };

        var as_xml = new bsn.AutoSuggest('<%= txtEmpCode.ClientID %>', options_xml);
        var as_xml1 = new bsn.AutoSuggest('<%= txtStaffName.ClientID %>', options_xml2);

        function GetEmpByCode() {
            $("[id*=txtStaffName]").val('');
            var staffName = $("[id*=txtStaffName]").val();
            var empCode = $("[id*=txtEmpCode]").val();
            if (empCode != '') {
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffSearch.aspx/GetEmployee",
                    data: '{staffName:"' + staffName + '",empCode:"' + empCode + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEmployeeByCodedSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnEmployeeByCodedSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var employee = xml.find("Employee");

            if (employee.length > 0) {
                $.each(employee, function () {
                    $("[id*=txtStaffName]").val($(this).find("StaffName").text());
                });
            }
            else {
                $("[id*=txtStaffName]").val('');
            }
        }
        function GetEmpByName() {
            $("[id*=txtEmpCode]").val('');
            var staffName = $("[id*=txtStaffName]").val();
            var empCode = $("[id*=txtEmpCode]").val();
            if (staffName != '') {
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffSearch.aspx/GetEmployee",
                    data: '{staffName:"' + staffName + '",empCode:"' + empCode + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEmployeeByNameSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnEmployeeByNameSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var employee = xml.find("Employee");

            if (employee.length > 0) {
                $.each(employee, function () {
                    $("[id*=txtEmpCode]").val($(this).find("EmpCode").text());
                });
            }
            else {
                $("[id*=txtEmpCode]").val('');
            }
        }
    </script>
    <script src="../prettyphoto/js/prettyPhoto.js" type="text/javascript"></script>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("a[rel^='prettyPhoto']").prettyPhoto();
        });
    </script>
</asp:Content>
