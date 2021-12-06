<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="GeneratePromotion.aspx.cs" Inherits="Performance_GeneratePromotion" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/performance-print.css") + "' rel='stylesheet' type='text/css'  media='print' />"%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function GetModuleID(path) {
            $.ajax({
                type: "POST",
                url: "../Performance/PromotionSearch.aspx/GetModuleId",
                data: '{"path": "' + path + '"}',
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
            var cls = xml.find("ModuleMenusByPath");
            $.each(cls, function () {
                $("[id*=hfModuleID]").val($(this).find("modulemenuid").text());
                $("[id*=hdnMenuIndex]").val($(this).find("menuid").text())
            });
        }
        GetModuleID('Performance/PromotionSearch.aspx');

        function ApplyPromotion() {
            if (jConfirm('Are you confirm to promote these students to the selected class & section?', 'Confirm', function (r) {
                if (r) {
                    var ClassID = $("[id*=hfClassID]").val();
                    var SectionID = $("[id*=hfSectionID]").val();
                    var NxtClassID = $("[id*=ddlClass]").val();
                    var NxtSectionID = $("[id*=ddlSection]").val();
                    if (ClassID != "" && SectionID != "") {

                        $(".even").each(function () {
                            var regno = $(this).find('td.regno').html();
                            var status = $(this).find("option:selected").text();

                            var parameters = '{"NxtClassID": "' + NxtClassID + '","NxtSectionID": "' + NxtSectionID + '","ClassID": "' + ClassID + '","SectionID": "' + SectionID + '","RegNo": "' + regno + '","Status": "' + status + '"}';
                            $.ajax({
                                type: "POST",
                                url: "../Performance/GeneratePromotion.aspx/UpdatePromotion",
                                data: parameters,
                                contentType: "application/json; charset=utf-8",
                                beforeSend: loadingfun,
                                dataType: "json",
                                failure: function (response) {
                                    AlertMessage('info', response.d);
                                },
                                error: function (response) {
                                    AlertMessage('info', response.d);
                                }
                            });
                        });
                    }
                    alertwindow();
                }

            })) {
            }

        }



        function alertwindow() {
            AlertMessage('success', 'Updated');
            $("#loading").html('');
            $(".IDprint").html('');
        }
        function loadingfun() {

            var str = '<div style="background: url(../img/overly.png) repeat; width: 100%;  height: 100%; position: fixed;text-align:center; top: 0; left: 0; z-index: 10000;">';
            str += '<center><img src="../img/loading.gif"/></center>';
            str += '</div>';
            $("#loading").html(str);

        }
        function GetSectionByClass(ID) {
            $.ajax({
                type: "POST",
                url: "../Performance/PromotionSearch.aspx/GetSectionByClassID",
                data: '{ClassID: ' + ID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetSectionByClassSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetSectionByClassSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("SectionByClass");
            var select = $("[id*=ddlSection]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));


            });
        };



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
    <style type="text/css">
        .modal
        {
            position: fixed;
            top: 0;
            left: 0;
            background-color: black;
            z-index: 99;
            opacity: 0.8;
            filter: alpha(opacity=80);
            -moz-opacity: 0.8;
            min-height: 100%;
            width: 100%;
        }
        .loading
        {
            font-family: Arial;
            font-size: 10pt;
            border: 5px solid #67CFF5;
            width: 200px;
            height: 100px;
            display: none;
            position: fixed;
            background-color: White;
            z-index: 999;
        }
    </style>
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div id="loading">
    </div>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Promotion List</h2>
            <div class="clear">
            </div>
            <div align="center" class="block john-accord content-wrapper2">
                <table width="100%" class="form">
                    <asp:HiddenField ID="hfModuleID" runat="server" />
                    <tr>
                        <td>
                            <div class="IDprint">
                                <div id="dvCard" style="overflow: auto; width: 100%" runat="server">
                                </div>
                                <asp:PlaceHolder ID="promocontent" runat="server"></asp:PlaceHolder>
                                <asp:HiddenField ID="hfClassID" runat="server" />
                                <asp:HiddenField ID="hfAcademicID" runat="server" />
                                <asp:HiddenField ID="hfSectionID" runat="server" />
                            </div>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <pre style="border: thin solid #FF0000; background-color: #FFFFCC; font-family: Verdana;
                                font-weight: bold; font-size: 12px;"> For your Verification &amp; Confirmation before proceeding Promotion...
 1. Please check the promotion list once again before proceeding to promotion.
 2. Once the promotion applied for the students in the selected class and section, can&#39;t be roll back.
 3. Once the promotion applied for the students in the selected class and section, can&#39;t be viewed in any other reports until the change of academic year.</pre>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <label>
                                Select the class to Promote</label>&nbsp;
                            <asp:DropDownList ID="ddlClass" CssClass="jsrequired" AppendDataBoundItems="True"
                                onchange="GetSectionByClass(this.value);" runat="server">
                            </asp:DropDownList>
                            &nbsp; &nbsp;
                            <label>
                                Select the section to Promote</label>&nbsp;
                            <asp:DropDownList ID="ddlSection" CssClass="jsrequired" runat="server">
                                <asp:ListItem Selected="True" Value="">Select</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;
                            <button id="btnSubmit" type="button" runat="server" class="btn-generate-list button-generatelist"
                                onclick="ApplyPromotion();">
                                <span></span>
                                <div id="spSubmit">
                                    Apply Promotion</div>
                            </button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
