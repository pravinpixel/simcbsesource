<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Fuel.aspx.cs" Inherits="Fuel" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
     <script type="text/javascript">
         $(document).ready(function () {
             setDatePicker("[id*=txtEntryDate]");
         });
      </script>
    <script type="text/javascript">

        $(function () {
            //        GetFuel Function on page load
          
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetFuel(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetFuel Function

        function GetFuel(pageIndex) {
         if ($("[id*=hfViewPrm]").val() == 'true') {
            $.ajax({
                type: "POST",
                url: "../Masters/Fuel.aspx/GetFuel",
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

        //        GetFuel On Success Function
        //        Get Fuel to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Fuels = xml.find("Fuels");
            var row = $("[id*=dgFuel] tr:last-child").clone(true);
            $("[id*=dgFuel] tr").not($("[id*=dgFuel] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditFuel('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteFuel('";
                danchorEnd = "');\">Delete</a>";
            }
            if (Fuels.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records Found").attr("align", "left");
                $("td", row).eq(3).html("").removeClass("editacc edit-links");
                $("td", row).eq(4).html("").removeClass("deleteacc delete-links");
                $("[id*=dgFuel]").append(row);
                row = $("[id*=dgFuel] tr:last-child").clone(true);

            }
            else {
                $.each(Fuels, function () {
                    var Fuel = $(this);
                    var ehref = eanchor + $(this).find("FuelID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("FuelID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("FuelTypeName").text());
                    $("td", row).eq(1).html($(this).find("EntryDate").text());
                    $("td", row).eq(2).html($(this).find("PricePerLtr").text());
                    $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgFuel]").append(row);
                    row = $("[id*=dgFuel] tr:last-child").clone(true);
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
        // Delete Fuel
        function DeleteFuel(id) {
            var parameters = '{"FuelID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                $.ajax({

                    type: "POST",
                    url: "../Masters/Fuel.aspx/DeleteFuel",
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

        function EditFuel(FuelID) {
         if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Masters/Fuel.aspx/EditFuel",
                data: '{FuelID: ' + FuelID + '}',
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
            var Fuel = xml.find("EditFuel");
            $.each(Fuel, function () {
                var Fuel = $(this);
                $("[id*=ddlFuelType]").val($(this).find("FuelTypeID").text());
                $("[id*=txtEntryDate]").val($(this).find("EntryDate").text());
                $("[id*=txtPrice]").val($(this).find("PricePerLtr").text());
                $("[id*=hfFuelID]").val($(this).find("FuelID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save Fuel
        function SaveFuel() {
         if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfFuelID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfFuelID]").val() != '')
            ) {
             if ($('#aspnetForm').valid()) {
                 $("[id*=btnSubmit]").attr("disabled", "true");
                var FuelID = $("[id*=hfFuelID]").val();
                var FuelType = $("[id*=ddlFuelType]").val();
                var EntryDate = $("[id*=txtEntryDate]").val();
                var PricePerLtr = $("[id*=txtPrice]").val();
                var parameters = '{"id": "' + FuelID + '","name": "' + FuelType + '","entrydate": "' + EntryDate + '","priceperltr": "' + PricePerLtr + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Masters/Fuel.aspx/SaveFuel",
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
                GetFuel(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
               AlertMessage('success', 'Inserted');
                GetFuel(1);
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
                GetFuel(parseInt(currentPage));
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
            GetFuel(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=ddlFuelType]").val("");
            $("[id*=txtEntryDate]").val("");
            $("[id*=txtPrice]").val("");
            $("[id*=hfFuelID]").val("");
            $("[id*=btnSubmit]").attr("disabled", "false");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
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
                Fuel
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 350px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Fuel Type</label>
                                        </td>
                                        <td class="col2">
                                            <asp:DropDownList ID="ddlFuelType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Entry Date</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtEntryDate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Price/Litre</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtPrice" CssClass="jsrequired numericswithdecimals" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfFuelID" runat="server" />
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving"  onclick="SaveFuel();" ><span></span><div  id="spSubmit">Save</div></button>
                                            <button ID="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1"    
                                                runat="server"  onclick="return Cancel();"><span></span>Cancel</button>

 
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top" colspan="2">
                            <asp:GridView ID="dgFuel" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="FuelTypeName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Fuel Type" SortExpression="FuelTypeName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EntryDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Entry Date" SortExpression="EntryDate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PricePerLtr" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Price/Ltr" SortExpression="PricePerLtr">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("FuelID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("FuelID") %>'
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
