<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="VehiclesReport.aspx.cs" Inherits="Reports_VehiclesReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Vehicle Report</h2>
            <div class="clear" align="center">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                <table align="center">
                    <tr>
                        <td align="center">
                            <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                            </asp:DropDownList>
                            <asp:Button ID="btnPrint" runat="server" class="btn-icon button-print" OnClick="btnPrint_Click"
                                Text="Print" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <rsweb:ReportViewer ID="VehicleReport" runat="server" Width="1000px" Font-Names="Verdana"
                                Font-Size="8pt" InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana"
                                WaitMessageFont-Size="14pt" Height="600px">
                                <LocalReport ReportPath="Rpt\rptVehiclesReport.rdlc">
                                    <DataSources>
                                        <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                                    </DataSources>
                                </LocalReport>
                            </rsweb:ReportViewer>
                            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="GetData" TypeName="dsVehiclesTableAdapters.SP_GETVEHICLEANDSERVICEINFOTableAdapter">
                                <SelectParameters>
                                    <asp:Parameter Name="VehicleId" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
