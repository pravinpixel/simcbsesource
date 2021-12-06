<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ExportSMS.aspx.cs" Inherits="SMS_ExportSMS" %>

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
    <script type="text/javascript">

        $(function () {
            var sms="";
            var row = $("[id*=dgSMSList] tr:last-child").clone(true);
            $("[id*=dgSMSList] tr").not($("[id*=dgSMSList] tr:first-child")).remove();
          
            if (sms.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found");
                $("td", row).eq(2).html("");
                $("[id*=dgSMSList]").append(row);
                row = $("[id*=dgSMSList] tr:last-child").clone(true);

            }
        });
        function GetMessageList() {
                if ($("[id*=hfViewPrm]").val() == 'true') {
                    var parameters = '{"MessageDate": "' + $("[id*=txtDate]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../SMS/ExportSMS.aspx/GetMessageList",
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
             

               
                if (sms.length == 0) {
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("No Records Found");
                    $("td", row).eq(2).html("");
                    $("[id*=dgSMSList]").append(row);
                    row = $("[id*=dgSMSList] tr:last-child").clone(true);

                }
                else {

                    $.each(sms, function () {
                        row.addClass("even");
                        $("td", row).eq(0).html($(this).find("MessageType").text());
                        $("td", row).eq(1).html($(this).find("ReceiverType").text());
                        $("td", row).eq(2).html($(this).find("MessageCount").text());
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

            function ExportSMS() {

                MsgDate = $("[id*=txtDate]").val();
                $.ajax({
                    type: "POST",
                    url: "../SMS/ExportSMS.aspx/ExportSMS",
                    data: '{"MsgDate":"' + MsgDate + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json"                 

                });
            }
            

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Export SMS</h2>
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
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" align="center">
                                        <asp:Button ID="btnExport" runat="server" OnClick="btnExport_Click" class="btn-icon button-exprots" Text="Export" />
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
