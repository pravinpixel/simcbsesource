<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ApproveSMSView.aspx.cs" Inherits="ApproveSMSView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/view.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
    <%="<link href='" + ResolveUrl("~/css/layout.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>

    <script type="text/javascript">

        $(function () {
            var msgType = $("[id*=hfmsgType]").val();
            var ReceiverType = $("[id*=hfReceiverType]").val();
            var MsgDate = $("[id*=hfMsgDate]").val();
            if (msgType != "" && ReceiverType != "" && MsgDate != "") {
                GetSMSListByType(msgType, ReceiverType, MsgDate);
            }
            else {
                GetSMSListByType("", "", "");
                var SMSLists = "";

                row = $("[id*=dgSMSList] tr:last-child").clone(true);
                $("[id*=dgSMSList] tr").not($("[id*=dgSMSList] tr:first-child")).remove();
                if (SMSLists.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("");
                    $("td", row).eq(3).html("No Records Found").attr("align", "center");
                    $("td", row).eq(4).html("");
                    $("td", row).eq(5).html("");
                    $("td", row).eq(6).html("");
                    $("[id*=dgSMSList]").append(row);
                    row = $("[id*=dgSMSList] tr:last-child").clone(true);

                }
            }
        });



        function GetSMSListByType(msgType, ReceiverType, MsgDate) {

            $.ajax({
                type: "POST",
                url: "../SMS/ApproveSMSView.aspx/GetSMSListByType",
                data: '{"msgType":"' + msgType + '","ReceiverType":"' + ReceiverType + '","MsgDate":"' + MsgDate + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess
            });
        }

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var SMSLists = xml.find("SMSList");
            row = $("[id*=dgSMSList] tr:last-child").clone(true);
            $("[id*=dgSMSList] tr").not($("[id*=dgSMSList] tr:first-child")).remove();
            row.addClass("even");
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteMessage('";
                danchorEnd = "');\">Delete</a>";
            }
            if (SMSLists.length == 0) {
                $("[id*=dgSMSList] tr").not($("[id*=dgSMSList] tr:first-child")).remove();
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Records Found").attr("align", "center");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("[id*=dgSMSList]").append(row);
            }
            else {

                $.each(SMSLists, function () {
                    var dhref = danchor + $(this).find("MessageID").text() + danchorEnd;
                    var chkAdd = null;
                    chkAdd = "<input name=\"chkAdd\" value=" + $(this).find("MessageID").text() + " type=\"checkbox\">";
                    $("td", row).eq(0).html(chkAdd);
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("StudentName").text());
                    $("td", row).eq(3).html($(this).find("ReceiverType").text());
                    $("td", row).eq(4).html($(this).find("MobileNumber").text());
                    $("td", row).eq(5).html($(this).find("Message").text());
                    $("td", row).eq(6).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgSMSList]").append(row);
                    row = $("[id*=dgSMSList] tr:last-child").clone(true);
                });
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


        function CheckAll(id) {
            $("[id*=dgSMSList]").find("input[name*='" + id + "']:checkbox").each(function () {
                if ($("[id*=" + id + "]").is(':checked')) {
                    $(this).attr('checked', true);
                }
                else {
                    $(this).attr('checked', false);
                }
            });
        }

        function DeleteMessage(id) {
            var parameters = '{"MessageID": "' + id + '"}';
            $.ajax({
                type: "POST",
                url: "../SMS/ApproveSMSView.aspx/DeleteMessage",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDeleteMessageSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDeleteMessageSuccess(response) {

            if (response.d == "Deleted") {
                alert("Deleted");
                var Type = $("[id*=hfmsgType]").val();
                var MsgDate = $("[id*=hfMsgDate]").val();
                if (Type != "" && MsgDate) {
                    GetSMSListByType(Type, MsgDate);
                }
            }
            else if (response.d == "Delete Failed") {
                alert("Delete Failed");
            }
        }
        function GetQuery() {
            var sqlstr = '';
            var subQuery = '';
            $(".even").each(function () {
                var chkAdd = $(this).find("input[name*='chkAdd']").is(':checked');
                var MessageID = $(this).find("input[name*='chkAdd']").val();
                if (chkAdd == true && MessageID != "") {
                    subQuery = "delete from O_Message where MessageID='" + MessageID + "'";
                }
                sqlstr += subQuery;
            });
            return sqlstr;
        }
        function BulkDelete() {
            $("[id*=btnSubmit]").attr("disabled", "true");
            var query = '';
            query = GetQuery();
            var parameters = '{"query": "' + query + '"}';
            if (query) {
                $.ajax({
                    type: "POST",
                    url: "../SMS/ApproveSMSView.aspx/BulkDelete",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnBulkDeleteSuccess,
                    failure: function (response) {
                        alert('Delete Failed');
                    },
                    error: function (response) {
                        alert('Delete Failed');
                    }
                });
            }

        }
        // Save On Success
        function OnBulkDeleteSuccess(response) {
            if (response.d == "Deleted") {
                var Type = $("[id*=hfmsgType]").val();
                var MsgDate = $("[id*=hfMsgDate]").val();
                if (Type != "" && MsgDate) {
                    GetSMSListByType(Type, MsgDate);
                }
                alert('Deleted Successfully');
            }
            else if (response.d == "Delete Failed") {
                alert("Delete Failed");
            }

        }
    </script>
    <style type="text/css">
        article, aside, figure, footer, header, hgroup, menu, nav, section
        {
            display: block;
        }
    </style>
</head>
<body style="overflow: auto;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td valign="middle">
                <form id="form1" runat="server">
                <div class="grid_10">
                    <div class="box round first fullpage">
                        <h2>
                            SMS Un-Approved List View</h2>
                        <div class="clear">
                        </div>
                        <div class="block john-accord content-wrapper2">
                            <ul class="section menu">
                                <li>
                                    <ul class="johnmenu">
                                        <li>
                                            <div class="block1" style="border-bottom-style: none; border-bottom-width: 0px;">
                                                <table width="100%">
                                                    <tr valign="top">
                                                        <td valign="top">
                                                            <asp:GridView ID="dgSMSList" runat="server" Width="100%" AutoGenerateColumns="False"
                                                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="CheckAll" HeaderStyle-CssClass="sorting_mod">
                                                                        <HeaderTemplate>
                                                                            <input id="chkAdd" type="checkbox" onchange="CheckAll(this.id);" />Select
                                                                        </HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:CheckBox ID="chkAddSelect" runat="server" AutoPostBack="false" />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:BoundField DataField="RegNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="RegNo/EmpCode" SortExpression="RegNo">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="StudentName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Name" SortExpression="StudentName">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="ReceiverType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="ReceiverType" SortExpression="ReceiverType">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="MobileNumber" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="MobileNumber" SortExpression="MobileNumber">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="Message" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                        HeaderText="Message" SortExpression="Message">
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:BoundField>
                                                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                        <HeaderTemplate>
                                                                            Delete</HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("MessageID") %>'
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
                                                    <tr>
                                                        <td id="buttonCss">
                                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="BulkDelete();">
                                                                <span></span>
                                                                <div id="spSubmit">
                                                                    Delete</div>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40">
                                                            <asp:HiddenField ID="hfmsgType" runat="server" />
                                                            <asp:HiddenField ID="hfAcademicyear" runat="server" />
                                                            <asp:HiddenField ID="hfMsgDate" runat="server" />
                                                            <asp:HiddenField ID="hfUserId" runat="server" />
                                                            <br />
                                                            <asp:HiddenField ID="hfReceiverType" runat="server" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                </form>
            </td>
        </tr>
    </table>
</body>
</html>
