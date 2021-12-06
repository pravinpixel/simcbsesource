<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="PlaceofWork.aspx.cs" Inherits="PlaceofWork" %>

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
            //        GetPlaceofWork Function on page load
           
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetPlaceofWork(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetPlaceofWork Function

        function GetPlaceofWork(pageIndex) {
         if ($("[id*=hfViewPrm]").val() == 'true') {
            $.ajax({
                type: "POST",
                url: "../Masters/PlaceofWork.aspx/GetPlaceofWork",
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

        //        GetPlaceofWork On Success Function
        //        Get PlaceofWork to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var PlaceofWorks = xml.find("PlaceofWorks");
            var row = $("[id*=dgPlaceofWork] tr:last-child").clone(true);
            $("[id*=dgPlaceofWork] tr").not($("[id*=dgPlaceofWork] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditPlaceofWork('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeletePlaceofWork('";
                danchorEnd = "');\">Delete</a>";
            }
            if (PlaceofWorks.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("editacc edit-links");
                $("td", row).eq(2).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(3).html("");
                $("[id*=dgPlaceofWork]").append(row);
                row = $("[id*=dgPlaceofWork] tr:last-child").clone(true);

            }
            else {
                $.each(PlaceofWorks, function () {
                    var PlaceofWork = $(this);
                    var ehref = eanchor + $(this).find("PlaceofWorkID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("PlaceofWorkID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("PlaceofWork").text());
                    $("td", row).eq(1).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(2).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgPlaceofWork]").append(row);
                    row = $("[id*=dgPlaceofWork] tr:last-child").clone(true);
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
        // Delete PlaceofWork
        function DeletePlaceofWork(id) {
            var parameters = '{"PlaceofWorkID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                $.ajax({

                    type: "POST",
                    url: "../Masters/PlaceofWork.aspx/DeletePlaceofWork",
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

        function EditPlaceofWork(PlaceofWorkID) {
        if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Masters/PlaceofWork.aspx/EditPlaceofWork",
                data: '{PlaceofWorkID: ' + PlaceofWorkID + '}',
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
            var PlaceofWork = xml.find("EditPlaceofWork");
            $.each(PlaceofWork, function () {
                var PlaceofWork = $(this);
                $("[id*=txtPlaceofWork]").val($(this).find("PlaceofWork").text());
                $("[id*=hfPlaceofWorkID]").val($(this).find("PlaceofWorkID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save PlaceofWork
        function SavePlaceofWork() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfPlaceofWorkID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfPlaceofWorkID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                var PlaceofWorkID = $("[id*=hfPlaceofWorkID]").val();
                var PlaceofWork = $("[id*=txtPlaceofWork]").val();
                var parameters = '{"id": "' + PlaceofWorkID + '","name": "' + PlaceofWork + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Masters/PlaceofWork.aspx/SavePlaceofWork",
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
                GetPlaceofWork(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
               AlertMessage('success', 'Inserted');
                GetPlaceofWork(1);
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
                GetPlaceofWork(parseInt(currentPage));
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
            GetPlaceofWork(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtPlaceofWork]").val("");
            $("[id*=hfPlaceofWorkID]").val("");
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
                Place of Work
            </h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 650px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Place of Work</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtPlaceofWork" CssClass="jsrequired" runat="server"></asp:TextBox>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfPlaceofWorkID" runat="server" />
                                        </td>
                                        <td>
                                        
                                         <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving"  onclick="SavePlaceofWork();" ><span></span><div  id="spSubmit">Save</div></button>
                                            <button ID="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1"    
                                                runat="server"  onclick="return Cancel();"><span></span>Cancel</button>

                                         
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2" valign="top">
                            <asp:GridView ID="dgPlaceofWork" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="PlaceofWork" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="PlaceofWork" SortExpression="PlaceofWork">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("PlaceofWorkID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("PlaceofWorkID") %>'
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
