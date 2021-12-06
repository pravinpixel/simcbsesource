<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StudentsIDCardReport.aspx.cs" Inherits="Reports_StudentsIDCardReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <link href="../css/IDprint.css" type="text/css" media="print"  rel="Stylesheet"/>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function Print() {


            $(".IDprint").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
               // styleToAdd: 'padding:5px 5px 0px 5px;margin:5px 5px 0px 5px;color:#000;font-family:Arial, Helvetica, sans-serif; font-size:8px; text-align: left; !important;'

        }
             , overrideElementCSS: [
                    '../css/IDprint.css',
                    { href: '../css/IDprint.css', media: 'print'}]
            });
        }

    </script>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Students ID Card Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <table align="left">
                        <tr align="left">
                            <td>
                                <label>
                                    Class :</label>&nbsp;
                                <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                    <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;
                                <label>
                                    Section :</label>&nbsp;
                                <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                    <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;
                                <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" OnClick="btnSearch_Click" />&nbsp;<asp:Button
                                    ID="btnExport" class="btn-icon button-exprots" Text="Export" runat="server" 
                                    OnClick="btnExport_Click" Visible="False" />
                                &nbsp;<asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                                    </asp:DropDownList>
                                    <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" OnClientClick="Print(); return false;" />
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
                </div>
            </div>
        </div>
    </div>
</asp:Content>
