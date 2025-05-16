<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="TCSearch.aspx.cs" Inherits="Students_TCSearch" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!--Autocomplete script starts here -->
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <%="<link href='" + ResolveUrl("~/css/managefees.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
    <!--Autocomplete script ends here -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript">


        $(function () {
            //        GetStudentInfos Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')

                $('#rbtnnewTC').prop('checked', true);
            GetModuleMenuID('Students/TransferCertificate.aspx');


            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

            setDatePicker('<%= txtDupDOB.ClientID%>');
        });

        var gender = "";



        function GetStudentsDetail(pageIndex) {

            if ($("[id*=hfViewPrm]").val() == 'true') {
                if ($("[id*=rbtnnewTC]").is(':checked')) {
                    $.ajax({
                        type: "POST",
                        url: "../Students/TCSearch.aspx/GetStudentsTCDetail",
                        data: '{"pageIndex":"' + pageIndex + '","Regno":"' + $("[id*=txtRegNo]").val() + '","AdminNo":"' + $("[id*=txtAdminNo]").val() + '","gender":"' + $("[name*=rbGender]:checked").val() + '","Class":"' + $("[id*=ddlClass]").val() + '","Section":"' + $("[id*=ddlSection]").val() + '","StudentName":"' + $("[id*=txtStudentName]").val() + '"}',
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
                else if ($("[id*=rbtnoldTC]").is(':checked')) {

                    var gend = "";
                    if ($("[name*=rbdupGender]:checked").val() != "undefined")
                        gend = $("[name*=rbdupGender]:checked").val();

                    $.ajax({
                        type: "POST",
                        url: "../Students/TCSearch.aspx/GetStudentsOLDTC",
                        data: '{"pageIndex":"' + pageIndex + '","Regno":"' + $("[id*=txtDupRegno]").val() + '","AdminNo":"' + $("[id*=txtAdmissionNo]").val() + '","leaveYear":"' + $("[id*=ddlDupYear]").val() + '","gender":"' + gend + '","Class":"' + $("[id*=ddlDupClass]").val() + '","Section":"' + $("[id*=ddlDupSection]").val() + '","StudentName":"' + $("[id*=ddlDupStudent]").val() + '","parent":"' + $("[id*=txtDupParent]").val() + '","DOB":"' + $("[id*=txtDupDOB]").val() + '"}',
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

            }
            else {
                return false;
            }
        }


        function OnSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var admissionStudList = xml.find("StudentInfo");
            var regno = "";
            var DueStatusHtml = "";
       
            var tcOptionsStatus = "";


            if (admissionStudList.find("regno").length > 0) {



                var row = $("[id*=grdStudentTCInfo] tr:last-child").clone(true);
                $("[id*=grdStudentTCInfo] tr").not($("[id*=grdStudentTCInfo] tr:first-child")).remove();


                $.each(admissionStudList, function () {

                    regno = $(this).find("regno").text();

                    if ($(this).find("duestatus").text() == "Pending") {
                        DueStatusHtml = '<span class="feepending" > <a href="#" onclick="ShowFeeDueList(\'' + regno + '\',\'' + $(this).find("active").text() + '\');">Pending</a></span>';
                    }
                    else {
                        DueStatusHtml = '<span class="nodue" >' + $(this).find("duestatus").text() + '</span>';
                    }
                     
                    if ($(this).find("ApporvalStatus").text() == "1")
                        ApporvalStatus = "-";
                    else if ($(this).find("ApporvalStatus").text() == "2")
                        ApporvalStatus = "Pending";
                    else
                        if (parseInt($(this).find("tcoptions").text()) > 3)
                            ApporvalStatus = "Approved";
                        else
                            ApporvalStatus = "Pending";

                    if ($(this).find("tcoptions").text() == "2") {
                        tcOptionsStatus = "<a href=\"../Students/TransferCertificate.aspx?menuId=" + $("[id*=hfAcdMenuId]").val() + "&activeIndex=0&moduleId=" + $("[id*=hfAcdModuleID]").val() + "&regno=" + regno + "\"><span class='tcsend'> View TC | </span> </a>";
                        tcOptionsStatus += "<a href='#' onclick='SendForApporval(\"" + regno + "\")' ><span class='tcsend'> Send For Appoval </span> </a>";
                    }
                    else if ($(this).find("tcoptions").text() == "3")
                        tcOptionsStatus = "<span class='tcwait'>Waiting For Appoval</span> ";
                    else if ($(this).find("tcoptions").text() == "1")
                        tcOptionsStatus = "<a href=\"../Students/TransferCertificate.aspx?menuId=" + $("[id*=hfAcdMenuId]").val() + "&activeIndex=0&moduleId=" + $("[id*=hfAcdModuleID]").val() + "&regno=" + regno + "\"><span class='tcsend'> Generate TC </span> </a>";

                    else {
                        if ($(this).find("active").text().toLowerCase() != "o")
                            tcOptionsStatus = "<a href='#' onclick='PrintTC(\"" + regno + "\")' ><span class='tcsend'> Print TC </span> </a>";
                        else
                            tcOptionsStatus = "<a href='#' onclick='DuplicateTC(\"" + regno + "\");' ><span class='tcsend'>Duplicate TC</span> </a>";
                    }

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("row").text());
                    $("td", row).eq(1).html(regno);
                    $("td", row).eq(2).html($(this).find("adminno").text());
                    $("td", row).eq(3).html($(this).find("stname").text());
                    $("td", row).eq(4).html($(this).find("classname").text());
                    $("td", row).eq(5).html($(this).find("sectionname").text());
                    $("td", row).eq(6).html(DueStatusHtml);
                    $("td", row).eq(7).html(ApporvalStatus);
                    $("td", row).eq(8).html(tcOptionsStatus);

                    $("[id*=grdStudentTCInfo]").append(row);
                    row = $("[id*=grdStudentTCInfo] tr:last-child").clone(true);
                    regno = "";

                });



            }
            else {
                var pager = xml.find("Pager");
                if (parseInt(pager.find("RecordCount").text()) > 0)
                    GetStudentsDetail(parseInt(pager.find("PageIndex").text()) - 1);
                else {
                    var row = $("[id*=grdStudentTCInfo] tr:last-child").clone(true);
                    $("[id*=grdStudentTCInfo] tr").not($("[id*=grdStudentTCInfo] tr:first-child")).remove();
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("");
                    $("td", row).eq(3).html("");
                    $("td", row).eq(4).html("");
                    $("td", row).eq(5).html("No Result Found");
                    $("td", row).eq(6).html("");
                    $("td", row).eq(7).html("");
                    $("td", row).eq(8).html("");
                    $("td", row).eq(9).html("");
                    $("[id*=grdStudentTCInfo]").append(row);
                }
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


        function PrintTC(regno) {
            var parameters = '{"pregno":"' + regno + '"}';
            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/printTc",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnPrintSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
            GetStudentsDetail(1);
        }

        function OnPrintSuccess(response) {

            if (response.d != '') {
                $(".printBulkTCContent").html(response.d);

                $(".printBulkTCContent").printElement(
            {
                leaveOpen: true,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'
            }
            });
            }
            else {
                AlertMessage('info', 'Please check Duplicate TC');
            }
            GetStudentsDetail(1);
        }


        function DuplicateTC(regno) {
            var parameters = '{"pregno":"' + regno + '"}';
            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/printDuplicateTc",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnDuplicateTCPrintSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnDuplicateTCPrintSuccess(response) {

            if (response.d != '') {
                $(".printBulkTCContent").html(response.d);

                $(".printBulkTCContent").printElement(
            {
                async: false,
                leaveOpen: true,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'
            }
            });
            }
            else {
                AlertMessage('info', 'Please check Duplicate TC');
            }
           // GetStudentsDetail(1);
            return false;
        }



        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetStudentsDetail(parseInt($(this).attr('page')));
        });


    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=stud_1]").slideDown("fast");
            $("[id*=stud_2]").slideUp("fast");

            //           bulk Section Datepicker starts
            setDatePicker("[id*=txtBulkTCStudLateDate]");
            setDatePicker("[id*=txtBulkTCAppDate]");
            setDatePicker("[id*=txtBulkTCDate]");
            //           bulk Section Datepicker ends
        });
        function showDiv() {
            if (document.getElementById('rbtnnewTC').checked == true) {
                $("[id*=stud_1]").slideDown("fast");
                $("[id*=stud_2]").slideUp("fast");
                $("[id*=divBulkSection]").show("fast");
            }
            if (document.getElementById('rbtnoldTC').checked == true) {
                $("[id*=stud_2]").slideDown("fast");
                $("[id*=stud_1]").slideUp("fast");
                $("[id*=divBulkSection]").hide("fast");

            }
            GetStudentsDetail(1);
        }

        function Cancel() {
            $('#aspnetForm').validate().resetForm();

        };     
    </script>
    <script type="text/javascript">
        function GetDupStudent() {
            var dupYear = $("[id*=ddlDupYear]").val();

            var dupClass = $("[id*=ddlDupClass]").val();
            var dupSection = $("[id*=ddlDupSection]").val();
            if (dupYear == "")
                dupYear = -1;


            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/GetStudentDup",
                data: '{"dupYear": "' + dupYear + '","dupClass":"' + dupClass + '","dupSection":"' + dupSection + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetDupStudent,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetDupStudent(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("Students");
            var select = $("[id*=ddlDupStudent]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var StudentID = $(this).find("StudentID").text();
                var StudentName = $(this).find("StudentName").text();
                select.append($("<option>").val(StudentID).text(StudentName));
            });
            GetStudentsDetail(1);
        };

        function GetDupSection(ID) {
            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/GetSectionByClassID",
                data: '{ClassID: ' + ID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetSectionByDupClassSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetSectionByDupClassSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("SectionByClass");
            var select = $("[id*=ddlDupSection]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));

            });
            GetStudentsDetail(1);
        };

        function GetSection(ID) {
            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/GetSectionByClassID",
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

        };


     

 
    </script>
    <script type="text/javascript">

        function GetSectionByClass(ID) {
            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/GetSectionByClassID",
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
            GetStudentsDetail(1);
        };


    </script>
    <script type="text/javascript">
        function GetModuleMenuID(path) {
            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/GetModuleMenuId",
                data: '{"path": "' + path + '","UserId":"' + $("[id*=hdnUserId]").val() + '"}',
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
            var modmenu = xml.find("ModuleMenu");
            $("[id*=hfAcdMenuId]").val(modmenu.find("menuid").text());
            $("[id*=hfAcdModuleID]").val(modmenu.find("modulemenuid").text());
            GetStudentsDetail(1);
        }


    </script>
    <script type="text/javascript">

        function ShowFeeDueList(regNo, activeStatus) {
            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/GetFeePendingList",
                data: '{"RegNo": "' + regNo + '","Active":"' + activeStatus + '","AcademicId":"' + $('[id*=hdnAcademicYearId]').val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: DisplayPendingList,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function DisplayPendingList(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var billMaster = xml.find("Table");
            var studentBill = xml.find("Table1");
            var totAMt = xml.find("Table2");
            var S_No = 1;
            //  $("[id*=tblViewBill] tr").not($("[id*=tblViewBill] tr:first-child")).remove();
            $("[id*=tblViewBill] tr").remove();

            $.each(billMaster, function () {
                $("[id*=lblRegNo]").html($(this).find("RegNo").text());
                $("[id*=lblStudentName]").html($(this).find("StudentName").text());
                $("[id*=lblClassName]").html($(this).find("Class").text());
                $("[id*=lblSection]").html($(this).find("Section").text());
            });

            $.each(studentBill, function () {
                var row = "<tr><td class=\"billHead\" width=\"8%\" height=\"25\" align=\"center\">" + S_No + "</td>" +
                          "<td class=\"billHead\" width=\"54%\">" + $(this).find("feesheadname").text() + "</td>" +
                          "<td class=\"billHeadAmt\"  width=\"54%\">" + $(this).find("amount").text() + "</td></tr>";
                $("[id*=tblViewBill]").append(row);
                S_No += 1;
            });

            $.each(totAMt, function () {
                $("[id*=lblTotAmt]").html($(this).find("TotalAomunt").text());

            });

            $('#divFeesPendingList').css("display", "block");
        }

        function closePendingList() {
            $('#divFeesPendingList').css("display", "none");
        }
    </script>
    <script type="text/javascript">

        function SendForApporval(regNo) {

            $.ajax({
                type: "POST",
                url: "../Students/TCSearch.aspx/SendForApporval",
                data: '{"RegNo": "' + regNo + '","AcademicId":"' + $('[id*=hdnAcademicYearId]').val() + '","userId":"' + $('#<%= hdnUserId.ClientID %>').val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == "1")
                        AlertMessage('success', "Send For Apporval");
                    else
                        AlertMessage('fail', "Failed");

                },
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
            GetStudentsDetail(1);

        }

        function GenerateTC(regNo) {



        }


    </script>
    <%--Bulk Section--%>
    <script type="text/javascript">
        function CheckAll() {
            if ($("[id*=chkBulk]").is(':checked')) {
                $("[id*=bulkView]").attr("style", "display:inline;");
            }
            else {
                $("[id*=bulkView]").attr("style", "display:none;");
            }
        }

        function CheckBulkPrint() {
            if ($("[id*=chkPrintBulk]").is(':checked')) {
                $("[id*=trBulkPrint]").attr("style", "display:inline;");
            }
            else {
                $("[id*=trBulkPrint]").attr("style", "display:none;");
            }
        }

        function ShowDiv() {
            $('#divBulkUpdatePopUp').css("display", "block");
        }
        function CloseDiv() {
            $("[id*=ddlBulkUpdCls]").val('');
            $("[id*=ddlBulkUpdSec]").val('');
            $("[id*=txtBulkPromotion]").val('');
            $("[id*=txtBulkTCStudLateDate]").val('');
            $("[id*=txtBulkTCAppDate]").val('');
            $("[id*=txtBulkTCDate]").val('');
            $("[id*=txtBulkTCCoures]").val('');

            $('#divBulkUpdatePopUp').css("display", "none");
        }

        function GetSectionForBulk(ID) {
            if (ID != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/TCSearch.aspx/GetSectionByClassID",
                    data: '{ClassID: ' + ID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetSectionForBulk,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                var select = $("[id*=ddlSectionForApproval]");
                select.children().remove();
                select.append($("<option>").val('').text('---Select---'));
            }
        }

        function OnGetSectionForBulk(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("SectionByClass");
            var select = $("[id*=ddlSectionForApproval]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));

            });

        };
        function GetSectionForBulkPrint(ID) {
            if (ID != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/TCSearch.aspx/GetSectionByClassID",
                    data: '{ClassID: ' + ID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetSectionForBulkPrint,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                var select = $("[id*=dpIPrintBulkSection]");
                select.children().remove();
                select.append($("<option>").val('').text('---Select---'));
            }
        }

        function OnGetSectionForBulkPrint(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("SectionByClass");
            var select = $("[id*=dpIPrintBulkSection]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));

            });

        };

        function ChangeSectionBulk(ID) {
            if (ID != '') {
                $.ajax({
                    type: "POST",
                    url: "../Students/TCSearch.aspx/GetSectionByClassID",
                    data: '{ClassID: ' + ID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnChangeSectionBulk,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
            else {
                var select = $("[id*=ddlBulkUpdSec]");
                select.children().remove();
                select.append($("<option>").val('').text('---Select---'));
            }
        }

        function OnChangeSectionBulk(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("SectionByClass");
            var select = $("[id*=ddlBulkUpdSec]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var SectionID = $(this).find("SectionID").text();
                var SectionName = $(this).find("SectionName").text();
                select.append($("<option>").val(SectionID).text(SectionName));

            });

            var clsWords = xml.find("ClassWords");
            var word = clsWords.find("ClassInWords").text();
            $("[id*=hdnClassInWords]").val(word);

        };

        function BulkApprove() {
            if (jConfirm('Are you sure to send bulk approve?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Students/TCSearch.aspx/BulkApproval",
                        data: '{"classId": "' + $('[id*=ddlClassForApproval]').val() + '","sectionId":"' + $('[id*=ddlSectionForApproval]').val() + '","academicId": "' + $("[id*=hfAcademicYear]").val() + '","userId":"' + $('[id*=hfuserid]').val() + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d == "1") {
                                AlertMessage('success', "Bulk apporval has been sent");
                                GetStudentsDetail(1);
                            }
                            else
                                AlertMessage('fail', "Bulk apporval sending");

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

        function BulkUpdate() {
            var parameters = '{"classId": "' + $("[id*=ddlBulkUpdCls]").val() + '","sectionId": "' + $("[id*=ddlBulkUpdSec]").val() + '","academicId": "' + $("[id*=hfAcademicYear]").val() + '","userId": "' + $("[id*=hfuserid]").val() + '","leaveOfStudy": "' + $("[id*=hdnClassInWords]").val() + '","promotionText": "' + $("[id*=txtBulkPromotion]").val() + '","lastDate": "' + $("[id*=txtBulkTCStudLateDate]").val() + '","applicationDate": "' + $("[id*=txtBulkTCAppDate]").val() + '","tcDate": "' + $("[id*=txtBulkTCDate]").val() + '","courseofStudy": "' + $("[id*=txtBulkTCCoures]").val() + '"}';
            if ($("[id*=hfEditPrm]").val() == 'true') {

                if (jConfirm('Are you sure to update bulk?', 'Confirm', function (r) {
                    if (r) {
                        if ($('#aspnetForm').valid()) {
                            $.ajax({
                                type: "POST",
                                url: "../Students/TCSearch.aspx/BulkUpdate",
                                data: parameters,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (response) {
                                    if (response.d == "0") {
                                        CloseDiv();
                                        AlertMessage('info', "Student Not in Approval List");
                                        GetStudentsDetail(1);
                                    }

                                    else if (response.d == "1") {
                                        CloseDiv();
                                        AlertMessage('success', "Bulk Update done");
                                        GetStudentsDetail(1);
                                    }
                                    else {
                                        CloseDiv();
                                        AlertMessage('fail', "Bulk Update");
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
                    }

                })) {
                }
            }
        }
    </script>
    <%--Bulk Print Section--%>
    <%="<link href='" + ResolveUrl("~/css/TCprint.css") + "' rel='stylesheet' type='text/css'  media='print,handheld' />"%>
    <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
        function BulkPrint() {
            if ($("[id*=dpIPrintBulkClass]").val() != '') {
                if (jConfirm('Are you sure to update bulk?', 'Confirm', function (r) {
                    if (r) {
                        $.ajax({
                            type: "POST",
                            url: "../Students/TCSearch.aspx/BulkPrint",
                            data: '{"classId": "' + $('[id*=dpIPrintBulkClass]').val() + '","sectionId":"' + $('[id*=dpIPrintBulkSection]').val() + '","academicId":"' + $('[id*=hfAcademicYear]').val() + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnBulkPrintSuccess,
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
        }
        function OnBulkPrintSuccess(response) {
            if (response.d != '') {
                GetStudentsDetail(1);

                $(".printBulkTCContent").html(response.d);

                $(".printBulkTCContent").printElement(
            {
                leaveOpen: true,
                printBodyOptions:
            {
                styleToAdd: 'padding:5px 20px 0px 20px;margin:5px 25px 0px 20px;color:#000 !important;'
            }
            });
            }
            else {
                AlertMessage('info', 'Please check Duplicate TC');
            }
        }
    </script>
    <%--Print Section--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Transfer Certificate Search</h2>
            <div class="block content-wrapper2">
                <table class="form">
                    <tr>
                        <td>
                            <strong class="searchby">TC Type&nbsp;&nbsp;&nbsp;
                                <label>
                                    <input type="radio" name="rbTCType" id="rbtnnewTC" value="newTC" checked="checked"
                                        onclick="javascript:showDiv();" />New TC</label>
                                <label>
                                    <input type="radio" name="rbTCType" id="rbtnoldTC" value="oldTC" onclick="javascript:showDiv();" />Duplicate
                                    TC</label>
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
                                            <asp:TextBox ID="txtRegNo"  runat="server"></asp:TextBox>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                Admission No :</label>
                                        </td>
                                        <td width="32%">
                                            <asp:TextBox ID="txtAdminNo"  runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <label>
                                                Gender :</label>
                                        </td>
                                        <td>
                                            <label>
                                                <input type="radio" name="rbGender" id="rbtnMale" value="M" />Male</label>
                                            <label>
                                                <input type="radio" name="rbGender" id="rbtnFemale" value="F" />Female</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="9%">
                                            <label>
                                                Class :</label>
                                        </td>
                                        <td width="18%">
                                            <asp:DropDownList ID="ddlClass" runat="server" AppendDataBoundItems="True" onchange="GetSectionByClass(this.value);">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="11%">
                                            <label>
                                                Section :</label>
                                        </td>
                                        <td width="20%">
                                            <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True" onchange="GetStudentsDetail(1);">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                Student Name :</label>
                                        </td>
                                        <td width="32%">
                                            <input type="text" id="testid" value="" style="display: none" />
                                            <asp:TextBox ID="txtStudentName"  runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div id="stud_2" style="display: none;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="9%">
                                            <label>
                                                Year of Leaving :</label>
                                        </td>
                                        <td width="18%">
                                            <asp:DropDownList ID="ddlDupYear" CssClass="" runat="server" AppendDataBoundItems="True"
                                                onchange="GetStudentsDetail(1);">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                Register No :</label>
                                        </td>
                                        <td width="32%">
                                            <asp:TextBox ID="txtDupRegno"  runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <label>
                                                Gender :</label>
                                        </td>
                                        <td>
                                            <label>
                                                <input type="radio" name="rbdupGender" id="Radio1" value="M" />Male</label>
                                            <label>
                                                <input type="radio" name="rbdupGender" id="Radio2" value="F" />Female</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="9%">
                                            <label>
                                                Class of Leaving :</label>
                                        </td>
                                        <td width="18%">
                                            <asp:DropDownList ID="ddlDupClass" CssClass="" runat="server" AppendDataBoundItems="True"
                                                onchange="GetDupStudent();GetDupSection(this.value);">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="11%">
                                            <label>
                                                Section of Leaving :</label>
                                        </td>
                                        <td width="20%">
                                            <asp:DropDownList ID="ddlDupSection" CssClass="" runat="server" AppendDataBoundItems="True"
                                                onchange="GetStudentsDetail(1);">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="10%">
                                            <label>
                                                Student Name :</label>
                                        </td>
                                        <td width="32%">
                                            <asp:TextBox ID="ddlDupStudent"  runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>
                                                Parent Name</label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDupParent" CssClass="" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <label>
                                                Date Of Birth:</label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDupDOB" CssClass="" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <label>
                                                Admission No:</label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtAdmissionNo"  runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
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
                        </td>
                    </tr>
                </table>
                <div id="divBulkSection">
                    <%--Bulk Section Starts--%>
                    <table width="100%" class="form">
                        <tr>
                            <td>
                                <label>
                                    <u><strong>Step I</strong> :</u></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <a id="A1" href="#" onclick="ShowDiv()" runat="server"><strong>Click here to TC Bulk
                                    Update</strong> </a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    <u><strong>Step II </strong>:</u></label>
                            </td>
                        </tr>
                    </table>
                    <table width="100%" class="form">
                        <tr>
                            <td>
                                <strong>Select here to Send TC Bulk Approval </strong>
                                <input type="checkbox" id="chkBulk" onclick="CheckAll()" />
                            </td>
                        </tr>
                        <tr id="bulkView" style="display: none;">
                            <td>
                                <label>
                                    Class:
                                </label>
                                &nbsp;
                                <asp:DropDownList ID="ddlClassForApproval" runat="server" onchange="GetSectionForBulk(this.value);">
                                </asp:DropDownList>
                                &nbsp; &nbsp;
                                <label>
                                    Section:
                                </label>
                                &nbsp;
                                <asp:DropDownList ID="ddlSectionForApproval" runat="server">
                                    <asp:ListItem Text="---Select---" Value=""></asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;
                                <button id="btnApprove" type="button" class="btn-icon btn-navy btn-save" onclick="BulkApprove();">
                                    <span></span>Send</button>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td valign="top">
                                <label>
                                    <u><strong>Step III </strong>:</u></label>
                            </td>
                        </tr>
                    </table>
                    <table width="100%" class="form">
                        <tr>
                            <td>
                                <strong>Select here to Bulk TC Print </strong>
                                <input type="checkbox" id="chkPrintBulk" onclick="CheckBulkPrint()" />
                            </td>
                        </tr>
                        <tr id="trBulkPrint" style="display: none;">
                            <td>
                                <label>
                                    Class:
                                </label>
                                &nbsp;
                                <asp:DropDownList ID="dpIPrintBulkClass" runat="server" onchange="GetSectionForBulkPrint(this.value);">
                                </asp:DropDownList>
                                &nbsp; &nbsp;
                                <label>
                                    Section:
                                </label>
                                &nbsp;
                                <asp:DropDownList ID="dpIPrintBulkSection" runat="server">
                                    <asp:ListItem Text="---Select---" Value=""></asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;
                                <button id="Button1" type="button" class="btn-icon btn-navy btn-save" onclick="BulkPrint();">
                                    <span></span>Print</button>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td valign="top">
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                    <%--Bulk Section Ends--%></div>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="grdStudentTCInfo" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField HeaderText="Serial No" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Register No" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Admission No" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Student Name" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Class" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Section" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Due Status" HeaderStyle-CssClass="sorting_mod" />
                                    <asp:BoundField HeaderText="Approval Status" HeaderStyle-CssClass="sorting_mod" />
                                    <asp:TemplateField HeaderText="Options" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <div id="divTCOption">
                                            </div>
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
    <div id="divFeesPendingList" style="background: url(../img/overly.png) repeat; width: 100%;
        display: none; height: 100%; position: fixed; top: 0; left: 0; z-index: 10000;">
        <div style="position: absolute; top: 15%; left: 31%;">
            <table width="600" border="0" cellpadding="0" cellspacing="0" id="tableTC" style="border: 8px solid #bfbfbf;
                background-color: #fff;">
                <tr>
                    <td style="padding: 10px 10px 0px; float: right;">
                        <a href="javascript:closePendingList()">Close</a>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 10px 10px 0px;">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="60" colspan="2" align="center" valign="top" style="border-bottom: 1px solid #bfbfbf;
                                    font-family: Arial, Helvetica, sans-serif; font-size: 22px; font-weight: bold;
                                    color: #000; line-height: 25px;">
                                    AMALORPAVAM HIGHER SECONDARY SCHOOL<br />
                                    <span style="font-family: Arial, Helvetica, sans-serif; font-size: 15px; font-weight: bold;
                                        color: #000;">PUDUCHERRY - 605 00. PHONE NO. 2356747</span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="padding: 10px 0px;">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 0px !important;">
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td width="20%" height="25">
                                                Register No.
                                            </td>
                                            <td width="4%">
                                                :
                                            </td>
                                            <td width="42%">
                                                <label id="lblRegNo">
                                                </label>
                                            </td>
                                            <td width="10%">
                                            </td>
                                            <td width="3%">
                                            </td>
                                            <td width="21%">
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td height="25">
                                                Name
                                            </td>
                                            <td>
                                                :
                                            </td>
                                            <td colspan="4">
                                                <label id="lblStudentName">
                                                </label>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left;">
                                            <td height="25">
                                                Class &amp; Section
                                            </td>
                                            <td>
                                                :
                                            </td>
                                            <td>
                                                <label id="lblClassName">
                                                </label>
                                                &nbsp;
                                                <label id="lblSection">
                                                </label>
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="tblFeesBill" style="margin-bottom: 0px !important;">
                                        <tr style="background-color: #545454; font-family: Arial, Helvetica, sans-serif;
                                            font-size: 13px; font-weight: bold; color: #ffffff; text-align: center;">
                                            <td width="8%" height="25" align="center">
                                                SI.No
                                            </td>
                                            <td width="54%">
                                                PARTICULARS
                                            </td>
                                            <td width="38%" align="right" style="padding-right: 25px;">
                                                Amount
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="" style="overflow: auto; height: 100px; margin: 0px 0px;">
                                        <table id="tblViewBill" width="100%" border="0" cellspacing="0" cellpadding="0">
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td width="62%" style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;
                                    line-height: 30px; font-weight: bold; color: #000; padding-left: 5px; text-align: left;
                                    border-left: 0px solid #bfbfbf; border-top: 1px solid #bfbfbf;">
                                </td>
                                <td width="38%" valign="top" style="font-family: Arial, Helvetica, sans-serif; font-size: 18px;
                                    font-weight: bold; color: #000; padding-right: 25px; padding-top: 5px; text-align: right;
                                    border-left: 0px solid #bfbfbf; border-top: 1px solid #bfbfbf;">
                                    Total &raquo; &nbsp;&nbsp;
                                    <label id="lblTotAmt">
                                        0.00</label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <asp:HiddenField ID="hdnAcademicYearId" runat="server" />
    <asp:HiddenField ID="hfAcdModuleID" runat="server" />
    <asp:HiddenField ID="hfAcdMenuId" runat="server" />
    <asp:HiddenField ID="hfStudentID" runat="server" />
    <asp:HiddenField ID="hfModuleID" runat="server" />
    <div id="divBulkUpdatePopUp" style="background: url(../img/overly.png) repeat; width: 100%;
        display: none; height: 100%; position: fixed; top: 0; left: 0; z-index: 10000;">
        <div style="position: absolute; top: 15%; left: 31%;">
            <table width="600" border="0" cellpadding="0" cellspacing="0" id="table1" style="border: 8px solid #bfbfbf;
                background-color: #fff;">
                <tr>
                    <td style="padding: 10px 10px 0px; float: right;">
                        <a href="javascript:CloseDiv()">Close</a>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 10px 10px 0px;">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                color: #000; text-align: left; height: 50px;">
                                <td width="40%" height="25">
                                    Class:
                                    <asp:DropDownList ID="ddlBulkUpdCls" runat="server" onchange="ChangeSectionBulk(this.value)"
                                        CssClass="jsrequired">
                                    </asp:DropDownList>
                                </td>
                                <td width="4%">
                                    :
                                </td>
                                <td width="25%">
                                    Section:
                                    <asp:DropDownList ID="ddlBulkUpdSec" runat="server" CssClass="jsrequired">
                                        <asp:ListItem Value="" Text="---Select---" Enabled="true"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <asp:HiddenField ID="hdnClassInWords" runat="server" />
                            <tr>
                                <td style="padding: 10px 0px;">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 0px !important;">
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left; height: 50px;">
                                            <td width="50%" height="25">
                                                Whether qualified for promotion to higher standard
                                            </td>
                                            <td width="4%">
                                                :
                                            </td>
                                            <td width="25%">
                                                <input type="text" id="txtBulkPromotion" class="jsrequired" style="font-weight: bold" />
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left; height: 50px;">
                                            <td width="50%" height="25">
                                                Date on which the pupil actually left the school
                                            </td>
                                            <td width="4%">
                                                :
                                            </td>
                                            <td width="25%">
                                                <asp:TextBox ID="txtBulkTCStudLateDate" runat="server" CssClass="jsrequired" Style="font-weight: bold"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left; height: 50px;">
                                            <td width="50%" height="25">
                                                Date on which application for Transfer Certificate was made on behalf of the pupil
                                                by the parent or guardian
                                            </td>
                                            <td width="4%">
                                                :
                                            </td>
                                            <td width="25%">
                                                <asp:TextBox ID="txtBulkTCAppDate" runat="server" CssClass="jsrequired" Style="font-weight: bold"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left; height: 50px;">
                                            <td width="50%" height="25">
                                                Date of the Transfer Certificate
                                            </td>
                                            <td width="4%">
                                                :
                                            </td>
                                            <td width="25%">
                                                <asp:TextBox ID="txtBulkTCDate" runat="server" CssClass="jsrequired" Style="font-weight: bold"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left; height: 50px;">
                                            <td width="50%" height="25">
                                                Course of Study
                                            </td>
                                            <td width="4%">
                                                :
                                            </td>
                                            <td width="25%">
                                                <asp:TextBox ID="txtBulkTCCoures" runat="server" CssClass="jsrequired" Style="font-weight: bold"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold;
                                            color: #000; text-align: left; height: 50px;">
                                            <td width="50%" align="right" height="25">
                                                <button id="btnSendBulkUdate" type="button" class="btn-icon btn-navy btn-save" onclick="BulkUpdate();">
                                                    <span></span>Update</button>
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
    <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetTCStudentName.ashx?input=" + input + "&regNo=" + $("[id*=txtRegNo]").val() + "&Class=" + $("[id*=ddlClass]").val() + "&Section=" + $("[id*=ddlSection]").val() + "&AcademicYearId=" + $("[id*=hdnAcademicYearId]").val() + "&Gender=" + $("[name*=rbGender]:checked").val() + "&testid=" + document.getElementById('testid').value + "&mod=search"; },
            varname: "input",
            maxentries: 15
        };


        var as_xml = new bsn.AutoSuggest('<%= txtStudentName.ClientID %>', options_xml);    

    </script>
    <div class="printBulkTCContent">
    </div>
</asp:Content>
