<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="StaffSearch.aspx.cs" Inherits="Staffs_StaffSearch" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetStaffInfo(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });

        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetStaffInfo(parseInt($(this).attr('page')));
        });
           
    </script>
    <script type="text/javascript">
        function showDiv() {
            if (document.getElementById('rbtnBasic').checked == true) {
                $("[id*=staff_1]").slideDown("fast");
                $("[id*=staff_2]").slideUp("fast");
            }
            if (document.getElementById('rbtnAdvanced').checked == true) {
                $("[id*=staff_2]").slideDown("fast");
                $("[id*=staff_1]").slideUp("fast");
            }
        }
    </script>
    <script type="text/javascript">
        function GetStaffInfo(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var SearchTag;
                if ($("[id*=rbtnBasic]").is(':checked')) {
                    SearchTag = "Basic";
                }

                else if ($("[id*=rbtnAdvanced]").is(':checked')) {
                    SearchTag = "Advanced";
                }
                var staffId = '';
                var empCode = '';
                var empName = '';
                var gender = '';
                var designation = '';
                var phoneNumber = '';
                var email = '';
                var presentstatus = '';
                var placeofwork = '';
                var department = '';
                var subjecthandling = '';
                var religion = '';
                var bloodgroup = '';
                //var StudentID = "", regno = "", StudentName = "", AdminNo = "", Classname = "", Sectionname = "", Name = "", Gender = "", PhoneNo = "", Hostel = "", HostelName = "", BusFacility = "", RouteCode = "", RouteName = "";
                //= $("[id*=hfStudentID]").val();
                if (SearchTag == "Basic") {
                    empCode = $("[id*=txtEmpCode]").val();
                    empName = $("[id*=txtEmpName]").val();
                    if ($("[id*=rbtnMale]").is(':checked')) {
                        gender = "M";
                    }
                    else if ($("[id*=rbtnFemale]").is(':checked')) {
                        gender = "F";
                    }

                }

                else if (SearchTag == "Advanced") {

                    designation = $("[id*=ddlDesignation]").val();                   
                    phoneNumber = $("[id*=txtPhoneNo]").val();
                    email = $("[id*=txtEmail]").val();
                    presentstatus = $("[id*=ddlStatus]").val();
                    placeofwork = $("[id*=ddlPlace]").val();
                    department = $("[id*=ddlDepartment]").val(); 
                    subjecthandling =$("[id*=ddlSubject]").val(); 
                    religion = $("[id*=ddlReligion]").val(); 
                    bloodgroup = $("[id*=ddlBloodGroup]").val(); 
                }
                var parameters = '{"index": "' + pageIndex + '","code": "' + empCode + '","name": "' + empName + '","designation": "' + designation + '","sex": "' + gender + '","pNo": "' + phoneNumber + '","emailId": "' + email + '","department": "' + department + '","presentstatus": "' + presentstatus + '","placeofwork": "' + placeofwork + '","bloodgroup": "' + bloodgroup + '","religion": "' + religion + '","subjecthandling": "' + subjecthandling + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffSearch.aspx/GetStaffInfo",
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
            var staffs = xml.find("StaffInfo");

            var row = $("[id*=dgStaffInfo] tr:last-child").clone(true);
            $("[id*=dgStaffInfo] tr").not($("[id*=dgStaffInfo] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditStaffInfo('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteStaffInfo('";
                danchorEnd = "');\">Delete</a>";
            }


            if (staffs.length > 0) {

                $.each(staffs, function () {
                    var staffinfo = $(this);
                    var ehref = eanchor + $(this).find("StaffId").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StaffId").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("EmpCode").text());
                    $("td", row).eq(2).html($(this).find("StaffName").text());
                    $("td", row).eq(3).html($(this).find("DesignationName").text());
                    $("td", row).eq(4).html($(this).find("Placeofwork").text());
                    $("td", row).eq(5).html(ehref).addClass("editacc edit-links");
                    //  $("td", row).eq(5).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgStaffInfo]").append(row);
                    row = $("[id*=dgStaffInfo] tr:last-child").clone(true);
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
            else {

                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");

                $("[id*=dgStaffInfo]").append(row);
                row = $("[id*=dgStaffInfo] tr:last-child").clone(true);
            }
        }

        function EditStaffInfo(StaffId) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                var url = "../Staffs/StaffInfo.aspx?menuId=" + $("[id*=hdnContentMenuId]").val() + "&activeIndex=" + $("[id*=hdnContentActiveIndex]").val() + "&moduleId=" + $("[id*=hdnContentModuleId]").val() + "&id=" + StaffId + "";
                $(location).attr('href', url)
            }
            else {
                $("table.form :input").prop('disabled', true);
                return false;
            }
        }
        function Cancel() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtEmpCode]").val("");
            $("[id*=txtEmpName]").val("");
            $("[id*=ddlDesignation]").val("");
            $("[id*=txtPhoneNo]").val("");
            $("[id*=txtEmail]").val("");
            $("[id*=ddlDesignation]").val("");
            $("[id*=ddlPlace]").val("");
            $("[id*=ddlStatus]").val("");
            $("[id*=ddlSubject]").val("");
            $("[id*=ddlReligion]").val("");
            $("[id*=ddlBloodGroup]").val(""); 
            GetStaffInfo(1);
        };
    </script>
