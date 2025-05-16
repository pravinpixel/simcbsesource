<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ConsolidateReport.aspx.cs" Inherits="Reports_ConsolidateReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/report-print.css") + "' rel='stylesheet' type='text/css'  media='print' />"%>
    <script type="text/JavaScript">

        function Export() {

            var a = document.createElement('a');
            var data_type = 'data:application/vnd.ms-excel';
            var table_html = encodeURIComponent($('div[id$=dvCard]').html());
            a.href = data_type + ', ' + table_html;
            a.download = 'ConsolidatedReport.xls';
            a.click();


        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function Print() {


            $(".IDprint").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000;font-family:Arial, Helvetica, sans-serif; font-size:8px; text-align: left; !important;'

            }

             , overrideElementCSS: [
                    '../css/layout.css',
                   { href: '../css/report-print.css', media: 'print'}]
            });

        }

    </script>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Consolidated Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <table width="100%" align="left">
                    <tr align="left">
                        <td>
                            <label>
                                Exam Name:</label>&nbsp;
                            <asp:DropDownList ID="ddlExamName" runat="server" CssClass="jsrequired" OnSelectedIndexChanged="ddlExamName_SelectedIndexChanged"
                                AutoPostBack="True">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>

                            <label>
                                Class :</label>&nbsp;
                            <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                            </asp:DropDownList>&nbsp;
                             
                             <label>
                                Section :</label>&nbsp;
                            <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                            </asp:DropDownList>
                           
                            &nbsp;


                             <label>
                                Exam Type:</label>&nbsp;
                            <asp:DropDownList ID="ddlExamType" runat="server" AutoPostBack="True">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>
                            <label>
                                Type:</label>&nbsp;
                            
                                                    <asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="True" 
                                                        CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                        <asp:ListItem Value="General">General</asp:ListItem>
                                                        <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                                        <asp:ListItem Value="Co-Curricular Activities">Co-Curricular Activities</asp:ListItem>
                                                        <asp:ListItem Value="General Activities">General Activities</asp:ListItem>
                                                        <asp:ListItem>Slip Test</asp:ListItem>
                                                    </asp:DropDownList>
                              
                            
                           
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server"
                                OnClick="btnSearch_Click" />&nbsp;
                            <asp:Button ID="btnExport" class="btn-icon button-exprots" Text="Export" runat="server"
                                OnClientClick="Export();" />
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
</asp:Content>
