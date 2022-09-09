<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Days.aspx.cs" Inherits="Days" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">

        $(function () {
            //        GetDayss Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetDays(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });



        //        GetDayss Function

        function GetDays(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Days.aspx/GetDays",
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
            var blocks = xml.find("Days");
            var row = $("[id*=dgDays] tr:last-child").clone(true);
            $("[id*=dgDays] tr").not($("[id*=dgDays] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditDays('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteDays('";
                danchorEnd = "');\">Delete</a>";
            }
            if (blocks.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("editacc edit-links");
                $("td", row).eq(2).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");
                $("[id*=dgDays]").append(row);
                row = $("[id*=dgDays] tr:last-child").clone(true);

            }
            else {

                $.each(blocks, function () {
                    var block = $(this);
                    var ehref = eanchor + $(this).find("DaysID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("DaysID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("Class").text());
                    $("td", row).eq(1).html($(this).find("MonthName").text());
                    $("td", row).eq(2).html($(this).find("NoofDays").text());
                    $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgDays]").append(row);
                    row = $("[id*=dgDays] tr:last-child").clone(true);
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
        // Delete Days
        function DeleteDays(id) {
            var parameters = '{"DaysID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Days.aspx/DeleteDays",
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

        function EditDays(DaysID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/Days.aspx/EditDays",
                    data: '{DaysID: ' + DaysID + '}',
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
            var EditDays = xml.find("EditDays");
            $.each(EditDays, function () {
                var ClassID = $(this).find("ClassID").text();
                $("[id*=ddlClass] option[value='" + ClassID + "']").attr("selected", "true");
                $("[id*=txtDays]").val($(this).find("NoofDays").text());
                var MonthID = $(this).find("MonthID").text();
                $("[id*=ddlMonth] option[value='" + MonthID + "']").attr("selected", "true");
                $("[id*=hfDaysID]").val($(this).find("DaysID").text());
                $("[id*=spSubmit]").html("Update");

                var parameters = '{"MonthID": "' + $("[id*=ddlMonth]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Masters/Days.aspx/NoofBindDays",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnNoofBindDaysSucces

                });

               

            });

        };

        function BindDays() {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                var parameters = '{"MonthID": "' + $("[id*=ddlMonth]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Masters/Days.aspx/NoofBindDays",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnNoofBindDaysSucces

                });


            }   
            else {
                $("table.form :input").prop('disabled', true);
                return false;
            }
        }


        function OnNoofBindDaysSucces(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var firstContent = xml.find("FirstContent");
            $.each(firstContent, function () {
                $("[id*=dvDays]").html($(this).find("firsthtml").text());

            });
            var parameters = '{"ClassID": "' + $("[id*=ddlClass]").val() + '","MonthID": "' + $("[id*=ddlMonth]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Masters/Days.aspx/GetDaysList",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetDaysListSucces

            });


        };
        function OnGetDaysListSucces(response) {
            // alert(response.d);
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var DaysList = xml.find("DaysList");
            if (DaysList.length > 0) {
                $(".checkbox2").find("input:checkbox").each(function () {
                    $(".chkDays").attr("checked", false);
                });
                $.each(DaysList, function () {
                    $("[id*=txtDays]").val($(this).find("NoofDays").text());
                    var DayValue = $(this).find("Dayvalue").text();
                    $(".checkbox2").find("input:checkbox").each(function () {
                        var DateVal = $(this).val();
                        if (DayValue == DateVal) {
                            $(this).attr("checked", true);
                        }
                    });
                });
            }
            else {
                $(".checkbox2").find("input:checkbox").each(function () {
                    $(".chkDays").attr("checked", true);
                });
            }


        };
       

        
        // Save Days
        function SaveDays() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfDaysID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfDaysID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var DaysID = $("[id*=hfDaysID]").val();
                    var Days = $("[id*=txtDays]").val();
                    var MonthID = $("[id*=ddlMonth]").val();
                    var ClassID = $("[id*=ddlClass]").val();
                    var DayValue = "";
                    var iCnt = 0;
                    $(".checkbox2").find("input:checkbox").each(function () {
                        var chk = $(this).is(':checked');
                        if (chk == true) {
                            if (DayValue == "") {
                                DayValue = $(this).val();
                            }
                            else {
                                DayValue = DayValue + ',' + $(this).val();
                            }

                            iCnt = (parseInt(iCnt) + 1).toString();
                        }
                    });

                    if ((iCnt < Days) || (iCnt > Days) || (iCnt == 0) || (DayValue == "")) {
                        AlertMessage('info', "No of Working days mismatch with the selected dates");
                        Cancel();
                        return true;

                    }
                    var parameters = '{"id": "' + DaysID + '","ClassID": "' + ClassID + '","Days": "' + Days + '","MonthID": "' + MonthID + '","DayValue": "' + DayValue + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/Days.aspx/SaveDays",
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
                GetDays(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetDays(1);
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
                GetDays(parseInt(currentPage));
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
            GetDays(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtDays]").val("");
            $("[id*=ddlClass]").val("");
            $("[id*=ddlMonth]").val("");
            $("[id*=hfDaysID]").val("");
            $(".checkbox2").find("input:checkbox").each(function () {
                $(this).attr("checked", false);
            });
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
                Days
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr>
                        <td colspan="2">
                            <asp:UpdatePanel ID="ups" runat="server">
                                <ContentTemplate>
                                    <div id="dvCashVoucher" style="float: left; width: 100%" runat="server">
                                        <table width="100%" class="form">
                                            <tr>
                                                <td width="15%">
                                                    <label>
                                                        Class</label>
                                                </td>
                                                <td class="col2">
                                                    <asp:DropDownList ID="ddlClass" runat="server" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="15%">
                                                    <label>
                                                        Month Name</label>
                                                </td>
                                                <td class="col2">
                                                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="jsrequired"
                                                       onchange="BindDays();">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="15%">
                                                    <label>
                                                        No. of Working Days</label>
                                                </td>
                                                <td class="col2">
                                                    <asp:TextBox ID="txtDays" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="15%">
                                                    <label>
                                                        Select the working Days
                                                    </label>
                                                </td>
                                                <td class="col2">
                                                <div id="dvDays" runat="server"></div>
                                                    
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="15%">
                                                    &nbsp;
                                                    <asp:HiddenField ID="hfDaysID" runat="server" />
                                                </td>
                                                <td>
                                                    <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveDays();">
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
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlMonth" EventName="SelectedIndexChanged" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2" valign="top">
                            <asp:GridView ID="dgDays" runat="server" Width="100%" AutoGenerateColumns="false"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="Class" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Class Name" SortExpression="Class">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MonthName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Month Name" SortExpression="MonthName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NoofDays" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="No of Days" SortExpression="NoofDays">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("DaysID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("DaysID") %>'
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
