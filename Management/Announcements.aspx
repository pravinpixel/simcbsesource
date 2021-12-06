<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Announcements.aspx.cs" Inherits="Management_Announcements" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<link href='" + ResolveUrl("~/css/managefees.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtDOI]");
        });
        $(function () {

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true') {
                GetAnnouncementsInfo(1);
            }
            else {
                GetAnnouncementsInfo(0);

            }
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
            $("[id*=dvCount]").css("display", "none");
            $("[id*=dviCount]").css("display", "none");
            $("[id*=spSubmit]").html("Save");
        });
        var formdata;



        function ViewAnnouncementsInfo(AnnouncementsID) {

            $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Management/Announcements.aspx/GetAnnouncementsLog",
                data: '{AnnouncementsID: ' + AnnouncementsID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnAnnouncementsLogSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });



        }

        function OnAnnouncementsLogSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var classcount = xml.find("AnnouncementsLog");
            var row = $("[id*=dgCount] tr:last-child").clone(true);
            $("[id*=dgCount] tr").not($("[id*=dgCount] tr:first-child")).remove();
            if (classcount.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("[id*=dgCount]").append(row);
                row = $("[id*=dgCount] tr:last-child").clone(true);
            }
            else {
                $.each(classcount, function () {
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("DOI").text());
                    $("td", row).eq(2).html($(this).find("Title").text());
                    $("td", row).eq(3).html($(this).find("StaffName").text());
                    $("[id*=dgCount]").append(row);
                    row = $("[id*=dgCount] tr:last-child").clone(true);
                    $("[id*=dvCount]").css("display", "block");
                    $("[id*=dviCount]").css("display", "block");
                });


                var pager = xml.find("Pager");

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }
        };
        function GetAnnouncementsInfo(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Management/Announcements.aspx/GetAnnouncementsInfo",
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
            var AnnouncementsInfoes = xml.find("AnnouncementsInfo");

            var row = $("[id*=dgAnnouncementsInfo] tr:last-child").clone(true);
            $("[id*=dgAnnouncementsInfo] tr").not($("[id*=dgAnnouncementsInfo] tr:first-child")).remove();

            var eanchor = ''
            var eanchorEnd = '';

            var danchor = ''
            var danchorEnd = '';

            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:ViewAnnouncementsInfo('";
                eanchorEnd = "');\">View</a>";
            }

            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteAnnouncementsInfo('";
                danchorEnd = "');\">Delete</a>";
            }

            if (AnnouncementsInfoes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("").removeClass("editacc view-links");
                $("td", row).eq(6).html("").removeClass("deleteacc delete-links");
                $("[id*=dgAnnouncementsInfo]").append(row);
                row = $("[id*=dgAnnouncementsInfo] tr:last-child").clone(true);

                var pager = xml.find("Pager");
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(1),
                    PageSize: parseInt(1),
                    RecordCount: parseInt(0)
                });
            }
            else {

                $.each(AnnouncementsInfoes, function () {
                    var iAnnouncementsInfo = $(this);
                    if ($(this).find("AnnouncementsLogID").text() != "") {
                        var ehref = "<a href=javascript:ViewAnnouncementsInfo(" + $(this).find('AnnouncementsID').text() + ");>View</a>";
                    }
                    else {
                        var ehref = "<a href='#'>No log to view</a>";
                    }
                    var dhref = "<a href=javascript:DeleteAnnouncementsInfo(" + $(this).find('AnnouncementsID').text() + ");>Delete</a>";
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("DOI").text());
                    $("td", row).eq(2).html($(this).find("Title").text());
                    $("td", row).eq(3).html($(this).find("Message").text());
                    $("td", row).eq(4).html($(this).find("RoleName").text());
                    $("td", row).eq(5).html(ehref).addClass("editacc view-links");
                    $("td", row).eq(6).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgAnnouncementsInfo]").append(row);
                    row = $("[id*=dgAnnouncementsInfo] tr:last-child").clone(true);
                });

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
            }
        };

        function SaveAnnouncementsDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfBlockID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfBlockID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var AnnouncementsID = $("[id*=hfAnnouncementsID]").val();
                    var Title = $("[id*=txtTitle]").val();
                    var Message = $("[id*=txtMessage]").val();
                    var DOI = $("[id*=txtDOI]").val();
                    var SendTo = $("[id*=ddlSendTo]").val();
                    var parameters = '{"AnnouncementsID": "' + AnnouncementsID + '","DOI": "' + DOI + '","Title": "' + Title + '","Message": "' + Message + '","SendTo": "' + SendTo + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Management/Announcements.aspx/SaveAnnouncements",
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
        // Delete AnnouncementsInfo
        function DeleteAnnouncementsInfo(id) {
            var parameters = '{"AnnouncementsInfoID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Management/Announcements.aspx/DeleteAnnouncementsInfo",
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



        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var AnnouncementsID = $("[id*=hfAnnouncementsID]").val();

                AnnouncementsDetailsClear();
                GetAnnouncementsInfo(1);
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                AnnouncementsDetailsClear();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                $("[id*=hfAnnouncementsID]").val(response.d);
                var AnnouncementsID = $("[id*=hfAnnouncementsID]").val();

                AnnouncementsDetailsClear();
                GetAnnouncementsInfo(1);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                AnnouncementsDetailsClear();
            }
            else {
                AlertMessage('fail', response.d);
                AnnouncementsDetailsClear();
            }
        };

        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetAnnouncementsInfo(1);
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
        function closeView() {
            $('#dvCount').css("display", "none");
            $("[id*=dviCount]").css("display", "none");

        }
        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetAnnouncementsInfo(parseInt($(this).attr('page')));
        });
        function AnnouncementsDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $("[id*=hfAnnouncementsID]").val("");
            $("[id*=txtTitle]").val("");
            $("[id*=txtMessage]").val("");
            $("[id*=txtDOI]").val("");
            $("[id*=ddlSendTo]").val("");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Manage Announcements
            </h2>
            <div class="block john-accord content-wrapper2">
                <table class="form">
                          <tr>
                        <td width="10%">
                              <label>
                                Send To :</label>
                        </td>
                        <td width="28%" class="col2">
                            <asp:DropDownList ID="ddlSendTo" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                       
                    </tr>
                    <tr>
                     <td width="10%">
                           <label>
                               Announcement Title :</label>
                        </td>
                        <td width="33%" class="col2">
                          <asp:TextBox ID="txtTitle" CssClass="jsrequired" runat="server"></asp:TextBox>
                            
                        </td>
                    </tr>
                    <tr>
                        <td width="10%">
                           <label>
                                Message :</label>
                        </td>
                        <td>
                          <asp:TextBox ID="txtMessage" CssClass="jsrequired" TextMode="MultiLine" Columns="75" Rows="5" runat="server"></asp:TextBox>
                        </td>
                       
                    </tr>
                    <tr>
                    <td width="10%">
                            <label>
                                Date of Issue :
                            </label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDOI" CssClass="jsrequired DateNL Date-picker" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                Upload File :
                            </label>
                        </td>
                        <td>
                            <span class="col2">
                                <input type='file' id="FuUpload" onchange="readURL(this);" />
                            </span>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                  
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveAnnouncementsDetails();">
                                <span></span>
                                <div id="spSubmit">
                                    Save</div>
                            </button>
                            &nbsp;
                            <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return AnnouncementsDetailsClear();">
                                <span></span>Cancel</button>&nbsp;
                            <asp:HiddenField ID="hfUserId" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div class="">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <div class="block">
                                                <table width="100%">
                                                    <tr valign="top">
                                                        <td valign="top">
                                                            <asp:GridView ID="dgAnnouncementsInfo" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                <Columns>
                                                                    <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Sl.No." SortExpression="SlNo">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="DOI" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Date of Issue" SortExpression="DOI">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="Title" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Title" SortExpression="Title">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="Message" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Message" SortExpression="Message">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="RoleName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Send To" SortExpression="RoleName">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderStyle-CssClass="sorting_mod editacc">
                                                                        <HeaderTemplate>
                                                                            View</HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Delete" CommandArgument='<%# Eval("AnnouncementsID")%>'
                                                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                        <HeaderTemplate>
                                                                            Delete</HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("AnnouncementsID")%>'
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
                                                            <br />
                                                            <br />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div id="dvCount" style="background: url(../img/overly.png) repeat; width: 100%;
                                display: none; height: 100%; position: fixed; top: 0; left: 0; z-index: 10000;">
                                <div id="dviCount" style="position: absolute; display: none; top: 15%; left: 31%;">
                                    <table width="600" border="0" cellpadding="0" cellspacing="0" id="tableTC" class="tblViewMain">
                                        <tr>
                                            <td class="ViewClose">
                                                <a href="javascript:closeView()">Close</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="viewTDPadding">
                                                <asp:GridView ID="dgCount" runat="server" Width="100%" AutoGenerateColumns="False"
                                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                    <Columns>
                                                        <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="SlNo" SortExpression="SlNo">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="DOI" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Date of Issue" SortExpression="DOI">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Title" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Title" SortExpression="Title">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="StaffName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Viewed By" SortExpression="StaffName">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hfAnnouncementsID" runat="server" />
</asp:Content>
