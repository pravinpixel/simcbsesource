<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="ViewTransferCertificate.aspx.cs"
    Inherits="Students_ViewTransferCertificate" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">

        function GetModuleMenuID(path) {
            $.ajax({
                type: "POST",
                url: "../Students/ViewTransferCertificate.aspx/GetModuleMenuId",
                data: '{"path": "' + path + '","UserId":"' + $("[id*=hdnUserId]").val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnModuleIDSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }
        function OnModuleIDSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var modmenu = xml.find("ModuleMenu");
            $("[id*=hfAcdMenuId]").val(modmenu.find("menuid").text());
            $("[id*=hfAcdModuleID]").val(modmenu.find("modulemenuid").text());
            var url = "../Students/TcApproval.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&StudentID=" + $("[id*=hdnRegNo]").val() + "";
            $(location).attr('href', url)
        }

        function SaveTCDetails(isPrintTc) {
            if ($("[id*=hfAddPrm]").val() == 'true') {
                if ($('#aspnetForm').valid()) {
                    var parameters = '{"isPrint":"' + isPrintTc + '","regNo": "' + $("[id*=hdnRegNo]").val() + '","academicId": "' + $("[id*=hfAcademicYear]").val() + '","userId": "' + $("[id*=hfuserid]").val() + '","leaveOfStudy": "' + $("[id*=txtSTD]").val() + '","promotionText": "' + $("[id*=txtPromotion]").val() + '","result": "' + $("[id*=txtResult]").val() + '","failed": "' + $("[id*=txtFailed]").val() + '","feesdue": "' + $("[id*=txtFees]").val() + '","concession": "' + $("[id*=txtConcession]").val() + '","working": "' + $("[id*=txtworking]").val() + '","present": "' + $("[id*=txtPresent]").val() + '","ncc": "' + $("[id*=txtNCC]").val() + '","extra": "' + $("[id*=txtGames]").val() + '","reason": "' + $("[id*=txtReason]").val() + '","remarks": "' + $("[id*=txtRemarks]").val() + '","conduct": "' + $("[id*=ddlConduct]").val() + '","applicationDate": "' + $("[id*=txtTCAppDate]").val() + '","tcDate": "' + $("[id*=txtTCDate]").val() + '","courseofStudy": "' + $("[id*=txtTCCoures]").val() + '","printtc":"1"}';
                    $.ajax({
                        type: "POST",
                        url: "../Students/ViewTransferCertificate.aspx/SaveTCDetails",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d == 'fail') {
                                AlertMessage('fail', 'TC Generate');
                            }

                            else if (response.d == 'false') {
                                AlertMessage('success', 'TC Generated');
                            }

                            else if (response.d == 'true') {
                                AlertMessage('success', 'TC Generated');
                                print();
                            }

                        },
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });
                }
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="head2" runat="Server">
    <style type="text/css">
        @media print
        {
            .bord-bott
            {
                border-bottom: 1px solid;
            }
        }
        
        @media screen
        {
            .bord-bott
            {
                border-bottom: 1px solid;
            }
        }
        
        .alignright
        {
            text-align: right;
        }
        .alignleft
        {
            text-align: left;
        }
        .aligncenter
        {
            text-align: center;
        }
        
        .logotxt
        {
            font-family: "Myriad Pro" , "Trebuchet MS" , Arial;
            text-align: left;
            vertical-align: top !important;
        }
        .style1
        {
            font-family: DV-TTNatraj;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtTCStudLateDate]");
            setDatePicker("[id*=txtTCAppDate]");
            setDatePicker("[id*=txtTCDate]");

        });


    </script>
    <%="<link href='" + ResolveUrl("~/css/tc.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
    <%="<link href='" + ResolveUrl("~/css/TCprint.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
        function print() {
            $(".formtc").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'
            }
            ,
                overrideElementCSS: [

        '../css/tc.css',

        { href: '../css/TCprint.css', media: 'print'}]

            });

        }


        function ChangeApproval() {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                if (jConfirm('Are you sure to approve this?', 'Confirm', function (r) {
                    if (r) {
                        $.ajax({
                            type: "POST",
                            url: "../Students/ViewTransferCertificate.aspx/ChangeApproval",
                            data: '{"regNo":"' + $("[id*=hdnRegNo]").val() + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnChangeSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }

                })) {
                }

            }
            else {
                return false;
            }
        }
        function OnChangeSuccess(response) {
            if (response.d == '') {
                AlertMessage('success', "TC Approved");
                GetModuleMenuID('Students/TcApproval.aspx');
            }
            else {
                AlertMessage('fail', "Approving TC Status");
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnRegNo" runat="server" />
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <asp:HiddenField ID="hdnAcademicYearId" runat="server" />
    <div class="grid_10">
        <div class="box round first">
            <h2>
                TRANSFER CERTIFICATE</h2>
            <div align="right">
                <button id="Button2" type="button" class="btn-icon btn-orange btn-saving" onclick="ChangeApproval()">
                    <span></span>Approve TC
                </button>
                <button id="Button1" type="button" class="btn-icon btn-orange btn-saving" onclick="GetModuleMenuID('Students/TcApproval.aspx')">
                    <span></span>Back</button></div>
            <table style="float: right">
                <tr>
                    <td align="center">
                    </td>
                    <td>
                        <button id="Button3" type="button" class="btn-icon btn-orange btn-saving" style="display: none;"
                            onclick="SaveTCDetails('true')">
                            <span></span>Save & PrintTC</button>
                    </td>
                </tr>
            </table>
            <div class="tc-block content-wrapper2">
                <table class="formtc">
                    <tr>
                        <td align="center" class="tctext" colspan="2">
                            <%--<img src="../images/login-school-logo.png" class="schoolLogo" alt="" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 50px;" colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td align="center" valign="bottom" style="padding-top: 0px;" colspan="2">
                            <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tcbg">
                                <tr>
                                    <td width="33%" align="left" valign="middle" class="ser-no">
                                        <br />
                                        Serial No :
                                        <%= _SerialNo%><br />
                                        Admission No :
                                        <%= _AdminNo%><br />
                                          Student UID :
                                        <%= _Studentuid%>
                                    </td>
                                    <td width="33%">
                                    </td>
                                    <%--  <td width="33%" align="center" valign="middle" class="tctext">
                                        TRANSFER CERTIFICATE
                                    </td>--%>
                                    <td width="33%" align="right" valign="middle" class="tc-photo">
                                        <img src="Photos/<%= _Regno%>.jpg" class="studPhoto" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="" colspan="2">
                            <table width="100%" cellpadding="5" cellspacing="0" class="formtctxt">
                               
                                <tr>
                                    <td height="40" class="tdHeight35">
                                        1.
                                    </td>
                                    <td>
                                        <span class="alignleft">Name of the Pupil /<span class="style1">  Ê´ÉtÉlÉÔ EòÉ xÉÉ¨É
                                        </span> </span>
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td class="tc-txt-upper">
                                        <asp:TextBox ID="txtStudentName" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="40" class="tdHeight35">
                                        2.
                                    </td>
                                    <td>
                                        <span class="alignleft">Father's / Guardian's Name /  <span class="style1">Ê{ÉiÉÉ / +Ê¦É¦ÉÉ´ÉEò EòÉ xÉÉ¨É
                                        </span> </span>
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td class="tc-txt-upper">
                                        <asp:TextBox ID="txtParentName" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                 <tr>
                                    <td height="40" class="tdHeight35">
                                        3.
                                    </td>
                                    <td>
                                        <span class="alignleft">Mother's Name /<span class="style1">  ¨ÉÉiÉÉ EòÉ xÉÉ¨É</span></span>
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td class="tc-txt-upper">
                                        <asp:TextBox ID="txtMotherName" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="40" class="tdHeight35">
                                        4.
                                    </td>
                                    <td>
                                        <span class="alignleft">Nationality /<span class="style1"> ®úÉ¹]õÒªÉiÉÉ </span> </span>
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td class="tc-txt-upper">
                                        <asp:TextBox ID="txtNationality" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        5.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Whether the candidate belongs to <br />
                                        Scheduled Caste or Scheduled Tribe /</span><span style="font-size:9.0pt;mso-bidi-font-size:10.0pt;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">/ </span>
                                        <span style="font-size:9.0pt;mso-bidi-font-size:14.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><span style="mso-spacerun:yes">&nbsp;</span></span><span style="font-size:12.0pt;
font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:
&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;
mso-bidi-language:AR-SA">CªÉÉ Ê´ÉtÉlÉÔ +xÉÖºÉÚÊSÉiÉ VÉÉÊiÉ /
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">+xÉÖºÉÚÊSÉiÉ VÉxÉVÉÉÊiÉ EòÉ ½èþ?</span></span></td>
                                    <td>
                                        :
                                    </td>
                                    <td class="tc-txt-upper">
                                        <asp:TextBox ID="txtCommunity" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                 <tr>
                                    <td height="40" class="tdHeight35">
                                        6
                                    </td>
                                    <td>
                                        <span class="alignleft">&nbsp;Date of first admission with class /  
                                        <span class="style1">
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">Ê´ÉtÉ±ÉªÉ ¨Éå |ÉlÉ¨É |É´Éä¶É EòÒ ÊiÉÊlÉ 
                                        +Éè®ú EòIÉÉ</span> </span>
 </span>
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td class="tc-txt-upper">
                                        <asp:TextBox ID="txtDOA" TextMode="MultiLine" Width="400" Height="30" Style="font-weight: bold"
                                            runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        7.
                                    </td>
                                    <td valign="top">
                                        Date of Birth ( in Christian Era ) according to the admission Register (in figures 
                                        &amp; in words) /
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">É´Éä¶É <span style="mso-spacerun:yes">&nbsp;</span>®úÊVÉº]õ®ú 
                                        Eäò +xÉÖºÉÉ®ú VÉx¨É ÊiÉÊlÉ </span>(<span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">(&lt;ÇºÉ´ÉÓ ºÉxÉ ¨Éå</span>)
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">+ÆEòÉä ¨Éå</span><span style="font-size:9.0pt;mso-bidi-font-size:14.0pt;font-family:
DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:
&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;
mso-bidi-language:AR-SA"> </span><span style="font-size:12.0pt;font-family:
DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:
&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;
mso-bidi-language:AR-SA">+Éè®ú ¶É¤nùÉå ¨Éå</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtDOB" TextMode="MultiLine" Width="400" Height="30" Style="font-weight: bold"
                                            runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                    <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        8.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Class in which the pupil last studied in words and in figures / 
                                        </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">+ÎxiÉ¨É EòIÉÉ ÊVÉºÉ ¨Éå Ê´ÉtÉlÉÔ xÉä 
                                        +vªÉªÉxÉ ÊEòªÉÉ +ÆEòÉå ¨Éå +Éè®ú ¶É¤nùÉå ¨Éå</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtSTD" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>

                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        9.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">School / Board Annual Examination last taken with result / 
                                        </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">¤ÉÉäbÇ÷ EòÒ +ÎxiÉ¨É ´ÉÉÌ¹ÉEò {É®úÒIÉÉ +Éè®ú 
                                        =ºÉEòÉ ¨ÉÊ®úhÉÉ¨É</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtResult" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>

                                  <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        10.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Whether failed? if so, once / twice in the same class / 
                                        </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">+xÉÖkÉÒhÉÇ ®ú½þÉ ªÉÊnù ½þÉÄ iÉÉä =ºÉÒ EòIÉÉ 
                                        ¨Éå CªÉÉ BEò ¤ÉÉ®ú / nùÉä ¤ÉÉ®</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtFailed" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>

                                  <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        11.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Subjects studied /<span class="style1"><span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">{Éfäø MÉB Ê´É¹ÉªÉ</span><span style="font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:
EN-US;mso-bidi-language:AR-SA"> /</span>
                                        </span>Compulsory / </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">+ÊxÉ´ÉÉªÉÇ</span><span style="font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;
mso-bidi-language:AR-SA"> /</span>Electives/<span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">´ÉèEòÎ±{ÉEò</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <input id="txtTCCoures" runat="server" name="txtTCCoures" type="text" /></td>
                                </tr>

                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        12.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Whether qualified for promotion to the higher class. If so, to which class/ 
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">CªÉÉ =SSÉiÉ®ú EòIÉÉ ¨Éå VÉÉxÉä Eäò ªÉÉäMªÉ 
                                        ½èþ? iÉÉä ÊEòºÉ EòIÉÉ ¨É </span>in figures and in words: 
                                        </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">+ÆEòÉå ¨Éå +Éè®ú ¶É¤nùÉå ¨Éå</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtPromotion" Style="font-weight: bold" CssClass="jsrequired" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                  <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        13.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Month up to which the pupil has paid School dues /  
                                        </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">ÊEòºÉ ¨ÉÉºÉ iÉEò Ê´ÉtÉ±ÉªÉ EòÒ näùªÉ 
                                        ®úÉÊ¶ÉªÉÉå EòÉ ¦ÉÖMÉiÉÉxÉ Eò®ú ÊnùªÉÉ ½èþ?</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtFees" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        13.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Any fee concession availed of; if so, the nature of such concession /  
                                        </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">CªÉÉ ÊEòºÉÒ ¶ÉÖ±Eò EòÒ Ê®úªÉÉªÉiÉ |ÉÉ{iÉ EòÒ 
                                        MÉ&lt;Ç, </span>
                                        <span style="font-size:
12.0pt;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><span style="mso-spacerun:yes">&nbsp;</span></span><span style="font-size:12.0pt;
font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:
&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;
mso-bidi-language:AR-SA">ªÉÊnù ½þÉÄ iÉÉä ´É½þ Ê®úªÉÉªÉiÉ ÊEòºÉ |ÉEòÉ®ú EòÒ lÉÒ?</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtConcession" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>

                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        14.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Total No. of working days /  </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">EòÉªÉÇÊnù´ÉºÉÉå EòÒ EÖò±É ºÉÆJªÉÉ</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtworking" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        15.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Total No. of working days present /  </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">EòÉªÉÇÊnù´ÉºÉÉå ¨Éå ºÉä EÖò±É ={ÉÎºlÉÊiÉ Eäò 
                                        ÊnùxÉ</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtPresent" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>

                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        16.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Whether NCC Cadet /Boy Scout / Girl Guide (details may be given) / 
                                        <span class="style1">
                                        <span style="font-size:9.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:
EN-US;mso-bidi-language:AR-SA">/ </span><span style="font-size:12.0pt;
font-family:DV-TTNatraj;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:
&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language:EN-US;
mso-bidi-language:AR-SA">CªÉÉ BxÉ ºÉÒ ºÉÒ Eèòb÷] </span>&nbsp;õ/ 
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">¤ÉÉ±ÉSÉ®ú(¤ÉÉªÉ ºEòÉ=]õ) </span>&nbsp;/ </span>
                                        </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">¤ÉÉ±ÉSÉÉÊ®úEòÉ(MÉ±ÉÇ MÉÉ&lt;b÷) ½èþ (¤ªÉÉè®úÉ 
                                        näù)</span><td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtNCC" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>

                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        17.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Games played or extra curricular activities in which the pupil usually took part, (mention achievement level therein)*<span 
                                            class="style1">
                                        </span></span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">JÉä±Éä MÉªÉä JÉä±É ªÉÉ +ÊiÉÊ®úHò 
                                        {ÉÉ`öªÉSÉªÉÉÇ <span style="mso-spacerun:yes">&nbsp;</span>ÊGòªÉÉEò±ÉÉ{É ÊVÉºÉ ¨Éå 
                                        Ê´ÉtÉlÉÔ xÉä ºÉÉ¨ÉÉxªÉiÉ: ¦ÉÉMÉ Ê±ÉªÉÉ ½þÉä (={É±ÉÎ¤nù ºiÉ®ú EòÉ =±±ÉäJÉ Eò®åú)</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtGames" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>

                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        18.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">General Conduct /  </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">ºÉÉ¨ÉÉxªÉ +ÉSÉ®úhÉ</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:DropDownList ID="ddlConduct" runat="server" AppendDataBoundItems="True">
                                            <asp:ListItem Selected="True" Value="">Select</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>

                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        20.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Date of application of certificate / 
                                        </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">|É¨ÉÉhÉ {ÉjÉ Eäò +É´ÉänùxÉ {ÉjÉ EòÒ ÊiÉÊlÉ</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <input id="txtTCAppDate" class="jsrequired" runat="server" name="txtTCAppDate" type="text" /></td>
                                </tr>
                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        21.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Date of issue of certificate / </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">|É¨ÉÉhÉ {ÉjÉ Eäò VÉÉ®úÒ Eò®úxÉä EòÒ ÊiÉÊlÉ</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <input id="txtTCDate" runat="server" class="jsrequired" name="txtTCDate" type="text" /></td>
                                </tr>
                                <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        22.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Reasons for leaving the school /  </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">Ê´ÉtÉ±ÉªÉ UôÉäb÷xÉä Eäò EòÉ®úhÉ</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtReason" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                 <tr>
                                    <td height="40" valign="top" class="tdHeight35">
                                        23.
                                    </td>
                                    <td valign="top">
                                        <span class="alignleft">Any other remarks /  </span>
                                        <span style="font-size:12.0pt;font-family:DV-TTNatraj;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;
mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA">EòÉä&lt;Ç +xªÉ +¦ªÉÖÊHò</span></td>
                                    <td valign="top">
                                        :
                                    </td>
                                    <td valign="top" class="tc-txt-upper">
                                        <asp:TextBox ID="txtRemarks" Style="font-weight: bold" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                </table>
                        </td>
                    </tr>
                    <%-- <tr>
                        <td style="vertical-align: top; padding-top: 9px;" class="style1">
                            <strong><span class="alignleft">Signature of the Principle with date and school seal
                            </span></strong>
                        </td>
                    </tr>--%>
                    <tr>
                        <td style="vertical-align: top; padding-top: 9px;" colspan="2">
                            <span class="aligncenter">Note: </span>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top; padding-top: 9px;">
                            <span class="alignleft">1. Erasures and unauthenticated or fraudulent alteration will
                                lead to its cancellation</span><br />
                            <span class="alignleft">2. Should be signed in ink by the Head of the Institution, who
                                will be held responsible for the correctness of the entries</span>
                        </td>
                        <td style="vertical-align: top; padding-top: 9px;">
                            <strong>Signature of the Principal      
                            <br />
                            with date and school seal </strong>&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="center" style="padding-top: 20px;" colspan="2">
                            <span class="decleartion"><strong>Declaration by the Parent or Guardian </strong>
                            </span>
                            <br />
                            <span class="aligncenter">I here by declare that the particulars recorded against items
                                2 to 7 are correct and that no change will be demanded by me in future. </span>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="vertical-align: top; padding-top: 9px;" colspan="2">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="signparent" align="left" colspan="2">
                            <strong>Signature of the Parent / Guardian </strong>
                        </td>
                    </tr>

                    <tr>
                        <td class="signparent" align="left" colspan="2">
                            <strong>Visit us @ www.amalorpavamacademy.com</strong>
                        </td>
                    </tr>
                    <tr>
                        <td height="50" style="vertical-align: top; padding-top: 9px;" colspan="2">
                            &nbsp;
                            <asp:HiddenField ID="hfAcdModuleID" runat="server" />
                            <asp:HiddenField ID="hfAcdMenuId" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
