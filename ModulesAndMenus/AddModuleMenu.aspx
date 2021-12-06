<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
      CodeFile="AddModuleMenu.aspx.cs" Inherits="ModulesAndMenus_AddModuleMenu" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        
    </style>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
           
        });
</script>
    <%--Function Load--%>
    <script type="text/javascript">
        var flag = '';
        $(function () {
            // GetModuleMenu Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetModuleMenu(1, $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

        });

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetModuleMenu(parseInt($(this).attr('page')), $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());

        });

//        function groupTable($rows, startIndex, total) {
//            debugger
//            if (total === 0) {
//                return;
//            }
//            var i, currentIndex = startIndex, count = 1, lst = [];
//            var tds = $rows.find('td:eq(' + currentIndex + ')');
//            var ctrl = $(tds[0]);
//            lst.push($rows[0]);
//            for (i = 1; i <= tds.length; i++) {
//                if (ctrl.text() == $(tds[i]).text()) {
//                    count++;
//                    $(tds[i]).addClass('removed');
//                    lst.push($rows[i]);
//                }
//                else {
//                    if (count > 1) {
//                        ctrl.attr('rowspan', count);
//                        groupTable($(lst), startIndex + 1, total - 1)
//                    }
//                    count = 1;
//                    lst = [];
//                    ctrl = $(tds[i]);
//                    lst.push($rows[i]);
//                }
//            }
//        }
      
    </script>
    <%--Get Module Menu--%>
    <script type="text/javascript">
        function GetModuleMenu(pageIndex, val, pVal) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var parameters = '{"pageIndex": "' + pageIndex + '","menuId":"' + val + '","pMenuId":"' + pVal + '"}';
                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddModuleMenu.aspx/GetModuleMenu",
                    data: parameters,
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
        //        GetModuleMenu On Success Function
        //        Get Modules to Grid
        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("ModuleMenus");
            var row = $("[id*=dgModuleMenu] tr:last-child").clone(true);
            $("[id*=dgModuleMenu] tr").not($("[id*=dgModuleMenu] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var eanchormid = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:ChangeStatus('";
                eanchormid = "');\">";
                eanchorEnd = "</a>";
            }
            if (menus.length > 0) {
                
                $.each(menus, function () {
                    var modules = $(this);
                    if ($("[id*=dpParentMenu]").val() != '' && $("[id*=dpMenu]").val())
                        $("[id*=hdnYes]").val('Y');
                    else
                        $("[id*=hdnYes]").val('N');
                    var ehref = eanchor + $(this).find("modulemenuid").text() + "','" + $(this).find("STATUS").text() + eanchormid + "Make it " + $(this).find("STATUS").text() + eanchorEnd;
                    var inp = "<input type='text' value=\""+ $(this).find("SortingOrder").text() + "\" id=\"" + $(this).find("modulemenuid").text() + "\"  style=\"width:35px;\" class=\"txtChange\">";
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("parentname").text());
                    $("td", row).eq(1).html($(this).find("menuname").text());
                    $("td", row).eq(2).html($(this).find("modulename").text());
                    $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(inp);
                    $("[id*=dgModuleMenu]").append(row);
                    row = $("[id*=dgModuleMenu] tr:last-child").clone(true);

                    

                });
            }
            else {
                $("[id*=hdnYes]").val('N');
                row.addClass("even");
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('No records found');
                $("td", row).eq(3).html('').removeClass("editacc edit-links");
                $("[id*=dgModuleMenu]").append(row);
                row = $("[id*=dgModuleMenu] tr:last-child").clone(true);
            }

            if ($("[id*=hfEditPrm]").val() == 'false') {
                $('.editacc').hide();
            }
            else {
                $('.editacc').show();
            }

            var pager = xml.find("Pager");

            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(pager.find("PageIndex").text()),
                PageSize: parseInt(pager.find("PageSize").text()),
                RecordCount: parseInt(pager.find("RecordCount").text())
            });

            $('.txtChange').bind('keypress', function (event) {
                if (event.which > 31 && (event.which < 48 || event.which > 57))
                    return false;
                else {
                    var c = String.fromCharCode(event.which);
                    var parameters = '{"moduleMenuId": "' + this.id + '","sortingValue": "' + c + '"}';
                    var parameters =
                    $.ajax({
                        type: "POST",
                        url: "../ModulesAndMenus/AddModuleMenu.aspx/UpdateSortingOrder",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });

                    //alert("module id is "+this.id);
                }

            });

           // groupTable($("[id*=dgModuleMenu] tr:has(td)"), 0, 1);
            //    $("[id*=dgModuleMenu] .removed").remove();
        };
    </script>
    <%--Save Module Menu--%>
    <script type="text/javascript">
        function SaveModuleMenu() {
            var hdnYes = $("[id*=hdnYes]").val();
            $("[id*=btnSubmit]").attr("disabled", "true");
            if (hdnYes == 'Y') {

                var array = new Array();
                $('input[name=chkModules]:checked').each(function () {
                    var id = $(this).find("input[name*='chkModules']").attr('id');
                    $(this).find("label[id*='lbl_" + id + "']").attr('style', 'color:green');
                    array.push($(this).val());
                });
                var otherparameters = '"parentMenu": "' + $("[id*=dpParentMenu]").val() + '","menu": "' + $("[id*=dpMenu]").val() + '","userId": "' + $("[id*=hdnUserId]").val() + '"';
                var jsonText = JSON.stringify(array);
                var hdnYes = $("[id*=hdnYes]").val();

                var parameters = '{"array":' + jsonText + ',' + otherparameters + '}';
                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddModuleMenu.aspx/UpdateModuleMenu",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnUpdateSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else if (hdnYes == 'N') {

                if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfModuleMenuId]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfModuleMenuId]").val() != '')
            ) {
                    if ($('#aspnetForm').valid()) {
                        var userId = $("[id*=hdnUserId]").val();
                        var menuId = $("[id*=dpMenu]").val();
                        var qry = '';
                        var index = 0;
                        $('input[name=chkModules]:checked').each(function () {
                            index++;
                            qry += "exec sp_InsertModuleMenu " + $(this).val() + "," + "" + userId + "," + menuId + ",'True';";
                        });
                        if (index > 0) {
                            var parameters = '{"query": "' + qry + '"}';
                            $.ajax({
                                type: "POST",
                                url: "../ModulesAndMenus/AddModuleMenu.aspx/SaveModuleMenu",
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
                            alert("Select any module");

                        }
                    }
                }
                else {
                    return false;
                }
            }
        }

        function OnUpdateSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            $("[id*=btnSubmit]").attr("disabled", false);
            if (response.d == "Updated") {
                AlertMessage('success', "Updated");
                // Cancel();
                GetModuleMenu(parseInt(currentPage), $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
                GetModuleMenuByMenuId();
            }
            else if (response.d == "Failed") {
                AlertMessage('fail', "Update");
                Cancel();
            }

        }

        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (currentPage == '')
                currentPage = 1;
            
            $("[id*=btnSubmit]").attr("disabled", false);
            if (response.d == "Inserted") {
                AlertMessage('success', "Inserted");
                // Cancel();
                GetModuleMenu(parseInt(currentPage), $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', "Insert");
                Cancel();
            }
        };
    </script>
    <%--Edit Module Menu--%>
    <script type="text/javascript">
        function ChangeStatus(moduleMenuId, status) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                var userId = $("[id*=hdnUserId]").val();
                var parameters = '{"moduleMenuId": "' + moduleMenuId + '","status": "' + status + '","userId": "' + userId + '"}';
                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddModuleMenu.aspx/ChangeStatus",
                    data: parameters,
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
                return false;
            }
        }

        //        Edit On Success Function
        function OnEditSuccess(response) {
            AlertMessage('success', response.d);
            GetModuleMenu($("[id*=currentPage]").text(), $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
            if ($("[id*=dpParentMenu]").val() != '' && $("[id*=dpMenu]").val() != '')
                GetModuleMenuByMenuId();
        };
    </script>
    <%--Get SubMenu--%>
    <script type="text/javascript">
        function GetSubMenu() {
            $("[id*=dpMenu]").empty();
            if ($("[id*=dpParentMenu]").val() != '') {

                var parameters = '{"id": "' + $("[id*=dpParentMenu]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddPermission.aspx/GetSubMenu",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSubMenuSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                GetModuleMenuByParentMenuId();
                $(".checkbox").each(function () {
                    $(this).find("input[name*='chkModules']").attr('checked', false);
                    $(this).find("label[name*='lblModules']").removeAttr('style', 'color');
                });
            }
        }
        function OnSubMenuSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var submenus = xml.find("SubMenus");
            //var row = $("[id*=dgUserPermission] tr:last-child").clone(true);
            var select = $("[id*=dpMenu]");
            select.children().remove();
            select.append($("<option>").val('').text('----Select Menu----'));

            if (submenus.length > 0) {
                $.each(submenus, function () {
                    var submenu = $(this);
                    var menuId = $(this).find("MenuId").text();
                    var menuName = $(this).find("MenuName").text();

                    select.append($("<option>").val(menuId).text(menuName));
                });

                GetModuleMenuByParentMenuId();
            }
            else {
                $(".checkbox").each(function () {
                    $(this).find("input[name*='chkModules']").attr('checked', false);
                    $(this).find("label[name*='lblModules']").removeAttr('style', 'color');
                });

                GetModuleMenu(1, $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
            }
        }
    </script>
    <script type="text/javascript">
        function GetModuleMenuByParentMenuId() {
            GetModuleMenu(1, $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
        }
    </script>
    <%--Get Module Menu--%>
    <script type="text/javascript">
        function GetModuleMenuByMenuId() {

            if ($("[id*=dpMenu]").val() != '') {

                $.ajax({
                    type: "POST",
                    url: "../ModulesAndMenus/AddModuleMenu.aspx/GetModuleMenuByMenuId",
                    data: '{menuId: ' + $("[id*=dpMenu]").val() + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OntModuleMenuByMenuIdSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                $("[id*=dpMenu]").val('');
                GetModuleMenu(1, $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
                $(".checkbox").each(function () {
                    $(this).find("label[name*='lblModules']").removeAttr('style', 'color');
                    $(this).find("input[name*='chkModules']").attr('checked', false);
                });
            }
        }
        function OntModuleMenuByMenuIdSuccess(response) {
            $(".checkbox").each(function () {
                $(this).find("label[name*='lblModules']").removeAttr('style', 'color');
                $(this).find("input[name*='chkModules']").attr('checked', false);
            });
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var modulemenuid = xml.find("ModuleMenuById");
            if (modulemenuid.length != 0) {
                $.each(modulemenuid, function () {
                    var value = $(this).find("moduleid").text();
                    var isModuleActive = $(this).find("IsModuleActive").text();
                    $(".checkbox").each(function () {
                        var id = $(this).find("input[name*='chkModules']").attr('id');

                        if ($(this).find("input[name*='chkModules']").val() == value) {
                            $(this).find("input[name*='chkModules']").attr('checked', 'checked');
                            if (isModuleActive == 'true')
                                $(this).find("label[id*='lbl_" + id + "']").attr('style', 'color:green');
                            else {
                                $(this).find("label[id*='lbl_" + id + "']").attr('style', 'color:red');
                                $(this).find("input[name*='chkModules']").attr('checked', false);
                            }

                        }

                    });
                });
            }
            GetModuleMenu(1, $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
        }
    </script>
    <%--Cancel Controls--%>
    <script type="text/javascript">
        function Cancel() {
            $("[id*=dpParentMenu]").val("");
            var select = $("[id*=dpMenu]");
            select.children().remove();
            GetModuleMenu(1, $("[id*=dpMenu]").val(), $("[id*=dpParentMenu]").val());
            $(".checkbox").each(function () {
                $(this).find("input[name*='chkModules']").attr('checked', false);
                $(this).find("label[name*='lblModules']").removeAttr('style', 'color');
            });
        };
    </script>
</asp:Content>
<asp:Content ID="Cont" ContentPlaceHolderID="head2" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <asp:HiddenField ID="hdnYes" runat="server" />
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Add Module Menu</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table class="form">
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Parent Menu</label>
                                    </td>
                                    <td class="col2">
                                        <asp:DropDownList Width="200" ID="dpParentMenu" runat="server" CssClass="jsrequired"
                                            onchange="GetSubMenu();" AutoPostBack="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Menu</label>
                                    </td>
                                    <td class="col2">
                                        <asp:DropDownList Width="200" ID="dpMenu" runat="server" CssClass="jsrequired" onchange="GetModuleMenuByMenuId();"
                                            AutoPostBack="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <label>
                                            Modules</label>
                                    </td>
                                    <td class="col2" valign="top">
                                        <%=BindModules() %>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveModuleMenu();">
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
                            <asp:HiddenField ID="hfModuleMenuId" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="dgModuleMenu" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="parentname" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Parent Name" SortExpression="parentname">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="menuname" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Menu Name" SortExpression="menuname">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="modulename" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Module Name" SortExpression="modulename">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Active/Deactive</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkChangeStatus" runat="server" Text='<%#  Bind("STATUS")  %>'
                                                CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Sorting Order</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkChangeStatus" runat="server" Text='<%#  Bind("STATUS")  %>'
                                                CssClass="links"></asp:LinkButton>
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
    <script type="text/javascript">
        $(document).ready(function () {
            
            $('.txtChange').bind('keypress', function (event) {
                if (event.which > 31 && (event.which < 48 || event.which > 57)) return false;
            });
        });
       
    </script>
</asp:Content>





