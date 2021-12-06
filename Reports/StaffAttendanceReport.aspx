<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StaffAttendanceReport.aspx.cs" Inherits="Reports_StaffAttendanceReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
      <script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtStartdate]");
            setDatePicker("[id*=txtEnddate]");
        });
     
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/performance-print.css") + "' rel='stylesheet' type='text/css'  media='print' />"%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<script type="text/JavaScript">
    $(function () {
        $("[id$=btnExport]").click(function (e) {
            window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=dvCard]').html()));
            e.preventDefault();
        });
    });
         
    </script>
    <script type="text/javascript">
        function print() {

            $(".IDprint").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 15px 0px 20px;color:#000;font-family:Arial, Helvetica, sans-serif; font-size:5px; text-align: left; !important;'

            }
            , overrideElementCSS: [
                    '../css/layout.css',
                    { href: '../css/performance-print.css', media: 'print'}]
            });
    }

    </script>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                StaffAttendance Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
              <%--  <asp:UpdatePanel ID="ups" runat="server">
                    <ContentTemplate>--%>
                        <table align="center" width="100%">
                            <tr align="center">
                                <td>
                                    <asp:TextBox ID="txtStartdate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                    &nbsp;&nbsp;
                                    <asp:TextBox ID="txtEnddate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                    &nbsp;&nbsp;
                                    <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server"
                                        OnClick="btnSearch_Click" />&nbsp;
                                   <input type="button" id="btnExport" value="Export" class="btn-icon button-exprots" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="IDprint">
                                        <div id="dvCard" runat="server">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    <%--</ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                       
                    </Triggers>
                </asp:UpdatePanel>--%>
            </div>
        </div>
    </div>
</asp:Content>
