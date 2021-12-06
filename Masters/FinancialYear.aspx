<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="FinancialYear.aspx.cs" Inherits="FinancialYear" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtStartDate]");
            setDatePicker("[id*=txtEndDate]");
        });
        $(function () {
            //        GetFinancialYears Function on page load
   
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetFinancialYear(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetFinancialYears Function

        function GetFinancialYear(pageIndex) {
         if ($("[id*=hfViewPrm]").val() == 'true') {
            $.ajax({
                type: "POST",
                url: "../Masters/FinancialYear.aspx/GetFinancialYear",
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
            var Financialyears = xml.find("FinancialYears");
            var row = $("[id*=dgFinancialYear] tr:last-child").clone(true);
            $("[id*=dgFinancialYear] tr").not($("[id*=dgFinancialYear] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditFinancialYear('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteFinancialYear('";
                danchorEnd = "');\">Delete</a>";
            }
            if (Financialyears.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("").removeClass("editacc edit-links");
                $("td", row).eq(3).html("").removeClass("deleteacc delete-links");
                $("[id*=dgFinancialYear]").append(row);
                row = $("[id*=dgFinancialYear] tr:last-child").clone(true);

            }
            else {
                $.each(Financialyears, function () {
                    var Financialyear = $(this);
                    var ehref = eanchor + $(this).find("FinancialID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("FinancialID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("StartDate").text());
                    $("td", row).eq(1).html($(this).find("EndDate").text());
                    $("td", row).eq(2).html(ehref).addClass("editacc edit-links");
                //    $("td", row).eq(3).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgFinancialYear]").append(row);
                    row = $("[id*=dgFinancialYear] tr:last-child").clone(true);
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
        // Delete FinancialYear
        function DeleteFinancialYear(id) {
            var parameters = '{"FinancialID": "' + id + '"}';
           if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                $.ajax({

                    type: "POST",
                    url: "../Masters/FinancialYear.aspx/DeleteFinancialYear",
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

        function EditFinancialYear(FinancialID) {
        if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Masters/FinancialYear.aspx/EditFinancialYear",
                data: '{FinancialID: ' + FinancialID + '}',
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
            var Financialyears = xml.find("EditFinancialYear");
            $.each(Financialyears, function () {
                var Financialyear = $(this);
                $("[id*=txtStartDate]").val($(this).find("StartDate").text());
                $("[id*=txtEndDate]").val($(this).find("EndDate").text());
                $("[id*=hfFinancialID]").val($(this).find("FinancialID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save FinancialYear
        function SaveFinancialYear() {
         if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfFinancialID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfFinancialID]").val() != '')
            ) {
             if ($('#aspnetForm').valid()) {
                 $("[id*=btnSubmit]").attr("disabled", "true");
                var FinancialID = $("[id*=hfFinancialID]").val();
                var startdate = $("[id*=txtStartDate]").val();
                var enddate = $("[id*=txtEndDate]").val();
                var parameters = '{"id": "' + FinancialID + '","startdate": "' + startdate + '","enddate": "' + enddate + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Masters/FinancialYear.aspx/SaveFinancialYear",
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
                GetFinancialYear(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
               AlertMessage('success', 'Inserted');
                GetFinancialYear(parseInt(currentPage));
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
                GetFinancialYear(1);
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
            GetFinancialYear(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtStartDate]").val("");
            $("[id*=txtEndDate]").val("");
            $("[id*=hfFinancialID]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $("[id*=btnSubmit]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function CheckDate() {

            var date1 = $("[id*=txtStartDate]").val();
            var date2 = $("[id*=txtEndDate]").val();
            if (date1 != "" && date2 != "") {
                if ($.datepicker.parseDate('dd/mm/yy', date2) < $.datepicker.parseDate('dd/mm/yy', date1)) {
                    AlertMessage('info', 'StartDate should be lesser than EndDate !!!');
                    $("[id*=txtStartDate]").val("");
                    $("[id*=txtEndDate]").val("");
                }
            }

        };       

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Financial Year
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
                                                Start Date</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtStartDate" CssClass="jsrequired dateNL date-picker" onchange="CheckDate();" runat="server"></asp:TextBox>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                End Date</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtEndDate" CssClass="jsrequired dateNL date-picker" onchange="CheckDate();" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfFinancialID" runat="server" />
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving"  onclick="SaveFinancialYear();" ><span></span><div  id="spSubmit">Save</div></button>
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
                            <asp:GridView ID="dgFinancialYear" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="StartDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Start Date" SortExpression="StartDate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EndDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="End Date" SortExpression="EndDate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("FinancialID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                   <%-- <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("FinancialID") %>'
                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
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
