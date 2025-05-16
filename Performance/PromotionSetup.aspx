<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="PromotionSetup.aspx.cs" Inherits="Performance_PromotionSetup" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript">
        function GetPromotionCriteria() {
            var ClassID = $("[id*=ddlClass]").val();
            var parameters = '{"ClassID": "' + ClassID + '"}';
            $.ajax({

                type: "POST",
                url: "../Performance/PromotionSetup.aspx/GetPromotionCriteria",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: onGetPromotionSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function disable() {
           $(".group1").each(function () {
                $(".chkExamName1").each(function () {
                    $(this).attr("checked", false);
                    $(this).attr("disabled", true);
                });
            });
           
        }
        function enable() {
            $(".group1").each(function () {
            $(".chkExamName1").each(function () {
                $(this).attr("disabled", false);
            });
        });
        }
        function onGetPromotionSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var PromotionMaster = xml.find("Table");
            var PromotionDetails = xml.find("Table1");
            var SubjectType = xml.find("Table2");
           
            if (SubjectType.length > 0) {
                $.each(SubjectType, function () {
                    var strSubjectType = "";
                    strSubjectType = $(this).find("SubjectType").text();
                    if (strSubjectType == "General") {
                        enable();
                    }
                    else if (strSubjectType == "Samacheer") {
                        disable();
                    }
                });
            }
            if (PromotionMaster.length > 0) {
                $.each(PromotionMaster, function () {
                    var Type = "";
                    Type = $(this).find("Type").text();
                    var PromotionID = "";
                    PromotionID = $(this).find("PromotionID").text();
                    var Status = "";
                    Status = $(this).find("Status").text();
                    if (Type == "CaseI") {
                        $("[id*=txtCase1]").val($(this).find("TotalMarks").text());
                    }
                    else if (Type == "CaseII") {
                        $("[id*=txtCase2]").val($(this).find("TotalMarks").text());
                    }
                    else if (Type == "CaseIII") {
                        $("[id*=txtCase3]").val($(this).find("TotalMarks").text());
                    }
                    if (PromotionID != null) {
                        if (PromotionDetails.length > 0) {
                            $.each(PromotionDetails, function () {
                                var PromotionId = "";
                                PromotionId = $(this).find("PromotionId").text();
                                if (PromotionId == PromotionID) {
                                    $("[id*=txtGroup1]").val($(this).find("MarkPercentage1").text());
                                    $("[id*=txtGroup2]").val($(this).find("MarkPercentage2").text());
                                    $("[id*=txtGroup3]").val($(this).find("MarkPercentage3").text());
                                    $("[id*=txtGroup4]").val($(this).find("MarkPercentage4").text());

                                    if (Status == "P1") {
                                        var ExamIdList1 = $(this).find("ExamIdList1").text();
                                        for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnList1']")).length; i++) {
                                            if (ExamIdList1 == $("[id*=rbtnList1_" + i + "]").val()) {
                                                $("[id*=rbtnList1_" + i + "]").attr("checked", true);
                                            }
                                        }
                                    }

                                    if (Status == "P2") {
                                        var ExamIdList1 = $(this).find("ExamIdList1").text();
                                        var tmp = ExamIdList1.split(',');
                                        if (tmp.length > 0) {
                                            $(".group1").each(function () {
                                                $(".chkExamName1").each(function () {
                                                    for (var i = 0; i < tmp.length; i++) {
                                                        var DateVal = $(this).val();
                                                        if (tmp[i] == DateVal) {
                                                            $(this).attr("checked", true);
                                                        }
                                                    }
                                                });
                                            });

                                        }

                                        var ExamIdList2 = $(this).find("ExamIdList2").text();
                                        for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnList2']")).length; i++) {
                                            if (ExamIdList2 == $("[id*=rbtnList2_" + i + "]").val()) {
                                                $("[id*=rbtnList2_" + i + "]").attr("checked", true);
                                            }
                                        }

                                        var ExamIdList3 = $(this).find("ExamIdList3").text();
                                        for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnList3']")).length; i++) {
                                            if (ExamIdList3 == $("[id*=rbtnList3_" + i + "]").val()) {
                                                $("[id*=rbtnList3_" + i + "]").attr("checked", true);
                                            }
                                        }

                                        var ExamIdList4 = $(this).find("ExamIdList4").text();
                                        for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnList4']")).length; i++) {
                                            if (ExamIdList4 == $("[id*=rbtnList4_" + i + "]").val()) {
                                                $("[id*=rbtnList4_" + i + "]").attr("checked", true);
                                            }
                                        }

                                        //                                        var ExamIdList2 = $(this).find("ExamIdList2").text();
                                        //                                        var tmp = ExamIdList2.split(',');
                                        //                                        if (tmp.length > 0) {
                                        //                                            $(".group2").each(function () {
                                        //                                                $(".chkExamName2").each(function () {
                                        //                                                    for (var i = 0; i < tmp.length; i++) {
                                        //                                                        var DateVal = $(this).val();
                                        //                                                        if (tmp[i] == DateVal) {
                                        //                                                            $(this).attr("checked", true);
                                        //                                                        }
                                        //                                                    }
                                        //                                                });
                                        //                                            });

                                        //                                        }

                                        //                                        var ExamIdList3 = $(this).find("ExamIdList3").text();
                                        //                                        var tmp = ExamIdList3.split(',');
                                        //                                        if (tmp.length > 0) {
                                        //                                            $(".group3").each(function () {
                                        //                                                $(".chkExamName3").each(function () {
                                        //                                                    for (var i = 0; i < tmp.length; i++) {
                                        //                                                        var DateVal = $(this).val();
                                        //                                                        if (tmp[i] == DateVal) {
                                        //                                                            $(this).attr("checked", true);
                                        //                                                        }
                                        //                                                    }
                                        //                                                });
                                        //                                            });

                                        //                                        }


                                        //                                        var ExamIdList4 = $(this).find("ExamIdList4").text();
                                        //                                        var tmp = ExamIdList4.split(',');
                                        //                                        if (tmp.length > 0) {
                                        //                                            $(".group4").each(function () {
                                        //                                                $(".chkExamName4").each(function () {
                                        //                                                    for (var i = 0; i < tmp.length; i++) {
                                        //                                                        var DateVal = $(this).val();
                                        //                                                        if (tmp[i] == DateVal) {
                                        //                                                            $(this).attr("checked", true);
                                        //                                                        }
                                        //                                                    }
                                        //                                                });
                                        //                                            });

                                        //                                        }

                                    }

                                }
                            });
                        }

                    }

                });

            }
            else {
                $("[id*=txtCase1]").val('');
                $("[id*=txtCase2]").val('');
                $("[id*=txtCase3]").val('');
                $("[id*=txtGroup1]").val('');
                $("[id*=txtGroup2]").val('');
                $("[id*=txtGroup3]").val('');
                $("[id*=txtGroup4]").val('');

                for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnList1']")).length; i++) {
                    $("[id*=rbtnList1_" + i + "]").attr("checked", false);
                }

                $(".group1").each(function () {
                    $(".chkExamName1").each(function () {
                        $(this).attr("checked", false);
                    });
                });

                for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnList2']")).length; i++) {
                    $("[id*=rbtnList2_" + i + "]").attr("checked", false);
                }

                for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnList3']")).length; i++) {
                    $("[id*=rbtnList3_" + i + "]").attr("checked", false);
                }

                for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnList4']")).length; i++) {
                    $("[id*=rbtnList4_" + i + "]").attr("checked", false);
                }
                //                $(".group2").each(function () {
                //                    $(".chkExamName2").each(function () {
                //                            $(this).attr("checked", false);
                //                    });
                //                });

                //                $(".group3").each(function () {
                //                    $(".chkExamName3").each(function () {
                //                            $(this).attr("checked", false);
                //                    });
                //                });

                //                $(".group4").each(function () {
                //                    $(".chkExamName4").each(function () {
                //                            $(this).attr("checked", false);
                //                    });
                //                });
            }
        };
        function GetGroup1List() {
            var sqlstr1 = '';
            var subQuery;

            $(".group1").each(function () {
                var chk = $(this).find('input.chkExamName1').is(':checked');
                if (chk == true) {
                    subQuery = $(this).find('input.chkExamName1').val();
                    if (sqlstr1 == '')
                        sqlstr1 = subQuery;
                    else
                        sqlstr1 += ',' + subQuery;
                }
            });

            return sqlstr1;
        }

        function GetGroup2List() {
            var sqlstr1 = '';
            var subQuery;

            $(".group2").each(function () {
                var chk = $(this).find('input.chkExamName2').is(':checked');
                if (chk == true) {
                    subQuery = $(this).find('input.chkExamName2').val();
                    if (sqlstr1 == '')
                        sqlstr1 = subQuery;
                    else
                        sqlstr1 += ',' + subQuery;
                }
            });

            return sqlstr1;
        }

        function GetGroup3List() {
            var sqlstr1 = '';
            var subQuery;

            $(".group3").each(function () {
                var chk = $(this).find('input.chkExamName3').is(':checked');
                if (chk == true) {
                    subQuery = $(this).find('input.chkExamName3').val();
                    if (sqlstr1 == '')
                        sqlstr1 = subQuery;
                    else
                        sqlstr1 += ',' + subQuery;
                }
            });

            return sqlstr1;
        }

        function GetGroup4List() {
            var sqlstr1 = '';
            var subQuery;

            $(".group4").each(function () {
                var chk = $(this).find('input.chkExamName4').is(':checked');
                if (chk == true) {
                    subQuery = $(this).find('input.chkExamName4').val();
                    if (sqlstr1 == '')
                        sqlstr1 = subQuery;
                    else
                        sqlstr1 += ',' + subQuery;
                }
            });

            return sqlstr1;
        }
        function SavePromotion() {
            if ($('#aspnetForm').valid()) {
                $("[id*=btnSubmit]").attr("disabled", "true");
                var PromotionID = $("[id*=hfPromotionID]").val();
                var ClassID = $("[id*=ddlClass]").val();

                var CaseI;
                var CaseIExamNameID;
                var CaseIStatus = "P1";
                var NameList1 = "";
                var NameList2 = "";
                var NameList3 = "";
                var NameList4 = "";

                NameList1 = $('#<%=rbtnList1.ClientID %> input[type=radio]:checked').val();

                CaseIExamNameID = NameList1;

                CaseI = CaseIExamNameID + "-" + $("[id*= txtCase1]").val() + "-" + CaseIStatus;

                var CaseII;
                var CaseIIExamNameID;
                var CaseIIStatus = "P2";
                var Group1Value = "";
                var Group2Value = "";
                var Group3Value = "";
                var Group4Value = "";

                Group1Value = GetGroup1List();



                NameList2 = $('#<%=rbtnList2.ClientID %> input[type=radio]:checked').val();
                Group2Value = NameList2;
                //Group2Value = GetGroup2List();

                NameList3 = $('#<%=rbtnList3.ClientID %> input[type=radio]:checked').val();
                Group3Value = NameList3;
                //  Group3Value = GetGroup3List();

                NameList4 = $('#<%=rbtnList4.ClientID %> input[type=radio]:checked').val();
                Group4Value = NameList4;
                // Group4Value = GetGroup4List();

                CaseIIExamNameID = Group1Value + "-" + $("[id*= txtGroup1]").val() + "-" + Group2Value + "-" + $("[id*= txtGroup2]").val() + "-" + Group3Value + "-" + $("[id*= txtGroup3]").val() + "-" + Group4Value + "-" + $("[id*= txtGroup4]").val();

                CaseII = CaseIIExamNameID + "-" + $("[id*= txtCase2]").val() + "-" + CaseIIStatus;

                var CaseIII;
                var CaseIStatus = "P2Mod";
                CaseIII = CaseIExamNameID + "-" + $("[id*= txtCase3]").val() + "-" + CaseIStatus;

                var parameters = '{"ClassID": "' + ClassID + '","CaseI": "' + CaseI + '","CaseII": "' + CaseII + '","CaseIII": "' + CaseIII + '"}';
                $.ajax({

                    type: "POST",
                    url: "../Performance/PromotionSetup.aspx/SavePromotion",
                    data: parameters,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnPromotionSetupSaveSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnPromotionSetupSaveSuccess(response) {
            if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }
            else {
                AlertMessage('fail', response.d);
            }
        };

        function Cancel() {
            $("[id*=ddlClass]").val("");
            $("[id*=txtCase1]").val("");
            $("[id*=txtCase2]").val("");
            $("[id*=txtCase3]").val("");
            $("[id*=txtGroup1]").val("");
            $("[id*=txtGroup2]").val("");
            $("[id*=txtGroup3]").val("");
            $("[id*=txtGroup4]").val("");
            $("[id*=hfPromotionID]").val("");
            $('#aspnetForm').validate().resetForm();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <asp:HiddenField ID="hfAcademicID" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Performance Setup
            </h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2" id="">
                <div>
                    <ul class="section menu">
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Promotion Criteria Setup</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr>
                                                <td align="left">
                                                    <pre style="border: thin solid #FF0000; background-color: #FFFFCC; font-family: Verdana;
                                                        font-weight: bold; font-size: 12px;"> For your Verification &amp; Confirmation before proceeding Promotion...
 1. The Exam that you selected in Case I should be same as in the Exam Name List Group IV . 
 2. Since it is working on huge amount of data and queries, it is very tedious process, so do not refresh the page.
 3. Confirm the data entered once again before you proceed to save the entry.
 4. It is mandatory to fill all Case I, II and III compulsory, if not the result data will not be accurate/correct.</pre>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvExamName" style="float: left; margin: 0 auto; width: 100%" runat="server">
                                                        <table class="form" cellpadding="0" width="100%" cellspacing="0">
                                                            <tr class="even">
                                                                <td class="col1 case" align="right" colspan="2">
                                                                    <label>
                                                                        Class :</label>&nbsp;
                                                                </td>
                                                                <td colspan="2">
                                                                    &nbsp;
                                                                    <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True"
                                                                        onchange="GetPromotionCriteria();">
                                                                        <asp:ListItem Selected="True" Value="">Select</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td>
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td width="15%">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2">
                                                                    &nbsp; &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case">
                                                                    <label>
                                                                        Case I :</label>
                                                                </td>
                                                                <td>
                                                                    <label>
                                                                        ALL Subjects Pass Percentage</label>
                                                                </td>
                                                                <td colspan="3">
                                                                    &nbsp;
                                                                    <label>
                                                                        Apply P-I Criteria based on III Term Examination</label>
                                                                </td>
                                                                <td align="right">
                                                                    <label>
                                                                        Mark(%)</label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtCase1" Width="50" runat="server" CssClass="jsrequired">0</asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case" colspan="2">
                                                                    <label>
                                                                        Exam Name List for P-I Criteria</label>
                                                                </td>
                                                                <td colspan="2">
                                                                    &nbsp; &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td colspan="5">
                                                                    <asp:RadioButtonList ID="rbtnList1" runat="server" RepeatColumns="7" CssClass="jsrequired group0"
                                                                        CellPadding="3" CellSpacing="2" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td colspan="5">
                                                                    &nbsp;
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case">
                                                                    <label>
                                                                        Case II :</label>
                                                                </td>
                                                                <td>
                                                                    <label>
                                                                        ALL the Subjects Pass</label>
                                                                </td>
                                                                <td colspan="3">
                                                                    &nbsp;
                                                                    <label>
                                                                        Apply P-2 Criteria</label>
                                                                </td>
                                                                <td align="right">
                                                                    <label>
                                                                        Mark(%)</label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtCase2" Width="50" runat="server" CssClass="jsrequired">0</asp:TextBox>
                                                                    and above
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case">
                                                                    <label>
                                                                        Exam Name List Group I :</label>
                                                                </td>
                                                                <td colspan="4">
                                                                    &nbsp;
                                                                </td>
                                                                <td align="right">
                                                                    <label>
                                                                        Mark(%)</label>
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtGroup1" Width="50" runat="server" CssClass="jsrequired">0</asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td colspan="5">
                                                                    <%=BindGroup1()%>
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case">
                                                                    <label>
                                                                        Exam Name List Group II :</label>
                                                                </td>
                                                                <td colspan="4">
                                                                    &nbsp;
                                                                </td>
                                                                <td align="right">
                                                                    <label>
                                                                        Mark(%)</label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtGroup2" Width="50" runat="server" CssClass="jsrequired">0</asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1" colspan="5">
                                                                    <%=BindGroup2()%>
                                                                    <asp:RadioButtonList ID="rbtnList2" runat="server" RepeatColumns="7" CssClass="jsrequired group2"
                                                                        CellPadding="3" CellSpacing="2" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case">
                                                                    <label>
                                                                        Exam Name List Group III :</label>
                                                                </td>
                                                                <td colspan="4">
                                                                    &nbsp;
                                                                </td>
                                                                <td align="right">
                                                                    <label>
                                                                        Mark(%)</label>&nbsp;
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtGroup3" Width="50" runat="server" CssClass="jsrequired">0</asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1" colspan="5">
                                                                    <%=BindGroup3()%>
                                                                    <asp:RadioButtonList ID="rbtnList3" runat="server" RepeatColumns="7" CssClass="jsrequired group3"
                                                                        CellPadding="3" CellSpacing="2" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case">
                                                                    <label>
                                                                        Exam Name List Group IV :</label>
                                                                </td>
                                                                <td colspan="4">
                                                                    &nbsp;
                                                                </td>
                                                                <td align="right">
                                                                    <label>
                                                                        Mark(%)</label>&nbsp;
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtGroup4" Width="50" runat="server" CssClass="jsrequired">0</asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1" colspan="5">
                                                                    <%=BindGroup4()%>
                                                                    <asp:RadioButtonList ID="rbtnList4" runat="server" RepeatColumns="7" CssClass="jsrequired group4"
                                                                        CellPadding="3" CellSpacing="2" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1 case">
                                                                    <label>
                                                                        Case III :</label>
                                                                </td>
                                                                <td colspan="2">
                                                                    <label>
                                                                        Moderation Pass Mark
                                                                    </label>
                                                                    &nbsp;&nbsp;
                                                                </td>
                                                                <td colspan="2">
                                                                    <label>
                                                                        Apply P-2 MOD Criteria</label>
                                                                </td>
                                                                <td align="right">
                                                                    <label>
                                                                        Mark(%)</label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtCase3" Width="50" runat="server" CssClass="jsrequired">0</asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr class="even">
                                                                <td class="col1">
                                                                    <asp:HiddenField ID="hfPromotionID" runat="server" />
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2">
                                                                    &nbsp;
                                                                    <button id="btnExamSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SavePromotion();">
                                                                        <div id="spExamSubmit">
                                                                            Save</div>
                                                                    </button>
                                                                    <button id="btnExamNameCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                        runat="server" onclick="return Cancel();">
                                                                        Cancel</button>
                                                                </td>
                                                                <td>
                                                                </td>
                                                                <td align="right">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                        </table>
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
