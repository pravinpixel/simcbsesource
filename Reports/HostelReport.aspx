<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="HostelReport.aspx.cs" EnableViewState="true"
    Inherits="Reports_HostelReport" %>

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
                Hostel Information Register</h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <div style="overflow: auto">
                   <%-- <asp:UpdatePanel ID="ups" runat="server">
                        <ContentTemplate>--%>
                            <table align="left" style="width: 931px">
                                <tr align="left">
                                    <td>                                      
                                        <label>
                                            Hostel Name :</label>&nbsp;
                                        <asp:DropDownList ID="ddlHostel" runat="server" AutoPostBack="True">
                                            <asp:ListItem Selected="True" Value="0">-----Select----</asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;
                                         <label>
                                            Gender :</label>&nbsp;
                                        <asp:DropDownList ID="ddlGender" runat="server" AutoPostBack="True">
                                            <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            <asp:ListItem Value="M">Male</asp:ListItem>
                                            <asp:ListItem Value="F">Female</asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;
                                        <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Search" runat="server" OnClick="btnSearch_Click" />&nbsp;
                                        <asp:DropDownList ID="cmbPrinters" runat="server" Width="150px">
                                    </asp:DropDownList>
                                        <asp:Button ID="btnPrint" class="btn-icon button-print" Text="Print" runat="server" OnClick="btnPrint_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>                                        
                                        <rsweb:ReportViewer ID="Hostel" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                            InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt"
                                            Width="1000px" Height="600px">
                                            <LocalReport ReportPath="Rpt\HostelReport.rdlc">
                                                <DataSources>
                                                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                                                </DataSources>
                                            </LocalReport>
                                        </rsweb:ReportViewer>
                                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" 
                                            TypeName="dsHostelTableAdapters.DataTable1TableAdapter">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="ddlHostel" Name="HostelId" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="ddlGender" Name="Gender" 
                                                    PropertyName="SelectedValue" Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                    </td>
                                </tr>
                            </table>
                     <%--   </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="Hostel" />
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnPrint" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="ddlHostel" EventName="SelectedIndexChanged" />
                            <asp:AsyncPostBackTrigger ControlID="ddlGender" EventName="SelectedIndexChanged" />
                        </Triggers>
                    </asp:UpdatePanel>--%>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
