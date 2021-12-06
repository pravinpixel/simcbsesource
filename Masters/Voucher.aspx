<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Voucher.aspx.cs" Inherits="Voucher" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }             
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".desc").hide();
            GetCashVoucher(1);
            GetCashVoucherID();

            GetFuelVoucher(1);
            GetFuelVoucherID();

            GetCashReturnVoucher(1);
            setDatePicker("[id*=txtVoucherDate]");
            setDatePicker("[id*=txtFuelVoucherDate]");
            setDatePicker("[id*=txtChequeDate]");
            setDatePicker("[id*=txtDateofIssue]");
            setDatePicker("[id*=txtDateofReturn]");
        });
        function showDiv() {

            if (document.getElementById('rbtnCashType').checked == true) {
                $(".desc").hide("slow");
            }
            if (document.getElementById('rbtnChequeType').checked == true) {
                $(".desc").show("slow");
            }
        }

        
    </script>
    <script type="text/javascript">

        $(function () {
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetCashVoucher(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);


            GetCashVoucherID();
           // ControlDisable(strval);
        });

//        var strval = "";
//        function ControlDisable(value) {
//            alert(value);
//            if (value == 'False') {
//                $("table.form :input").attr('readonly', 'readonly');
//            }
//            else
//                $("table.form :input").attr('readonly', 'readonly');

