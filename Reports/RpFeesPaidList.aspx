<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="RpFeesPaidList.aspx.cs" Inherits="Reports_RpFeesPaidList" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtStartdate]");
            setDatePicker("[id*=txtenddate]");
        }); 
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Fees Paid Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                    <table align="left" width="100%">
                        <tr align="left">
                            <td>
                                <label>
                                    Start Date :</label>
                                <asp:TextBox ID="txtStartdate" CssClass="dateNL date-picker" runat="server"></asp:TextBox>
                                    <label>
                                        End Date :</label>
                                    <asp:TextBox ID="txtenddate" CssClass="dateNL date-picker" runat="server"></asp:TextBox>
                                    <label>
                                        Class :</label>&nbsp;
                                    <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                        <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;
                                    <label>
                                        Section :</label>&nbsp;
                                    <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    &nbsp;
                                    <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" OnClick="btnSearch_Click" />
                                    <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                                    </asp:DropDownList>
                                    <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" OnClick="btnPrint_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <rsweb:ReportViewer ID="FeesPaidReport" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                    InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt"
                                    Width="1000px">
                                    <LocalReport ReportPath="Rpt\rpFeesPaidListReport.rdlc">
                                        <DataSources>
                                            <rsweb:ReportDataSource DataSourceId="ObjectDataSource2" Name="DataSet1" />
                                        </DataSources>
                                    </LocalReport>
                                </rsweb:ReportViewer>
                                <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" OldValuesParameterFormatString="original_{0}"
                                    SelectMethod="GetData" TypeName="dsPaidListTableAdapters.Vw_GetSchoolFeesTableAdapter">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfSDate" Name="startdate" PropertyName="Value" Type="String" />
                                        <asp:ControlParameter ControlID="hfEDate" Name="enddate" PropertyName="Value" Type="String" />
                                        <asp:ControlParameter ControlID="ddlClass" Name="_class" PropertyName="SelectedValue"
                                            Type="String" />
                                        <asp:ControlParameter ControlID="ddlSection" Name="section" PropertyName="SelectedValue"
                                            Type="String" />
                                        <asp:SessionParameter Name="academicid" SessionField="AcademicID" 
                                            Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <asp:HiddenField ID="hfSDate" runat="server" />
                                <asp:HiddenField ID="hfEDate" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
