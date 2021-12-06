<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="FuelVoucherReport.aspx.cs" Inherits="Reports_FuelVoucherReport" %>

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
                Fuel Voucher Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                <asp:UpdatePanel ID="ups" runat="server">
                    <ContentTemplate>
                        <table align="center">
                            <tr align="center">
                                <td>
                                    <asp:TextBox ID="txtStartdate" CssClass="jsrequired dateNL date-picker" runat="server"                                       ></asp:TextBox>
                                    &nbsp;&nbsp;
                                    <asp:TextBox ID="txtEnddate" CssClass="jsrequired dateNL date-picker" runat="server"
                                        ></asp:TextBox>
                                    &nbsp;&nbsp;
                                    <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" 
                                        onclick="btnSearch_Click" />
                                    <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                                    </asp:DropDownList>
                                    <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" 
                                        onclick="btnPrint_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <div class="printable">
                                    <rsweb:ReportViewer ID="FuelVoucherReport" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                        InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" 
                                        WaitMessageFont-Size="14pt" Width="1000px">
                                        <LocalReport ReportPath="Rpt\rpFuelVoucher.rdlc">
                                            <DataSources>
                                                <rsweb:ReportDataSource DataSourceId="ObjectDataSource2" Name="DataSet1" />
                                            </DataSources>
                                        </LocalReport>
                                    </rsweb:ReportViewer>
                                    
                                    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" 
                                        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
                                        TypeName="dsFuelVoucherReportTableAdapters.Vw_GetFuelVoucherDetailsTableAdapter">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfSDate" Name="startdate" 
                                                PropertyName="Value" Type="String" />
                                            <asp:ControlParameter ControlID="hfEDate" Name="enddate" PropertyName="Value" 
                                                Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                  
                                    
                                    <asp:HiddenField ID="hfSDate" runat="server" />
                                    <asp:HiddenField ID="hfEDate" runat="server" />
                                  
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <Triggers>
                        <%--<asp:PostBackTrigger ControlID="FuelReport" />
                        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnPrint" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="txtStartDate" EventName="TextChanged" />
                        <asp:AsyncPostBackTrigger ControlID="txtEndDate" EventName="TextChanged" />--%>
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>
