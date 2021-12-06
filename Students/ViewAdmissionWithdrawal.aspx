<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ViewAdmissionWithdrawal.aspx.cs" Inherits="Students_ViewAdmissionWithdrawal" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <style type="text/css">
        @font-face
        {
            font-family: 'MonotypeCorsivaRegular';
            src: url('../fonts/mtcorsva.eot');
            src: url('../fonts/mtcorsva.eot') format('embedded-opentype'), url('../mtcorsva.woff') format('woff'), url('fonts/mtcorsva.ttf') format('truetype'), url('../fonts/mtcorsva.svg#MonotypeCorsivaRegular') format('svg');
        }
        
        .study-certificate
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
    <link rel="stylesheet" type="text/css" href="../css/AdmissionPrint.css" />
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%--Save Personal Details--%>
    <script type="text/javascript">
        $(function () {
            GetSerialNo();
        });
        function GetSerialNo() {
            $.ajax({
                type: "POST",
                url: "../Students/ViewAdmissionWithdrawal.aspx/GetSerialNo",
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
            if ($('#aspnetForm').valid()) {
                var parameters = '{"regNo": "' + $("[id*=txtRegNo]").val() + '","AcademicId": "' + $("[id*=hfAcademicYear]").val() + '","reason": "' + $("[id*=txtReason]").val() + '","remarks": "' + $("[id*=txtRemarks]").val() + '","UserId": "' + $("[id*=hfuserid]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Students/ViewAdmissionWithdrawal.aspx/Save",
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

            else if (response.d == "No") {
                AlertMessage('info', 'Please enter Admission Withdrawal info for this student');
            }

            else {
                AlertMessage('success', 'Admission Withdrawal Register Issued');
                Print();
            }
        }

        
    </script>
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head2">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/AdmissionPrint.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
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

                        { href: '../css/print-admission.css', media: 'print'}]
            });
        }
    </script>
</asp:Content>
<asp:Content ID="mainContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:HiddenField ID="hdnRegNo" runat="server" />
    <div class="grid_10" style="background-color:White;">
        <div class="box round first fullpage">
            <h2>
                ADMISSION / WITHDRAWL DATA</h2>
            <div class="block content-wrapper2 ">
                <table  width="100%" border="0" cellspacing="0" cellpadding="0" style=" background-color:White;">
                    <tr>
                        <td style="background-color:White;">
                            <div id="printContent" class="formsc" style="background-color:White;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="study-certificate">
                                    <tr>
                                        <td align="center" valign="top">
                                            <div class="st-certificate">
                                                <table width="980" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td align="center" class="tctext">
                                                            <img src="../img/login-school-logo.png" class="schoolLogo" alt="" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center">
                                                            <h1>
                                                                ADMISSION WITHDRAWAL REGISTER</h1>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div class="st-certificate-cont">
                                                                <table width="95%" cellpadding="5" cellspacing="0" class="bio-table">
                                                                    <tr>
                                                                        <td class="" valign="top" style="vertical-align: top;">
                                                                            <table width="" cellpadding="10" cellspacing="0" class="bio-table">
                                                                                <tr>
           <td class="" colspan="3"  style="width: 100%; background-color: #808080; font-weight: bold; color:#fff; padding:6px;" align="left">
                                                                                       ADMISSION DETAILS</td>
                              <td class="" style="background-color: #808080; font-weight: bold;" align="left"> &nbsp;</td>
                                                                                </tr>

                                                                                <tr><td class="" style="padding-bottom:0px;" colspan="3">&nbsp;</td></tr>

                                                                                <tr>
                                                                                    <td width="45%" class="">
                                                                                        <span class="alignleft">REGISTER NUMBER</span>
                                                                                    </td>
                                                                                    <td width="3%" class="">
                                                                                        :
                                                                                    </td>
                                                                                    <td width="40%" class="">
                                                                                        <asp:TextBox ID="txtRegNo" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td rowspan="4">
                                                                            <img id="imgSrc" runat="server"   alt="" /></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td  class="">
                                                                                        <span class="alignleft">ADMISSION NUMBER</span>
                                                                                    </td>
                                                                                    <td  class="">
                                                                                        :
                                                                                    </td>
                                                                                    <td  class="">
                                                                                        <asp:TextBox ID="txtAdminNo" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td  class="">
                                                                                        <span class="alignleft">NAME OF THE PUPIL</span>
                                                                                    </td>
                                                                                    <td  class="">
                                                                                        :
                                                                                    </td>
                                                                                    <td  class="">
                                                                                        <asp:TextBox ID="txtName" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="">
                                                                                        <span class="alignleft">SEX</span>
                                                                                    </td>
                                                                                    <td  class="">
                                                                                        :
                                                                                    </td>
                                                                                    <td class="">
                                                                                        <asp:TextBox ID="txtSex" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        FATHER NAME
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtFatherName" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        OCCUPATION
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtFOccupation" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        MOTHER NAME
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtMotherName" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        OCCUPATION
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtMOccupation" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        NAME OF THE GAURDIAN
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtGaurdian" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        OCCUPATION
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtGOccupation" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">DATE OF BIRTH </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtStudDOB" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">DATE OF ADMISSION </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtStudDOA" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">COMMUNITY WHETHER HE/SHE BELONGS TO SC/ST/BC/MBC/OC </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtCommCaste" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">NATIONALITY & RELIGION </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtNatReligion" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">MOTHER TONGUE</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtMotherTongue" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        SCHOOL AND CLASS STUDIED LAST
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtSchClassLast" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        NO & DATE OF BIRTH CERTIFICATE/RECORD SHEET/TC PRODUCED
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtRecord" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">CLASS TO WHICH ADMITTED</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtAdClass" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">ADDRESS</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtAddress" TextMode="MultiLine" Rows="5" Columns="30" Style="font-weight: bold"
                                                                                            runat="server" ReadOnly="True"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">PHONE NUMBER</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtPhNo" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>

                                                                                <tr><td class="" style="padding-bottom:0px;" colspan="3">&nbsp;</td></tr>

                                                                                <tr>
                      <td class="" colspan="3"  style="width: 100%; background-color: #808080; font-weight: bold; color:#fff; padding:6px;" align="left">
                                                                                        <strong>WITHDRAWAL DETAILS</strong></td>
                                                                                  <td class="" colspan="3"  style="width: 100%; background-color: #808080; font-weight: bold; color:#fff; padding:6px;" align="left">
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr><td class="" style="padding-bottom:0px;" colspan="3">&nbsp;</td></tr>



                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">CLASS STUDIED ON LEAVING</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtstudyLeave" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">N0 & DATE OF ISSUE OF TC</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtTcDate" Style="font-weight: bold" runat="server" ReadOnly="True"
                                                                                            Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">REASON FOR LEAVING</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtReason" Style="font-weight: bold" runat="server" Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="alignleft">REMARKS</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        :
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtRemarks" Style="font-weight: bold" runat="server" Width="200px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;</td>
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
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <%--  <tr>
                        <td style="vertical-align: top; padding-top: 9px;">
                            <table border="0" cellspacing="0" cellpadding="5" width="95%" style="text-align: center;"
                                class="course">
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
                                            <strong>Standard (s) studied</strong></p>
                                    </td>
                                    <td width="20%" valign="middle" class="cours-brd-tlr">
                                        <p>
                                            <strong>Medium of Instruction</strong></p>
                                    </td>
                                </tr>
                                <%= _StudCourceHistory %>
                            </table>
                        </td>
                    </tr>--%>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <button id="btnSave" type="button" class="btn-icon btn-orange btn-saving" onclick="Save();">
                                <span></span>Save & Print</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
