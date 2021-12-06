<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Vehicle.aspx.cs" Inherits="Vehicle" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function Delete() {
            return confirm("Are You Sure to Delete ?");
        }
        function changeAccordion() {
            $(".john-accord").accordion({
                "header": "a.menuitem",
                "collapsible": false,
                "active": parseInt(1),
                "autoHeight": false;

            });
        }
    </script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <%="<script src='" + ResolveUrl("~/js/ASPSnippets_Pager.min.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
       
        $(document).ready(function () {
            setDatePicker("[id*=txtFromDate]");
            setDatePicker("[id*=txtToDate]");
        });
        $(function () {
            GetVehicleCode();
            //        GetVehicles Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetVehicle(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);

            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')
                GetService(1);
            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);



        });


        //        GetVehicles Function

        function GetVehicle(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Vehicle.aspx/GetVehicle",
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

        function GetVehicleCode() {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Vehicle.aspx/GetVehicleCode",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnGetVehicleCodeSuccess,
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
        function OnGetVehicleCodeSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var cls = xml.find("Vehicle");

            var select = $("[id*=ddlVehicleCode]");
            select.children().remove();
            select.append($("<option>").val('').text('---Select---'));
            $.each(cls, function () {
                var icls = $(this);
                var VehicleID = $(this).find("VehicleID").text();
                var VehicleCode = $(this).find("VehicleCode").text();
                select.append($("<option>").val(VehicleID).text(VehicleCode));

            });

        };

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Vehiclees = xml.find("Vehicles");
            var row = $("[id*=dgVehicle] tr:last-child").clone(true);
            $("[id*=dgVehicle] tr").not($("[id*=dgVehicle] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditVehicle('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteVehicle('";
                danchorEnd = "');\">Delete</a>";
            }
            if (Vehiclees.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("No Records Found").attr("align", "left");
                $("td", row).eq(4).html("");
                $("td", row).eq(5).html("");
                $("td", row).eq(6).html("");
                $("td", row).eq(7).html("");
                $("td", row).eq(8).html("").removeClass("editacc edit-links");
                $("td", row).eq(9).html("").removeClass("deleteacc delete-links");
                $("[id*=dgVehicle]").append(row);
                row = $("[id*=dgVehicle] tr:last-child").clone(true);

            }
            else {
                $.each(Vehiclees, function () {
                    var iVehicle = $(this);
                    var ehref = eanchor + $(this).find("VehicleID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("VehicleID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("VehicleCode").text());
                    $("td", row).eq(1).html($(this).find("RegistrationNo").text());
                    $("td", row).eq(2).html($(this).find("ClassofVehicle").text());
                    $("td", row).eq(3).html($(this).find("EngineNo").text());
                    $("td", row).eq(4).html($(this).find("ChasisNo").text());
                    $("td", row).eq(5).html($(this).find("ModelNo").text());
                    $("td", row).eq(6).html($(this).find("YearofPurchase").text());
                    $("td", row).eq(7).html($(this).find("SchoolCode").text());
                    $("td", row).eq(8).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(9).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgVehicle]").append(row);
                    row = $("[id*=dgVehicle] tr:last-child").clone(true);
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
            var pager = xml.find("Pager");

            $("#Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(pager.find("PageIndex").text()),
                PageSize: parseInt(pager.find("PageSize").text()),
                RecordCount: parseInt(pager.find("RecordCount").text())
            });
        };


        // Delete Vehicle
        function DeleteVehicle(id) {
            var parameters = '{"VehicleID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Vehicle.aspx/DeleteVehicle",
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

        function EditVehicle(VehicleID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Vehicle.aspx/EditVehicle",
                    data: '{VehicleID: ' + VehicleID + '}',
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
            var Vehiclees = xml.find("EditVehicle");
            $.each(Vehiclees, function () {

                var iVehicle = $(this);
                $("[id*=txtVehicleCode]").val($(this).find("VehicleCode").text());
                $("[id*=txtRegistrationNo]").val($(this).find("RegistrationNo").text());
                $("[id*=txtClassofVehicle]").val($(this).find("ClassofVehicle").text());
                $("[id*=txtEngineNo]").val($(this).find("EngineNo").text());
                $("[id*=txtChasisNo]").val($(this).find("ChasisNo").text());
                $("[id*=txtModelNo]").val($(this).find("ModelNo").text());
                $("[id*=txtYearofPurchase]").val($(this).find("YearofPurchase").text());
                $("[id*=txtSchoolCode]").val($(this).find("SchoolCode").text());
                $("[id*=hfVehicleID]").val($(this).find("VehicleID").text());
                $("[id*=spVehicleSubmit]").html("Update");

            });
        };




        // Save Vehicle
        function SaveVehicle() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfVehicleID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfVehicleID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnSubmit]").attr("disabled", "true");
                    var VehicleID = $("[id*=hfVehicleID]").val();
                    var VehicleCode = $("[id*=txtVehicleCode]").val();
                    var RegistrationNo = $("[id*=txtRegistrationNo]").val();
                    var ClassOfVehicle = $("[id*=txtClassofVehicle]").val();
                    var EngineNo = $("[id*=txtEngineNo]").val();
                    var ChasisNo = $("[id*=txtChasisNo]").val();
                    var ModelNo = $("[id*=txtModelNo]").val();
                    var YearofPurchase = $("[id*=txtYearofPurchase]").val();
                    var SchoolCode = $("[id*=txtSchoolCode]").val();

                    var parameters = '{"id": "' + VehicleID + '","vehiclecode": "' + VehicleCode + '","registrationno": "' + RegistrationNo + '","classofvehicle": "' + ClassOfVehicle + '","engineno": "' + EngineNo + '","chasisno": "' + ChasisNo + '","modelno": "' + ModelNo + '","yearofpurchase": "' + YearofPurchase + '","schoolcode": "' + SchoolCode + '"}';
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Vehicle.aspx/SaveVehicle",
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
                GetVehicle(1);
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetVehicle(1);
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
            //location.reload();
            

        };




        // Delete On Success
        function OnDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetVehicle(parseInt(currentPage));
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
        $("#Pager .page").live("click", function (e) {
            GetVehicle(parseInt($(this).attr('page')));
        });



        function GetService(pageIndex) {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Vehicle.aspx/GetService",
                    data: '{pageIndex: ' + pageIndex + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnServiceSuccess,
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


        function OnServiceSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var iServices = xml.find("Services");
            var row = $("[id*=dgService] tr:last-child").clone(true);
            $("[id*=dgService] tr").not($("[id*=dgService] tr:first-child")).remove();
            var eanchor = ''
            var eanchorEnd = '';
            var danchor = ''
            var danchorEnd = '';
            if ($("[id*=hfEditPrm]").val() == 'false') {
                eanchor = "<a>";
                eanchorEnd = "</a>";
            }
            else {
                eanchor = "<a  href=\"javascript:EditService('";
                eanchorEnd = "');\">Edit</a>";
            }
            if ($("[id*=hfDeletePrm]").val() == 'false') {
                danchor = "<a>";
                danchorEnd = "</a>";
            }
            else {
                danchor = "<a  href=\"javascript:DeleteService('";
                danchorEnd = "');\">Delete</a>";
            }
            if (iServices.length == 0) {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("");
                $("td", row).eq(2).html("No Records Found").attr("align", "left");
                $("td", row).eq(3).html("");
                $("td", row).eq(4).html("").removeClass("editacc edit-links");
                $("td", row).eq(5).html("").removeClass("deleteacc delete-links");
                $("[id*=dgService]").append(row);
                row = $("[id*=dgService] tr:last-child").clone(true);

            }
            else {
                $.each(iServices, function () {
                    var iService = $(this);
                    var ehref = eanchor + $(this).find("ServiceID").text() + eanchorEnd;
                    var dhref = danchor + $(this).find("ServiceID").text() + danchorEnd;

                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("VehicleCode").text());
                    $("td", row).eq(1).html($(this).find("ServiceType").text());
                    $("td", row).eq(2).html($(this).find("FromDate").text());
                    $("td", row).eq(3).html($(this).find("ToDate").text());
                    $("td", row).eq(4).html(ehref).addClass("editacc edit-links");
                    $("td", row).eq(5).html(dhref).addClass("deleteacc delete-links");
                    $("[id*=dgService]").append(row);
                    row = $("[id*=dgService] tr:last-child").clone(true);
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
            var servicepager = xml.find("Pager");

            $("#ServicePager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(servicepager.find("PageIndex").text()),
                PageSize: parseInt(servicepager.find("PageSize").text()),
                RecordCount: parseInt(servicepager.find("RecordCount").text())
            });
        };


        // Delete Service
        function DeleteService(id) {
            var parameters = '{"ServiceID": "' + id + '"}';
            if (jConfirm('Are you sure to delete this?', 'Confirm', function (r) {
                if (r) {
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Vehicle.aspx/DeleteService",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnServiceDeleteSuccess,
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

        function EditService(ServiceID) {
            if ($("[id*=hfEditPrm]").val() == 'true') {
                $.ajax({
                    type: "POST",
                    url: "../Masters/Vehicle.aspx/EditService",
                    data: '{ServiceID: ' + ServiceID + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnServiceEditSuccess,
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

        function OnServiceEditSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Vehiclees = xml.find("EditService");
            $.each(Vehiclees, function () {

                var iVehicle = $(this);

                var VehicleID = $(this).find("VehicleID").text();
                $("[id*=ddlVehicleCode] option[value='" + VehicleID + "']").attr("selected", "true");

                var ServiceType = $(this).find("ServiceType").text();
                $("[id*=ddlType] option[value='" + ServiceType + "']").attr("selected", "true");

                $("[id*=txtFromDate]").val($(this).find("FromDate").text());
                $("[id*=txtToDate]").val($(this).find("ToDate").text());
                $("[id*=hfServiceID]").val($(this).find("ServiceID").text());
                $("[id*=spServiceSubmit]").html("Update");

            });
        };


        // Save Service
        function SaveService() {
            if (($("[id*=hfAddPrm]").val() == 'true' && $("[id*=hfServiceID]").val() == '') ||
            ($("[id*=hfEditPrm]").val() == 'true' && $("[id*=hfServiceID]").val() != '')
            ) {
                if ($('#aspnetForm').valid()) {
                    $("[id*=btnServiceSubmit]").attr("disabled", "true");
                    var ServiceID = $("[id*=hfServiceID]").val();
                    var VehicleID = $("[id*=ddlVehicleCode]").val();
                    var Type = $("[id*=ddlType]").val();
                    var FromDate = $("[id*=txtFromDate]").val();
                    var ToDate = $("[id*=txtToDate]").val();

                    var parameters = '{"id": "' + ServiceID + '","vehicleid": "' + VehicleID + '","type": "' + Type + '","fromdate": "' + FromDate + '","todate": "' + ToDate + '"}';
                    $.ajax({

                        type: "POST",
                        url: "../Masters/Vehicle.aspx/SaveService",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnServiceSaveSuccess,
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
        function OnServiceSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                GetService(1);
                Cancel();
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                GetService(1);
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
        function OnServiceDeleteSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Deleted") {
                AlertMessage('success', 'Deleted');
                GetService(1);
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



        $("#ServicePager .page").live("click", function (e) {
            GetService(parseInt($(this).attr('page')));
        });



        function Cancel() {
            $("[id*=hfVehicleID]").val("");
            $("[id*=txtVehicleCode]").val("");
            $("[id*=txtRegistrationNo]").val("");
            $("[id*=txtClassofVehicle]").val("");
            $("[id*=txtEngineNo]").val("");
            $("[id*=txtChasisNo]").val("");
            $("[id*=txtModelNo]").val("");
            $("[id*=txtYearofPurchase]").val("");
            $("[id*=txtSchoolCode]").val("");
            $("[id*=spVehicleSubmit]").html("Save")

            $("[id*=hfServiceID]").val("");
            $("[id*=ddlVehicleCode]").val("");
            $("[id*=ddlType]").val("");
            $("[id*=txtFromDate]").val("");
            $("[id*=txtToDate]").val("");
            $("[id*=spServiceSubmit]").html("Save");
            $("[id*=btnServiceSubmit]").attr("disabled", "false");
            $("[id*=btnSubmit]").attr("disabled", "false");
            $('#aspnetForm').validate().resetForm();
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
            GetVehicleCode();
        };

        function CheckDate() {

            var date1 = $("[id*=txtFromDate]").val();
            var date2 = $("[id*=txtToDate]").val();
            if (date1 != "" && date2 != "") {
                if ($.datepicker.parseDate('dd/mm/yy', date2) < $.datepicker.parseDate('dd/mm/yy', date1)) {
                    AlertMessage('info', 'StartDate should be lesser than EndDate !!!');
                    $("[id*=txtFromDate]").val("");
                    $("[id*=txtToDate]").val("");
                }
            }

        };   

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Vehicle
            </h2>
            <div class="clear">
            </div>
            <div class="block john-accord content-wrapper2">
                <ul class="section menu">
                    <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">Vehicle Details</a>
                        <ul class="johnmenu">
                            <li>
                                <div style="border-bottom-style: none; overflow: auto; height: 420px; border-bottom-width: 0px;"
                                    class="frm-block">
                                    <table class="form" width="100%">
                                        <tr>
                                            <td colspan="2">
                                                <div id="dvCashVoucher" style="float: left; width: 550px" runat="server">
                                                    <table class="form">
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Vehicle Code</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtVehicleCode" CssClass="jsrequired" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Registration No</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtRegistrationNo" CssClass="jsrequired" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Class of Vehicle</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtClassofVehicle" CssClass="jsrequired" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Engine No</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtEngineNo" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Chasis No</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtChasisNo" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Model No</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtModelNo" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Year of Purchase</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtYearofPurchase" CssClass="jsrequired bloodgroup" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    School Code</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtSchoolCode" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <asp:HiddenField ID="hfVehicleID" runat="server" />
                                                            </td>
                                                            <td>
                                                                <button id="btnSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SaveVehicle();">
                                                                    <span></span><div id="spVehicleSubmit">Save</div></button>
                                                                <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                                    onclick="return Cancel();">
                                                                    <span></span>Cancel</button>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td valign="top" colspan="2">
                                                <asp:GridView ID="dgVehicle" runat="server" Width="100%" AutoGenerateColumns="False"
                                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                    <Columns>                                                    
                                                        <asp:BoundField DataField="VehicleCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Vehicle Code" SortExpression="VehicleCode">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="RegistrationNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Registration No" SortExpression="RegistrationNo">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="ClassofVehicle" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Class of Vehicle" SortExpression="ClassofVehicle">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="EngineNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Engine No" SortExpression="EngineNo">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="ChasisNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Chasis No" SortExpression="ChasisNo">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="ModelNo" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Model No" SortExpression="ModelNo">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="YearofPurchase" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Year of Purchase" SortExpression="YearofPurchase">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="SchoolCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="School Code" SortExpression="SchoolCode">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                            HeaderStyle-CssClass="sorting_mod editacc">
                                                            <HeaderTemplate>
                                                                Edit</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("VehicleID") %>'
                                                                    CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                            HeaderStyle-CssClass="sorting_mod deleteacc">
                                                            <HeaderTemplate>
                                                                Delete</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("VehicleID") %>'
                                                                    CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="Pager" id="Pager">
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li><a style="border-width: 1px; border-style: dotted; border-color: #CCCCCC;" class="menuitem">Service Details</a>
                        <ul class="johnmenu">
                            <li>
                                <div style="border-bottom-style: none; overflow: auto; height: 420px; border-bottom-width: 0px;"
                                    class="frm-block">
                                    <table class="form" width="100%">
                                        <tr>
                                            <td colspan="2">
                                                <div id="Div1" style="float: left; width: 550px" runat="server">
                                                    <table class="form">
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Vehicle Code</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:DropDownList ID="ddlVehicleCode" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    Type</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:DropDownList ID="ddlType" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                                    <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="Tax">Tax</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="FC">FC</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="HP">HP</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="Insurance">Insurance</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="Permit">Permit</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td class="col2">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    From Date</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtFromDate" CssClass="jsrequired DateNL Date-picker" onchange="CheckDate();" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <label>
                                                                    To Date</label>
                                                            </td>
                                                            <td class="col2">
                                                                <asp:TextBox ID="txtToDate" CssClass="jsrequired DateNL Date-picker" onchange="CheckDate();" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col1">
                                                                <asp:HiddenField ID="hfServiceID" runat="server" />
                                                            </td>
                                                            <td>
                                                                <button id="btnServiceSubmit" type="button" class="btn-icon btn-navy btn-save" onclick="SaveService();">
                                                                    <span></span><div id="spServiceSubmit">Save</div></button>
                                                                <button id="btnServiceCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                                                    runat="server" onclick="return Cancel();">
                                                                    <span></span>Cancel</button>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td valign="top" colspan="2">
                                                <asp:GridView ID="dgService" runat="server" Width="100%" AutoGenerateColumns="False"
                                                    AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                                    AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                                    <Columns>
                                                        <asp:BoundField DataField="VehicleCode" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Vehicle Code" SortExpression="VehicleCode">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="ServiceType" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="Service Type" SortExpression="ServiceType">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="FromDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="From Date" SortExpression="FromDate">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="ToDate" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center"
                                                            HeaderText="To Date" SortExpression="ToDate">
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:BoundField>
                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                            HeaderStyle-CssClass="sorting_mod editacc">
                                                            <HeaderTemplate>
                                                                Edit</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("ServiceID") %>'
                                                                    CommandName="Edit" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                            HeaderStyle-CssClass="sorting_mod deleteacc">
                                                            <HeaderTemplate>
                                                                Delete</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("ServiceID") %>'
                                                                    CommandName="Delete" CausesValidation="false" CssClass="links"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="Pager" id="ServicePager">
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
            <div class="clear">
            </div>
        </div>
    </div>
</asp:Content>
