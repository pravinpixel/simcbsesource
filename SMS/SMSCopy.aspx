<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="SMSCopy.aspx.cs" Inherits="SMSCopy" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/maxlength.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript">
        $(function () {

            //        GetSMSCopy Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetSMSCopy(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);


        });


        //        GetSMSCopy Function

        function GetSMSCopy(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../SMS/SMSCopy.aspx/GetSMSCopy",
                    data: '{pageIndex: ' + pageIndex + '}',
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

        //        GetSMSCopy On Success Function
        //        Get SMSCopy to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var SMSCopys = xml.find("SMSCopys");
            var row = $("[id*=dgSMSCopy] tr:last-child").clone(true);
            $("[id*=dgSMSCopy] tr").not($("[id*=dgSMSCopy] tr:first-child")).remove();

            var danchor = ''
            var danchorEnd = '';

            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteSMSCopy('";
                danchorEnd = "');\">Delete</a>";
            }
            if (SMSCopys.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("deleteacc delete-links");
                $("[id*=dgSMSCopy]").append(row);
                row = $("[id*=dgSMSCopy] tr:last-child").clone(true);

            }
            else {

                $.each(SMSCopys, function () {
                    var SMSCopy = $(this);

                    var dhref = danchor + $(this).find("StaffID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("StaffName").text());
                    $("td", row).eq(1).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgSMSCopy]").append(row);
                    row = $("[id*=dgSMSCopy] tr:last-child").clone(true);
                });
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
        // Delete SMSCopy
        function DeleteSMSCopy(StaffID) {
            var parameters = '{"StaffID": "' + StaffID + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../SMS/SMSCopy.aspx/DeleteSMSCopy",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteSuccess,
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



        // Save SMSCopy
        function SaveSMSCopy() {
            if ($("[id*=hfDeletePrm]").val() == 'true') {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var staff = "";
                    var staffID = "";
                    $(".checkboxlist").find("input:checkbox").each(function () {
                        if ($(this).is(':checked')) {
                            if (staff == "") {
                                staff = $(this).parent().attr('Staffs');

                            }
                            else {
                                staff = staff + "," + $(this).parent().attr('Staffs');
                            }
                        }

                    });
                    staffID = staff;
                    staff = "";
                    var parameters = '{"staffID": "' + staffID + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../SMS/SMSCopy.aspx/SaveSMSCopy",
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
            else {
                return false;
            }
        }

        // Save On Success
        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                $(".checkboxlist").find("input:checkbox").each(function () {
                    $(this).attr("checked", false);
                });

                GetSMSCopy(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                $(".checkboxlist").find("input:checkbox").each(function () {
                    $(this).attr("checked", false);
                });

                GetSMSCopy(1);
                Cancel();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                Cancel();
            }
            else {
                AlertMessage('fail', response.d);
                Cancel();
            }
        };


        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetSMSCopy(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
                Cancel();
            }
            else {
                AlertMessage('reference', response.d);
                Cancel();
            }
        };

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetSMSCopy(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=btnSubmit]").attr('disabled', false);
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $(".checkboxlist").find("input:checkbox").each(function () {
                $(this).attr("checked", false);
            });
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                SMS Copy To</h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 650px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td valign="top" class="col1">
                                            <label>
                                                SMS Copy To</label>
                                        </td>
                                        <td align="left">
                                            <div align="left" style="overflow: auto; height: 170px; width: 268px">
                                                <table>
                                                    <tr>
                                                        <td class="col2">
                                                            <asp:CheckBoxList ID="chkStaff" CssClass="checkboxlist" runat="server" RepeatColumns="1">
                                                            </asp:CheckBoxList>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveSMSCopy();">
                                                <span></span>
                                                <div id="spSubmit">
                                                    Save</div>
                                            </button>
                                            <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                onclick="return Cancel();">
                                                <span></span>Cancel</button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top" colspan="2">
                            <asp:GridView ID="dgSMSCopy" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="StaffName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Staff Name" SortExpression="StaffName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StaffID") %>'
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
            <div class="clear">
            </div>
        </div>
    </div>
</asp:Content>
