<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="BusRoute.aspx.cs" Inherits="BusRoute" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   
    <script type="text/javascript" src="../js/jquery.min.js"></script>
     <%--  <%="<link href='" + ResolveUrl("~/js/jquery.timeentry.package-1.5.0/jquery.timeentry.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
      <%="<script src='" + ResolveUrl("~/js/jquery.timeentry.package-1.5.0/jquery.timeentry.js") + "' type='text/javascript'></script>"%>--%>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript">

        $(function () {
            //        GetBusRoute Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetBusRoute(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });
        $(function () {
           $("[id*=txtTimings]").timeEntry();

        });

        //        GetBusRoute Function

        function GetBusRoute(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/BusRoute.aspx/GetBusRoute",
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

        //        GetBusRoute On Success Function
        //        Get BusRoute to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var BusRoutes = xml.find("BusRoutes");
            var row = $("[id*=dgBusRoute] tr:last-child").clone(true);
            $("[id*=dgBusRoute] tr").not($("[id*=dgBusRoute] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditBusRoute('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteBusRoute('";
                danchorEnd = "');\">Delete</a>";
            }
            if (BusRoutes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records Found").attr("align", "left");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("").removeClass("editacc edit-links");
                $("td", row).eq(6).html("").removeClass("deleteacc delete-links");
                $("[id*=dgBusRoute]").append(row);
                row = $("[id*=dgBusRoute] tr:last-child").clone(true);

            }
            else {

                $.each(BusRoutes, function () {
                    var BusRoute = $(this);
                    var ehref = eanchor + $(this).find("BusRouteID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("BusRouteID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("VehicleCode").text());
                    $("td", row).eq(1).html($(this).find("BusRouteName").text());
                    $("td", row).eq(2).html($(this).find("BusRouteCode").text());
                    $("td", row).eq(3).html($(this).find("Timings").text());
                    $("td", row).eq(4).html($(this).find("BusCharge").text());
                    $("td", row).eq(5).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(6).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgBusRoute]").append(row);
                    row = $("[id*=dgBusRoute] tr:last-child").clone(true);
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
        // Delete BusRoute
        function DeleteBusRoute(id) {
            var parameters = '{"BusRouteID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/BusRoute.aspx/DeleteBusRoute",
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

        function EditBusRoute(BusRouteID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/BusRoute.aspx/EditBusRoute",
                    data: '{BusRouteID: ' + BusRouteID + '}',
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
            var BusRoute = xml.find("EditBusRoute");
            $.each(BusRoute, function () {
                var BusRoute = $(this);
                $("[id*=txtBusRouteName]").val($(this).find("RouteName").text());
                $("[id*=txtBusRouteCode]").val($(this).find("BusRouteCode").text());
                $("[id*=txtBusCharge]").val($(this).find("BusCharge").text());
                $("[id*=txtTimings]").val($(this).find("Timings").text());

                var VehicleID = $(this).find("VehicleID").text();
                $("[id*=ddlVehicleCode] option[value='" + VehicleID + "']").attr("selected", "true");

                $("[id*=hfBusRouteID]").val($(this).find("BusRouteID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save BusRoute
        function SaveBusRoute() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfBusRouteID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfBusRouteID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var BusRouteID = $("[id*=hfBusRouteID]").val();
                    var BusRouteName = $("[id*=txtBusRouteName]").val();
                    var BusRouteCode = $("[id*=txtBusRouteCode]").val();
                    var BusCharge = $("[id*=txtBusCharge]").val();
                    var Timings = $("[id*=txtTimings]").val();
                    var VehicleCode = $("[id*=ddlVehicleCode]").val();
                    var parameters = '{"id": "' + BusRouteID + '","busroutename": "' + BusRouteName + '","busroutecode": "' + BusRouteCode + '","vehicleid": "' + VehicleCode + '","timings": "' + Timings + '","buscharge": "' + BusCharge + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/BusRoute.aspx/SaveBusRoute",
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
                GetBusRoute(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetBusRoute(1);
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
                GetBusRoute(parseInt(currentPage));
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
            GetBusRoute(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtBusRouteName]").val("");
            $("[id*=txtBusRouteCode]").val("");
            $("[id*=txtTimings]").val("");
            $("[id*=txtBusCharge]").val("");
            $("[id*=ddlVehicleCode]").val("");
            $("[id*=hfBusRouteID]").val("");
            $("[id*=btnSubmit]").attr("disabled", "false");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function GetRegNo(ID) {
            if (ID) {


                var VehicleID = $("[id*=ddlVehicleCode]").val();
                if ($("[id*=hfViewPrm]").val() == 'true') {
                    $.ajax({
                        type: "POST",
                        url: "../Masters/BusRoute.aspx/GetRegisterNo",
                        data: '{VehicleID: ' + VehicleID + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnGetRegisterNoSuccess,
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
            else {
                $("[id*=lblRegNo]").slideUp("slow");
                $("[id*=lblRegNo]").html("");
            }
        }

        function OnGetRegisterNoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var BusRoute = xml.find("RegisterNo");
            $.each(BusRoute, function () {
                var BusRoute = $(this);
                $("[id*=lblRegNo]").slideUp("slow");
                $("[id*=lblRegNo]").slideDown("slow");
                $("[id*=lblRegNo]").html(" Registration No : " + $(this).find("RegistrationNo").text());
            });
        };

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                BusRoute
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 550px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Vehicle Code</label>
                                        </td>
                                        <td class="col2">
                                            <asp:DropDownList ID="ddlVehicleCode" CssClass="jsrequired" runat="server" onChange="GetRegNo(this.value);" AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                            <label><span id="lblRegNo" style="display:none"></span></label>
                                        </td>
                                        
                                    </tr>
                                   
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Bus Route Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtBusRouteName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Bus Route Code</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtBusRouteCode" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Timings</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtTimings" CssClass="jsrequired" Width="80px" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Bus Charge</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtBusCharge" CssClass="jsrequired numericswithdecimals" Width="80px"
                                                runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveBusRoute();">
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
                            <asp:HiddenField ID="hfBusRouteID" runat="server" />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top" colspan="2">
                            <asp:GridView ID="dgBusRoute" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="VehicleName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Vehicle Code" SortExpression="VehicleName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BusRouteName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Bus Route Name" SortExpression="BusRouteName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BusRouteCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Bus Route Code" SortExpression="BusRouteCode">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Timings" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Timings" SortExpression="Timings">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BusCharge" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Bus Charge" SortExpression="BusCharge">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("BusRouteID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("BusRouteID") %>'
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
