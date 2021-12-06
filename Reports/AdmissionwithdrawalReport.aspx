<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="AdmissionwithdrawalReport.aspx.cs" EnableViewState="true"
    Inherits="Reports_AdmissionwithdrawalReport" %>

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
                Admission Withdrawal Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <asp:UpdatePanel ID="ups" runat="server">
                        <ContentTemplate>
                            <table align="left" style="width: 100%">
                                 
                                <tr>
                                    <td> 
                                        <rsweb:ReportViewer ID="rptAdmissionWithdraw" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                            InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt"
                                            Width="929px" Height="600px">
                                            <LocalReport ReportPath="Rpt\rptwithdrawal.rdlc">
                                                <DataSources>
                                                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                                                </DataSources>
                                            </LocalReport>
                                        </rsweb:ReportViewer>
                                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" 
                                            TypeName="dswithdrawalTableAdapters.DataTable1TableAdapter">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="AcademicID" SessionField="AcademicID" 
                                                    Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                        
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
