<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StudentAttendance.aspx.cs" Inherits="Students_StudentAttendance" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!--Autocomplete script starts here -->
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <!--Autocomplete script ends here -->
    <script type="text/javascript">

        $(function () {

            setDatePicker("[id*=txtAttDate]");
            //        GetStudentInfos Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetStudentsDetail(1);
            //        GetModuleID('Students/TCSearch.aspx');
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
            GetDay();

        });

        function GetStudentsDetail(pageIndex) {

            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Students/StudentAttendance.aspx/GetStudentAttendanceStudList",
                    data: '{"pageIndex":"' + pageIndex + '","regNo":"' + $("[id*=txtRegNo]").val() + '","Class":"' + $("[id*=ddlClass]").val() + '","Section":"' + $("[id*=ddlSection]").val() + '","studentName":"' + $("[id*=txtStudentName]").val() + '","attdate":"' + $("[id*=txtAttDate]").val() + '"}',
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

        function GetStudentsDetails(pageIndex) {

            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Students/StudentAttendance.aspx/GetStudentAttendanceStudList",
                    data: '{"pageIndex":"' + pageIndex + '","regNo":"' + $("[id*=txtRegNo]").val() + '","Class":"' + $("[id*=ddlClass]").val() + '","Section":"' + $("[id*=ddlSection]").val() + '","studentName":"' + $("[id*=txtStudentName]").val() + '","attdate":"' + $("[id*=txtAttDate]").val() + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetStudentsDetailSuccess,
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
        function GetSectionByClass(ID) {
            var Class = $("[id*=ddlClass]").val();
            if (Class != "") {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentAttendance.aspx/GetSectionByClassID",
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
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));

            });

        };
        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var changeofsectionStudList = xml.find("StudentAttendanceStudList");

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
                    var regno = $(this).find("regno").text();
                    var studentid = $(this).find("studentId").text();
                    var adminno = $(this).find("adminno").text();
                    var stname = $(this).find("stname").text();
                    var class1 = $(this).find("classname").text();
                    var classid = $(this).find("classid").text();
                    var section1 = $(this).find("sectionname").text();
                    var sectionid = $(this).find("sectionid").text();
                    var forenoon = $(this).find("forenoon").text();
                    var afternoon = $(this).find("afternoon").text();
                    var AttendanceID = $(this).find("AttendanceID").text();
                    $("[id*=hfRegNo]").val($(this).find("regno").text());
                    $("[id*=hfAttendanceId]").val($(this).find("AttendanceID").text());

                    $(".even").each(function () {
                        var tdregno = $(this).find('td.RegNo').html();
                        var tdAttendanceID = $(this).find('td.AttendanceID').html();
                        if (tdAttendanceID == $("[id*=hfAttendanceId]").val() && tdregno == $("[id*=hfRegNo]").val()) {
                            if (forenoon == 'true') {
                                $(this).find('input.forenoon').attr('checked', false);
                                var callfuntion = "updateStatus(" + tdregno + ",'forenoon')";
                                $(this).find('input.forenoon').attr('onclick', callfuntion);
                            }
                            else {
                                $(this).find('input.forenoon').attr("checked", true);
                                var callfuntion = "updateStatus(" + tdregno + ",'forenoon')";
                                $(this).find('input.forenoon').attr('onclick', callfuntion);
                            }
                        }
                        else {
                            var callfuntion = "updateStatus(" + tdregno + ",'forenoon')";
                            $(this).find('input.forenoon').attr('onclick', callfuntion);
                        }
                        if (tdAttendanceID == $("[id*=hfAttendanceId]").val() && tdregno == $("[id*=hfRegNo]").val()) {
                            if (afternoon == 'true') {
                                $(this).find('input.afternoon').attr("checked", false);
                                var callfuntion = "updateStatus(" + tdregno + ",'afternoon')";
                                $(this).find('input.afternoon').attr('onclick', callfuntion);
                            }
                            else {
                                $(this).find('input.afternoon').attr("checked", true);
                                var callfuntion = "updateStatus(" + tdregno + ",'afternoon')";
                                $(this).find('input.afternoon').attr('onclick', callfuntion);
                            }
                        }
                        else {
                            var callfuntion = "updateStatus(" + tdregno + ",'afternoon')";
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
            GetStudentsDetails(parseInt($(this).attr('page')));
        });
        function OnGetStudentsDetailSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var changeofsectionStudList = xml.find("StudentAttendanceStudList");
            var row = $("[id*=GridView1] tr:last-child").clone(true);
            $("[id*=GridView1] tr").not($("[id*=GridView1] tr:first-child")).remove();

            var hfAttendanceId = "";
            var hfRegNo = "";
            var slno = "";
            var regno = "";
            var studentid = "";
            var adminno = "";
            var stname = "";
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
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("[id*=GridView1]").append(row);
                row = $("[id*=GridView1] tr:last-child").clone(true);

            }
            else {

                $.each(changeofsectionStudList, function () {

                    var ehref = "<input type='checkbox' onclick=updateStatus(" + $(this).find('regno').text() + ",'forenoon') class='forenoon' id= " + $(this).find("regno").text() + "></input>";
                    var dhref = "<input type='checkbox' onclick=updateStatus(" + $(this).find('regno').text() + ",'afternoon') class='afternoon' id= " + $(this).find("regno").text() + "></input>";
                    row.addClass("even");
                    slno = $(this).find("RowNumber").text();
                    regno = $(this).find("regno").text();
                    studentid = $(this).find("studentId").text();
                    adminno = $(this).find("adminno").text();
                    stname = $(this).find("stname").text();
                    class1 = $(this).find("classname").text();
                    classid = $(this).find("classid").text();
                    section1 = $(this).find("sectionname").text();
                    sectionid = $(this).find("sectionid").text();
                    forenoon = $(this).find("forenoon").text();
                    afternoon = $(this).find("afternoon").text();
                    AttendanceID = $(this).find("AttendanceID").text();

                    $("[id*=hfRegNo]").val($(this).find("regno").text());
                    $("[id*=hfAttendanceId]").val($(this).find("AttendanceID").text());
                    hfAttendanceId = $("[id*=hfAttendanceId]").val();
                    hfRegNo = $("[id*=hfRegNo]").val();

                    $("td", row).eq(0).html($(this).find("AttendanceID").text()).attr("class", "AttendanceID");
                    $("td", row).eq(1).html($(this).find("regno").text()).attr("class", "RegNo");
                    $("td", row).eq(2).html($(this).find("stname").text());
                    $("td", row).eq(3).html($(this).find("classname").text());
                    $("td", row).eq(4).html($(this).find("sectionname").text());
                    $("td", row).eq(5).html(ehref);
                    $("td", row).eq(6).html(dhref);
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

        function updateStatus(regno, status) {
            if (jConfirm('Are you sure to update the attendance status ?', 'Confirm', function (r) {
                if (r) {
                    var iRegno = "";
                    if ($("[id*=" + regno + "]").is(':checked')) {
                        iRegno = "1";
                    }
                    else {
                        iRegno = "0";
                    }
                    var AttDate = $("[id*=txtAttDate]").val();
                    $.ajax({
                        type: "POST",
                        url: "../Students/StudentAttendance.aspx/UpdateStudentAttendance",

                        data: '{"regno":"' + regno + '","status":"' + status + '","AttDate":"' + AttDate + '","userId":"' + $('#<%= hdnUserId.ClientID %>').val() + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            AlertMessage('success', response.d);
                            //                            GetStudentsDetail(parseInt($("[id*=currentPage]").text()));
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
            $("[id*=txtRegNo]").val("");
            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            $("[id*=txtStudentName]").val("");
            GetStudentsDetails(1);
        }
        function GetDay() {
            if ($("[id*=txtAttDate]").val() != "") {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentAttendance.aspx/GetDay",
                    data: '{"Date":"' + $("[id*=txtAttDate]").val() + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetDaySuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
                
            }

        }
        function OnGetDaySuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("DayofWeek");
            $.each(cls, function () {
                var icls = $(this);
                if (icls.length == 0) {
                    $("[id*=spnDate]").html("");
                }
                else {
                    $("[id*=spnDate]").html("Its " + $(this).find("DAYNAME").text()+ "");
                }



            });

        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Student Attendance</h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%" class="form">
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
                                            <asp:TextBox ID="txtAttDate" CssClass="jsrequired DateNL date-picker" 
                                                runat="server" onchange="javascript:GetDay();"></asp:TextBox>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Class :</label>
                                        </td>
                                        <td width="15%">
                                            <asp:DropDownList ID="ddlClass" runat="server" onchange="javascript:GetSectionByClass(this.value);"
                                                AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Section :</label>
                                        </td>
                                        <td width="16%">
                                            <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="9%">
                                            <label>
                                                Register No :</label>
                                        </td>
                                        <td width="15%">
                                            <asp:TextBox ID="txtRegNo" CssClass="bloodgroup" onblur="GetStudentByCode()" runat="server"></asp:TextBox>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                Student Name :</label>
                                        </td>
                                        <td width="18%">
                                            <input type="text" id="testid" value="" style="display: none" />
                                            <asp:TextBox ID="txtStudentName" onblur="GetStudentByName()" runat="server"></asp:TextBox>
                                        </td>
                                        <td colspan="2" width="20%">
                                        <h4><span id="spnDate" style="color:red;"></span></h4>
                                        </td>
                                        
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" align="center">
                            <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStudentsDetails(1);">
                                <span></span>Search</button>
                            &nbsp;
                            <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return Cancel();">
                                <span></span>Cancel</button>
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False"
                                ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even" AlternatingRowStyle-CssClass="even"
                                EnableModelValidation="True" CssClass="display" PageSize="50">
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
    <asp:HiddenField ID="hfRegNo" runat="server" />
    <asp:HiddenField ID="hfModuleID" runat="server" />
    <asp:HiddenField ID="hfAttendanceId" runat="server" />
    <script src="../prettyphoto/js/prettyPhoto.js" type="text/javascript"></script>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("a[rel^='prettyPhoto']").prettyPhoto();
        });
    </script>
    <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetStudent.ashx?type=code&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            timeout: 10000,
            callback: function (obj) { GetStudentByCode(); }
        };
        var options_xml2 = {
            script: function (input) { return "../Handlers/GetStudent.ashx?type=name&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            timeout: 10000,
            callback: function (obj) { GetStudentByName(); }
        };

        var as_xml = new bsn.AutoSuggest('<%= txtRegNo.ClientID %>', options_xml);
        var as_xml1 = new bsn.AutoSuggest('<%= txtStudentName.ClientID %>', options_xml2);

        function GetStudentByCode() {
            $("[id*=txtStudentName]").val('');
            var StudentName = $("[id*=txtStudentName]").val();
            var RegNo = $("[id*=txtRegNo]").val();
            if (RegNo != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentSearch.aspx/GetStudent",
                    data: '{StudentName:"' + StudentName + '",RegNo:"' + RegNo + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnStudentByCodeSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnStudentByCodeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var student = xml.find("Student");

            if (student.length > 0) {
                $.each(student, function () {
                    $("[id*=txtStudentName]").val($(this).find("StudentName").text());
                });
            }
            else {
                $("[id*=txtStudentName]").val('');
            }
        }
        function GetStudentByName() {
            $("[id*=txtRegNo]").val('');
            var StudentName = $("[id*=txtStudentName]").val();
            var RegNo = $("[id*=txtRegNo]").val();
            if (StudentName != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentSearch.aspx/GetStudent",
                    data: '{StudentName:"' + StudentName + '",RegNo:"' + RegNo + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnStudentByNameSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnStudentByNameSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var student = xml.find("Student");

            if (student.length > 0) {
                $.each(student, function () {
                    $("[id*=txtRegNo]").val($(this).find("RegNo").text());
                });
            }
            else {
                $("[id*=txtRegNo]").val('');
            }
        }
    </script>
</asp:Content>
