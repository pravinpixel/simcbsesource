<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Rooms.aspx.cs" Inherits="Rooms" %>

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

        $(function () {
            //        GetRoomss Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetRooms(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetRoomss Function

        function GetRooms(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Rooms.aspx/GetRooms",
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
            var Roomses = xml.find("Rooms");
            var row = $("[id*=dgRooms] tr:last-child").clone(true);
            $("[id*=dgRooms] tr").not($("[id*=dgRooms] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditRooms('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteRooms('";
                danchorEnd = "');\">Delete</a>";
            }
            if (Roomses.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records Found").attr("align", "left");
                $("td", row).eq(3).html("").removeClass("editacc edit-links");
                $("td", row).eq(4).html("").removeClass("deleteacc delete-links");
                $("[id*=dgRooms]").append(row);
                row = $("[id*=dgRooms] tr:last-child").clone(true);

            }
            else {
                $.each(Roomses, function () {
                    var iRooms = $(this);
                    var ehref = eanchor + $(this).find("RoomID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("RoomID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("HostelName").text());
                    $("td", row).eq(1).html($(this).find("BlockName").text());
                    $("td", row).eq(2).html($(this).find("RoomName").text());
                    $("td", row).eq(3).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgRooms]").append(row);
                    row = $("[id*=dgRooms] tr:last-child").clone(true);
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
        // Delete Rooms
        function DeleteRooms(id) {
            var parameters = '{"RoomsID": "' + id + '"}';
           if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                $.ajax({

                    type: "POST",
                    url: "../Masters/Rooms.aspx/DeleteRooms",
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

     function GetBlockByHostel(ID) {
         if (ID) {
             $.ajax({
                 type: "POST",
                 url: "../Masters/Rooms.aspx/GetBlockByHostelID",
                 data: '{HostelID: ' + ID + '}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: OnGetSuccess,
                 failure: function (response) {
                     AlertMessage('info', response.d);
                 },
                 error: function (response) {
                     AlertMessage('info', response.d);
                 }
             });
         }
     }

        function OnGetSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("BlockByHostel");


            var select = $("[id*=ddlBlock]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var BlockID = $(this).find("BlockID").text();
                var BlockName = $(this).find("BlockName").text();
                select.append($("<option>").val(BlockID).text(BlockName));

            });
        };


        //        Edit Function

        function EditRooms(RoomsID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/Rooms.aspx/EditRooms",
                    data: '{RoomsID: ' + RoomsID + '}',
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
            var Roomses = xml.find("EditRooms");
            $.each(Roomses, function () {

                var iRooms = $(this);
                $("[id*=txtRoomsName]").val($(this).find("RoomName").text());

                var HostelID = $(this).find("HostelID").text();
                $("[id*=ddlHostel] option[value='" + HostelID + "']").attr("selected", "true");

                var BlockID = $(this).find("BlockID").text();
                $("[id*=ddlBlock] option[value='" + BlockID + "']").attr("selected", "true");

                $("[id*=hfRoomsID]").val($(this).find("RoomID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save Rooms
        function SaveRooms() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfRoomsID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfRoomsID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var RoomsID = $("[id*=hfRoomsID]").val();
                    var RoomsName = $("[id*=txtRoomsName]").val();
                    var HostelID = $("[id*=ddlHostel]").val();
                    var BlockID = $("[id*=ddlBlock]").val();

                    var parameters = '{"id": "' + RoomsID + '","roomname": "' + RoomsName + '","blockid": "' + BlockID + '"}';
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Rooms.aspx/SaveRooms",
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
                GetRooms(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
               AlertMessage('success', 'Inserted');
                GetRooms(1);
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
                GetRooms(parseInt(currentPage));
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
            GetRooms(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtRoomsName]").val("");
            $("[id*=ddlHostel]").val("");
            $("[id*=ddlBlock]").val("");
            $("[id*=hfRoomsID]").val("");
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
                Rooms / Racks
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 570px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Hostel Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:DropDownList ID="ddlHostel" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                onchange="GetBlockByHostel(this.value);">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Block Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:DropDownList ID="ddlBlock" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Room / Rack Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtRoomsName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <asp:HiddenField ID="hfRoomsID" runat="server" />
                                        </td>
                                        <td>
                                         <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving"  onclick="SaveRooms();" ><span></span><div  id="spSubmit">Save</div></button>
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
                            <asp:GridView ID="dgRooms" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="HostelName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Hostel Name" SortExpression="HostelName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BlockName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Block Name" SortExpression="BlockName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RoomName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Room Name" SortExpression="RoomName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("RoomID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("RoomID") %>'
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
