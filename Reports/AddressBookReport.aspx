<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="AddressBookReport.aspx.cs" EnableViewState="true"
    Inherits="Reports_AddressBookReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
        function Print() {

            $(".IDprint").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000;font-family:Times New Roman, Helvetica, sans-serif; font-size:12px; text-align: left; !important;'

            }
            });

        }

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Address List Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <table align="left" style="width: 931px">
                        <tr align="left">
                            <td>
                                <label>
                                    Address Name :</label>&nbsp;
                                <asp:DropDownList ID="ddlAddressBook" CssClass="jsrequired" runat="server"  
                                    AutoPostBack="True" 
                                    onselectedindexchanged="ddlAddressBook_SelectedIndexChanged">
                                     <asp:ListItem Selected="True">---Select---</asp:ListItem>
                                            <asp:ListItem Value="Alumni">Alumni</asp:ListItem>
                                            <asp:ListItem  Value="Banks">Banks</asp:ListItem>
                                            <asp:ListItem Value="Chief Guest">Chief Guest</asp:ListItem>
                                            <asp:ListItem Value="Colleges">Colleges</asp:ListItem>
                                            <asp:ListItem Value="Companies">Companies</asp:ListItem>
                                            <asp:ListItem Value="Doctors">Doctors</asp:ListItem>
                                            <asp:ListItem Value="Engineers">Engineers</asp:ListItem>
                                            <asp:ListItem Value="High School">High School</asp:ListItem>
                                            <asp:ListItem Value="Hr.Sec. School">Hr.Sec. School</asp:ListItem>
                                            <asp:ListItem Value="Govt Officials">Govt Officials</asp:ListItem>
                                            <asp:ListItem Value="Political Parties">Political Parties</asp:ListItem>
                                            <asp:ListItem Value="Press">Press</asp:ListItem>
                                            <asp:ListItem Value="Sports">Sports</asp:ListItem>
                                            <asp:ListItem Value="Student">Student</asp:ListItem>
                                            <asp:ListItem Value="Staff">Staff</asp:ListItem>
                                            <asp:ListItem Value="Relations">Relations</asp:ListItem>
                                            <asp:ListItem Value="Religious"></asp:ListItem>
                                            <asp:ListItem Value="Well-wisher">Well-wisher</asp:ListItem>
                                            <asp:ListItem Value="Others">Others</asp:ListItem>
                            </asp:DropDownList>
                                &nbsp;
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
                                </asp:DropDownList>
                                &nbsp;
                                <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server"
                                    OnClick="btnSearch_Click" />&nbsp;
                                <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server"
                                    OnClientClick="Print(); return false;" />                                
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
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
