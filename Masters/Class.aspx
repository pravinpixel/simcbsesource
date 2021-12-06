<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Class.aspx.cs" Inherits="Class" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">

        $(function () {
            //        GetClasss Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetClass(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetClasss Function

        function GetClass(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Class.aspx/GetClass",
                    data: '{pageIndex: ' + pageIndex + '}',
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
            var classes = xml.find("Class");
            var row = $("[id*=dgClass] tr:last-child").clone(true);
            $("[id*=dgClass] tr").not($("[id*=dgClass] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditClass('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteClass('";
                danchorEnd = "');\">Delete</a>";
            }
            if (classes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("").removeClass("editacc edit-links");
                $("td", row).eq(5).html("").removeClass("deleteacc delete-links");
                $("[id*=dgClass]").append(row);
                row = $("[id*=dgClass] tr:last-child").clone(true);

            }
            else {

                $.each(classes, function () {
                    var iclass = $(this);
                    var ehref = eanchor + $(this).find("ClassID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("ClassID").text() + danchorEnd;


                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("SchoolTypeName").text());
                    $("td", row).eq(1).html($(this).find("ClassName").text());
                    $("td", row).eq(2).html($(this).find("NoofStudents").text());
                    $("td", row).eq(3).html($(this).find("FeesType").text());
                    $("td", row).eq(4).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(5).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgClass]").append(row);
                    row = $("[id*=dgClass] tr:last-child").clone(true);
                });
            }
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
        };
        // Delete Class
        function DeleteClass(id) {
            var parameters = '{"ClassID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Class.aspx/DeleteClass",
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

        function EditClass(ClassID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/Class.aspx/EditClass",
                    data: '{ClassID: ' + ClassID + '}',
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
            var classes = xml.find("EditClass");
            $.each(classes, function () {

                var iclass = $(this);
                $("[id*=txtClassName]").val($(this).find("ClassName").text());
                $("[id*=txtClassWords]").val($(this).find("ClassInWords").text());
                $("[id*=txtNoofStudents]").val($(this).find("NoofStudents").text());
                var FeesType = $(this).find("FeesType").text();
                if (FeesType == "Monthly") {
                    $("#rbtnMonthwise").attr("checked", "true");
                }
                else if (FeesType == "Term") {
                    $("#rbtnTermwise").attr("checked", "true");
                }

                var SchoolTypeID = $(this).find("SchoolTypeID").text();

                $("[id*=ddlSchoolType] option[value='" + SchoolTypeID + "']").attr("selected", "true");

                $("[id*=hfClassID]").val($(this).find("ClassID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save Class
        function SaveClass() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfClassID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfClassID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var ClassID = $("[id*=hfClassID]").val();
                    var ClassName = $("[id*=txtClassName]").val();
                    var ClassWords = $("[id*=txtClassWords]").val();
                    var NoofStudents = $("[id*=txtNoofStudents]").val();
                    var SchoolTypeID = $("[id*=ddlSchoolType]").val();

                    var iFeesType;
                    if ($("[id*=rbtnTermwise]").is(':checked')) {
                        iFeesType = "Term";
                    }

                    else if ($("[id*=rbtnMonthwise]").is(':checked')) {
                        iFeesType = "Monthly";
                    }
                    var parameters = '{"id": "' + ClassID + '","classname": "' + ClassName + '","noofstudents": "' + NoofStudents + '","feestype": "' + iFeesType + '","schooltypeid": "' + SchoolTypeID + '","classwords":"' + ClassWords + '"}';
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Class.aspx/SaveClass",
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
            else {
                return false;
            }
        }

        // Save On Success
        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                GetClass(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetClass(1);
                Cancel();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                Cancel();
            }
            else {
                AlertMessage('fail', response.d);
                Cancel();
            }
        };


        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetClass(parseInt(currentPage));
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
            GetClass(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtClassName]").val("");
            $("[id*=txtClassWords]").val("");
            $("[id*=txtNoofStudents]").val("");
            $("[id*=ddlSchoolType]").val("");
            $("[id*=hfClassID]").val("");
            $("[id*=btnSubmit]").attr("disabled", "false");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
        function btnSubmit_onclick() {

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Class
            </h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 650px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                School Category Type</label>
                                        </td>
                                        <td class="col2">
                                            <asp:DropDownList ID="ddlSchoolType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td rowspan="3">
                                            <div class="Class">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Class</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtClassName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Class In Words
                                            </label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtClassWords" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                No of Students
                                            </label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtNoofStudents" CssClass="jsrequired numbersonly" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Fees Type</label>
                                        </td>
                                        <td class="col2">
                                            <label>
                                                <input type="radio" name="rb1" id="rbtnTermwise" value="Term" checked="checked" />Term-wise</label>
                                            <label>
                                                <input type="radio" name="rb1" id="rbtnMonthwise" value="Month" />Month-wise</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            &nbsp;
                                            <asp:HiddenField ID="hfClassID" runat="server" />
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveClass();">
                                                <span></span><div  id="spSubmit">Save</div></button>
                                            <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                onclick="return Cancel();">
                                                <span></span>Cancel</button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td>&nbsp;
                            
                        </td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2" valign="top">
                            <asp:GridView ID="dgClass" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="SchoolTypeName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="School Type Name" SortExpression="SchoolTypeName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ClassName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Class" SortExpression="ClassName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NoofStudents" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="No of Students" SortExpression="NoofStudents">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FeesType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Fees Type" SortExpression="FeesType">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("ClassID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("ClassID") %>'
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
</asp:Content>
