<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="LeaveApplication.aspx.cs" Inherits="Staffs_LeaveApplication" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtFrom]");
            setDatePicker("[id*=txtTo]");
        });
    </script>
    <%--Save Leave Details--%>
    <script type="text/javascript">
        $(function () {
            GetLeaveDetails();

        });
        var formdata;
        function readURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffLeave", input.files[0]);
                }
            }
        }

        function SaveLeave() {
            if ($("[id*=hdnStaffId]").val() != '') {
                if ($('#aspnetForm').valid()) {

                    val = $("[id*=hdnStaffLeaveId]").val();
                    var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","acdYear": "' + $("[id*=hdnAcd]").val() + '","leaveId": "' + $("[id*=ddlLeave]").val() + '","reason": "' + $("[id*=txtReason]").val() + '","from": "' + $("[id*=txtFrom]").val() + '","to": "' + $("[id*=txtTo]").val() + '","noOfLeave": "' + $("[id*=txtNop]").val() + '","fileName":  "' + $("[id*=leaveFile]").val().replace(/C:\\fakepath\\/i, '') + '","filePath": "no file path","userId": "' + $("[id*=hdnUserId]").val() + '","staffLeaveId": "' + $("[id*=hdnStaffLeaveId]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/LeaveApplication.aspx/UpdateLeaveDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveLeaveSuccess,
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
                AlertMessage('info', "Please enter personal details first");
                changeAccordion(0);
            }
        }
        function OnSaveLeaveSuccess(response) {
            if (response.d != '') {
                AlertMessage('success', "Updated");
                $("[id*=hdnStaffLeaveId]").val('');
                GetLeaveDetails();
                CancelLeaveDetails();
                debugger
                if (response.d != '-1') {
                    formdata.append("FileName", response.d);
                    if (formdata) {
                        $.ajax({
                            url: "../Staffs/LeaveApplication.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                                formdata = new FormData();
                                //alert(res)
                            }
                        });
                    }
                }
            }
            else if (response.d == '') {
                AlertMessage('fail', "Update");
                CancelLeaveDetails();
            }
        }

       
        function CancelLeaveDetails() {
            $("[id*=ddlLeave]").val('');
            $("[id*=txtReason]").val('');
            $("[id*=txtFrom]").val('');
            $("[id*=txtTo]").val('');
            $("[id*=txtNop]").val('');
            $("[id*=leaveFile]").val('');
            $("[id*=hdnStaffLeaveId]").val('');
            
        }
        function GetLeaveDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","academicId": "' + $("[id*=hdnAcd]").val() + '","staffLeaveId": ""}';
            $.ajax({
                type: "POST",
                url: "../Staffs/LeaveApplication.aspx/GetLeaveDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetLeaveSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetLeaveSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Leave");
            var row = $("[id*=dgLeave] tr:last-child").clone(true);
            $("[id*=dgLeave] tr").not($("[id*=dgLeave] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditLeave('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteLeave('";
                danchorEnd = "');\">Delete</a>";
            }
            if (menus.length > 0) {
                $.each(menus, function () {
                    var modules = $(this);
                    var ehref = eanchor + $(this).find("StaffLeaveId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffLeaveId").text() + danchorEnd;
                    row.addClass("even");
                    var cls = $(this).find("StatusName").text().toLowerCase();
                    $("td", row).eq(0).html($(this).find("AcademicYearFormat").text());
                    $("td", row).eq(1).html($(this).find("LeaveName").text());
                    $("td", row).eq(2).html($(this).find("Reason").text());
                    $("td", row).eq(3).html($(this).find("FROMFORMAT").text());
                    $("td", row).eq(4).html($(this).find("TOFORMAT").text());
                    $("td", row).eq(5).html($(this).find("NOP").text());
                    $("td", row).eq(6).html($(this).find("FileName").text());

                    $("td", row).eq(7).html("<span class=\"" + cls + "\">" + $(this).find("StatusName").text() + "</span>");
                    $("td", row).eq(8).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgLeave]").append(row);
                    row = $("[id*=dgLeave] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('No records found');
                $("td", row).eq(5).html('');
                $("td", row).eq(6).html('');
                $("td", row).eq(7).html('');
                $("td", row).eq(8).html('');
                $("[id*=dgLeave]").append(row);
                row = $("[id*=dgLeave] tr:last-child").clone(true);
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
        }
        function EditLeave(id) {

            var parameters = '{"staffId": "' + "" + '","academicId": "' + "" + '","staffLeaveId": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/LeaveApplication.aspx/GetLeaveDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditLeaveSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnEditLeaveSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Leave");
            $.each(menus, function () {
                $("[id*=hdnStaffLeaveId]").val($(this).find("StaffLeaveId").text());
                $("[id*=txtAcademic]").val($(this).find("AcademicYearFormat").text());
                $("[id*=ddlLeave]").val($(this).find("LeaveId").text());
                $("[id*=txtReason]").val($(this).find("Reason").text());
                $("[id*=txtFrom]").val($(this).find("FROMFORMAT").text());
                $("[id*=txtTo]").val($(this).find("TOFORMAT").text());
                $("[id*=txtNop]").val($(this).find("NOP").text());
            });
        }
        function DeleteLeave(id) {
            var parameters = '{"staffLeaveId": "' + id + '","userId": "' + $("[id*=hdnUserId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/StaffInfo.aspx/DeleteLeaveDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteLeaveSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteLeaveSuccess(response) {
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetLeaveDetails();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
            }
        }
        function CheckDate(ID) {
            var i = $("[id*=txtFrom]").val();
            if (ID == 5) {
                $("[id*=txtTo]").attr("disabled", true);
            }
            else {
                $("[id*=txtTo]").attr("disabled", false);
            }
            $("[id*=txtTo]").val(i);
            
        }
        function ChangeDate(ID) {
            var i = $("[id*=ddlLeave]").val();
            CheckDate(i);
        }
    </script>
</asp:Content>
<asp:Content ID="mainContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div class="grid_10">
        <div class="box round first fullpage" style="overflow: auto; height: 600px;">
            <h2>
                Add Leave Application
            <div id="jSuccess-info">
                    EL Accumulated :
                    <asp:Label ID="lblElaccumulated" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    EL Sanctioned for...(Current Year) :
                    <asp:Label ID="lblElaccumulatedcuryear" runat="server"></asp:Label></div>    
            </h2>
            <div class="block content-wrapper2">
                <asp:HiddenField ID="hdnAcd" runat="server" />
                <asp:HiddenField ID="hdnStaffId" runat="server" />
                <asp:HiddenField ID="hdnStaffLeaveId" runat="server" />
                <table class="form">
                    <tr>
                        <td width="20%" class="col1">
                            <label>
                                Employee Code :</label>
                        </td>
                        <td width="26%" class="col2">
                            <asp:TextBox ID="txtEmpCode" runat="server" ReadOnly="true"></asp:TextBox>
                        </td>
                        <td>
                            <span class="col1">
                                <label>
                                    Name :</label>
                            </span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtStaffName" ReadOnly="true" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="20%" class="col1">
                            <label>
                                Designation :</label>
                        </td>
                        <td width="26%" class="col2">
                            <asp:TextBox ID="txtDesignation" ReadOnly="true" runat="server"></asp:TextBox>
                        </td>
                        <td width="20%" class="col1">
                            <label>
                                Class Taught :</label>
                        </td>
                        <td width="26%" class="col2">
                            <asp:TextBox ID="txtClassTaught" ReadOnly="true" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                Leave :</label>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlLeave" runat="server" onchange="CheckDate(this.value);" CssClass="jsrequired">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <label>
                                No of Leaves/Hours :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtNop" CssClass="numbersonly" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="14%" class="col2">
                            <span class="col1">
                                <label>
                                    Leave From :</label>
                            </span>
                        </td>
                        <td class="col2">
                            <asp:TextBox ID="txtFrom" onchange="ChangeDate(this.value);" runat="server"></asp:TextBox>
                        </td>
                        <td>
                            <label>
                                Leave To :
                            </label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtTo" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                Upload Attachments :</label>
                        </td>
                        <td>
                            <input type='file' style="width: 180px;" id="leaveFile" onchange="readURL(this);" />
                        </td>
                        <td>
                            <label>
                                Reason :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtReason" TextMode="MultiLine" Rows="4" Columns="18" CssClass=""
                                runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td height="40">
                            <asp:HiddenField ID="hdnUserId" runat="server" />
                        </td>
                        <td colspan="3">
                            <br />
                            <button id="btnLeaveSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveLeave();">
                                <span></span>
                                <div id="spSubmit">
                                    Save</div>
                            </button>
                            <button id="btnLeaveCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return CancelLeaveDetails();">
                                <span></span>Cancel</button>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:GridView ID="dgLeave" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="AcademicYear" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Academic Year" SortExpression="AcademicYear">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Leave" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Leave" SortExpression="Leave">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Reason" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Reason" SortExpression="Reason">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="From" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="From" SortExpression="From">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="To" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="To" SortExpression="To">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NoOfLeaves" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="No Of Leaves/Permission" SortExpression="NoOfLeaves">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Uploads" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Uploads" SortExpression="Uploads">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Status" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Status" SortExpression="Status">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StaffId") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StaffId") %>'
                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
