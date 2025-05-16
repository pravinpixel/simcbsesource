<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="MarkListReport.aspx.cs"
    Inherits="Performance_MarkEntry" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {

        });
    </script>
    <style type="text/css">
    .highlight { background:#A7A4A4;}
        .jsrequired
        {}
    </style>
    <script type="text/JavaScript">

        function Export() {
            var a = document.createElement('a');
            var data_type = 'data:application/vnd.ms-excel';
            var table_html = encodeURIComponent($('div[id$=dvCard]').html());
            a.href = data_type + ', ' + table_html;
            a.download = 'MarkList.xls';
            a.click();
        }
    </script>
     <script type="text/javascript">
         function Cancel() {
             $("[id*=ddlClass]").val("");
             $("[id*=ddlSection]").val("");
             $("[id*=ddlExamName]").val("");
             $("[id*=ddlExamType]").val("");
             $("[id*=txtMarkFrom]").val("");
             $("[id*=txtMarkTo]").val("");
             $("[id*=ddlType]").val("");
             $('#aspnetForm').validate().resetForm();
             if ($("[id*=hfAddPrm]").val() == 'false') {
                 $("table.form :input").prop('disabled', true);
             }
             else
                 $("table.form :input").prop('disabled', false);
         };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
  <%--  <script type="text/javascript">

        function Cancel() {

            $("[id*=chkSMSSelectAll]").attr("checked", false);
            SMSSelectAll();

            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            $("[id*=ddlExamName]").val("");
            $("[id*=ddlType]").val("");
            $("[id*=ddlSubjects]").val("");
            $("[id*=ddlExamType]").val("");
            $("[id*=ddlResult]").val("");          
                   
            $('#aspnetForm').validate().resetForm();
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

    </script>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                MarkList Report
            </h2>
            <div class="block content-wrapper2">
                <asp:UpdatePanel ID="ups" runat="server">
                    <ContentTemplate>
                        <table class="form" width="100%">
                            <tr>
                                <td>
                                    <div id="dvmarkEntry">
                                        <table width="100%">
                                            <tr>                                                                                        
                                                <td  width="15%" height="40">
                                                    <label>
                                                        ExamName :</label>
                                                    <asp:DropDownList ID="ddlExamName" runat="server" AppendDataBoundItems="True" CssClass="jsrequired"
                                                        OnSelectedIndexChanged="ddlExamName_SelectedIndexChanged" 
                                                        AutoPostBack="True" Height="26px">
                                                        <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>

                                                 <td width="15%">
                                                    <label>
                                                        Class &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label>
                                                    <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AutoPostBack="True" 
                                                         onselectedindexchanged="ddlClass_SelectedIndexChanged">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>

                                                <td  width="25%">
                                                    <label>
                                                        Section &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :</label>
                                                    <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td  height="40">
                                                    <label>
                                                        ExamType &nbsp;:</label>
                                                    <asp:DropDownList ID="ddlExamType" runat="server" CssClass="jsrequired" 
                                                        AutoPostBack="True">
                                                        <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>      

                                                <td>
                                                    <label>
                                                        Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :</label>
                                                    <asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="True" 
                                                        CssClass="jsrequired" AutoPostBack="True" 
                                                        onselectedindexchanged="ddlType_SelectedIndexChanged">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                        <asp:ListItem Value="General">General</asp:ListItem>
                                                        <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                                        <asp:ListItem>Slip Test</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>

                                                <td>
                                                   <%-- <label>
                                                Subject :</label>
                                            <asp:DropDownList ID="ddlSubjects" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>--%>

                                                  <label>
                                                        Mark From &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :</label>
                                                    <asp:TextBox ID="txtMarkFrom" runat="server" Width="50px"></asp:TextBox>
                                               <%--     <asp:RegularExpressionValidator id="RegularExpressionValidator2" ControlToValidate="txtMarkFrom"  
                                                    ValidationExpression="\d+" Display="Static" EnableClientScript="true" ErrorMessage="Enter numbers only" runat="server"/>--%>
                                                     <label>
                                                        To :</label>
                                                    <asp:TextBox ID="txtMarkTo" runat="server" Width="50px"></asp:TextBox>
                                                   <%-- <asp:RegularExpressionValidator id="RegularExpressionValidator1" ControlToValidate="txtMarkTo"  
                                                    ValidationExpression="\d+" Display="Static" EnableClientScript="true" ErrorMessage="Enter numbers only" runat="server"/>--%>
                                                    &nbsp;

                                                    <label>
                                                        Subjects :</label>
                                                   <asp:DropDownList ID="ddlSubjects" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                                   </asp:DropDownList>

                                                    </td>

                                            </tr>
                                        
                                            <tr>

                                             <td>
                                           
                                            </td>

                                             <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                   
                                                          <asp:Button ID="btnSearch" runat="server" class="btn-icon button-search" 
                                              Text="Search" onclick="btnSearch_Click" />
                                                 <asp:Button ID="Button1" runat="server" class="btn-icon button-cancel" 
                                                     OnClientClick="return Cancel();" Text="Cancel" />
                                                 <asp:Button ID="btnExport" runat="server" class="btn-icon button-exprots" 
                                                     OnClientClick="Export();" Text="Export" />
                                                </td>

                                            <td>
                                                
                                            </td>
                                               
                                            </tr>

                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>

                         <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                             <div class="IDprint">
                                <div id="dvCard" style="overflow :auto; width:1000px;" runat="server">

                                

                                </div> 
                            </div>
                        </td>
                    </tr>
                </table>



                    </ContentTemplate>
                    <Triggers>
                         <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnExport" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="ddlExamName" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlClass" EventName="SelectedIndexChanged" />
                     </Triggers>
                </asp:UpdatePanel>
          
          
               
            </div>





        </div>
    </div>
</asp:Content>
