<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ViewStudyCertificate.aspx.cs" Inherits="Students_ViewStudyCertificate" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">

   <style>
     @font-face
        {
            font-family: 'MonotypeCorsivaRegular';
            src: url('../fonts/mtcorsva.eot');
            src: url('../fonts/mtcorsva.eot') format('embedded-opentype'), url('../mtcorsva.woff') format('woff'), url('fonts/mtcorsva.ttf') format('truetype'), url('../fonts/mtcorsva.svg#MonotypeCorsivaRegular') format('svg');
        }
        
        .study-certificate
        {
            background: url(../img/study-certificate-bg.jpg) no-repeat center top;
        }
        
        .st-certificate
        {
        }
        .st-certificate h1
        {
            font-family: "MonotypeCorsivaRegular" , Georgia, "Times New Roman" , Times, serif;
            font-size: 35px;
            font-weight: normal;
            margin: 0px;
            display: inline;
            text-decoration: underline;
            color: #000;
        }
        .st-certificate-cont
        {
            width: 950px;
            margin: 20px auto;
        }
        .st-certificate-cont1
        {
        }
        
        .st-certificate-cont h4
        {
            margin: 0px;
            font-family: "MonotypeCorsivaRegular" , Georgia, "Times New Roman" , Times, serif;
            font-size: 29px;
            line-height: 50px;
            font-weight: normal;
            font-style: italic;
            color: #000;
        }
        .st-certificate-name
        {
            /*text-decoration: underline;*/
            font-weight: bold;
            font-style: italic;
        }
        .bio-table
        {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 18px;
            color: #000;
        }
        .bio-th
        {
            background: #CCC;
        }
        
        .st-certificate-cont img
        {
            -webkit-border-radius: 6px;
            -moz-border-radius: 6px;
            border-radius: 6px;
            border: 2px solid #cecece;
        }
        .style1
        {
            width: 48%;
            height: 30px;
            text-transform: uppercase;
            font-size: 18px;
            font-weight:normal;
        }
   
   
   </style>

<style>
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
     <link rel="stylesheet" type="text/css" href="../css/ScPrint.css" />
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%--Save Personal Details--%>
    <script type="text/javascript">
        $(function () {
            GetSerialNo();
        });
        function GetSerialNo() {
            $.ajax({
                type: "POST",
                url: "../Students/ViewStudyCertificate.aspx/GetSerialNo",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetSerialNoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetSerialNoSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var SCID = xml.find("SCIDs");
            $.each(SCID, function () {
                $("[id*=lblSLNo]").html($(this).find("SerialNo").text());
            });
        };

        function Save() {
            var conduct = $("#ctl00_ContentPlaceHolder1_ddLConduct option:selected").text();
            if ($('#aspnetForm').valid()) {
                var parameters = '{"slNo": "' + $("[id*=lblSLNo]").html() + '","RegNo": "' + $("[id*=hdnRegNo]").val() + '","AcademicId": "' + $("[id*=hfAcademicYear]").val() + '","Class": "' + $("[id*=txtClass]").val() + '","SubStudyPart1": "' + $("[id*=txtStudyP1]").val() + '","SubStudyPart2": "' + $("[id*=txtStudyP2]").val() + '","SubStudyPart3": "' + $("[id*=txtStudyP3]").val() + '","Conduct": "' + conduct + '","Purpose": "' + $("[id*=txtPurpose]").val() + '","UserId": "' + $("[id*=hfuserid]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Students/ViewStudyCertificate.aspx/Save",
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
                AlertMessage('success', 'Study Certificate Issued');
                Print();
            }
        }

        
    </script>
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head2">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/print-sc.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
    <script type="text/javascript">
        function Print() {

            $(".formsc").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 0px 0px 20px;color:#000 !important;'

            }
                            ,
                overrideElementCSS: [

                        '../css/ScPrint.css',

                        { href: '../css/print-sc.css', media: 'print'}]
            });
        }
    </script>
