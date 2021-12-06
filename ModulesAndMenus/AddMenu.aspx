<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AddMenu.aspx.cs" Inherits="AddMenu" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <%--On Load--%>
    <script type="text/javascript">
        $(function () {
            //        GetMenu Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetMenu(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetMenu(parseInt($(this).attr('page')));
        });
       
    </script>
    <%--Get Menu --%>
    <script type="text/javascript">
        //        GetMenu Function
        function GetMenu(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddMenu.aspx/GetMenu",
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
        //        GetMenu On Success Function
        //        Get Modules to Grid
        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Menus");
            var row = $("[id*=dgMenu] tr:last-child").clone(true);
            $("[id*=dgMenu] tr").not($("[id*=dgMenu] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditMenu('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteMenu('";
                danchorEnd = "');\">Delete</a>";
            }
            $.each(menus, function () {
                var modules = $(this);
                var ehref = eanchor + $(this).find("MenuId").text() + eanchorEnd;
                var dhref = danchor + $(this).find("MenuId").text() + danchorEnd;
                row.addClass("even");
                $("td", row).eq(0).html($(this).find("ParentMenuName").text());
                $("td", row).eq(1).html($(this).find("MenuName").text());
                $("td", row).eq(2).html($(this).find("Description").text());
                $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                $("[id*=dgMenu]").append(row);
                row = $("[id*=dgMenu] tr:last-child").clone(true);
            });


            emptyDittoCells($("[id*=dgMenu]"));

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

        function emptyDittoCells(table) {
            if (!(table instanceof jQuery && table.is("table")))
                throw "bad parameter";

            table.find('tr').each(function (rowElement) {
                var row = $(rowElement);
                var previousRow = $(rowElement).prev('tr');
                if (!previousRow.length) return;

                row.each(function (cellElement, index) {
                    var cell = $(cellElement);
                    var previousCell = previousRow.children("td:nth-child(" + index + ")");

                    while (previousCell.data('ditto')) {
                        previousCell = previousCell.data('ditto');
                    }

                    if (hasSameContents(cell, previousCell)) {
                        cell.empty()
                    .data('ditto', previousCell);
                    }
                });
            });
        }

        function hasSameContents(a, b) {
            return (a.text() == b.text()); // naive but usable in the simple case
        }
    </script>
    <%--Edit Menu--%>
    <script type="text/javascript">
        //        Edit Function
        function EditMenu(menuId) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddMenu.aspx/EditMenus",
                    data: '{menuId: ' + menuId + '}',
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
            var menus = xml.find("EditMenus");

            $.each(menus, function () {

                var menu = $(this);

                $("[id*=txtMenuName]").val($(this).find("MenuName").text());
                $("[id*=txtDescription]").val($(this).find("Description").text());
                $("[id*=dpMenu] option[value='" + $(this).find("ParentId").text() + "']").attr("selected", "true");
                $("[id*=hfMenuId]").val($(this).find("MenuId").text());
                $("[id*=spSubmit]").html("Update");
            });
        };
    </script>
    <%--Save Menu--%>
    <script type="text/javascript">
        // Save Module
        function SaveMenu() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfMenuId]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfMenuId]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var menuId = $("[id*=hfMenuId]").val();
                    var menuName = $("[id*=txtMenuName]").val();
                    var menuDescription = $("[id*=txtDescription]").val();
                    var parentId = $("[id*=dpMenu]").val();
                    var userId = $("[id*=hfuserid]").val();
                    var parameters = '{"id": "' + menuId + '","name": "' + menuName + '","description": "' + menuDescription + '","parentId": "' + parentId + '","userId": "' + userId + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../ModulesAndMenus/AddMenu.aspx/SaveMenu",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveSuccess,
                        failure: function (response) {
                            AlertMessage('info', response.d);
                            $("[id*=btnSubmit]").attr("disabled", false);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                            $("[id*=btnSubmit]").attr("disabled", false);
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
                AlertMessage('success', "Updated");
                GetMenu(parseInt(currentPage));
                GetMenuDropDown();
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', "Inserted");
                GetMenu(parseInt(currentPage));
                GetMenuDropDown();
                Cancel();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', "Insert");
                Cancel();
            }
            else if (response.d == "Exists") {
                AlertMessage('reference', "Menu Name Already Exists");
                Cancel();
            }
        }

        function GetMenuDropDown() {
            $.ajax({
                type: "POST",
                url: "../ModulesAndMenus/AddMenu.aspx/GetMenuDropDown",
                data: '',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnReloadSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnReloadSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("DropDownMenus");
            if (menus.length > 0) {
                var select = $("[id*=dpMenu]");
                select.children().remove();
                select.append($("<option>").val('').text('----Select Menu----'));
                $.each(menus, function () {
                    var submenu = $(this);
                    var menuId = $(this).find("MenuId").text();
                    var menuName = $(this).find("MenuName").text();
                    select.append($("<option>").val(menuId).text(menuName));
                });
            }
        }
    </script>
    <%--Delete Menu--%>
    <script type="text/javascript">
        // Delete Module
        function DeleteMenu(id) {

            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    var parameters = '{"menuId": "' + id + '","userId": "' + $("[id*=hfuserid]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../ModulesAndMenus/AddMenu.aspx/DeleteMenu",
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

        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', "Deleted");
                GetMenu(parseInt(currentPage));
                GetMenuDropDown();
                Cancel();
            }
            else {
                AlertMessage('reference', response.d);
                Cancel();
            }
        };
    </script>
    <%--Cancel Control--%>
    <script type="text/javascript">
        function Cancel() {
            $("[id*=txtMenuName]").val("");
            $("[id*=txtDescription]").val("");
            $("[id*=dpMenu]").val("");
            $("[id*=hfMenuId]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            txtMenuName.attr("disabled", "false");
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
                Add Menu</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table class="form">
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Menu Name</label>
                                    </td>
                                    <td class="col2">
                                        <asp:TextBox ID="txtMenuName" CssClass="jsrequired letterswithbasicpunc txtChange" runat="server"></asp:TextBox>
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
                                            Parent Menu</label>
                                    </td>
                                    <td class="col2">
                                        <asp:DropDownList Width="200" ID="dpMenu" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <button id="btnSubmit" type="button" class="btn-icon btn btn-orange btn-saving" value="Save"
                                            onclick="SaveMenu();">
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
                            <asp:HiddenField ID="hfMenuId" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="dgMenu" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="ParentMenuName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Parent Menu" SortExpression="ParentMenuName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MenuName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Menu Name" SortExpression="MenuName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Description" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Description" SortExpression="Description">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("MenuId") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("MenuId") %>'
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
