<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="LeaveApproval.aspx.cs" Inherits="Staffs_LeaveApproval" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!--Autocomplete script starts here -->
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <!--Autocomplete script ends here -->
    <script type="text/javascript">
        var dpStatus = '';
        $(function () {
            GetDpStatus();

            //        GetStudentInfos Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetStaffDetail(1);
            //        GetModuleID('Students/TCSearch.aspx');
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });

        function GetDpStatus() {
            $.ajax({
                type: "POST",
                url: "../Staffs/LeaveApproval.aspx/GetDpStatus",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDPSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnDPSuccess(response) {
            dpStatus = response.d;
        }
        function GetStaffDetail(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Staffs/LeaveApproval.aspx/GetLeaveApprovalList",
                    data: '{"pageIndex":"' + pageIndex + '","empCode":"' + $("[id*=txtEmpCode]").val() + '","designation":"' + $("[id*=ddlDesignation]").val() + '","staffName":"' + $("[id*=txtStaffName]").val() + '"}',
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
        function GetSectionByClass(ID) {
            var Class = $("[id*=ddlClass]").val();
            if (Class != "") {
                $.ajax({
                    type: "POST",
                    url: "../Students/LeaveApproval.aspx/GetSectionByClassID",
                    data: '{ClassID: ' + Class + '}',
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
            GetCount();
        };
        function OnSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var LeaveApproval = xml.find("LeaveApproval");
            var row = $("[id*=grdLeaveApproval] tr:last-child").clone(true);
            $("[id*=grdLeaveApproval] tr").not($("[id*=grdLeaveApproval] tr:first-child")).remove();
            var vanchor = ''
            var vanchorEnd = '';

            if ($("[id*=hfViewPrm]").val() == 'false') {
                vanchor = "<a>";
                vanchorEnd = "</a>";
            }
            else {
                vanchor = "<a  href=\"javascript:GetLeaveApproval('";
                vanchorEnd = "');\">View</a>";
            }
            if (LeaveApproval.length > 0) {
                $.each(LeaveApproval, function () {
                    var appendDpFormat = '';
                    row.addClass("even");
                    var selectHtml = "<select id=\"" + $(this).find("StaffLeaveId").text() + "\" onchange=\"updateStatus('" + $(this).find("StaffLeaveId").text() + "',this.value);\"><option value=\"\">---Select---</option><option value=\"0\">Pending</option><option value=\"1\">Approved</option><option value=\"2\">Denied</option></select>";
                    var vhref = vanchor + $(this).find("StaffLeaveId").text() + "','" + $(this).find("LeaveId").text() + vanchorEnd;
                    $("td", row).eq(0).html($(this).find("EmpCode").text());
                    $("td", row).eq(1).html($(this).find("StaffName").text());
                    $("td", row).eq(2).html($(this).find("RoleName").text());
                    $("td", row).eq(3).html($(this).find("DesignationName").text());
                    $("td", row).eq(4).html($(this).find("RequestedDate").text());
                    $("td", row).eq(5).html($(this).find("NoOfDays").text());
                    $("td", row).eq(6).html($(this).find("LeaveFrom").text());
                    $("td", row).eq(7).html($(this).find("LeaveTo").text());
                    if ($(this).find("FileName").text()!=null && $(this).find("FileName").text()!="") {
                        $("td", row).eq(8).html("<a target='_blank' href=../Staffs/Uploads/LeaveRecords/" + $(this).find("FileName").text() + ">" + $(this).find("FileName").text() + "</a>").addClass("download-links");
                    }
                    else {
                        $("td", row).eq(8).html($(this).find("FileName").text()).removeClass("download-links");
                    }
                    $("td", row).eq(9).html($(this).find("LeaveType").text());
                    $("td", row).eq(10).html($(this).find("StatusName").text());
                    $("td", row).eq(11).html(selectHtml);
                    $("td", row).eq(12).html(vhref).addClass("viewacc view-links");
                    $("[id*=grdLeaveApproval]").append(row);
                    row = $("[id*=grdLeaveApproval] tr:last-child").clone(true);
                });
            }
            else {
                row.addClass("even");
                $("td", row).eq(0).html('');
                $("td", row).eq(1).html('');
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('');
                $("td", row).eq(5).html('No records found');
                $("td", row).eq(6).html('');
                $("td", row).eq(7).html('');
                $("td", row).eq(8).html('').removeClass("download-links");
                $("td", row).eq(9).html('');
                $("td", row).eq(10).html('');
                $("td", row).eq(11).html('');
                $("td", row).eq(12).html('').removeClass("viewacc view-links");
                $("[id*=grdLeaveApproval]").append(row);
                row = $("[id*=grdLeaveApproval] tr:last-child").clone(true);
            }
            if ($("[id*=hfViewPrm]").val() == 'false') {
                $('.editacc').hide();
            }
            else {
                $('.editacc').show();
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
        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetStaffDetail(parseInt($(this).attr('page')));
        });
        function GetLeaveApproval(StaffLeaveId, LeaveId) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                var pageurl;
                var redirecturl;
                if (LeaveId == 1) {
                    pageurl = "../Staffs/ViewLeaveApplication.aspx/GetLeaveApproval"
                    redirecturl = "../Staffs/ViewLeaveApplication.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&StaffLeaveId=" + StaffLeaveId + "&LeaveId=" + LeaveId + "";
                }
                else if (LeaveId == 2) {
                    pageurl = "../Staffs/MaternityLeaveApplication.aspx/GetLeaveApproval"
                    redirecturl = "../Staffs/MaternityLeaveApplication.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&StaffLeaveId=" + StaffLeaveId + "&LeaveId=" + LeaveId + "";
                }
                else if (LeaveId == 3) {
                    pageurl = "../Staffs/EOLLeaveApplication.aspx/GetLeaveApproval"
                    redirecturl = "../Staffs/EOLLeaveApplication.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&StaffLeaveId=" + StaffLeaveId + "&LeaveId=" + LeaveId + "";
                }
                else if (LeaveId == 4) {
                    pageurl = "../Staffs/EarnedLeaveApplication.aspx/GetLeaveApproval"
                    redirecturl = "../Staffs/EarnedLeaveApplication.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&StaffLeaveId=" + StaffLeaveId + "&LeaveId=" + LeaveId + "";
                }
                else if (LeaveId == 5) {
                    pageurl = "../Staffs/ViewPermissionApplication.aspx/GetLeaveApproval"
                    redirecturl = "../Staffs/ViewPermissionApplication.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&StaffLeaveId=" + StaffLeaveId + "&LeaveId=" + LeaveId + "";
                }


                $.ajax({
                    type: "POST",
                    url: pageurl,
                    data: '{"StaffLeaveId": "' + StaffLeaveId + '","LeaveId": "' + LeaveId + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var url = redirecturl;
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
        function updateStatus(StaffLeaveId, status) {
            if (jConfirm('Are you sure to update the Leave approval status ?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Staffs/LeaveApproval.aspx/UpdateLeaveApproval",
                        data: '{"StaffLeaveId":"' + StaffLeaveId + '","status":"' + status + '","userId":"' + $('#<%= hdnUserId.ClientID %>').val() + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            AlertMessage('success', response.d);
                            GetStaffDetail(parseInt($("[id*=currentPage]").text()));
                        },
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

        function Cancel() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtEmpCode]").val("");
            $("[id*=txtStaffName]").val("");
            $("[id*=ddlDesignation]").val("");
            GetStaffDetail(1);
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
       <div class="box round first fullpage">
            <h2>
                Leave Approval</h2>
               <div class="block john-accord content-wrapper2">
             <div class="block1">
                  <table class="form" width="100%">
                    <tr>
                        <td>
                            <div id="stud_1" style="display: block;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="9%">
                                            <label>
                                                Employee Code :</label>
                                        </td>
                                        <td width="15%">
                                            <asp:TextBox ID="txtEmpCode" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Designation :</label>
                                        </td>
                                        <td width="15%">
                                            <asp:DropDownList ID="ddlDesignation" runat="server" AppendDataBoundItems="True">
                                            </asp:DropDownList>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                Staff Name :</label>
                                        </td>
                                        <td width="18%">
                                            <input type="text" id="testid" value="" style="display: none" />
                                            <asp:TextBox ID="txtStaffName" CssClass="letterswithbasicpunc" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            .
                        </td>
                    </tr>
                    <tr>
                        <td class="col1">
                        </td>
                    </tr>
                    <tr>
                        <td class="col1">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" align="center">
                            <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStaffDetail(1);">
                                <span></span>Search</button>
                            &nbsp;
                            <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                onclick="return Cancel();">
                                <span></span>Cancel</button>
                            &nbsp;
                            <asp:HiddenField ID="hfStaffID" runat="server" />
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
                        <td valign="top" width="12%">
                        </td>
                        <td valign="top" width="15%">
                            <asp:RadioButtonList ID="radlAcademicYear" Visible="false" RepeatDirection="Horizontal"
                                runat="server">
                            </asp:RadioButtonList>
                        </td>
                        <td valign="top" width="70%">
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="grdLeaveApproval" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="EmpCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="EmpCode" SortExpression="EmpCode">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Name" SortExpression="Name">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RoleNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Role No" SortExpression="RoleNo">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Designation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Designation" SortExpression="Designation">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RequestedDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Requested Date" SortExpression="RequestedDate">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NoOfDays" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="No Of Days" SortExpression="NoOfDays">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="From" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="From" SortExpression="From">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="To" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="To" SortExpression="To">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Attachment" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Attachment" SortExpression="Attachment">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="LeaveType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Leave Type" SortExpression="LeaveType">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="StatusName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="PresentStatus" SortExpression="StatusName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Approval Status" HeaderStyle-CssClass="sorting_mod"
                                        ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlApproval" runat="server" AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                                <asp:ListItem Selected="False" Value="0">Pending</asp:ListItem>
                                                <asp:ListItem Selected="False" Value="1">Approved</asp:ListItem>
                                                <asp:ListItem Selected="False" Value="2">Denied</asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-CssClass="sorting_mod viewacc">
                                        <HeaderTemplate>
                                            View</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkView" runat="server" Text="View" CommandArgument='<%# Eval("StaffLeaveId") %>'
                                                CommandName="View" CausesValidation="false" CssClass="links"></asp:LinkButton>
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
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <%--  <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetLeaveApprovalStudent.ashx?input=" + input + "&class=" + $('#<%= ddlClass.ClientID %>').val() + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15
        };


        var as_xml = new bsn.AutoSuggest('<%= txtStudentName.ClientID %>', options_xml);    

    </script>--%>
    <script src="../prettyphoto/js/prettyPhoto.js" type="text/javascript"></script>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("a[rel^='prettyPhoto']").prettyPhoto();
        });
    </script>
</asp:Content>