</asp:Content>
<asp:Content ID="ContentHead2" ContentPlaceHolderID="head2" runat="server">
    <!--Autocomplete script starts here -->
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <!--Autocomplete script ends here -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnContentMenuId" runat="server" />
    <asp:HiddenField ID="hdnContentActiveIndex" runat="server" />
    <asp:HiddenField ID="hdnContentModuleId" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Staff Search
            </h2>
            <div class="block john-accord content-wrapper2">
                <div class="block1">
                    <table class="form" width="100%">
                        <tr>
                            <td width="100%">
                                <strong class="searchby">Search By&nbsp;&nbsp;&nbsp;
                                    <label>
                                        <input type="radio" name="Tb1" id="rbtnBasic" value="Basic" checked="checked" onclick="javascript:showDiv();" />Basic</label>
                                    <label>
                                        <input type="radio" name="Tb1" id="rbtnAdvanced" value="Advanced" onclick="javascript:showDiv();" />Advanced</label>
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%">
                                <div id="staff_1" style="display: block;">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="10%">
                                                <label>
                                                    Employee Code :</label>
                                            </td>
                                            <td>
                                                <input type="text" id="testid" value="" style="display: none" />
                                                <asp:TextBox ID="txtEmpCode" CssClass="jsrequired" runat="server" onkeydown="GetStaffInfo(1);" onblur="GetStaffInfo(1);"></asp:TextBox>
                                            </td>
                                            <td width="10%">
                                                <label>
                                                    Employee Name :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtEmpName" CssClass="jsrequired" runat="server" onkeydown="GetStaffInfo(1);" onblur="GetStaffInfo(1);"></asp:TextBox>
                                            </td>
                                            <td width="3%">
                                                <label>
                                                    Sex :</label>
                                            </td>
                                            <td>
                                                <label>
                                                    <input type="radio" name="rb1" id="rbtnMale" value="Male" />Male</label>
                                                <label>
                                                    <input type="radio" name="rb1" id="rbtnFemale" value="Female" />Female</label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="staff_2" style="display: none;">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="9%">
                                                <label>
                                                    Designation :</label>
                                            </td>
                                            <td width="18%">
                                                <asp:DropDownList ID="ddlDesignation" CssClass="" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td width="10%">
                                                <label>
                                                    Phone Number</label>
                                            </td>
                                            <td width="10%">
                                                <asp:TextBox ID="txtPhoneNo" runat="server"></asp:TextBox>
                                            </td>
                                            <td width="5%">
                                                <label>
                                                    Email</label>
                                            </td>
                                            <td width="10%">
                                                <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="9%">
                                                <label>
                                                    Present Status :</label>
                                            </td>
                                            <td width="18%">
                                                <asp:DropDownList ID="ddlStatus" runat="server">
                                                    <asp:ListItem Value="" Text="---Select---" Selected="True"></asp:ListItem>
                                                    <asp:ListItem>Active</asp:ListItem>
                                                    <asp:ListItem>Discontinued</asp:ListItem>
                                                    <asp:ListItem>Resigned</asp:ListItem>
                                                    <asp:ListItem>Suspended</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td width="9%">
                                                <label>
                                                    Place of Work :</label>
                                            </td>
                                            <td width="18%">
                                                <asp:DropDownList ID="ddlPlace" runat="server">
                                                </asp:DropDownList>
                                            </td>
                                            <td width="9%">
                                                <label>
                                                    Department :</label>
                                            </td>
                                            <td width="18%">
                                                <asp:DropDownList ID="ddlDepartment" runat="server">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="9%">
                                                <label>
                                                    Subject Handling :</label>
                                            </td>
                                            <td width="18%">
                                              <asp:DropDownList ID="ddlSubject" runat="server">
                                                        </asp:DropDownList>
                                            </td>
                                            <td width="9%">
                                                <label>
                                                    Religion :</label>
                                            </td>
                                            <td width="18%">
                                                <asp:DropDownList ID="ddlReligion" runat="server">
                                                </asp:DropDownList>
                                            </td>
                                            <td width="9%">
                                                <label>
                                                    Blood Group :</label>
                                            </td>
                                            <td width="18%">
                                                <asp:DropDownList ID="ddlBloodGroup" runat="server">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="col1" width="100%">
                            </td>
                        </tr>
                        <tr>
                            <td class="col1" width="100%">
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" align="center" width="100%">
                                <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStaffInfo(1);">
                                    <span></span>Search</button>
                                &nbsp;
                                <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                    onclick="return Cancel();">
                                    <span></span>Cancel</button>
                                &nbsp;
                                <button id="btnAddNew" type="button" class="btn-icon btn-navy btn-add" style="display: none;"
                                    onclick="AddStudentInfo();">
                                    <span></span>Add New</button>
                                <asp:HiddenField ID="hfStaffId" runat="server" />
                                <asp:HiddenField ID="hfModuleID" runat="server" />
                            </td>
                        </tr>
                        <tr valign="top">
                            <td valign="top">
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="dgStaffInfo" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Sl.No." SortExpression="SlNo">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EmpCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Emp Code" SortExpression="EmpCode">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="StaffName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Staff Name" SortExpression="StaffName">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Designation" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Designation" SortExpression="Designation">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                     <asp:BoundField DataField="Placeofwork" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Place of Work" SortExpression="Placeofwork">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StaffId") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" Visible="false" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StaffId")%>'
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
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetEmployee.ashx?type=code&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            callback: function (obj) { GetEmpByCode(); }
        };
        var options_xml2 = {
            script: function (input) { return "../Handlers/GetEmployee.ashx?type=name&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            callback: function (obj) { GetEmpByName(); }
        };

        var as_xml = new bsn.AutoSuggest('<%= txtEmpCode.ClientID %>', options_xml);
        var as_xml1 = new bsn.AutoSuggest('<%= txtEmpName.ClientID %>', options_xml2);

        function GetEmpByCode() {
            $("[id*=txtEmpName]").val('');
            var staffName = $("[id*=txtEmpName]").val();
            var empCode = $("[id*=txtEmpCode]").val();
            if (empCode != '') {
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffSearch.aspx/GetEmployee",
                    data: '{staffName:"' + staffName + '",empCode:"' + empCode + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEmployeeByCodedSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnEmployeeByCodedSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var employee = xml.find("Employee");

            if (employee.length > 0) {
                $.each(employee, function () {
                    $("[id*=txtEmpName]").val($(this).find("StaffName").text());
                });
            }
            else {
                $("[id*=txtEmpName]").val('');
            }
        }
        function GetEmpByName() {
            $("[id*=txtEmpCode]").val('');
            var staffName = $("[id*=txtEmpName]").val();
            var empCode = $("[id*=txtEmpCode]").val();
            if (staffName != '') {
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffSearch.aspx/GetEmployee",
                    data: '{staffName:"' + staffName + '",empCode:"' + empCode + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEmployeeByNameSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnEmployeeByNameSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var employee = xml.find("Employee");

            if (employee.length > 0) {
                $.each(employee, function () {
                    $("[id*=txtEmpCode]").val($(this).find("EmpCode").text());                   
                });
            }
            else {
                $("[id*=txtEmpCode]").val('');
            }
        }
    </script>
</asp:Content>
