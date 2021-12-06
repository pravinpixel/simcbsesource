<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ViewPermissionApplication.aspx.cs" Inherits="Staffs_ViewPermissionApplication" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <style type="text/css">
        @font-face
        {
            font-family: 'MonotypeCorsivaRegular';
            src: url('../fonts/mtcorsva.eot');
            src: url('../fonts/mtcorsva.eot') format('embedded-opentype'), url('../mtcorsva.woff') format('woff'), url('fonts/mtcorsva.ttf') format('truetype'), url('../fonts/mtcorsva.svg#MonotypeCorsivaRegular') format('svg');
        }
    </style>
    <style type="text/css">
        @media print
        {
            .printContent
            {
                display: block;
            }
        }
        
        @media screen
        {
            .printContent
            {
                display: none;
            }
        }
    </style>
    <script type="text/javascript">
        $(function () {
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                var StaffLeaveId = $("[id*=hfStaffLeaveId]").val();
            
            var LeaveId = $("[id*=hfLeaveId]").val();
            if (StaffLeaveId != "" && StaffLeaveId != "0" && LeaveId!="") {
                GetLeaveApproval(StaffLeaveId, LeaveId);
            }
        });
        function SaveDetails() {
            if ($('#aspnetForm').valid()) {
                var parameters = '{"StaffLeaveId": "' + $("[id*=hfStaffLeaveId]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Staffs/ViewPermissionApplication.aspx/UpdateLeave",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSaveSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }

        function OnSaveSuccess(response) {
            if (response.d != "") {
                AlertMessage('info', 'Failed');
            }
            else {
                AlertMessage('success', 'Permission Application Generated');
                Print();
            }
        }

        function GetLeaveApproval(StaffLeaveId, LeaveId) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Staffs/ViewPermissionApplication.aspx/GetLeaveApproval",
                    data: '{"StaffLeaveId": "' + StaffLeaveId + '","LeaveId": "' + LeaveId + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: Onsuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });

            }
            else {
                $("table.form :input").prop('disabled', true);
                return false;
            }

        }

        function Onsuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Staffleave = xml.find("Staffleave");
            $.each(Staffleave, function () {
                $("[id*=lblStaffName]").html($(this).find("StaffName").text());
                $("[id*=lblEmpcode]").html($(this).find("EmpCode").text());
                $("[id*=lblDesignation]").html($(this).find("DesignationName").text());
                $("[id*=lblDaysRequested]").html($(this).find("NoofLeaves").text());
                $("[id*=lblReason]").html($(this).find("Reason").text());
                $("[id*=lblDatesRequested]").html($(this).find("LeaveFrom").text() + " to " + $(this).find("LeaveTo").text());
                $("[id*=txtLeaveTaken]").html($(this).find("LeavesTaken").text());
                $("[id*=lblStatus]").html($(this).find("StatusName").text());
                $("[id*=lblAppDate]").html($(this).find("AppDate").text());
                $("[id*=lblAppNo]").html($(this).find("LeaveId").text());
              
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head2">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/leaveprint.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
    <script type="text/javascript">
        function Print() {

            $(".formsc").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'

            }
                            ,
                overrideElementCSS: [

                        '../css/layout.css',

                        { href: '../css/leaveprint.css', media: 'print'}]
            });
        }
    </script>
</asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Permission Application
            </h2>
            <div class="block john-accord content-wrapper2">
                <div id="printContent" class="formsc">
                    <table class="formtc" width="100%">
                        <tr>
                            <td height="120" align="center" class="tctext">
                                <img src="../img/login-school-logo.png" alt="" width="615" height="110" />
                            </td>
                        </tr>
                        <tr>
                            <td height="50" align="center" valign="bottom" style="padding-top: 0px;">
                                <span class="leave-title">PERMISSION APPLICATION</span>
                            </td>
                        </tr>
                        <tr>
                            <td height="50" align="center" valign="bottom" style="padding-top: 0px;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tcbg">
                                    <tr>
                                        <td width="33%" height="40" align="left" valign="middle" class="leave-ser-no">
                                            Application No. :
                                            <asp:Label ID="lblAppNo" runat="server"></asp:Label>
                                            <br />
                                        </td>
                                        <td width="33%" align="right" valign="middle" class="leave-ser-no">
                                            Date of Application :
                                            <asp:Label ID="lblAppDate" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="30" class="">
                                <table border="0" cellspacing="0" cellpadding="5" width="100%" class="leaveapp">
                                    <tr>
                                        <td width="4%" height="30" class="leaveapp-brd-tl">
                                            1
                                        </td>
                                        <td width="32%" class="leaveapp-brd-tl">
                                            Name of the Staff
                                        </td>
                                        <td width="2%" class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td width="72%" class="leaveapp-brd-tlr">
                                            <asp:Label ID="lblStaffName" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            2
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Emp Code
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                            <asp:Label ID="lblEmpcode" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            3
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Designation
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                            <asp:Label ID="lblDesignation" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            4
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            No. of Hours requested
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                            <asp:Label ID="lblDaysRequested" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            5
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Time requested
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                            <asp:Label ID="lblDatesRequested" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            6
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Reason for permission
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                            <asp:Label ID="lblReason" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            7
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Number of permission taken so far
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                            <asp:Label ID="lblLeaveTaken" runat="server"></asp:Label>
                                        </td>
                                    </tr>                                                                   
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tlb">
                                            8
                                        </td>
                                        <td class="leaveapp-brd-tlb">
                                             Signature of the staff
                                        </td>
                                        <td class="leaveapp-brd-tlb">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlrb">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="70" style="vertical-align: top; padding-top: 9px;">
                                <asp:HiddenField ID="hfStaffLeaveId" runat="server" />
                                 <asp:HiddenField ID="hfLeaveId" runat="server" />
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
                <button id="btnSave" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveDetails();">
                    <span></span>Save & Print</button>
            </div>
        </div>
    </div>
    <div class="clear">
    </div>
</asp:Content>
