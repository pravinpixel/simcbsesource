<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ManageCancellation.aspx.cs" Inherits="Students_ManageCancellation" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <%="<script src='" + ResolveUrl("~/prettyphoto/js/jquery.prettyPhoto.js") + "' type='text/javascript' charset='utf-8'></script>"%>
    <%="<link href='" + ResolveUrl("~/prettyphoto/css/prettyPhoto.css") + "' rel='stylesheet' type='text/css'  media='screen'  title='prettyPhoto main stylesheet' charset='utf-8' />"%>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("a[rel^='prettyPhoto']").prettyPhoto();
            setDatePicker("[id*=txtCancellationDate]");
        });
    </script>
    <script type="text/javascript">

        $(function () {
            //        GetStudentInfos Function on page load
            document.getElementById("dvCancellation").style.display = "none";
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetStudentInfo(1);
            GetModuleID('Students/StudentInfo.aspx');
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });


        function GetStudentInfo(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var SearchTag;
                if ($("[id*=rbtnBus]").is(':checked')) {
                    SearchTag = "Bus";
                }

                else if ($("[id*=rbtnHostel]").is(':checked')) {
                    SearchTag = "Hostel";
                }
                var StudentID = "", regno = "";
                StudentID = $("[id*=hfStudentID]").val();

                regno = $("[id*=txtRegNo]").val();


                var parameters = '{pageIndex: ' + pageIndex + ',"regno": "' + regno + '","searchtag": "' + SearchTag + '"}';

                $.ajax({
                    type: "POST",
                    url: "../Students/ManageCancellation.aspx/GetCancellationStudentInfo",
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
        function EditStudentInfo(StudentInfoID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfoView.aspx/GetStudentInfo",
                    data: '{studentid: ' + StudentInfoID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var url = "../Students/StudentInfoView.aspx?StudentID=" + StudentInfoID + "";
                        $.prettyPhoto.open('StudentInfoView.aspx?StudentID=' + StudentInfoID + '&iframe=true&width=800', '', '');
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

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var StudentInfoes = xml.find("StudentInfo");

            var row = $("[id*=dgStudentInfo] tr:last-child").clone(true);
            $("[id*=dgStudentInfo] tr").not($("[id*=dgStudentInfo] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  style='cursor:pointer;' onclick=\"javascript:ShowCancellation('";
                eanchorEnd = "');\">Cancel</a>";
            }

            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a href=\"javascript:EditStudentInfo('";
                danchorEnd = "');\">View</a>";
            }
            if (StudentInfoes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("[id*=dgStudentInfo]").append(row);
                row = $("[id*=dgStudentInfo] tr:last-child").clone(true);


            }
            else {

                $.each(StudentInfoes, function () {
                    var iStudentInfo = $(this);
                    var studentid = $(this).find("StudentID").text();
                    var ehref = eanchor + $(this).find("RegNo").text() + "','" + $(this).find("CancellationType").text() + eanchorEnd;
                    var dhref = danchor + studentid + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("StudentName").text());
                    $("td", row).eq(3).html($(this).find("Class").text());
                    $("td", row).eq(4).html($(this).find("Section").text());
                    $("td", row).eq(5).html(ehref).addClass("deleteacc delete-links");
                    $("td", row).eq(6).html(dhref).addClass("editacc view-links");
                    $("[id*=dgStudentInfo]").append(row);
                    row = $("[id*=dgStudentInfo] tr:last-child").clone(true);
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


        // Delete StudentInfo
        function UpdateCancellation() {
            var regno = $("[id*=hfregno]").val();
            if ($("[id*=rbtnBus]").is(':checked')) {
                type = "Bus";
            }
            else if ($("[id*=rbtnHostel]").is(':checked')) {
                type = "Hostel";
            }
            var canceldate = $("[id*=txtCancellationDate]").val();
            var reason = $("[id*=txtReason]").val();
            var parameters = '{"regno": "' + regno + '","type": "' + type + '","canceldate": "' + canceldate + '","reason": "' + reason + '"}';
            if (jConfirm('Are you sure to Cancel ?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/ManageCancellation.aspx/UpdateCancellation",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnUpdateCancellationSuccess,
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
        function OnUpdateCancellationSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                closeiframe();
                AlertMessage('success', 'Deleted');
                var RegNo = $("[id*=hfRegNo]").val();
                if (RegNo != "") {
                    GetStudentInfo(1);
                }
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
                Cancel();
            }
        };
        //        Edit Function


        function GetModuleID(path) {
            $.ajax({
                type: "POST",
                url: "../Students/ManageCancellation.aspx/GetModuleId",
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
            $("[id*=hfModuleID]").val(response.d);
        }
        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetStudentInfo(parseInt(currentPage));
                Cancel();
            }
            else if (response.d == "Delete Failed") {
                AlertMessage('fail', 'Delete');
                Cancel();
            }
        };

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetStudentInfo(parseInt($(this).attr('page')));
        });

        function Cancel() {
            $("[id*=hfStudentID]").val("");
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
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
        function ShowCancellation(regno, type) {

            document.getElementById("dvCancellation").style.display = "block";
            $("[id*=hfregno]").val(regno);
            $("[id*=hftype]").val(type);
            $("[id*=txtCancellationDate]").val("");
            $("[id*=txtReason]").val("");
        }
        function closeiframe() {
            document.getElementById("dvCancellation").style.display = "none";
        }

    </script>
    <script type="text/javascript">

        function Cancel() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtRegNo]").val("");
            GetStudentInfo(1);
        };
       
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Manage Cancellation
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table class="form">
                    <tr>
                        <td width="12%">
                            <label>
                                Cancellation For :</label>
                        </td>
                        <td>
                            <label>
                                <input type="radio" name="cb1" id="rbtnBus" value="Bus" checked="checked" />Bus</label>
                            <label>
                                <input type="radio" name="cb1" id="rbtnHostel" value="Hostel" />Hostel</label>
                        </td>
                    </tr>
                    <tr>
                        <td width="12%">
                            <label>
                                Register No :</label>
                        </td>
                        <td>
                            <label>
                                <asp:TextBox ID="txtRegNo" CssClass="bloodgroup" runat="server"></asp:TextBox></label>
                        </td>
                    </tr>
                    <tr>
                        <td width="12%">
                            &nbsp;
                        </td>
                        <td valign="top">
                            <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStudentInfo(1);">
                                <span></span>Search</button>
                            &nbsp;
                            <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return Cancel();">
                                <span></span>Cancel</button>
                            &nbsp;
                            <asp:HiddenField ID="hfStudentID" runat="server" />
                            <asp:HiddenField ID="hfModuleID" runat="server" />
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="dgStudentInfo" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Sl.No." SortExpression="SlNo">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RegNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Reg No" SortExpression="RegNo">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="StudentName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Student Name" SortExpression="StudentName">
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
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Cancel</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Cancel" CommandArgument='<%# Eval("StudentID") %>'
                                                CommandName="Cancel" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            View</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkView" runat="server" Text="lnkView"></asp:LinkButton>
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
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div id="dvCancellation" style="background: url(../img/overly.png) repeat; width: 100%;
        display: block; height: 100%; position: absolute; top: 0; left: 0; z-index: 10000;">
        <div style="position: absolute; top: 45%; left: 30%">
            <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="center" valign="middle">
                        <table width="700px" border="0" cellspacing="0" cellpadding="0" class="paleartsbg">
                            <tr>
                                <td align="right" valign="top" style="padding: 6px;">
                                    <a href="javascript:closeiframe()">Close</a>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" valign="top" style="padding: 6px;">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="12%">
                                                <label>
                                                    Date for Cancellation :</label>
                                            </td>
                                            <td width="12%">
                                                <asp:TextBox ID="txtCancellationDate" runat="server" CssClass="jsrequired DateNL Date-picker"></asp:TextBox>
                                            </td>
                                            <td width="12%">
                                                <label>
                                                    Reason for Cancellation :</label>
                                            </td>
                                            <td width="12%">
                                                <asp:TextBox ID="txtReason" TextMode="MultiLine" runat="server" CssClass="bloodgroup"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <asp:HiddenField ID="hfregno" runat="server" />
                                        <asp:HiddenField ID="hftype" runat="server" />
                                        <tr>
                                            <td colspan="4" align="center">
                                                <br />
                                                <button id="btnCancellationSubmit" type="button" runat="server" class="btn-icon btn-navy btn-save"
                                                    onclick="UpdateCancellation();">
                                                    <span></span>
                                                    <div id="spSubmit">
                                                        Update</div>
                                                </button>
                                                <button id="btnConcessionCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                    runat="server" onclick="return CancellationCancel();">
                                                    <span></span>Cancel</button><br />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
