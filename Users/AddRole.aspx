<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage/AdminMaster.master"
    CodeFile="AddRole.aspx.cs" Inherits="Users_AddRole" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headTag" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript">
        $(function () {
            //        GetRoles Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetRoles(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetRoles(parseInt($(this).attr('page')));
        });

        $(document).ready(function () {
            $("[id*=txtRole]").keypress(function (e) {
                if (e.which == 13) {
                    return false;
                }
            });
        });

    </script>
    <%--Get Roles--%>
    <script type="text/javascript">
        function GetRoles(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Users/AddRole.aspx/GetRoles",
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
        //        GetRoles On Success Function
        //        Get Roles to Grid
        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var modules = xml.find("Roles");
            var row = $("[id*=dgRole] tr:last-child").clone(true);
            $("[id*=dgRole] tr").not($("[id*=dgRole] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditRole('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteRole('";
                danchorEnd = "');\">Delete</a>";
            }
            $.each(modules, function () {
                var module = $(this);
                var ehref = eanchor + $(this).find("RoleId").text() + eanchorEnd;
                var dhref = danchor + $(this).find("RoleId").text() + danchorEnd;
                row.addClass("even");
                $("td", row).eq(0).html($(this).find("RoleName").text());
                $("td", row).eq(1).html(ehref).addClass("editacc edit-links");
                $("td", row).eq(2).html(dhref).addClass("deleteacc delete-links");
                $("[id*=dgRole]").append(row);
                row = $("[id*=dgRole] tr:last-child").clone(true);
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
    <%--Edit Roles--%>
    <script type="text/javascript">
        function EditRole(roleId) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Users/AddRole.aspx/EditRole",
                    data: '{roleId: ' + roleId + '}',
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
            var modules = xml.find("EditRoles");
            $.each(modules, function () {
                var module = $(this);
                $("[id*=txtRole]").val($(this).find("RoleName").text());
                $("[id*=hfRoleId]").val($(this).find("RoleId").text());
                $("[id*=spSubmit]").html("Update");
            });
        };
    </script>
    <%--Save Roles--%>
    <script type="text/javascript">
        function SaveRole() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfRoleId]").val() == '') ||
            ($("[id*=hfViewPrm]").val() == 'true' && $("[id*=hfRoleId]").val() != '')
            ) {
                $("[id*=btnSubmit]").attr("disabled", "true");
                if ($('#aspnetForm').valid()) {
                    var roleId = $("[id*=hfRoleId]").val();
                    var roleName = $("[id*=txtRole]").val();
                    var parameters = '{"id": "' + roleId + '","name": "' + roleName + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Users/AddRole.aspx/SaveRole",
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

        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                GetRoles(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', "Inserted");
                GetRoles(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', "Insert");
                Cancel();
            }
            else if (response.d == "Exists") {
                AlertMessage('fail', "Role Name Already Exists");
                Cancel();
            }
        };
    </script>
    <%--Delete Roles--%>
    <script type="text/javascript">
        function DeleteRole(id) {
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    var parameters = '{"roleId": "' + id + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Users/AddRole.aspx/DeleteRole",
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

        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', "Deleted");
                GetRoles(parseInt(currentPage));
                Cancel();
            }
            else {
                AlertMessage('reference', response.d);
                Cancel();
            }
        };
    </script>
    <%--Cancel Roles--%>
    <script type="text/javascript">
        function Cancel() {
            $("[id*=txtRole]").val("");
            $("[id*=hfRoleId]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $("[id*=btnSubmit]").attr("disabled", false);
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
                Add Roles</h2>
            <div class="block ">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table class="form">
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Role
                                        </label>
                                    </td>
                                    <td class="col2">
                                        <input type="text" class="jsrequired letterswithspace" id="txtRole" />
                                        <%--<asp:TextBox ID="txtRole" runat="server" CssClass="jsrequired letterswithspace"></asp:TextBox>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveRole();">
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
                            <asp:HiddenField ID="hfRoleId" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="dgRole" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="RoleName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Role Name" SortExpression="RoleName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("RoleId") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("RoleId") %>'
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
        </div>
    </div>
</asp:Content>
