<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Tax.aspx.cs" Inherits="Tax" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript">

        $(function () {
            //        GetTax Function on page load
       
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetTax(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetTax Function

        function GetTax(pageIndex) {
        if ($("[id*=hfViewPrm]").val() == 'true') {
            $.ajax({
                type: "POST",
                url: "../Masters/Tax.aspx/GetTax",
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

        //        GetTax On Success Function
        //        Get Tax to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Taxs = xml.find("Taxs");
            var row = $("[id*=dgTax] tr:last-child").clone(true);
            $("[id*=dgTax] tr").not($("[id*=dgTax] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditTax('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteTax('";
                danchorEnd = "');\">Delete</a>";
            }
            if (Taxs.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Records Found").attr("align", "left").removeClass("editacc edit-links");
                $("td", row).eq(4).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(5).html("");
                $("[id*=dgTax]").append(row);
                row = $("[id*=dgTax] tr:last-child").clone(true);

            }
            else {
                $.each(Taxs, function () {
                    var Tax = $(this);
                    var ehref = eanchor + $(this).find("TaxID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("TaxID").text() + danchorEnd;


                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("FeesHeadName").text());
                    $("td", row).eq(1).html($(this).find("TaxName").text());
                    $("td", row).eq(2).html($(this).find("Percentage").text());
                    $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgTax]").append(row);
                    row = $("[id*=dgTax] tr:last-child").clone(true);
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
        // Delete Tax
        function DeleteTax(id) {
            var parameters = '{"TaxID": "' + id + '"}';
           if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                $.ajax({

                    type: "POST",
                    url: "../Masters/Tax.aspx/DeleteTax",
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

        function EditTax(TaxID) {
         if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Masters/Tax.aspx/EditTax",
                data: '{TaxID: ' + TaxID + '}',
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
            var Tax = xml.find("EditTax");
            $.each(Tax, function () {
                var Tax = $(this);
                var FeesheadID = $(this).find("FeesheadID").text();
                $("[id*=ddlFeeHead] option[value='" + FeesheadID + "']").attr("selected", "true");
                $("[id*=txtTaxName]").val($(this).find("TaxName").text());
                $("[id*=txtPercentage]").val($(this).find("Percentage").text().trim());
                $("[id*=hfTaxID]").val($(this).find("TaxID").text());
                $("[id*=spSubmit]").html("Update");

            });
        };

        // Save Tax
        function SaveTax() {
         if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfTaxID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfTaxID]").val() != '')
            ) {
             if ($('#aspnetForm').valid()) {
                 $("[id*=btnSubmit]").attr("disabled", "true");
                var TaxID = $("[id*=hfTaxID]").val();
                var TaxName = $("[id*=txtTaxName]").val();
                var Percentage = $("[id*=txtPercentage]").val();
                var feeheadid = $("[id*=ddlFeeHead]").val();
                var parameters = '{"id": "' + TaxID + '","feeheadid": "' + feeheadid + '","name": "' + TaxName + '","percentage": "' + Percentage + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Masters/Tax.aspx/SaveTax",
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
                GetTax(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
               AlertMessage('success', 'Inserted');
                GetTax(1);
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
                GetTax(parseInt(currentPage));
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
            GetTax(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtTaxName]").val("");
            $("[id*=ddlFeeHead]").val("");
            $("[id*=txtPercentage]").val("");
            $("[id*=hfTaxID]").val("");
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
                Tax
            </h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 550px" runat="server">
                                <table class="form">
                                 <tr>
                                        <td class="col1">
                                            <label>
                                                Fee Head Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:DropDownList ID="ddlFeeHead" CssClass="jsrequired" runat="server">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Tax Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtTaxName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td class="col1">
                                            <label>
                                                Percentage</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtPercentage" CssClass="jsrequired numericswithdecimals" runat="server"></asp:TextBox>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                        </td>
                                        <td>
                                           <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving"  onclick="SaveTax();" ><span></span><div  id="spSubmit">Save</div></button>
                                            <button ID="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1"    
                                                runat="server"  onclick="return Cancel();"><span></span>Cancel</button>

                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <asp:HiddenField ID="hfTaxID" runat="server" />
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="dgTax" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="FeesHeadName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="FeesHead" SortExpression="FeesHeadName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="TaxName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Tax Name" SortExpression="TaxName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                       <asp:BoundField DataField="Percentage" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Percentage" SortExpression="Percentage">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("TaxID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("TaxID") %>'
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
