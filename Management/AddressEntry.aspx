<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="AddressEntry.aspx.cs" Inherits="Management_AddressEntry" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
        $(function () {

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true') {
                GetAddressInfo(1);
            }
            else {
                GetAddressInfo(0);

            }
            $("[id*=spSubmit]").html("Save");
        });

        function GetAddressInfo(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Management/AddressEntry.aspx/GetAddressBookInfo",
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
            var AddressBookInfoes = xml.find("AddressBookInfo");

            var row = $("[id*=dgAddressBookInfo] tr:last-child").clone(true);
            $("[id*=dgAddressBookInfo] tr").not($("[id*=dgAddressBookInfo] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditAddressBookInfo('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteAddressBookInfo('";
                danchorEnd = "');\">Delete</a>";
            }

            if (AddressBookInfoes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("No Record Found").attr("align", "left");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("td", row).eq(8).html("");
                $("td", row).eq(9).html("").removeClass("editacc edit-links");
                $("td", row).eq(10).html("").removeClass("deleteacc delete-links");
                $("[id*=dgAddressBookInfo]").append(row);
                row = $("[id*=dgAddressBookInfo] tr:last-child").clone(true);

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

                $.each(AddressBookInfoes, function () {
                    var iAddressBookInfo = $(this);
                    var ehref = eanchor + $(this).find("AddressID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("AddressID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("AddressType").text());
                    $("td", row).eq(2).html($(this).find("Name").text());
                    $("td", row).eq(3).html($(this).find("Address").text());
                    $("td", row).eq(4).html($(this).find("MobileNo1").text());
                    $("td", row).eq(5).html($(this).find("MobileNo2").text());
                    $("td", row).eq(6).html($(this).find("MobileNo3").text());
                    $("td", row).eq(7).html($(this).find("Email").text());
                    $("td", row).eq(8).html($(this).find("WayofAssociation").text());
                    $("td", row).eq(9).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(10).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgAddressBookInfo]").append(row);
                    row = $("[id*=dgAddressBookInfo] tr:last-child").clone(true);
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

        function SaveAddressDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfBlockID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfBlockID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var AddressID = $("[id*=hfAddressID]").val();
                    var Salutation = $("[id*=txtSalutation]").val();
                    var Name = $("[id*=txtName]").val();
                    var Address = $("[id*=txtAddress]").val();
                    var AddressType = $("[id*=ddlAddressType]").val();
                    var WOA = $("[id*=txtWOA]").val();
                    var Email = $("[id*=txtEmail]").val();
                    var Mobile1 = $("[id*=txtMobile1]").val();
                    var Mobile2 = $("[id*=txtMobile2]").val();
                    var Mobile3 = $("[id*=txtMobile3]").val();
                    var parameters = '{"AddressID": "' + AddressID + '","Salutation": "' + Salutation + '","Name": "' + Name + '","Address": "' + Address + '","AddressType": "' + AddressType + '","WOA": "' + WOA + '","Email": "' + Email + '","Mobile1": "' + Mobile1 + '","Mobile2": "' + Mobile2 + '","Mobile3": "' + Mobile3 + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Management/AddressEntry.aspx/SaveAddress",
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
        // Delete AddressBookInfo
        function DeleteAddressBookInfo(id) {
            var parameters = '{"AddressBookInfoID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Management/AddressEntry.aspx/DeleteAddressBookInfo",
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

        function EditAddressBookInfo(AddressBookInfoID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Management/AddressEntry.aspx/EditAddressBookInfo",
                    data: '{AddressBookInfoID: ' + AddressBookInfoID + '}',
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
        function OnEditSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var blocks = xml.find("EditAddressBookInfo");
            $.each(blocks, function () {
                var block = $(this);
                $("[id*=hfAddressID]").val($(this).find("AddressID").text());
                $("[id*=txtSalutation]").val($(this).find("Salutation").text());
                $("[id*=txtName]").val($(this).find("Name").text());
                $("[id*=txtAddress]").val($(this).find("Address").text());
                $("[id*=txtMobile1]").val($(this).find("MobileNo1").text());
                $("[id*=txtMobile2]").val($(this).find("MobileNo2").text());
                $("[id*=txtMobile3]").val($(this).find("MobileNo3").text());
                $("[id*=txtEmail]").val($(this).find("Email").text());
                $("[id*=txtWOA]").val($(this).find("WayofAssociation").text());
                var AddressType = $(this).find("AddressType").text();
                $("[id*=ddlAddressType] option[value='" + AddressType + "']").attr("selected", "true");
                $("[id*=spSubmit]").html("Update");


            });
        };

        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                AddressDetailsClear();
                GetAddressInfo(1);
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                AddressDetailsClear();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                AddressDetailsClear();
                GetAddressInfo(1);
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                AddressDetailsClear();
            }
            else {
                AlertMessage('fail', response.d);
                AddressDetailsClear();
            }
        };

        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetAddressInfo(1);
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
            GetAddressInfo(parseInt($(this).attr('page')));
        });
        function AddressDetailsClear() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Save");
            $("[id*=txtSalutation]").val("");
            $("[id*=hfAddressID]").val("");
            $("[id*=txtName]").val("");
            $("[id*=txtAddress]").val("");
            $("[id*=ddlAddressType]").val(""); 
            $("[id*=txtWOA]").val("");
            $("[id*=txtEmail]").val("");
            $("[id*=txtMobile1]").val("");
            $("[id*=txtMobile2]").val("");
            $("[id*=txtMobile3]").val("");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Add/Edit Address Book</h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table class="form" width="50%">
                    <tr>
                        <td width="12%">
                            <span style="color: Red">*</span>
                            <label>
                                Address Type :</label>
                        </td>
                        <td class="col2">
                            <asp:DropDownList ID="ddlAddressType" CssClass="jsrequired" runat="server">
                                <asp:ListItem Selected="True">---Select---</asp:ListItem>
                                            <asp:ListItem Value="Alumni">Alumni</asp:ListItem>
                                            <asp:ListItem  Value="Banks">Banks</asp:ListItem>
                                            <asp:ListItem Value="Chief Guest">Chief Guest</asp:ListItem>
                                            <asp:ListItem Value="Colleges">Colleges</asp:ListItem>
                                            <asp:ListItem Value="Companies">Companies</asp:ListItem>
                                            <asp:ListItem Value="Doctors">Doctors</asp:ListItem>
                                            <asp:ListItem Value="Engineers">Engineers</asp:ListItem>
                                            <asp:ListItem Value="High School">High School</asp:ListItem>
                                            <asp:ListItem Value="Hr.Sec. School">Hr.Sec. School</asp:ListItem>
                                            <asp:ListItem Value="Govt Officials">Govt Officials</asp:ListItem>
                                            <asp:ListItem Value="Political Parties">Political Parties</asp:ListItem>
                                            <asp:ListItem Value="Press">Press</asp:ListItem>
                                            <asp:ListItem Value="Sports">Sports</asp:ListItem>
                                            <asp:ListItem Value="Student">Student</asp:ListItem>
                                            <asp:ListItem Value="Staff">Staff</asp:ListItem>
                                            <asp:ListItem Value="Relations">Relations</asp:ListItem>
                                            <asp:ListItem Value="Religious"></asp:ListItem>
                                            <asp:ListItem Value="Well-wisher">Well-wisher</asp:ListItem>
                                            <asp:ListItem Value="Others">Others</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td width="12%">
                           <label>
                                Salutation :</label></td>
                        <td class="col2">
                            <asp:TextBox ID="txtSalutation" Width="50px" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>
                            <span style="color: Red">*</span>
                            <label>
                                Name :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtName" CssClass="jsrequired" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                <span style="color: Red">*</span> Way of Association :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtWOA" CssClass="jsrequired" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                Address :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtAddress" TextMode="MultiLine" runat="server" Columns="30" 
                                Rows="5"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                Email :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtEmail" CssClass="email" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            LandLine
                            <label>
                                &nbsp;No 1:</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtMobile1" CssClass="numbersonly" runat="server"></asp:TextBox>
                            &nbsp;
                        </td>
                    </tr>
                       <tr>
                        <td>
                            <label>
                                Mobile No 2:</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtMobile2" CssClass="numbersonly" runat="server"></asp:TextBox>
                            &nbsp;
                        </td>
                    </tr>
                       <tr>
                        <td>
                            <label>
                                Mobile No 3:</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtMobile3" CssClass="numbersonly" runat="server"></asp:TextBox>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-left:130px;">
                            <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveAddressDetails();">
                                <span></span>
                                <div id="spSubmit">
                                    Save</div>
                            </button>
                            <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return AddressDetailsClear();">
                                <span></span>Cancel</button>&nbsp;<asp:HiddenField ID="hfUserId" runat="server" />
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="dgAddressBookInfo" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
<AlternatingRowStyle CssClass="odd"></AlternatingRowStyle>
                                <Columns>
                                    <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Sl.No." SortExpression="SlNo">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                      <asp:BoundField DataField="AddressType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Address Type" SortExpression="AddressType">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Name" SortExpression="Name">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Address" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Address" SortExpression="Address">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MobileNo1" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="LandLine No I" SortExpression="MobileNo1">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                     <asp:BoundField DataField="MobileNo2" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Mobile No II" SortExpression="MobileNo2">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                     <asp:BoundField DataField="MobileNo3" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Mobile No III" SortExpression="MobileNo3">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Email" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Email" SortExpression="Email">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="WayofAssociation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Way of Association" SortExpression="WayofAssociation">
<HeaderStyle CssClass="sorting_mod"></HeaderStyle>

                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("AddressID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>

<HeaderStyle HorizontalAlign="Center" CssClass="sorting_mod editacc"></HeaderStyle>

<ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("AddressID")%>'
                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>

<HeaderStyle HorizontalAlign="Center" CssClass="sorting_mod deleteacc"></HeaderStyle>

<ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateField>
                                </Columns>

<RowStyle CssClass="even"></RowStyle>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="Pager">
                            </div>
                            <br />
                            <br />

                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hfAddressID" runat="server" />
</asp:Content>
