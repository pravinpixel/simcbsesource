<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="BloodGroup.aspx.cs" Inherits="BloodGroup" %>

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
            //        GetBloodGroup Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetBloodGroup(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });
       
         


        //        GetBloodGroup Function

        function GetBloodGroup(pageIndex) {
         if ($("[id*=hfViewPrm]").val() == 'true') {
            $.ajax({
                type: "POST",
                url: "../Masters/BloodGroup.aspx/GetBloodGroup",
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

        //        GetBloodGroup On Success Function
        //        Get BloodGroup to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var bloodgroups = xml.find("BloodGroups");
            var row = $("[id*=dgBloodGroup] tr:last-child").clone(true);
            $("[id*=dgBloodGroup] tr").not($("[id*=dgBloodGroup] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditBloodGroup('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteBloodGroup('";
                danchorEnd = "');\">Delete</a>";
            }
            if (bloodgroups.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("editacc edit-links");
                $("td", row).eq(2).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(3).html("");
                $("[id*=dgBloodGroup]").append(row);
                row = $("[id*=dgBloodGroup] tr:last-child").clone(true);

            }
            else {
                $.each(bloodgroups, function () {
                    var bloodgroup = $(this);
                    var ehref = eanchor + $(this).find("BloodGroupID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("BloodGroupID").text() + danchorEnd;


                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("BloodGroupName").text());
                    $("td", row).eq(1).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(2).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgBloodGroup]").append(row);
                    row = $("[id*=dgBloodGroup] tr:last-child").clone(true);
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
        // Delete BloodGroup
        function DeleteBloodGroup(id) {
            var parameters = '{"BloodGroupID": "' + id + '"}';
        if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                $.ajax({

                    type: "POST",
                    url: "../Masters/BloodGroup.aspx/DeleteBloodGroup",
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

        function EditBloodGroup(BloodGroupID) {
         if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Masters/BloodGroup.aspx/EditBloodGroup",
                data: '{BloodGroupID: ' + BloodGroupID + '}',
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
            var BloodGroup = xml.find("EditBloodGroup");
            $.each(BloodGroup, function () {
                var BloodGroup = $(this);
                $("[id*=txtBloodGroupName]").val($(this).find("BloodGroupName").text());
                $("[id*=hfBloodGroupID]").val($(this).find("BloodGroupID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save BloodGroup
        function SaveBloodGroup() {
         if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfBloodGroupID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfBloodGroupID]").val() != '')
            ) {
             if ($('#aspnetForm').valid()) {
                 $("[id*=btnSubmit]").attr("disabled", "true");
                var BloodGroupID = $("[id*=hfBloodGroupID]").val();
                var BloodGroupName = $("[id*=txtBloodGroupName]").val();
                var parameters = '{"id": "' + BloodGroupID + '","name": "' + BloodGroupName + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Masters/BloodGroup.aspx/SaveBloodGroup",
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
                GetBloodGroup(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
               AlertMessage('success', 'Inserted');
                GetBloodGroup(1);
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
                GetBloodGroup(parseInt(currentPage));
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
            GetBloodGroup(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtBloodGroupName]").val("");
            $("[id*=hfBloodGroupID]").val("");
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
        <div class="box round first">
            <h2>
                Blood Group
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
                                                Blood Group Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtBloodGroupName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfBloodGroupID" runat="server" />
                                        </td>
                                        <td>

                                         <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving"  onclick="SaveBloodGroup();" ><span></span><div  id="spSubmit">Save</div></button>
                                            <button ID="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1"    
                                                runat="server"  onclick="return Cancel();"><span></span>Cancel</button>
 
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="dgBloodGroup" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="BloodGroupName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Blood Group Name" SortExpression="BloodGroupName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("BloodGroupID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("BloodGroupID") %>'
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
                                            <asp:HiddenField ID="hfAdd" runat="server" />
                                            <asp:HiddenField ID="hfEdit" runat="server" />
                                            <asp:HiddenField ID="hdDelete" runat="server" />
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
