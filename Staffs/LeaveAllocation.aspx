<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="LeaveAllocation.aspx.cs" Inherits="Staffs_LeaveAllocation" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <style type="text/css">
        .highlight
        {
            background: #A7A4A4;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

        });


        function GetList(pageIndex) {
            var PlaceofworkID = $("[id*=ddlPlaceofwork]").val();
            var LeaveID = $("[id*=ddlLeave]").val();
            $.ajax({
                type: "POST",
                url: "../Staffs/LeaveAllocation.aspx/GetStaffList",
                data: '{"PlaceofworkID":"' + PlaceofworkID + '","LeaveID":"' + LeaveID + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetStaffListSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }
        function OnGetStaffListSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var sList = xml.find("StaffList");
            var row = $("[id*=dgStaffList] tr:last-child").clone(true);
            $("[id*=dgStaffList] tr").not($("[id*=dgStaffList] tr:first-child")).remove();
            if (sList.length > 0) {

                $.each(sList, function () {
                    var inp = "<input type='text' value=\"" + $(this).find("Accumulated").text() + "\" id=\"" + $(this).find("StaffID").text() + "\"  style=\"width:75px;\" class=\"Accumulated\">";
                    var inp1 = "<input type='text' value=\"" + $(this).find("AvailableLeave").text() + "\" id=\"" + $(this).find("StaffID").text() + "\"  style=\"width:75px;\" class=\"AvailableLeave\">";
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("StaffID").text()).addClass("StaffID");
                    $("td", row).eq(1).html($(this).find("EmpCode").text()).addClass("EmpCode");
                    $("td", row).eq(2).html($(this).find("StaffName").text()).addClass("StaffName");
                    $("td", row).eq(3).html(inp);
                    $("td", row).eq(4).html(inp1);
                    $("[id*=dgStaffList]").append(row);
                    row = $("[id*=dgStaffList] tr:last-child").clone(true);
                });
            }
            else {
                row.addClass("even");
                $("td", row).eq(0).html('').removeClass("StaffID");
                $("td", row).eq(1).html('No records found').removeClass("EmpCode");
                $("td", row).eq(2).html('').removeClass("StaffName");
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('');
                $("[id*=dgStaffList]").append(row);
                row = $("[id*=dgStaffList] tr:last-child").clone(true);
            }

            if ($("[id*=hfEditPrm]").val() == 'false') {
                $('.editacc').hide();
            }
            else {
                $('.editacc').show();
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
                        nxtIdx = $inp.index($('.' + arr.split(' ')[0] + '').first());
                    }
                    $(":input:text:eq(" + nxtIdx + ")").focus();
                    $(":input:text:eq(" + nxtIdx + ")").closest('tr').addClass('highlight');
                }
            });
            $("input[type=text]").blur(function () {
                $(this).closest('tr').removeClass('highlight');
            });



        };


        function UpdateAllocation() {
        if ($("[id*=hfAddPrm]").val() == 'true') {
            var LeaveDetails = new Array();
            $(".even").each(function () {
                var LeaveID = $("[id*=ddlLeave]").val();
                var StaffID = $(this).find('td.StaffID').html();
                var Accumulated = $(this).find('input.Accumulated').val();
                var AvailableLeave = $(this).find('input.AvailableLeave').val();
                var AcademicID = $("[id*=hfAcademicID]").val();
                if (Accumulated == "" || Accumulated == null) {
                    Accumulated = "0";
                }
                if (AvailableLeave == "" || AvailableLeave == null) {
                    AvailableLeave = "0";
                }

                LeaveDetails.push({ "LeaveID": "" + $("[id*=ddlLeave]").val() + "", "StaffID": "" + StaffID + "", "Accumulated": "" + Accumulated + "", "AvailableLeave": "" + AvailableLeave + "", "AcademicID": "" + $("[id*=hfAcademicID]").val() + "", "userId": "" + $("[id*=hfUserId]").val() + "" });
            });

            var parameters = JSON.stringify({ leavelist: LeaveDetails });

            $.ajax({
                type: "POST",
                url: "../Staffs/LeaveAllocation.aspx/UpdateAllocation",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnUpdateAllocationSuccess,
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
        function OnUpdateAllocationSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                GetList(1);
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <asp:HiddenField ID="hfAcademicID" runat="server" />
    <asp:HiddenField ID="hfval" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Staff Leave Allocation
            </h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2" id="">
                <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                    <table class="form" width="100%">
                        <tr valign="top">
                            <td valign="top">
                                <div id="dvLeavAllocationAssigner" style="float: left; margin: 0 auto; width: 780px;"
                                    runat="server">
                                    <asp:UpdatePanel ID="ups" runat="server">
                                        <ContentTemplate>
                                            <table class="form" cellpadding="0" cellspacing="0">
                                                <tr align="left">
                                                    <td width="30%" height="30">
                                                        <label>
                                                            Place Of Work :</label>
                                                        <asp:DropDownList ID="ddlPlaceofwork" runat="server" AppendDataBoundItems="True">
                                                            <asp:ListItem Value="">-----Select-----</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td width="50%" height="30">
                                                        <label>
                                                            Leave Type :</label>
                                                        <asp:DropDownList ID="ddlLeave" runat="server" AppendDataBoundItems="True">
                                                            <asp:ListItem Value="">-----Select-----</asp:ListItem>
                                                        </asp:DropDownList>
                                                        <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetList(1);">
                                                            <span></span>
                                                            <div id="spFeesSubmit">
                                                                Search</div>
                                                        </button>
                                                        <button id="btnUpdate" type="button" class="btn-icon btn-orange btn-saving" onclick="UpdateAllocation();">
                                                            <span></span>
                                                            <div>
                                                                Update</div>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="ddlPlaceofwork" EventName="SelectedIndexChanged" />
                                             <asp:AsyncPostBackTrigger ControlID="ddlLeave" EventName="SelectedIndexChanged" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:GridView ID="dgStaffList" runat="server" Width="100%" AutoGenerateColumns="False"
                                    ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even" AlternatingRowStyle-CssClass="odd"
                                    EnableModelValidation="True" CssClass="display">
                                    <Columns>
                                        <asp:BoundField DataField="StaffID" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                            HeaderText="StaffID" SortExpression="StaffID">
                                            <ItemStyle HorizontalAlign="Center" CssClass="StaffID"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="EmpCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                            HeaderText="EmpCode" SortExpression="EmpCode">
                                            <ItemStyle HorizontalAlign="Center" CssClass="EmpCode"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="StaffName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                            HeaderText="StaffName" SortExpression="StaffName">
                                            <ItemStyle HorizontalAlign="Center" CssClass="StaffName"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Accumulated" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                            HeaderText="Accumulated" SortExpression="Accumulated">
                                            <ItemStyle HorizontalAlign="Center" CssClass="StaffName"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="AvailableLeave" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                            HeaderText="CurrentYear Leave" SortExpression="AvailableLeave">
                                            <ItemStyle HorizontalAlign="Center" CssClass="StaffName"></ItemStyle>
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="Pager" id="GetListPager">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
