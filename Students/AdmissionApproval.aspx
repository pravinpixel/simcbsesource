<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="AdmissionApproval.aspx.cs" Inherits="Students_AdmissionApproval" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <!--Autocomplete script starts here -->
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <!--Autocomplete script ends here -->
    <script type="text/javascript">

        $(function () {
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
        });


        function GetStudentsDetail(pageIndex) {

            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Students/AdmissionApproval.aspx/GetAdmissionApprovalStudList",
                    data: '{"pageIndex":"' + pageIndex + '","regNo":"' + $("[id*=txtRegNo]").val() + '","Class":"' + $("[id*=ddlClass]").val() + '","studentName":"' + $("[id*=txtStudentName]").val() + '","AcademicId":"' + $("[id*=hdnAcademicId]").val() + '"}',
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


        function OnSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var admissionStudList = xml.find("AdmissionStudList");

            if (admissionStudList.find("regno").length > 0) {
                var row = $("[id*=grdAdmissionApproval] tr:last-child").clone(true);
                $("[id*=grdAdmissionApproval] tr").not($("[id*=grdAdmissionApproval] tr:first-child")).remove();
                $.each(admissionStudList, function () {
                    var regno = $(this).find("regno").text();
                    var stname = $(this).find("stname").text();
                    var class1 = $(this).find("classname").text();
                    var classid = $(this).find("classid").text();
                    $.ajax({
                        type: "POST",
                        url: "../Students/AdmissionApproval.aspx/GetAdmissionApprovalStudClassbySection",
                        data: '{"regNo":"' + regno + '","Classid":"' + classid + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            row.addClass("even");
                            $("td", row).eq(0).html(regno);
                            $("td", row).eq(1).html(stname);
                            $("td", row).eq(2).html(class1);
                            $("td", row).eq(3).html(response.d);
                            $("[id*=grdAdmissionApproval]").append(row);
                            row = $("[id*=grdAdmissionApproval] tr:last-child").clone(true);
                        },
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });

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
            else {
                var pager = xml.find("Pager");
                if (parseInt(pager.find("RecordCount").text()) > 0)
                    GetStudentsDetail(parseInt(pager.find("PageIndex").text()) - 1);
                else {
                    var row = $("[id*=grdAdmissionApproval] tr:last-child").clone(true);
                    $("[id*=grdAdmissionApproval] tr").not($("[id*=grdAdmissionApproval] tr:first-child")).remove();
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("No Result Found");
                    $("td", row).eq(2).html("");
                    $("td", row).eq(3).html("");
                    $("[id*=grdAdmissionApproval]").append(row);
                }
            }

            if ($("[id*=txtRegNo]").val() != "") {
                getApplicationdetail();
            }


        };

        function getApplicationdetail() {

            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Students/AdmissionApproval.aspx/getApplicationdetail",
                    data: '{"regNo":"' + $("[id*=txtRegNo]").val() + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d != "") {
                            if (response.d == "failed") {
                                jAlert("The selected student is  either In-Active or not Paid in SIMApp software, Kindly check with administrator");
                                $("[id*=txtRegNo]").val('');
                                GetStudentsDetail(1);
                            }
                            else {
                                jAlert(response.d);
                            }
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
                return false;
            }
        }


        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetStudentsDetail(parseInt($(this).attr('page')));
        });

        function updateSection(regno, classid) {
            var sectionId = $('#' + regno).val();
            var academicYear = $("[name*=radlAcademicYear]:checked").val();

            $.ajax({
                type: "POST",
                url: "../Students/AdmissionApproval.aspx/UpdateStudentSection",
                data: '{"regNo":"' + regno + '","sectionId":"' + sectionId + '","Classid":"' + classid + '","AcademicYearId":"' + academicYear + '","userId":"' + $('#<%= hdnUserId.ClientID %>').val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    jAlert(response.d);
                    GetStudentsDetail(parseInt($("[id*=currentPage]").text()));
                },
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });


        }

        function Cancel() {
            $("[id*=txtRegNo]").val('');
            $("[id*=ddlClass]").val('');
            $("[id*=txtStudentName]").val('');
        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                ADMISSION APPORVAL</h2>
            <div class="block1 content-wrapper2">
                <table class="form">
                    <tr>
                        <td>
                            <div id="stud_1" style="display: block;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="9%">
                                            <label>
                                                Register No :</label>
                                        </td>
                                        <td width="18%">
                                            <asp:TextBox ID="txtRegNo" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Class :</label>
                                        </td>
                                        <td width="20%">
                                            <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                Student Name :</label>
                                        </td>
                                        <td width="32%">
                                            <input type="text" id="testid" value="" style="display: none" />
                                            <asp:TextBox ID="txtStudentName" CssClass="bloodgroup" runat="server"></asp:TextBox>
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
                            <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStudentsDetail(1);">
                                <span></span>Search</button>
                            &nbsp;
                            <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return Cancel();">
                                <span></span>Cancel</button>
                            &nbsp;
                            <asp:HiddenField ID="hfStudentID" runat="server" />
                            <asp:HiddenField ID="hfModuleID" runat="server" />
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
                        <td valign="top" width="12%">
                            <span>Academic Year Belong To : </span>
                        </td>
                        <td valign="top" width="15%">
                            <asp:RadioButtonList ID="radlAcademicYear" RepeatDirection="Horizontal" runat="server">
                            </asp:RadioButtonList>
                        </td>
                        <td valign="top" width="70%">
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="grdAdmissionApproval" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField HeaderText="Register No" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Student Name" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Class" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:TemplateField HeaderText="Section" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <select id="ddlAdmissionApproval" onchange="changeStatus();">
                                            </select>
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
        </div>
    </div>
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <asp:HiddenField ID="hdnAcademicId" runat="server" />
    <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetAdmissionApprovalStudent.ashx?input=" + input + "&class=" + $('#<%= ddlClass.ClientID %>').val() + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15
        };
        
        var as_xml = new bsn.AutoSuggest('<%= txtStudentName.ClientID %>', options_xml);    

    </script>
</asp:Content>
