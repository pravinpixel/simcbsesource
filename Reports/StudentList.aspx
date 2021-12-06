<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StudentList.aspx.cs" Inherits="Reports_StudentList" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtStartdate]");
            setDatePicker("[id*=txtEnddate]");
        });
        $(function () {
            $("[id$=btnExport]").click(function (e) {
                window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=dvCard]').html()));
                e.preventDefault();
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function print() {

            $(".IDprint").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 15px 0px 20px;color:#000;font-family:Arial, Helvetica, sans-serif; font-size:5px; text-align: left; !important;'

            }
            , overrideElementCSS: [
                    '../css/layout.css',
                    { href: '../css/performance-print.css', media: 'print'}]
            });
        }

    </script>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Student List Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                <table align="center">
                    <tr align="center">
                        <td width="200px">
                            <asp:DropDownList ID="ddlType" runat="server">
                                <asp:ListItem Value="">---Select Type---</asp:ListItem>
                                <asp:ListItem Value="StudentName">Student Name</asp:ListItem>
                                <asp:ListItem Value="RegNo">RegNo</asp:ListItem>
                                <asp:ListItem Value="AdmissionNo">Admission No</asp:ListItem>
                                <asp:ListItem Value="Sex">Sex</asp:ListItem>
                                <asp:ListItem Value="DOB">Date of Birth</asp:ListItem>
                                <asp:ListItem Value="DOJ">Date Of Joining</asp:ListItem>  
                                <asp:ListItem Value="Religion">Religion</asp:ListItem>
                                <asp:ListItem Value="Nationality">Nationality</asp:ListItem>
                                <asp:ListItem Value="Community">Community</asp:ListItem>
                                <asp:ListItem Value="Caste">Caste</asp:ListItem>                               
                                <asp:ListItem Value="PermAddress">Permanent Address</asp:ListItem>
                                <asp:ListItem Value="ContactAddress">Contact Address</asp:ListItem>    
                                <asp:ListItem Value="RationCardNo">RationCardNo</asp:ListItem>
                                <asp:ListItem Value="SmartCardNo">SmartCardNo</asp:ListItem>                              
                                <asp:ListItem Value="BloodGroup">BloodGroup</asp:ListItem>            
                                <asp:ListItem Value="Weight">Weight</asp:ListItem>
                                <asp:ListItem Value="Height">Height</asp:ListItem>
                                <asp:ListItem Value="EmergencyPhNo">EmergencyPhNo</asp:ListItem>
                                <asp:ListItem Value="Doctor">Family Doctor Name</asp:ListItem>
                                <asp:ListItem Value="DocAddr">Doctor Address</asp:ListItem>
                                <asp:ListItem Value="DocPhNo">Doctor Ph.No</asp:ListItem>  
                                <asp:ListItem Value="FatherName">Father Name</asp:ListItem>        
                                <asp:ListItem Value="FatherEmail">Father Email</asp:ListItem>      
                                <asp:ListItem Value="FatherPhone">Father Phone</asp:ListItem>   
                                <asp:ListItem Value="MotherName">Mother Name</asp:ListItem>        
                                <asp:ListItem Value="MotherEmail">Mother Email</asp:ListItem>      
                                <asp:ListItem Value="MotherPhone">Mother Phone</asp:ListItem>    
                                <asp:ListItem Value="AdmittedClassName">Admitted ClassName</asp:ListItem>        
                                <asp:ListItem Value="CurrentClassName">Current ClassName</asp:ListItem>       
                                                   
                            </asp:DropDownList>
                        </td>
                        <td width="200px">
                            <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
                        </td>
                        <td width="200px">
                            <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Show" runat="server"
                                OnClick="btnSearch_Click" />&nbsp;
                            <input type="button" id="btnExport" value="Export" class="btn-icon button-exprots" />
                        </td>
                    </tr>
                </table>
                <br />
                <div style="overflow: scroll;">
                    <table align="center">
                        <tr align="center">
                            <td>
                                <div class="IDprint">
                                    <div id="dvCard" runat="server" class="staff-list-report">
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
