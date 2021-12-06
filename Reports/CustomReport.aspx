<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="CustomReport.aspx.cs" EnableViewState="true"
    Inherits="Reports_CustomReport" %>

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
                Custom Report Builder</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <asp:UpdatePanel ID="ups" runat="server">
                        <ContentTemplate>
                            <table width="100%" align="left">
                                <tr>
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
                                        <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <label>
                                            Status :</label>&nbsp;
                                        <asp:DropDownList ID="ddlStatus" runat="server">
                                            <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                             <asp:ListItem Value="F">Temporary</asp:ListItem>
                                            <asp:ListItem Value="N">New</asp:ListItem>
                                            <asp:ListItem Value="C">Current</asp:ListItem>
                                            <asp:ListItem Value="O">Old</asp:ListItem>
                                            <asp:ListItem Value="D">Discontinued</asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;  <label>Any Field Search :</label>
                                        <asp:TextBox ID="txtSearch" runat="server" TextMode="MultiLine" Width="244px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>Fields to display </label>
                                        <asp:CheckBox ID="chkAll" runat="server" Text="Check All" AutoPostBack="True" OnCheckedChanged="chkAll_CheckedChanged" /><asp:CheckBox
                                            ID="unchkAll" runat="server" Text="UnCheck All" AutoPostBack="True" OnCheckedChanged="unchkAll_CheckedChanged" />
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left">
                                    <td>
                                        <asp:CheckBoxList ID="chkids" CssClass="checkboxlist" runat="server" RepeatColumns="7"
                                            RepeatDirection="Horizontal">
                                        </asp:CheckBoxList>
                                        <%-- <%=BindFields() %>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server"
                                            OnClick="btnSearch_Click" />&nbsp;
                                        <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px" Visible="False">
                                        </asp:DropDownList>
                                        <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" 
                                            runat="server" Visible="False" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <rsweb:ReportViewer ID="CustomReport" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                            InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt"
                                            Width="1000px" Height="600px">
                                            <LocalReport ReportPath="Rpt\CustomReport.rdlc">
                                                <DataSources>
                                                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                                                </DataSources>
                                            </LocalReport>
                                        </rsweb:ReportViewer>
                                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" 
                                            TypeName="dsCustomTableAdapters.sp_GetCustomReportTableAdapter">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="ddlClass" Name="_class" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="ddlSection" Name="section" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="ddlStatus" Name="Status" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="txtSearch" Name="Search" PropertyName="Text" Type="String" />
                                                <asp:SessionParameter Name="AcademicID" SessionField="AcademicID" Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="CustomReport" />
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnPrint" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="chkAll" EventName="CheckedChanged" />
                            <asp:AsyncPostBackTrigger ControlID="unchkAll" EventName="CheckedChanged" />
                            <asp:AsyncPostBackTrigger ControlID="ddlClass" EventName="SelectedIndexChanged" />
                            <asp:AsyncPostBackTrigger ControlID="ddlSection" EventName="SelectedIndexChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
