<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="CertificateReport.aspx.cs" Inherits="Performance_CertificateReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/certificate.css" />
    <style type="text/css">
        body
        {
            margin: 0;
        }
        .merit-table
        {
            margin-top: 34%;
        }
        .label
        {
            font-size: 22px;
            color: #23408f;
            text-align: right;
            font-style: italic;
        }
        .merit-table td
        {
            padding: 8px 10px;
            vertical-align: baseline;
            font-family: auto;
        }
        .value
        {
            border-bottom: 1px dashed #d1d2d4;
            width: 100%;
            font-size: 18px;
        }
    </style>
    <style type="text/css">
        @media print
        {
		
		 
            .printContent
        
            {
                display: block;                
            }  
        }
        @media screen
        {
            {
                display: none;
            }
        }
    </style>
    <script type="text/javascript">

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/certificatePrint.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function Print() {

            $(".formsc").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:0px 0px 0px 0px;margin:0px 0px 0px 0px;color:#000 !important;'

            }
                            ,
                overrideElementCSS: [

                        '../css/certificate.css',

                        { href: '../css/certificatePrint.css', media: 'print'}]
            });
        }
    </script>
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Certificate Chart</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                <table class="form" width="100%">
                    <tr>
                        <td align="left">
                            <label>
                                Class :</label>
                            <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td align="left">
                            <label>
                                Section :</label>
                            &nbsp;
                            <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td align="left">
                            <label>
                                Template :</label>
                            <asp:DropDownList ID="ddlTmp" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                OnSelectedIndexChanged="ddlTmp_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td align="left">
                         <label>
                                Name : &nbsp;</label>
                            <asp:DropDownList ID="ddlType" runat="server">
                            </asp:DropDownList>
                           </td>
                        <td align="left">
                        <label>
                                Print : &nbsp;</label>
                            <asp:DropDownList ID="ddlPrint" runat="server">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                       
                        <td align="left">
                            &nbsp;
                            <label>
                                Search by Regno(enter with comma separated):</label>
                            <asp:TextBox ID="txtSearch" runat="server" TextMode="MultiLine" Width="244px"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <table class="form">
                    <tr>
                        <td align="center" class="col1">
                            <asp:Button ID="btnSearch" runat="server" class="btn-icon button-search" OnClick="btnSearch_Click"
                                Text="Search" />
                            <asp:Button ID="Button2" runat="server" class="btn-icon button-cancel" OnClientClick="return Cancel();"
                                Text="Cancel" />
                            <asp:Button ID="btnPrint" runat="server" class="btn-icon button-print" OnClientClick="Print();"
                                Text="Print" />
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr>
                        <td>
                            <div id="printContent" class="formsc">
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
