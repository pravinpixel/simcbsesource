<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="SchoolType.aspx.cs" Inherits="SchoolType" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript">

        $(function () {
            //        GetSchoolType Function on page load
          
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetSchoolType(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        //        GetSchoolType Function

        function GetSchoolType(pageIndex) {
         if ($("[id*=hfViewPrm]").val() == 'true') {
            $.ajax({
                type: "POST",
                url: "../Masters/SchoolType.aspx/GetSchoolType",
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

        //        GetSchoolType On Success Function
        //        Get SchoolType to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var schooltypes = xml.find("SchoolTypes");
            var row = $("[id*=dgSchoolType] tr:last-child").clone(true);
            $("[id*=dgSchoolType] tr").not($("[id*=dgSchoolType] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditSchoolType('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteSchoolType('";
                danchorEnd = "');\">Delete</a>";
            }
            if (schooltypes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("").removeClass("editacc edit-links");
                $("td", row).eq(3).html("").removeClass("deleteacc delete-links");
                $("[id*=dgSchoolType]").append(row);
                row = $("[id*=dgSchoolType] tr:last-child").clone(true);

            }
            else {
                $.each(schooltypes, function () {
                    var schooltype = $(this);
                    var ehref = eanchor + $(this).find("SchoolTypeID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("SchoolTypeID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("SchoolTypeName").text());
                    $("td", row).eq(1).html($(this).find("Description").text());
                    $("td", row).eq(2).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(3).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgSchoolType]").append(row);
                    row = $("[id*=dgSchoolType] tr:last-child").clone(true);
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
        // Delete SchoolType
        function DeleteSchoolType(id) {
            var parameters = '{"SchoolTypeID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                $.ajax({

                    type: "POST",
                    url: "../Masters/SchoolType.aspx/DeleteSchoolType",
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

        function EditSchoolType(SchoolTypeID) {
        if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
            $.ajax({
                type: "POST",
                url: "../Masters/SchoolType.aspx/EditSchoolType",
                data: '{SchoolTypeID: ' + SchoolTypeID + '}',
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
            var schooltypes = xml.find("EditSchoolType");
            $.each(schooltypes, function () {
                var schooltype = $(this);
                $("[id*=txtSchoolTypeName]").val($(this).find("SchoolTypeName").text());
                $("[id*=txtDescription]").val($(this).find("Description").text());
                $("[id*=hfSchoolTypeID]").val($(this).find("SchoolTypeID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save SchoolType
        function SaveSchoolType() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfSchoolTypeID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfSchoolTypeID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                var SchoolTypeID = $("[id*=hfSchoolTypeID]").val();
                var SchoolTypeName = $("[id*=txtSchoolTypeName]").val();
                var Description = $("[id*=txtDescription]").val();
                var parameters = '{"id": "' + SchoolTypeID + '","name": "' + SchoolTypeName + '","description": "' + Description + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Masters/SchoolType.aspx/SaveSchoolType",
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
                GetSchoolType(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
               AlertMessage('success', 'Inserted');
                GetSchoolType(1);
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
                GetSchoolType(parseInt(currentPage));
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
            GetSchoolType(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtSchoolTypeName]").val("");
            $("[id*=txtDescription]").val("");
            $("[id*=hfSchoolTypeID]").val("");
            $("[id*=btnSubmit]").attr("disabled", "false");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
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
        <div class="box round first fullpage">
            <h2>
                School Category Type
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <div id="dvCashVoucher" style="float: left; width: 650px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                School Category Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtSchoolTypeName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                        <td rowspan="3">
                                            <div class="block">                                              
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Description</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtDescription" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <asp:HiddenField ID="hfSchoolTypeID" runat="server" />
                                        </td>
                                        <td>
                                         <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving"  onclick="SaveSchoolType();" ><span></span><div  id="spSubmit">Save</div></button>
                                            <button ID="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1"    
                                                runat="server"  onclick="return Cancel();"><span></span>Cancel</button>
 
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top" colspan="2">
                        <asp:GridView ID="dgSchoolType" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="SchoolTypeName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="School Type Name" SortExpression="SchoolTypeName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                     <asp:BoundField DataField="Description" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Description" SortExpression="Description">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("SchoolTypeID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("SchoolTypeID") %>'
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
