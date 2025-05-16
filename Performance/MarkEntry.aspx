<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="MarkEntry.aspx.cs"
    Inherits="Performance_MarkEntry" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <style type="text/css">
        .highlight
        {
            background: #A7A4A4;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript">

        function GetExamTypeByExamName() {
            var examnameid = $("[id*=ddlExamName]").val();
            var classid = $("[id*=ddlClass]").val();

            if (examnameid != "" && classid != "") {
                var parameters = '{"ExamNameID": "' + examnameid + '","ClassID": "' + classid + '"}';

                $.ajax({
                    type: "POST",
                    url: "../Performance/MarkEntry.aspx/GetExamTypeByExamName",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetExamTypeByExamNameSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }


        function OnGetExamTypeByExamNameSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("ExamTypeByExamName");
            var select = $("[id*=ddlExamType]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var ExamTypeID = $(this).find("ExamTypeID").text();
                var ExamTypeName = $(this).find("ExamTypeName").text();
                select.append($("<option>").val(ExamTypeID).text(ExamTypeName));
            });

            GetSectionByClass($("[id*=ddlClass]").val());
        };




        function GetExamNameByType(ID) {
            $.ajax({
                type: "POST",
                url: "../Performance/MarkEntry.aspx/GetExamNameByType",
                data: '{ExamNameID: ' + ID + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetExamNameByTypeSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnGetExamNameByTypeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("ExamNameByType");
            var select = $("[id*=ddlExamType]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var ExamTypeID = $(this).find("ExamTypeID").text();
                var ExamTypeName = $(this).find("ExamTypeName").text();
                select.append($("<option>").val(ExamTypeID).text(ExamTypeName));
            });
        };

        function GetSectionByClass(ID) {
            $.ajax({
                type: "POST",
                url: "../Performance/MarkEntry.aspx/GetSectionByClassID",
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

        function GetList() {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                if ($('#aspnetForm').valid()) {
                    var parameters = '{"classid": "' + $("[id*=ddlClass]").val() + '","section": "' + $("[id*=ddlSection]").val() + '","type": "' + $("[id*=ddlType]").val() + '","academicId": "' + $("[id*=hfAcademicYear]").val() + '","examTypeId": "' + $("[id*=ddlExamType]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Performance/MarkEntry.aspx/GetList",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        beforeSend: loadingfun,
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
            
            var arr = new Array();
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var langs = xml.find("Table");
            var studs = xml.find("Table1");
            var marks = xml.find("Table2");
          
            $("[id*=grdList]").html('');
            if (langs.length > 0) {
                $('.grdList').removeAttr('style', 'display:none;');
                var first = '<tbody><tr style=\margin-top:-60px;padding-left:0px;\"><th class=\"freezing_mod\" scope=\"col\">RegNo</th><th class=\"freezing_mod\" scope=\"col\">Name</th><th class=\"freezing_mod\" scope=\"col\">Exam No</th>';
                var second = '';

                $.each(langs, function () {
                    second += '<th class=\"freezing_mod\" scope=\"col\">' + $(this).find("SubjectName").text() + '</th>';
                });
                var third = '</tr></<tbody>';
                $("[id*=grdList]").html(first + second + third);

                $.each(langs, function () {
                    arr.push($(this).find("Subt").text());
                });
              
                  
                if (studs.length > 0) {
                    $.each(studs, function () {
                        var mod = $(this);
                        var firstApp = '<tr class=\"evennew\"><td class=\"regno\">' + $(this).find("RegNo").text() + '</td><td>' + $(this).find("StName").text() + '</td><td>' + $(this).find("ExamNo").text() + '</td>';
                        var secondeApp = '';
                        var maxMark = '';
                        $.each(arr, function (index, value) {
                            var SubjectId = value.split('-')[1];
                            if (marks.length > 0) {

                                $.each(marks, function () {
                                   
                                    var sub = $(this).find("Sub").text();
                                  
                                    if (value == sub) {
                                  
                                        maxMark = $(this).find("Maxmark").text();
                                    
                                    }

                                });
                            }


                            secondeApp += '<td><input style=\"width:57px;\" type=\"text\" class=\"' + SubjectId+'S' + ' ' + maxMark + '\" value="' + mod.find(value).text() + '" ></input></td>';


                        });
                        var thirdApp = "</tr>";
                        $("[id*=grdList]").append(firstApp + secondeApp + thirdApp);
                    });
                }
                else {
                    $('.grdList').attr('style', 'display:none;');
                    AlertMessage('info', 'Please Check Exam Setup');
                }
            }
            else {
                $('.grdList').attr('style', 'display:none;');
                AlertMessage('info', 'Please Map Class-Subject Type');
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
                    var maxmark = cls[1].split(' ');
                    var actualmark = $(this).val();
                    if (parseFloat(maxmark) < parseFloat(actualmark)) {
                               AlertMessage('info', "Entered Mark should not exceed than " + maxmark + "");
                        $(":input:text:eq(" + nxtIdx + ")").focus();
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
                        //alert($('.' + arr.split(' ')[0] + ''));
                        nxtIdx = $inp.index($('.' + arr.split(' ')[0] + '').first());
                    }
                    var maxmark = cls[1].split(' ');
                    var actualmark = $(this).val();
                    if (parseFloat(maxmark) < parseFloat(actualmark)) {
                        AlertMessage('info', "Entered Mark should not exceed than " + maxmark + "");
                        $(":input:text:eq(" + nxtIdx + ")").focus();
                    }
                    $(":input:text:eq(" + nxtIdx + ")").focus();
                    $(":input:text:eq(" + nxtIdx + ")").closest('tr').addClass('highlight');
                }
            });
            $("input[type=text]").blur(function () {
                $(this).closest('tr').removeClass('highlight');
            });

            $("#loading").html('');

        }

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
            var select = $("[id*=ddlClass]");
            select.children().remove();
            $.each(cls, function () {
                var icls = $(this);
                var ClassID = $(this).find("ClassID").text();
                var ClassName = $(this).find("ClassName").text();
                select.append($("<option>").val(ClassID).text(ClassName));

            });
            GetSectionByClass($("[id*=ddlClass]").val());

        };


        function Cancel() {
            $("[id*=ddlExamType]").val('');
            $("[id*=ddlClass]").val('');
            $("[id*=ddlSection]").val('');
            $("[id*=ddlType]").val('');
            $('#aspnetForm').validate().resetForm();
            $(".grdList").attr("style", "display:none;");
        }

        function SaveMarks() {
            if ($("[id*=hfAddPrm]").val() == 'true') {
                var markDetails = new Array();
                $(".evennew").each(function () {
                    var subjectId = '';
                    var marks = '';
                    var regno = '';
                    regno = $(this).find("td.regno").html();
                    $(this).find("td input[type=text]").each(function () {                       
                            var subID = $(this).attr("class").split(' ')[0].replace("S", "")
                            subjectId += subID + '|';
                            marks += $(this).val() + '|';                        
                    });
                    markDetails.push({ "examId": "" + $("[id*=ddlExamType]").val() + "", "type": "" + $("[id*=ddlType]").val() + "", "classID": "" + $("[id*=ddlClass]").val() + "", "sectionId": "" + $("[id*=ddlSection]").val() + "", "regNo": "" + regno + "", "subId": "" + subjectId + "", "marks": "" + marks + "", "academicId": "" + $("[id*=hfAcademicYear]").val() + "", "userId": "" + $("[id*=hfuserid]").val() + "" });
                });

                var parameters = JSON.stringify({ marklist: markDetails });

                $.ajax({
                    type: "POST",
                    url: "../Performance/MarkEntry.aspx/SaveMarks",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    beforeSend: loadingfun,
                    success: OnSaveSuccess,
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
        function OnSaveSuccess(response) {
            AlertMessage('success', 'Updated');
            GetList();
            $("#loading").html('');
        }
        function loadingfun() {
    
        var str='<div style="background: url(../img/overly.png) repeat; width: 100%;  height: 100%; position: fixed;text-align:center; top: 0; left: 0; z-index: 10000;">';
        str += '<center><img src="../img/loading.gif"/></center>';
        str += '</div>';
        $("#loading").html(str);

        }
    </script>
    <style type="text/css">
        .modal
        {
            position: fixed;
            top: 0;
            left: 0;
            background-color: black;
            z-index: 99;
            opacity: 0.8;
            filter: alpha(opacity=80);
            -moz-opacity: 0.8;
            min-height: 100%;
            width: 100%;
        }
        .loading
        {
            font-family: Arial;
            font-size: 10pt;
            border: 5px solid #67CFF5;
            width: 200px;
            height: 100px;
            display: none;
            position: fixed;
            background-color: White;
            z-index: 999;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div id="loading">
    </div>
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Mark Entry
            </h2>
            <div>
                <asp:UpdatePanel ID="ups" runat="server">
                    <ContentTemplate>
                        <table class="form" width="100%">
                            <tr>
                                <td>
                                    <div id="dvmarkEntry">
                                        <table width="100%">
                                            <tr>
                                                <td width="15%" height="40">
                                                    <label>
                                                        ExamName :</label>
                                                    <asp:DropDownList ID="ddlExamName" runat="server" AppendDataBoundItems="True" CssClass="jsrequired" onchange="GetExamTypeByExamName();">
                                                        <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                 
                                                 <td width="15%">
                                                    <label>
                                                        Class :</label>
                                                    <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True" onchange="GetExamTypeByExamName();">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>

                                                <td width="25%">
                                                    <label>
                                                        Section &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :</label>
                                                    <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>                                                
                                               
                                            </tr>
                                            <tr>
                                            <td height="40">
                                                    <label>
                                                        ExamType :</label>
                                                    <asp:DropDownList ID="ddlExamType" runat="server" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                
                                                <td>
                                                    <label>
                                                        Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :</label>
                                                    <asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                        <asp:ListItem Value="General">General</asp:ListItem>
                                                        <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                                        <asp:ListItem Value="Co-Curricular Activities">Co-Curricular Activities</asp:ListItem>
                                                        <asp:ListItem Value="General Activities">General Activities</asp:ListItem>
                                                        <asp:ListItem>Slip Test</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetList();">
                                                        Search</button>
                                                    <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveMarks();">
                                                        <span></span>
                                                        <div id="spSubmit">
                                                            Save</div>
                                                    </button>
                                                    <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                        onclick="return Cancel();">
                                                        <span></span>Cancel</button>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlExamName" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlExamType" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlClass" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlSection" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <div class="clear">
            </div>
            <br />
            <div class="block john-accord content-wrapper5">
                <table width="100%" class="grdList">
                    <tr>
                        <td colspan="8">
                            <div id="dvBody">
                                <asp:GridView ID="grdList" runat="server" Width="100%" AutoGenerateColumns="False"
                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="evennew"
                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <%--   <div class="loading" align="center">
                Loading. Please wait.<br />
                <br />
                <img src="../img/ajax-loader.gif" alt="" />
            </div>--%>
        </div>
    </div>
</asp:Content>
