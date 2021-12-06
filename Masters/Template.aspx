<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Template.aspx.cs" Inherits="Template" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%-- <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>--%>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">

        $(function () {
            //        GetTemplates Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetTemplate(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });



        //        GetTemplates Function

        function GetTemplate(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Template.aspx/GetTemplate",
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
            var Templates = xml.find("Templates");
            var row = $("[id*=dgTemplate] tr:last-child").clone(true);
            $("[id*=dgTemplate] tr").not($("[id*=dgTemplate] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditTemplate('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteTemplate('";
                danchorEnd = "');\">Delete</a>";
            }
            if (Templates.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left").removeClass("editacc edit-links");
                $("td", row).eq(2).html("").removeClass("deleteacc delete-links");
                $("td", row).eq(3).html("");
                $("[id*=dgTemplate]").append(row);
                row = $("[id*=dgTemplate] tr:last-child").clone(true);

            }
            else {

                $.each(Templates, function () {
                    var Template = $(this);
                    var ehref = eanchor + $(this).find("TemplateID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("TemplateID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("CertificateTypeName").text());
                    $("td", row).eq(1).html($(this).find("TemplateName").text());
                    $("td", row).eq(2).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(3).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgTemplate]").append(row);
                    row = $("[id*=dgTemplate] tr:last-child").clone(true);
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
        // Delete Template
        function DeleteTemplate(id) {
            var parameters = '{"TemplateID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Template.aspx/DeleteTemplate",
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

        function EditTemplate(TemplateID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Masters/Template.aspx/EditTemplate",
                    data: '{TemplateID: ' + TemplateID + '}',
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
            var Templates = xml.find("EditTemplate");
            $.each(Templates, function () {
                var Template = $(this);
                var PhotoFile = $(this).find("TemplateName").text();
                if (PhotoFile) {
                    $("[id*=img_prev]").attr('src', "../Masters/Templates/" + PhotoFile.toString() + "?rand=" + Math.random()).width(114).height(114)
                }
                else {
                    $("[id*=img_prev]").attr('src', "../img/Photo.jpg").width(114).height(114);
                }

                var CertificateTypeID = $(this).find("CertificateTypeID").text();

                $("[id*=ddlCertificateType] option[value='" + CertificateTypeID + "']").attr("selected", "true");
                $("[id*=hfTemplateNo]").val($(this).find("TemplateID").text());                
                $("[id*=hfTemplateID]").val($(this).find("TemplateID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };

        // Save Template
        function SaveTemplate() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfTemplateID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfTemplateID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var TemplateID = $("[id*=hfTemplateID]").val();
                    var TemplateName = $("[id*=txtTemplateName]").val();
                    var CertificateTypeID = $("[id*=ddlCertificateType]").val();
                    var tempfile = $('#FuPhoto').val().replace(/C:\\fakepath\\/i, ''); ;
                    var PhotoFile = tempfile.substring(tempfile.lastIndexOf('\\') + 1);
                    var parameters = '{"id": "' + TemplateID + '","Templatename": "' + PhotoFile + '","CertificateTypeid": "' + CertificateTypeID + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/Template.aspx/SaveTemplate",
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
                var TemplateNo = $("[id*=hfTemplateNo]").val();
                if (formdata) {
                    formdata.append("TemplateID", TemplateNo);                    
                    if (formdata) {
                        $.ajax({
                            url: "../Masters/Template.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                            }
                        });
                    }
                }
                GetTemplate(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
           
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                Cancel();
            }
            else if (response.d) {
                AlertMessage('success', 'Inserted');
                var TemplateNo = response.d.toString();
                $("[id*=hfTemplateNo]").val(TemplateNo);
                if (formdata) {
                    formdata.append("TemplateID", TemplateNo);
                    if (formdata) {
                        $.ajax({
                            url: "../Masters/Template.aspx",
                            type: "POST",
                            data: formdata,
                            processData: false,
                            contentType: false,
                            success: function (res) {
                            }
                        });
                    }
                }
                GetTemplate(1);
                Cancel();
            }            
        };


        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetTemplate(parseInt(currentPage));
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
            GetTemplate(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $('#img_prev').attr('src', "../img/photo.jpg");
            $("[id*=FuPhoto]").val("");
            $("[id*=ddlCertificateType]").val("");
            $("[id*=hfTemplateID]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $("[id*=btnSubmit]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        var formdata;
        function readURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#img_prev').attr('src', e.target.result).width(114).height(114);

                };
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("TemplateImage", input.files[0]);
                }
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Template
            </h2>
            <div class="clear">
            </div>
            <div class="Template content-wrapper2">
                <table width="100%">
                    <tr>
                        <td colspan="2">
                            <div id="dvCashVoucher" style="float: left; width: 450px" runat="server">
                                <table class="form">
                                    <tr>
                                        <td>
                                            <table>
                                                <tr>
                                                    <td class="col1">
                                                        <label>
                                                            CertificateType Name</label>
                                                    </td>
                                                    <td class="col2">
                                                        <asp:DropDownList ID="ddlCertificateType" AppendDataBoundItems=true CssClass="jsrequired" runat="server">
                                                            <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="col1">
                                                        <label>
                                                            Template</label>
                                                    </td>
                                                    <td class="col2">
                                                        <input type='file' id="FuPhoto" onchange="readURL(this);" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <br />
                                                    </td>
                                                    <td>
                                                        <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveTemplate();">
                                                            <span></span>
                                                            <div id="spSubmit">
                                                                Save</div>
                                                        </button>
                                                        <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                            onclick="return Cancel();">
                                                            <span></span>Cancel</button>
                                                        <asp:HiddenField ID="hfTemplateID" runat="server" />
                                                        <asp:HiddenField ID="hfTemplateNo" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td rowspan="3">
                                            <table>
                                                <tr>
                                                    <td align="center" colspan="4">
                                                        <div style="float: left; width: 120px; right: 60px; margin-top: 5px;">
                                                            <img id="img_prev" src="../img/photo.jpg" class='zoom' alt="Profile Photo" width="114"
                                                                height="114" />
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2" valign="top">
                            <asp:GridView ID="dgTemplate" runat="server" Width="100%" AutoGenerateColumns="false"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="CertificateTypeName" HeaderStyle-CssClass="sorting_mod"
                                        ItemStyle-HorizontalAlign="Center" HeaderText="CertificateType Name" SortExpression="CertificateTypeName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="TemplateName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Template Name" SortExpression="TemplateName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("TemplateID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("TemplateID") %>'
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
