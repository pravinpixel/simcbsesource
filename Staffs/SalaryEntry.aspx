<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="SalaryEntry.aspx.cs"
    Inherits="Performance_SalaryEntry" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <style type="text/css">
        .highlight
        {
            background: #A7A4A4;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript">


        function GetList() {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                if ($('#aspnetForm').valid()) {
                    var parameters = '{"placeofwork": "' + $("[id*=ddlPlaceofwork]").val() + '","departmentid": "' + $("[id*=ddlDepartment]").val() + '","academicId": "' + $("[id*=hfAcademicYear]").val() + '","formonth": "' + $("[id*=ddlMonth]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/SalaryEntry.aspx/GetList",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        beforeSend: loadingfun,
                        success: OnSuccess,
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

        function OnSuccess(response) {

            var arr = new Array();
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var heads = xml.find("Table");
            var staffs = xml.find("Table1");


            $("[id*=grdList]").html('');
            if (heads.length > 0) {
                $('.grdList').removeAttr('style', 'display:none;');
                var first = '<tbody><tr style=\margin-top:-60px;padding-left:0px;\"><th class=\"freezing_mod\" scope=\"col\">StaffID</th><th class=\"freezing_mod\" scope=\"col\">EmpCode</th><th class=\"freezing_mod\" scope=\"col\">Name</th><th class=\"freezing_mod\" scope=\"col\">Short Name</th>';
                var second = '';

                $.each(heads, function () {
                    second += '<th class=\"freezing_mod\" scope=\"col\">' + $(this).find("SalaryHeadName").text() + '</th>';
                });
                var third = '</tr></<tbody>';
                $("[id*=grdList]").html(first + second + third);

                $.each(heads, function () {
                    arr.push($(this).find("Subt").text());
                });


                if (staffs.length > 0) {
                    $.each(staffs, function () {
                        var mod = $(this);
                        var firstApp = '<tr class=\"evennew\"><td class=\"staffid\">' + $(this).find("StaffID").text() + '</td><td class=\"empcode\">' + $(this).find("EmpCode").text() + '</td><td>' + $(this).find("StaffName").text() + '</td><td>' + $(this).find("StaffShortName").text() + '</td>';
                        var secondeApp = '';
                        var maxSalary = '';
                        $.each(arr, function (index, value) {
                            var salaryheadid = value.split('-')[1];

                            secondeApp += '<td><input style=\"width:57px;\" type=\"text\" class=\"' + salaryheadid + 'S' + '\" value="' + mod.find(value).text() + '" ></input></td>';


                        });
                        var thirdApp = "</tr>";
                        $("[id*=grdList]").append(firstApp + secondeApp + thirdApp);
                    });
                }
                else {
                    $('.grdList').attr('style', 'display:none;');
                    AlertMessage('info', 'Please Check Staff List');
                }
            }
            else {
                $('.grdList').attr('style', 'display:none;');
                AlertMessage('info', 'Please Check Salary Heads');
            }


            // Moving to Next TextBox on Enter Key Press Event
            $("input[type=text]").focus();
            var $inp = $("input[type=text]");
            $inp.bind('keydown', function (e) {
                var key = e.which;
                if (key == 40) {
                    e.preventDefault();
                    var cls = $(this).attr("class").split(' ');
                    var nxtIdx = $inp.index($(this).parent().parent("tr").next().find("td input." + cls[0] + ""));
                    if (nxtIdx == "-1") {
                        var arr = $(this).parent().next().find("input").attr("class");
                        nxtIdx = $inp.index($('.' + arr.split(' ')[0] + '').first());
                    }

                    $(":input:text:eq(" + nxtIdx + ")").focus();
                    $(":input:text:eq(" + nxtIdx + ")").closest('tr').addClass('highlight');
                }
            });
            $("input[type=text]").blur(function () {
                $(this).closest('tr').removeClass('highlight');
            });

            $("input[type=text]").focus();
            var $inp = $("input[type=text]");
            $inp.bind('keyup', function (e) {
                var key = e.which;
                if (key == 38) {
                    e.preventDefault();
                    var cls = $(this).attr("class").split(' ');
                    var nxtIdx = $inp.index($(this).parent().parent("tr").prev().find("td input." + cls[0] + ""));
                    if (nxtIdx == "-1") {
                        var arr = $(this).parent().prev().find("input").attr("class");
                       // alert($('.' + arr.split(' ')[0] + ''));
                        nxtIdx = $inp.index($('.' + arr.split(' ')[0] + '').first());
                    }

                    $(":input:text:eq(" + nxtIdx + ")").focus();
                    $(":input:text:eq(" + nxtIdx + ")").closest('tr').addClass('highlight');
                }
            });
            $("input[type=text]").blur(function () {
                $(this).closest('tr').removeClass('highlight');
            });

            $("#loading").html('');

        }



        function Cancel() {
            $("[id*=ddlPlaceofwork]").val('');
            $("[id*=ddlDepartment]").val('');
            $("[id*=ddlMonth]").val('');
            $('#aspnetForm').validate().resetForm();
            $(".grdList").attr("style", "display:none;");
        }

        function SaveSalary() {
            if ($("[id*=hfAddPrm]").val() == 'true') {
                var salaryDetails = new Array();
                $(".evennew").each(function () {
                    var SalHeadId = '';
                    var salary = '';
                    var staffid = '';
                    staffid = $(this).find("td.staffid").html();
                    $(this).find("td input[type=text]").each(function () {
                        var headID = $(this).attr("class").split(' ')[0].replace("S", "")
                        SalHeadId += headID + '|';
                        salary += $(this).val() + '|';
                    });
                    salaryDetails.push({ "formonth": "" + $("[id*=ddlMonth]").val() + "", "staffid": "" + staffid + "", "salaryheadid": "" + SalHeadId + "", "salary": "" + salary + "", "academicId": "" + $("[id*=hfAcademicYear]").val() + "", "userId": "" + $("[id*=hfuserid]").val() + "" });
                });

                var parameters = JSON.stringify({ salarylist: salaryDetails });

                $.ajax({
                    type: "POST",
                    url: "../Staffs/SalaryEntry.aspx/SaveSalary",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    beforeSend: loadingfun,
                    success: OnSaveSuccess,
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
        function OnSaveSuccess(response) {
            AlertMessage('success', 'Updated');
            GetList();
            $("#loading").html('');
        }
        function loadingfun() {

            var str = '<div style="background: url(../img/overly.png) repeat; width: 100%;  height: 100%; position: fixed;text-align:center; top: 0; left: 0; z-index: 10000;">';
            str += '<center><img src="../img/loading.gif"/></center>';
            str += '</div>';
            $("#loading").html(str);

        }
    </script>
    <style type="text/css">
        .modal
        {
            position: fixed;
            top: 0;
            left: 0;
            background-color: black;
            z-index: 99;
            opacity: 0.8;
            filter: alpha(opacity=80);
            -moz-opacity: 0.8;
            min-height: 100%;
            width: 100%;
        }
        .loading
        {
            font-family: Arial;
            font-size: 10pt;
            border: 5px solid #67CFF5;
            width: 200px;
            height: 100px;
            display: none;
            position: fixed;
            background-color: White;
            z-index: 999;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div id="loading">
    </div>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Salary Entry
            </h2>
            <div>
                <asp:UpdatePanel ID="ups" runat="server">
                    <ContentTemplate>
                        <table class="form" width="100%">
                            <tr>
                                <td>
                                    <div id="dvSalaryEntry">
                                        <table width="100%">
                                            <tr>
                                                <td width="20%" height="30">
                                                    <label>
                                                        Place Of Work :</label>
                                                    <asp:DropDownList ID="ddlPlaceofwork" runat="server" AppendDataBoundItems="True">
                                                        <asp:ListItem Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td width="20%" height="40">
                                                    <label>
                                                        Department :</label>
                                                    <asp:DropDownList ID="ddlDepartment" runat="server" AppendDataBoundItems="True">
                                                        <asp:ListItem Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td width="25%" height="40">
                                                    <label>
                                                        For Month :</label>
                                                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="jsrequired" AutoPostBack="False">
                                                        <asp:ListItem Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td align="center" colspan="3">
                                                     <button id="btnSearch" class="btn-icon btn-navy btn-search" onclick="GetList();"
                                                        type="button">
                                                        Search
                                                    </button>
                                                    <button id="btnSubmit" class="btn-icon btn-orange btn-saving" onclick="SaveSalary();"
                                                        type="button">
                                                        <span></span>
                                                        <div id="spSubmit">
                                                            Save</div>
                                                    </button>
                                                    <button id="btnkCancel" runat="server" class="btn-icon btn-navy btn-cancel1" onclick="return Cancel();"
                                                        type="button">
                                                        <span></span>Cancel
                                                    </button>
                                                   
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                         
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="clear">
            </div>
            <br />
            <div class="block john-accord content-wrapper5">
                <table width="100%" class="grdList">
                    <tr>
                        <td colspan="8">
                            <div id="dvBody">
                                <asp:GridView ID="grdList" runat="server" Width="100%" AutoGenerateColumns="False"
                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="evennew"
                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <%--   <div class="loading" align="center">
                Loading. Please wait.<br />
                <br />
                <img src="../img/ajax-loader.gif" alt="" />
            </div>--%>
        </div>
    </div>
</asp:Content>