//            strval = value;
//        }
        //        GetCashVoucher Function

        function GetCashVoucher(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Masters/Voucher.aspx/GetCashVoucher",
                    data: '{pageIndex: ' + pageIndex + '}',
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
        function GetCashVoucherID() {
            $.ajax({
                type: "POST",
                url: "../Masters/Voucher.aspx/GetCashVoucherID",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnCashVoucherIDSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnCashVoucherIDSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cashvoucherids = xml.find("CashVoucherIDs");
            $.each(cashvoucherids, function () {
                var icashvoucherid = $(this);
                $("[id*=txtVoucherNo]").val($(this).find("CashVoucherID").text());
                $("[id*=txtVoucherNo]").attr('readonly', 'readonly');
            });

        };

        //        GetCashVoucher On Success Function
        //        Get CashVoucher to Grid

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cashvouchers = xml.find("CashVouchers");
            var row = $("[id*=dgCashVoucher] tr:last-child").clone(true);
            $("[id*=dgCashVoucher] tr").not($("[id*=dgCashVoucher] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditCashVoucher('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteCashVoucher('";
                danchorEnd = "');\">Delete</a>";
            }

            var panchor = "<a  href=\"javascript:ReprintCashVoucher('";
            var panchorend = "');\">Reprint</a>";

            if (cashvouchers.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("No Records Found").attr("align", "left");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("td", row).eq(8).html("");
                $("td", row).eq(9).html("");
                $("td", row).eq(10).html("");
                $("td", row).eq(11).html("");
                $("td", row).eq(12).html("").removeClass("editacc edit-links");
                $("td", row).eq(13).html("").removeClass("editacc edit-links");
                $("td", row).eq(14).html("").removeClass("deleteacc delete-links");
                $("[id*=dgCashVoucher]").append(row);
                row = $("[id*=dgCashVoucher] tr:last-child").clone(true);

            }
            else {
                $.each(cashvouchers, function () {
                    var iCashVoucher = $(this);
                    var ehref = eanchor + $(this).find("CashVoucherID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("CashVoucherID").text() + danchorEnd;
                    var print = panchor + $(this).find("CashVoucherID").text() + panchorend;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("VoucherType").text());
                    $("td", row).eq(1).html($(this).find("VoucherNo").text());
                    $("td", row).eq(2).html($(this).find("PaymentTo").text());
                    $("td", row).eq(3).html($(this).find("PaymentFor").text());
                    $("td", row).eq(4).html($(this).find("Amount").text());
                    $("td", row).eq(5).html($(this).find("PaymentDate").text());
                    $("td", row).eq(6).html($(this).find("BillNo").text());
                    $("td", row).eq(7).html($(this).find("ExpenseTypeName").text());
                    $("td", row).eq(8).html($(this).find("PayType").text());
                    $("td", row).eq(9).html($(this).find("ChequeNo").text());
                    $("td", row).eq(10).html($(this).find("ChequeDate").text());
                    $("td", row).eq(11).html($(this).find("AccountNo").text());
                    $("td", row).eq(12).html(print).addClass("print-links");
                    $("td", row).eq(13).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(14).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgCashVoucher]").append(row);
                    row = $("[id*=dgCashVoucher] tr:last-child").clone(true);
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
            var icashpager = xml.find("Pager");
            $("#CashPager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(icashpager.find("PageIndex").text()),
                PageSize: parseInt(icashpager.find("PageSize").text()),
                RecordCount: parseInt(icashpager.find("RecordCount").text())
            });
        };
        // Delete CashVoucher
        function DeleteCashVoucher(id) {
            var parameters = '{"CashVoucherID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Voucher.aspx/DeleteCashVoucher",
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

        function EditCashVoucher(CashVoucherID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Voucher.aspx/EditCashVoucher",
                    data: '{CashVoucherID: ' + CashVoucherID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnEditSuccess,
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

        function OnEditSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cashvouchers = xml.find("EditCashVoucher");
            $.each(cashvouchers, function () {
                var iCashVoucher = $(this);

                $("[id*=txtVoucherNo]").val($(this).find("VoucherNo").text());
                $("[id*=txtPaymentTo]").val($(this).find("PaymentTo").text());
                $("[id*=txtPaymentFor]").val($(this).find("PaymentFor").text());
                $("[id*=txtAmount]").val($(this).find("Amount").text());
                $("[id*=txtVoucherDate]").val($(this).find("PaymentDate").text());
                $("[id*=txtBillNo]").val($(this).find("BillNo").text());

                var ExpenseTypeID = $(this).find("ExpenseTypeID").text();
                $("[id*=ddlExpenseType] option[value='" + ExpenseTypeID + "']").attr("selected", "true");


                var PayType = $(this).find("PayType").text();
                if (PayType == "Cash") {
                    $("#rbtnCashType").attr("checked", "true");
                    $(".desc").hide("slow");
                    $("[id*=txtChequeNo]").val("");
                    $("[id*=txtChequeDate]").val("");
                    $("[id*=txtAccountNo]").val("");
                }
                else if (PayType == "Cheque") {
                    $("#rbtnChequeType").attr("checked", "true");
                    $(".desc").show("slow");
                    $("[id*=txtChequeNo]").val($(this).find("ChequeNo").text());
                    $("[id*=txtChequeDate]").val($(this).find("ChequeDate").text());
                    $("[id*=txtAccountNo]").val($(this).find("AccountNo").text());
                }

                $("[id*=hfCashVoucherID]").val($(this).find("CashVoucherID").text());
                $("[id*=spCashSubmit]").html("Update");

            });
        };

        // Save CashVoucher
        function SaveCashVoucher() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfCashVoucherID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfCashVoucherID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnCashSubmit]").attr("disabled", "true");
                    var CashVoucherID = $("[id*=hfCashVoucherID]").val();
                    var CashVoucherNo = $("[id*=txtVoucherNo]").val();
                    var PaymentTo = $("[id*=txtPaymentTo]").val();
                    var PaymentFor = $("[id*=txtPaymentFor]").val();
                    var Amount = $("[id*=txtAmount]").val();
                    var PaymentDate = $("[id*=txtVoucherDate]").val();
                    var BillNo = $("[id*=txtBillNo]").val();
                    var ExpenseTypeID = $("[id*=ddlExpenseType]").val();
                    var expenseTypeText = $("[id*=ddlExpenseType] option:selected").text();
                    var iPayType;
                    if ($("[id*=rbtnCashType]").is(':checked')) {
                        iPayType = "Cash";
                    }

                    else if ($("[id*=rbtnChequeType]").is(':checked')) {
                        iPayType = "Cheque";
                    }
                    showDiv();
                    var ChequeNo = $("[id*=txtChequeNo]").val();
                    var ChequeDate;
                    if ($("[id*=txtChequeDate]").val() != "") {
                        ChequeDate = $("[id*=txtChequeDate]").val();
                    }
                    else {
                        ChequeDate = "";
                    }
                    var AccountNo = $("[id*=txtAccountNo]").val();

                    var parameters = '{"id": "' + CashVoucherID + '","cashvoucherno": "' + CashVoucherNo + '","paymentto": "' + PaymentTo + '","paymentfor": "' + PaymentFor + '","amount": "' + Amount + '","paymentdate": "' + PaymentDate + '","billno": "' + BillNo + '","expensetype":"' + ExpenseTypeID + '","paytype": "' + iPayType + '","chequeno": "' + ChequeNo + '","chequedate": "' + ChequeDate + '","accountno": "' + AccountNo + '","userName": "' + $("[id*=hdnUserName]").val() + '","expenseTypeText":"' + expenseTypeText + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/Voucher.aspx/SaveCashVoucher",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSaveSuccess,
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
        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                location.reload();

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                location.reload();

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
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetCashVoucher(1);
                GetCashVoucherID();
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
        $("#CashPager .page").live("click", function (e) {
            GetCashVoucher(parseInt($(this).attr('page')));
            GetCashVoucherID();
        });

    </script>
    <script type="text/javascript">

        $(function () {
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetFuelVoucher(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

            GetFuelVoucherID();
        });

        function GetFuelPrice() {
            var id = $('input[name="ctl00$ContentPlaceHolder1$rbtnFuel"]:checked').val();
            if (id) {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Voucher.aspx/GetFuelPrice",
                    data: '{fuelid: ' + id + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnFuelPriceSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnFuelPriceSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var fuelprices = xml.find("FuelPrice");
            if (fuelprices.length > 0) {
                $.each(fuelprices, function () {
                    var ifuelprice = $(this);
                    $("[id*=txtPricePerLitre]").val($(this).find("PricePerLtr").text());
                });
            }
            else {
                $("[id*=txtPricePerLitre]").val("");
            }


        };

        function GetFuelTotalPrice() {
            var NoofLtr = $("[id*=txtNoofLitre]").val();
            var PricePerLitre = $("[id*=txtPricePerLitre]").val();
            var totalamount = parseFloat(NoofLtr) * parseFloat(PricePerLitre);
            $("[id*=txtFuelAmount]").val(totalamount);

        }

        //        GetFuelVoucher Function

        function GetFuelVoucher(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {

                $.ajax({
                    type: "POST",
                    url: "../Masters/Voucher.aspx/GetFuelVoucher",
                    data: '{pageIndex: ' + pageIndex + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnFuelSuccess,
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
        function GetFuelVoucherID() {
            $.ajax({
                type: "POST",
                url: "../Masters/Voucher.aspx/GetFuelVoucherID",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnFuelVoucherIDSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        function OnFuelVoucherIDSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var fuelvoucherids = xml.find("FuelVoucherIDs");
            $.each(fuelvoucherids, function () {
                var ifuelvoucherid = $(this);
                $("[id*=txtFuelVoucherNo]").val($(this).find("FuelVoucherID").text());
                $("[id*=txtFuelVoucherNo]").attr('readonly', 'readonly');
            });

        };


        function OnFuelSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var fuelvouchers = xml.find("FuelVouchers");
            var row = $("[id*=dgFuelVoucher] tr:last-child").clone(true);
            $("[id*=dgFuelVoucher] tr").not($("[id*=dgFuelVoucher] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditFuelVoucher('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteFuelVoucher('";
                danchorEnd = "');\">Delete</a>";
            }

            var panchor = "<a  href=\"javascript:ReprintFuelVoucher('";
            var panchorend = "');\">Reprint</a>";

            if (fuelvouchers.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("No Records Found").attr("align", "left");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("td", row).eq(8).html("");
                $("td", row).eq(9).html("").removeClass("print-links");
                $("td", row).eq(10).html("").removeClass("editacc edit-links");
                $("td", row).eq(11).html("").removeClass("deleteacc delete-links");
                $("[id*=dgFuelVoucher]").append(row);
                row = $("[id*=dgFuelVoucher] tr:last-child").clone(true);

            }
            else {
                $.each(fuelvouchers, function () {
                    var iFuelVoucher = $(this);
                    var ehref = eanchor + $(this).find("FuelVoucherID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("FuelVoucherID").text() + danchorEnd;
                    var print = panchor + $(this).find("FuelVoucherID").text() + panchorend;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("VoucherType").text());
                    $("td", row).eq(1).html($(this).find("VoucherNo").text());
                    $("td", row).eq(2).html($(this).find("VehicleCode").text());
                    $("td", row).eq(3).html($(this).find("FuelName").text());
                    $("td", row).eq(4).html($(this).find("PricePerLtr").text());
                    $("td", row).eq(5).html($(this).find("NoofLtr").text());
                    $("td", row).eq(6).html($(this).find("VoucherDate").text());
                    $("td", row).eq(7).html($(this).find("Amount").text());
                    $("td", row).eq(8).html($(this).find("ReceivedBy").text());
                    $("td", row).eq(9).html(print).addClass("print-links");
                    $("td", row).eq(10).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(11).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgFuelVoucher]").append(row);
                    row = $("[id*=dgFuelVoucher] tr:last-child").clone(true);
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
            var ifuelpager = xml.find("Pager");
            $("#FuelPager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(ifuelpager.find("PageIndex").text()),
                PageSize: parseInt(ifuelpager.find("PageSize").text()),
                RecordCount: parseInt(ifuelpager.find("RecordCount").text())
            });
        };
        // Delete CashVoucher
        function DeleteFuelVoucher(id) {
            var parameters = '{"FuelVoucherID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Voucher.aspx/DeleteFuelVoucher",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnFuelDeleteSuccess,
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

        function EditFuelVoucher(FuelVoucherID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Voucher.aspx/EditFuelVoucher",
                    data: '{FuelVoucherID: ' + FuelVoucherID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnFuelEditSuccess,
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

        function OnFuelEditSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var fuelvouchers = xml.find("EditFuelVoucher");
            $.each(fuelvouchers, function () {
                var iFuelVoucher = $(this);
                $("[id*=txtFuelVoucherNo]").val($(this).find("VoucherNo").text());

                var VehicleNo = $(this).find("VehicleNo").text();
                $("[id*=ddlVehicleNo] option[value='" + VehicleNo + "']").attr("selected", "true");

                var FuelTypeID = $(this).find("FuelTypeID").text();

                for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnFuel']")).length; i++) {
                    $("[id*=rbtnFuel_" + i + "]").attr("checked", false);
                    $("[id*=rbtnFuel_" + i + "]").attr("disabled", true);
                }

                for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnFuel']")).length; i++) {
                    if (FuelTypeID == $("[id*=rbtnFuel_" + i + "]").val()) {
                        $("[id*=rbtnFuel_" + i + "]").attr("checked", true);
                        $("[id*=rbtnFuel_" + i + "]").attr("disabled", true);
                    }

                }


                $("[id*=txtPricePerLitre]").val($(this).find("PricePerLtr").text());
                $("[id*=txtNoofLitre]").val($(this).find("NoofLtr").text());
                $("[id*=txtFuelAmount]").val($(this).find("Amount").text());
                $("[id*=txtFuelVoucherDate]").val($(this).find("VoucherDate").text());
                $("[id*=txtReceivedBy]").val($(this).find("ReceivedBy").text());
                $("[id*=hfFuelVoucherID]").val($(this).find("FuelVoucherID").text());
                $("[id*=spFuelSubmit]").html("Update");

            });
        };

        // SaveFuelVoucher
        function SaveFuelVoucher() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfFuelVoucherID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfFuelVoucherID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnFuelSubmit]").attr("disabled", "true");
                    var FuelVoucherID = $("[id*=hfFuelVoucherID]").val();
                    var FuelVoucherNo = $("[id*=txtFuelVoucherNo]").val();
                    var FuelTypeID;
                    FuelTypeID = $('input[name="ctl00$ContentPlaceHolder1$rbtnFuel"]:checked').val();

                    var VehicleNo = $("[id*=ddlVehicleNo]").val();
                    var PricePerLitre = $("[id*=txtPricePerLitre]").val();
                    var NoofLitre = $("[id*=txtNoofLitre]").val();
                    var Amount = $("[id*=txtFuelAmount]").val();
                    var ReceivedBy = $("[id*=txtReceivedBy]").val();
                    var FuelVoucherDate = $("[id*=txtFuelVoucherDate]").val();

                    var parameters = '{"id": "' + FuelVoucherID + '","fuelvoucherno": "' + FuelVoucherNo + '","vehicleno": "' + VehicleNo + '","fueltypeid": "' + FuelTypeID + '","priceperlitre": "' + PricePerLitre + '","nooflitre": "' + NoofLitre + '","amount": "' + Amount + '","receivedby": "' + ReceivedBy + '","fuelVoucherdate": "' + FuelVoucherDate + '","fuelType":"' + $('input[name="ctl00$ContentPlaceHolder1$rbtnFuel"]:checked + label').text() + '","userName": "' + $("[id*=hdnUserName]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../Masters/Voucher.aspx/SaveFuelVoucher",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnFuelSaveSuccess,
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
        function OnFuelSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                GetFuelVoucher(1);
                GetFuelVoucherID();
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetFuelVoucher(1);
                GetFuelVoucherID();
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
        function OnFuelDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetFuelVoucher(1);
                GetFuelVoucherID();
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
        $("#FuelPager .page").live("click", function (e) {
            GetFuelVoucher(parseInt($(this).attr('page')));
            GetFuelVoucherID();
        });



        //        function Cancel() {
        //            $('#aspnetForm').validate().resetForm();
        //            $("[id*=txtPaymentTo]").val("");
        //            $("[id*=txtPaymentFor]").val("");
        //            $("[id*=txtAmount]").val("");
        //            $("[id*=txtVoucherDate]").val("");
        //            $("[id*=txtBillNo]").val("");
        //            $("[id*=txtChequeNo]").val("");
        //            $("[id*=txtChequeDate]").val("");
        //            $("[id*=txtAccountNo]").val("");
        //            $("[id*=ddlExpenseType]").val("");
        //            $("[id*=hfCashVoucherID]").val("");
        //            $("#rbtnCashType").attr("checked", "true");
        //            $(".desc").hide("slow");
        //           

        //            $("[id*=ddlVehicleNo]").val("");
        //            $("[id*=txtPricePerLitre]").val("");
        //            $("[id*=txtNoofLitre]").val("");
        //            $("[id*=txtFuelAmount]").val("");
        //            $("[id*=txtFuelVoucherDate]").val("");
        //            $("[id*=hfFuelVoucherID]").val("");
        //            $("[id*=spCashSubmit]").html("Save");
        //            $("[id*=spFuelSubmit]").html("Save");
        //            $("[id*=spCashReturnSubmit]").html("Save");
        //            GetCashVoucher(1);
        //            GetFuelVoucher(1);
        //            GetCashVoucherID();
        //            GetFuelVoucherID();

        //            if ($("[id*=hfAddPrm]").val() == 'false') {
        //                $("table.form :input").prop('disabled', true);
        //            }
        //            else
        //                $("table.form :input").prop('disabled', false);
        //        };
    </script>
    <script type="text/javascript">

        $(function () {

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetCashReturnVoucher(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        });

        function GetCashVoucherAmount() {
            var CashVoucherNo = $("[id*=ddlVoucherNo]").val();
            if (CashVoucherNo != "") {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Voucher.aspx/GetCashVoucherAmount",
                    data: '{cashvoucherno: ' + CashVoucherNo + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnCashVoucherAmountSuccess,
                    failure: function (response) {
                        AlertMessage('info', response.d);
                    },
                    error: function (response) {
                        AlertMessage('info', response.d);
                    }
                });
            }
        }
        function OnCashVoucherAmountSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cashvoucheramounts = xml.find("CashVoucherAmt");
            $.each(cashvoucheramounts, function () {
                var icashvoucheramount = $(this);
                $("[id*=txtCashVoucherAmount]").val($(this).find("TotalAmount").text());
                $("[id*=txtDateofIssue]").val($(this).find("PaymentDate").text());
            });

        };
        function CheckDate() {

            var date1 = $("[id*=txtDateofIssue]").val();
            var date2 = $("[id*=txtDateofReturn]").val();
            if (date1 != "" && date2 != "") {
                if ($.datepicker.parseDate('dd/mm/yy', date2) < $.datepicker.parseDate('dd/mm/yy', date1)) {
                    AlertMessage('info', 'Issue Date should be lesser than Return Date !!!');
                    $("[id*=txtDateofIssue]").val("");
                    $("[id*=txtDateofReturn]").val("");
                }
            }

        };
        //        GetFuelVoucher Function

        function GetCashReturnVoucher(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Voucher.aspx/GetCashReturnVoucher",
                    data: '{pageIndex: ' + pageIndex + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnCashReturnSuccess,
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


        function OnCashReturnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cashreturns = xml.find("CashReturns");
            var row = $("[id*=dgCashReturnVoucher] tr:last-child").clone(true);
            $("[id*=dgCashReturnVoucher] tr").not($("[id*=dgCashReturnVoucher] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditCashReturnVoucher('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteCashReturnVoucher('";
                danchorEnd = "');\">Delete</a>";
            }


            var panchor = "<a  href=\"javascript:ReprintCashReturnVoucher('";
            var panchorend = "');\">Reprint</a>";

            if (cashreturns.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("No Records Found").attr("align", "left");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("").removeClass("print-links");
                $("td", row).eq(7).html("").removeClass("editacc edit-links");
                $("td", row).eq(8).html("").removeClass("deleteacc delete-links");
                $("[id*=dgCashReturnVoucher]").append(row);
                row = $("[id*=dgCashReturnVoucher] tr:last-child").clone(true);

            }
            else {
                $.each(cashreturns, function () {
                    var icashreturn = $(this);
                    var ehref = eanchor + $(this).find("CashRetVoucherID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("CashRetVoucherID").text() + danchorEnd;
                    var print = panchor + $(this).find("CashRetVoucherID").text() + panchorend;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("VoucherType").text());
                    $("td", row).eq(1).html($(this).find("VoucherNo").text());
                    $("td", row).eq(2).html($(this).find("DateofIssue").text());
                    $("td", row).eq(3).html($(this).find("VoucherAmount").text());
                    $("td", row).eq(4).html($(this).find("DateofReturn").text());
                    $("td", row).eq(5).html($(this).find("ReturningAmount").text());
                    $("td", row).eq(6).html(print).addClass("print-links");
                    $("td", row).eq(7).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(8).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgCashReturnVoucher]").append(row);
                    row = $("[id*=dgCashReturnVoucher] tr:last-child").clone(true);
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
            var icashreturnpager = xml.find("Pager");
            $("#CashReturnPager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(icashreturnpager.find("PageIndex").text()),
                PageSize: parseInt(icashreturnpager.find("PageSize").text()),
                RecordCount: parseInt(icashreturnpager.find("RecordCount").text())
            });
        };
        // Delete CashVoucher
        function DeleteCashReturnVoucher(id) {
            var parameters = '{"CashReturnVoucherID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Voucher.aspx/DeleteCashReturnVoucher",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnFuelDeleteSuccess,
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

        function EditCashReturnVoucher(CashReturnVoucherID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Voucher.aspx/EditCashReturnVoucher",
                    data: '{CashReturnVoucherID: ' + CashReturnVoucherID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnCashReturnVoucherEditSuccess,
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

        function OnCashReturnVoucherEditSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var CashReturnvouchers = xml.find("EditCashReturnVoucher");
            $.each(CashReturnvouchers, function () {
                var iCashReturnvoucher = $(this);
                $("[id*=ddlVoucherNo]").val($(this).find("CashVoucherId").text());
                $("[id*=txtDateofIssue]").val($(this).find("DateofIssue").text());
                $("[id*=txtDateofReturn]").val($(this).find("DateofReturn").text());
                $("[id*=txtCashVoucherAmount]").val($(this).find("VoucherAmount").text());
                $("[id*=txtCashRetVoucherAmount]").val($(this).find("ReturningAmount").text());
                $("[id*=hfCashReturnVoucherId]").val($(this).find("CashRetVoucherID").text());
                $("[id*=spCashReturnSubmit]").html("Update");

            });
        };

        // SaveCashReturnVoucher
        function SaveCashReturnVoucher() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfCashReturnVoucherId]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfCashReturnVoucherId]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnCashReturnSubmit]").attr("disabled", "true");
                    var CashRetVoucherID = $("[id*=hfCashReturnVoucherId]").val();
                    var CashVoucherNo = $("[id*=ddlVoucherNo]").val();
                    var DateofIssue = $("[id*=txtDateofIssue]").val();
                    var DateofReturn = $("[id*=txtDateofReturn]").val();
                    var ReturningAmount = $("[id*=txtCashRetVoucherAmount]").val();
                    var VoucherAmount = $("[id*=txtCashVoucherAmount]").val();
                    var userName = $("[id*=hdnUserName]").val();

                    if (parseFloat(ReturningAmount) <= parseFloat(VoucherAmount)) {

                        var parameters = '{"cashretvoucherid": "' + CashRetVoucherID + '","cashvoucherno": "' + CashVoucherNo + '","dateofissue": "' + DateofIssue + '","dateofreturn": "' + DateofReturn + '","voucheramount": "' + VoucherAmount + '","returningamount": "' + ReturningAmount + '","userName": "' + userName + '"}';
                        $.ajax({
                            type: "POST",
                            url: "../Masters/Voucher.aspx/SaveCashReturnVoucher",
                            data: parameters,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: OnCashReturnSaveSuccess,
                            failure: function (response) {
                                AlertMessage('info', response.d);
                            },
                            error: function (response) {
                                AlertMessage('info', response.d);
                            }
                        });
                    }
                    else {
                        AlertMessage('reference', 'Returning amount should be lesser than or equal to voucher amount !!!');
                        $("[id*=btnCashReturnSubmit]").attr("disabled", "false");
                    }
                }
            }
            else {
                $("[id*=btnCashReturnSubmit]").attr("disabled", "false");
                return false;
            }
        }

        // Save On Success
        function OnCashReturnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                GetCashReturnVoucher(1);
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetCashReturnVoucher(1);
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
        function OnCashReturnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetCashReturnVoucher(1);
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
        $("#CashReturnPager .page").live("click", function (e) {
            GetCashReturnVoucher(parseInt($(this).attr('page')));
            (1);
        });



        function Cancel() {
            $('#aspnetForm').validate().resetForm();
            $("[id*=txtPaymentTo]").val("");
            $("[id*=txtPaymentFor]").val("");
            $("[id*=txtAmount]").val("");
            $("[id*=txtVoucherDate]").val("");
            $("[id*=txtBillNo]").val("");
            $("[id*=txtChequeNo]").val("");
            $("[id*=txtChequeDate]").val("");
            $("[id*=txtAccountNo]").val("");
            $("[id*=ddlExpenseType]").val("");
            $("[id*=hfCashVoucherID]").val("");
            $("#rbtnCashType").attr("checked", "true");
            $(".desc").hide("slow");
            $("[id*=spCashSubmit]").html("Save");

            $("[id*=ddlVehicleNo]").val("");
            $("[id*=txtPricePerLitre]").val("");
            $("[id*=txtNoofLitre]").val("");
            $("[id*=txtFuelAmount]").val("");
            $("[id*=txtReceivedBy]").val("");
            $("[id*=txtFuelVoucherDate]").val("");
            $("[id*=hfFuelVoucherID]").val("");
            $("[id*=spFuelSubmit]").html("Save");

            $("[id*=ddlVoucherNo]").val("");
            $("[id*=txtDateofIssue]").val("");
            $("[id*=txtDateofReturn]").val("");
            $("[id*=txtCashVoucherAmount]").val("");
            $("[id*=txtCashRetVoucherAmount]").val("");
            $("[id*=hfCashReturnVoucherId]").val("");
            $("[id*=spCashReturnSubmit]").html("Save");

            $("[id*=btnCashSubmit]").attr("disabled", false);
            $("[id*=btnFuelSubmit]").attr("disabled", false);
            $("[id*=btnCashReturnSubmit]").attr("disabled", false);
            for (var i = 0; i < ($("input[name='ctl00$ContentPlaceHolder1$rbtnFuel']")).length; i++) {
                $("[id*=rbtnFuel_" + i + "]").attr("disabled", false);
            }

            GetCashVoucher(1);
            GetFuelVoucher(1);
            GetCashReturnVoucher(1);
            GetCashVoucherID();
            GetFuelVoucherID();
        };
    </script>
    <script type="text/javascript">
        function ReprintCashVoucher(id) {

            // var parameters = '{"cashretvoucherid": "' + CashRetVoucherID + '","cashvoucherno": "' + CashVoucherNo + '","dateofissue": "' + DateofIssue + '","dateofreturn": "' + DateofReturn + '","voucheramount": "' + VoucherAmount + '","returningamount": "' + ReturningAmount + '"}';

            $.ajax({
                type: "POST",
                url: "../Masters/Voucher.aspx/RePrintCashVoucher",
                data: '{CashVoucherID: ' + id + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnCashPrintSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnCashPrintSuccess(response) {
            if (response.d == "1")
                AlertMessage('success', "Reprint done");
            else
                AlertMessage('success', "Reprinting");
        }

        function ReprintCashReturnVoucher(id) {


            $.ajax({
                type: "POST",
                url: "../Masters/Voucher.aspx/RePrintCashReturnVoucher",
                data: '{CashReturnVoucherID: ' + id + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnCashReturnPrintSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnCashReturnPrintSuccess(response) {
            if (response.d == "1")
                AlertMessage('success', "Reprint done");
            else
                AlertMessage('success', "Reprinting");
        }

        function ReprintFuelVoucher(id) {


            $.ajax({
                type: "POST",
                url: "../Masters/Voucher.aspx/RePrintFuelVoucher",
                data: '{FuelVoucherID: ' + id + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnFuelPrintSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        function OnFuelPrintSuccess(response) {
            if (response.d == "1")
                AlertMessage('success', "Reprint done");
            else
                AlertMessage('success', "Reprinting");
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Voucher&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Select Financial Year
                <asp:DropDownList ID="ddlFinancialyear" CssClass="jsrequired cb_selectone" runat="server"
                    AppendDataBoundItems="True" AutoPostBack="True" 
                    onselectedindexchanged="ddlFinancialyear_SelectedIndexChanged">
                </asp:DropDownList>
                  <asp:HiddenField ID="hfFinancialID" runat="server" />
            </h2>
            <div class="clear">
                                                                  
            </div>
            <div class="block john-accord content-wrapper2" id="">
                <div>
                    <ul class="section menu">
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Cash Voucher</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvCashVoucher" style="float: left; margin: 0 auto; width: 780px; height: 400px;"
                                                        runat="server">
                                                        <table class="form" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Voucher No</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtVoucherNo" CssClass="jsrequired" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td class="col1">
                                                                    <label>
                                                                        Payment To</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtPaymentTo" CssClass="jsrequired CashVoucher" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Payment For</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtPaymentFor" CssClass="jsrequired CashVoucher" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td class="col1">
                                                                    <label>
                                                                        Amount</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtAmount" CssClass="jsrequired numericswithdecimals" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <label>
                                                                        Voucher Date</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtVoucherDate" CssClass="jsrequired date-picker dateNL" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td class="col1">
                                                                    <label>
                                                                        Bill No</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtBillNo" CssClass="jsrequired CashVoucher" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Pay Type</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <label>
                                                                        <input type="radio" name="Tb1" id="rbtnCashType" value="Cash Type" checked="checked"
                                                                            onclick="javascript:showDiv();" />Cash
                                                                    </label>
                                                                    <label>
                                                                        <input type="radio" name="Tb1" id="rbtnChequeType" value="Cheque Type" onclick="javascript:showDiv();" />Cheque
                                                                    </label>
                                                                </td>
                                                                <td class="col1">
                                                                    <label>
                                                                        Expense Type</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlExpenseType" CssClass="jsrequired cb_selectone" runat="server"
                                                                        AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="4" valign="top">
                                                                    <div class="desc" id="dvCheque" style="float: left; display: none; width: 735px">
                                                                        <table class="" width="100%">
                                                                            <tr>
                                                                                <td class="col1" width="20%">
                                                                                    <label>
                                                                                        Cheque No</label>
                                                                                </td>
                                                                                <td class="col2" width="35%">
                                                                                    <asp:TextBox ID="txtChequeNo" CssClass="jsrequired CashVoucher" runat="server"></asp:TextBox>
                                                                                </td>
                                                                                <td class="col1" width="10%">
                                                                                    <label>
                                                                                        Cheque Date</label>
                                                                                </td>
                                                                                <td class="col2" width="24%">
                                                                                    <asp:TextBox ID="txtChequeDate" CssClass="jsrequired date-picker DateNL" runat="server"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="col1">
                                                                                    <label>
                                                                                        Account No</label>
                                                                                </td>
                                                                                <td class="col2">
                                                                                    <asp:TextBox ID="txtAccountNo" CssClass="jsrequired CashVoucher" runat="server"></asp:TextBox>
                                                                                </td>
                                                                                <td>
                                                                                </td>
                                                                                <td>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="center" class="col1" colspan="4">
                                                                    <asp:HiddenField ID="hfCashVoucherID" runat="server" />
                                                                    <button id="btnCashSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveCashVoucher();">
                                                                        <span></span>
                                                                        <div id="spCashSubmit">
                                                                            Save</div>
                                                                    </button>
                                                                    <button id="btnCashCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                                        onclick="return Cancel();">
                                                                        <span></span>Cancel</button>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td colspan="2" valign="top">
                                                    <asp:GridView ID="dgCashVoucher" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="VoucherType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Voucher Type" SortExpression="VoucherType">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="VoucherNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Voucher No" SortExpression="VoucherNo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="PaymentTo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Payment To" SortExpression="PaymentTo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="PaymentFor" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Payment For" SortExpression="PaymentFor">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Amount" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Amount" SortExpression="Amount">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="PaymentDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Payment Date" SortExpression="PaymentDate">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="BillNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Bill No" SortExpression="BillNo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ExpenseTypeName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Expense Type" SortExpression="ExpenseTypeName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="PayType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Pay Type" SortExpression="PayType">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ChequeNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Cheque No" SortExpression="ChequeNo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ChequeDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Cheque Date" SortExpression="ChequeDate">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="AccountNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Account No" SortExpression="AccountNo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Reprint" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Reprint" SortExpression="Reprint">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Edit</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("CashVoucherID") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                <HeaderTemplate>
                                                                    Delete</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("CashVoucherID") %>'
                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="CashPager" class="Pager">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Fuel Voucher</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvFuelVoucher" style="float: left; width: 420px" runat="server">
                                                        <table class="form" width="100%">
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Voucher No</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtFuelVoucherNo" CssClass="jsrequired" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Vehicle No</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlVehicleNo" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Fuel Type</label>
                                                                </td>
                                                                <td>
                                                                    <asp:RadioButtonList ID="rbtnFuel" CssClass="jsrequired rb_selectone" runat="server"
                                                                        RepeatDirection="Horizontal" onclick="javascript:GetFuelPrice();" RepeatLayout="Flow">
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Price Per Litre</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtPricePerLitre" CssClass="jsrequired numericswithdecimals" runat="server"
                                                                        ReadOnly="True"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Date</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtFuelVoucherDate" CssClass="jsrequired date-picker DateNL" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        No of Litre</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtNoofLitre" CssClass="jsrequired numericswithdecimals" onchange="javascript:GetFuelTotalPrice();"
                                                                        runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Amount</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtFuelAmount" CssClass="jsrequired numericswithdecimals" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Received By</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtReceivedBy" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <asp:HiddenField ID="hfFuelVoucherID" runat="server" />
                                                                </td>
                                                                <td class="col2">
                                                                    <button id="btnFuelSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveFuelVoucher();">
                                                                        <span></span>
                                                                        <div id="spFuelSubmit">
                                                                            Save</div>
                                                                    </button>
                                                                    <button id="btnFuelCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                                        onclick="return Cancel();">
                                                                        <span></span>Cancel</button>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td colspan="2" valign="top">
                                                    <asp:GridView ID="dgFuelVoucher" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="VoucherType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Voucher Type" SortExpression="VoucherType">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="VoucherNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Voucher No" SortExpression="VoucherNo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="VehicleCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Vehicle No" SortExpression="VehicleCode">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="FuelName" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Fuel Name" SortExpression="FuelName">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="PricePerLtr" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Price/Ltr" SortExpression="PricePerLtr">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="NoofLtr" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="No.of Ltr" SortExpression="NoofLtr">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="VoucherDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Voucher No" SortExpression="VoucherDate">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Amount" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Amount" SortExpression="Amount">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ReceivedBy" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="ReceivedBy" SortExpression="ReceivedBy">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Reprint" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Reprint" SortExpression="Reprint">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Edit</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("FuelVoucherID") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                <HeaderTemplate>
                                                                    Delete</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("FuelVoucherID") %>'
                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="FuelPager" class="Pager">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">
                            Cash Return Voucher</a>
                            <ul class="johnmenu">
                                <li>
                                    <div style="border-bottom-style: none; border-bottom-width: 0px;" class="frm-block">
                                        <table class="form" width="100%">
                                            <tr valign="top">
                                                <td valign="top">
                                                    <div id="dvCashReturnVoucher" style="float: left; width: 570px" runat="server">
                                                        <table class="form">
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Against Voucher No.</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:DropDownList ID="ddlVoucherNo" CssClass="jsrequired" runat="server" onchange="javascript:GetCashVoucherAmount();"
                                                                        AppendDataBoundItems="True">
                                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Date of Issue</label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtDateofIssue" CssClass="jsrequired date-picker DateNL" onchange="CheckDate();"
                                                                        runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Voucher Amount</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtCashVoucherAmount" ReadOnly="true" CssClass="jsrequired numericswithdecimals"
                                                                        runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Date of Return</label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtDateofReturn" CssClass="jsrequired date-picker DateNL" onchange="CheckDate();"
                                                                        runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <label>
                                                                        Returning Amount</label>
                                                                </td>
                                                                <td class="col2">
                                                                    <asp:TextBox ID="txtCashRetVoucherAmount" CssClass="jsrequired numericswithdecimals"
                                                                        runat="server"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="col1">
                                                                    <asp:HiddenField ID="hfCashReturnVoucherId" runat="server" />
                                                                </td>
                                                                <td class="col2">
                                                                    <button id="btnCashReturnSubmit" type="button" class="btn-icon btn-orange btn-saving"
                                                                        onclick="SaveCashReturnVoucher();">
                                                                        <span></span>
                                                                        <div id="spCashReturnSubmit">
                                                                            Save</div>
                                                                    </button>
                                                                    <button id="btnCashReturnCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                        runat="server" onclick="return Cancel();">
                                                                        <span></span>Cancel</button>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td colspan="2" valign="top">
                                                    <asp:GridView ID="dgCashReturnVoucher" runat="server" Width="100%" AutoGenerateColumns="False"
                                                        AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                        AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                        <Columns>
                                                            <asp:BoundField DataField="VoucherType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Voucher Type" SortExpression="VoucherType">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="VoucherNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Voucher No" SortExpression="VoucherNo">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="DateofIssue" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Date of Issue" SortExpression="DateofIssue">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="VoucherAmount" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Voucher Amount" SortExpression="VoucherAmount">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="DateofReturn" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Date of Return" SortExpression="DateofReturn">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ReturningAmount" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Returning Amount" SortExpression="ReturningAmount">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Reprint" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                                HeaderText="Reprint" SortExpression="Reprint">
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod editacc">
                                                                <HeaderTemplate>
                                                                    Edit</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("CashRetVoucherID") %>'
                                                                        CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                HeaderStyle-CssClass="sorting_mod deleteacc">
                                                                <HeaderTemplate>
                                                                    Delete</HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("CashRetVoucherID") %>'
                                                                        CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="CashReturnPager" class="Pager">
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
            <div class="clear">
            </div>
        </div>
    </div>
</asp:Content>
