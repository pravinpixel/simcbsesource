<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true" CodeFile="Certificatemissing.aspx.cs" Inherits="Reports_Certificatemissing" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>   
  <script type="text/javascript">
      $(function () {
          $("[id$=btnExport]").click(function (e) {
              window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=dvCard]').html()));
              e.preventDefault();
          });
      });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

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
                Certificate Missing Report</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">            
                        <table align="center">
                            <tr align="center">

                                <td width="200px">
                                   <asp:Button ID="btnSearch" class="btn-icon button-search" Text="Show" 
                                        runat="server" onclick="btnSearch_Click" />&nbsp;
                                   <input type="button" id="btnExport" value="Export" class="btn-icon button-exprots" />
                                </td>
                            </tr>                            
                        </table>                   
           
           <br />

            <div>            
                        <table>
                            <tr>
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

