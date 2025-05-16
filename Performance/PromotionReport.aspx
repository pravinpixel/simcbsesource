<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="PromotionReport.aspx.cs" Inherits="Performance_PromotionReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/JavaScript">

        function Export() {
            var a = document.createElement('a');
            var data_type = 'data:application/vnd.ms-excel';
            var table_html = encodeURIComponent($('div[id$=dvCard]').html());
            a.href = data_type + ', ' + table_html;
            a.download = 'PromotionReport.xls';
            a.click();
        }
        function PromotionList() {

            if ($('#aspnetForm').valid()) {

            }
            else {
                return false;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/performance-print.css") + "' rel='stylesheet' type='text/css'  media='print' />"%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Promotion List</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                <table width="100%" class="form">
                    <tr>
                        <td align="left">
                            <label>
                                Class :</label>
                            <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                AutoPostBack="true" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td align="left">
                            <label>
                                Section :</label>
                            <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="true" AppendDataBoundItems="True"
                                CssClass="jsrequired" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td align="justify" width="60%">
                            <asp:Button ID="btnShow" runat="server" class="btn-icon button-search" Text="Submit"
                                OnClick="btnShow_Click" />
                            &nbsp;
                            <asp:Button ID="btnPromotionCancel" runat="server" class="btn-icon button-search"
                                Text="Cancel" />
                            &nbsp;
                            <asp:Button ID="btnExport" class="btn-icon button-exprots" Text="Export" OnClientClick="Export();" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <div class="IDprint">
                                <div id="dvCard" style="overflow: auto; width: 1000px;" runat="server">
                                </div>
                                <asp:PlaceHolder ID="promocontent" runat="server"></asp:PlaceHolder>
                            </div>
                            <br />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
