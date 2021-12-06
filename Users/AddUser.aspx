<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AddUser.aspx.cs" Inherits="Users_AddUser" %>

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
            //        GetUsers Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetUsers(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

            $("[id*= addPassword]").hide();

        });
        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetUsers(parseInt($(this).attr('page')));
        });
        $("[id*=txtEmployeeName]").blur(function () {
            alert("s empty");
        });
    </script>
    <%--Get Users--%>
    <script type="text/javascript">
        //        GetUsers Function
        function GetUsers(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Users/AddUser.aspx/GetUsers",
                    data: '{pageIndex: ' + pageIndex + ',"search":"' + $("[id*=txtSearch]").val() + '"}',
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
        //        GetUsers On Success Function
        //        Get Users to Grid
        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var modules = xml.find("Users");
            var row = $("[id*=dgUser] tr:last-child").clone(true);
            $("[id*=dgUser] tr").not($("[id*=dgUser] tr:first-child")).remove();
            var vanchor = ''
            var vanchorEnd = '';
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfViewPrm]").val() == 'false') {
                vanchor = "<a>";
                vanchorEnd = "</a>";
            }
            else {
                vanchor = "<a href=\"javascript:ViewRights('";
                vanchorEnd = "');\">View Rights</a>";
            }
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:ChangePassword('";
                eanchorEnd = "');\">Change Password</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteUser('";
                danchorEnd = "');\">Delete</a>";
            }
            $.each(modules, function () {
                var module = $(this);
                var vhref = vanchor + $(this).find("UserId").text() + vanchorEnd;
                var ehref = eanchor + $(this).find("UserId").text() + eanchorEnd;
                var dhref = danchor + $(this).find("UserId").text() + danchorEnd;
                row.addClass("even");
                $("td", row).eq(0).html($(this).find("UserName").text());
                $("td", row).eq(1).html($(this).find("EmpCode").text());
                $("td", row).eq(2).html($(this).find("EmpName").text());
                $("td", row).eq(3).html($(this).find("Rolename").text());
                if ($("[id*=hfViewPrm]").val() == 'false') {
                    vhref = "<a>Not Assigned</a>";
                }
                else {
                    if ($(this).find("PermissionCount").text() == "" || $(this).find("PermissionCount").text() == "0") {
                        vhref = "<a href='#'>Not Assigned</a>";
                    }
                    else {
                        vhref = "<a href='#' onclick='ViewRights(\"" + $(this).find("UserId").text() + "\")' >View Rights</a>";
                    }
                }
                $("td", row).eq(4).html(vhref).addClass("viewacc view-links");
                $("td", row).eq(5).html(ehref).addClass("editacc edit-links");
                $("td", row).eq(6).html(dhref).addClass("deleteacc delete-links");
                $("[id*=dgUser]").append(row);
                row = $("[id*=dgUser] tr:last-child").clone(true);
            });
            if ($("[id*=hfViewPrm]").val() == 'false') {
                $('.viewacc').hide();
            }
            else {
                $('.viewacc').show();
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
    </script>
    <%--Change Password--%>
    <script type="text/javascript">
        //        Edit Function

        function ViewRights(userId) {

            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Users/AddUser.aspx/ViewRights",
                    data: '{userId: ' + userId + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnViewRightsSuccess,
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
        function OnViewRightsSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Rights = xml.find("Rights");
            if (Rights.length > 0) {
                $('#dv1').css("display", "block");
            }
            else {
                $('#dv1').css("display", "none");
            }

            $.each(Rights, function () {
                $("[id*=dvRights]").html($(this).find("rights").text())
            });
        }
        //        Edit On Success Function
        function OnChangePasswordSuccess(response) {
            if (response.d == "-1") {
                AlertMessage('info', 'Invalid User');
            }
            else {
                $("[id*= addPassword]").show();
                $("[id*= addUsers]").hide();
                $("[id*=hfUserId]").val(response.d);
                $("[id*=spSubmit]").html("Update");
                $("[id*=btnSubmit]").attr("disabled", false);
                $("[id*=headAdd]").html('Change Password');


            }

        };


        function ChangePassword(userId) {

            if ($("[id*=hfViewPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Users/AddUser.aspx/ChangePassword",
                    data: '{userId: ' + userId + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnChangePasswordSuccess,
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

    </script>
    <%--Save User--%>
    <script type="text/javascript">
        // Save Module
        function SaveUser() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfUserId]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfUserId]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var empId = $("[id*=dpEmployee]").val();
                    var userName = $("[id*=txtUserName]").val();
                    var password = $("[id*=txtPassword]").val();
                    var roleId = $("[id*=dpRole]").val();
                    var parameters = '{"empId": "' + empId + '","userName": "' + userName + '","password": "' + password + '","roleId": "' + roleId + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Users/AddUser.aspx/SaveUser",
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
            else { return false; }
        }

        // Save On Success
        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Inserted") {
                AlertMessage('success', "Inserted");
                GetUsers(parseInt(currentPage));
                ReloadEmploye();
                Cancel();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', "Insert");
                Cancel();
            }
            else if (response.d == "exists") {
                AlertMessage('info', "Username already exists");
                Cancel();
            }
        };
    </script>
    <%--Delete User--%>
    <script type="text/javascript">
        // Delete Module
        function DeleteUser(id) {
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    var parameters = '{"userId": "' + id + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Users/AddUser.aspx/DeleteUser",
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
                GetUsers(parseInt(currentPage));
                Cancel();
                ReloadEmploye();
            }
            else {
                AlertMessage('reference', response.d);
                Cancel();
            }
        };

        function ReloadEmploye() {
            $.ajax({
                type: "POST",
                url: "../Users/AddUser.aspx/ReloadEmployee",
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
            var menus = xml.find("Employees");
            if (menus.length > 0) {
                var select = $("[id*=dpEmployee]");
                select.children().remove();
                select.append($("<option>").val('').text('----Select Menu----'));
                $.each(menus, function () {
                    var submenu = $(this);
                    var staffId = $(this).find("StaffId").text();
                    var empCode = $(this).find("EmpCode").text();
                    select.append($("<option>").val(staffId).text(empCode));
                });
            }
        }
    </script>
    <%--Cancel Controls--%>
    <script type="text/javascript">
        function Cancel() {
            $("[id*=dpEmployee]").val(0);
            $("[id*=txtEmployeeName]").val("");
            $("[id*=dpRole]").val(0);
            $("[id*=txtEmployeeName]").val("");
            $("[id*=txtUserName]").val("");
            $("[id*=txtPassword]").val("");
            $("[id*=txtNewPassword]").val("");
            $("[id*=txtConfirmPassword]").val("");
            $("[id*=spSubmit]").html("Save");
            $('#aspnetForm').validate().resetForm();
            $("[id*=btnSubmit]").attr("disabled", false);
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

        };
        function CancelPassword() {
            $('#aspnetForm').validate().resetForm();
            $("[id*= txtNewPassword]").val('');
            $("[id*= txtConfirmPassword]").val('');
            $("[id*= addPassword]").hide();
            $("[id*= addUsers]").show();
            $("[id*=headAdd]").html('Add User');
            $("[id*=spSubmit]").html('Save');
            $("[id*=btnSubmit]").attr("disabled", false);
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
    <%--Get Employee--%>
    <script type="text/javascript">
        function GetEmployee() {

            var staffId = $("[id*=dpEmployee]").val();
            if (staffId != '') {
                $.ajax({
                    type: "POST",
                    url: "../Users/AddUser.aspx/GetEmployee",
                    data: '{staffId: ' + staffId + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEmployeeSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                $("[id*=dpEmployee]").val('');
                $("[id*=txtEmployeeName]").val('');
                $("[id*=txtUserName]").val('');
                $("[id*=dpRole]").val('');
            }
        }

        function OnEmployeeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var modules = xml.find("Employees");
            $.each(modules, function () {
                $("[id*=txtEmployeeName]").val($(this).find("StaffName").text());
            });
        }

        function ChangeEmpCode() {
            alert("sss");
            alert($("[id*=txtEmployeeName]").val());
        }
    </script>
    <%--Save Password--%>
    <script type="text/javascript">
        // Save Password
        function SavePassword() {
            if ($('#aspnetForm').valid()) {
                $("[id*=btnSubmit]").attr("disabled", "true");
                var userId = $("[id*=hfUserId]").val();
                var password = $("[id*=txtNewPassword]").val();
                var parameters = '{"id": "' + userId + '","password": "' + password + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Users/AddUser.aspx/SavePassword",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSavePwdSuccess,
                    failure: function (response) {
                        alert(response.d);
                    },
                    error: function (response) {
                        alert(response.d);
                    }
                });
            }
        }

        // Save On Success
        function OnSavePwdSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                alert("Updated Successfully");
                GetUsers(parseInt(currentPage));
                Cancel();
                CancelPassword();
            }
            else if (response.d == "Update Failed") {
                alert("Update failed");
                Cancel();
            }
        };
    </script>
