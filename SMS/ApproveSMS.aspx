<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ApproveSMS.aspx.cs" Inherits="SMS_ApproveSMS" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtDate]");
        }); 
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
  <script src="../prettyphoto/js/prettyPhoto.js" type="text/javascript"></script>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("a[rel^='prettyPhoto']").prettyPhoto();
        });
    </script>
    <script type="text/javascript">

        $(function () {
            var sms="";
            var row = $("[id*=dgSMSList] tr:last-child").clone(true);
            $("[id*=dgSMSList] tr").not($("[id*=dgSMSList] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';

            if ($("[id*=hfViewPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:ViewList('";
                eanchorEnd = "');\">View</a>";
            }

            if (sms.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("viewacc view-links");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("[id*=dgSMSList]").append(row);
                row = $("[id*=dgSMSList] tr:last-child").clone(true);

            }
        });
        function GetMessageList() {
                if ($("[id*=hfViewPrm]").val() == 'true') {
                    var parameters = '{"MessageDate": "' + $("[id*=txtDate]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../SMS/ApproveSMS.aspx/GetMessageList",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSuccess                      
                    });
                }
                else {
                    return false;
                }
            }
            function OnSuccess(response) {
                var xmlDoc = $.parseXML(response.d);
                var xml = $(xmlDoc);
                var sms = xml.find("SMS");
                var row = $("[id*=dgSMSList] tr:last-child").clone(true);
                $("[id*=dgSMSList] tr").not($("[id*=dgSMSList] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';

                if ($("[id*=hfViewPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a  href=\"javascript:ViewList('";
                    eanchorEnd = "');\">View</a>";
                }
                 
                if (sms.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("No Records Found").attr("align", "left");
                    $("td", row).eq(2).html("");
                    $("td", row).eq(3).html("").addClass("viewacc view-links");
                    $("[id*=dgSMSList]").append(row);
                    row = $("[id*=dgSMSList] tr:last-child").clone(true);

                }
                else {

                    $.each(sms, function () {
                        var ehref = eanchor + $(this).find("MessageType").text() + "','" + $(this).find("ReceiverType").text() + "','" + $("[id*=txtDate]").val() + eanchorEnd;

                        row.addClass("even");
                        $("td", row).eq(0).html($(this).find("MessageType").text());
                        $("td", row).eq(1).html($(this).find("ReceiverType").text());
                        $("td", row).eq(2).html($(this).find("MessageCount").text());
                        $("td", row).eq(3).html(ehref).addClass("viewacc view-links");
                        $("[id*=dgSMSList]").append(row);
                        row = $("[id*=dgSMSList] tr:last-child").clone(true);
                    });

                }
                if ($("[id*=hfViewPrm]").val() == 'false') {
                    $('.viewacc').hide();
                }
                else {
                    $('.viewacc').show();
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
            function ViewList(msgType,ReceiverType, MsgDate) {
                if ($("[id*=hfViewPrm]").val() == 'true') {
                    $("table.form :input").prop('disabled', false);
                    $.ajax({
                        type: "POST",
                        url: "../SMS/ApproveSMS.aspx/ViewList",
                        data: '{"msgType":"' + msgType + '","ReceiverType":"' + ReceiverType + '","MsgDate":"' + MsgDate + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            var url = "../SMS/ApproveSMSView.aspx?msgType=" + msgType + "&ReceiverType=" + ReceiverType + "&MsgDate=" + MsgDate + "";
                            $.prettyPhoto.open('ApproveSMSView.aspx?msgType=' + msgType + '&ReceiverType=' + ReceiverType + '&MsgDate=' + MsgDate + '&iframe=true&width=1000&height=500', '', '');
                        },
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

            function SendSMS() {
                if (jConfirm('Are you sure to send the SMS?', 'Confirm', function (r) {
                    if (r) {
                       MsgDate= $("[id*=txtDate]").val();
                        $.ajax({
                            type: "POST",
                            url: "../SMS/ApproveSMS.aspx/SendSMS",
                            data: '{"MsgDate":"' + MsgDate + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSendSMSSuccess,
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

            function OnSendSMSSuccess(response) {

                if (response.d == "SMS Sent") {
                    AlertMessage('success', 'SMS Sent');
                    GetMessageList();
                    window.location.href = 'http://192.168.1.102/SIMV8/SIMSMS/Default.aspx';
                }
                else if (response.d == "SMS Failed") {
                    AlertMessage('fail', 'SMS Failed');
                }

            };

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Approve SMS</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table class="form" width="90%">
                                <tr>
                                    <td>
                                        <label>
                                            Select Date :</label>
                                        <asp:TextBox ID="txtDate" runat="server" CssClass="jsrequired DateNL date-picker"></asp:TextBox>
                                        <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" runat="server"
                                            onclick="return GetMessageList();">
                                            <span></span>Search</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:GridView ID="dgSMSList" runat="server" Width="100%" AutoGenerateColumns="False"
                                            AllowPaging="false" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                            AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                            <Columns>
                                                <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="MessageType" HeaderText="MessageType"
                                                    SortExpression="MessageType" />
                                                      <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="ReceiverType" HeaderText="ReceiverType"
                                                    SortExpression="ReceiverType" />
                                                <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="MessageCount" HeaderText="Count"
                                                    SortExpression="MessageCount" />
                                                <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                    HeaderStyle-CssClass="sorting_mod viewacc">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkClick" runat="server" Text="Click Here" CommandName="Edit"
                                                            CausesValidation="false" CommandArgument='<%# Eval("MessageType") %>' CssClass="links"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" align="center">
                                        <!-- <button id="btnsend" type="button" class="btn-icon btn-navy btn-save" onclick="SendSMS();">
                                            <span></span>Approve</button> -->
                                        <a class="btn-icon btn-navy btn-save" target="_blank" href="http://192.168.1.102/SIMCBSE/SIMSMS/Default.aspx">Approve</a>
                                        &nbsp; &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <br />
            </div>
        </div>
    </div>
</asp:Content>
