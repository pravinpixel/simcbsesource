<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="PromotionSearch.aspx.cs" Inherits="Promotions_PromotionSearch" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <script type="text/javascript">

        $(function () {
            //        GetPromotionInfos Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetPromotionInfo(1);
            GetModuleID('Performance/GeneratePromotion.aspx');
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });

        var Academic = "";
        function GetPromotionInfo(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                var Class = $("[id*=ddlClass]").val();
                var Section = $("[id*=ddlSection]").val();

                var parameters = '{pageIndex: ' + pageIndex + ',"Class": "' + Class + '","Section": "' + Section + '"}';

                $.ajax({
                    type: "POST",
                    url: "../Performance/PromotionSearch.aspx/GetPromotionInfo",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                return false;
            }
        }


        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var PromotionInfoes = xml.find("PromotionInfo");

            var row = $("[id*=dgPromotionInfo] tr:last-child").clone(true);
            $("[id*=dgPromotionInfo] tr").not($("[id*=dgPromotionInfo] tr:first-child")).remove();
            var vanchor = ''
            var vanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfViewPrm]").val() == 'false') {
                vanchor = "<a>";
                vanchorEnd = "</a>";
            }
            else {
                vanchor = "<a href=\"javascript:ViewPromotionInfo('";
                vanchorEnd = "');\">Apply Promotion</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeletePromotionInfo('";
                danchorEnd = "');\">Delete</a>";
            }

            if (PromotionInfoes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Record Found").attr("align", "left");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("").removeClass("viewacc view-links"); ;
                $("td", row).eq(4).html("").removeClass("deleteacc delete-links"); ;
                $("[id*=dgPromotionInfo]").append(row);
                row = $("[id*=dgPromotionInfo] tr:last-child").clone(true);

                var pager = xml.find("Pager");
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(1),
                    PageSize: parseInt(1),
                    RecordCount: parseInt(0)
                });
            }
            else {

                $.each(PromotionInfoes, function () {
                    var iPromotionInfo = $(this);
                    var vhref = vanchor + $(this).find("PromotionID").text() + vanchorEnd;
                    var dhref = danchor + $(this).find("PromotionID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("ClassName").text());
                    $("td", row).eq(2).html($(this).find("SectionName").text());
                    if ($(this).find("PromotionStatus").text() == "true") {
                        $("td", row).eq(3).html('Promotion Applied');
                        $("td", row).eq(4).html('Delete not applicable');
                    }
                    else {
                        $("td", row).eq(3).html(vhref).addClass("viewacc view-links");
                        $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    }

                    $("[id*=dgPromotionInfo]").append(row);
                    row = $("[id*=dgPromotionInfo] tr:last-child").clone(true);
                });

                if ($("[id*=hfViewPrm]").val() == 'false') {
                    $('.viewacc').hide();
                }
                else {
                    $('.viewacc').show();
                }
                if ($("[id*=hfDeletePrm]").val() == 'false') {
                    $('.deleteacc').hide();
                }
                else {
                    $('.deleteacc').show();
                }
                var pager = xml.find("Pager");
                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }
        };
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


        // Delete PromotionInfo
        function DeletePromotionInfo(PromotionInfoID) {
            var tmp = PromotionInfoID.split('-');
            var Class = tmp[0].toString();
            var Section = tmp[1].toString();
            var parameters = '{"PromotionID": "' + PromotionInfoID + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Performance/PromotionSearch.aspx/DeletePromotionInfo",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteSuccess,
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

        //        Edit Function

        function ViewPromotionInfo(PromotionInfoID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                var tmp = PromotionInfoID.split('-');
                var Class = tmp[0].toString();
                var Section = tmp[1].toString();
                var parameters = '{"PromotionID": "' + PromotionInfoID + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Performance/PromotionSearch.aspx/ViewPromotionInfo",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var url = "../Performance/GeneratePromotion.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&ClassID=" + Class + "&SectionID=" + Section + "";
                        $(location).attr('href', url)
                    },
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
        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetPromotionInfo(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
                Cancel();
            }
        };

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetPromotionInfo(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
    <script type="text/javascript">

        function Cancel() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            GetPromotionInfo(1);
        };
      
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Promotion Search
            </h2>
            <div class="block john-accord content-wrapper2">
                <div class="block1" align="center">
                    <table width="100%" class="form" align="center">
                        <tr>
                            <td>
                                <table border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="justify" width="10%">
                                            <strong class="searchby">Search By&nbsp;</strong>
                                        </td>
                                        <td width="10%" align="right">
                                            <strong class="searchby">&nbsp;</strong><label>Class :</label>
                                        </td>
                                        <td width="20%" align="right">
                                            <asp:DropDownList ID="ddlClass" CssClass="" runat="server" AppendDataBoundItems="True"
                                                onchange="GetSectionByClass(this.value);">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="10%" align="right">
                                            <label>
                                                Section :</label>
                                        </td>
                                        <td width="20%" align="right">
                                            <asp:DropDownList ID="ddlSection" CssClass="" runat="server" AppendDataBoundItems="True"
                                                onchange="GetPromotionBySection();">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="20%" align="right">
                                            <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetPromotionInfo(1);">
                                                <span></span>Search</button>
                                            &nbsp;
                                            <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                onclick="return Cancel();">
                                                <span></span>Cancel</button>
                                            &nbsp;
                                            <button id="btnAddNew" type="button" class="btn-icon btn-navy btn-add" style="display: none;"
                                                onclick="AddPromotionInfo();">
                                                <span></span>Add New</button>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="dgPromotionInfo" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Sl.No." SortExpression="SlNo">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Class" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Class" SortExpression="Class">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Section" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Section" SortExpression="Section">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Option</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkView" runat="server" Text="Option" CommandArgument='<%# Eval("PromotionID") %>'
                                                CommandName="View" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("PromotionID")%>'
                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="Pager">
                            </div>
                            <asp:HiddenField ID="hfModuleID" runat="server" />
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
