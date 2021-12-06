<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="StudentStrengthReport.aspx.cs" Inherits="Reports_StudentStrengthReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Student Strength Report</h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2">
                <div align="center">
                    <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                    </asp:DropDownList><asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" OnClick="btnPrint_Click" />
                    <rsweb:ReportViewer ID="StudentStrengthReport" runat="server" Font-Names="Verdana"
                        Font-Size="8pt" InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana"
                        WaitMessageFont-Size="14pt" Width="1000px" Height="500px">
                        <LocalReport ReportPath="Rpt\rptStudentStrength.rdlc">
                            <DataSources>
                                <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                            </DataSources>
                        </LocalReport>
                    </rsweb:ReportViewer>
                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="GetData" TypeName="dsStudentStrengthTableAdapters.vw_ClasswisecountTableAdapter">
                        <SelectParameters>
                            <asp:SessionParameter Name="AcademicID" SessionField="AcademicID" 
                                Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
