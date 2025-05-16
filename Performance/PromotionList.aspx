    <%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
        AutoEventWireup="true" CodeFile="PromotionList.aspx.cs" Inherits="Performance_PromotionList" %>

    <%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
        <script type="text/javascript" src="../js/jquery.min.js"></script>
        <script type="text/JavaScript">

            function Export() {
                var a = document.createElement('a');
                var data_type = 'data:application/vnd.ms-excel';
                var table_html = encodeURIComponent($('div[id$=dvC1_Content]').html());
                a.href = data_type + ', ' + table_html;
                a.download = 'PromotionList.xls';
                a.click();
            }
            function PromotionList() {

                if ($('#aspnetForm').valid()) {

                }
                else {
                    return false;
                }
            }


            function DisplayProgress() {
                document.getElementById('pnlProgress').style.visibility = 'visible';
                window.setTimeout(HideProgressPanel, 600000);  //handles hiding the progress panel should the operation time out
            }

            function HideProgressPanel() {
                document.getElementById('pnlProgress').style.visibility = "hidden", 600000
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
                    Promotion Manager</h2>
                <div class="clear">
                </div>
                <div align="center" class="block john-accord content-wrapper2">
                    <%--  <asp:UpdatePanel ID="ups" runat="server">
                        <ContentTemplate>--%>
                    <table class="form" width="100%">
                        <tr>
                            <td width="1%" style="display: none" align="left">
                                <label>
                                    Type:</label>
                                <asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                    <asp:ListItem Value="General">General</asp:ListItem>
                                    <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                    <asp:ListItem>Slip Test</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td width="100%" style="display: none;" align="left">
                                <label>
                                    Exam Name:</label>
                                <asp:CheckBoxList ID="chkExamName" runat="server" CssClass="checkboxlist" RepeatColumns="4"
                                    RepeatDirection="Horizontal">
                                </asp:CheckBoxList>
                            </td>
                        </tr>
                    </table>
                    <table width="100%" class="form">
                        <tr>
                            <td align="left" width="20%">
                                <label>
                                    Class :</label>
                                <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td width="22%" align="left">
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
                                <asp:Button ID="btnExport0" class="btn-icon button-exprots" Text="Export" runat="server"
                                    OnClick="btnExport0_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left" colspan="3" style="width: 102%" width="22%">
                                <div id="dvNotify" visible="false" runat="server">
                                    <table class="form">
                                        <tr>
                                            <td align="left">
                                                <pre style="border: thin solid #FF0000; background-color: #FFFFCC; font-family: Verdana;
                                                    font-weight: bold; font-size: 12px;"> For your Verification &amp; Confirmation before proceeding Promotion...
     1. Please verify the marks entered for all exams selected under Promotion setup criteria under CASE I, CASE II, CASE III. 
     2. Please confirm the pomortion set up marks percentage before proceeding.
     3. Any mark update in student mark entry after promotion will not reflect.
     4. Any changes in the promotion set up section will not reflect after Promotion confirmed.</pre>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="chkAgree" runat="server" CausesValidation="True" />
                                                <label>
                                                    I Agree the above terms and conditions and Points from 1 to 4.
                                                </label>
                                                <br />
                                                <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="Please accept the terms and conditions"
                                                    OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                                                <br />
                                                <asp:Button ID="btnP1Search" runat="server" class="btn-generate-list button-generatelist"
                                                    Text="Generate Promotion List" OnClick="btnP1Search_Click" OnClientClick="javascript:DisplayProgress()" />
                                                &nbsp;
                                                <asp:Button ID="btnExport" class="btn-icon button-exprots" Text="Export" runat="server"
                                                    OnClientClick="Export();" Visible="False" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                    <table width="100%">
                        <tr>
                            <td>
                                <div class="IDprint">
                                    <div id="dvC1_Content" style="overflow: auto; width: 1000px;" runat="server">
                                    </div>
                                    <div id="dvC2_Content" style="overflow: auto; width: 1000px;" runat="server">
                                    </div>
                                    <asp:PlaceHolder ID="promocontent" runat="server"></asp:PlaceHolder>
                                </div>
                                <br />
                            </td>
                        </tr>
                    </table>
                    <div id="pnlProgress" class="modalBackground" style="visibility: hidden;">
                        <div id="content" class="modalDialogClear" style="text-align: center;">
                            <br />
                            <br />
                            looking up promotion list, please wait...<br />
                            <img src="../images/loading.gif" alt="" />
                        </div>
                    </div>
                    <%--  </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnShow" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnExport" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="ddlClass" EventName="SelectedIndexChanged" />
                            <asp:AsyncPostBackTrigger ControlID="ddlSection" EventName="SelectedIndexChanged" />
                        </Triggers>
                    </asp:UpdatePanel>--%>
                </div>
            </div>
        </div>
    </asp:Content>
