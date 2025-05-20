<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="ManageSchoolFees.aspx.cs" Inherits="Students_ManageSchoolFees" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%="<link href='" + ResolveUrl("~/css/ManageFees.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
      <%="<link href='" + ResolveUrl("~/css/PrintFees.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
     <link type="text/css" href="../css/Barcodeprint.css" />
   <style type="text/css">
      /*  img.barcode
        {
            width: 201px !important;
            height: 75px !important;
            max-width: none;
            max-height: none;
        }*/
        
        .barcodeimage img
        {
             max-width: inherit;
        }
        .barcodefont {font-family: "Free 3 of 9";font-size:40px;}
        .barcodetext {letter-spacing:7px;font-size:18px;}
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            setDatePicker("[id*=txtDateofBusReg]");
        });
        function showbus() {
            if (document.getElementById('rbtnBusYes').checked == true) {
                $("#dvbus").slideDown("slow");
                $("[id*=btnBusRouteSubmit]").removeAttr("disabled");
                $("[id*=txtDateofBusReg]").val('');
            }
            if (document.getElementById('rbtnBusNo').checked == true) {
                $("#dvbus").slideUp("slow");
            }

        }

        function SaveBusRouteDetails() {
            if (($("[id*=hfAddPrm]").val() == 'true') ||
            ($("[id*=hfEditPrm]").val() == 'true')
            ) {
                if ($("[id*=hfRegNo]").val() != '') {
                    if ($('#aspnetForm').valid()) {
                        $("[id*=btnBusRouteSubmit]").attr("disabled", "true");
                        var RegNo = $("[id*=hdnRegNo]").val();
                        var BusFacility;
                        if ($("[id*=rbtnBusYes]").is(':checked')) {
                            BusFacility = "Y";
                        }

                        else if ($("[id*=rbtnBusNo]").is(':checked')) {
                            BusFacility = "N";
                        }
                        var RouteCode = $("[id*=ddlRouteCode]").val();
                        var Academicyear = $("[id*=hfAcademicyear]").val();
                        var RegDate = $("[id*=txtDateofBusReg]").val();
                        var parameters = '{"id": "' + RegNo + '","routeid": "' + RouteCode + '","regdate": "' + RegDate + '"}';
                        var baseurl = "../Students/ManageSchoolFees.aspx/SaveBusRouteInfo";

                        $.ajax({
                            type: "POST",
                            url: baseurl,
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnSaveBusRouteDetailsSuccess,
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
                    AlertMessage('info', "Please Enter Personal Details");
                    changeAccordion(0);
                }
            }
        }

        function OnSaveBusRouteDetailsSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                var RegNo = $("[id*=hdnRegNo]").val();
                LoadData();

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                var RegNo = $("[id*=hdnRegNo]").val();
                LoadData();

            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
            }
            else {
                AlertMessage('info', response.d);
                $("[id*=btnBusRouteSubmit]").attr("disabled", "false");
                $("[id*=rbtnBusNo]").attr("checked", "checked");
                showbus();
            }

        };
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
    <style type="text/css">
.billcont {font-family:Arial, Helvetica, sans-serif;font-size:19px;}
.ph {font-family:Arial, Helvetica, sans-serif;font-size:16px;}
    </style>
    <%--Get Academic Details--%>
    <script type="text/javascript">
        function GetAcademicDetails() {
            var btype = "";
            if ($("[id*=rbtnMonth]").is(':checked')) {
                btype = "Single";
            }
            else if ($("[id*=rbtnBiMonth]").is(':checked')) {
                btype = "Double";
            }
            var parameters = '{"regNo": "' + $("[id*=hdnRegNo]").val() + '","academicId": "' + $("[id*=hdnAcademicId]").val() + '","editPrm": "' + $("[id*=hfEditPrm]").val() + '","delPrm": "' + $("[id*=hfDeletePrm]").val() + '","btype": "' + btype + '"}';
            $.ajax({
                type: "POST",
                url: "../Students/ManageSchoolFees.aspx/BindAcademicYearMonth",
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
            console.log("secondContent", secondContent);
            console.log("thirdContent", thirdContent);
            $('#divAdvanceFee').css("display", "none");
            $.each(firstContent, function () {
                $("[id*=divAcademicFees]").html($(this).find("firsthtml").text())
            });

            $.each(secondContent, function () {
                $("#divBillContents").html($(this).find("secondhtml").text());
                setDatePicker('txtBillDate');
                $('#txtBillDate').val($('[id*=hdnDate]').val());


            });
            $.each(thirdContent, function () {
                var third = $(this).find("thirdhtml").text();
                if (third.length > 0) {
                    $("#divAdvanceFeeContent").html($(this).find("thirdhtml").text());
                    $('#divAdvanceFee').css("display", "block");
                }


            });
            $('#txtRegNo').focus();
        }
    </script>
    <script type="text/javascript">



        function ViewBill(BillId) {
            $.ajax({
                type: "POST",
                url: "../Students/ManageSchoolFees.aspx/ViewBillDetails",
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
            console.log("studentBill", studentBill);
            var SchoolDetails = xml.find("Table2");
            var S_No = 1;

            //  $("[id*=tblViewBill] tr").not($("[id*=tblViewBill] tr:first-child")).remove();
            $("[id*=tblViewBill] tr").remove();

            var totalConcession = 0;

            $.each(studentBill, function (index, element) {                
                var concessionamount = parseFloat($(element).find("concessionamount").text()) || 0;
                totalConcession += concessionamount;
                console.log("element", element);
                console.log("concessionamount", concessionamount);
            });

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
               // $("[id*=lblConcessionAmt]").html(totalConcession.toFixed(2));
                if (totalConcession > 0) {
                    $("#lblConcessionAmt").html(totalConcession.toFixed(2));
                    $("#lblConcessionAmt").closest("div").show(); // Show the parent div
                } else {
                    $("#lblConcessionAmt").closest("div").hide(); // Hide the parent div if amount is 0
                }
            });

           

            $.each(studentBill, function () {

                var row = "<tr><td class=\"billHead\" width=\"8%\" height=\"25\" align=\"center\">" + S_No + "</td>" +
                    "<td class=\"billHead\" width=\"54%\">" + $(this).find("FeesHeadName").text() + "</td>" +
                    "<td class=\"billHeadAmt\"  width=\"54%\">" + $(this).find("actualamount").text() + "</td></tr>";
                    //"<td class=\"billHeadActualAmt\" width=\"54%\">" + $(this).find("actualamount").text() + "</td></tr>";
                      //    "<td class=\"billHeadAmt\"  width=\"54%\">" + $(this).find("Amount").text() + "</td></tr>";
                $("[id*=tblViewBill]").append(row);
                S_No += 1;
            });

            $.each(SchoolDetails, function () {

                $("[id*=lblSchoolName]").html($(this).find("SchoolName").text());
                $("[id*=lblSchoolState]").html($(this).find("SchoolState").text());
                $("[id*=lblSchZip]").html($(this).find("SchoolZip").text());
                $("[id*=lblSchPhone]").html($(this).find("PhoneNo").text());
            });

            $('#divFeesPrint').css("display", "block");

        }

        function SaveFeesBill(Regno, AcademicId, FeesHeadIds, FeesAmount, FeesCatId, FeesMonthName, FeestotalAmount, FeesHeadActualAmt, FeesHeadConcessionAmt, feeCategory) {
            $("#btnSubmit").attr("disabled", "true");

            if ($("[id*=hdnUpdateBillID]").val().length == 0) {

                $.ajax({
                    type: "POST",
                    url: "../Students/ManageSchoolFees.aspx/SaveBillDetails",
                   // data: '{"regNo":"' + Regno + '","AcademicId":"' + AcademicId + '","FeesHeadIds":"' + FeesHeadIds + '","FeesAmount":"' + FeesAmount + '","FeesCatId":"' + FeesCatId + '","FeesMonthName":"' + FeesMonthName + '","FeestotalAmount":"' + FeestotalAmount + '","BillDate":"' + $("[id*=txtBillDate]").val() + '","userId":"' + $("[id*=hdnUserId]").val() + '","PaymentMode":"' + $('#selPaymentMode').val() + '","CashAmt":"' + $('#txtcashamt').val() + '","CardAmt":"' + $('#txtcardamt').val() + '","QRAmount":"' + $('#txtqramt').val() + '","Remarks":"' + $('#txtremarks').val() + '","MonthNum":"' + $('#hdnMonthNum').val() + '","FeeType":"' + $('#hdnFeeType').val() + '"}',
                    data: '{"regNo":"' + Regno +
                        '","AcademicId":"' + AcademicId +
                        '","FeesHeadIds":"' + FeesHeadIds +
                        '","FeesAmount":"' + FeesAmount +
                        '","FeesCatId":"' + FeesCatId +
                        '","FeesMonthName":"' + FeesMonthName +
                        '","FeestotalAmount":"' + FeestotalAmount +
                        '","FeesHeadActualAmt":"' + FeesHeadActualAmt +
                        '","FeesHeadConcessionAmt":"' + FeesHeadConcessionAmt +
                        '","feeCategory":"' + feeCategory +
                        '","BillDate":"' + $("[id*=txtBillDate]").val() +
                        '","userId":"' + $("[id*=hdnUserId]").val() +
                        '","PaymentMode":"' + $('#selPaymentMode').val() +
                        '","CashAmt":"' + $('#txtcashamt').val() +
                        '","CardAmt":"' + $('#txtcardamt').val() +
                        '","QRAmount":"' + $('#txtqramt').val() +
                        '","Remarks":"' + $('#txtremarks').val() +
                        '","MonthNum":"' + $('#hdnMonthNum').val() +
                        '","FeeType":"' + $('#hdnFeeType').val() + '"}'
                    ,
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
            else {


                $.ajax({
                    type: "POST",
                    url: "../Students/ManageSchoolFees.aspx/UpdateBillDetails",
                    data: '{"BillId":"' + $("[id*=hdnUpdateBillID]").val() + '","AcademicId":"' + AcademicId + '","FeesHeadIds":"' + FeesHeadIds + '","FeesAmount":"' + FeesAmount + '","FeesCatId":"' + FeesCatId + '","FeesMonthName":"' + FeesMonthName + '","FeestotalAmount":"' + FeestotalAmount + '","BillDate":"' + $("[id*=txtBillDate]").val() + '","userId":"' + $("[id*=hdnUserId]").val() + '","PaymentMode":"' + $('#selPaymentMode').val() + '","CashAmt":"' + $('#txtcashamt').val() + '","CardAmt":"' + $('#txtcardamt').val() + '","QRAmount":"' + $('#txtqramt').val() + '","Remarks":"' + $('#txtremarks').val() + '","MonthNum":"' + $('#hdnMonthNum').val() + '","FeeType":"' + $('#hdnFeeType').val() + '"}',
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

                $("[id*=hdnUpdateBillID]").val('');
            }

        }


        function DeleteBill(billId) {
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Students/ManageSchoolFees.aspx/DeleteBill",
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


        function updateBill(BId) {

            $("[id*=hdnUpdateBillID]").val(BId);
            $('#divBillDetials').css("display", "block");
        }

        function closeCreateBill() {
            $('#divBillDetials').css("display", "none");
        }




        function IgnoreExistingBill(Billid, AcademicId, FeesHeadIds, FeesAmount, FeesCatId, FeesMonthName, FeestotalAmount) {

            if (jConfirm('Are you sure to Ignore this Month Bill?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Students/ManageSchoolFees.aspx/UpdateBillDetails",
                        data: '{"BillId":"' + Billid + '","AcademicId":"' + AcademicId + '","FeesHeadIds":"' + FeesHeadIds + '","FeesAmount":"' + FeesAmount + '","FeesCatId":"' + FeesCatId + '","FeesMonthName":"' + FeesMonthName + '","FeestotalAmount":"' + FeestotalAmount + '","BillDate":"' + $("[id*=txtBillDate]").val() + '","userId":"' + $("[id*=hdnUserId]").val() + '","PaymentMode":"0","CashAmt":"' + $('#txtcashamt').val() + '","CardAmt":"' + $('#txtcardamt').val() + '","QRAmount":"' + $('#txtqramt').val() + '","MonthNum":"' + $('#hdnMonthNum').val() + '","FeeType":"' + $('#hdnFeeType').val() + '"}',
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




        function IgnoreBill(Regno, AcademicId, FeesHeadIds, FeesAmount, FeesCatId, FeesMonthName, FeestotalAmount) {

            if (jConfirm('Are you sure to Ignore this Month Bill?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({
                        type: "POST",
                        url: "../Students/ManageSchoolFees.aspx/SaveBillDetails",
                        data: '{"regNo":"' + Regno + '","AcademicId":"' + AcademicId + '","FeesHeadIds":"' + FeesHeadIds + '","FeesAmount":"' + FeesAmount + '","FeesCatId":"' + FeesCatId + '","FeesMonthName":"' + FeesMonthName + '","FeestotalAmount":"' + FeestotalAmount + '","BillDate":"' + $("[id*=txtBillDate]").val() + '","userId":"' + $("[id*=hdnUserId]").val() + '","PaymentMode":"0","CashAmt":"' + $('#txtcashamt').val() + '","CardAmt":"' + $('#txtcardamt').val() + '","QRAmount":"' + $('#txtqramt').val() + '","MonthNum":"' + $('#hdnMonthNum').val() + '","FeeType":"' + $('#hdnFeeType').val() + '"}',
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
                url: "../Students/ManageSchoolFees.aspx/PrintBillDetails",
                data: '{"billId":"' + BillId + '"}',
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
        }


        function OnPrintSuccess(response) {

            if (response.d != '') {
                $(".dvPrint").html(response.d);

                $(".dvPrint").printElement(
            {
                async: false,
                leaveOpen: true,
               
               overrideElementCSS: [

                        '../css/PrintFees.css',

                        { href: '../css/PrintFees.css', media: 'print'}]
            });


            }
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
                url: "../Students/ManageSchoolFees.aspx/BindStudDetails",
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
            if ($('#txtstudName').val() != "") {
                if (xml.find("SportStudent").text() == "1") {
                 setTimeout(() => {
                    jAlert('He/she is Full-time Sport Student, So Request to bill it in the Sport Fee Screen!!!');
                      }, 1000);
                    $("[id*=txtBarcode]").val("");
                    $("[id*=hdnRegNo]").val("");
                    $("[id*=txtRegNo]").val("");
                    $("[id*=txtBarcode]").focus();
                }
                else if (xml.find("SportStudent").text() == "0" && xml.find("StudentId").text() != "") {
                    setTimeout(() => {
                       jAlert('He/she is not a Full-time Sport Student, So Request to bill it in the Sport School Billing!!!');
                    }, 1000);
                 
//                    $("[id*=txtBarcode]").val("");
//                    $("[id*=hdnRegNo]").val("");
//                    $("[id*=txtRegNo]").val("");
//                    $("[id*=txtBarcode]").focus();
                }
                if (xml.find("AdminNo").text() == "0" || xml.find("AdminNo").text() == "") {
                    jAlert('Can\'t Display the Fees Bill, B\'coz the student admission is not approved. !!!');
                }
                else if (xml.find("PresentStatus").text() == "Inactive") {
                    jAlert('Can\'t Display the Fees Bill, B\'coz he/she is not active. !!!');
                }
            }
        }


        function ViewBiMonthBill(BillId) {
            $.ajax({
                type: "POST",
                url: "../Students/ManageSchoolFees.aspx/ViewBiMonthBillDetails",
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


        function SaveFeesBiMonthBill(Regno, AcademicId, FeesHeadIds, FeesAmount, FeesCatId, FeesMonthName, FeestotalAmount, FeesHeadActualAmt, FeesHeadConcessionAmt) {
            $("#btnSubmit").attr("disabled", "true");

            if ($("[id*=hdnUpdateBillID]").val().length == 0) {

                $.ajax({
                    type: "POST",
                    url: "../Students/ManageSchoolFees.aspx/SaveBiMonthBillDetails",
                   // data: '{"regNo":"' + Regno + '","AcademicId":"' + AcademicId + '","FeesHeadIds":"' + FeesHeadIds + '","FeesAmount":"' + FeesAmount + '","FeesCatId":"' + FeesCatId + '","FeesMonthName":"' + FeesMonthName + '","FeestotalAmount":"' + FeestotalAmount + '","BillDate":"' + $("[id*=txtBillDate]").val() + '","userId":"' + $("[id*=hdnUserId]").val() + '","PaymentMode":"' + $('#selPaymentMode').val() + '","CashAmt":"' + $('#txtcashamt').val() + '","CardAmt":"' + $('#txtcardamt').val() + '","MonthNum":"' + $('#hdnMonthNum').val() + '","FeeType":"' + $('#hdnFeeType').val() + '"}',
                    data: '{"regNo":"' + Regno +
                        '","AcademicId":"' + AcademicId +
                        '","FeesHeadIds":"' + FeesHeadIds +
                        '","FeesAmount":"' + FeesAmount +
                        '","FeesCatId":"' + FeesCatId +
                        '","FeesMonthName":"' + FeesMonthName +
                        '","FeestotalAmount":"' + FeestotalAmount +
                        '","FeesHeadActualAmt":"' + FeesHeadActualAmt +
                        '","FeesHeadConcessionAmt":"' + FeesHeadConcessionAmt +
                        '","BillDate":"' + $("[id*=txtBillDate]").val() +
                        '","userId":"' + $("[id*=hdnUserId]").val() +
                        '","PaymentMode":"' + $('#selPaymentMode').val() +
                        '","CashAmt":"' + $('#txtcashamt').val() +
                        '","CardAmt":"' + $('#txtcardamt').val() +
                        '","MonthNum":"' + $('#hdnMonthNum').val() +
                        '","FeeType":"' + $('#hdnFeeType').val() + '"}',

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
            else {


                $.ajax({
                    type: "POST",
                    url: "../Students/ManageSchoolFees.aspx/UpdateBillDetails",
                    data: '{"BillId":"' + $("[id*=hdnUpdateBillID]").val() + '","AcademicId":"' + AcademicId + '","FeesHeadIds":"' + FeesHeadIds + '","FeesAmount":"' + FeesAmount + '","FeesCatId":"' + FeesCatId + '","FeesMonthName":"' + FeesMonthName + '","FeestotalAmount":"' + FeestotalAmount + '","BillDate":"' + $("[id*=txtBillDate]").val() + '","userId":"' + $("[id*=hdnUserId]").val() + '","PaymentMode":"' + $('#selPaymentMode').val() + '","CashAmt":"' + $('#txtcashamt').val() + '","CardAmt":"' + $('#txtcardamt').val() + '","MonthNum":"' + $('#hdnMonthNum').val() + '","FeeType":"' + $('#hdnFeeType').val() + '"}',
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

                $("[id*=hdnUpdateBillID]").val('');
            }

        }


        function PrintBiMonthBill(BillId) {
            $.ajax({
                type: "POST",
                url: "../Students/ManageSchoolFees.aspx/PrintBiMonthBillDetails",
                data: '{"billId":"' + BillId + '"}',
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
        }


        $(document).ready(function () {
            $("input[type='radio']").click(function () {
                var radioValue = $("input[name='btype']:checked").val();
                if (radioValue) {
                    GetAcademicDetails();
                }
            });

            $('.numericswithdecimals').keyup(function () {
                alert('f');
                this.value = this.value.replace(/[^0-9\.]/g, '');
            })
        });

//        $('select').on('change', function () {
//            alert(this.value);
        //        });

        function bindpaymode(sel) {
            $("#txtcashamt").removeAttr("disabled");
            $("#txtcardamt").removeAttr("disabled");
            $("#txtqramt").removeAttr("disabled");
            $("#txtremarks").attr("disabled", "disabled");
            $("#modes").css("display", "none");
            if (sel.value == "4" || sel.value == "8" || sel.value == "9") {
                $("#txtcashamt").removeAttr("disabled");
                $("#txtcardamt").removeAttr("disabled");
                $("#txtqramt").removeAttr("disabled", "disabled");
                $("#txtremarks").attr("disabled", "disabled");
                $("#modes").css("display", "block");
            }
            if (sel.value == "10" || sel.value == "11" || sel.value == "12" || sel.value == "13" || sel.value == "14" || sel.value == "15") {
                $("#txtcashamt").attr("disabled", "disabled");
                $("#txtcardamt").attr("disabled", "disabled");
                $("#txtqramt").attr("disabled", "disabled");
                $("#txtremarks").removeAttr("disabled");
                $("#modes").css("display", "none");
            }

        }
        function checkval(sel) {
            if (!$.isNumeric(sel.value)) {
                sel.value = "0";
                return false;
            }
        }
        
    </script>
     <%="<script src='" + ResolveUrl("~/js/jquery.printElement.js") + "' type='text/javascript'></script>"%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                School Fees Entry
            </h2>
            <div class="clear">
            </div>
            <div align="center" class="block content-wrapper2">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table class="form" width="100%" border="0" cellspacing="0" cellpadding="0">
                                
                                <tr>
                                    <td width="8%" height="30" style="font-size: 20px;">
                                        <label>
                                            Reg/Bar<br />
                                            Code No
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
                                    <td>
                                        <h5>
                                            <label>
                                                Name :</label><input type="text" id="txtstudName" readonly="readonly" style="border-style: none;
                                                    font-weight: bold; width: 300px" /><br />
                                            <label>
                                                Class :</label>
                                            <input type="text" id="txtstudClass" readonly="readonly" style="border-style: none;
                                                font-weight: bold;" class="mini" /><br />
                                            <label>
                                                Section :</label>
                                            <input type="text" id="txtstudSections" readonly="readonly" style="border-style: none;
                                                font-weight: bold;" class="mini" /></h5>
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
                            <span>Billing Type</span>
                        </td>
                    </tr> 
                    <tr>
                        <td height="30" class="formsubheading">
                            <span>Academic Year Fee Structure</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                <input type="radio"  onkeydown="GetAcademicDetails();" checked="checked"  name="btype" id="rbtnMonth" value="Single" />Single
                                Month Billing</label>
                            <label style="display:none;" >
                                <input type="radio"id="rbtnBiMonth" onkeydown="GetAcademicDetails();" name="btype" value="Double" />Bi-month Billing</label>
                        </td>
                    </tr>
                       <tr>
                        <td height="30" class="formsubheading">
                            <span>Do you want to enroll for Bus?</span>&nbsp;
                            <label>
                                <input type="radio" onclick="showbus();"  name="bustype" id="rbtnBusYes"
                                    value="Yes" />Yes</label>
                            <label>
                                <input type="radio" id="rbtnBusNo" onclick="showbus();" checked="checked" name="bustype" value="No" />No</label>

                           
                        </td>
                    </tr>
                       <tr>
                     <td>
                      <div id="dvbus" style="display: none;">
                                <span>Select Bus Route</span>&nbsp;
                                <asp:DropDownList ID="ddlRouteCode" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                </asp:DropDownList>&nbsp;
                                    <asp:TextBox ID="txtDateofBusReg" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>&nbsp;
                                   <button id="btnBusRouteSubmit" type="button" runat="server" class="btn-icon btn-navy btn-update"
                                                    onclick="SaveBusRouteDetails();">
                                                    <span></span>
                                                    <div id="Div1">
                                                        Update</div>
                                                </button>
                            </div>
                     </td>
                     </tr>
                    <tr>
                        <td height="30">
                            <div class="block1">
                                <div style="height: 300px;">
                                    <div style="overflow: auto; display: none;" id="divAdvanceFee">
                                        <span>Advance Fee </span>
                                        <div id="divAdvanceFeeContent">
                                        </div>
                                    </div>
                                    <br />
                                    <div class="block" id="divAcademicFees">
                                    </div>
                                </div>
                                <div id="divFeesPrint" style="background: url(../img/overly.png) repeat; width: 100%;
                                    display: none; height: 100%; position: fixed; top: 0; left: 0; z-index: 10000;">
                                    <div style="position: absolute; top: 15%; left: 31%;">
                                        <table width="600" border="0" cellpadding="0" cellspacing="0" id="tableTC" class="tblViewMain">
                                            <tr>
                                                <td class="ViewClose">
                                                    <a href="javascript:closeBillView()">Close</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="viewTDPadding">
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
                                                                            Month
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
                                                        <%--    <td width="38%" valign="top" style="font-family: Arial, Helvetica, sans-serif; font-size: 18px;
                                                                font-weight: bold; color: #000; padding-right: 25px; padding-top: 5px; text-align: right;
                                                                border-left: 0px solid #bfbfbf; border-top: 1px solid #bfbfbf;">
                                                                 Concession Granted :
                                                                <label id="lblConcessionAmt">
                                                                </label>
                                                                
                                                                Total &raquo; &nbsp;&nbsp;
                                                                <label id="lblTotAmt">
                                                                    0.00</label>
                                                            </td>--%>
<td width="38%" valign="top" style="font-family: Arial, Helvetica, sans-serif; font-size: 13px;
    font-weight: bold; color: #000; padding-right: 25px; padding-top: 5px; text-align: right;
    border-left: 0px solid #bfbfbf; border-top: 1px solid #bfbfbf; line-height: 24px;">

    <div style="display: flex; justify-content: space-between; align-items: center;">
        <span style="white-space: nowrap;">Concession Granted :</span>
        <label id="lblConcessionAmt" style="min-width: 100px; text-align: right;"></label>
    </div>

    <div style="display: flex; justify-content: space-between; align-items: center;">
        <span style="white-space: nowrap;">Total &raquo;&nbsp;&nbsp;</span>
        <label id="lblTotAmt" style="min-width: 100px; text-align: right;"></label>
    </div>
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
                <div id="divBillContents" style="position: absolute; top: 0%; left: 31%;">
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hdnUserId" runat="server" />
        <asp:HiddenField ID="hdnRegNo" runat="server" />
        <asp:HiddenField ID="hdnAcademicId" runat="server" />
        <asp:HiddenField ID="hdnFinancialId" runat="server" />
        <asp:HiddenField ID="hdnDate" runat="server" />
        <asp:HiddenField ID="hdnUpdateBillID" runat="server" />
        
    </div>
      <div class="dvPrint">
    </div>
</asp:Content>
