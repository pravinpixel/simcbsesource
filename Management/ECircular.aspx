<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ECircular.aspx.cs" Inherits="Management_ECircular" %>

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
            if (window.FormData) {
                formdata = new FormData();
            }
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true') {
                GetECircularInfo(1);
            }
            else {
                GetECircularInfo(0);

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


        function readURL(input) {

            if (window.FormData) {
                formdata = new FormData();
            }
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("ECircular", input.files[0]);
                }
            }
        }
        function ViewECircularInfo(ECircularID) {

            $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Management/ECircular.aspx/GetECircularLog",
                data: '{ECircularID: ' + ECircularID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnECircularLogSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });



        }

        function EditECircularInfo(ECircularID) {

            $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Management/ECircular.aspx/EditECircularInfo",
                data: '{ECircularID: ' + ECircularID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditECircularSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });



        }

        function OnEditECircularSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var blocks = xml.find("EditECircular");
            $.each(blocks, function () {
                var block = $(this);
                $("[id*=hfECircularID]").val($(this).find("ECircularID").text());
                $("[id*=txtTitle]").val($(this).find("Title").text());
                $("[id*=txtMessage]").val($(this).find("Message").text());
                $("[id*=txtDOI]").val($(this).find("DOI").text());
                $("[id*=ddlSendTo]").val($(this).find("SendTo").text());
                $("[id*=spSubmit]").html("Update");


            });
        };


        function OnECircularLogSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var classcount = xml.find("ECircularLog");
            var row = $("[id*=dgCount] tr:last-child").clone(true);
            $("[id*=dgCount] tr").not($("[id*=dgCount] tr:first-child")).remove();
            if (classcount.length == 0) {
                $("td", row).eq(0).html("");               
                $("td", row).eq(1).html("");
                $("[id*=dgCount]").append(row);
                row = $("[id*=dgCount] tr:last-child").clone(true);
            }
            else {
                var iCount = 0;
                $.each(classcount, function () {
                    if (iCount == 0) {
                        row.addClass("even");
                        $("td", row).eq(1).html($(this).find("Message").text()).attr("align", "center");
                        var RoleID = $("[id*=hfRoleID").val();
                        var iRoleID = $(this).find("SendTo").text();
                        if (RoleID == iRoleID) {
                            $("td", row).eq(0).html($(this).find("StaffName").text()).attr("display", "none");
                        }
                        else {
                            $("td", row).eq(0).html($(this).find("StaffName").text()).attr("display", "block");
                        }

                        $("[id*=hfECircularID]").val($(this).find("ECircularID").text());
                        $("[id*=dgCount]").append(row);
                        row = $("[id*=dgCount] tr:last-child").clone(true);
                        $("[id*=dvCount]").css("display", "block");
                        $("[id*=dviCount]").css("display", "block");
                    }
                    iCount = iCount + 1;
                });

                SaveECircularLog();
                var pager = xml.find("Pager");

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }

            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else {
                $("table.form :input").prop('disabled', false);
            }


        };

        function SaveECircularLog() {
            if ($("[id*=hfECircularID]").val() != '') {
                var ECircularID = $("[id*=hfECircularID]").val();
                var parameters = '{"ECircularID": "' + ECircularID + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Management/ECircular.aspx/SaveECircularLog",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSaveECircularLogSuccess

                });
            }

        }
        function OnSaveECircularLogSuccess(response) {

            if (response.d == "E-Circular Viewed") {
                AlertMessage('success', 'E-Circular Viewed');
                GetECircularInfo(1);
                Cancel();
            }
            else if (response.d == "Viewed Failed") {
                AlertMessage('fail', 'Viewed');
                Cancel();
            }

        };
        function GetECircularInfo(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Management/ECircular.aspx/GetECircularInfo",
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
            var ECircularInfoes = xml.find("ECircularInfo");

            var row = $("[id*=dgECircularInfo] tr:last-child").clone(true);
            $("[id*=dgECircularInfo] tr").not($("[id*=dgECircularInfo] tr:first-child")).remove();

            var eanchor = ''
            var eanchorEnd = '';

            var danchor = ''
            var danchorEnd = '';

            var vanchor = ''
            var vanchorEnd = '';

            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditECircularInfo('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfViewPrm]").val() == 'false') {
                vanchor = "<a>";
                vanchorEnd = "</a>";
            }
            else {
                vanchor = "<a  href=\"javascript:ViewECircularInfo('";
                vanchorEnd = "');\">View</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteECircularInfo('";
                danchorEnd = "');\">Delete</a>";
            }
           
            if (ECircularInfoes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("").removeClass("viewacc view-links").css("display", "none");
                $("td", row).eq(6).html("").removeClass("editacc edit-links").css("display", "none");
                $("td", row).eq(7).html("").removeClass("deleteacc delete-links").css("display", "none");
                $("[id*=dvControls]").css("display", "block");
                $("[id*=dgECircularInfo]").append(row);
                row = $("[id*=dgECircularInfo] tr:last-child").clone(true);

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
                $.each(ECircularInfoes, function () {
                    var iECircularInfo = $(this);
                    var vhref = vanchor + $(this).find("ECircularID").text() + vanchorEnd;
                    var ehref = eanchor + $(this).find("ECircularID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("ECircularID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("DOI").text());
                    $("td", row).eq(2).html($(this).find("Title").text());
                    $("td", row).eq(3).html($(this).find("RoleName").text());
                    $("td", row).eq(4).html($(this).find("FileName").text());

                    var RoleID = $("[id*=hfRoleID]").val();
                    var iRoleID = $(this).find("SendTo").text();
                    if (RoleID == iRoleID) {
                        $("[id*=dvControls]").css("display", "none");
                        $("td", row).eq(5).html(vhref).addClass("viewacc view-links").attr("display", "none");
                        $("td", row).eq(6).html(ehref).addClass("editacc edit-links").attr("display", "none");
                        $("td", row).eq(7).html(dhref).addClass("deleteacc delete-links").attr("display", "none");
                    }
                    else {
                        $("[id*=dvControls]").css("display", "block");
                        $("td", row).eq(5).html(vhref).addClass("viewacc view-links").attr("display", "block");
                        $("td", row).eq(6).html(ehref).addClass("editacc edit-links").attr("display", "block");
                        $("td", row).eq(7).html(dhref).addClass("deleteacc delete-links").attr("display", "block");
                    }


                    $("[id*=dgECircularInfo]").append(row);
                    row = $("[id*=dgECircularInfo] tr:last-child").clone(true);
                });
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
            }
        };

        function SaveECircularDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfECircularID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfECircularID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var ECircularID = $("[id*=hfECircularID]").val();
                    var Title = $("[id*=txtTitle]").val();
                    var Message = $("[id*=txtMessage]").val();
                    var DOI = $("[id*=txtDOI]").val();
                    var SendTo = $("[id*=ddlSendTo]").val();
                    var tempfile = $('#FuUpload').val().replace(/C:\\fakepath\\/i, ''); ;
                    var UploadFile = tempfile.substring(tempfile.lastIndexOf('\\') + 1);
                    var parameters = '{"ECircularID": "' + ECircularID + '","DOI": "' + DOI + '","Title": "' + Title + '","Message": "' + Message + '","SendTo": "' + SendTo + '","FileName": "' + UploadFile + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Management/ECircular.aspx/SaveECircular",
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
        // Delete ECircularInfo
        function DeleteECircularInfo(id) {
            var parameters = '{"ECircularInfoID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Management/ECircular.aspx/DeleteECircularInfo",
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
                var ECircularID = $("[id*=hfECircularID]").val();
                if (formdata) {
                    formdata.append("ECircularID", ECircularID);
                    if (formdata) {
                        $.ajax({
                            url: "../Management/ECircular.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                            }
                        });
                    }
                }
                ECircularDetailsClear();
                GetECircularInfo(1);
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                ECircularDetailsClear();
            }
            else if (response.d) {
                AlertMessage('success', 'Inserted');
                $("[id*=hfECircularID]").val(response.d);
                var ECircularID = $("[id*=hfECircularID]").val();
                if (formdata) {
                    formdata.append("ECircularID", ECircularID);
                    if (formdata) {
                        $.ajax({
                            url: "../Management/ECircular.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                            }
                        });
                    }
                }
                ECircularDetailsClear();
                GetECircularInfo(1);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                ECircularDetailsClear();
            }
            else {
                AlertMessage('fail', response.d);
                ECircularDetailsClear();
            }
        };

        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetECircularInfo(1);
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
            GetECircularInfo(parseInt($(this).attr('page')));
        });
        function ECircularDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $("[id*=hfECircularID]").val("");
            $("[id*=txtTitle]").val("");
            $("[id*=txtMessage]").val("");
            $("[id*=txtDOI]").val("");
            $("[id*=ddlSendTo]").val("");
            $("[id*=FuUpload]").val("");
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
                Manage E-Circular
            </h2>
            <div class="block john-accord content-wrapper2">
                <table class="form">
                    <tr><td>
                        <div id="dvControls">
                        <table>
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
                                        E-Cricular Title :</label>
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
                                    <asp:TextBox ID="txtMessage" CssClass="jsrequired" TextMode="MultiLine" Columns="75"
                                        Rows="5" runat="server"></asp:TextBox>
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
                                <td align="center">
                                    <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveECircularDetails();">
                                        <span></span>
                                        <div id="spSubmit">
                                            Save</div>
                                    </button>
                                    &nbsp;
                                    <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                        onclick="return ECircularDetailsClear();">
                                        <span></span>Cancel</button>&nbsp;
                                    <asp:HiddenField ID="hfUserId" runat="server" />
                                </td>
                            </tr></table>
                        </div>
                    </td></tr>
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
                                                            <asp:GridView ID="dgECircularInfo" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                <AlternatingRowStyle CssClass="odd"></AlternatingRowStyle>
                                                                <Columns>
                                                                    <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Sl.No." SortExpression="SlNo">
                                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="DOI" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Circular Date" SortExpression="DOI">
                                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="Title" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Title" SortExpression="Title">
                                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="Message" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Message" SortExpression="Message" Visible="False">
                                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="RoleName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Send To" SortExpression="RoleName">
                                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="FileName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="FileName" SortExpression="FileName">
                                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderStyle-CssClass="sorting_mod viewacc">
                                                                        <HeaderTemplate>
                                                                            View</HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Delete" CommandArgument='<%# Eval("ECircularID")%>'
                                                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" CssClass="sorting_mod viewacc"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderStyle-CssClass="sorting_mod editacc">
                                                                        <HeaderTemplate>
                                                                            Edit</HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("ECircularID")%>'
                                                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" CssClass="sorting_mod editacc"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                        <HeaderTemplate>
                                                                            Delete</HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("ECircularID")%>'
                                                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" CssClass="sorting_mod deleteacc"></HeaderStyle>
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                                <RowStyle CssClass="even"></RowStyle>
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
                                                       <%--  <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="SlNo" SortExpression="SlNo">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="DOI" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Circular Date" SortExpression="DOI">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Title" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Title" SortExpression="Title">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>--%>
                                                        <asp:BoundField DataField="StaffName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Viewed By" SortExpression="StaffName">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Message" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Message" SortExpression="Message">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
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
    <asp:HiddenField ID="hfECircularID" runat="server" />
    <asp:HiddenField ID="hfRoleID" runat="server" />
</asp:Content>
