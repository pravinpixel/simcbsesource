<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Uniform.aspx.cs" Inherits="Uniform" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtEntryDate]");
        });
    </script>
    <script type="text/javascript">

        $(function () {
            //        GetUniform Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetUniform(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetUniform Function

        function GetUniform(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Uniform.aspx/GetUniform",
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

        //        GetUniform On Success Function
        //        Get Uniform to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Uniforms = xml.find("Uniforms");
            var row = $("[id*=dgUniform] tr:last-child").clone(true);
            $("[id*=dgUniform] tr").not($("[id*=dgUniform] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditUniform('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteUniform('";
                danchorEnd = "');\">Delete</a>";
            }
            if (Uniforms.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("No Records Found").attr("align", "left");
                $("td", row).eq(7).html("").removeClass("editacc edit-links");
                $("td", row).eq(8).html("").removeClass("deleteacc delete-links");
                $("[id*=dgUniform]").append(row);
                row = $("[id*=dgUniform] tr:last-child").clone(true);

            }
            else {
                $.each(Uniforms, function () {
                    var Uniform = $(this);
                    var ehref = eanchor + $(this).find("UniformId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("UniformId").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("ClassName").text());
                    $("td", row).eq(1).html($(this).find("BoysCnt").text());
                    $("td", row).eq(2).html($(this).find("GirlsCnt").text());
                    $("td", row).eq(3).html($(this).find("BoysRate").text());
                    $("td", row).eq(4).html($(this).find("GirlsRate").text());
                    $("td", row).eq(5).html($(this).find("TotalRate").text());
                    $("td", row).eq(6).html($(this).find("Quantity").text());
                    $("td", row).eq(7).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(8).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgUniform]").append(row);
                    row = $("[id*=dgUniform] tr:last-child").clone(true);
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
        // Delete Uniform
        function DeleteUniform(id) {
            var parameters = '{"UniformID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Uniform.aspx/DeleteUniform",
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

        function EditUniform(UniformID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/Uniform.aspx/EditUniform",
                    data: '{UniformID: ' + UniformID + '}',
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
            var Uniform = xml.find("EditUniform");
            $.each(Uniform, function () {
                var Uniform = $(this);
                var ClassID = $(this).find("ClassId").text();
                $("[id*=ddlClass] option[value='" + ClassID + "']").attr("selected", "true");
                $("[id*=txtBoysCnt]").val($(this).find("BoysCnt").text());
                $("[id*=txtGirlsCnt]").val($(this).find("GirlsCnt").text());
                $("[id*=txtBoysRate]").val($(this).find("BoysRate").text());
                $("[id*=txtGirlsRate]").val($(this).find("GirlsRate").text());
                $("[id*=txtTotalRate]").val($(this).find("TotalRate").text());
                $("[id*=txtQty]").val($(this).find("Quantity").text());
                $("[id*=hfUniformID]").val($(this).find("UniformId").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save Uniform
        function SaveUniform() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfUniformID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfUniformID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var UniformID = $("[id*=hfUniformID]").val();
                    var ClassID = $("[id*=ddlClass]").val();
                    var EntryDate = $("[id*=txtEntryDate]").val();
                    var BoysCnt = $("[id*=txtBoysCnt]").val();
                    var GirlsCnt = $("[id*=txtGirlsCnt]").val();
                    var BoysRate = $("[id*=txtBoysRate]").val();
                    var GirlsRate = $("[id*=txtGirlsRate]").val();
                    var TotalRate = $("[id*=txtTotalRate]").val();
                    var Qty = $("[id*=txtQty]").val();
                    var parameters = '{"id": "' + UniformID + '","classid": "' + ClassID + '","boyscnt": "' + BoysCnt + '","girlscnt": "' + GirlsCnt + '","boysrate": "' + BoysRate + '","girlsrate": "' + GirlsRate + '","totalrate": "' + TotalRate + '","qty": "' + Qty + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/Uniform.aspx/SaveUniform",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                            $("[id*=btnSubmit]").attr("disabled", "false");
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                            $("[id*=btnSubmit]").attr("disabled", "false");
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
                GetUniform(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetUniform(1);
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
                GetUniform(parseInt(currentPage));
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
            GetUniform(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=ddlClass]").val("");
            $("[id*=txtEntryDate]").val("");
            $("[id*=txtBoysCnt]").val("");
            $("[id*=txtGirlsCnt]").val("");
            $("[id*=txtBoysRate]").val("");
            $("[id*=txtGirlsRate]").val("");
            $("[id*=txtTotalRate]").val("");
            $("[id*=txtQty]").val("");
            $("[id*=hfUniformID]").val("");
            $("[id*=btnSubmit]").attr("disabled", "false");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
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
                Uniform
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 650px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Class</label>
                                        </td>
                                        <td class="col2">
                                            <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AutoPostBack="True"
                                                OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                                <asp:ListItem Selected="True" Value="0">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="3">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Boys Count</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtBoysCnt" CssClass="jsrequired numericswithdecimals" runat="server"
                                                Enabled="False" OnTextChanged="txtBoysCnt_TextChanged"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Girls Count</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtGirlsCnt" CssClass="jsrequired numericswithdecimals" runat="server"
                                                Enabled="False" OnTextChanged="txtGirlsCnt_TextChanged"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Boys Tender Unit Rate</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtBoysRate" CssClass="jsrequired numericswithdecimals" runat="server"
                                                AutoPostBack="True" OnTextChanged="txtBoysRate_TextChanged"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Girls Tender Unit Rate</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtGirlsRate" CssClass="jsrequired numericswithdecimals" runat="server"
                                                AutoPostBack="True" OnTextChanged="txtGirlsRate_TextChanged"></asp:TextBox>
                                        </td>
                                    </tr>
                                      <tr>
                                        <td class="col1">
                                            <label>
                                                Qty Per Student</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtQty" CssClass="jsrequired numericswithdecimals" 
                                                runat="server" ontextchanged="txtQty_TextChanged" AutoPostBack="True"></asp:TextBox>
                                        </td>
                                        <td colspan="3">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Total Rate</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtTotalRate" CssClass="jsrequired numericswithdecimals" runat="server"
                                                Enabled="False" ReadOnly="True"></asp:TextBox>
                                        </td>
                                        <td colspan="3">
                                        </td>
                                    </tr>
                                  
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfUniformID" runat="server" />
                                        </td>
                                        <td colspan="4">
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveUniform();">
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
                            <asp:GridView ID="dgUniform" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="ClassName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Class Name" SortExpression="ClassName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BoysCnt" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Boys Cnt" SortExpression="BoysCnt">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="GirlsCnt" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Girls Cnt" SortExpression="GirlsCnt">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BoysRate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Boys Rate" SortExpression="BoysRate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="GirlsRate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Girls Rate" SortExpression="GirlsRate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="TotalRate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Total Rate" SortExpression="TotalRate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Quantity" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Quantity" SortExpression="Quantity">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("UniformID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("UniformID") %>'
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
