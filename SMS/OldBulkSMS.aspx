<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="OldBulkSMS.aspx.cs" Inherits="SMS_OldBulkSMS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript" src="../js/maxlength.js"></script>
    <script type="text/javascript">
        $(function () {
            //        GetSMSCopy Function on page load
            MessageType();
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')

                var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);


        });
        function SelectAll() {
            $("[id*=chkClass]").find("input:checkbox").each(function () {
                if ($("[id*=chkSelectAll]").is(':checked')) {
                    $(this).attr('checked', true);
                }
                else {
                    $(this).attr('checked', false);
                }
            });

        }

        function SMS() {
            AlertMessage('success', 'SMS Sent');
            Cancel();
        }
        function SMSSelectAll() {

            $("[id*=chkSmsCopy]").find("input:checkbox").each(function () {
                if ($("[id*=chkSMSSelectAll]").is(':checked')) {
                    $(this).attr('checked', true);
                }
                else {
                    $(this).attr('checked', false);
                }
            });

        }
        function MessageType() {
            if ($("[id*=MsgText]").is(':checked')) {
                $("[id*=ddlTemplate]").attr('disabled', true);
                $("[id*=txtMessage]").val("");
            }
            else if ($("[id*=msgTemplate]").is(':checked')) {

                $("[id*=ddlTemplate]").attr('disabled', false);
                $("[id*=txtMessage]").val("");
            }
        }

        function GetMessageTemplate() {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var MessTempID = $("[id*=ddlTemplate]").val();
                if (MessTempID != "") {
                    $.ajax({
                        type: "POST",
                        url: "../SMS/OldBulkSMS.aspx/GetMessageTemplate",
                        data: '{MessTempID: ' + MessTempID + '}',
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
                    $("[id*=txtMessage]").val("");
                    $("[id*=status1]").html("(0/160) Left(Max.160 Charactes only allowed)").addClass("status2");
                    return false;
                }
            }

        }

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var MessageTemplates = xml.find("GetMessageTemplate");
            $.each(MessageTemplates, function () {
                var MessageTemplate = $(this);
                $("[id*=txtMessage]").val($(this).find("Message").text());
                var myLength = $(this).find("Message").text().length;
                if (myLength <= 160) {
                    $("[id*=status1]").html("(" + myLength + "/160) Left(Max.160 Charactes only allowed)").addClass("status2");
                }


            });

        };
        function Cancel() {
            $("[id*=chkSelectAll]").attr("checked", false);
            SelectAll();
            $("[id*=chkSMSSelectAll]").attr("checked", false);
            SMSSelectAll();
            $("[id*=txtMessage]").val("");
            $("[id*=ddlTemplate]").attr('disabled', true);
            $("[id*=btnSubmit]").attr('disabled', false);
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Send");
            $("[id*=status1]").html("(0/160) Left(Max.160 Charactes only allowed)").addClass("status2");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Old Students Bulk SMS</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table>
                                <tr>
                                    <td valign="top">
                                        <b>Class</b>
                                    </td>
                                    <td>
                                        <input type="checkbox" id="chkSelectAll" onclick="SelectAll();" />
                                        <b>Select All</b>
                                        <asp:CheckBoxList ID="chkClass" runat="server" CssClass="checkboxlist" RepeatColumns="20">
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Send To</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlSendTo" runat="server">
                                            <asp:ListItem Text="Priority" Selected="True" Value="P"></asp:ListItem>
                                            <asp:ListItem Text="Father" Value="F"></asp:ListItem>
                                            <asp:ListItem Text="Mother" Value="M"></asp:ListItem>
                                            <asp:ListItem Text="Gaurdian" Value="G"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <b>SMS Copy To</b>
                                    </td>
                                    <td>
                                        <input type="checkbox" id="chkSMSSelectAll" onclick="SMSSelectAll();" />
                                        <b>Select All</b>
                                        <asp:CheckBoxList ID="chkSmsCopy" runat="server" CssClass="checkboxlist" Font-Bold="False"
                                            RepeatColumns="8" RepeatDirection="Horizontal">
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Message By</b>
                                    </td>
                                    <td>
                                        <input type="radio" checked="checked" class="Mess" id="MsgText" onclick="MessageType();"
                                            name="mes" />Entry
                                        <input type="radio" class="Mess" id="msgTemplate" name="mes" onclick="MessageType();" />Template
                                        <asp:DropDownList ID="ddlTemplate" onchange="GetMessageTemplate();" runat="server"
                                            AppendDataBoundItems="True">
                                            <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Message</b>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtMessage" Rows="5" Columns="30" MaxLength="160" runat="server"
                                            data-maxsize="160" data-output="status1" TextMode="MultiLine"></asp:TextBox>
                                        <%-- <textarea rows="6" cols="40" id="txtMessage" data-maxsize="160" data-output="status1"
                                            wrap="virtual"></textarea>--%><br />
                                        <div id="status1" class="status1">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td id="buttonCss">
                                        <%-- <button id="btnSubmit" type="button" class="btn-icon btn-navy btn-save" onclick="SavePermission();">
                                            <span></span>
                                            <div id="spSubmit">
                                                Send</div>
                                        </button>--%>
                                        <asp:Button ID="btnSearch" runat="server" class="btn-icon btn-navy btn-send" Text="Send"
                                            OnClick="btnSearch_Click" />
                                        <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                            onclick="return Cancel();">
                                            <span></span>Cancel</button>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
