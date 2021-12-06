<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="BusRouteReport.aspx.cs" EnableViewState="true"
    Inherits="Reports_BusRouteReport" %>

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
                Bus Route Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <asp:UpdatePanel ID="ups" runat="server">
                        <ContentTemplate>
                            <table align="left" style="width: 100%">
                                <tr align="left">
                                    <td>
                                        <label>
                                            Class :</label>&nbsp;
                                        <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;
                                        <label>
                                            Section :</label>&nbsp;
                                        <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="True" 
                                            onselectedindexchanged="ddlSection_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        &nbsp;
                                        <label>
                                            Route Code :</label>&nbsp;
                                        <asp:DropDownList ID="ddlBusRoute" runat="server" AutoPostBack="True">
                                            <asp:ListItem Selected="True" Value="0">-----Select----</asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;
                                           <label>
                                            Bus :</label>&nbsp;
                                        <asp:DropDownList ID="ddlBus" runat="server" AutoPostBack="True">
                                            <asp:ListItem Selected="True" Value="0">-----Select----</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" OnClick="btnSearch_Click" />&nbsp;
                                        <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                                        </asp:DropDownList>
                                        <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" OnClick="btnPrint_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%--<CR:CrystalReportViewer ID="BusRoute" runat="server" AutoDataBind="True"
                                            GroupTreeImagesFolderUrl="" Height="1174px" ToolbarImagesFolderUrl=""
                                            ReportSourceID="CrystalReportSource1" EnableDatabaseLogonPrompt="False" EnableDrillDown="False"
                                            EnableParameterPrompt="False" HasCrystalLogo="False"  OnInit="BusRoute_Init" 
                                            HasSearchButton="False" HasDrilldownTabs="False"
                                            HasDrillUpButton="False" HasToggleGroupTreeButton="False" HasToggleParameterPanelButton="False"
                                            ToolPanelView="None" HasPrintButton="True" HasGotoPageButton="False" 
                                            onunload="BusRoute_Unload" PrintMode="Pdf" />
                                        <CR:CrystalReportSource ID="CrystalReportSource1" runat="server">
                                            <Report FileName="../Rpt/cryBusRouteReport.rpt">
                                            </Report>
                                        </CR:CrystalReportSource>--%>
                                        <rsweb:ReportViewer ID="BusRoute" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                            InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt"
                                            Width="929px" Height="600px">
                                            <LocalReport ReportPath="Rpt\BusRouteReport.rdlc">
                                                <DataSources>
                                                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                                                </DataSources>
                                            </LocalReport>
                                        </rsweb:ReportViewer>
                                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" TypeName="dsBusRouteTableAdapters.DataTable2TableAdapter">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="ddlBus" Name="BusCode" 
                                                    PropertyName="SelectedValue" Type="String" />
                                                <asp:ControlParameter ControlID="ddlBusRoute" Name="RouteCode" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:SessionParameter Name="academicid" SessionField="AcademicID" 
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="ddlClass" Name="_class" 
                                                    PropertyName="SelectedValue" Type="String" />
                                                <asp:ControlParameter ControlID="ddlSection" Name="section" 
                                                    PropertyName="SelectedValue" Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="BusRoute" />
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnPrint" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="ddlClass" EventName="SelectedIndexChanged" />
                            <asp:AsyncPostBackTrigger ControlID="ddlSection" EventName="SelectedIndexChanged" />
                            <asp:AsyncPostBackTrigger ControlID="ddlBusRoute" EventName="SelectedIndexChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
