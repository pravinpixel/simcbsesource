<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="BioData.aspx.cs" Inherits="Staffs_BioData" %>

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
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head2">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%-- <%="<link href='" + ResolveUrl("~/css/layout.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>--%>
    <script type="text/javascript">
        function Print() {

            $(".formsc").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'

            }
                //                            ,
                //                overrideElementCSS: [

                //                        '../css/layout.css',

                //                        { href: '../css/layout.css', media: 'print'}]
            });
        }
    </script>
</asp:Content>
<asp:Content ID="mainContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Bio Data</h2>
            <div class="block john-accord content-wrapper2">
            <table class="form" width="100%">
                    <tr>
                        <td>
                            Staff Name<label>
                                :</label>
                            <asp:DropDownList ID="ddlStaffName" runat="server" AppendDataBoundItems="True">
                             <asp:ListItem Value="">-----Select-----</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;
                            <label>
                                Department :</label>
                            <asp:DropDownList ID="ddlDepartment" runat="server" AppendDataBoundItems="True">
                             <asp:ListItem Value="">-----Select-----</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;
                            <asp:Button ID="btnSearch" runat="server" class="btn-icon button-search" 
                                Text="Search" onclick="btnSearch_Click" />
                            <asp:Button ID="Button2" runat="server" class="btn-icon button-cancel" OnClientClick="return Cancel();"
                                Text="Cancel" onclick="Button2_Click" />
                                   <button id="btnSave" type="button" class="btn-icon btn-orange btn-saving" onclick="Print();">
                    <span></span>Save & Print</button>
                        </td>
                    </tr>
                </table>
                <div class="clear">
                </div>
             
                <div id="printContent" class="formsc" runat="server">
                    <%--<table class="formtc" width="100%">
                        <tr>
                            <td height="120" align="center" class="tctext">
                                <img src="../img/amalorpavam-tc-logotext.png" alt="" width="615" height="110" />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" valign="bottom" style="padding-top: 0px;">
                                <span class="leave-title">BIO - DATA</span> 
                            </td>
                        </tr>
                        <tr>
                            <td  align="center" valign="bottom" style="padding-top: 0px;" height="10">
                                
                            </td>
                        </tr>
                        <tr>
                            <td height="30" class="">
                               <div class="user-details" > <div class="user-photo" ><img src="../img/photo.jpg" alt="" width="120" height="120" /></div><table border="0" cellspacing="0" cellpadding="5" width="100%" class="leaveapp"  >
                                    <tr>
                                        <td height="30" width="4%" class="leaveapp-brd-tl">
                                            1
                                        </td>
                                        <td class="leaveapp-brd-tl" width="30%">
                                            Name in Full
                                        </td>
                                        <td width="4%" class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td width="62%" class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblStaffName" runat="server"></asp:Label>
                                        </td>                                       
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            2
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Date of Birth
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblDOB" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            3
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Name of the Father
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblFatherName" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            4
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Name of the Mother
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblMotherName" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            5
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Name of the spouse, if Married
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblSpouseName" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            6
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Nationality
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblNationality" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            7
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Religion
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblReligion" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            8
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Caste
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblCaste" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            9
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Community
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblCommunity" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr >
                              <td height="30" class="leaveapp-brd-tl" >10</td>
                              <td colspan="3" class="leaveapp-brd-tlr" >Educational Qualification</td>
                            </tr>


                                    <tr>
                              <td height="30" class="leaveapp-brd-tl">&nbsp;</td>
                              <td class="leaveapp-brd-tl">&nbsp;</td>
                              <td class="leaveapp-brd-tl">&nbsp;</td>
                              <td class="leaveapp-brd-tlr"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="qualific">
                                <tr bgcolor="#999999">
                                  <td width="10%" class="leaveapp-brd-tl"  >Sl.No</td>
                                  <td width="20%" class="leaveapp-brd-tl">Qualicfication</td>
                                  <td width="51%" class="leaveapp-brd-tl">Board of Exam</td>
                                  <td width="19%" class="leaveapp-brd-tlr">Year of Pass</td>
                                </tr>
                                <tr>
                                  <td class="leaveapp-brd-tl">&nbsp;</td>
                                  <td class="leaveapp-brd-tl">&nbsp;</td>
                                  <td class="leaveapp-brd-tl">&nbsp;</td>
                                  <td class="leaveapp-brd-tlr">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td class="leaveapp-brd-tlb">&nbsp;</td>
                                  <td class="leaveapp-brd-tlb">&nbsp;</td>
                                  <td class="leaveapp-brd-tlb">&nbsp;</td>
                                  <td class="leaveapp-brd-tlrb">&nbsp;</td>
                                </tr>
                              </table></td>
                            </tr>



                                
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            11
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Exact height measurement in cm
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            &nbsp;
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblHeight" runat="server"></asp:Label>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            12
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Personal marks of identification
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                            a.)&nbsp;<asp:Label ID="lblIdentification1" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            &nbsp;
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            &nbsp;
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            &nbsp;
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                            b.)&nbsp;<asp:Label ID="lblIdentification2" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            13
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Residential Address
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        &nbsp;<asp:Label ID="lblResidential" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tl">
                                            14
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            Aardhar No.
                                        </td>
                                        <td class="leaveapp-brd-tl">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlr">
                                        <asp:Label ID="lblAadhaar" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td height="30" class="leaveapp-brd-tlb">
                                         15
                                        </td>
                                        <td class="leaveapp-brd-tlb">
                                           PAN No.
                                        </td>
                                        <td class="leaveapp-brd-tlb">
                                            :
                                        </td>
                                        <td class="leaveapp-brd-tlrb">
                                           <asp:Label ID="lblPan" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                                
                                
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align: top; padding-top: 9px;" class="leave-staff" ><br />
                                Sign of the Staff
                            </td>
                        </tr>
                        <tr>
                            <td height="70" style="vertical-align: top;  padding-top: 9px;" class="leave-staff"><br />
                                 Sign of the Head of the 
                                 Institution with Seal
                            </td>
                        </tr>
                    </table>--%>
                </div>
            </div>
        </div>
    </div>
    <div class="clear">
    </div>
</asp:Content>
