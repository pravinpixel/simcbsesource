<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="DayBookReport.aspx.cs" Inherits="Reports_DayBookReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtStartdate]");
        });
        function Cancel() {
            location.reload();
        }
        function Validate() {
            if ($("[id*=txtAccManual1]").val() == "Other Accounts if any") {
                if ($("[id*=txtAccManualValue1]").val() == "0.00") {
                    return true;
                }
                else {
                    return false;
                }
            }
            else {
                return true;
            }
        }
        function Save() {
            if ($('#aspnetForm').valid()) {
                if (Validate() == true) {
                    value();
                    SaveData();
                    print();
                }
                else {
                    alert("Please enter valid account details");
                    $("[id*=txtAccManual1]").focus();
                }
            }
        }
        function SaveData() {
            var parameters = '{"dayBookId":"' + $("[id*=hdnDayBookId]").val() + '","acdYear": "' + $("[id*=hfAcademicYear]").val() + '","accDate": "' + $("[id*=txtStartdate]").val() + '","otherAcc1": "' + $("[id*=txtAccManual1]").val() + '","otherAcc2": "' + $("[id*=txtAccManual2]").val() + '","otherCashSpent": "' + $("[id*=txtOtherCashSpent]").val() + '","otherAcc1Value": "' + $("[id*=txtAccManualValue1]").val() + '","otherAcc2Value": "' + $("[id*=txtAccManualValue2]").val() + '","otherCashSpentValue": "' + $("[id*=txtOtherCashSpentValue]").val() + '","userId": "' + $("[id*=hfuserid]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Reports/DayBookReport.aspx/InsertAccDetails",
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
        function OnSaveSuccess(response) {
            //  alert(response.d);
        }

        $(function () {

            $(".water").each(function () {
                $tb = $(this);
                if ($tb.val() != this.title) {
                    $tb.removeClass("water");
                }
            });
            $(".water").blur(function () {
                $tb = $(this);
                if ($.trim($tb.val()) == "") {
                    $tb.val(this.title);
                    $tb.addClass("water");
                }
            });
            $(".water").focus(function () {
                $tb = $(this);
                if ($tb.val() == this.title) {
                    $tb.val("");
                    $tb.removeClass("water");
                }
            });

            $(".acc").blur(function () {
                $tb = $(this);
                var reg = /^\d+(?:\.\d+)?$/;
                if (reg.test($(this).val())) {
                    value();
                }
            });
        });

        function value() {
            if ($("[id*=txtAccManualValue1]").val() == "") {
                $("[id*=txtAccManualValue1]").val() = "0.00";
            }
            if ($("[id*=txtAccManualValue2]").val() == "") {
                $("[id*=txtAccManualValue2]").val() = "0.00";
            }
            if ($("[id*=txtOtherCashSpentValue]").val() == "") {
                $("[id*=txtOtherCashSpentValue]").val() = "0.00";
            }
            var totValue = parseFloat($("[id*=hdnTotalAcc]").val()) + parseFloat($("[id*=txtAccManualValue1]").val()) + parseFloat($("[id*=txtAccManualValue2]").val());
            var totCashSpent = parseFloat($("[id*=lblCashSpent]").html()) + parseFloat($("[id*=txtOtherCashSpentValue]").val()) + parseFloat($("[id*=lblAdvance]").val()) + parseFloat($("[id*=lblCheque]").val()) + parseFloat($("[id*=lblCashCard]").val()) + parseFloat($("[id*=lblQRCode]").val()) + parseFloat($("[id*=lblNetbank]").val()) + parseFloat($("[id*=lblPayTM]").val()) + parseFloat($("[id*=lblCardQR]").val()) + parseFloat($("[id*=lblCashQR]").val()) + parseFloat($("[id*=lblScholarshipAEWS1]").val()) + parseFloat($("[id*=lblScholarshipAEWS2]").val()) + parseFloat($("[id*=lblScholarshipAEWS3]").val()) + parseFloat($("[id*=lblScholarshipAEWS3]").val()) + parseFloat($("[id*=lblScholarshipSC1]").val()) + parseFloat($("[id*=lblScholarshipSC2]").val()) + parseFloat($("[id*=lblScholarshipSC3]").val()) + parseFloat($("[id*=lblAdvance]").val()) + parseFloat($("[id*=lblCard]").val()) + parseFloat($("[id*=<CloudUploadOutlined />]").val());
            var netCashInHand = parseFloat(totValue) - parseFloat(totCashSpent) + parseFloat($("[id*=lblCashReturn]").html());
            $("[id*=lblNetCash]").html(parseFloat(totValue));
            $("[id*=lblNetCashInHand]").html(parseFloat(netCashInHand));
        }   


 
    </script>
    <style type="text/css">
        td span
        {
            padding-left: 6px;
        }
        .water
        {
            font-family: Tahoma, Arial, sans-serif;
            color: gray;
            font-size: 11px;
            font-style: italic;
        }
        .noitalic
        {
            font-style: normal;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/daybook-print.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
    <script type="text/javascript">
        function print() {
            if ($("[id*=txtStartdate]").val() != "") {
                $(".printContent").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'

            }
            , overrideElementCSS: [
                    '../css/layout.css',
                    { href: '../css/daybook-print.css', media: 'print'}]
            });
            }
            else {
                AlertInfo('info', "Please select Date");
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnTotalAcc" Value="0.00" runat="server" />
    <asp:HiddenField ID="hdnDayBookId" Value="0.00" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Day Book Report</h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2">
                <div align="center">
                    <table width="100%" align="center" class="form">
                        <tr align="center">
                            <td width="56%" align="right" style="padding-right: 10px;">
                                <label>
                                    Select Date</label>
                                <asp:TextBox ID="txtStartdate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                            </td>
                            &nbsp;&nbsp; &nbsp;&nbsp;
                            <td width="44%" align="left">
                                <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server"
                                    OnClick="btnSearch_Click" />
                                <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server"
                                    OnClientClick="print()" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <table width="500" class="printContent">
                        <tr class="tbl-bg">
                            <td colspan="2" style="padding-left: 10px; padding-bottom: 10px;">
                                Amalorpavam Lourdes Academy
                            </td>
                            <td align="right" style="padding-right: 10px; padding-bottom: 10px;">
                                Date:
                                <asp:Label ID="lblDate" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr class="tbl-subbg">
                            <td height="25" colspan="2">
                                <label>
                                    <strong>Details</strong></label>
                            </td>
                            <td class="price-brd-left">
                                <label>
                                    <strong>Amount</strong></label>
                            </td>
                        </tr>
                        <tr>
                            <td width="300" height="25">
                                <label>
                                    LKG New Admission Accounts</label>
                            </td>
                            <td width="50" align="center" class="colan">
                                :
                            </td>
                            <td width="200" class="price-brd-left">
                                <asp:Label ID="lbllkgAdminAcc" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <label>
                                    Pre Primary Accounts
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblPrePrimAcc" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <label>
                                    Primary Accounts
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblPrimAcc" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <label>
                                    High School Accounts
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblHighSchAcc" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <label>
                                    High Secondary Accounts
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblHighSecAcc" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <label>
                                    Hostel Accounts
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblHostelAcc" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                         <tr class="bankForm">
                            <td height="25" class="col2">
                                <label>
                                   ALA application fees accounts
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblAHSSApp" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                           <tr class="bankForm">
                            <td height="25" class="col2">
                                <label>
                                   ASOS application fees accounts
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblAECAApp" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                &nbsp;&nbsp;
                                <asp:TextBox ID="txtAccManual1" runat="server" class="water jsrequired" Text="Other Accounts if any"
                                    ToolTip="Other Accounts if any"></asp:TextBox>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:TextBox ID="txtAccManualValue1" Text="0.00" class="acc  noitalic numericswithdecimals"
                                    runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                &nbsp;&nbsp;<asp:TextBox ID="txtAccManual2" class="water jsrequired" Text="Other Accounts if any"
                                    ToolTip="Other Accounts if any" runat="server"></asp:TextBox>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:TextBox ID="txtAccManualValue2" Text="0.00" class="acc noitalic numericswithdec"
                                    runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Net Cash Received</label></strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblNetCash" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Cash Spent</label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblCashSpent" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                &nbsp;&nbsp;<asp:TextBox ID="txtOtherCashSpent" runat="server" class="water" Text="Other Cash Spent if any"
                                    ToolTip="Other Cash Spent if any"></asp:TextBox>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:TextBox ID="txtOtherCashSpentValue" runat="server" Text="0.00" class="acc noitalic numericswithdecimals"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Advance Fees</label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblAdvance" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr style="display:none;" class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Cash Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblCash" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Cheque Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblCheque" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Card Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblCard" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Cash + Card Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblCashCard" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total QR Code Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblQRCode" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total NetBanking Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblNetbank" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total PayTM Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblPayTM" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Card + QR Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblCardQR" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Cash + QR Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblCashQR" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Scholarship(AEWS) - I Term Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblScholarshipAEWS1" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Scholarship(AEWS) - II Term Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblScholarshipAEWS2" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Scholarship(AEWS) - III Term Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblScholarshipAEWS3" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Scholarship(SC/ST) - I Term Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblScholarshipSC1" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Scholarship(SC/ST) - II Term Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblScholarshipSC2" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Total Scholarship(SC/ST) - III Term Payment
                                    </label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblScholarshipSC3" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <label>
                                    Cash Returned Against Vouchers</label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblCashReturn" runat="server">0.00</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2">
                                <strong>
                                    <label>
                                        Net Cash In Hand</label>
                                </strong>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <strong>
                                    <asp:Label ID="lblNetCashInHand" runat="server">0.00</asp:Label>
                                </strong>
                            </td>
                        </tr>
                    </table>
                </div>
                <table align="center" width="100%">
                    <tr class="bankForm">
                        <td colspan="2" align="center">
                            &nbsp;
                        </td>
                    </tr>
                    <tr class="bankForm">
                        <td colspan="2" align="center">
                            <button id="btnBankSubmit" type="button" class="btn-icon btn-navy btn-update" onclick="Save();">
                                <span></span>
                                <div id="spBankSubmit">
                                    Update</div>
                            </button>
                            <button id="btnBankCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return Cancel();">
                                <span></span>Cancel</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
