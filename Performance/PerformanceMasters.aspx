<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="PerformanceMasters.aspx.cs" Inherits="Performance_PerformanceMasters" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <style type="text/css">
        .highlight
        {
            background: #A7A4A4;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtStartDate]");
            setDatePicker("[id*=txtEndDate]");
        });
        $(function () {


            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetExamName(1);
            GetExamType(1);
            GetClassSubjects(1);
            GetExamSetup(1);
            GetGradeSetups(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);



        });


        function GetGradeSetups(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/GetGradeSetup",
                    data: '{pageIndex: ' + pageIndex + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetGradeSetupSuccess,
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



        function OnGetGradeSetupSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var GradeSetups = xml.find("GradeSetups");
            var row = $("[id*=dgGradeSetup] tr:last-child").clone(true);
            $("[id*=dgGradeSetup] tr").not($("[id*=dgGradeSetup] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditGradeSetup('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteGradeSetup('";
                danchorEnd = "');\">Delete</a>";
            }
            if (GradeSetups.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records Found").attr("align", "left");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("").removeClass("editacc edit-links");
                $("td", row).eq(5).html("").removeClass("deleteacc delete-links");
                $("[id*=dgGradeSetup]").append(row);
                row = $("[id*=dgGradeSetup] tr:last-child").clone(true);

            }
            else {
                $.each(GradeSetups, function () {
                    var GradeSetup = $(this);
                    var ehref = eanchor + $(this).find("GradeSetupID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("GradeSetupID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("GradeName").text());
                    $("td", row).eq(1).html($(this).find("Pattern").text());
                    $("td", row).eq(2).html($(this).find("MarkFrom").text());
                    $("td", row).eq(3).html($(this).find("MarkTo").text());
                    $("td", row).eq(4).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(5).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgGradeSetup]").append(row);
                    row = $("[id*=dgGradeSetup] tr:last-child").clone(true);
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
            var GradeSetupsPager = xml.find("Pager");

            $("#GradeSetupPager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(GradeSetupsPager.find("PageIndex").text()),
                PageSize: parseInt(GradeSetupsPager.find("PageSize").text()),
                RecordCount: parseInt(GradeSetupsPager.find("RecordCount").text())
            });
        };
        // Delete ExamName
        function DeleteGradeSetup(id) {
            var parameters = '{"GradeSetupID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Performance/PerformanceMasters.aspx/DeleteGradeSetup",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteGradeSetupSuccess,
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
        function OnDeleteGradeSetupSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetGradeSetups(1);
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
        $("#GradeSetupPager .page").live("click", function (e) {
            GetGradeSetups(parseInt($(this).attr('page')));
        });

        //        Edit Function

        function EditGradeSetup(GradeSetupID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/EditGradeSetup",
                    data: '{GradeSetupID: ' + GradeSetupID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditGradeSetupSuccess,
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

        function OnEditGradeSetupSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var EditGradeSetups = xml.find("EditGradeSetup");
            $.each(EditGradeSetups, function () {
                var GradeSetups = $(this);
                $("[id*=ddlGrade]").val($(this).find("GradeID").text());
                $("[id*=ddlExamPattern]").val($(this).find("Pattern").text());
                $("[id*=txtFrom]").val($(this).find("MarkFrom").text());
                $("[id*=txtTo]").val($(this).find("MarkTo").text());
                $("[id*=hfGradeSetupID]").val($(this).find("GradeSetupID").text());
                $("[id*=spGradeSetupSubmit]").html("Update");


            });
        };

        // Save ExamName
        function SaveGradeSetup() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfGradeSetupID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfGradeSetupID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnGradeSetupSubmit]").attr("disabled", "true");
                    var GradeSetupID = $("[id*=hfGradeSetupID]").val();
                    var GradeID = $("[id*=ddlGrade]").val();
                    var Pattern = $("[id*=ddlExamPattern]").val();
                    var MarkFrom = $("[id*=txtFrom]").val();
                    var MarkTo = $("[id*=txtTo]").val();
                    var parameters = '{"GradeSetupID": "' + GradeSetupID + '","GradeID": "' + GradeID + '","Pattern": "' + Pattern + '","MarkFrom": "' + MarkFrom + '","MarkTo": "' + MarkTo + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Performance/PerformanceMasters.aspx/SaveGradeSetup",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveGradeSetupSuccess,
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
        function OnSaveGradeSetupSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                GetGradeSetups(1);
                GradeSetupCancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                GradeSetupCancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetGradeSetups(1);
                GradeSetupCancel();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                GradeSetupCancel();
            }
            else {
                AlertMessage('fail', response.d);
                GradeSetupCancel();
            }
        };


        // Delete On Success
        function OnDeleteExamNameSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetExamName(1);
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
        $("#GradeSetupPager .page").live("click", function (e) {
            GetGradeSetups(parseInt($(this).attr('page')));
        });





        function BindClass(ID) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/BindClassByExamType",
                    data: '{ExamTypeID: ' + ID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnBindClassSuccess,
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
        function OnBindClassSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("ClassByExamType");
            var select = $("[id*=ddlClass3]");
            select.children().remove();
            $.each(cls, function () {
                var icls = $(this);
                var ClassID = $(this).find("ClassID").text();
                var ClassName = $(this).find("ClassName").text();
                select.append($("<option>").val(ClassID).text(ClassName));

            });
            BindClassSubjects(1);

        };


        function BindClassSubjects(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var ExamTypeID = $("[id*=ddlExamType]").val();
                var ClassID = $("[id*=ddlClass3]").val();
                var Type = $("[id*=ddlEType]").val();
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/BindClassSubjects",
                    data: '{pageIndex: ' + pageIndex + ',"ExamTypeID": "' + ExamTypeID + '","ClassID": "' + ClassID + '","Type": "' + Type + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnBindClassSubjectsSuccess,
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

        function OnBindClassSubjectsSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var BindClassSubject = xml.find("BindClassSubjects");
            var row = $("[id*=dgExamSetup] tr:last-child").clone(true);
            $("[id*=dgExamSetup] tr").not($("[id*=dgExamSetup] tr:first-child")).remove();

            if (BindClassSubject.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");
                $("[id*=dgExamSetup]").append(row);
                row = $("[id*=dgExamSetup] tr:last-child").clone(true);

            }
            else {
                $.each(BindClassSubject, function () {
                    row.addClass("even");
                    var inptxt = "<input type='text' value=\"" + $(this).find("MaxMark").text() + "\" id=\"" + $(this).find("MaxMark").text() + "\"  style=\"width:75px;\" class=\"MaxMark\">";
                    var inptxt1 = "<input type='text' value=\"" + $(this).find("PassMark").text() + "\" id=\"" + $(this).find("PassMark").text() + "\"  style=\"width:75px;\" class=\"PassMark\">";
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("ExamSetupID").text()).css("display", "none").addClass("ExamSetupID");
                    $("td", row).eq(1).html($(this).find("ClassSubjectID").text()).css("display", "none").addClass("ClassSubjectID");
                    $("td", row).eq(2).html($(this).find("SubjectName").text());
                    $("td", row).eq(3).html(inptxt);
                    $("td", row).eq(4).html(inptxt1);
                    $("[id*=dgExamSetup]").append(row);
                    row = $("[id*=dgExamSetup] tr:last-child").clone(true);
                });
            }

            var ExamSetupPager = xml.find("Pager");

            $("#ExamSetupPager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(ExamSetupPager.find("PageIndex").text()),
                PageSize: parseInt(ExamSetupPager.find("PageSize").text()),
                RecordCount: parseInt(ExamSetupPager.find("RecordCount").text())
            });
        };


        function SaveExamSetup() {
            var sqlstr = "";
            subQuery = "";
            var iCount = 0;
            $(".even").each(function () {
                subQuery = "";
                var ExamTypeID = $("[id*=ddlExamType]").val();
                var UserId = $("[id*=hfUserId]").val();
                var AcademicID = $("[id*=hfAcademicID]").val();
                var ClassSubjectID = $(this).find('td.ClassSubjectID').html();
                var PassMark = $(this).find('input.PassMark').val();
                var MaxMark = $(this).find('input.MaxMark').val();
                if (PassMark != null && PassMark != "" && PassMark != "0" && MaxMark != null && MaxMark != "" && MaxMark != "0") {
                    iCount = iCount + 1;
                    subQuery = "insert into p_examsetup(ExamTypeID,ClassSubjectID,MaxMark,PassMark,AcademicID,Isactive,UserID)values('" + ExamTypeID + "','" + ClassSubjectID + "','" + MaxMark + "','" + PassMark + "','" + AcademicID + "',1,'" + UserId + "')";
                }
                var parameters = '{"ExamTypeID": "' + ExamTypeID + '","ClassSubjectID": "' + ClassSubjectID + '","MaxMark": "' + MaxMark + '","PassMark": "' + PassMark + '","query": "' + subQuery + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/SaveExamSetup",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSaveExamSetupSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            });
            if (iCount == 0) {
                AlertMessage('info', "Enter Pass Mark /Max. Marks");

            }
        }
        function OnSaveExamSetupSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetExamSetup(1);
            }
            else if (response.d == "Inserted Failed") {
                AlertMessage('fail', 'Insert Failed');
            }
            else if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                GetExamSetup(1);
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update Failed');
            }
        }


        function GetExamSetup(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/GetExamSetup",
                    data: '{pageIndex: ' + pageIndex + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetExamSetupSuccess,
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

        function OnGetExamSetupSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var ExamSetups = xml.find("ExamSetup");
            var row = $("[id*=dgExamSetup] tr:last-child").clone(true);
            $("[id*=dgExamSetup] tr").not($("[id*=dgExamSetup] tr:first-child")).remove();


            if (ExamSetups.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");
                $("[id*=dgExamSetup]").append(row);
                row = $("[id*=dgExamSetup] tr:last-child").clone(true);

            }
            else {
                $.each(ExamSetups, function () {
                    row.addClass("even");
                    var inptxt = "<input type='text' value=\"" + $(this).find("MaxMark").text() + "\" id=\"" + $(this).find("MaxMark").text() + "\"  style=\"width:75px;\" class=\"MaxMark\">";
                    var inptxt1 = "<input type='text' value=\"" + $(this).find("PassMark").text() + "\" id=\"" + $(this).find("PassMark").text() + "\"  style=\"width:75px;\" class=\"PassMark\">";
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("ExamSetupID").text()).css("display", "none").addClass("ExamSetupID");
                    $("td", row).eq(1).html($(this).find("ClassSubjectID").text()).css("display", "none").addClass("ClassSubjectID");
                    $("td", row).eq(2).html($(this).find("SubjectName").text());
                    $("td", row).eq(3).html(inptxt);
                    $("td", row).eq(4).html(inptxt1);
                    $("[id*=dgExamSetup]").append(row);
                    row = $("[id*=dgExamSetup] tr:last-child").clone(true);
                });
            }

            var ExamSetupPager = xml.find("Pager");

            $("#ExamSetupPager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(ExamSetupPager.find("PageIndex").text()),
                PageSize: parseInt(ExamSetupPager.find("PageSize").text()),
                RecordCount: parseInt(ExamSetupPager.find("RecordCount").text())
            });
        };
        function GetClassSubjectID() {
            var SchoolTypeID = $("[id*=ddlSchType]").val();
            var ClassID = $("[id*=ddlCls]").val();
            var SubjectType = $("[id*=ddlSubType]").val();
            var Subjects = $("[id*=ddlSubjects]").val();

            var parameters = '{"schooltypeid": "' + SchoolTypeID + '","classid": "' + ClassID + '","subjecttype": "' + SubjectType + '","subjects": "' + Subjects + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/GetClassSubjectID",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetClassSubjectIDSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }

            // Save On Success
            function OnGetClassSubjectIDSuccess(response) {

                var xmlDoc = $.parseXML(response.d);
                var xml = $(xmlDoc);
                var ClassSub = xml.find("GetClassSubjectID");
                if (ClassSub.length > 0) {
                    $.each(ClassSub, function () {
                        var iClassSub = $(this);
                        var ClassSubjectID = $(this).find("ClassSubjectID").text();
                        $("[id*=hfSubjectheaders]").val(ClassSubjectID);

                    });
                }                 
                else {
                    AlertMessage('info', "Not yet Mapped!");
                }
                 
            };
        
        function GetClassBySchoolType(ID) {
            if (ID) {

                $.ajax({
                    type: "POST",
                    url: "../Masters/Section.aspx/GetClassBySchoolTypeID",
                    data: '{SchoolTypeID: ' + ID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }

        function OnGetSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("ClassBySchoolType");

            var select = $("[id*=ddlClass2]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var ClassID = $(this).find("ClassID").text();
                var ClassName = $(this).find("ClassName").text();
                select.append($("<option>").val(ClassID).text(ClassName));
                if (FlagClassID != -1)
                    $("[id*=ddlClass2] option[value='" + FlagClassID + "']").attr("selected", "true");
            });

            var slt = $("[id*=ddlCls]");
            slt.children().remove();
            slt.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var ClassID = $(this).find("ClassID").text();
                var ClassName = $(this).find("ClassName").text();
                slt.append($("<option>").val(ClassID).text(ClassName));
                if (FlagClassID != -1)
                    $("[id*=ddlCls] option[value='" + FlagClassID + "']").attr("selected", "true");
            });
        };

        function GetClassSubject() {
            var ClassID = $("[id*=ddlClass2]").val();
            var Type = $("[id*=ddlType]").val();
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/GetClassSubject",
                    data: '{"ClassID": "' + ClassID + '","Type": "' + Type + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetClassSubjectSuccess,
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

        function OnGetClassSubjectSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var ClassSub = xml.find("GetClassSubject");
            if (ClassSub.length > 0) {
                $.each(ClassSub, function () {
                    $(".checkbox").each(function () {
                        $(this).find('input.chkSubjects').attr('checked', false);
                        $(this).find('input.chkSubjects').attr('disabled', false);
                    });
                });
                $.each(ClassSub, function () {
                    var iClassSub = $(this);
                    var SubjectID = $(this).find("SubjectID").text();
                    $(".checkbox").each(function () {
                        var tdchkSubjects = $(this).find('input.chkSubjects').val();
                        if (SubjectID == tdchkSubjects) {
                            $(this).find('input.chkSubjects').attr('checked', true);
                            $(this).find('input.chkSubjects').attr('disabled', 'disabled');
                        }
                    });
                    $("[id*=spClassSubmit]").html("Update");

                });
            }
            else {
                $(".checkbox").each(function () {
                    $(this).find('input.chkSubjects').attr('checked', false);
                    $(this).find('input.chkSubjects').attr('disabled', false);
                });
            }

        }

        function GetClassSubjects(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var ClassID = $("[id*=ddlClassSearch1]").val();

                if (ClassID == 'null' || ClassID == "---Select---") {
                    ClassID = "";
                }
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/GetClassSubjects",
                    data: '{pageIndex: ' + pageIndex + ',"ClassID": "' + ClassID + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetClassSubjectsSuccess,
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

        function OnGetClassSubjectsSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var ClassSubjects = xml.find("ClassSubjects");
            var row = $("[id*=dgClassSubjects] tr:last-child").clone(true);
            $("[id*=dgClassSubjects] tr").not($("[id*=dgClassSubjects] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditClassSubjects('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteClassSubjects('";
                danchorEnd = "');\">Delete</a>";
            }
            if (ClassSubjects.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records Found").attr("align", "left");
                $("td", row).eq(3).html("");
                //  $("td", row).eq(4).html("").removeClass("editacc edit-links");
                $("td", row).eq(4).html("").removeClass("deleteacc delete-links");
                $("[id*=dgClassSubjects]").append(row);
                row = $("[id*=dgClassSubjects] tr:last-child").clone(true);

            }
            else {
                $.each(ClassSubjects, function () {
                    var iClassSubjects = $(this);
                    var ehref = eanchor + $(this).find("ClassSubjectID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("ClassSubjectID").text() + danchorEnd;
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("SchoolTypeName").text());
                    $("td", row).eq(1).html($(this).find("ClassName").text());
                    $("td", row).eq(2).html($(this).find("SubjectType").text());
                    $("td", row).eq(3).html($(this).find("SubjectName").text());
                    // $("td", row).eq(4).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(4).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgClassSubjects]").append(row);
                    row = $("[id*=dgClassSubjects] tr:last-child").clone(true);
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
            var ClassPager = xml.find("Pager");

            $("#ClassPager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(ClassPager.find("PageIndex").text()),
                PageSize: parseInt(ClassPager.find("PageSize").text()),
                RecordCount: parseInt(ClassPager.find("RecordCount").text())
            });
        };
        // Delete ClassSubjects
        function DeleteClassSubjects(id) {
            var parameters = '{"ClassSubjectID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Performance/PerformanceMasters.aspx/DeleteClassSubjects",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteClassSubjectsSuccess,
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

        function EditClassSubjects(ClassSubjectID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/EditClassSubjects",
                    data: '{ClassSubjectID: ' + ClassSubjectID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditClassSubjectsSuccess,
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
        var FlagClassID = -1;
        function OnEditClassSubjectsSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var ClassSubjects = xml.find("EditClassSubjects");
            $.each(ClassSubjects, function () {
                var iClassSubjects = $(this);
                var SchoolTypeID = $(this).find("SchoolTypeID").text();
                $("[id*=ddlSchoolType] option[value='" + SchoolTypeID + "']").attr("selected", "true");
                FlagClassID = $(this).find("ClassID").text();
                GetClassBySchoolType(SchoolTypeID);
                var SubjectType = $(this).find("SubjectType").text();
                $("[id*=ddlType] option[value='" + SubjectType + "']").attr("selected", "true");
                $("[id*=hfClassSubjectID]").val($(this).find("ClassSubjectID").text());
                var SubjectID = $(this).find("SubjectID").text();
                $(".checkbox").each(function () {
                    $(this).find('input.chkSubjects').attr('checked', false);
                });
                $(".checkbox").each(function () {
                    var tdchkSubjects = $(this).find('input.chkSubjects').val();
                    if (SubjectID == tdchkSubjects) {
                        $(this).find('input.chkSubjects').attr('checked', true);
                        $(this).find('input.chkSubjects').attr('disabled', 'disabled');
                    }
                });
                $("[id*=spClassSubmit]").html("Update");


            });
        };

        // Save ClassSubjects
        function SaveClassSubjects() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfClassSubjectID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfClassSubjectID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnClassSubmit]").attr("disabled", "true");
                    var ClassSubjectID = $("[id*=hfClassSubjectID]").val();
                    var SchoolTypeID = $("[id*=ddlSchoolType]").val();
                    var ClassID = $("[id*=ddlClass2]").val();
                    var SubjectType = $("[id*=ddlType]").val();
                    var SubjectID = "";
                    $(".checkbox").each(function () {
                        var chk = $(this).find('input.chkSubjects').is(':checked');
                        if (chk == true) {
                            SubjectID = $(this).find('input.chkSubjects').val();
                            var parameters = '{"id": "' + ClassSubjectID + '","schooltypeid": "' + SchoolTypeID + '","classid": "' + ClassID + '","subjecttype": "' + SubjectType + '","subjectid": "' + SubjectID + '"}';
                            $.ajax({
                                type: "POST",
                                url: "../Performance/PerformanceMasters.aspx/SaveClassSubjects",
                                data: parameters,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: OnSaveClassSubjectsSuccess,
                                failure: function (response) {
                                    AlertMessage('info', response.d);
                                },
                                error: function (response) {
                                    AlertMessage('info', response.d);
                                }
                            });
                        }
                    });

                }
            }
            else {
                return false;
            }
        }

        // Save On Success
        function OnSaveClassSubjectsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                location.reload();
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                location.reload();
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
        function OnDeleteClassSubjectsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetClassSubjects(1);
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
        $("#ClassPager .page").live("click", function (e) {
            GetClassSubjects(parseInt($(this).attr('page')));
        });

        function ClassCancel() {
            $("[id*=txtClassSubjectName]").val("");
            $("[id*=hfClassSubjectID]").val("");
            $("[id*=ddlSchoolType]").val("");
            $("[id*=ddlClass2]").val("");
            $("[id*=ddlType]").val("");
            $(".checkbox").each(function () {
                $(this).find('input.chkSubjects').attr('checked', false);
            });
            $('#aspnetForm').validate().resetForm();
            $("[id*=spClassSubmit]").html("Save");
            $("[id*=btnClassSubmit]").attr("disabled", "false");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function GetExamName(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/GetExamName",
                    data: '{pageIndex: ' + pageIndex + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetExamNameSuccess,
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

        //        GetExamName On Success Function
        //        Get ExamName to Grid

        function OnGetExamNameSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var ExamNamees = xml.find("ExamNames");
            var row = $("[id*=dgExamName] tr:last-child").clone(true);
            $("[id*=dgExamName] tr").not($("[id*=dgExamName] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditExamName('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteExamName('";
                danchorEnd = "');\">Delete</a>";
            }
            if (ExamNamees.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("").removeClass("editacc edit-links");
                $("td", row).eq(5).html("").removeClass("deleteacc delete-links");
                $("[id*=dgExamName]").append(row);
                row = $("[id*=dgExamName] tr:last-child").clone(true);

            }
            else {
                $.each(ExamNamees, function () {
                    var ExamName = $(this);
                    var ehref = eanchor + $(this).find("ExamNameID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("ExamNameID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("ExamName").text());
                    $("td", row).eq(1).html($(this).find("Description").text());
                    $("td", row).eq(2).html($(this).find("StartDate").text());
                    $("td", row).eq(3).html($(this).find("EndDate").text());
                    $("td", row).eq(4).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(5).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgExamName]").append(row);
                    row = $("[id*=dgExamName] tr:last-child").clone(true);
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
            var ExamNamePager = xml.find("Pager");

            $("#ExamNamePager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(ExamNamePager.find("PageIndex").text()),
                PageSize: parseInt(ExamNamePager.find("PageSize").text()),
                RecordCount: parseInt(ExamNamePager.find("RecordCount").text())
            });
        };
        // Delete ExamName
        function DeleteExamName(id) {
            var parameters = '{"ExamNameID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Performance/PerformanceMasters.aspx/DeleteExamName",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteExamNameSuccess,
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

        function EditExamName(ExamNameID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/EditExamName",
                    data: '{ExamNameID: ' + ExamNameID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditExamNameSuccess,
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

        function OnEditExamNameSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var ExamNames = xml.find("EditExamName");
            $.each(ExamNames, function () {
                var ExamName = $(this);
                $("[id*=txtExamName]").val($(this).find("ExamName").text());
                $("[id*=txtDescription]").val($(this).find("Description").text());
                $("[id*=txtStartDate]").val($(this).find("StartDate").text());
                $("[id*=txtEndDate]").val($(this).find("EndDate").text());
                $("[id*=hfExamNameID]").val($(this).find("ExamNameID").text());
                $("[id*=spExamSubmit]").html("Update");


            });
        };

        // Save ExamName
        function SaveExamName() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfExamNameID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfExamNameID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnExamSubmit]").attr("disabled", "true");
                    var ExamNameID = $("[id*=hfExamNameID]").val();
                    var ExamNameName = $("[id*=txtExamName]").val();
                    var startdate = $("[id*=txtStartDate]").val();
                    var enddate = $("[id*=txtEndDate]").val();
                    var Description = $("[id*=txtDescription]").val();
                    var parameters = '{"id": "' + ExamNameID + '","name": "' + ExamNameName + '","startdate": "' + startdate + '","enddate": "' + enddate + '","description": "' + Description + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Performance/PerformanceMasters.aspx/SaveExamName",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveExamNameSuccess,
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
        function OnSaveExamNameSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                location.reload();
                ExamNameCancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                ExamNameCancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                location.reload();
                ExamNameCancel();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                ExamNameCancel();
            }
            else {
                AlertMessage('fail', response.d);
                ExamNameCancel();
            }
        };


        // Delete On Success
        function OnDeleteExamNameSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetExamName(1);
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
        $("#ExamNamePager .page").live("click", function (e) {
            GetExamName(parseInt($(this).attr('page')));
        });



        function GetList(pageIndex) {
            var classid = $("[id*=ddlClass]").val();
            var sectionid = $("[id*=ddlSection]").val();
            if (sectionid == 'null') {
                sectionid = "";
            }
            $.ajax({
                type: "POST",
                url: "../Performance/PerformanceMasters.aspx/GetStudentList",
                data: '{"classid":"' + classid + '","sectionid":"' + sectionid + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetStudentListSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }
        function OnGetStudentListSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var sList = xml.find("StudentList");
            var row = $("[id*=dgStudentList] tr:last-child").clone(true);
            $("[id*=dgStudentList] tr").not($("[id*=dgStudentList] tr:first-child")).remove();
            if (sList.length > 0) {

                $.each(sList, function () {
                    var inp = "<input type='text' value=\"" + $(this).find("ExamNo").text() + "\" id=\"" + $(this).find("RegNo").text() + "\"  style=\"width:75px;\" class=\"ExamNo\">";
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("RegNo").text()).addClass("RegNo");
                    $("td", row).eq(1).html($(this).find("StudentName").text()).addClass("StudentName");
                    $("td", row).eq(2).html($(this).find("DOB").text()).addClass("DOB");
                    $("td", row).eq(3).html($(this).find("FatherName").text()).addClass("FatherName");
                    $("td", row).eq(4).html(inp);
                    $("[id*=dgStudentList]").append(row);
                    row = $("[id*=dgStudentList] tr:last-child").clone(true);
                });
            }
            else {
                row.addClass("even");
                $("td", row).eq(0).html('').removeClass("RegNo");
                $("td", row).eq(1).html('No records found').removeClass("StudentName");
                $("td", row).eq(2).html('');
                $("td", row).eq(3).html('');
                $("td", row).eq(4).html('');
                $("[id*=dgStudentList]").append(row);
                row = $("[id*=dgStudentList] tr:last-child").clone(true);
            }

            if ($("[id*=hfEditPrm]").val() == 'false') {
                $('.editacc').hide();
            }
            else {
                $('.editacc').show();
            }

            // Moving to Next TextBox on Enter Key Press Event
            $("input[type=text]").focus();
            var $inp = $("input[type=text]");

            $inp.bind('keydown', function (e) {
                var key = e.which;
                if (key == 40) {
                    e.preventDefault();
                    var cls = $(this).attr("class").split(' ');

                    var nxtIdx = $inp.index($(this).parent().parent("tr").next().find("td input." + cls[0] + ""));

                    if (nxtIdx == "-1") {
                        var arr = $(this).parent().next().find("input").attr("class");
                        nxtIdx = $inp.index($('.' + arr.split(' ')[0] + '').first());
                    }
                    $(":input:text:eq(" + nxtIdx + ")").focus();
                    $(":input:text:eq(" + nxtIdx + ")").closest('tr').addClass('highlight');
                }
            });
            $("input[type=text]").blur(function () {
                $(this).closest('tr').removeClass('highlight');
            });

            $("input[type=text]").focus();
            var $inp = $("input[type=text]");
            $inp.bind('keyup', function (e) {
                var key = e.which;
                if (key == 38) {
                    e.preventDefault();
                    var cls = $(this).attr("class").split(' ');
                    var nxtIdx = $inp.index($(this).parent().parent("tr").prev().find("td input." + cls[0] + ""));
                    if (nxtIdx == "-1") {
                        var arr = $(this).parent().prev().find("input").attr("class");
                        nxtIdx = $inp.index($('.' + arr.split(' ')[0] + '').first());
                    }
                    $(":input:text:eq(" + nxtIdx + ")").focus();
                    $(":input:text:eq(" + nxtIdx + ")").closest('tr').addClass('highlight');
                }
            });
            $("input[type=text]").blur(function () {
                $(this).closest('tr').removeClass('highlight');
            });

            //            var GetListPager = xml.find("Pager");
            //            $("#GetListPager").ASPSnippets_Pager({
            //                ActiveCssClass: "current",
            //                PagerCssClass: "pager",
            //                PageIndex: parseInt(GetListPager.find("PageIndex").text()),
            //                PageSize: parseInt(GetListPager.find("PageSize").text()),
            //                RecordCount: parseInt(GetListPager.find("RecordCount").text())
            //            });

        };
        //        $("#GetListPager .page").live("click", function (e) {
        //            GetList(parseInt($(this).attr('page')));
        //        });

        function UpdateExamNo() {
            var sqlstr = "";
            subQuery = "";
            $(".even").each(function () {
                subQuery = "";
                var RegNo = $(this).find('td.RegNo').html();
                var ExamNo = $(this).find('input.ExamNo').val();
                if (ExamNo != null && ExamNo != "" && ExamNo != "0") {
                    subQuery = "update s_studentinfo set examno='" + ExamNo + "' where regno='" + RegNo + "'";
                }
                sqlstr += subQuery;
            });
            var parameters = '{"query": "' + sqlstr + '"}';
            $.ajax({
                type: "POST",
                url: "../Performance/PerformanceMasters.aspx/UpdateExamNo",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnUpdateExamNoSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnUpdateExamNoSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                GetList(1);
            }
        }



        function GetExamType(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var ClassID = $("[id*=ddlClassSearch]").val();
               
                if (ClassID == 'null' || ClassID=="---Select---") {
                    ClassID = "";
                }
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/GetExamType",
                    data: '{pageIndex: ' + pageIndex + ',"ClassID": "' + ClassID + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetExamTypeSuccess,
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



        function OnGetExamTypeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var ExamTypees = xml.find("ExamTypes");
            var row = $("[id*=dgExamType] tr:last-child").clone(true);
            $("[id*=dgExamType] tr").not($("[id*=dgExamType] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditExamType('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteExamType('";
                danchorEnd = "');\">Delete</a>";
            }
            if (ExamTypees.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Records Found").attr("align", "left");
                $("td", row).eq(4).html("").removeClass("editacc edit-links");
                $("td", row).eq(5).html("").removeClass("deleteacc delete-links");
                $("[id*=dgExamType]").append(row);
                row = $("[id*=dgExamType] tr:last-child").clone(true);

            }
            else {
                $.each(ExamTypees, function () {
                    var iExamType = $(this);
                    var ehref = eanchor + $(this).find("ExamTypeID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("ExamTypeID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("ExamTypeName").text());
                    $("td", row).eq(1).html($(this).find("ClassName").text());
                    $("td", row).eq(2).html($(this).find("ExamName").text());
                    $("td", row).eq(3).html($(this).find("Pattern").text());
                    $("td", row).eq(4).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(5).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgExamType]").append(row);
                    row = $("[id*=dgExamType] tr:last-child").clone(true);
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
            var iExamTypePager = xml.find("Pager");

            $("#ExamTypePager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(iExamTypePager.find("PageIndex").text()),
                PageSize: parseInt(iExamTypePager.find("PageSize").text()),
                RecordCount: parseInt(iExamTypePager.find("RecordCount").text())
            });

        };

        function EditExamType(ExamTypeID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                $("table.form :input").prop('disabled', false);
                $.ajax({
                    type: "POST",
                    url: "../Performance/PerformanceMasters.aspx/EditExamType",
                    data: '{ExamTypeID: ' + ExamTypeID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditExamTypeSuccess,
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

        function OnEditExamTypeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var ExamTypees = xml.find("EditExamType");
            $.each(ExamTypees, function () {

                var iExamType = $(this);
                $("[id*=txtExamType]").val($(this).find("ExamTypeName").text());

                var ExamNameID = $(this).find("ExamNameID").text();
                $("[id*=ddlExamNameID] option[value='" + ExamNameID + "']").attr("selected", "true");

                var ClassID = $(this).find("ClassID").text();
                $("[id*=ddlClass1] option[value='" + ClassID + "']").attr("selected", "true");

                var Pattern = $(this).find("Pattern").text();
                $("[id*=ddlPattern] option[value='" + Pattern + "']").attr("selected", "true");

                $("[id*=hfExamTypeID]").val($(this).find("ExamTypeID").text());
                $("[id*=spSubmit]").html("Update");


            });
        };


        // Delete ExamType
        function DeleteExamType(id) {
            var parameters = '{"ExamTypeID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Performance/PerformanceMasters.aspx/DeleteExamType",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteExamTypeSuccess,
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
        // Delete On Success
        function OnDeleteExamTypeSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetExamType(parseInt(currentPage));
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
        $("#ExamTypePager .page").live("click", function (e) {
            GetExamType(parseInt($(this).attr('page')));
        });

        function SaveExamType() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfExamTypeID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfExamTypeID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var ExamTypeID = $("[id*=hfExamTypeID]").val();
                    var ExamType = $("[id*=txtExamType]").val();
                    var ClassID = $("[id*=ddlClass1]").val();
                    var ExamNameID = $("[id*=ddlExamNameID]").val();
                    var Pattern = $("[id*=ddlPattern]").val();
                    var parameters = '{"ExamTypeID": "' + ExamTypeID + '","ExamType": "' + ExamType + '","ClassID": "' + ClassID + '","ExamNameID": "' + ExamNameID + '","Pattern": "' + Pattern + '"}';
                    $.ajax({

                        type: "POST",
                        url: "../Performance/PerformanceMasters.aspx/SaveExamType",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveExamTypeSuccess,
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

        function OnSaveExamTypeSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                location.reload();
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                location.reload();
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
        function Cancel() {
            $("[id*=txtExamType]").val("");
            $("[id*=ddlClass1]").val("");
            $("[id*=ddlExamNameID]").val("");
            $("[id*=hfExamTypeID]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=btnSubmit]").attr("disabled", "false");
            $("[id*=spSubmit]").html("Save");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function ExamNameCancel() {
            $("[id*=txtExamName]").val("");
            $("[id*=hfExamNameID]").val("");
            $("[id*=txtStartDate]").val("");
            $("[id*=txtEndDate]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=btnExamSubmit]").attr("disabled", "false");
            $("[id*=spExamSubmit]").html("Save");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };

        function GradeSetupCancel() {
            $("[id*=ddlGrade]").val("");
            $("[id*=ddlExamPattern]").val("");
            $("[id*=txtFrom]").val("");
            $("[id*=txtTo]").val("");
            $("[id*=hfGradeSetupID]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=btnGradeSetupSubmit]").attr("disabled", "false");
            $("[id*=spGradeSetupSubmit]").html("Save");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
        function ExamSetupCancel() {
            $("[id*=ddlClass3]").val("");
            $("[id*=hfExamSetupD]").val("");
            $('#aspnetForm').validate().resetForm();
            $("[id*=btnExamSetup]").attr("disabled", "false");
            $("[id*=spExamSetup]").html("Save");
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };
        function CheckDate() {

            var date1 = $("[id*=txtStartDate]").val();
            var date2 = $("[id*=txtEndDate]").val();
            if (date1 != "" && date2 != "") {
                if ($.datepicker.parseDate('dd/mm/yy', date2) < $.datepicker.parseDate('dd/mm/yy', date1)) {
                    AlertMessage('info', 'StartDate should be lesser than EndDate !!!');
                    $("[id*=txtStartDate]").val("");
                    $("[id*=txtEndDate]").val("");
                }
            }

        };      
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <asp:HiddenField ID="hfAcademicID" runat="server" />
    <asp:HiddenField ID="hfval" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Performance Activities
            </h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2" id="">
                <div>
                    <ul class="section menu">
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Assign Exam No</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvExamNoAssigner" style="float: left; margin: 0 auto; width: 780px;" runat="server">
                                                        <asp:UpdatePanel ID="ups" runat="server">
                                                            <ContentTemplate>
                                                                <table class="form" cellpadding="0" cellspacing="0">
                                                                    <tr align="left">
                                                                        <td>
                                                                            <label>
                                                                                Class :</label>&nbsp;
                                                                            <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                                AutoPostBack="true" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                                                                                <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            &nbsp;
                                                                            <label>
                                                                                Section :</label>&nbsp;
                                                                            <asp:DropDownList ID="ddlSection" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSection_SelectedIndexChanged">
                                                                            </asp:DropDownList>
                                                                            &nbsp;
                                                                            <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetList(1);">
                                                                                <span></span>
                                                                                <div id="spFeesSubmit">
                                                                                    Search</div>
                                                                            </button>
                                                                            <button id="btnUpdate" type="button" class="btn-icon btn-orange btn-saving" onclick="UpdateExamNo();">
                                                                                <span></span>
                                                                                <div>
                                                                                    Update</div>
                                                                            </button>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="ddlClass" EventName="SelectedIndexChanged" />
                                                                <asp:AsyncPostBackTrigger ControlID="ddlSection" EventName="SelectedIndexChanged" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:GridView ID="dgStudentList" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even" AlternatingRowStyle-CssClass="odd"
                                                        EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="RegNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="RegNo" SortExpression="RegNo">
                                                                <ItemStyle HorizontalAlign="Center" CssClass="RegNo"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="StudentName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="StudentName" SortExpression="StudentName">
                                                                <ItemStyle HorizontalAlign="Center" CssClass="StudentName"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="DOB" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="DOB" SortExpression="DOB">
                                                                <ItemStyle HorizontalAlign="Center" CssClass="StudentName"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="FatherName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="FatherName" SortExpression="FatherName">
                                                                <ItemStyle HorizontalAlign="Center" CssClass="StudentName"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ExamNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="ExamNo" SortExpression="ExamNo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="Pager" id="GetListPager">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Exam Name</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvExamName" style="float: left; margin: 0 auto; width: 780px" runat="server">
                                                        <table class="form" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Exam Name</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtExamName" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Description</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtDescription" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="15%">
                                                                    <label>
                                                                        Start From</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtStartDate" CssClass="jsrequired dateNL date-picker" onchange="CheckDate();"
                                                                        runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="15%">
                                                                    <label>
                                                                        Start To</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtEndDate" CssClass="jsrequired dateNL date-picker" onchange="CheckDate();"
                                                                        runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <asp:HiddenField ID="hfExamNameID" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <button id="btnExamSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveExamName();">
                                                                        <span></span>
                                                                        <div id="spExamSubmit">
                                                                            Save</div>
                                                                    </button>
                                                                    <button id="btnExamNameCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                        runat="server" onclick="return ExamNameCancel();">
                                                                        <span></span>Cancel</button>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td valign="top" colspan="2">
                                                    <asp:GridView ID="dgExamName" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="ExamName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Exam Name" SortExpression="ExamName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Description" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Description" SortExpression="Description">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="StartDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="StartDate" SortExpression="StartDate">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="EndDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="EndDate" SortExpression="EndDate">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Edit</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("ExamNameID") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                <HeaderTemplate>
                                                                    Delete</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("ExamNameID") %>'
                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="Pager" id="ExamNamePager">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Exam Type</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvExamType" style="float: left; margin: 0 auto; width: 780px;" runat="server">
                                                        <table class="form" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Exam Name</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlExamNameID" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Pattern</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlPattern" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                        <asp:ListItem Value="FA(a)">FA(a)</asp:ListItem>
                                                                        <asp:ListItem Value="FA(b)">FA(b)</asp:ListItem>
                                                                        <asp:ListItem Value="SA">SA</asp:ListItem>
                                                                        <asp:ListItem Value="Co-Scholastic">Co-Scholastic</asp:ListItem>
                                                                        <asp:ListItem Value="None">None</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Class Name</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlClass1" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Exam Type
                                                                    </label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtExamType" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <asp:HiddenField ID="hfExamTypeID" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveExamType();">
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
                                             <tr>
                                            <td>&nbsp;</td>
                                                <td>
                                                    <label>
                                                        Class : </label>&nbsp;
                                                    <asp:DropDownList ID="ddlClassSearch" CssClass="jsrequired" runat="server" onchange="javascript:GetExamType(1);">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td valign="top" colspan="2">
                                                    <asp:GridView ID="dgExamType" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="ExamTypeName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Exam Type" SortExpression="ExamTypeName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ClassName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Class" SortExpression="ClassName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ExamName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Exam Name" SortExpression="ExamName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Pattern" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Pattern" SortExpression="Pattern">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Edit</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("ExamTypeID") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                <HeaderTemplate>
                                                                    Delete</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("ExamTypeID") %>'
                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="Pager" id="ExamTypePager">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Map Class-Subjects </a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvCashVoucher" style="float: left; width: 550px" runat="server">
                                                        <table class="form">
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        School Type</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlSchoolType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                        onchange="GetClassBySchoolType(this.value);">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td rowspan="4">
                                                                    <div class="block">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Class</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlClass2" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Subject Type</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlType" CssClass="jsrequired" runat="server" onchange="GetClassSubject();"
                                                                        AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                        <asp:ListItem Value="General">General</asp:ListItem>
                                                                        <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                                                        <asp:ListItem Value="Co-Curricular Activities">Co-Curricular Activities</asp:ListItem>
                                                                        <asp:ListItem Value="General Activities">General Activities</asp:ListItem>
                                                                        <asp:ListItem>Slip Test</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1" valign="top">
                                                                    <label>
                                                                        Subject Name</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <%=BindSubjects() %>
                                                                </td>
                                                                <td rowspan="3">
                                                                    <div class="block">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <asp:HiddenField ID="hfClassSubjectID" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <button id="btnClassSubmit" type="button" class="btn-icon btn-orange btn-saving"
                                                                        onclick="SaveClassSubjects();">
                                                                        <span></span>
                                                                        <div id="spClassSubmit">
                                                                            Save</div>
                                                                    </button>
                                                                    <button id="btnClassCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                                        onclick="return ClassCancel();">
                                                                        <span></span>Cancel</button>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>&nbsp;</td>
                                                <td>
                                                    <label>
                                                        Class : </label>&nbsp;
                                                    <asp:DropDownList ID="ddlClassSearch1" CssClass="jsrequired" runat="server" onchange="javascript:GetClassSubjects(1);">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td valign="top" colspan="2">
                                                    <asp:GridView ID="dgClassSubjects" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="SchoolType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="School Type" SortExpression="SchoolType">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Class" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Class" SortExpression="Class">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="SubjectType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Subject Type" SortExpression="SubjectType">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ClassSubjectName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Subjects" SortExpression="ClassSubjectName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <%--   <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Edit</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("ClassSubjectID") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>--%>
                                                            <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                <HeaderTemplate>
                                                                    Delete</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("ClassSubjectID") %>'
                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="Pager" id="ClassPager">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                         <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Create Subject Headers </a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="Div1" style="float: left; width: 550px" runat="server">
                                                        <table class="form">
                                                        <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        School Type</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlSchType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                        onchange="GetClassBySchoolType(this.value);">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td rowspan="4">
                                                                    <div class="block">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Class</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlCls" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Subject Type</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlSubType" CssClass="jsrequired" runat="server" onchange="GetClassSubject();"
                                                                        AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                        <asp:ListItem Value="General">General</asp:ListItem>
                                                                        <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                                                        <asp:ListItem Value="Co-Curricular Activities">Co-Curricular Activities</asp:ListItem>
                                                                        <asp:ListItem Value="General Activities">General Activities</asp:ListItem>
                                                                        <asp:ListItem>Slip Test</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                       Subject</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlSubjects" runat="server" AppendDataBoundItems="True" CssClass="jsrequired" onchange="GetClassSubjectID();">
                                                <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                            </asp:DropDownList>
                                                                </td>
                                                                <td rowspan="4">
                                                                    <div class="block">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Subject Headers</label>
                                                                </td>
                                                                <td class="col2">
                                                                   <asp:TextBox ID="txtHeader" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <asp:HiddenField ID="hfSubjectheaders" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <button id="btnSavesubject" type="button" class="btn-icon btn-orange btn-saving"
                                                                        onclick="SaveSubjectHeaders();">
                                                                        <span></span>
                                                                        <div id="Div2">
                                                                            Save</div>
                                                                    </button>
                                                                    <button id="btncancelsubject" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                                        onclick="return SubjectCancel();">
                                                                        <span></span>Cancel</button>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                         
                                            <tr valign="top">
                                                <td valign="top" colspan="2">
                                                    <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="SchoolType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="School Type" SortExpression="SchoolType">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Class" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Class" SortExpression="Class">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="SubjectType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Subject Type" SortExpression="SubjectType">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ClassSubjectName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Subjects" SortExpression="ClassSubjectName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <%--   <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Edit</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("ClassSubjectID") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>--%>
                                                            <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                <HeaderTemplate>
                                                                    Delete</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("ClassSubjectID") %>'
                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="Pager" id="Div3">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Exam Setup</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvexam" style="float: left; margin: 0 auto; width: 75%;" runat="server">
                                                        <table class="form" cellpadding="0" width="100px" cellspacing="0">
                                                            <tr>
                                                                <td class="col1" style="text-align: center">
                                                                    <label>
                                                                        Exam Type</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlExamType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                        onchange="BindClass(this.value);">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td class="col1" style="text-align: center">
                                                                    <label>
                                                                        Class Name</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlClass3" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                        onchange="BindClassSubjects(1);">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td class="col1" style="text-align: center">
                                                                    <label>
                                                                        Type</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlEType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                        onchange="BindClassSubjects(1);">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                        <asp:ListItem Value="General">General</asp:ListItem>
                                                                        <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                                                        <asp:ListItem Value="Co-Curricular Activities">Co-Curricular Activities</asp:ListItem>
                                                                        <asp:ListItem Value="General Activities">General Activities</asp:ListItem>
                                                                        <asp:ListItem>Slip Test</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td valign="top" colspan="6">
                                                    <asp:GridView ID="dgExamSetup" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="rowodd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="ExamSetupID" HeaderStyle-CssClass="ExamSetupID" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="ExamSetupID" SortExpression="ExamSetupID">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ClassSubjectID" HeaderStyle-CssClass="ClassSubjectID"
                                                                ItemStyle-HorizontalAlign="Center" HeaderText="ClassSubjectID" SortExpression="ClassSubjectID">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="SubjectName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Subject Name" SortExpression="SubjectName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="MaxMark" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Max Mark" SortExpression="MaxMark">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="PassMark" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Pass Mark" SortExpression="PassMark">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="Pager" id="ExamSetupPager">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td align="left" valign="top" colspan="6">
                                                    <button id="btnExamSetup" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveExamSetup();">
                                                        <span></span>
                                                        <div id="spExamSetup">
                                                            Save</div>
                                                    </button>
                                                    <button id="btnExamSetupCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                        runat="server" onclick="return ExamSetupCancel();">
                                                        <span></span>Cancel</button>
                                                    <asp:HiddenField ID="hfExamSetupID" runat="server" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <%--  <li style="display:none;"><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">--%>
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Grade Setup</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvGradeSetup" style="float: left; margin: 0 auto; width: 100%;" runat="server">
                                                        <table class="form" cellpadding="0" width="100px" cellspacing="0">
                                                            <tr>
                                                                <td class="col1" style="text-align: center">
                                                                    <label>
                                                                        Pattern</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlExamPattern" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                        <asp:ListItem Value="FA">FA</asp:ListItem>
                                                                        <asp:ListItem Value="SA">SA</asp:ListItem>
                                                                        <asp:ListItem Value="OverAll">OverAll</asp:ListItem>
                                                                        <asp:ListItem Value="Co-Curricular Activities">Co-Curricular Activities</asp:ListItem>
                                                                        <asp:ListItem Value="General Activities">General Activities</asp:ListItem>
                                                                        <asp:ListItem Value="None">None</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td class="col1" style="text-align: center">
                                                                    <label>
                                                                        Grade Name</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlGrade" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td class="col1" style="text-align: center">
                                                                    <label>
                                                                        Mark From</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtFrom" CssClass="jsrequired numbersonly" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td class="col1" style="text-align: center">
                                                                    <label>
                                                                        Mark To</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtTo" CssClass="jsrequired numbersonly" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td class="col2">
                                                                    <button id="btnGradeSetupSubmit" type="button" class="btn-icon btn-orange btn-saving"
                                                                        onclick="SaveGradeSetup();">
                                                                        <span></span>
                                                                        <div id="spGradeSetupSubmit">
                                                                            Save</div>
                                                                    </button>
                                                                </td>
                                                                &nbsp;
                                                                <td class="col2">
                                                                    <button id="btnGradeSetupCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                        runat="server" onclick="return GradeSetupCancel();">
                                                                        <span></span>Cancel</button>
                                                                    <asp:HiddenField ID="hfGradeSetupID" runat="server" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td valign="top" colspan="6">
                                                    <asp:GridView ID="dgGradeSetup" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="rowodd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="GradeName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="GradeName" SortExpression="GradeName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Pattern" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Pattern" SortExpression="Pattern">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="MarkFrom" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Mark From" SortExpression="MarkFrom">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="MarkTo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Mark To" SortExpression="MarkTo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Edit</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("GradeSetupID") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                <HeaderTemplate>
                                                                    Delete</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("GradeSetupID") %>'
                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="Pager" id="GradeSetupPager">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
