<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Designation.aspx.cs" Inherits="Designation" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript">

        $(function () {
            //        GetDesignation Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetDesignation(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetDesignation Function

        function GetDesignation(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Designation.aspx/GetDesignation",
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

        //        GetDesignation On Success Function
        //        Get Designation to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Designations = xml.find("Designations");
            var row = $("[id*=dgDesignation] tr:last-child").clone(true);
            $("[id*=dgDesignation] tr").not($("[id*=dgDesignation] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditDesignation('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteDesignation('";
                danchorEnd = "');\">Delete</a>";
            }
            if (Designations.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("editacc edit-links");
                $("td", row).eq(2).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(3).html("");
                $("[id*=dgDesignation]").append(row);
                row = $("[id*=dgDesignation] tr:last-child").clone(true);

            }
            else {
                $.each(Designations, function () {
                    var Designation = $(this);
                    var ehref = eanchor + $(this).find("DesignationID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("DesignationID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("DesignationName").text());
                    $("td", row).eq(1).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(2).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgDesignation]").append(row);
                    row = $("[id*=dgDesignation] tr:last-child").clone(true);
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
        // Delete Designation
        function DeleteDesignation(id) {
            var parameters = '{"DesignationID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Designation.aspx/DeleteDesignation",
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

        function EditDesignation(DesignationID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/Designation.aspx/EditDesignation",
                    data: '{DesignationID: ' + DesignationID + '}',
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
            var Designation = xml.find("EditDesignation");
            $.each(Designation, function () {
                var Designation = $(this);
                $("[id*=txtDesignationName]").val($(this).find("DesignationName").text());
                $("[id*=hfDesignationID]").val($(this).find("DesignationID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save Designation
        function SaveDesignation() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfDesignationID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfDesignationID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var DesignationID = $("[id*=hfDesignationID]").val();
                    var DesignationName = $("[id*=txtDesignationName]").val();
                    var parameters = '{"id": "' + DesignationID + '","name": "' + DesignationName + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/Designation.aspx/SaveDesignation",
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
                GetDesignation(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetDesignation(1);
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
                GetDesignation(parseInt(currentPage));
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
            GetDesignation(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtDesignationName]").val("");
            $("[id*=hfDesignationID]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $("[id*=btnSubmit]").attr("disabled", "false");
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
                Designation
            </h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 550px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Designation Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtDesignationName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfDesignationID" runat="server" />
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveDesignation();">
                                                <span></span><div  id="spSubmit">Save</div></button>
                                            <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                onclick="return Cancel();">
                                                <span></span>Cancel</button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2" valign="top">
                            <asp:GridView ID="dgDesignation" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="DesignationName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Designation Name" SortExpression="DesignationName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("DesignationID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("DesignationID") %>'
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
