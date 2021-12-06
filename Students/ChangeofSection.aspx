<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ChangeofSection.aspx.cs" Inherits="Students_ChangeofSection" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!--Autocomplete script starts here -->
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <link rel="stylesheet" href="../prettyphoto/css/prettyPhoto.css" type="text/css"
        media="screen" title="prettyPhoto main stylesheet" charset="utf-8" />
    <script src="../prettyphoto/js/jquery.prettyPhoto.js" type="text/javascript" charset="utf-8"></script>
    <!--Autocomplete script ends here -->
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("a[rel^='prettyPhoto']").prettyPhoto();
        });
    </script>
    <script type="text/javascript">

        $(function () {
            //        GetStudentInfos Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetStudentsDetail(1);
            //        GetModuleID('Students/TCSearch.aspx');
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);


        });


        function GetStudentsDetail(pageIndex) {

            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Students/ChangeofSection.aspx/GetChangeofSectionStudList",
                    data: '{"pageIndex":"' + pageIndex + '","regNo":"' + $("[id*=txtRegNo]").val() + '","Class":"' + $("[id*=ddlClass]").val() + '","Section":"' + $("[id*=ddlSection]").val() + '","studentName":"' + $("[id*=txtStudentName]").val() + '"}',
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
                    url: "../Students/ChangeofSection.aspx/GetSectionByClassID",
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
        function GetCount() {
            var Class = $("[id*=ddlClass]").val();
            if (Class != "") {
                $.ajax({
                    type: "POST",
                    url: "../Students/ChangeofSection.aspx/GetSectionByClassID",
                    data: '{ClassID: ' + Class + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetCountSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnGetCountSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var classcount = xml.find("SectionByClass");
            var row = $("[id*=dgClass] tr:last-child").clone(true);
            $("[id*=dgClass] tr").not($("[id*=dgClass] tr:first-child")).remove();

            if (classcount.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("[id*=dgClass]").append(row);
                row = $("[id*=dgClass] tr:last-child").clone(true);
            }
            else {
                $.each(classcount, function () {
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("ClassName").text());
                    $("td", row).eq(2).html($(this).find("SectionName").text());
                    $("td", row).eq(3).html($(this).find("NoofStudents").text());
                    $("[id*=dgClass]").append(row);
                    row = $("[id*=dgClass] tr:last-child").clone(true);
                });
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
            var changeofsectionStudList = xml.find("ChangeofSectionStudList");

            if (changeofsectionStudList.find("regno").length > 0) {
                var row = $("[id*=grdChangeofSection] tr:last-child").clone(true);
                $("[id*=grdChangeofSection] tr").not($("[id*=grdChangeofSection] tr:first-child")).remove();
                var eanchor = ''
                var eanchorEnd = '';
                var danchor = ''
                var danchorEnd = '';
                if ($("[id*=hfEditPrm]").val() == 'false') {
                    eanchor = "<a>";
                    eanchorEnd = "</a>";
                }
                else {
                    eanchor = "<a href=\"javascript:EditStudentInfo('";
                    eanchorEnd = "');\">View</a>";
                }
                $.each(changeofsectionStudList, function () {
                    var regno = $(this).find("regno").text();
                    var studentid = $(this).find("studentId").text();
                    var stname = $(this).find("stname").text();
                    var class1 = $(this).find("classname").text();
                    var classid = $(this).find("classid").text();
                    var section1 = $(this).find("sectionname").text();
                    var sectionid = $(this).find("sectionid").text();
                    $.ajax({
                        type: "POST",
                        url: "../Students/ChangeofSection.aspx/GetChangeofSectionStudClassbySection",
                        data: '{"regNo":"' + regno + '","Classid":"' + classid + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            row.addClass("even");
                            var ehref = eanchor + studentid + eanchorEnd;
                            $("td", row).eq(0).html(regno);
                            $("td", row).eq(1).html(stname);
                            $("td", row).eq(2).html(class1);
                            $("td", row).eq(3).html(section1);
                            $("td", row).eq(4).html(response.d);
                            $("td", row).eq(5).html(ehref).addClass("editacc view-links");
                            $("[id*=grdChangeofSection]").append(row);
                            row = $("[id*=grdChangeofSection] tr:last-child").clone(true);
                        },
                        failure: function (response) {
                            AlertMessage('info', response.d);
                        },
                        error: function (response) {
                            AlertMessage('info', response.d);
                        }
                    });

                });

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
                var pager = xml.find("Pager");
                if (parseInt(pager.find("RecordCount").text()) > 0)
                    GetStudentsDetail(parseInt(pager.find("PageIndex").text()) - 1);
                else {
                    var row = $("[id*=grdChangeofSection] tr:last-child").clone(true);
                    $("[id*=grdChangeofSection] tr").not($("[id*=grdChangeofSection] tr:first-child")).remove();
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("No Result Found");
                    $("td", row).eq(3).html("");
                    $("td", row).eq(4).html("");
                    $("td", row).eq(5).html("");
                    $("[id*=grdChangeofSection]").append(row);
                }
            }

        };


        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetStudentsDetail(parseInt($(this).attr('page')));
        });

        function updateSection(regno, classid) {
            var sectionId = $('#' + regno).val();
            var academicYear = $("[name*=radlAcademicYear]:checked").val();
            if (jConfirm('Are you sure to change the section ?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Students/ChangeofSection.aspx/UpdateStudentSection",
                        data: '{"regNo":"' + regno + '","sectionId":"' + sectionId + '","Classid":"' + classid + '","AcademicYearId":"' + academicYear + '","userId":"' + $('#<%= hdnUserId.ClientID %>').val() + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d == "Updated") {
                                AlertMessage('success', 'Updated');
                                GetStudentsDetail(parseInt($("[id*=currentPage]").text()));
                            }
                            else if (response.d == "Update Failed") {
                                AlertMessage('fail', 'Update');
                            }
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
            $("[id*=txtRegNo]").val("");
            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            $("[id*=txtStudentName]").val("");
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Change of Section</h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table class="form">
                    <tr>
                        <td>
                            <div id="stud_1" style="display: block;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="9%">
                                            <label>
                                                Register No :</label>
                                        </td>
                                        <td width="15%">
                                            <asp:TextBox ID="txtRegNo" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Class :</label>
                                        </td>
                                        <td width="15%">
                                            <asp:DropDownList ID="ddlClass" runat="server" onchange="javascript:GetSectionByClass(this.value);"
                                                AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                No of Students :</label>
                                        </td>
                                        <td width="13%" class="">
                                            <a href="#dvCount" style="color: Red; text-decoration: blink;" rel="prettyPhoto[]"
                                                title="No of Students">Click here to view</a>
                                            <div id="dvCount" title="No of Students" style="display: none;">
                                                <asp:GridView ID="dgClass" runat="server" Width="75%" AutoGenerateColumns="False"
                                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                    <Columns>
                                                        <asp:BoundField DataField="SlNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="SlNo" SortExpression="SlNo">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="ClassName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Class" SortExpression="ClassName">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="SectionName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="SectionName" SortExpression="SectionName">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="NoofStudents" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="No of Students" SortExpression="NoofStudents">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Section :</label>
                                        </td>
                                        <td width="16%">
                                            <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                Student Name :</label>
                                        </td>
                                        <td width="18%">
                                            <input type="text" id="testid" value="" style="display: none" />
                                            <asp:TextBox ID="txtStudentName" CssClass="bloodgroup" runat="server"></asp:TextBox>
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
                            <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStudentsDetail(1);">
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
                        <td valign="top" width="14%">
                            <span><b>Academic Year Belong To :</b></span>
                        </td>
                        <td valign="top" width="15%">
                            <asp:RadioButtonList ID="radlAcademicYear" RepeatDirection="Horizontal" runat="server">
                            </asp:RadioButtonList>
                        </td>
                        <td valign="top" width="70%">
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="grdChangeofSection" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField HeaderText="Register No" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Student Name" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Class" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="From Section" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:TemplateField HeaderText="To Section" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <select id="ddlChangeofSection" onchange="changeStatus();">
                                            </select>
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
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetStudent.ashx?type=code&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            callback: function (obj) { GetStudentByCode(); }
        };
        var options_xml2 = {
            script: function (input) { return "../Handlers/GetStudent.ashx?type=name&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            callback: function (obj) { GetStudentByName(); }
        };

        var as_xml = new bsn.AutoSuggest('<%= txtRegNo.ClientID %>', options_xml);
        var as_xml1 = new bsn.AutoSuggest('<%= txtStudentName.ClientID %>', options_xml2);

        function GetStudentByCode() {
            $("[id*=txtStudentName]").val('');
            var StudentName = $("[id*=txtStudentName]").val();
            var RegNo = $("[id*=txtRegNo]").val();
            if (RegNo != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/ConcessionApproval.aspx/GetStudent",
                    data: '{StudentName:"' + StudentName + '",RegNo:"' + RegNo + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnStudentByCodeSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnStudentByCodeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var student = xml.find("Student");

            if (student.length > 0) {
                $.each(student, function () {
                    $("[id*=txtStudentName]").val($(this).find("StudentName").text());
                });
            }
            else {
                $("[id*=txtStudentName]").val('');
            }
        }
        function GetStudentByName() {
            $("[id*=txtRegNo]").val('');
            var StudentName = $("[id*=txtStudentName]").val();
            var RegNo = $("[id*=txtRegNo]").val();
            if (StudentName != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/ConcessionApproval.aspx/GetStudent",
                    data: '{StudentName:"' + StudentName + '",RegNo:"' + RegNo + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnStudentByNameSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {    
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnStudentByNameSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var student = xml.find("Student");

            if (student.length > 0) {
                $.each(student, function () {
                    $("[id*=txtRegNo]").val($(this).find("RegNo").text());
                });
            }
            else {
                $("[id*=txtRegNo]").val('');
            }
        }
    </script>
</asp:Content>