</asp:Content>
<asp:Content ID="mainContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:HiddenField ID="hdnRegNo" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                COURSE CERTIFICATE</h2>
            <div class="block content-wrapper2">
                <table style="float: right">
                    <tr>
                        <%--  <td valign="top" align="center">
                            <button id="Button2" type="button" class="btn-icon btn-navy btn-save" onclick="storeTCDetails(1);">
                                <span></span>Save TC</button>
                        </td>--%>
                    </tr>
                </table>
                <div id="printContent" class="formsc">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="study-certificate">
                        <tr>
                            <td height="1300" align="center" valign="top">
                                <div class="st-certificate">
                                    <table width="980" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td height="220">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <h1>
                                                    COURSE CERTIFICATE</h1>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="st-certificate-cont">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td style="padding-right:40px;">
                                                                <img id="imgSrc" runat="server" width="136" height="146" style="margin-left: 20px;"
                                                                    class="studPhoto" alt="" align="right" />
                                                                <h4>
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This is to certify that selvan/selvi <span class="st-certificate-name">
                                                                        <asp:Label ID="lblName" runat="server"></asp:Label>
                                                                        &nbsp;</span>has been/is a bonafide student of this School during <b>
                                                                            <asp:Label ID="lblAcademic" runat="server"></asp:Label>
                                                                            <asp:Label ID="lblAcdYear" runat="server"></asp:Label>&nbsp;</b>and his/her
                                                                    bio-data as per school record is furnished below.</h4>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="12" class="bio-table">
                                                                    <tr>
                                                                        <td colspan="3" align="center" class="">
                                                                            <%--  <strong>Bio - Data</strong>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            1. Admission No
                                                                        </td>
                                                                        <td width="4%">
                                                                            :
                                                                        </td>
                                                                        <td width="48%">
                                                                            <span>
                                                                                <asp:TextBox ID="txtAdminNo" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            2. Father's and Mother's Name
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <span runat="server">
                                                                                <asp:TextBox ID="txtParentName" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            3. Date Of Birth
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtStudDOB" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            4. Class Studied/Studying
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtClass" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            5. Nationality
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtNationality" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            6. Religion
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtReligion" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            7. Caste and Community
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtCasteComm" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            8. Subject Of Study
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;</td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="font-size:18px;">
                                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PART&nbsp; I
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtStudyP1" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="font-size:18px;">
                                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PART&nbsp; II
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtStudyP2" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="font-size:18px;">
                                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PART&nbsp; III&nbsp;
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtStudyP3" Style="font-weight: bold" runat="server" 
                                                                                Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            9. Conduct
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <asp:DropDownList ID="ddLConduct" runat="server" Style="font-weight: bold" Width="250px">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            10.Purpose of Certificate
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtPurpose" Style="font-weight: bold" runat="server" Width="400px"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="style1" align="left">
                                                                            <%--School Studied--%>
                                                                        </td>
                                                                        <td>
                                                                            <%--:--%>
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                            <asp:Label ID="lblSchoolStudied" runat="server" Visible="false"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="vertical-align: top; padding-top: 9px;" colspan="3">
                                                                          
                                                                            <div id="OldSchool" runat="server">
                                                                                <table border="1" class="bord-bott" cellspacing="0" cellpadding="5" width="95%" style="text-align: center;"
                                                                                    class="course">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td width="20%" valign="middle" class="cours-brd-tl">
                                                                                                <p>
                                                                                                    <strong>Name of the School</strong></p>
                                                                                            </td>
                                                                                            <td width="20%" valign="middle" class="cours-brd-tl">
                                                                                                <p>
                                                                                                    <strong>Academic Year (s)</strong></p>
                                                                                            </td>
                                                                                            <td width="20%" valign="middle" class="cours-brd-tl">
                                                                                                <p>
                                                                                                    <strong>Standard(s) studied/Studying</strong></p>
                                                                                            </td>
                                                                                            <td width="20%" valign="middle" class="cours-brd-tlr">
                                                                                                <p>
                                                                                                    <strong>Medium of Instruction</strong></p>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%= _StudCourceHistory %>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td height="40">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Date :
                                                                            <asp:Label ID="lblDate" runat="server"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td align="right">
                                                                           
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <table cellpadding="5" cellspacing="0" class="formsctxt">
                </table>
                <table cellpadding="10" cellspacing="10">
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" align="center">
                            <button id="btnSave" type="button" class="btn-icon btn-orange btn-saving" onclick="Save();">
                                <span></span>Save & Print</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
