<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ContactNoReport.aspx.cs" Inherits="Reports_ContactNoReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Contact No Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <asp:UpdatePanel ID="ups" runat="server">
                        <ContentTemplate>
                            <table align="left">
                                <tr align="left">
                                    <td>
                                        <label>
                                            Type :</label>&nbsp;
                                        <asp:DropDownList ID="ddlAddressBook" runat="server" AutoPostBack="True">
                                            <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
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
                                        <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server"
                                            OnClick="btnSearch_Click" />&nbsp;
                                        <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                                        </asp:DropDownList>
                                        <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server"
                                            OnClick="btnPrint_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <rsweb:ReportViewer ID="ContactNoReport" Width="979px" Height="498px" runat="server"
                                            Font-Names="Verdana" Font-Size="8pt" InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana"
                                            WaitMessageFont-Size="14pt">
                                            <LocalReport ReportPath="Rpt\AddressReport.rdlc">
                                                <DataSources>
                                                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                                                </DataSources>
                                            </LocalReport>
                                        </rsweb:ReportViewer>
                                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" TypeName="dsAddressBookTableAdapters.a_addressbookTableAdapter">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="ddlAddressBook" Name="AddressType" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:Parameter Name="Class" Type="String" />
                                                <asp:Parameter Name="Section" Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                        <iframe id="frmPrint" name="IframeName" width="1500" height="200" runat="server"
                                            style="display: none"></iframe>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="ContactNoReport" />
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnPrint" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
