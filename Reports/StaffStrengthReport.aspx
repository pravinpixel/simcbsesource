<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="StaffStrengthReport.aspx.cs" Inherits="Reports_StaffStrengthReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Staff Strength Report</h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2">
                <div align="center">
                   Type:<asp:DropDownList ID="ddlType" runat="server">
                   <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                   <asp:ListItem Text="Department" Value="Department"></asp:ListItem>
                   <asp:ListItem Text="Designation" Value="Designation"></asp:ListItem>
                   <asp:ListItem Text="Building" Value="Building"></asp:ListItem>
                    </asp:DropDownList>
                   <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" OnClick="btnSearch_Click" />&nbsp;
                    <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                    </asp:DropDownList><asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" OnClick="btnPrint_Click" />
                    <rsweb:ReportViewer ID="StaffStrengthReport" runat="server" Font-Names="Verdana"
                        Font-Size="8pt" InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana"
                        WaitMessageFont-Size="14pt" Width="1000px" Height="500px">
                        <LocalReport ReportPath="Rpt\rptStaffStrength.rdlc">
                            <DataSources>
                                <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                            </DataSources>
                        </LocalReport>
                    </rsweb:ReportViewer>
                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="GetData" 
                        TypeName="dsStaffStrengthTableAdapters.vw_DepartmentwisecountTableAdapter">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ddlType" Name="Type" 
                                PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
