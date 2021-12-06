<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AdmissionWithdrawal.aspx.cs" Inherits="Students_AdmissionWithdrawal" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function GetSectionByClass(ID) {
            if (ID != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/AdmissionWithdrawal.aspx/GetSectionByClassID",
                    data: '{ClassID: ' + ID + '}',
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
            else {
                var select = $("[id*=ddlSection]");
                select.children().remove();
                select.append($("<option>").val('').text('---Select---'));
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
                $("[id*=dgStudentInfo] tr:has(td)").remove();
                $("[id*=dgStudentInfo]").append("<tr class=\"even\"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");

            });
        };

        function GetStudInfo() {
            if ($("[id*=txtRegNo]").val() != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/AdmissionWithdrawal.aspx/GetStudInfo",
                    data: '{"Regno": "' + $("[id*=txtRegNo]").val() + '","AdminNo": "' + $("[id*=txtAdminNo]").val() + '","name": "' + $("[id*=txtStudentName]").val() + '","className": "' + $("[id*=txtClass]").val() + '","section": "' + $("[id*=txtSection]").val() + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetStudentSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnGetStudentSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("StudInfo");
            $.each(cls, function () {
                $("[id*=txtRegNo]").val($(this).find("RegNo").text());
                $("[id*=txtAdminNo]").val($(this).find("AdmissionNo").text());
                $("[id*=txtStudentName]").val($(this).find("StudentName").text());
                $("[id*=ddlSchoolType]").val($(this).find("schooltypeid").text());
                $("[id*=txtClass]").val($(this).find("Class").text());
                $("[id*=txtSection]").val($(this).find("Section").text());
            });
        }
        function SearchAdmissionWithdrawal() {
            if ($("[id*=txtRegNo]").val() != "" || $("[id*=txtStudentName]").val() != "" || $("[id*=txtAdminNo]").val() != "" || $("[id*=txtClass]").val() != "" || $("[id*=txtSection]").val() != "") {
                if ($('#aspnetForm').valid()) {
                    Search(1);
                }
            }
            else
                AlertMessage('info', "Please enter any search term");
        }
        function Search(pageIndex) {
            var parameters = '{"Regno": "' + $("[id*=txtRegNo]").val() + '","StName": "' + $("[id*=txtStudentName]").val() + '","AdminNo": "' + $("[id*=txtAdminNo]").val() + '","Class": "' + $("[id*=ddlClass]").val() + '","Section": "' + $("[id*=ddlSection]").val() + '","pageIndex": "' + pageIndex + '"}';
            $.ajax({
                type: "POST",
                url: "../Students/AdmissionWithdrawal.aspx/GetAdmissionWithdrawal",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSearchSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnSearchSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var StudCertList = xml.find("AdmissionWithdrawal");
            var optionHref = "";
            if (StudCertList.length > 0) {
                var row = $("[id*=grdStudentSCInfo] tr:last-child").clone(true);
                $("[id*=grdStudentSCInfo] tr").not($("[id*=grdStudentSCInfo] tr:first-child")).remove();
                $.each(StudCertList, function () {
                    if ($(this).find("AdmissionId").text() != '')
                        optionHref = "<a href=\"../Students/ViewAdmissionWithdrawal.aspx?menuId=" + $("[id*=hdnViewTcMenu]").val() + "&activeIndex=0&moduleId=" + $("[id*=hdnViewTcModuleMenu]").val() + "&regno=" + $(this).find("RegNo").text() + "\">View</a>";
                    else
                        optionHref = "<a href=\"../Students/ViewAdmissionWithdrawal.aspx?menuId=" + $("[id*=hdnViewTcMenu]").val() + "&activeIndex=0&moduleId=" + $("[id*=hdnViewTcModuleMenu]").val() + "&regno=" + $(this).find("RegNo").text() + "\">Generate</a>";
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("adminno").text());
                    $("td", row).eq(3).html($(this).find("StudentName").text());
                    $("td", row).eq(4).html($(this).find("Class").text());
                    $("td", row).eq(5).html($(this).find("Section").text());
                    $("td", row).eq(6).html(optionHref);
                    $("[id*=grdStudentSCInfo]").append(row);
                    row = $("[id*=grdStudentSCInfo] tr:last-child").clone(true);
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

            //        Pager Click Function
            $(".Pager .page").live("click", function (e) {
                Search(parseInt($(this).attr('page')));
            });

        }
        $(function () {
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

            Search(1);

        });

    </script>
</asp:Content>
<asp:Content ID="mainContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:HiddenField ID="hdnViewTcMenu" runat="server" />
    <asp:HiddenField ID="hdnViewTcModuleMenu" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Admission Withdrawal Search</h2>
            <div class="block john-accord content-wrapper2">
                <div class="block1">
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
                                            <td width="11%">
                                                <label>
                                                    Admission No :</label>
                                            </td>
                                            <td width="20%">
                                                <asp:TextBox ID="txtAdminNo" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                            </td>
                                            <td width="10%">
                                                <label>
                                                    Student Name :</label>
                                            </td>
                                            <td width="32%">
                                                <asp:TextBox ID="txtStudentName" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="11%">
                                                <label>
                                                    Class :</label>
                                            </td>
                                            <td width="20%">
                                             <asp:DropDownList ID="ddlClass" CssClass="" runat="server" AppendDataBoundItems="True"
                                                    onchange="GetSectionByClass(this.value);">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td width="10%">
                                                <label>
                                                    Section :</label>
                                            </td>
                                            <td width="32%">
                                                  <asp:DropDownList ID="ddlSection" CssClass="" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
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
                                <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="SearchAdmissionWithdrawal();">
                                    <span></span>Search</button>
                                &nbsp;
                                <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                    onclick="return Cancel();">
                                    <span></span>Cancel</button>
                                &nbsp;
                                <button id="btnAddNew" type="button" class="btn-icon btn-navy btn-add" style="display: none;"
                                    onclick="AddStudentInfo();">
                                    <span></span>Add New</button>
                                <asp:HiddenField ID="hfStudentID" runat="server" />
                                <asp:HiddenField ID="hfModuleID" runat="server" />
                            </td>
                        </tr>
                        <tr valign="top">
                            <td valign="top">
                                <asp:GridView ID="grdStudentSCInfo" runat="server" Width="100%" AutoGenerateColumns="False"
                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                    <Columns>
                                         <asp:BoundField HeaderText="SlNo" DataField="SlNo" HeaderStyle-CssClass="sorting_mod"
                                            ReadOnly="True" />
                                        <asp:BoundField HeaderText="Register No" DataField="Register No" HeaderStyle-CssClass="sorting_mod"
                                            ReadOnly="True" />
                                        <asp:BoundField HeaderText="Admission No" DataField="Admission No" HeaderStyle-CssClass="sorting_mod"
                                            ReadOnly="True" />
                                        <asp:BoundField HeaderText="Student Name" DataField="Student Name" HeaderStyle-CssClass="sorting_mod"
                                            ReadOnly="True" />
                                        <asp:BoundField HeaderText="Class" DataField="Class" HeaderStyle-CssClass="sorting_mod"
                                            ReadOnly="True" />
                                        <asp:BoundField HeaderText="Section" DataField="Section" HeaderStyle-CssClass="sorting_mod"
                                            ReadOnly="True" />
                                        <asp:BoundField HeaderText="Option" DataField="Option" HeaderStyle-CssClass="sorting_mod" />
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
    </div>
</asp:Content>
