<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="MarkCalculation.aspx.cs" Inherits="Performance_MarkCalculation" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Cancel() {
            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            $("[id*=ddlExamName]").val("");
            $("[id*=ddlSubjects]").val("");
            $("[id*=ddlType]").val("");
            $('#aspnetForm').validate().resetForm();
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
    <script type="text/JavaScript">

        function Export() {

            var a = document.createElement('a');
            var data_type = 'data:application/vnd.ms-excel';
            var table_html = encodeURIComponent($('div[id$=dvCard]').html());
            a.href = data_type + ', ' + table_html;
            a.download = 'MarkCalculation.xls';
            a.click();


        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/Barcodeprint.css") + "' rel='stylesheet' type='text/css'  media='print' />"%>
    <%="<link href='" + ResolveUrl("~/BarcodeFont/stylesheet.css") + "' rel='stylesheet' type='text/css'/>"%>
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
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Mark Calculation</h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2" id="">
                <table width="100%">
                    <tr>
                        <td>
                            <div>
                                <table class="form" width="100%">
                                    <tr>
                                        <td>
                                            <label>
                                                Class :</label>
                                            <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <label>
                                                Section :</label>
                                            <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="true" AppendDataBoundItems="True"
                                                CssClass="jsrequired" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <label>
                                                Examination :</label>
                                            <asp:DropDownList ID="ddlExamName" runat="server" AppendDataBoundItems="True" CssClass="jsrequired"
                                                OnSelectedIndexChanged="ddlExamName_SelectedIndexChanged">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <label>
                                                Type:</label>
                                            <asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                <asp:ListItem Value="General">General</asp:ListItem>
                                                <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                                <asp:ListItem>Slip Test</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <label>
                                                Subject:</label>&nbsp;
                                            <asp:DropDownList ID="ddlSubjects" runat="server" AppendDataBoundItems="True" CssClass="jsrequired"
                                                OnSelectedIndexChanged="ddlSubjects_SelectedIndexChanged" 
                                                AutoPostBack="True">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                        <tr>
                                            <td align="center" colspan="5">
                                                <asp:Button ID="btnSearch" runat="server" class="btn-icon button-search" OnClick="btnSearch_Click"
                                                    Text="Search" />
                                                <asp:Button ID="Button1" class="btn-icon button-cancel" Text="Cancel" runat="server" OnClientClick="return Cancel();" />
                                      <asp:Button ID="btnExport" class="btn-icon button-exprots" Text="Export" runat="server" 
                                        OnClientClick="Export();"/>
                                            </td>
                                        </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr>
                        <td>
                            <div class="IDprint">
                                <div id="dvCard" runat="server">
                                </div>
                            </div>
                            <br />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
