<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="StudentCertificateEntry.aspx.cs" Inherits="Students_StudentCertificateEntry" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%--Save Personal Details--%>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtDate]");
        });
        $(function () {
            if ($("[id*=hdnSCID]").val() == "") {
                GetSerialNo();
            }

        });
        function GetSerialNo() {
            $.ajax({
                type: "POST",
                url: "../Students/StudentCertificateEntry.aspx/GetSerialNo",
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
            var ddlFor = $("#ctl00_ContentPlaceHolder1_ddlFor option:selected").text();
            var comptype;
            if ($("[id*=rbtntype1]").is(':checked')) {
                comptype = "Inter School";
            }

            else if ($("[id*=rbtntype2]").is(':checked')) {
                comptype = "Intra School";
            }

            var complevel;
            if ($("[id*=rbtnLevel1]").is(':checked')) {
                complevel = "National";
            }

            else if ($("[id*=rbtnLevel2]").is(':checked')) {
                complevel = "State";
            }

            else if ($("[id*=rbtnLevel3]").is(':checked')) {
                complevel = "Zonal";
            }

            else if ($("[id*=rbtnLevel4]").is(':checked')) {
                complevel = "School";
            }



            var Print;
            if ($("[id*=rbtnPrintYes]").is(':checked')) {
                Print = "1";
            }

            else if ($("[id*=rbtnPrintNo]").is(':checked')) {
                Print = "0";
            }
            var compdate = $("[id*=txtDate]").val();



            if ($('#aspnetForm').valid()) {
                var parameters = '{"slNo": "' + $("[id*=lblSLNo]").html() + '","RegNo": "' + $("[id*=hdnRegNo]").val() + '","AcademicId": "' + $("[id*=hfAcademicYear]").val() + '","title": "' + $("[id*=txtTitle]").val() + '","comptype": "' + comptype + '","complevel": "' + complevel + '","compfor": "' + ddlFor + '","compdate": "' + compdate + '","awardtype": "' + $("[id*=txtawardtype]").val() + '","Conductby": "' + $("[id*=txtConductedby]").val() + '","remarks": "' + $("[id*=txtremarks]").val() + '","eventname": "' + $("[id*=txtEvent]").val() + '","result": "' + $("[id*=ddlresult]").val() + '","isprint": "' + Print + '","UserId": "' + $("[id*=hfuserid]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentCertificateEntry.aspx/Save",
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
                AlertMessage('success', 'Certificate Generated');
                GetModuleID('Students/StudentCertificateSearch.aspx');
            }
        }

        function GetModuleID(path) {
            $.ajax({
                type: "POST",
                url: "../Students/StudentCertificateEntry.aspx/GetModuleId",
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
                var url = "../Students/StudentCertificateSearch.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "";
                $(location).attr('href', url)
            });
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head2">
    <style type="text/css">
        .style1
        {
            font-weight: bold;
        }
    </style>
</asp:Content>
<asp:Content ID="mainContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:HiddenField ID="hdnRegNo" runat="server" />
    <asp:HiddenField ID="hdnSCID" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                STUDENT CERTIFICATE</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" runat="server">
                                <table class="form">
                                    <tr>
                                        <td align="center">
                                            <h1>
                                                Student Certificate Entry</h1>
                                        </td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" cellspacing="20" cellpadding="20" class="form">
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" class="form">
                                                <tr>
                                                    <td class="col1" colspan="3" align="center" style="text-align: left">
                                                        <label>
                                                            Certificate Sl. No :
                                                        </label>
                                                        <asp:Label ID="lblSLNo" runat="server" Style="text-align: left; font-weight: 700;"></asp:Label>
                                                        &nbsp;&nbsp;
                                                        <label style="text-align: left">
                                                            Name :
                                                        </label>
                                                        <asp:Label ID="lblName" runat="server" CssClass="style1"></asp:Label>
                                                    </td>
                                                    <td class="col1" align="center" style="text-align: left">
                                                        <label>
                                                            Academic Year:
                                                        </label>
                                                        <asp:Label ID="lblAcdYear" runat="server" CssClass="style1"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        <label>
                                                            1. Title of Certificate
                                                        </label>
                                                    </td>
                                                    <td width="4%" colspan="2">
                                                        :
                                                    </td>
                                                    <td width="48%">
                                                        <span>
                                                            <asp:TextBox ID="txtTitle" CssClass="jsrequired" runat="server" Width="400px"></asp:TextBox></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        <label>
                                                            2. Competition Type
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td style="text-align: left">
                                                        <asp:RadioButton ID="rbtntype1" GroupName="Type" Checked="true" runat="server" Text="Inter School" />
                                                        <asp:RadioButton ID="rbtntype2" GroupName="Type" runat="server" Text="Intra School" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        <label>
                                                            3. competition Level
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td style="text-align: left">
                                                        <asp:RadioButton ID="rbtnLevel1" GroupName="Level" Checked="true" runat="server"
                                                            Text="National " />
                                                        <asp:RadioButton ID="rbtnLevel2" GroupName="Level" runat="server" Text="State" />
                                                        <asp:RadioButton ID="rbtnLevel3" GroupName="Level" runat="server" Text="Zonal" />
                                                        <asp:RadioButton ID="rbtnLevel4" GroupName="Level" runat="server" Text="School" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        <label>
                                                            4. Certification for
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td style="text-align: left">
                                                        <asp:DropDownList ID="ddlFor" AppendDataBoundItems="true" CssClass="jsrequired" runat="server">
                                                            <asp:ListItem Selected="True" Value="">Select</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        <label>
                                                            5. Conducted By
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtConductedby" runat="server" CssClass="jsrequired" Width="400px"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        <label>
                                                            6. Award Type / Stage of Award Received
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtawardtype" runat="server" CssClass="jsrequired" Width="400px"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        <label>
                                                            7. Remarks
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtremarks" CssClass="jsrequired" runat="server" Width="400px"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        <label>
                                                            8. Certification Print
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td style="text-align: left">
                                                        <asp:RadioButton ID="rbtnPrintYes" GroupName="Print" runat="server" Text="Yes" />
                                                        &nbsp;
                                                        <asp:RadioButton ID="rbtnPrintNo" GroupName="Print" runat="server" Text="No" Checked="True" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        9<label>. Competition Date
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td style="text-align: left">
                                                        <asp:TextBox ID="txtDate" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        10<label>. Name of the event
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td style="text-align: left">
                                                        <asp:TextBox ID="txtEvent" CssClass="jsrequired" runat="server"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1" align="left">
                                                        10<label>. Position
                                                        </label>
                                                    </td>
                                                    <td colspan="2">
                                                        :
                                                    </td>
                                                    <td style="text-align: left">
                                                      <asp:DropDownList ID="ddlresult" CssClass="jsrequired" runat="server">
                                                            <asp:ListItem Selected="True" Value="">Select</asp:ListItem>
                                                            <asp:ListItem Value="Pariticpant">Pariticpant</asp:ListItem>
                                                            <asp:ListItem Value="Winner">Winner</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" valign="top" align="center">
                                                        <button id="btnSave" type="button" class="btn-icon btn-orange btn-saving" onclick="Save();">
                                                            <span></span>Save</button>
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
        </div>
    </div>
</asp:Content>
