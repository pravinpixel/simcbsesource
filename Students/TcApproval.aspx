<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="TcApproval.aspx.cs" Inherits="Students_TcApproval" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!--Autocomplete script starts here -->
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <!--Autocomplete script ends here -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript">
        function Cancel() {
            $("[id*=txtRegNo]").val('');
            $("[id*=txtAdminNo]").val('');
            $("[id*=ddlClass]").val('');
            $("[name*=rbGender]").val('');
            $("[id*=ddlClass]").val('');
            $("[id*=ddlSection]").val('');
            $("[id*=txtStudentName]").val('');
            $('#aspnetForm').validate().resetForm();
        };   
        function CheckAll() {
            if ($("[id*=chkBulk]").is(':checked')) {
                $("[id*=bulkView]").attr("style", "display:inline;");
            }
            else {
                $("[id*=bulkView]").attr("style", "display:none;");
            }
        }

        function GetSectionByClass(ID) {
            if (ID != '') {
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
            else {
                var select = $("[id*=ddlSection]");
                select.children().remove();
                select.append($("<option>").val('').text('---Select---'));
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
            GetStudentsDetail(1);
        };

    </script>
    <script type="text/javascript">
        $(function () {
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
           
            GetStudentsDetail(1);
            //        Pager Click Function
            $(".Pager .page").live("click", function (e) {
                GetStudentsDetail(parseInt($(this).attr('page')));
            });

        });

        var gender = "";

        function GetStudentsDetail(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Students/TCApproval.aspx/GetStudentsTCDetail",
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
            var ApporvalStatus = "";
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
                    tcOptionsStatus = "<a href=\"../Students/ViewTransferCertificate.aspx?menuId=" + $("[id*=hfAcdMenuId]").val() + "&activeIndex=0&moduleId=" + $("[id*=hfAcdModuleID]").val() + "&regno=" + regno + "\"><span class='tcsend'> View TC | </span> </a>";
                    tcOptionsStatus += "<a href='#' onclick='ChangeApproval(\"" + regno + "\")' ><span class='tcsend'> Approve TC </span> </a>";

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("row").text());
                    $("td", row).eq(1).html(regno);
                    $("td", row).eq(2).html($(this).find("adminno").text());
                    $("td", row).eq(3).html($(this).find("stname").text());
                    $("td", row).eq(4).html($(this).find("classname").text());
                    $("td", row).eq(5).html($(this).find("sectionname").text());
                    $("td", row).eq(6).html(DueStatusHtml);
                    $("td", row).eq(7).html(ApporvalStatus);
                    $("td", row).eq(8).html(tcOptionsStatus).addClass("editacc"); ;

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
                    $("td", row).eq(4).html("No Result Found");
                    $("td", row).eq(5).html("");
                    $("td", row).eq(6).html("");
                    $("td", row).eq(7).html("");
                    $("td", row).eq(8).html("");

                    $("[id*=grdStudentTCInfo]").append(row);
                }
            }

            if ($("[id*=hfEditPrm]").val() == 'false') {
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
        function ChangeApproval(regno) {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                if (jConfirm('Are you sure to approve this?', 'Confirm', function (r) {
                    if (r) {
                        $.ajax({
                            type: "POST",
                            url: "../Students/TCApproval.aspx/ChangeApproval",
                            data: '{"regNo":"' + regno + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnChangeSuccess,
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
            else {
                return false;
            }
        }
        function OnChangeSuccess(response) {
            if (response.d == '') {
                AlertMessage('success', "Approved TC");
                GetStudentsDetail(1);
            }
            else {
                AlertMessage('fail', "Approving TC Status");
            }
        }
    </script>
    <script type="text/javascript">
        
    </script>
    <%--Popup Section--%>
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

                $("[id*=lblRegNo]").html($(this).find("regno").text());
                $("[id*=lblStudentName]").html($(this).find("stname").text());
                $("[id*=lblClassName]").html($(this).find("classname").text());
                $("[id*=lblSection]").html($(this).find("sectionname").text());
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
    <%--Bulk Section--%>
    <script type="text/javascript">

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

        function BulkApprove() {
            if ($("[id*=hfEditPrm]").val() == 'true') {

                if (jConfirm('Are you sure to approve this?', 'Confirm', function (r) {
                    if (r) {
                        $.ajax({
                            type: "POST",
                            url: "../Students/TCApproval.aspx/UpdateBulkApporval",
                            data: '{"classId": "' + $('[id*=ddlClassForApproval]').val() + '","sectionId":"' + $('[id*=ddlSectionForApproval]').val() + '","userId":"' + $('[id*=hfuserid]').val() + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                if (response.d == "") {
                                    AlertMessage('success', "TC Approved");
                                    GetStudentsDetail(1);
                                }
                                else {
                                    AlertMessage('fail', "Failed");
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
        }

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                Transfer Certificate Approval</h2>
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
                <table>
                    <tr>
                        <td>
                            <strong>TC Bulk Approval </strong>
                            <input type="checkbox" id="chkBulk" onclick="CheckAll()" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
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
                                <span></span>Approve Tc</button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table width="100%" id="gridView">
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
                                    <asp:TemplateField HeaderText="Options" HeaderStyle-CssClass="sorting_mod editacc" ItemStyle-HorizontalAlign="Center">
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
                                    Amalorpavam Lourds Academy<br />
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
    <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetTCStudentName.ashx?input=" + input + "&regNo=" + $("[id*=txtRegNo]").val() + "&Class=" + $("[id*=ddlClass]").val() + "&Section=" + $("[id*=ddlSection]").val() + "&AcademicYearId=" + $("[id*=hdnAcademicYearId]").val() + "&Gender=" + $("[name*=rbGender]:checked").val() + "&testid=" + document.getElementById('testid').value + "&mod=approval"; },
            varname: "input",
            maxentries: 15
        };


        var as_xml = new bsn.AutoSuggest('<%= txtStudentName.ClientID %>', options_xml);    

    </script>
</asp:Content>
