<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true" CodeFile="FeesCollectionReport.aspx.cs" Inherits="Reports_FeesCollectionReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
              Fees Collection Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                <table align="center">
                    <tr align="center">
                        <td> <label>
                                            Class :</label>&nbsp;
                                        <asp:DropDownList ID="ddlClass" runat="server"
                                            AppendDataBoundItems="True" AutoPostBack="True" 
                                             onselectedindexchanged="ddlClass_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        &nbsp;
                                        <label>
                                            Section :</label>&nbsp;
                                        <asp:DropDownList ID="ddlSection" runat="server"
                                            AutoPostBack="True" 
                                             onselectedindexchanged="ddlSection_SelectedIndexChanged" >
                                            <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;
                            <label>
                                Month :</label>
                            <asp:DropDownList ID="ddlMonth" runat="server" 
                                onselectedindexchanged="ddlMonth_SelectedIndexChanged">
                            </asp:DropDownList>
                         

                            <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" OnClick="btnSearch_Click" />&nbsp;<asp:DropDownList 
                                ID="cmbPrinters" runat="server" Width="150px">
                                    </asp:DropDownList>
                                    <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server"  OnClick="btnPrint_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                           
                            <rsweb:ReportViewer ID="ReportFeesCollection" runat="server" 
                                Font-Names="Verdana" Width="1000px" 
                                Font-Size="8pt" InteractiveDeviceInfos="(Collection)" 
                                WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt">
                                <LocalReport ReportPath="Rpt\rptFeesCollection.rdlc">
                                    <DataSources>
                                        <rsweb:ReportDataSource DataSourceId="ObjectDataSource2" Name="DataSet1" />
                                    </DataSources>
                                </LocalReport>
                            </rsweb:ReportViewer>
                            <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" 
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
                                TypeName="dsFeesCollectionTableAdapters.SP_GETFEESCOLLECTIONTableAdapter">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlMonth" Name="month" 
                                        PropertyName="SelectedValue" Type="String" />
                                    <asp:SessionParameter DefaultValue="AcademicID" Name="academicid" 
                                        SessionField="AcademicID" Type="String" />
                                    <asp:ControlParameter ControlID="ddlClass" DefaultValue="" Name="_class" 
                                        PropertyName="SelectedValue" Type="String" />
                                    <asp:ControlParameter ControlID="ddlSection" Name="section" 
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

