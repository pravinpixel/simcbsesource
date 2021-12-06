<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="BarcodeReport.aspx.cs" Inherits="Reports_BarcodeReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link type="text/css" href="../css/Barcodeprint.css" />
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
   <script type="text/JavaScript">
//       $(function () {
//           $("[id$=btnExport]").click(function (e) {
//               window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=dvCard]').html()));
//               e.preventDefault();
//           });
//       });       

   </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <style type="text/css">
      /*  img.barcode
        {
            width: 201px !important;
            height: 75px !important;
            max-width: none;
            max-height: none;
        }*/
        
        .barcodeimage img
        {
             max-width: inherit;
        }
    </style>
    <script type="text/javascript">
        function Print() {

            $(".IDprint").printElement(
            {
                leaveOpen: true,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000;font-family:Arial, Helvetica, sans-serif; font-size:9px; text-align: left; !important;'

            }
              , overrideElementCSS: [
                    '../css/Barcodeprint.css',
                    { href: '../css/Barcodeprint.css', media: 'print'}]
            });           

        }

    </script>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Barcode Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <table align="left">
                        <tr align="left">
                            <td>
                                <label>
                                    <br />
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
                                <label>
                                    Option :</label>&nbsp;<asp:DropDownList ID="ddlOption" runat="server">
                                        <asp:ListItem Selected="True">-----Select----</asp:ListItem>
                                        <asp:ListItem>With Photo</asp:ListItem>
                                        <asp:ListItem>Without Photo</asp:ListItem>
                                    </asp:DropDownList>
                                 &nbsp;
                                       <label> Regno(enter with comma separated):</label> <asp:TextBox ID="txtSearch" runat="server" TextMode="MultiLine" 
                                    Width="244px"></asp:TextBox>
                                <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server"
                                    OnClick="btnSearch_Click" />
                                <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server"
                                    OnClientClick="Print();" />
                                <asp:Button ID="btnPrintExport" class="btn-icon button-exprots" Text="Export" runat="server"
                                    OnClick="btnPrintExport_Click" Visible="False" />

                                    <%--<input type="button" id="btnExport" style="display:none;" value="Export" class="btn-icon button-exprots"  />--%>
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
