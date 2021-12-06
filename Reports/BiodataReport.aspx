<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true" CodeFile="BiodataReport.aspx.cs" Inherits="Reports_BiodataReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <style type="text/css">
        @font-face
        {
            font-family: 'MonotypeCorsivaRegular';
            src: url('../fonts/mtcorsva.eot');
            src: url('../fonts/mtcorsva.eot') format('embedded-opentype'), url('../mtcorsva.woff') format('woff'), url('fonts/mtcorsva.ttf') format('truetype'), url('../fonts/mtcorsva.svg#MonotypeCorsivaRegular') format('svg');
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
            .printContent
            {
                display: none;
            }
        }
        
        .style1
        {
            height: 30px;
        }
        
    </style>
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head2">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/biodata-print.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
    <script type="text/javascript">
        function Print() {

            $(".formsc").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'

            }
                            ,
                overrideElementCSS: [

                        '../css/layout.css',

                        { href: '../css/biodata-print.css', media: 'print'}]
            });
        }
    </script>
</asp:Content>
<asp:Content ID="mainContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Bio Data Report</h2>
            <div class="block john-accord content-wrapper2">
            
             <button id="btnSave" type="button" class="btn-icon btn-orange btn-saving" onclick="Print();">
                    <span></span>Save & Print</button>

                <div id="printContent" class="formsc" runat="server">               
                                        

                </div>               
            </div>
        </div>
    </div>
    <div class="clear">
    </div>
</asp:Content>
