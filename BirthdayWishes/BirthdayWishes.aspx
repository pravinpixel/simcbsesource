<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="BirthdayWishes.aspx.cs" Inherits="BirthdayWishes_BirthdayWishes" %>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <style>
        @media print
        {
            .printDivBdayList
            {
                display: block;
            }
        }
        
        @media screen
        {
            .printDivBdayList
            {
                display: none;
            }
        }
    </style>
    <link rel="stylesheet" type="text/css" href="../css/birthday.css" />
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) { dd = '0' + dd } if (mm < 10) { mm = '0' + mm } today = dd + '/' + mm + '/' + yyyy;
            $("[id*=hdnDate]").val(today);
            setCurrentDatePicker("[id*=txtDate]");
        });
        //setup current DatePicker
        function setCurrentDatePicker(containerElement) {
            var datePicker = $('#' + containerElement);
            datePicker.datepicker({
                showOn: "button",
                buttonImage: "img/calendar.gif",
                buttonImageOnly: true,
                dateFormat: 'dd/mm/yy',
                changeMonth: true,
                changeYear: true,
                yearRange: '1950:2020',
                onSelect: function (dateText) {
                    SelectBirthdayList(dateText);
                }
            }).datepicker('setDate', $("[id*=hdnDate]").val());
        }
        function SelectBirthdayList(dateText) {
            $("[id*=hdnDate]").val(dateText);
            if (dateText != '') {
                var parameters = '{"date": "' + dateText + '"}';
                $.ajax({
                    type: "POST",
                    url: "../BirthdayWishes/BirthdayWishes.aspx/GetList",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSelectSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnSelectSuccess(response) {
            //alert(z);
        }
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="head2" runat="Server">
    <%="<link href='" + ResolveUrl("~/css/print-birthday.css") + "' rel='stylesheet' type='text/css'  media='print, handheld' />"%>
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">

        function test() {
            $(".printAllDiv").printElement(
            {
                leaveOpen: false,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'

            },
                overrideElementCSS: [

        '../css/birthday.css',

        { href: '../css/print-birthday.css', media: 'print'}]
            });
        }
        function printAll() {
            if ($('.pagingClass a').length != 0) {
                var indx = '';
                $('.pagingClass a').each(function () {
                    indx += $(this).html();
                    indx += ",";
                });

                var parameters = '{"type": "' + $("[id*=dpList]").val() + '","date":"' + $("[id*=txtDate]").val() + '","index":"' + indx + '","template":"' + $("[id*=dpTemplateList]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../BirthdayWishes/BirthdayWishes.aspx/GetPrintOut",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnPrintSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                var parameters = '{"type": "' + $("[id*=dpList]").val() + '","date":"' + $("[id*=txtDate]").val() + '","index":"1","template":"' + $("[id*=dpTemplateList]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../BirthdayWishes/BirthdayWishes.aspx/GetPrintOut",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnPrintSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });

                alert(allDiv);
            }

        }
        function OnPrintSuccess(response) {
            //$('.printDivBdayList').css("display", "block");
            $(".printAllDiv").html(response.d)
            test();
            //$('.printAllDiv').css("display", "block");
        }
    </script>
</asp:Content>
<asp:Content ID="mainContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:HiddenField ID="hdnDate" runat="server" />
    <asp:UpdatePanel ID="upd" runat="server"> 
        <ContentTemplate>
            <asp:HiddenField ID="hdnCount" runat="server" /> 
            <div class="grid_10">
                <div class="box round first fullpage" style="overflow: auto; height: 600px;">
                    <h2>
                        Birthday Wishes</h2>
                    <div class="block content-wrapper2">
                        <div>
                            <table width="100%" >
                                <tr valign="top">
                                    <td width="900" valign="top">
                                        <table width="106%" class="form">
                                            <tr>
                                                <td width="10%" height="22" class="">
                                                    <label>
                                                Select Template</label></td>
                                                <td width="2%" class="">
                                                    
                                                  <span class="">
                                                    <label> : </label>
                                                </span></td>
                                                <td width="24%" class=""><asp:DropDownList ID="dpTemplateList" runat="server">
                                                    </asp:DropDownList></td>
                                                <td width="9%" class="">
                                                    <label>
                                                Select Date</label></td>
                                                <td width="1%" class=""><label> </label>
: </td>
                                                <td width="54%" class=""> <asp:TextBox ID="txtDate" runat="server" CssClass="jsrequired"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="">
                                                    <label>
                                                Staff List</label></td>
                                                <td class="">
                                                   
                                                <label> :</label></td>
                                                <td class=""> <asp:ListBox ID="lstStaff" runat="server" CssClass=""></asp:ListBox></td>
                                                <td class="">
                                                    <label>
                                                Student List </label></td>
                                                <td class=""><label>:</label>
                                                </td>
                                                <td class=""><asp:ListBox ID="lstStudent" runat="server"></asp:ListBox></td>
                                            </tr>
                                            <tr>
                                                <td height="50" class="">
                                                    <label>Generate For</label></td>
                                                <td class="">
                                                    
                                                <label> :</label></td>
                                                <td class=""><asp:DropDownList ID="dpList" runat="server">
                                                        <asp:ListItem Text="Staff" Value="Staff"></asp:ListItem>
                                                        <asp:ListItem Text="Student" Value="Student"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td class="" align="left">&nbsp;
                                                   
                                              </td>
                                              <td class="" align="left">&nbsp;</td>
                                                <td class="" align="left" valign="middle" height="45"> 
                                                <asp:Button ID="btnGenerate" runat="server" OnClick="btnGenerate_Click" Text="Generate" CssClass="btn-icon button-generate" />
                                             <span><asp:Button ID="btnExport" runat="server" OnClick="btnExport_Click" class="btn-icon button-exprots" Text="Export" /></span>
                                               <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                        runat="server" onClick="return Cancel();">
                                                                        <span></span>Cancel</button>
                                                   
                                                    <button type="button" onclick="printAll();" class="btn-icon btn-navy btn-print"><span></span>Print</button>
                                                </td>
                                                
                                            </tr>
                                        </table>
                                        <asp:HiddenField ID="hfRoleId" runat="server" />
                                  </td>
                                </tr>
                            </table>
                            <div class="birth_wrapper " id="divBdayList" runat="server">
                                <div id="divWrapper" runat="server">
                                    <div id="headWrapper" runat="server">
                                        <div class="txt-heading">
                                            Today's Birthday Celebrities -
                                            <asp:Label ID="lblDate" runat="server"></asp:Label></div>
                                    </div>
                                    <div class="clear">
                                    </div>
                                    <asp:UpdatePanel ID="uppnlChangeCity" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="birthday_phto-block">
                                                <asp:Repeater ID="rptBooks" runat="server">
                                                    <ItemTemplate>
                                                        <div class="birthday_phto-list">
                                                            <div class="birthday_photo">
                                                                <img src="<%#DataBinder.Eval(Container.DataItem, "PhotoFile") %>" width="146"
                                                                    height="147" alt="Profile-Photo" /></div>
                                                            <div class="birthday_photo-name">
                                                                <%#DataBinder.Eval(Container.DataItem, "NAME")%>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                                <div class="clear">
                                                </div>
                                                <div class="" style="height: 50px; width: 900px;">
                                                </div>
                                            </div>
                                            <div style="overflow: hidden;" class="pagingClass">
                                                <asp:Repeater ID="rptPaging" runat="server" OnItemCommand="rptPaging_ItemCommand">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnPage" Style="" CssClass="pagingnum" CommandName="Page" CommandArgument="<%# Container.DataItem %>"
                                                            runat="server" ForeColor="White" Font-Bold="True"><%# Container.DataItem %>
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="rptPaging" EventName="ItemCommand" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                    <div class="clear">
                                    </div>
                              </div>
                          </div>
                            <div class="printAllDiv" style="display: none;">
                                <%--<div id="printDivBdayList" class="birth_wrapper printDivBdayList">
                                    <div class="birth_wrap3">
                                        <div class="birthday_heading3">
                                            <div class="txt-heading">
                                                Today Birthday Celebrities -
                                                <asp:Label ID="lblPrintDate" runat="server"></asp:Label></div>
                                        </div>
                                        <div class="clear">
                                        </div>
                                        <div id="ctl00_ContentPlaceHolder1_uppnlChangeCity">
                                            <div class="birthday_phto-block">
                                                <div class="appendList">
                                                </div>
                                                <div class="birthday_phto-list">
                                                <div class="birthday_photo">
                                                    <img src="../Staffs/Uploads/ProfilePhotos/noimage.jpg" width="146" height="147"></div>
                                                <div class="birthday_photo-name">
                                                    SANTOSH.A
                                                </div>
                                            </div>
                                                <div class="clear">
                                                </div>
                                                <div class="" style="height: 50px; width: 900px;">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="clear">
                                        </div>
                                    </div>--%>
                            </div>
                      </div>
                    </div>
                </div>
            </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnGenerate" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
