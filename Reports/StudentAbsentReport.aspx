<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StudentAbsentReport.aspx.cs" Inherits="Reports_StudentAbsentReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
    <style type="text/css">
        @font-face
        {
            font-family: 'MonotypeCorsivaRegular';
            src: url('../fonts/mtcorsva.eot');
            src: url('../fonts/mtcorsva.eot') format('embedded-opentype'), url('../mtcorsva.woff') format('woff'), url('fonts/mtcorsva.ttf') format('truetype'), url('../fonts/mtcorsva.svg#MonotypeCorsivaRegular') format('svg');
        }
    </style>
    <script type="text/javascript">

        $(function () {
            setDatePicker("[id*=txtFromDate]");
            setDatePicker("[id*=txtTodate]");
        });

    </script>
    <script type="text/JavaScript">
        $(function () {
            $("[id$=btnExport]").click(function (e) {
                window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=dvAbsentReport]').html()));
                e.preventDefault();
            });
        });
         
    </script>
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head2">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/leaveprint.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
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

                        { href: '../css/leaveprint.css', media: 'print'}]
            });
        }


        function CheckDate() {

            var date1 = $("[id*=txtFromDate]").val();
            var date2 = $("[id*=txtTodate]").val();
            if (date1 != "" && date2 != "") {
                if ($.datepicker.parseDate('dd/mm/yy', date2) < $.datepicker.parseDate('dd/mm/yy', date1)) {
                    AlertMessage('info', 'StartDate should be lesser than EndDate !!!');
                    $("[id*=txtFromdate]").val("");
                    $("[id*=txtTodate]").val("");
                }
            }

        };

    </script>
</asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Student Absent Report
            </h2>
            <div class="clear">
            </div>
            <%--<asp:UpdatePanel ID="ups" runat="server">
                    <ContentTemplate>--%>
            <div class="block john-accord content-wrapper2">
                <table class="form" width="100%">
                    <tr>
                        <td>
                            <label>
                                From Date :</label>
                            <asp:TextBox ID="txtFromDate" CssClass="DateNL date-picker" runat="server"></asp:TextBox>
                            &nbsp;
                            <label>
                                To Date :</label>
                            <asp:TextBox ID="txtTodate" CssClass="DateNL date-picker" runat="server" onchange="CheckDate();"></asp:TextBox>
                            &nbsp;
                            <label>
                                Class :</label>
                            <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;
                            <label>
                                Section :</label>
                            <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <table class="form" width="100%">
                    <tr>
                        <td width="300px">
                        </td>
                        <td>
                            <asp:Button ID="btnSearch" runat="server" class="btn-icon button-search" Text="Search"
                                OnClick="btnSearch_Click" />
                            <asp:Button ID="Button2" runat="server" class="btn-icon button-cancel" OnClientClick="return Cancel();"
                                Text="Cancel" />
                            <input type="button" id="btnExport" value="Export" class="btn-icon button-exprots" />
                        </td>
                    </tr>
                </table>
                <div class="clear">
                </div>
                <div id="printContent" class="formsc">
                    <br />
                    <div id="dvAbsentReport" style="overflow: auto; width: 1000px;" runat="server">
                    </div>
                </div>
                <div class="clear">
                </div>
                <div class="clear">
                </div>
                <div class="clear">
                </div>
            </div>
            <%--  </ContentTemplate>

             <Triggers>                      
                        <asp:AsyncPostBackTrigger ControlID="ddlClass" EventName="SelectedIndexChanged" />
                       
                    </Triggers>

            </asp:UpdatePanel>--%>
        </div>
    </div>
    <div class="clear">
    </div>
</asp:Content>
