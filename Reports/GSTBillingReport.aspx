<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="GSTBillingReport.aspx.cs" EnableViewState="true" Inherits="Reports_GSTBillingReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtStartdate]");
            setDatePicker("[id*=txtEnddate]");
        }); 
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                GST Billing Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <asp:UpdatePanel ID="ups" runat="server">
                        <ContentTemplate>
                            <table align="left">
                                <tr align="left">
                                    <td>
                                        <asp:TextBox ID="txtStartdate" runat="server" 
                                            CssClass="jsrequired dateNL date-picker" 
                                            ontextchanged="txtStartdate_TextChanged"></asp:TextBox>
                                        <asp:TextBox ID="txtEnddate" runat="server" 
                                            CssClass="jsrequired dateNL date-picker" ontextchanged="txtEnddate_TextChanged"></asp:TextBox>
&nbsp;&nbsp;<asp:DropDownList ID="ddltype" runat="server">
                                            <asp:ListItem>Select</asp:ListItem>
                                            <asp:ListItem>School</asp:ListItem>
                                            <asp:ListItem>Trader</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:DropDownList ID="ddlFeesHead" runat="server" AutoPostBack="True" 
                                            onselectedindexchanged="ddlFeesHead_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:Button ID="btnSearch" runat="server" class="btn-icon button-search" 
                                            OnClick="btnSearch_Click" Text="Search" />
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" 
                                            
                                            TypeName="dsConsolidateTableAdapters.DataTable1TableAdapter">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfSDate" Name="fromdate" 
                                                    PropertyName="Value" Type="String" />
                                                <asp:ControlParameter ControlID="hfEDate" Name="todate" 
                                                    PropertyName="Value" Type="String" />
                                                <asp:ControlParameter ControlID="ddltype" Name="type" 
                                                    PropertyName="SelectedValue" Type="String" />
                                                <asp:SessionParameter Name="FeesHeadID" SessionField="FeesHeadID" 
                                                    Type="Int32" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                        <asp:HiddenField ID="hfEDate" runat="server" />
                                        <asp:HiddenField ID="hfSDate" runat="server" />
                                        <rsweb:ReportViewer ID="GSTReport" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                            InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt"
                                            Width="1000px">
                                            <LocalReport ReportPath="Rpt\GSTBillReport.rdlc">
                                                <DataSources>
                                                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource2" Name="DataSet1" />
                                                </DataSources>
                                            </LocalReport>
                                        </rsweb:ReportViewer>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="GSTReport" />
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                             <asp:AsyncPostBackTrigger ControlID="ddlFeesHead" EventName="" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
