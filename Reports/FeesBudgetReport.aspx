<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="FeesBudgetReport.aspx.cs" Inherits="Reports_FeesBudgetReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Fees Budget Report</h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2">
                <table>
                    <tr>
                        <td valign="top">
                               <label>
                                Class :</label>
                            <asp:DropDownList ID="dpClass" runat="server" AutoPostBack="True" 
                                   onselectedindexchanged="dpClass_SelectedIndexChanged">
                           
                            </asp:DropDownList>&nbsp;&nbsp;
                             <label>
                                Section :</label>
                            <asp:DropDownList ID="dpSection" runat="server" AutoPostBack="True" 
                                   onselectedindexchanged="dpSection_SelectedIndexChanged">
                            </asp:DropDownList>&nbsp;&nbsp;
                             <label>
                                Month :</label>
                            <asp:DropDownList ID="ddlMonth" runat="server" AutoPostBack="False">
                            </asp:DropDownList>&nbsp;&nbsp;
                            <label>
                                Fees Type :</label>
                            <asp:DropDownList ID="dpFeesType" runat="server" CssClass="jsrequired" AutoPostBack="False">
                                <asp:ListItem Selected="True">---Select---</asp:ListItem>
                                <asp:ListItem>School</asp:ListItem>
                                <asp:ListItem>Hostel</asp:ListItem>
                           
                                <asp:ListItem>Bus</asp:ListItem>
                           
                            </asp:DropDownList>
                            &nbsp;&nbsp;
                            <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" OnClick="btnSearch_Click" />&nbsp;<asp:DropDownList 
                                   ID="cmbPrinters" runat="server" Width="150px">
                                    </asp:DropDownList>
                                    <asp:Button
                                ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" OnClick="btnPrint_Click" />
                        </td>
                    </tr>
                    <tr>
                    <td>&nbsp;</td>
                    </tr>
                    <tr>
                      
                        <td>
                            <rsweb:ReportViewer ID="FeesBudgetReport" runat="server" Width="1000px" Font-Names="Verdana"
                                Font-Size="8pt" InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana"
                                WaitMessageFont-Size="14pt">
                                <LocalReport ReportPath="Rpt\rptFeesBudget.rdlc">
                                    <DataSources>
                                        <rsweb:ReportDataSource DataSourceId="ObjectDataSource4" Name="DataSet1" />
                                    </DataSources>
                                </LocalReport>
                            </rsweb:ReportViewer>
                            <asp:ObjectDataSource ID="ObjectDataSource4" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="GetData" TypeName="dsFeesBudgetTableAdapters.vw_FeesBudgetTableAdapter">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlMonth" Name="formonth" PropertyName="SelectedValue"
                                        Type="String" />
                                    <asp:SessionParameter Name="academicid" SessionField="AcademicID" 
                                        Type="String" />
                                    <asp:ControlParameter ControlID="dpClass" Name="_class" 
                                        PropertyName="SelectedValue" Type="String" />
                                    <asp:ControlParameter ControlID="dpSection" Name="section" 
                                        PropertyName="SelectedValue" Type="String" />
                                    <asp:ControlParameter ControlID="dpFeesType" Name="FeesType" 
                                        PropertyName="SelectedValue" Type="String" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
