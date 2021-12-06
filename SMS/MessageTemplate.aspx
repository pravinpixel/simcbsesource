<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="MessageTemplate.aspx.cs" Inherits="MessageTemplate" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/maxlength.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script type="text/javascript">
        $(function () {
            //        GetMessageTemplate Function on page load

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetMessageTemplate(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

           
        });


        //        GetMessageTemplate Function

        function GetMessageTemplate(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../SMS/MessageTemplate.aspx/GetMessageTemplate",
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

        //        GetMessageTemplate On Success Function
        //        Get MessageTemplate to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var MessageTemplates = xml.find("MessageTemplates");
            var row = $("[id*=dgMessageTemplate] tr:last-child").clone(true);
            $("[id*=dgMessageTemplate] tr").not($("[id*=dgMessageTemplate] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditMessageTemplate('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteMessageTemplate('";
                danchorEnd = "');\">Delete</a>";
            }
            if (MessageTemplates.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("").removeClass("editacc edit-links");
                $("td", row).eq(3).html("").removeClass("deleteacc delete-links");
                $("[id*=dgMessageTemplate]").append(row);
                row = $("[id*=dgMessageTemplate] tr:last-child").clone(true);

            }
            else {
          
                $.each(MessageTemplates, function () {
                    var MessageTemplate = $(this);
                    var ehref = eanchor + $(this).find("MessageTemplateID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("MessageTemplateID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("MessageTemplateName").text());
                    $("td", row).eq(1).html($(this).find("Message").text());
                    $("td", row).eq(2).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(3).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgMessageTemplate]").append(row);
                    row = $("[id*=dgMessageTemplate] tr:last-child").clone(true);
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
        // Delete MessageTemplate
        function DeleteMessageTemplate(id) {
            var parameters = '{"MessageTemplateID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../SMS/MessageTemplate.aspx/DeleteMessageTemplate",
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

        function EditMessageTemplate(MessageTemplateID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../SMS/MessageTemplate.aspx/EditMessageTemplate",
                    data: '{MessageTemplateID: ' + MessageTemplateID + '}',
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
            var MessageTemplates = xml.find("EditMessageTemplate");           
            $.each(MessageTemplates, function () {
                var MessageTemplate = $(this);
                $("[id*=txtTemplateName]").val($(this).find("MessageTemplateName").text());
                $("[id*=txtMessage]").val($(this).find("Message").text());
                $("[id*=hfMessageTemplateID]").val($(this).find("MessageTemplateID").text());
                var EmpID = $(this).find("EmpID").text();
               
                    var myLength = $(this).find("Message").text().length;
                    if (myLength <= 160) {
                        $("[id*=status1]").html("(" + myLength + "/160) Left(Max.160 Charactes only allowed)").addClass("status2");                        
                    }
                
                $("[id*=dvCount]").html("(" + $(this).find("Message").text().length + "/160) Left");

            });
                $("[id*=spSubmit]").html("Update");
        };

        // Save MessageTemplate
        function SaveMessageTemplate() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfMessageTemplateID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfMessageTemplateID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var MessageTemplateID = $("[id*=hfMessageTemplateID]").val();
                    var MessageTemplateName = $("[id*=txtTemplateName]").val();
                    var Message = $("[id*=txtMessage]").val().replace("'", "\'\'");                   
                    var parameters = '{"id": "' + MessageTemplateID + '","name": "' + MessageTemplateName + '","Message": "' + Message + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../SMS/MessageTemplate.aspx/SaveMessageTemplate",
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
                $("[id*=status1]").html("(0/160) Left(Max.160 Charactes only allowed)").addClass("status2"); 
                GetMessageTemplate(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');              
                $("[id*=status1]").html("(0/160) Left(Max.160 Charactes only allowed)").addClass("status2"); 
                GetMessageTemplate(1);
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
                GetMessageTemplate(parseInt(currentPage));
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
            GetMessageTemplate(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=txtTemplateName]").val("");
            $("[id*=txtMessage]").val("");
            $("[id*=hfMessageTemplateID]").val("");
            $("[id*=btnSubmit]").attr('disabled', false);
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");           
            $("[id*=status1]").html("(0/160) Left(Max.160 Charactes only allowed)").addClass("status2"); 
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
                SMS Template</h2>
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
                                                Template Name</label>
                                        </td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtTemplateName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                       
                                    </tr>
                                    <tr>
                                        <td class="col1">
                                            <label>
                                                Message</label>
                                        </td>
                                        <td class="col2">
                                          <textarea  rows="7" cols="40" id="txtMessage" data-maxsize="160" data-output="status1"
                                            wrap="virtual"></textarea><br />
                                        <div id="status1" class="status1">
                                        </div>
                                        </td>
                                    </tr>                                
                                    <tr>
                                        <td class="col1">
                                            <asp:HiddenField ID="hfMessageTemplateID" runat="server" />
                                        </td>
                                        <td>
                                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveMessageTemplate();">
                                                <span></span>
                                                <div id="spSubmit">
                                                    Save</div>
                                            </button>
                                            <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                onclick="return Cancel();">
                                                <span></span>Cancel</button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top" colspan="2">
                            <asp:GridView ID="dgMessageTemplate" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="MessageTemplateName" HeaderStyle-CssClass="sorting_mod"
                                        ItemStyle-HorizontalAlign="Center" HeaderText="Template Name" SortExpression="MessageTemplateName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Message" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Message" SortExpression="Message">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("MessageTemplateID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("MessageTemplateID") %>'
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
