<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="TCVerificationRpt.aspx.cs" Inherits="Reports_TCVerificationRpt" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
    <script type="text/JavaScript">

        $(function () {
            $("[id$=btnExport]").click(function (e) {
                window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=RptContent]').html()));
                e.preventDefault();
            });
        });

 
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/performance-print.css") + "' rel='stylesheet' type='text/css'  media='print' />"%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function print() {

            $(".Contentprint").printElement(
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
    <script type="text/javascript">
        function Cancel() {
            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            $('#aspnetForm').validate().resetForm();
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                TC Verification Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                <%--<asp:UpdatePanel ID="ups" runat="server">
                    <ContentTemplate>--%>
                        <table class="form" width="100%">
                            <tr>
                                <td style="width: 250px;">
                                    <label>
                                        Class :</label>
                                    <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                        </asp:DropDownList>
                                </td>
                                <td style="width: 250px;">
                                    <label>
                                        Section :</label>
                                    <asp:DropDownList ID="ddlSection" runat="server" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged"
                                        AutoPostBack="True">
                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Button ID="btnSearch" runat="server" class="btn-icon button-search" Text="Search"
                                        OnClick="btnSearch_Click" />
                                    <asp:Button ID="Button1" runat="server" class="btn-icon button-cancel" OnClientClick="return Cancel();"
                                        Text="Cancel" />
                                    <input type="button" id="btnExport" value="Export" class="btn-icon button-exprots" />
                                </td>
                            </tr>
                        </table>
                        <br />
                        <table width="100%">
                            <tr>
                                <td>
                                    <div class="Contentprint">
                                        <div id="RptContent" style="overflow: auto; width: 1000px;" runat="server">
                                        </div>
                                    </div>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    <%--</ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlClass" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlSection" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>--%>
            </div>
        </div>
    </div>     
</asp:Content>
