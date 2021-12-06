<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"  
    CodeFile="AddPermission.aspx.cs" Inherits="ModulesAndMenus_AddPermission" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headTag" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("[id*=dgUserPermission]").hide();
            $("[id*=buttonCss]").hide();
            if ($("[id*=hfAddPrm]").val() == 'true' || $("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
            }
            else
                $("table.form :input").prop('disabled', true);
        });
    </script>
    <%--Check All--%>
    <script type="text/javascript">
        function CheckAll(id) {
            $("[id*=dgUserPermission]").find("input[name*='" + id + "']:checkbox").each(function () {
                if ($("[id*=" + id + "]").is(':checked')) {
                    $(this).attr('checked', true);
                }
                else {
                    $(this).attr('checked', false);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function GetUserData() {

            GetPermission('user')
            var parameters = '{"userId": "' + $("[id*=dpUsers]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../ModulesAndMenus/AddPermission.aspx/GetUserRoleById",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetUserRoleByIdSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetUserRoleByIdSuccess(response) {
            $("[id*=txtRole]").val(response.d);
        }
    </script>
    <%--Save Permission--%>
    <script type="text/javascript">
        // Save Module
        function SavePermission() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfMenuId]").val() == '') ||
            ($("[id*=hfViewPrm]").val() == 'true' && $("[id*=hfMenuId]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                   // var user = $("[id*=hdnUserId]").val();
                    
                    var query = '';
//                    if (user== '')
//                        query = GetInsertQuery();
//                    else
                    //                        query = GetUpdateQuery();
                    query = GetQuery();
                    var parameters = '{"query": "' + query + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../ModulesAndMenus/AddPermission.aspx/SavePermission",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSavePermissionSuccess,
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
        function OnSavePermissionSuccess(response) {
            if (response.d == "Updated" || response.d == "Inserted") {
                AlertMessage('success', response.d);
                GetPermission();
            }
            else if (response.d == "UpdateFailed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "InsertFailed") {
                AlertMessage('fail', 'Insert');
            }   
            $("[id*=btnSubmit]").attr("disabled", false);

        }

//        function GetInsertQuery() {
//            var sqlstr = '';
//            var userId = $("[id*=dpUsers]").val();
//            var adminId = $("[id*=hdnAdmin]").val();
//            var menuId = $("[id*=dpMenu]").val();

//            $(".even").each(function () {
//                var addPrm = $(this).find("input[name*='chkAdd']").is(':checked');
//                var editPrm = $(this).find("input[name*='chkEdit']").is(':checked');
//                var deletePrm = $(this).find("input[name*='chkDelete']").is(':checked');
//                var viewPrm = '';
//                if (addPrm == 'true' || editPrm == 'true' || deletePrm == 'true')
//                    viewPrm = 'true';
//                else
//                    viewPrm = 'False';
//                var subQuery = "insert into m_userpermissions (UserId,AdminId,ModuleMenuId,AddPrm,ViewPrm,EditPrm,DeletePrm) values(" + userId + "," + adminId + "," + $(this).find("input[name*='modulemenuid']").val() + ",'" + addPrm + "','" + viewPrm + "','" + $(this).find("input[name*='chkEdit']").is(':checked') + "','" + $(this).find("input[name*='chkDelete']").is(':checked') + "');";
//                sqlstr += subQuery;
//            });
//            $("[id*=hdnUserId]").val(userId);
//            return sqlstr;
//        }

        function GetQuery() {
            var sqlstr = '';
            var userId = $("[id*=dpUsers]").val();
            var adminId = $("[id*=hdnAdmin]").val();
            var menuId = $("[id*=dpMenu]").val();

            $(".even").each(function () {
                var addPrm = $(this).find("input[name*='chkAdd']").is(':checked');
                var editPrm = $(this).find("input[name*='chkEdit']").is(':checked');
                var deletePrm = $(this).find("input[name*='chkDelete']").is(':checked');
                var viewPrm = $(this).find("input[name*='chkView']").is(':checked');
                var isUpdate = $(this).find("input[name*='isUpdate']").val();
               
//               if (addPrm == true || editPrm == true || deletePrm == true)
//                    viewPrm = 'true';
//                else
//                    viewPrm = 'false';
                var subQuery = '';
                if (isUpdate == "1")
                    subQuery = "update m_userpermissions Set AdminId=" + adminId + ",AddPrm='" + addPrm + "',ViewPrm='" + viewPrm + "',EditPrm='" + editPrm + "',DeletePrm='" + deletePrm + "'where userId=" + userId + " and modulemenuid=" + $(this).find("input[name*='modulemenuid']").val() + ";";
                 else
                     subQuery = "insert into m_userpermissions (UserId,AdminId,ModuleMenuId,AddPrm,ViewPrm,EditPrm,DeletePrm) values(" + userId + "," + adminId + "," + $(this).find("input[name*='modulemenuid']").val() + ",'" + $(this).find("input[name*='chkAdd']").is(':checked') + "','" + $(this).find("input[name*='chkView']").is(':checked') + "','" + $(this).find("input[name*='chkEdit']").is(':checked') + "','" + $(this).find("input[name*='chkDelete']").is(':checked') + "');";
                sqlstr += subQuery;
            });
            return sqlstr;
        }

        function GetUpdateQuery() {
            var sqlstr = '';
            var userId = $("[id*=dpUsers]").val();
            var adminId = $("[id*=hdnAdmin]").val();
            var menuId = $("[id*=dpMenu]").val();

            $(".even").each(function () {
                var addPrm = $(this).find("input[name*='chkAdd']").is(':checked');
                var editPrm = $(this).find("input[name*='chkEdit']").is(':checked');
                var deletePrm = $(this).find("input[name*='chkDelete']").is(':checked');
                var viewPrm = $(this).find("input[name*='chkView']").is(':checked');
                
//                var viewPrm = '';
//                if ((addPrm == true) && (editPrm == true) && (deletePrm == true))
//                    viewPrm = "false";
//                else
//                    viewPrm = "false";
                var subQuery = "update m_userpermissions Set AdminId=" + adminId + ",AddPrm='" + addPrm + "',ViewPrm='" + viewPrm + "',EditPrm='" + editPrm + "',DeletePrm='" + deletePrm + "'where userId=" + userId + " and modulemenuid=" + $(this).find("input[name*='modulemenuid']").val() + ";";
                sqlstr += subQuery;
            });

            return sqlstr;
        }

    </script>
    <%--Get Permission--%>
    <script type="text/javascript">
        function GetPermission() {

           
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var userId = $("[id*=dpUsers]").val();
                var menuId = $("[id*=dpMenu]").val();
                if ((userId != null && menuId != null) && (userId != '' && menuId != '')) {
                    var parameters = '{"userId": "' + userId + '","menuId": "' + menuId + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../ModulesAndMenus/AddPermission.aspx/GetPermission",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnPermissionSuccess,
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
                $("[id*=buttonCss]").hide();
                return false;
            }
        }

        function OnPermissionSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var permissions = xml.find("UserPermissions");
            if (permissions.length != 0) {
                var row = $("[id*=dgUserPermission] tr:last-child").clone(true);
                $("[id*=dgUserPermission] tr").not($("[id*=dgUserPermission] tr:first-child")).remove();
                $.each(permissions, function () {
                    var permission = $(this);
                    var chkAdd = null;
                    var chkView = null;
                    var chkEdit = null;
                    var chkDelete = null;
                    if ($(this).find("AddPrm").text() == 'true')
                        chkAdd = "<input name=\"chkAdd\" type=\"checkbox\" checked=\"checked\">";
                    else
                        chkAdd = "<input name=\"chkAdd\" type=\"checkbox\">";

                    if ($(this).find("EditPrm").text() == 'true')
                        chkEdit = "<input name=\"chkEdit\" type=\"checkbox\" checked=\"checked\">";
                    else
                        chkEdit = "<input name=\"chkEdit\" type=\"checkbox\">";

                    if ($(this).find("ViewPrm").text() == 'true')
                        chkView = "<input name=\"chkView\" type=\"checkbox\" checked=\"checked\">";
                    else
                        chkView = "<input name=\"chkView\" type=\"checkbox\">";

                    if ($(this).find("DeletePrm").text() == 'true')
                        chkDelete = "<input name=\"chkDelete\" type=\"checkbox\" checked=\"checked\">";
                    else
                        chkDelete = "<input name=\"chkDelete\" type=\"checkbox\">";

                    row.addClass("even");
                    if ($(this).find("IsModuleMenuActive").text() == "true")
                        $("td", row).eq(0).html("<input name='isUpdate' value='" + $(this).find("IsUpdate").text() + "' type='hidden'><label>" + $(this).find("modulename").text() + "</label><input name='modulemenuid' value='" + $(this).find("modulemenuid").text() + "' type='hidden'>");
                    else
                        $("td", row).eq(0).html("<input name='isUpdate' value='" + $(this).find("IsUpdate").text() + "' type='hidden'><label style=\"color:red;\">" + $(this).find("modulename").text()+ "</label><input name='modulemenuid' value='" + $(this).find("modulemenuid").text() + "' type='hidden'>");
                    $("td", row).eq(1).html(chkAdd);
                    $("td", row).eq(2).html(chkView);
                    $("td", row).eq(3).html(chkEdit);
                    $("td", row).eq(4).html(chkDelete);
                    $("[id*=dgUserPermission]").append(row);
                    row = $("[id*=dgUserPermission] tr:last-child").clone(true);

                    $("[id*=hdnUserId]").val($(this).find("UserId").text());
                    

                });

                $("[id*=dgUserPermission]").show();
                $("[id*=buttonCss]").show();
            }
            else {
                $("[id*=dgUserPermission] tr:has(td)").remove();
                $("[id*=dgUserPermission]").append("<tr class=\"even\"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
                
                $("[id*=dgUserPermission]").hide();
                $("[id*=buttonCss]").hide();
                alert("No records found");
            }

        };
    </script>
    <%--Get Sub Menu--%>
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
        }
        function OnSubMenuSuccess(response) {
            

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var submenus = xml.find("SubMenus");
            //var row = $("[id*=dgUserPermission] tr:last-child").clone(true);
            var select = $("[id*=dpMenu]");
            select.children().remove();
            select.append($("<option>").val('').text('----Select Menu----'));
            $.each(submenus, function () {
                var submenu = $(this);
                var menuId = $(this).find("MenuId").text();
                var menuName = $(this).find("MenuName").text();

                select.append($("<option>").val(menuId).text(menuName));
            });
            $("[id*=dgUserPermission] tr:has(td)").remove();
            $("[id*=dgUserPermission]").append("<tr class=\"even\"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
            $("[id*=dgUserPermission]").hide("slow");
            $("[id*=buttonCss]").hide("slow");
        }
    </script>
    <%--Cancel Controls--%>
    <script type="text/javascript">
        function Cancel() {
            $("[id*=dgUserPermission] tr:has(td)").remove();
            $("[id*=dgUserPermission]").append("<tr class=\"even\"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
            $("[id*=dgUserPermission]").hide("slow");
            $("[id*=buttonCss]").hide("slow");
            $("[id*=dpMenu]").empty();
            $("[id*=dpParentMenu]").val('');
            $("[id*=dpUsers]").val('');

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Add Permission</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table class="form">
                                <tr>
                                    <td class="col1">
                                        <label>
                                            User name</label>
                                    </td>
                                    <td class="col1">
                                        <asp:DropDownList Width="200" ID="dpUsers" runat="server" AutoPostBack="false" CssClass="jsrequired"
                                            onchange="GetUserData();">
                                        </asp:DropDownList>
                                    </td>

                                     <td class="col1">
                                        <label>
                                           Role Name</label>
                                    </td>
                                    <td class="col1">
                                        <asp:TextBox ID="txtRoleName" ReadOnly="true" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                               
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Parent Menu</label>
                                    </td>
                                    <td class="col1">
                                        <asp:DropDownList Width="200" ID="dpParentMenu" runat="server" AutoPostBack="false"
                                            CssClass="jsrequired" onchange="GetSubMenu();">
                                        </asp:DropDownList>
                                    </td>

                                    <td class="col1">
                                        <label>
                                            Menu</label>
                                    </td>
                                    <td class="col1">
                                        <asp:DropDownList Width="200" ID="dpMenu" runat="server" AutoPostBack="false" CssClass="jsrequired"
                                            onchange="GetPermission('perm');">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:HiddenField ID="hdnUserId" runat="server" />
                            <asp:HiddenField ID="hdnAdminId" runat="server" />
                            <asp:GridView ID="dgUserPermission" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" BackColor="White" BorderWidth="1px" ShowFooter="True" HorizontalAlign="Center"
                                RowStyle-CssClass="even" AlternatingRowStyle-CssClass="odd" EnableModelValidation="True"
                                CssClass="display">
                                <Columns>
                                    <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="ModuleName" HeaderText="Module"
                                        SortExpression="ModuleName" />
                                    <asp:TemplateField HeaderText="CheckAll" HeaderStyle-CssClass="sorting_mod">
                                        <HeaderTemplate>
                                            <input id="chkAdd" type="checkbox"  onchange="CheckAll(this.id);" />Add
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkAddSelect" runat="server" AutoPostBack="false" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="CheckAll" HeaderStyle-CssClass="sorting_mod">
                                        <HeaderTemplate>
                                            <input id="chkView" type="checkbox" onchange="CheckAll(this.id);" />View
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkViewSelect" runat="server" AutoPostBack="false"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="CheckAll" HeaderStyle-CssClass="sorting_mod">
                                        <HeaderTemplate>
                                            <input id="chkEdit" type="checkbox"  onchange="CheckAll(this.id);" />Edit
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkEditSelect" runat="server" AutoPostBack="true" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="CheckAll" HeaderStyle-CssClass="sorting_mod ">
                                        <HeaderTemplate>
                                            <input id="chkDelete" type="checkbox"  onchange="CheckAll(this.id);" />Delete
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <td>&nbsp;</td>
                    <tr>
                       <td id="buttonCss">
                           <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving"  onclick="SavePermission();" >  <span></span><div  id="spSubmit">Save</div></button>
                                            <button ID="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1"    
                                                runat="server"  onclick="return Cancel();"><span></span>Cancel</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
