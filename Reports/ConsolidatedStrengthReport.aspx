<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ConsolidatedStrengthReport.aspx.cs" Inherits="Reports_ConsolidatedStrengthReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
      <style>
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
    <%="<link href='" + ResolveUrl("~/css/strength-print.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
    <script type="text/javascript">
        function print() {

            $(".printContent").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'

            }
            , overrideElementCSS: [
                    '../css/layout.css',
                    { href: '../css/strength-print.css', media: 'print'}]
            });
        }
            
        
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnConsolidatedStrengthId" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Consolidated Strength Report</h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2">
                <div align="center">
                    <table width="500" class="printContent">
                        <tr class="tbl-bg">
                            <td colspan="3" style="padding-left: 10px; padding-bottom: 10px;" align="center">
                                <strong>Amalorpavam Lourds Academy </strong>
                            </td>
                        </tr>
                        <tr class="tbl-bg">
                            <td colspan="3" style="padding-left: 10px; padding-bottom: 10px;" align="right">
                                &nbsp; Date:
                                <asp:Label ID="lblDate" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr class="tbl-subbg">
                            <td height="25" colspan="2" align="center">
                                <label>
                                    <strong>Description</strong></label>
                            </td>
                            <td class="price-brd-left" align="center">
                                <label>
                                    <strong>Count</strong></label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Total Student Strength</label>
                            </td>
                            <td width="50px" align="center">
                                :
                            </td>
                            <td width="100" class="price-brd-left">
                                <asp:Label ID="lblStudentCount" runat="server">0</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Total No. of Boys
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblBoysCount" runat="server">0</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Total No. of Girls
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblGirlsCount" runat="server">0</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Total Staff Strength
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblStaffCount" runat="server">0</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Total No. of Male Staff
                                </label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblMaleStaff" runat="server">0</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Total No. of Female Staff</label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblFemaleStaff" runat="server">0</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm" style="display:none">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Total No. of Handicap Students</label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblHandicap" runat="server">0</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Today Student Strength</label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblTodayStudents" runat="server">0</asp:Label>
                            </td>
                        </tr>
                        <tr class="bankForm">
                            <td height="25" class="col2" align="left" style="padding-left: 20px">
                                <label>
                                    Today Staff Strength</label>
                            </td>
                            <td align="center">
                                :
                            </td>
                            <td class="price-brd-left">
                                <asp:Label ID="lblTodayStaffs" runat="server">0</asp:Label>
                            </td>
                        </tr>
                    </table>
                    <table width="100%" align="left" class="form">
                        <tr align="center">
                            <td align="center" colspan="2">
                                <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server"
                                    OnClientClick="print()" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
