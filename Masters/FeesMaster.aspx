<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="FeesMaster.aspx.cs" Inherits="FeesMaster" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript" language="javascript">

        function GetId() {
            $("[id*=hfSchoolTypeID]").val($("[id*=ddlSchoolType]").val());
            $("[id*=hfClassID]").val($("[id*=ddlClass]").val());
            $("[id*=hfFeesCategoryID]").val($('input[name="ctl00$ContentPlaceHolder1$rbtnFeesCategory"]:checked').val());
        }
    </script>
    <script type="text/javascript">
        $(function () {
            //        GetMenu Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
            GetFeesCatHead(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetFeesCatHead(parseInt($(this).attr('page')));
        });


        //        GetFeesCatHeads Function

        function GetFeesCatHead(pageIndex) {
            var AcademicId = $("[id*=hfAcademicYear]").val();
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/FeesMaster.aspx/GetFeesCatHead",
                    data: '{pageIndex: ' + pageIndex + ',AcademicId:' + AcademicId + '}',
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
            var FeeCatHeades = xml.find("FeeCatHeads");
            var row = $("[id*=dgFeesCategoryHead] tr:last-child").clone(true);
            $("[id*=dgFeesCategoryHead] tr").not($("[id*=dgFeesCategoryHead] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditFeesCatHead('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteFeesCatHead('";
                danchorEnd = "');\">Delete</a>";
            }
            if (FeeCatHeades.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("").removeClass("editacc edit-links");
                $("td", row).eq(8).html("").removeClass("deleteacc delete-links");
                $("[id*=dgFeesCategoryHead]").append(row);
                row = $("[id*=dgFeesCategoryHead] tr:last-child").clone(true);

            }
            else {
                $.each(FeeCatHeades, function () {
                    var iFeeCatHead = $(this);
                  
                    var ehref = eanchor + $(this).find("FeesCatHeadID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("FeesCatHeadID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("SchoolTypeName").text()).attr("colspan", "1").attr("align", "left");
                    $("td", row).eq(0).html($(this).find("SchoolTypeName").text());
                    $("td", row).eq(1).html($(this).find("ClassName").text());
                    $("td", row).eq(2).html($(this).find("FeesCategoryName").text());
                    $("td", row).eq(3).html($(this).find("FeesHeadName").text());
                    $("td", row).eq(4).html($(this).find("AcademicYear").text());
                    $("td", row).eq(5).html($(this).find("ForMonth").text());
                    $("td", row).eq(6).html($(this).find("Amount").text());
                    $("td", row).eq(7).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(8).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgFeesCategoryHead]").append(row);
                    row = $("[id*=dgFeesCategoryHead] tr:last-child").clone(true);
                });
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    $('.editacc').hide();
                }
                else {
                    $('.editacc').show();
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
        // Delete FeeCatHead
        function DeleteFeesCatHead(id) {
            var parameters = '{"FeesCatHeadID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                $.ajax({

                    type: "POST",
                    url: "../Masters/FeesMaster.aspx/DeleteFeesCatHead",
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

        function GetClassBySchoolType(ID) {
            if (ID) {
                $.ajax({
                    type: "POST",
                    url: "../Masters/FeesMaster.aspx/GetClassBySchoolTypeID",
                    data: '{SchoolTypeID: ' + ID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnGetSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("ClassBySchoolType");
            var select = $("[id*=ddlClass]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var ClassID = $(this).find("ClassID").text();
                var Class = $(this).find("ClassName").text();
                select.append($("<option>").val(ClassID).text(Class));

            });
        };


        function GetFeesTypeByClass(ID) {
            if (ID) {
                $.ajax({
                    type: "POST",
                    url: "../Masters/FeesMaster.aspx/GetFeesTypeByClass",
                    data: '{ClassID: ' + ID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetFeesTypeSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnGetFeesTypeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("FeesTypeByClass");
            $.each(cls, function () {
                var icls = $(this);
                var FeesType = $(this).find("FeesType").text();
                $("[id*=ddlFeesType] option[value='" + FeesType + "']").attr("selected", true);
            });
        };

        //        Edit Function

        function EditFeesCatHead(FeesCatHeadID) {
         if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Masters/FeesMaster.aspx/EditFeesCatHead",
                data: '{FeesCatHeadID: ' + FeesCatHeadID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnEditSuccess,
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

        //        Edit On Success Function

        function OnEditSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var FeeCatHeades = xml.find("EditFeesCatHead");
            $.each(FeeCatHeades, function () {

                var iFeeCatHead = $(this);


                var SchoolTypeID = $(this).find("SchoolTypeID").text();
                $("[id*=ddlSchoolType] option[value='" + SchoolTypeID + "']").attr("selected", "true");

                var ClassID = $(this).find("ClassID").text();
                $("[id*=ddlClass] option[value='" + ClassID + "']").attr("selected", "true");

                GetFeesTypeByClass(ClassID);

                var FeesCategoryID = $(this).find("FeesCategoryID").text();

                for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnFeesCategory']")).length; i++) {
                    $("#ctl00_ContentPlaceHolder1_rbtnFeesCategory_" + i).attr("checked", false);
                }

                for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnFeesCategory']")).length; i++) {
                    if (FeesCategoryID == $("#ctl00_ContentPlaceHolder1_rbtnFeesCategory_" + i).val()) {
                        $("#ctl00_ContentPlaceHolder1_rbtnFeesCategory_" + i).attr("checked", true);
                    }

                }
                var FeesCatHeadID = $(this).find("FeesCatHeadID").text();
                $("[id*=hfFeesCatHeadID]").val(FeesCatHeadID);

                var FeesHeadID = $(this).find("FeesHeadID").text();
                $("[id*=hfFeesHeadID]").val(FeesHeadID);
                EditFeesStructure();
            });
        };


        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                  AlertMessage('success', 'Deleted');
                GetFeesCatHead(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
                Cancel();
            }
            else {
                AlertMessage('reference', response.d);
                Cancel();
            }
        };

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetFeesCatHead(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=ddlSchoolType]").val("");
            $("[id*=ddlFeesType]").val("");
            $("[id*=ddlClass]").val("");
            $("[id*=hfFeesCatHeadID]").val("");
            $("[id*=hfSchoolTypeID]").val("");
            $("[id*=hfClassID]").val("");
            $("[id*=hfFeesHeadID]").val("");
            $('#aspnetForm').validate().resetForm();
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Fees Master
            </h2>
            <div class="block content-wrapper2">
                <div class="frm-block">
                    <table align="center" class="form" style="margin-bottom: 0px;">
                        <tr>
                            <td class="col1">
                                <label>
                                    School Category Name :</label>
                            </td>
                            <td class="col2">
                                <asp:DropDownList ID="ddlSchoolType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                    onchange="GetClassBySchoolType(this.value)">
                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="col1">
                                <label>
                                    Class Name :</label>
                            </td>
                            <td class="col2">
                                <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" 
                                    onchange="GetFeesTypeByClass(this.value)">
                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Fees Type:</label>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlFeesType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                    <asp:ListItem Selected="false" Value="Term">Term</asp:ListItem>
                                    <asp:ListItem Selected="false" Value="Monthly">Monthly</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <label>
                                    Fees Category Type Name:
                                </label>
                            </td>
                            <td>
                                <span class="col2">
                                    <asp:RadioButtonList ID="rbtnFeesCategory" runat="server" onchange="javascript:GetId();"
                                        RepeatDirection="Horizontal" RepeatLayout="Flow">
                                    </asp:RadioButtonList>
                                </span>
                            </td>
                        </tr>
                        <br />
                        <tr>
                            <td colspan="4">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <%--<tr>
                                        <td>
                                            <label>
                                                Head Name:
                                            </label>
                                        </td>
                                    </tr>--%>
                                    <%--<tr>
                                        <td>
                                            <asp:CheckBoxList ID="chkFeesHead" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                                RepeatColumns="5">
                                            </asp:CheckBoxList>
                                        </td>
                                    </tr>--%>
                                    <tr align="center">
                                        <td align="center">
                                            <a id="lnk" style="height: 29px; line-height: 31px" onclick="javascript:return generate();"
                                                class="btn-icon btn-navy btn-generate"><span></span>Generate</a>&nbsp; <a style="height: 29px; line-height: 31px"
                                                    onclick="return Cancel();" class="btn-icon btn-navy btn-cancel1"><span></span>Cancel</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <input type="hidden" id="hfFeesCategoryID" />
                                            <input type="hidden" id="hfSchoolTypeID" />
                                            <input type="hidden" id="hfClassID" />
                                            <input type="hidden" id="hfFeesCatHeadID" />
                                            <input type="hidden" id="hfFeesHeadID" />
                                            <input type="hidden" id="hfAcademicYear" runat="server" />
                                            
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            
            <div class="block ">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top" colspan="2">
                            <asp:GridView ID="dgFeesCategoryHead" runat="server" Width="100%" AutoGenerateColumns="false"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="SchoolTypeName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="School Type" SortExpression="SchoolTypeName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ClassName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Class" SortExpression="ClassName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FeesCategoryName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Fees Category Name" SortExpression="FeesCategoryName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FeesHeadName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Fees Head Name" SortExpression="FeesHeadName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AcademicYear" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Academic Year" SortExpression="AcademicYear">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ForMonth" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="For Month" SortExpression="ForMonth">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Amount" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Amount" SortExpression="Amount">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("FeesCatHeadID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("FeesCatHeadID") %>'
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
                        </td>
                    </tr>
                </table>
            </div>
            <div class="clear">
            </div>
            </div>
        </div>
    </div>
    <script src="../prettyphoto/js/prettyPhoto.js" type="text/javascript"></script>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("a[rel^='prettyPhoto']").prettyPhoto();
        });
    </script>
    <script type="text/javascript">

        function generate() {
            if ($('#aspnetForm').valid()) {
                if ($('input[type=radio][name=ctl00$ContentPlaceHolder1$rbtnFeesCategory]:checked').length == 0) {
                    alert("select fees Category");
                    return false;
                } else {
                    var hfschooltypeid = $("[id*=ddlSchoolType]").val();
                    var hfclassid = $("[id*=ddlClass]").val();
                    var hffeesid = $('input[name="ctl00$ContentPlaceHolder1$rbtnFeesCategory"]:checked').val();
                    var hffeescatheadid = $("[id*=hfFeesCatHeadID]").val();
                    hffeescatheadid = "";
                    var hffeesheadid = $("[id*=hfFeesHeadID]").val();
                    hffeesheadid = "";
                    var add = $("[id*=hfAddPrm]").val();
                    var edit = $("[id*=hfEditPrm]").val();
                    $.prettyPhoto.open('GenerateFees.aspx?AddFrm=' + add + '&EditFrm=' + edit + '&FeesHeadID=' + hffeesheadid + '&FeesCatHeadID=' + hffeescatheadid + '&SchoolTypeID=' + hfschooltypeid + '&FeesCategoryID=' + hffeesid + '&ClassID=' + hfclassid + '&iframe=true&width=800&height=600', '', '');
                    return false;
                }
            }

        }
        function EditFeesStructure() {

            var hfschooltypeid = $("[id*=ddlSchoolType]").val();
            var hfclassid = $("[id*=ddlClass]").val();
            var hffeesid = $('input[name="ctl00$ContentPlaceHolder1$rbtnFeesCategory"]:checked').val();
            var hffeescatheadid = $("[id*=hfFeesCatHeadID]").val();
            var hffeesheadid = $("[id*=hfFeesHeadID]").val();
            var add = $("[id*=hfAddPrm]").val();
            var edit = $("[id*=hfEditPrm]").val();
            $.prettyPhoto.open('GenerateFees.aspx?AddFrm=' + add + '&EditFrm=' + edit + '&FeesHeadID=' + hffeesheadid + '&FeesCatHeadID=' + hffeescatheadid + '&SchoolTypeID=' + hfschooltypeid + '&FeesCategoryID=' + hffeesid + '&ClassID=' + hfclassid + '&iframe=true&width=800&height=600', '', '');
            return false;
            GetFeesCatHead(1);
        }
        function Rebind() {
            GetFeesCatHead(1);
            window.$.prettyPhoto.close();
            Cancel();
        }
    </script>
</asp:Content>
