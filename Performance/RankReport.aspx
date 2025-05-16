<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true" CodeFile="RankReport.aspx.cs" Inherits="Performance_RankReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/JavaScript">

        function Export() {
            var a = document.createElement('a');
            var data_type = 'data:application/vnd.ms-excel';
            var table_html = encodeURIComponent($('div[id$=dvCard]').html());
            a.href = data_type + ', ' + table_html;
            a.download = 'CumulativeMarkList.xls';
            a.click();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/performance-print.css") + "' rel='stylesheet' type='text/css'  media='print' />"%>
    <style type="text/css">
        #spClassSearch
        {
            height: 16px;
        }
    </style>
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
    <script type="text/javascript">
        function Cancel() {
            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            $("[id*=ddlType]").val("");
            $("[id*=ddlExamName]").val("");
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
                Rank Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                      <table class="form" width="100%">
                            <tr>
                                <td width="1%" align="left">
                                    <label>
                                        Exam Name:</label>
                                            &nbsp;<asp:DropDownList ID="ddlExamName" runat="server" 
                                        AppendDataBoundItems="True" CssClass="jsrequired" 
                                        onselectedindexchanged="ddlExamName_SelectedIndexChanged" 
                                        AutoPostBack="True">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                    
                                    </div>
                                </td>

                                 <td width="1%" align="left">
                                    <label>
                                        Type:</label>
                                    <asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                        <asp:ListItem Value="General">General</asp:ListItem>
                                        <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                        <asp:ListItem>Slip Test</asp:ListItem>
                                    </asp:DropDownList>
                                </td>

                                <td width="1%" align="left">
                                    <label>
                                        Class :</label>
                                    <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td width="1%" align="left">
                                    <label>
                                        Section :</label>
                                    <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="true" AppendDataBoundItems="True"
                                        CssClass="jsrequired" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                    </asp:DropDownList>
                                </td>                               
                               
                            </tr>
                        </table>
                        <br />
                        <table width="100%" class="form">
                            <tr>
                                <td align="center">
                                    <asp:Button ID="btnSearch" runat="server" class="btn-icon button-search" Text="Search" OnClick="btnSearch_Click" />
                                    <asp:Button ID="Button1" runat="server" class="btn-icon button-cancel" OnClientClick="return Cancel();"
                                        Text="Cancel" />
                                    <asp:Button ID="btnExport" class="btn-icon button-exprots" Text="Export" runat="server" OnClientClick="Export();" />
                                </td>
                            </tr>
                        </table>
                        <table class="form">
                            <tr>
                                <td class="col1">
                                    <%--<asp:HiddenField ID="hfExamNameID" runat="server" />--%>
                                </td>
                            </tr>
                        </table>
                        <table width="100%">
                            <tr>
                                <td>
                                    <div class="IDprint">
                                        <div id="dvCard" style="overflow: auto; width: 1000px;" runat="server">
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