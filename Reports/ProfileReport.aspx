<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ProfileReport.aspx.cs" Inherits="Reports_ProfileReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>

   
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
         <%="<link href='" + ResolveUrl("~/css/Profileprint.css") + "' rel='stylesheet' type='text/css'  media='print' />"%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
     function Print() {


         $(".IDprint").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:30px 0px 0px 35px; margin:50px 0px 0px 0px;color:#000;font-family:Arial, Helvetica, sans-serif; font-size:9px; text-align: left; !important;'

            }

             , overrideElementCSS: [
                    '../css/Profileprint.css',
                    { href: '../css/Profileprint.css', media: 'print'}]
            });
           
     }

</script>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Profile Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div>
                    <table align="left" style="width:100%">
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
                                <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" OnClick="btnSearch_Click" />&nbsp;
                                <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server"  OnClientClick="Print(); return false;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            <div class="IDprint">
                                <div id="dvCard" runat="server" >
                                     
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
