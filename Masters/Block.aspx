<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Block.aspx.cs" Inherits="Block" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%-- <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>--%>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">

        $(function () {
            //        GetBlocks Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetBlock(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });



        //        GetBlocks Function

        function GetBlock(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Block.aspx/GetBlock",
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
            var blocks = xml.find("Blocks");
            var row = $("[id*=dgBlock] tr:last-child").clone(true);
            $("[id*=dgBlock] tr").not($("[id*=dgBlock] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditBlock('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteBlock('";
                danchorEnd = "');\">Delete</a>";
            }
            if (blocks.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("editacc edit-links");
                $("td", row).eq(2).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(3).html("");
                $("[id*=dgBlock]").append(row);
                row = $("[id*=dgBlock] tr:last-child").clone(true);

            }
            else {

                $.each(blocks, function () {
                    var block = $(this);
                    var ehref = eanchor + $(this).find("BlockID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("BlockID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("HostelName").text());
                    $("td", row).eq(1).html($(this).find("BlockName").text());
                    $("td", row).eq(2).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(3).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgBlock]").append(row);
                    row = $("[id*=dgBlock] tr:last-child").clone(true);
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
        // Delete Block
        function DeleteBlock(id) {
            var parameters = '{"BlockID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Block.aspx/DeleteBlock",
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

        function EditBlock(BlockID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/Block.aspx/EditBlock",
                    data: '{BlockID: ' + BlockID + '}',
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
            var blocks = xml.find("EditBlock");
            $.each(blocks, function () {
                var block = $(this);
                $("[id*=txtBlockName]").val($(this).find("BlockName").text());
                var HostelID = $(this).find("HostelID").text();

                $("[id*=ddlHostel] option[value='" + HostelID + "']").attr("selected", "true");

                $("[id*=hfBlockID]").val($(this).find("BlockID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save Block
        function SaveBlock() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfBlockID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfBlockID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var BlockID = $("[id*=hfBlockID]").val();
                    var BlockName = $("[id*=txtBlockName]").val();
                    var HostelID = $("[id*=ddlHostel]").val();
                    var parameters = '{"id": "' + BlockID + '","blockname": "' + BlockName + '","hostelid": "' + HostelID + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/Block.aspx/SaveBlock",
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
                GetBlock(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetBlock(1);
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
                GetBlock(parseInt(currentPage));
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
            GetBlock(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtBlockName]").val("");
            $("[id*=ddlHostel]").val("");
            $("[id*=hfBlockID]").val("");
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
                Block
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr>
                        <td colspan="2">
                            <div id="dvCashVoucher" style="float: left; width: 450px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Hostel Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:DropDownList ID="ddlHostel" CssClass="jsrequired" runat="server">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Block</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtBlockName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfBlockID" runat="server" />
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveBlock();">
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
                        <td>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2" valign="top">
                            <asp:GridView ID="dgBlock" runat="server" Width="100%" AutoGenerateColumns="false"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="HostelName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Hostel Name" SortExpression="HostelName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BlockName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Block Name" SortExpression="BlockName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("BlockID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("BlockID") %>'
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
