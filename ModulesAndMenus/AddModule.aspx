<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AddModule.aspx.cs" Inherits="ModulesAndMenus_AddModule" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headTag" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <%--On load--%>
    <script type="text/javascript">

        $(function () {
            //        GetModules Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetModules(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });
        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetModules(parseInt($(this).attr('page')));
        });
    </script>
    <%--Get Modules--%>
    <script type="text/javascript">
        function GetModules(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddModule.aspx/GetModules",
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
            var modules = xml.find("Modules");
            var row = $("[id*=dgModule] tr:last-child").clone(true);
            $("[id*=dgModule] tr").not($("[id*=dgModule] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditModule('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteModule('";
                danchorEnd = "');\">Delete</a>";
            }
            $.each(modules, function () {
                var module = $(this);
                var ehref = eanchor + $(this).find("ModuleId").text() + eanchorEnd;
                var dhref = danchor + $(this).find("ModuleId").text() + danchorEnd;
                row.addClass("even");
                $("td", row).eq(0).html($(this).find("ModuleName").text());
                $("td", row).eq(1).html($(this).find("Description").text());
                $("td", row).eq(2).html($(this).find("ModulePath").text());
                $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                $("[id*=dgModule]").append(row);
                row = $("[id*=dgModule] tr:last-child").clone(true);
            });

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
    </script>
    <%--Edit Modules--%>
    <script type="text/javascript">
        function EditModule(moduleId) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddModule.aspx/EditModules",
                    data: '{moduleId: ' + moduleId + '}',
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

        function OnEditSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var modules = xml.find("EditModules");
            $.each(modules, function () {
                var module = $(this);
                $("[id*=txtModuleName]").val($(this).find("ModuleName").text());
                $("[id*=txtDescription]").val($(this).find("Description").text());
                $("[id*=txtModulePath]").val($(this).find("ModulePath").text());
                $("[id*=hfModuleId]").val($(this).find("ModuleId").text());
                $("[id*=spSubmit]").html("Update");
            });
        };
    </script>
    <%--Save Modules--%>
    <script type="text/javascript">
        // Save Module
        function SaveModule() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfModuleId]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfModuleId]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var moduleId = $("[id*=hfModuleId]").val();
                    var moduleName = $("[id*=txtModuleName]").val();
                    var moduleDescription = $("[id*=txtDescription]").val();
                    var modulePath = $("[id*=txtModulePath]").val();
                    var parameters = '{"id": "' + moduleId + '","name": "' + moduleName + '","description": "' + moduleDescription + '","path": "' + modulePath + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../ModulesAndMenus/AddModule.aspx/SaveModule",
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
                else {
                    return false;
                }
            }
        }

        // Save On Success
        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                GetModules(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', "Inserted");
                GetModules(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', "Inserte");
                Cancel();
            }
            else if (response.d == "Exists") {
                AlertMessage('reference', "Module Name Already Exists");
                Cancel();
            }
        }
    </script>
    <%--Delete Modules--%>
    <script type="text/javascript">
        function DeleteModule(id) {
            if ($("[id*=hfDeletePrm]").val() == 'true') {
                if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                    if (r) {
                        var parameters = '{"moduleId": "' + id + '"}';
                        $.ajax({
                            type: "POST",
                            url: "../ModulesAndMenus/AddModule.aspx/DeleteModule",
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
            else
                return false;
        }
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', "Deleted");
                GetModules(parseInt(currentPage));
                Cancel();
            }
            else {
                AlertMessage('reference', response.d);
                Cancel();
            }
        };

    </script>
    <%--Cancel controls--%>
    <script type="text/javascript">
        function Cancel() {
            $("[id*=txtModuleName]").val("");
            $("[id*=txtDescription]").val("");
            $("[id*=txtModulePath]").val("");
            $("[id*=hfModuleId]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").val("Save");
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
        <div class="box round first">
            <h2>
                Add Module</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table class="form">
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Module Name</label>
                                    </td>
                                    <td class="col2">
                                        <asp:TextBox ID="txtModuleName" CssClass="jsrequired letterswithbasicpunc" runat="server"></asp:TextBox>
                                    </td>
                                    <td rowspan="3">
                                        <div class="block">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Description</label>
                                    </td>
                                    <td class="col2">
                                        <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Module Path</label>
                                    </td>
                                    <td class="col2">
                                        <asp:TextBox ID="txtModulePath" CssClass="jsrequired" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveModule();">
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
                            <asp:HiddenField ID="hfModuleId" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="dgModule" runat="server" Width="100%" AutoGenerateColumns="False"
                                GridLines="None" AllowPaging="True" ShowFooter="True" HorizontalAlign="Center"
                                RowStyle-CssClass="even" AlternatingRowStyle-CssClass="odd" EnableModelValidation="True"
                                CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="ModuleName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Module" SortExpression="ModuleName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Description" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Description" SortExpression="Description">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ModulePath" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Module Path" SortExpression="ModulePath">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="editacc sorting_mod">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("ModuleId") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="deleteacc sorting_mod">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("ModuleId") %>'
                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <br />
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
</asp:Content>
