<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StaffCustomReport.aspx.cs" EnableViewState="true"
    Inherits="Reports_StaffCustomReport" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%--
--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                StaffCustom Report Builder</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <asp:UpdatePanel ID="ups" runat="server">
                        <ContentTemplate>
                            <table align="left">
                                <tr>
                                    <td>
                                        &nbsp;Any Field Search :
                                        <asp:TextBox ID="txtSearch" runat="server" TextMode="MultiLine" Width="344px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight: bold">Fields to display </span>
                                        <asp:CheckBox ID="chkAll" runat="server" Text="Check All" AutoPostBack="True" OnCheckedChanged="chkAll_CheckedChanged" /><asp:CheckBox
                                            ID="unchkAll" runat="server" Text="UnCheck All" AutoPostBack="True" OnCheckedChanged="unchkAll_CheckedChanged" />
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left">
                                    <td>
                                        <asp:CheckBoxList ID="chkids" CssClass="checkboxlist" runat="server" RepeatColumns="10"
                                            RepeatDirection="Horizontal">
                                        </asp:CheckBoxList>
                                        <%-- <%=BindFields() %>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server"
                                            OnClick="btnSearch_Click" />&nbsp;
                                        <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                                        </asp:DropDownList>
                                        <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <rsweb:ReportViewer ID="StaffCustomReport" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                            InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt"
                                            Width="1000px" Height="600px">
                                            <LocalReport ReportPath="Rpt\StaffCustomReport.rdlc">
                                                <DataSources>
                                                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                                                </DataSources>
                                            </LocalReport>
                                        </rsweb:ReportViewer>
                                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" 
                                            TypeName="dsStaffCustomTableAdapters.sp_getStaffReportTableAdapter">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="txtSearch" Name="Search" PropertyName="Text" 
                                                    Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="StaffCustomReport" />
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnPrint" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="chkAll" EventName="CheckedChanged" />
                            <asp:AsyncPostBackTrigger ControlID="unchkAll" EventName="CheckedChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
