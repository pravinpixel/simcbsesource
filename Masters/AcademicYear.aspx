<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="AcademicYear.aspx.cs" Inherits="AcademicYear" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>--%>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtStartDate]");
            setDatePicker("[id*=txtEndDate]");
        });
        function showDiv() {

            if (document.getElementById('rbtnCashType').checked == true) {
                $(".desc").hide("slow");
            }
            if (document.getElementById('rbtnChequeType').checked == true) {
                $(".desc").show("slow");
            }
        }

        
    </script>
    <script type="text/javascript">
        $(function () {
            //        GetAcademicYears Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetAcademicYear(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetAcademicYears Function

        function GetAcademicYear(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/AcademicYear.aspx/GetAcademicYear",
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



        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var academicyears = xml.find("AcademicYears");
            var row = $("[id*=dgAcademicYear] tr:last-child").clone(true);
            $("[id*=dgAcademicYear] tr").not($("[id*=dgAcademicYear] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditAcademicYear('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteAcademicYear('";
                danchorEnd = "');\">Delete</a>";
            }
            if (academicyears.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("editacc edit-links");
             //   $("td", row).eq(2).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(3).html("")
                $("[id*=dgAcademicYear]").append(row);
                row = $("[id*=dgAcademicYear] tr:last-child").clone(true);

            }
            else {

                $.each(academicyears, function () {
                    var academicyear = $(this);
                    var ehref = eanchor + $(this).find("AcademicID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("AcademicID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("StartDate").text());
                    $("td", row).eq(1).html($(this).find("EndDate").text());
                    $("td", row).eq(2).html(ehref).addClass("editacc edit-links");
                   // $("td", row).eq(3).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgAcademicYear]").append(row);
                    row = $("[id*=dgAcademicYear] tr:last-child").clone(true);
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
        // Delete AcademicYear
        function DeleteAcademicYear(id) {
            var parameters = '{"AcademicID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/AcademicYear.aspx/DeleteAcademicYear",
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

        //        Edit Function

        function EditAcademicYear(AcademicID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/AcademicYear.aspx/EditAcademicYear",
                    data: '{AcademicID: ' + AcademicID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditSuccess,
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

        //        Edit On Success Function

        function OnEditSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var academicyears = xml.find("EditAcademicYear");
            $.each(academicyears, function () {
                var academicyear = $(this);
                $("[id*=txtStartDate]").val($(this).find("StartDate").text());
                $("[id*=txtEndDate]").val($(this).find("EndDate").text());
                $("[id*=hfAcademicID]").val($(this).find("AcademicID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save AcademicYear
        function SaveAcademicYear() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfAcademicID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfAcademicID]").val() != '')
            ) {

                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var AcademicID = $("[id*=hfAcademicID]").val();
                    var startdate = $("[id*=txtStartDate]").val();
                    var enddate = $("[id*=txtEndDate]").val();
                    var parameters = '{"id": "' + AcademicID + '","startdate": "' + startdate + '","enddate": "' + enddate + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/AcademicYear.aspx/SaveAcademicYear",
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
                GetAcademicYear(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetAcademicYear(1);
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

                GetAcademicYear(parseInt(currentPage));
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
            GetAcademicYear(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtStartDate]").val("");
            $("[id*=txtEndDate]").val("");
            $("[id*=hfAcademicID]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $("[id*=btnSubmit]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
        function CheckDate() {

            var date1 = $("[id*=txtStartDate]").val();
            var date2 = $("[id*=txtEndDate]").val();
            if (date1 != "" && date2 != "") {
                if ($.datepicker.parseDate('dd/mm/yy', date2) < $.datepicker.parseDate('dd/mm/yy', date1)) {
                    AlertMessage('info', 'StartDate should be lesser than EndDate !!!');
                    $("[id*=txtStartDate]").val("");
                    $("[id*=txtEndDate]").val("");
                }
            }

        };       
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Academic Year
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 350px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Start Date</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtStartDate" CssClass="jsrequired dateNL date-picker" onchange="CheckDate();"
                                                runat="server"></asp:TextBox>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                End Date</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtEndDate" CssClass="jsrequired dateNL date-picker" onchange="CheckDate();"
                                                runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfAcademicID" runat="server" />
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveAcademicYear();">
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
                            <asp:GridView ID="dgAcademicYear" runat="server" Width="100%" AutoGenerateColumns="false"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="StartDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Start Date" SortExpression="StartDate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EndDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="End Date" SortExpression="EndDate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("AcademicID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="edit-links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                   <%-- <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("AcademicID") %>'
                                                CommandName="Delete" CausesValidation="false" CssClass="links "></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
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