</asp:Content>
<asp:Content ID="ContentHead2" ContentPlaceHolderID="head2" runat="server">
    <!--Autocomplete script starts here -->
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <!--Autocomplete script ends here -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <div class="grid_10">
        <div class="box round first">
            <h2 id="headAdd">
                Add Users</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table class="form" id="addUsers">
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Employee Code</label>
                                    </td>
                                    <td class="col2">
                                        <asp:DropDownList Width="200" ID="dpEmployee" runat="server" CssClass="jsrequired"
                                            AutoPostBack="false" onchange="GetEmployee();">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Employee Name</label>
                                    </td>
                                    <td class="col2">
                                        <input type="text" id="testid" value="" style="display: none" />
                                        <asp:TextBox ID="txtEmployeeName" runat="server" Width="200" onblur="GetEmpIdByName()"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        <label>
                                            User Name</label>
                                    </td>
                                    <td class="col2">
                                        <asp:TextBox ID="txtUserName" runat="server" Width="200" CssClass="jsrequired"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Password</label>
                                    </td>
                                    <td class="col2">
                                        <asp:TextBox ID="txtPassword" runat="server" Width="200" TextMode="Password" CssClass="jsrequired pwdchk"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Role</label>
                                    </td>
                                    <td class="col2">
                                        <asp:DropDownList Width="200" ID="dpRole" runat="server" CssClass="jsrequired">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveUser();">
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
                            <table class="form" id="addPassword">
                                <asp:HiddenField ID="hfUserId" runat="server" />
                                <tr>
                                    <td class="col1">
                                        <label>
                                            New Password</label>
                                    </td>
                                    <td class="col2">
                                        <asp:TextBox ID="txtNewPassword" runat="server" Width="200" TextMode="Password" CssClass="jsrequired pwdchk"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        <label>
                                            Confirm Password</label>
                                    </td>
                                    <td class="col2">
                                        <asp:TextBox ID="txtConfirmPassword" runat="server" Width="200" TextMode="Password"
                                            CssClass="jsrequired pwd_not_same"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <button id="btnPwdSave" type="button" class="btn-icon btn-navy btn-update" onclick="SavePassword();">
                                            <span></span>
                                            <div id="Div1">
                                                Update</div>
                                        </button>
                                        <button id="btnPwdCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                            onclick="return CancelPassword();">
                                            <span></span>Cancel</button>
                                    </td>
                                </tr>
                            </table>
                            <asp:HiddenField ID="hdnEditUserId" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div style="float: right; padding-right: 20px;">
                                <table class="form">
                                    <tr>
                                        <td>
                                            <label>
                                                Search : &nbsp;&nbsp;&nbsp;&nbsp;
                                            </label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSearch" runat="server" onkeyup="GetUsers(1);"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="dgUser" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="UserName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="User Name" SortExpression="UserName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EmpCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Employee Code" SortExpression="EmpCode">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EmpName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Employee Name" SortExpression="ModEmpName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RoleName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Role Name" SortExpression="RoleName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod viewacc">
                                        <HeaderTemplate>
                                            View Rights</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkRights" runat="server" Text="View Rights" CommandArgument='<%# Eval("UserId") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Change Password</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Change Password" CommandArgument='<%# Eval("UserId") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" OnClientClick="return Delete();"
                                                CommandArgument='<%# Eval("UserId") %>' CommandName="Delete" CausesValidation="false"
                                                CssClass="links">
                                            </asp:LinkButton></ItemTemplate>
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
            <div id="dv1" style="background: url(../img/overly.png) repeat; width: 100%; display: none;
                height: 100%; position: fixed; top: 0; left: 0; z-index: 10000; padding-top: 3%;">
                <table cellpadding="0" cellspacing="0" width="100%" align="center">
                    <tr>
                        <td height="30" align="center">
                            <table cellpadding="0" cellspacing="0" width="700" align="center" style="border: 5px solid #bfbfbf;
                                background: #fff;">
                                <tr>
                                    <td align="right" height="30" style="padding-right: 10px; padding-top: 10px;">
                                        <a style="color: #000; text-decoration: none;" href="javascript:CloseFrame()">
                                            <img height="17" width="17" border="0" align="absmiddle" src="../img/close-icon.jpg">
                                            Close </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="dvRights" style="width: 700px; height: 500px; overflow: auto; margin: 10px;">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function CloseFrame() {
            $('#dv1').css("display", "none");
        }
        var options_xml = {
            script: function (input) { return "../Handlers/GetEmployee.ashx?type=employeeuser&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxresults: 15,
            callback: function (obj) { GetEmpIdByName(); }
        };

        var as_xml = new bsn.AutoSuggest('<%= txtEmployeeName.ClientID %>', options_xml);

        function GetEmpIdByName() {
            var staffName = $("[id*=txtEmployeeName]").val();
            $.ajax({
                type: "POST",
                url: "../Users/AddUser.aspx/GetEmployeeByName",
                data: '{staffName:" ' + staffName + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEmployeeIdSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnEmployeeIdSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var employee = xml.find("Employee");
            if (employee.length > 0) {
                $.each(employee, function () {
                    $("[id*=dpEmployee]").val($(this).find("StaffId").text());
                });
            }
            else {
                $("[id*=dpEmployee]").val('');
            }
        }

    </script>
</asp:Content>
