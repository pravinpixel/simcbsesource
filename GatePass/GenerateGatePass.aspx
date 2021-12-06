<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="GenerateGatePass.aspx.cs" Inherits="GatePass_GenerateGatePass" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">

        function ChangeText(id) {
            var value = $('#' + id + ' input:checked').val();
            if (value == "staff") {
                $("[id*=lblSlRegNo]").html("Emp Code");
            }
            else if (value == "student") {
                $("[id*=lblSlRegNo]").html("Reg No");
            }
        }

        function ChangeSearchText(id) {
            var value = $('#' + id + ' input:checked').val();
            if (value == "staff") {
                $("[id*=lblSearchRegEmp]").html("Emp Code");
            }
            else if (value == "student") {
                $("[id*=lblSearchRegEmp]").html("Reg No");
            }
        }

        $(function () {
            $("[id*=txtFrom]").timeEntry();
            $("[id*=txtTo]").timeEntry();
            $("[id*=txtPerFrom]").timeEntry();
            $("[id*=txtPerTo]").timeEntry();
            //        GetAcademicYears Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true') {
                GetGatePassID();
                GetList();
            }
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });

        $(document).ready(function () {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!

            var yyyy = today.getFullYear();
            if (dd < 10) { dd = '0' + dd } if (mm < 10) { mm = '0' + mm } today = dd + '/' + mm + '/' + yyyy;
            $("[id*=hdnDate]").val(today);
            setCurrentDatePicker("[id*=txtDate]");

        });

        
    </script>
    <%--Get Menu --%>
    <script type="text/javascript">
        //        GetMenu Function
        function GetList() {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../GatePass/GenerateGatePass.aspx/SearchList",
                    data: '{"type": "' + $("[id*=RadioButtonList1]input:checked").val() + '","id": "' + $("[id*=txtSearchId]").val() + '"}',
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
            var Pass = xml.find("Pass");
            var row = $("[id*=dgPass] tr:last-child").clone(true);
            $("[id*=dgPass] tr").not($("[id*=dgPass] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfViewPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:ViewGatePass('";
                eanchorEnd = "');\">View</a>";
            }
            var panchor = "<a  href=\"javascript:ReprintGatePass('";
            var panchorend = "');\">Reprint</a>";
            if (Pass.length > 0) {
                $.each(Pass, function () {
                    var modules = $(this);
                    var View = eanchor + $(this).find("GatePassId").text() + eanchorEnd;
                    var print = panchor + $(this).find("GatePassId").text() + panchorend;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("ID").text());
                    $("td", row).eq(1).html($(this).find("Name").text());
                    $("td", row).eq(2).html($(this).find("BelongsTo").text());
                    $("td", row).eq(3).html($(this).find("FormatedDate").text());
                    $("td", row).eq(4).html($(this).find("Reason").text());
                    $("td", row).eq(5).html($(this).find("InTime").text());
                    $("td", row).eq(6).html($(this).find("OutTime").text());
                    $("td", row).eq(7).html($(this).find("ActualInTime").text());
                    $("td", row).eq(8).html(View).addClass("view-links");
                    $("td", row).eq(9).html(print).addClass("print-links");
                    $("[id*=dgPass]").append(row);
                    row = $("[id*=dgPass] tr:last-child").clone(true);
                });
            }
            else {
                row.addClass("even");
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Records Found");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html();
                $("td", row).eq(8).html("").removeClass("view-links");
                $("td", row).eq(9).html("").removeClass("print-links");
                $("[id*=dgPass]").append(row);
                row = $("[id*=dgPass] tr:last-child").clone(true);
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
        function ReprintGatePass(id) {

            $.ajax({
                type: "POST",
                url: "../GatePass/GenerateGatePass.aspx/RePrintGatePass",
                data: '{GatePassID: ' + id + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnReprintGatePasstSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnReprintGatePasstSuccess(response) {
            if (response.d == "1")
                AlertMessage('success', "Reprint done");
            else
                AlertMessage('success', "Reprinting");
        }

        function UpdateReturnPass() {
            var id = $("[id*=hdnGPID]").val();
            $.ajax({
                type: "POST",
                url: "../GatePass/GenerateGatePass.aspx/UpdateReturnPass",
                data: '{GatePassID: ' + id + '}',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    AlertMessage('success', "Return Time Updated");
                    $('#divGatePass').css("display", "none");
                    Cancel();
                    GetGatePassID();
                    GetList();
                },
                dataType: "json"
            });

        }
        function ViewGatePass(id) {

            $.ajax({
                type: "POST",
                url: "../GatePass/GenerateGatePass.aspx/ViewGatePass",
                data: '{GatePassID: ' + id + '}',
                contentType: "application/json; charset=utf-8",
                success: OnViewGatePassSuccess,
                dataType: "json"
            });

        }
        function OnViewGatePassSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Pass = xml.find("ViewPass");

            if (Pass.length > 0) {
                $.each(Pass, function () {

                    if ($(this).find("stype").text() == "Staff")
                        $("[id*=lblRegEmp]").html("StaffId");
                    else
                        $("[id*=lblRegEmp]").html($(this).find("ID").text());
                    $("[id*=lblName]").html($(this).find("Name").text());
                    $("[id*=lblBelongsTo]").html($(this).find("sbelongs").text());
                    $("[id*=lblBelongsToId]").html($(this).find("BelongsTo").text());
                    $("[id*=txtDOP]").val($(this).find("FormatedDate").text());
                    $("[id*=txtReason]").val($(this).find("Reason").text());
                    $("[id*=txtPerFrom]").val($(this).find("InTime").text());
                    $("[id*=txtPerTo]").val($(this).find("OutTime").text());
                    $("[id*=hdnPID]").val($(this).find("pId").text());
                    $("[id*=hdnGPID]").val($(this).find("GatePassId").text());

                    var newSrc = '';

                    if ($(this).find("PhotoFile").text() == "")
                        newSrc = "../img/photo.jpg";

                    else {

                        if ($(this).find("Type").text() == "staff")
                            newSrc = "../Staffs/Uploads/ProfilePhotos/" + $(this).find("PhotoFile").text();
                        else if ($(this).find("Type").text() == "student")
                            newSrc = "../Students/Photos/" + $(this).find("PhotoFile").text();
                    }
                    $("[id*=imgForSt]").attr('src', newSrc);
                    $('#Button1').css("display", "none");
                    $('#Button2').css("display", "none");
                    $("[id*=Button6]").css("display", "block");
                });
                $('#divGatePass').css("display", "block");
            }

        }

        function OnReprintGatePasstSuccess(response) {
            if (response.d == "1")
                AlertMessage('success', "Reprint done");
            else
                AlertMessage('success', "Reprinting");
        }

        function GenerateGatePass() {
            if ($('#aspnetForm').valid()) {

                $.ajax({
                    type: "POST",
                    url: "../GatePass/GenerateGatePass.aspx/GetList",
                    data: '{"type": "' + $("[id*=rdStaffStud]input:checked").val() + '","id": "' + $("[id*=txtRegEmp]").val() + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGenerateSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });

            }
            else
                return false;
        }

        function OnGenerateSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Pass = xml.find("Pass");

            if (Pass.length > 0) {
                $.each(Pass, function () {

                    if ($(this).find("stype").text() == "Staff")
                        $("[id*=lblRegEmp]").html("Employee Code");
                    else
                        $("[id*=lblRegEmp]").html("Register No");
                    $("[id*=lblRegEmpId]").html($(this).find("ID").text());
                    $("[id*=lblName]").html($(this).find("Name").text());
                    $("[id*=lblBelongsTo]").html($(this).find("sbelongs").text());
                    $("[id*=lblBelongsToId]").html($(this).find("BelongsTo").text());
                    $("[id*=txtDOP]").val($("[id*=txtDate]").val());
                    $("[id*=txtReason]").val($("[id*=txtMainReason]").val());
                    $("[id*=txtPerFrom]").val($("[id*=txtFrom]").val());
                    $("[id*=txtPerTo]").val($("[id*=txtTo]").val());
                    $("[id*=hdnPID]").val($(this).find("pId").text());
                    var newSrc = '';
                    if ($(this).find("PhotoFile").text() == "")
                        newSrc = "../img/photo.jpg";

                    else {

                        if ($(this).find("stype").text() == "Staff")
                            newSrc = "../Staffs/Uploads/ProfilePhotos/" + $(this).find("PhotoFile").text();
                        else if ($(this).find("stype").text() == "Student")
                            newSrc = "../Students/Photos/" + $(this).find("PhotoFile").text();
                    }

                    $("[id*=imgForSt]").attr('src', newSrc);
                    $('#Button1').css("display", "block");
                    $('#Button2').css("display", "block");
                    $("[id*=Button6]").css("display", "none");
                });

                $('#divGatePass').css("display", "block");
            }
            else {
                if ($("[id*=rdStaffStud]  input:checked").val() == "student") {
                    AlertMessage('info', "Please enter valid Student Reg No");
                }
                else if ($("[id*=rdStaffStud]  input:checked").val() == "staff") {
                    AlertMessage('info', "Please enter valid Staff Emp Code");
                }
            }
        }

        function GetGatePassID() {
            $.ajax({
                type: "POST",
                url: "../GatePass/GenerateGatePass.aspx/GetGatePassID",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetGatePassIDSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetGatePassIDSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var GatePassIDs = xml.find("GatePassIDs");
            $.each(GatePassIDs, function () {
                var icashvoucherid = $(this);
                $("[id*=txtSerialNo]").val($(this).find("GatePassId").text());
            });
        };
        function CloseFrame() {
            $('#divGatePass').css("display", "none");
            //Cancel();
        }

        function Insert() {
            var parameters = '{"type": "' + $("[id*=rdStaffStud]input:checked").val() + '","serialNo": "' + $("[id*=txtSerialNo]").val() + '","pid": "' + $("[id*=hdnPID]").val() + '","Id": "' + $("[id*=lblRegEmpId]").html() + '","date": "' + $("[id*=txtDOP]").val() + '","reason": "' + $("[id*=txtReason]").val() + '","from": "' + $("[id*=txtPerFrom]").val() + '","to": "' + $("[id*=txtPerTo]").val() + '","userId": "' + $("[id*=hfuserid]").val() + '","classDes": "' + $("[id*=lblBelongsToId]").html() + '","name": "' + $("[id*=lblName]").html() + '"}';
            $.ajax({
                type: "POST",
                url: "../GatePass/GenerateGatePass.aspx/InsertGatePass",
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
        function OnSaveSuccess(response) {
            if (response.d == "") {
                print();

                $('#divGatePass').css("display", "none");
                AlertMessage('success', "Generated");
                Cancel();
                GetGatePassID();
                GetList();
            }
            else
                AlertMessage('fail', response.d);
        }
        function CancelSearch() {
            $("[id*=txtSearchId]").val('');
            $('input:radio[name*=RadioButtonList1]:nth(0)').attr('checked', true);
            GetList();
        }
        function Cancel() {
            $("[id*=txtRegEmp]").val('');
            $("[id*=txtMainReason]").val('');
            $("[id*=txtFrom]").val('');
            $("[id*=txtTo]").val('');
            $('#aspnetForm').validate().resetForm();
        }
        function CancelPoPUp() {
            $('#divGatePass').css("display", "none");
        }
        function print() {
            $(".printContent").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'

            }
                //               , overrideElementCSS: [

                //        '../css/birthday.css',

                //        { href: '../css/print-birthday.css', media: 'print'}]
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hdnDate" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage" style="overflow: auto; height: 600px;">
            <h2>
                Gate Pass</h2>
            <div class="block content-wrapper2">
                <table class="form">
                    <tr>
                        <td colspan="7" class="col1 formsubheading">
                            Generate Gate Pass
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" class="">
                            <asp:RadioButtonList ID="rdStaffStud" runat="server" RepeatDirection="Horizontal"
                                onchange="ChangeText(this.id)">
                                <asp:ListItem Text="Student" Selected="True" Value="student"></asp:ListItem>
                                <asp:ListItem Text="Staff" Value="staff"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td width="94">
                            <label>
                                Serial No</label>
                        </td>
                        <td width="13">
                            <label>
                                :</label>
                        </td>
                        <td width="200">
                            <asp:TextBox ID="txtSerialNo" ReadOnly="true" runat="server"></asp:TextBox>
                        </td>
                        <td width="100">
                            <label id="lblSlRegNo">
                                Reg No</label>
                        </td>
                        <td width="13">
                            <label>
                                :</label>
                        </td>
                        <td width="200">
                            <asp:TextBox ID="txtRegEmp" CssClass="jsrequired" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="">
                            <label>
                                Date</label>
                        </td>
                        <td class="">
                            <label>
                                :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDate" CssClass="jsrequired" runat="server"></asp:TextBox>
                        </td>
                        <td width="89" class="">
                            <label>
                                Reason</label>
                        </td>
                        <td width="16" class="">
                            <label>
                                :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtMainReason" TextMode="MultiLine" CssClass="jsrequired" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="">
                            <label>
                                From</label>
                        </td>
                        <td class="">
                            <strong>:</strong>
                        </td>
                        <td>
                            <asp:TextBox ID="txtFrom" CssClass="jsrequired" runat="server"></asp:TextBox>
                        </td>
                        <td class="">
                            <label>
                                To</label>
                        </td>
                        <td class="">
                            <label>
                                :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtTo" CssClass="jsrequired" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="">
                            &nbsp;
                        </td>
                        <td colspan="4">
                            <%-- <asp:Button ID="btnGenerate" runat="server" CssClass="btn-icon btn-navy btn-save"
                                Text="Generate" />--%>
                            <button id="Button3" type="button" onclick="GenerateGatePass();" class="btn-icon btn-navy btn-generate">
                                <span></span>
                                <div id="Div2">
                                    Generate</div>
                            </button>
                            <button id="Button4" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return Cancel();">
                                <span></span>Cancel</button>
                            <button type="button" onclick="print();" class="btn-icon btn-navy btn-print">
                                <span></span>Print</button>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="">
                            &nbsp;
                            <asp:HiddenField ID="hdnGPID" runat="server" />
                        </td>
                        <td colspan="4">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table class="form">
                    <tr>
                        <td colspan="6" class="col1 formsubheading">
                            Search
                        </td>
                    </tr>
                    <tr>
                        <td width="15%" class="">
                            <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal"
                                onclick="ChangeSearchText(this.id)">
                                <asp:ListItem Text="Student" Selected="True" Value="student"></asp:ListItem>
                                <asp:ListItem Text="Staff" Value="staff"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td width="10%" class="">
                            <label id="lblSearchRegEmp">
                                RegNo:</label>
                        </td>
                        <td width="5%">
                            <asp:TextBox ID="txtSearchId" CssClass="" runat="server"></asp:TextBox>
                        </td>
                        <td width="60%">
                            <button id="btnSubmit" type="button" onclick="GetList();" class="btn-icon btn-navy btn-search">
                                <span></span>
                                <div id="spSubmit">
                                    Search</div>
                            </button>
                            <button id="Button5" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return CancelSearch();">
                                <span></span>Cancel</button>
                        </td>
                        <td width="5%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td colspan="9">
                            <asp:GridView ID="dgPass" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="RegNoEmpId" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="RegNo/EmpId" SortExpression="RegNoEmpId">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Name" SortExpression="Name">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ClassDesignation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Class/Designation" SortExpression="ClassDesignation">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Date" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Date" SortExpression="Date">
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
                                    <asp:BoundField DataField="ActualInTime" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Actual Return" SortExpression="ActualInTime">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="View" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="View" SortExpression="View">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Reprint" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Reprint" SortExpression="Reprint">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div id="divGatePass" style="background: url(../img/overly.png) repeat; width: 100%;
        display: none; height: 100%; position: fixed; top: 0; left: 0; z-index: 10000;">
        <div style="position: absolute; top: 15%; left: 31%;">
            <asp:HiddenField ID="hdnPID" runat="server" />
            <table width="530" border="0" align="center" cellpadding="0" cellspacing="0" id="tableTC"
                style="border: 5px solid #bfbfbf; background-color: #ffffff;">
                <tr>
                    <td valign="top" style="padding: 10px 10px 0px;">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="35" colspan="2" align="right" valign="top" style="border-bottom: 0px solid #bfbfbf;
                                    font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold;
                                    color: #000; line-height: 25px;">
                                    <a href="javascript:CloseFrame()" style="color: #000; text-decoration: none;">
                                        <img src="../img/close-icon.jpg" width="17" height="17" border="0" align="absmiddle" />
                                        Close</a>
                                </td>
                            </tr>
                            <tr>
                                <td height="60" colspan="2" align="center" valign="top" style="border-bottom: 1px solid #bfbfbf;
                                    font-family: Arial, Helvetica, sans-serif; font-size: 22px; font-weight: bold;
                                    color: #000; line-height: 25px;">
                                    AMALORPAVAM LOURDS ACADEMY<br />
                                    <span style="font-family: Arial, Helvetica, sans-serif; font-size: 15px; font-weight: bold;
                                        color: #000;">PUDUCHERRY - 605 001. Phone no. 2356747</span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" valign="top" height="10">
                                </td>
                            </tr>
                            <tr>
                                <td width="79%" valign="top" style="padding: 5px 0px; vertical-align: top !important;">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td width="33%" height="30">
                                                <label id="lblRegEmp">
                                                </label>
                                            </td>
                                            <td width="5%">
                                                :
                                            </td>
                                            <td width="62%">
                                                <label id="lblRegEmpId">
                                                </label>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td height="30">
                                                Name
                                            </td>
                                            <td>
                                                :
                                            </td>
                                            <td>
                                                <label id="lblName">
                                                </label>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td height="30">
                                                <label id="lblBelongsTo">
                                                </label>
                                            </td>
                                            <td>
                                                :
                                            </td>
                                            <td>
                                                <label id="lblBelongsToId">
                                                </label>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td height="30">
                                                Gate Pass Date
                                            </td>
                                            <td>
                                                :
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDOP" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="21%" align="right" valign="top" style="padding: 5px 0px;">
                                    <img id="imgForSt" src="" width="100" height="100" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td width="26%" height="30">
                                                Time From
                                            </td>
                                            <td width="4%">
                                                :
                                            </td>
                                            <td width="70%">
                                               <input type="text" id="txtPerFrom" style="width: 150px;" value="" />                                              
                                            </td>
                                        </tr>

                                          <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td width="26%" height="30">
                                                Time To
                                            </td>
                                            <td width="4%">
                                                :
                                            </td>
                                            <td width="70%">
                                              <input type="text" style="width: 150px;" id="txtPerTo" value="To" />
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td height="30">
                                                Reason
                                            </td>
                                            <td height="30">
                                                :
                                            </td>
                                            <td height="30">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td height="110" colspan="3" valign="top">
                                                <label for="textarea">
                                                </label>
                                                <textarea name="textarea" id="txtReason" cols="69" rows="5"></textarea>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td height="35" colspan="3" align="center" style="">
                                                <button id="Button1" type="button" class="btn-icon btn btn-navy btn-save" value="Save"
                                                    onclick="Insert();">
                                                    <span></span>
                                                    <div id="Div1">
                                                        Save</div>
                                                </button>
                                                <button id="Button6" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                    onclick="return UpdateReturnPass();">
                                                    <span></span>Update Return Time</button>
                                                <button id="Button2" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                    onclick="return CancelPoPUp();">
                                                    <span></span>Cancel</button>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
