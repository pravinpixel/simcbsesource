<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="HostelFees.aspx.cs" Inherits="Students_HostelFees" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%="<link href='" + ResolveUrl("~/css/managefees.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript">

        $(function () {
            $('#txtRegNo').focus();
            //        GetStudentInfos Function on page load
            var view = $("[id*=hfViewPrm]").val();
            //            if (view == 'true')
            //                GetStudentsDetail(1);
            //        GetModuleID('Students/TCSearch.aspx');
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
            if ($("[id*=hdnRegNo]").length > 0) {
                $('#txtRegNo').val($("[id*=hdnRegNo]").val());
                BindStudDetails();
                GetAcademicDetails();
            }
        });
    </script>
    <%--Get Academic Details--%>
    <script type="text/javascript">
        function GetAcademicDetails() {
            var parameters = '{"regNo": "' + $("[id*=hdnRegNo]").val() + '","academicId": "' + $("[id*=hdnAcademicId]").val() + '","editPrm": "' + $("[id*=hfEditPrm]").val() + '","delPrm": "' + $("[id*=hfDeletePrm]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Fees/HostelFees.aspx/BindAcademicYearMonth",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetAcademicSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetAcademicSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var firstContent = xml.find("FirstContent");
            var secondContent = xml.find("SecondContent");
            var thirdContent = xml.find("ThirdContent");
            $.each(firstContent, function () {
                $("[id*=divAcademicFees]").html($(this).find("firsthtml").text())
            });

            $.each(secondContent, function () {
                $("#divBillContents").html($(this).find("secondhtml").text());
                setDatePicker('txtBillDate');
                $('#txtBillDate').val($('[id*=hdnDate]').val());


            });
            $('#txtRegNo').focus();

        }
    </script>
    <script type="text/javascript">



        function ViewBill(BillId) {
            $.ajax({
                type: "POST",
                url: "../Fees/HostelFees.aspx/ViewBillDetails",
                data: '{"billId":"' + BillId + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnViewBillSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnViewBillSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var billMaster = xml.find("Table");
            var studentBill = xml.find("Table1");
            var SchoolDetails = xml.find("Table2");
            var S_No = 1;

            //  $("[id*=tblFeesBill] tr").not($("[id*=tblFeesBill] tr:first-child")).remove();
            $("[id*=tblViewBill] tr").remove();

            $.each(billMaster, function () {
                $("[id*=lblRegNo]").html($(this).find("RegNo").text());
                $("[id*=lblBillNo]").html($(this).find("BillNo").text());
                $("[id*=lblStudentName]").html($(this).find("StName").text());
                $("[id*=lblClassName]").html($(this).find("ClassName").text());
                $("[id*=lblSection]").html($(this).find("SectionName").text());
                $("[id*=lblForMonth]").html($(this).find("Billmonth").text());
                $("[id*=lblTotAmt]").html($(this).find("TotalAmount").text());
                $("[id*=lblFeesDate]").html($(this).find("BillDate").text());
                $("[id*=lblCashier]").html($(this).find("staffname").text());

            });

            $.each(studentBill, function () {

                var row = "<tr><td class=\"billHead\" width=\"8%\" height=\"25\" align=\"center\">" + S_No + "</td>" +
                          "<td class=\"billHead\" width=\"54%\">" + $(this).find("FeesHeadName").text() + "</td>" +
                          "<td class=\"billHeadAmt\"  width=\"54%\">" + $(this).find("Amount").text() + "</td></tr>";
                $("[id*=tblViewBill]").append(row);
                S_No += 1;
            });

            $.each(SchoolDetails, function () {

                $("[id*=lblSchoolName]").html($(this).find("SchoolName").text());
                $("[id*=lblSchoolState]").html($(this).find("SchoolState").text());
                $("[id*=lblSchZip]").html($(this).find("SchoolZip").text());
                $("[id*=lblSchPhone]").html($(this).find("phoneno").text());
            });

            $('#divFeesPrint').css("display", "block");

        }

        function SaveFeesBill(Regno, AcademicId, FeesHeadIds, FeesAmount, FeesCatId, FeesMonthName, FeestotalAmount) {
            $("#btnSubmit").attr("disabled", "true");
            $.ajax({
                type: "POST",
                url: "../Fees/HostelFees.aspx/SaveBillDetails",
                data: '{"regNo":"' + Regno + '","AcademicId":"' + AcademicId + '","FinancialId":"' + '","FeesHeadIds":"' + FeesHeadIds + '","FeesAmount":"' + FeesAmount + '","FeesCatId":"' + FeesCatId + '","FeesMonthName":"' + FeesMonthName + '","FeestotalAmount":"' + FeestotalAmount + '","BillDate":"' + $("[id*=txtBillDate]").val() + '","userId":"' + $("[id*=hdnUserId]").val() + '","PaymentMode":"' + $('#selPaymentMode').val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == "Updated") {
                        AlertMessage('success', 'Saved');
                        $("#btnSubmit").attr("disabled", "disabled");

                    }
                    else if (response.d == "Failed") {
                        AlertMessage('fail', 'Failed');
                    }
                    $('#divBillDetials').css("display", "none");
                    GetAcademicDetails();

                },
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function DeleteBill(billId) {
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Fees/HostelFees.aspx/DeleteBill",
                        data: '{"billId":"' + billId + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnDeleteBillSuccess,
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
        function OnDeleteBillSuccess(response) {
            if (response.d == '') {
                AlertMessage('success', "Deleted");
                GetAcademicDetails();
            }
            else {
                AlertMessage('fail', "Delete");
            }
        }
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
    </script>
    <script src="../prettyphoto/js/prettyPhoto.js" type="text/javascript"></script>
    <script type="text/javascript" charset="utf-8">
        function closeBillView() {
            $('#divFeesPrint').css("display", "none");

        }
        function CreateBill() {
            $('#divBillDetials').css("display", "block");
        }

        function closeCreateBill() {
            $('#divBillDetials').css("display", "none");
        }


        function IgnoreBill(Regno, AcademicId, FeesHeadIds, FeesAmount, FeesCatId, FeesMonthName, FeestotalAmount) {

            if (jConfirm('Are you sure to Ignore this Month Bill?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Fees/HostelFees.aspx/SaveBillDetails",
                        data: '{"regNo":"' + Regno + '","AcademicId":"' + AcademicId + '","FinancialId":"' + '","FeesHeadIds":"' + FeesHeadIds + '","FeesAmount":"' + FeesAmount + '","FeesCatId":"' + FeesCatId + '","FeesMonthName":"' + FeesMonthName + '","FeestotalAmount":"' + FeestotalAmount + '","BillDate":"' + $("[id*=txtBillDate]").val() + '","userId":"' + $("[id*=hdnUserId]").val() + '","PaymentMode":"0"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d == "Updated") {
                                AlertMessage('success', 'Saved');

                            }
                            else if (response.d == "Failed") {
                                AlertMessage('fail', 'Failed');
                            }
                            GetAcademicDetails();

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

        function PrintBill(BillId) {
            $.ajax({
                type: "POST",
                url: "../Fees/HostelFees.aspx/PrintBillDetails",
                data: '{"billId":"' + BillId + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {


                },
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }


        function LoadData() {
            $("[id*=hdnRegNo]").val($('#txtBarcode').val());
            GetAcademicDetails();
            BindStudDetails();
            $("[id*=txtRegNo]").focus();

        }
        function onEnter(event) {
            if (event)
                if (event.keyCode == 13) {
                    $("[id*=txtBarcode]").val($('#txtRegNo').val());
                    $("[id*=hdnRegNo]").val($('#txtBarcode').val());
                    $("[id*=txtRegNo]").val("");
                    $("[id*=txtBarcode]").focus();
                }
        }
    


    </script>
    <script type="text/javascript">
        function BindStudDetails() {
            var parameters = '{"regNo": "' + $("[id*=hdnRegNo]").val() + '","academicId": "' + $("[id*=hdnAcademicId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Fees/HostelFees.aspx/BindStudDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnBindStudDetails,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnBindStudDetails(response) {
            var xmlDoc = $.parseXML(response.d);

            var xml = $(xmlDoc);
            $('#txtstudName').val(xml.find("stname").text());
            $('#txtstudClass').val(xml.find("classname").text());
            $('#txtstudSections').val(xml.find("sectionname").text());
            if (xml.find("PresentStatus").text() == "Inactive") {
                jAlert('Can\'t Display the Fees Bill, B\'coz he/she is not active. !!!');
            }
            if (xml.find("AdminNo").text() == "0" || xml.find("AdminNo").text() == "") {
                jAlert('Can\'t Display the Fees Bill, B\'coz the student admission is not approved. !!!');
            }
        }
   
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Hostel Fees
            </h2>
            <div class="clear">
            </div>
            <div class="block content-wrapper2">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td height="30">
                            <table class="form" width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="8%" height="30" style="font-size: 20px;">
                                        <label>
                                            Reg/Bar Code No
                                        </label>
                                    </td>
                                    <td width="1%">
                                        <strong>
                                            <input type="text" id="txtRegNo" name="txtRegNo" onkeypress="onEnter(event)" class="barcode"
                                                style="height: 50px; width: 200px; font-size: 30px;" /></strong>
                                    </td>
                                    <td width="10%" height="30" style="font-size: 20px; padding-left: 10px;">
                                        <label>
                                            Student Reg. No.
                                        </label>
                                    </td>
                                    <td width="20%">
                                        <input type="text" id="txtBarcode" name="txtBarcode" onfocus="LoadData();" class="barcode"
                                            style="height: 50px; width: 200px; font-size: 30px;" />
                                    </td>
                                    <td colspan="3">
                                       <h5> <label>
                                            Name :</label><input type="text" id="txtstudName" readonly="readonly" style="border-style: none ; width:300px;font-weight: bold;"
                                                class="mini" /><br />
                                        <label>
                                            Class :</label>
                                        <input type="text" id="txtstudClass" readonly="readonly" style="border-style: none; font-weight: bold;"
                                            class="mini" /><br />
                                        <label>
                                            Section :</label>
                                        <input type="text" id="txtstudSections" readonly="readonly" style="border-style: none; font-weight: bold;"
                                            class="mini" /></h5>
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td height="30" class="formsubheading">
                            <span>Hostel Fee Structure</span>
                        </td>
                    </tr>
                    <tr>
                        <td height="30">
                            <div class="block content-wrapper2">
                                <div style="overflow: auto; height: 300px;">
                                    <br />
                                    <div class="block" id="divAcademicFees">
                                    </div>
                                </div>
                                <div id="divFeesPrint" style="background: url(../img/overly.png) repeat; width: 100%;
                                    display: none; height: 100%; position: fixed; top: 0; left: 0; z-index: 10000;">
                                    <div style="position: absolute; top: 15%; left: 31%;">
                                        <table width="600" border="0" cellpadding="0" cellspacing="0" id="tableTC" style="border: 8px solid #bfbfbf;
                                            background-color: #fff;">
                                            <tr>
                                                <td style="padding: 10px 10px 0px; float: right;">
                                                    <a href="javascript:closeBillView()">Close</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 10px 10px 0px;">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td height="60" colspan="2" align="center" valign="top" style="border-bottom: 1px solid #bfbfbf;
                                                                font-family: Arial, Helvetica, sans-serif; font-size: 22px; font-weight: bold;
                                                                color: #000; line-height: 25px;">
                                                                <label id="lblSchoolName">
                                                                </label>
                                                                <br />
                                                                <span class="BillSchPhone">
                                                                    <label id="lblSchoolState">
                                                                    </label>
                                                                    -
                                                                    <label id="lblSchZip">
                                                                    </label>
                                                                    . PHONE NO -
                                                                    <label id="lblSchPhone">
                                                                    </label>
                                                                </span>
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
                                                                            R.No
                                                                        </td>
                                                                        <td width="3%">
                                                                            :
                                                                        </td>
                                                                        <td width="21%">
                                                                            <label id="lblBillNo">
                                                                            </label>
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
                                                                            Term
                                                                        </td>
                                                                        <td>
                                                                            :
                                                                        </td>
                                                                        <td>
                                                                            <label id="lblForMonth">
                                                                            </label>
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
                                                                Date :
                                                                <label id="lblFeesDate">
                                                                </label>
                                                                <br />
                                                                Cashier :
                                                                <label id="lblCashier">
                                                                </label>
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
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td height="30">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divBillDetials" style="background: url(../img/overly.png) repeat; width: 100%;
                display: none; height: 100%; position: fixed; top: 0; left: 0; z-index: 10000;">
                <div id="divBillContents" style="position: absolute; top: 25%; left: 31%;">
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hdnUserId" runat="server" />
        <asp:HiddenField ID="hdnRegNo" runat="server" />
        <asp:HiddenField ID="hdnAcademicId" runat="server" />
        <asp:HiddenField ID="hdnFinancialId" runat="server" />
        <asp:HiddenField ID="hdnDate" runat="server" />
    </div>
</asp:Content>
