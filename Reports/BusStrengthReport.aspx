<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="BusStrengthReport.aspx.cs" Inherits="Reports_BusStrengthReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Bus Strength Report</h2>
            <div class="clear">
               
            </div>
            <div class="block john-accord content-wrapper2">
                <div align="center">
                 <asp:DropDownList ID="ddlType" runat="server" Width="150px">
                 <asp:ListItem Value="Admitted">Admitted</asp:ListItem>
                 <asp:ListItem Value="Leaved">Leaved</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" 
                        OnClick="btnSearch_Click" />
                 <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                </asp:DropDownList>
                <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" OnClick="btnPrint_Click" />
                    <rsweb:ReportViewer Width="847px" ID="BusStrengthReport" runat="server" Font-Names="Verdana"
                        Font-Size="8pt" Height="600px" InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana"
                        WaitMessageFont-Size="14pt">
                        <LocalReport ReportPath="Rpt\BusStrengthReport.rdlc">
                            <DataSources>
                                <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                            </DataSources>
                        </LocalReport>
                    </rsweb:ReportViewer>
                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="GetData" 
                        TypeName="dsBusStrengthTableAdapters.Vw_GETBUSSTRENGTHTableAdapter">
                        <SelectParameters>
                            <asp:SessionParameter Name="AcademicID" SessionField="AcademicID" 
                                Type="String" />
                            <asp:ControlParameter ControlID="ddlType" Name="presentstatus" 
                                PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
