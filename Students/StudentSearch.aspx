<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StudentSearch.aspx.cs" Inherits="Students_StudentSearch" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <script type="text/javascript">

        $(function () {
            //        GetStudentInfos Function on page load

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
        function goto() {
            if ($("[id*=txtpage]").val() != null && $("[id*=txtpage]").val() != "") {
                GetStudentInfo(parseInt($("[id*=txtpage]").val()));
                $("[id*=txtpage]").val('');
            }
        }
        var Academic = "";
        function GetStudentInfo(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var SearchTag;
                if ($("[id*=rbtnBasic]").is(':checked')) {
                    SearchTag = "Basic";
                }

                else if ($("[id*=rbtnAdvanced]").is(':checked')) {
                    SearchTag = "Advanced";
                }
                var StudentID = "", regno = "", StudentName = "", AdminNo = "", Classname = "", Sectionname = "", Name = "", Gender = "", PhoneNo = "", Hostel = "", HostelName = "", BusFacility = "", RouteCode = "", RouteName = "", sStatus = "";
                StudentID = $("[id*=hfStudentID]").val();
                if (SearchTag == "Basic") {
                    regno = $("[id*=txtRegNo]").val();
                    StudentName = $("[id*=txtStudentName]").val();
                    AdminNo = $("[id*=txtAdminNo]").val();
                }

                else if (SearchTag == "Advanced") {

                    var Class = $("[id*=ddlClass]").val();
                    var Section = $("[id*=ddlSection]").val();
                    Classname = $("[id*=ddlClass] option[value='" + Class + "']").html();
                    Sectionname = $("[id*=ddlSection] option[value='" + Section + "']").html();


                    StudentID = $("[id*=ddlStudentName]").val();
                    Gender;
                    if ($("[id*=rbtnMale]").is(':checked')) {
                        Gender = "M";
                    }

                    else if ($("[id*=rbtnFemale]").is(':checked')) {
                        Gender = "F";
                    }
                    PhoneNo = $("[id*=txtPhoneNo]").val();

                    Hostel;
                    if ($("[id*=rbtnHostelYes]").is(':checked')) {
                        Hostel = "Y";
                    }

                    else if ($("[id*=rbtnHostelNo]").is(':checked')) {
                        Hostel = "N";
                    }

                    HostelName = $("[id*=txtHostelName]").val();

                    BusFacility;
                    if ($("[id*=rbtnBusYes]").is(':checked')) {
                        BusFacility = "Y";
                    }

                    else if ($("[id*=rbtnBusNo]").is(':checked')) {
                        BusFacility = "N";
                    }
                    RouteCode = $("[id*=txtRouteCode]").val();
                    RouteName = $("[id*=txtRouteName]").val();
                    sStatus = $("[id*=ddlStatus]").val();

                }
                if (Classname == "---Select---") {
                    Classname = "";

                }
                if (Sectionname == "---Select---") {
                    Sectionname = "";

                }
                if (StudentID == "---Select---") {
                    StudentID = "";
                }
                if (Academic == "---Select---") {
                    Academic = "";
                }
                if (sStatus == "---Select---") {
                    sStatus = "";
                }
                var parameters = '{pageIndex: ' + pageIndex + ',"studentid": "' + StudentID + '","regno": "' + regno + '","studentname": "' + StudentName + '","adminno": "' + AdminNo + '","classname": "' + Classname + '","section": "' + Sectionname + '","gender": "' + Gender + '","phoneno": "' + PhoneNo + '","hostel": "' + Hostel + '","hostelname": "' + HostelName + '","busfacility": "' + BusFacility + '","routecode": "' + RouteCode + '","routename": "' + RouteName + '","sStatus": "' + sStatus + '","Academic": "' + Academic + '"}';

                $.ajax({
                    type: "POST",
                    url: "../Students/StudentSearch.aspx/GetStudentInfo",
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
            var StudentInfoes = xml.find("StudentInfo");

            var row = $("[id*=dgStudentInfo] tr:last-child").clone(true);
            $("[id*=dgStudentInfo] tr").not($("[id*=dgStudentInfo] tr:first-child")).remove();
            var vanchor = ''
            var vanchorEnd = '';
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfViewPrm]").val() == 'false') {
                vanchor = "<a>";
                vanchorEnd = "</a>";
            }
            else {
                vanchor = "<a  href=\"javascript:ViewStudentInfo('";
                vanchorEnd = "');\">View</a>";
            }
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditStudentInfo('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:UpdateCoCurricularpayment('";
                danchorEnd = "');\">Co-Curricular Payment</a>";
            }

            if (StudentInfoes.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Record Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("").removeClass("viewacc edit-links");
                $("td", row).eq(7).html("").removeClass("editacc edit-links");
             //   $("td", row).eq(8).html("").removeClass("editacc edit-links");
                //   $("td", row).eq(6).html("").removeClass("deleteacc delete-links"); ;

                $("[id*=dgStudentInfo]").append(row);
                row = $("[id*=dgStudentInfo] tr:last-child").clone(true);

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

                $.each(StudentInfoes, function () {
                    var iStudentInfo = $(this);
                    var vhref = vanchor + $(this).find("StudentID").text() + vanchorEnd;
                    var ehref = eanchor + $(this).find("StudentID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("StudentID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RowNumber").text());
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("StudentName").text());
                    $("td", row).eq(3).html($(this).find("Class").text());
                    $("td", row).eq(4).html($(this).find("Section").text());
                    $("td", row).eq(5).html($(this).find("Status").text());
                    $("td", row).eq(6).html(vhref).addClass("viewacc view-links");
                    $("td", row).eq(7).html(ehref).addClass("editacc edit-links");
                  //  $("td", row).eq(8).html(dhref).addClass("editacc edit-links");

                    //  $("td", row).eq(6).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgStudentInfo]").append(row);
                    row = $("[id*=dgStudentInfo] tr:last-child").clone(true);
                });
                if ($("[id*=hfViewPrm]").val() == 'false') {
                    $('.viewacc').hide();
                }
                else {
                    $('.viewacc').show();
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
            }
        };
        function GetSectionByClass(ID) {
            $.ajax({
                type: "POST",
                url: "../Students/StudentSearch.aspx/GetSectionByClassID",
                data: '{ClassID: ' + ID + '}',
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

        function GetAcademicID(ID) {
            if (ID) {
                Academic = ID;
            }
            else {
                Academic = $("[id*=ddlAcademicYear]").val();
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
                $("[id*=dgStudentInfo] tr:has(td)").remove();
                $("[id*=dgStudentInfo]").append("<tr class=\"even\"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");

            });
            GetStudentBySection();
        };

        function GetStudentBySection() {
            var Class = $("[id*=ddlClass]").val();
            var Section = $("[id*=ddlSection]").val();
            var Sectionname = "";
            var Classname = "";
            Classname = $("[id*=ddlClass] option[value='" + Class + "']").html();
            if (Section != "") {
                Sectionname = $("[id*=ddlSection] option[value='" + Section + "']").html();
            }
            else {
                Sectionname = "";
            }

            if (Classname == "---Select---") {
                Classname = "";

            }
            if (Sectionname == "---Select---") {
                Sectionname = "";

            }
            $.ajax({
                type: "POST",
                url: "../Students/StudentSearch.aspx/GetStudentBySection",
                data: '{"Class": "' + Classname + '","Section": "' + Sectionname + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetStudentBySectionSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetStudentBySectionSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("StudentBySection");
            var select = $("[id*=ddlStudentName]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var StudentID = $(this).find("StudentID").text();
                var StudentName = $(this).find("StudentName").text();
                select.append($("<option>").val(StudentID).text(StudentName));
                $("[id*=dgStudentInfo] tr:has(td)").remove();
                $("[id*=dgStudentInfo]").append("<tr class=\"even\"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
            });
        };



        // Delete StudentInfo
        function DeleteStudentInfo(id) {
            var parameters = '{"StudentInfoID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Students/StudentSearch.aspx/DeleteStudentInfo",
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

        function EditStudentInfo(StudentInfoID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetStudentInfo",
                    data: '{studentid: ' + StudentInfoID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var url = "../Students/StudentInfo.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&StudentID=" + StudentInfoID + "";
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

        function ViewStudentInfo(StudentInfoID) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
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

        function UpdateCoCurricularpayment(StudentInfoID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Students/StudentInfo.aspx/GetStudentInfo",
                    data: '{studentid: ' + StudentInfoID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var url = "../Students/CoCurricularPayment.aspx?menuId=" + $("[id*=hdnMenuIndex]").val() + "&activeIndex=" + $("[id*=hdnIndex]").val() + "&moduleId=" + $("[id*=hfModuleID]").val() + "&StudentID=" + StudentInfoID + "";
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



        function GetModuleID(path) {
            $.ajax({
                type: "POST",
                url: "../Students/StudentSearch.aspx/GetModuleId",
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
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("ModuleMenusByPath");
            $.each(cls, function () {
                $("[id*=hfModuleID]").val($(this).find("modulemenuid").text());
                $("[id*=hdnMenuIndex]").val($(this).find("menuid").text())
            });
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
            $("[id*=txtClassName]").val("");
            $("[id*=ddlSchoolType]").val("");
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
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=stud_1]").slideDown("fast");
            $("[id*=stud_2]").slideUp("fast");
        });
        function showDiv() {
            if (document.getElementById('rbtnBasic').checked == true) {
                $("[id*=stud_1]").slideDown("fast");
                $("[id*=stud_2]").slideUp("fast");
            }
            if (document.getElementById('rbtnAdvanced').checked == true) {
                $("[id*=stud_2]").slideDown("fast");
                $("[id*=stud_1]").slideUp("fast");
            }
        }

        function Cancel() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtRegNo]").val("");
            $("[id*=txtAdminNo]").val("");
            $("[id*=txtStudentName]").val("");
            $("[id*=ddlClass]").val("");
            $("[id*=txtPhoneNo]").val("");
            $("[id*=ddlSection]").val("");
            $("[id*=ddlStudentName]").val("");
            GetStudentInfo(1);
        };
      
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Student Search
            </h2>
            <div class="block john-accord content-wrapper2">
                <div class="block1">
                    <table class="form" width="100%">
                        <tr>
                            <td>
                                <strong class="searchby">Search By&nbsp;&nbsp;&nbsp;
                                    <label>
                                        <input type="radio" name="Tb1" id="rbtnBasic" value="Basic" checked="checked" onclick="javascript:showDiv();" />Basic</label>
                                    <label>
                                        <input type="radio" name="Tb1" id="rbtnAdvanced" value="Advanced" onclick="javascript:showDiv();" />Advanced</label>
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="stud_1" style="display: block;">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="9%">
                                                <label>
                                                    Register No :</label>
                                            </td>
                                            <td width="18%">
                                                <input type="text" id="testid" value="" style="display: none" />
                                                <asp:TextBox ID="txtRegNo" CssClass="bloodgroup" onkeydown="GetStudentInfo(1);" onblur="GetStudentInfo(1);"
                                                    runat="server"></asp:TextBox>
                                            </td>
                                            <td width="11%">
                                                <label>
                                                    Admission No :</label>
                                            </td>
                                            <td width="20%">
                                                <asp:TextBox ID="txtAdminNo" CssClass="bloodgroup" onkeydown="GetStudentInfo(1);"
                                                    onblur="GetStudentInfo(1);" runat="server"></asp:TextBox>
                                            </td>
                                            <td width="10%">
                                                <label>
                                                    Student Name :</label>
                                            </td>
                                            <td width="32%">
                                                <asp:TextBox ID="txtStudentName" CssClass="" onkeydown="GetStudentInfo(1);" onblur="GetStudentInfo(1);"
                                                    runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="stud_2" style="display: none;">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="9%">
                                                <label>
                                                    Class :</label>
                                            </td>
                                            <td width="18%">
                                                <asp:DropDownList ID="ddlClass" CssClass="" runat="server" AppendDataBoundItems="True"
                                                    onchange="GetSectionByClass(this.value);">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td width="11%">
                                                <label>
                                                    Section :</label>
                                            </td>
                                            <td width="20%">
                                                <asp:DropDownList ID="ddlSection" CssClass="" runat="server" AppendDataBoundItems="True"
                                                    onchange="GetStudentBySection();">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td width="10%">
                                                <label>
                                                    Student Name :</label>
                                            </td>
                                            <td width="32%">
                                                <asp:DropDownList ID="ddlStudentName" CssClass="" runat="server" AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Gender :</label>
                                            </td>
                                            <td>
                                                <label>
                                                    <input type="radio" name="rb1" id="rbtnMale" value="Male" />Male</label>
                                                <label>
                                                    <input type="radio" name="rb1" id="rbtnFemale" value="Female" />Female</label>
                                            </td>
                                            <td>
                                                <label>
                                                    Phone No :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtPhoneNo" CssClass="" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Student Status :</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlStatus" CssClass="jsrequired" runat="server">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    <asp:ListItem Value="N">New</asp:ListItem>
                                                    <asp:ListItem Value="C">Current</asp:ListItem>
                                                    <asp:ListItem Value="O">Old</asp:ListItem>
                                                    <asp:ListItem Value="D">Discontinued</asp:ListItem>
                                                    <asp:ListItem Value="F">Temporary</asp:ListItem>
                                                     <asp:ListItem Value="E">Cancelled</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="9%">
                                                <label>
                                                    Hostel :</label>
                                            </td>
                                            <td width="18%">
                                                <label>
                                                    <input type="radio" name="hb1" id="rbtnHostelYes" value="Yes" />Yes</label>
                                                <label>
                                                    <input type="radio" name="hb1" id="rbtnHostelNo" value="No" />No</label>
                                            </td>
                                            <td width="11%">
                                                <label>
                                                    Hostel Name :</label>
                                            </td>
                                            <td width="20%">
                                                <asp:TextBox ID="txtHostelName" CssClass="letterswithbasicpunc" runat="server"></asp:TextBox>
                                            </td>
                                            <td width="10%">
                                                <label>
                                                    Academic Year :</label>
                                            </td>
                                            <td width="32%">
                                                <asp:DropDownList ID="ddlAcademicYear" CssClass="" runat="server" onchange="GetAcademicID(this.value);"
                                                    AppendDataBoundItems="True">
                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Bus Route :</label>
                                            </td>
                                            <td>
                                                <label>
                                                    <input type="radio" name="bb1" id="rbtnBusYes" value="Yes" />Yes</label>
                                                <label>
                                                    <input type="radio" name="bb1" id="rbtnBusNo" value="No" />No</label>
                                            </td>
                                            <td>
                                                <label>
                                                    Route Code :
                                                </label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtRouteCode" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                            </td>
                                            <td>
                                                <label>
                                                    Route Name :</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtRouteName" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="col1">
                                <table style="display:none;" class="form" width="100%">
                                    <tr>
                                        <td height="30" align="center" colspan="3" style="width: 45%">
                                            <label>
                                                Select the file to upload :</label>&nbsp;<asp:FileUpload ID="FileUpload1"
                                                    runat="server" />
                                            <asp:Button ID="Button1" runat="server" ValidationGroup="vg1" CssClass="btn-icon button-generate"
                                                OnClick="Button1_Click" Text="Upload" />
                                            <br />
                                            <asp:RegularExpressionValidator ValidationGroup="vg1" ID="RegularExpressionValidator1"
                                                runat="server" ControlToValidate="FileUpload1" Display="Dynamic" ErrorMessage="Please select a valid Excel file."
                                                ForeColor="Red" ValidationExpression="([a-zA-Z0-9\s_\\.\-:])+(.xls)$" />
                                        </td>
                                        <td height="30" align="center" colspan="3" style="width: 45%">
                                            <label>
                                                Select the concession file to upload :</label>&nbsp;<asp:FileUpload ID="FileUpload2"
                                                    runat="server" />
                                            <asp:Button ID="Button2" runat="server" ValidationGroup="vg1" CssClass="btn-icon button-generate"
                                                OnClick="Button2_Click" Text="Upload" />
                                            <br />
                                            <asp:RegularExpressionValidator ValidationGroup="vg1" ID="RegularExpressionValidator2"
                                                runat="server" ControlToValidate="FileUpload1" Display="Dynamic" ErrorMessage="Please select a valid Excel file."
                                                ForeColor="Red" ValidationExpression="([a-zA-Z0-9\s_\\.\-:])+(.xls)$" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="3" height="30" style="width: 45%">
                                            <strong>(or)</strong>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="col1">
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" align="center">
                                <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStudentInfo(1);">
                                    <span></span>Search</button>
                                &nbsp;
                                <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                    onclick="return Cancel();">
                                    <span></span>Cancel</button>
                                &nbsp;
                                <button id="btnAddNew" type="button" class="btn-icon btn-navy btn-add" style="display: none;"
                                    onclick="AddStudentInfo();">
                                    <span></span>Add New</button>
                                <asp:HiddenField ID="hfStudentID" runat="server" />
                                <asp:HiddenField ID="hfModuleID" runat="server" />
                            </td>
                        </tr>
                        <tr valign="top">
                            <td align="right" valign="top">
                                &nbsp; Goto Page No :
                                <asp:TextBox ID="txtpage" runat="server" Width="50px"></asp:TextBox>
                                <button id="btngoto" type="button" class="btn-icon btn-navy btn-add" onclick="goto();">
                                    <span></span>Go</button>
                            </td>
                        </tr>
                    </table>
                </div>
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
                                    <asp:BoundField DataField="Status" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Status" SortExpression="Status">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                     <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod viewacc">
                                        <HeaderTemplate>
                                            View</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkView" runat="server" Text="View" CommandArgument='<%# Eval("StudentID") %>'
                                                CommandName="View" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Edit</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("StudentID") %>'
                                                CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <%--   <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod editacc">
                                        <HeaderTemplate>
                                            Action</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkCocurricularpayment" runat="server" Text="Co-Curricular Payment"
                                                CommandArgument='<%# Eval("StudentID") %>' CommandName="Edit" CausesValidation="false"
                                                CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                        HeaderStyle-CssClass="sorting_mod deleteacc">
                                        <HeaderTemplate>
                                            Delete</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("StudentID")%>'
                                                CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>   --%>
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
            script: function (input) { return "../Handlers/GetStudent.ashx?type=code&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            timeout: 10000,
            callback: function (obj) { GetStudentByCode(); }
        };
        var options_xml2 = {
            script: function (input) { return "../Handlers/GetStudent.ashx?type=name&input=" + input + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15,
            timeout: 10000,
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
                    url: "../Students/StudentSearch.aspx/GetStudent",
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
                    url: "../Students/StudentSearch.aspx/GetStudent",
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
      <script src="../prettyphoto/js/prettyPhoto.js" type="text/javascript"></script>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("a[rel^='prettyPhoto']").prettyPhoto();
        });
    </script>
</asp:Content>
