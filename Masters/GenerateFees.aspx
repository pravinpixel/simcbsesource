<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GenerateFees.aspx.cs" Inherits="Masters_GenerateFees" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" type="text/css" href="../css/reset.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="../css/text.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="../css/layout.css" media="screen" />
    <script src="../js/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../js/table/jquery.dataTables.min.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="../css/jquery.jqplot.min.css" />
    <%="<script src='" + ResolveUrl("~/js/jquery-1.7.2.min.js") + "'  type='text/javascript'></script>"%>
    <%="<script src='" + ResolveUrl("~/js/jNotify-master/jquery/jNotify.jquery.js") + "' type='text/javascript'></script>"%>
    <%="<script src='" + ResolveUrl("~/js/jquery.validate.js") + "' type='text/javascript'></script>"%>
    <%="<script src='" + ResolveUrl("~/js/additional-methods.js") + "' type='text/javascript'></script>"%>
    <!--script src="prettyphoto/js/jquery.lint.js" type="text/javascript" charset="utf-8"></script-->
    <link rel="stylesheet" href="../prettyphoto/css/prettyPhoto.css" type="text/css"
        media="screen" title="prettyPhoto main stylesheet" charset="utf-8" />
    <script src="../prettyphoto/js/jquery.prettyPhoto.js" type="text/javascript" charset="utf-8"></script>
    <!--prettyphoto lightbox script ending here -->
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#aspnetForm').validate();

        });
    </script>
    <script type="text/javascript">
        $(function () {
            var hffeescatheadid = $("[id*=hfFeesCatHeadId]").val();
            var hffeesheadid = $("[id*=hfFeesHeadId]").val();
            var hfschooltypeid = $("[id*=hfSchoolTypeId]").val();
            var hfclassid = $("[id*=hfClassId]").val();
            var hffeescategoryid = $("[id*=hfFeesCategoryId]").val();
            var academicid = $("[id*=hfAcademicYear]").val();
            if (hffeescatheadid == "" || hffeescatheadid == null || hffeescatheadid == "undefined") {
                hffeescatheadid = "0";
            }
            if (hffeesheadid == "" || hffeesheadid == null || hffeesheadid == "undefined") {
                hffeesheadid = "0";
            }
            if (hfschooltypeid == "" || hfschooltypeid == null || hfschooltypeid == "undefined") {
                hfschooltypeid = "0";
            }
            if (hfclassid == "" || hfclassid == null || hfclassid == "undefined") {
                hfclassid = "0";
            }
            if (hffeescategoryid == "" || hffeescategoryid == null || hffeescategoryid == "undefined") {
                hffeescategoryid = "0";
            }
            if (academicid == "" || academicid == null || academicid == "undefined") {
                academicid = "0";
            }
            if (hffeescatheadid != "" && hffeesheadid != "" && hfschooltypeid != "" && hfclassid != "" && hffeescategoryid != "" && academicid != "") {
                BindFees(hffeescatheadid, hffeesheadid, hfschooltypeid, hfclassid, hffeescategoryid, academicid);
                $("[id*=spSubmit]").html("Update");
            }
            else {
                BindFees(0, 0, hfschooltypeid, hfclassid, hffeescategoryid, academicid);
                //UnBindBindFees();
                $("[id*=spSubmit]").html("Save");
            }

        }); 
    </script>
    <script type="text/javascript">

        function Cancel() {
            window.parent.Rebind();
        };

        function UnBindBindFees() {
            var hfschooltypeid = $("[id*=hfSchoolTypeId]").val();
            var hfclassid = $("[id*=hfClassId]").val();
            var hffeescategoryid = $("[id*=hfFeesCategoryId]").val();
            var academicid = $("[id*=hfAcademicYear]").val();
            var parameters = '{"schooltypeid": "' + hfschooltypeid + '","classid": "' + hfclassid + '","feescategoryid": "' + hffeescategoryid + '","academicid": "' + academicid + '"}';
            $.ajax({
                type: "POST",
                url: "../Masters/GenerateFees.aspx/GetUnBindFees",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetUnBindFeesSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }

        // Save On Success
        function OnGetUnBindFeesSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var feescathead = xml.find("UnBindFeesHead");
            if (response.d == "<NewDataSet />") {
                var hfacademicyear = $("[id*=lblAcademicyear]").text();
                alert("No " + hfacademicyear.toString());
                window.parent.$.prettyPhoto.close();
            };

        };

        function BindFees(feescatheadid, feesheadid, schooltypeid, classid, feescategoryid, academicid) {
            var parameters = '{"feescatheadid": "' + feescatheadid + '","feesheadid": "' + feesheadid + '","schooltypeid": "' + schooltypeid + '","classid": "' + classid + '","feescategoryid": "' + feescategoryid + '","academicid": "' + academicid + '"}';
            $.ajax({
                type: "POST",
                url: "../Masters/GenerateFees.aspx/GetFees",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetFeesSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        }
        // Save On Success
        function OnGetFeesSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var feescathead = xml.find("FeesCatHead");
            $.each(feescathead, function () {
                $("[id*=hfFeesCatHeadId]").val($(this).find("FeesCatHeadID").text());
                $("[id*=hfFeesHeadId]").val($(this).find("FeesHeadID").text());
                var tdFeesCatHeadID = $(this).find("FeesCatHeadID").text();
                var month = $(this).find("ForMonth").text();
                var amt = $(this).find("Amount").text();
                $(".even").each(function () {
                    var tdFeesHeadID = $(this).find('td.FeesHeadID').html();
                    if (tdFeesHeadID == $("[id*=hfFeesHeadId]").val()) {
                        $(this).find('input.Amount').val(amt);
                        $(this).find('td.FeesCatHeadID').html(tdFeesCatHeadID);
                        var formonth = month;
                        var strMonth = formonth.split(',');
                        for (var i = 0; i < strMonth.length; i++) {
                            var mnth = strMonth[i];
                            if (mnth == "'Jan'") {
                                $(this).find('input.Jan').attr('checked', true);
                            }
                            else if (mnth == "'Feb'") {
                                $(this).find('input.Feb').attr('checked', true);
                            }
                            else if (mnth == "'Mar'") {
                                $(this).find('input.Mar').attr('checked', true);
                            }
                            else if (mnth == "'Apr'") {
                                $(this).find('input.Apr').attr('checked', true);
                            }
                            else if (mnth == "'May'") {
                                $(this).find('input.May').attr('checked', true);
                            }
                            else if (mnth == "'Jun'") {
                                $(this).find('input.Jun').attr('checked', true);
                            }
                            else if (mnth == "'Jul'") {
                                $(this).find('input.Jul').attr('checked', true);
                            }
                            else if (mnth == "'Aug'") {
                                $(this).find('input.Aug').attr('checked', true);
                            }
                            else if (mnth == "'Sep'") {
                                $(this).find('input.Sep').attr('checked', true);
                            }
                            else if (mnth == "'Oct'") {
                                $(this).find('input.Oct').attr('checked', true);
                            }
                            else if (mnth == "'Nov'") {
                                $(this).find('input.Nov').attr('checked', true);
                            }
                            else if (mnth == "'Dec'") {
                                $(this).find('input.Dec').attr('checked', true);
                            }
                        }
                    }
                });


            });

        };
        function SaveFees() {

            GetInsertQuery();

        }
        // Save On Success
        function OnSaveSuccess(response) {
            var currentPage = $("[id*=currentPage]").text();
            if (response.d == "Updated") {
                AlertMessage('success', 'Updated');
                window.parent.Rebind();

            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', 'Update');
                Cancel();
            }
            else if (response.d == "Inserted") {
                AlertMessage('success', 'Inserted');
                window.parent.Rebind();
            }
            else if (response.d == "Insert Failed") {
                AlertMessage('fail', 'Insert');
                Cancel();
            }
        };
        function OnGetMonthsSuccess(response) {
            var sqlstr = "";
            var subQuery = "";
            var MonthName = "";
            var formonth = "";
            var mon = response.d;
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            $("#btnSubmit").attr("disabled", "disabled");
            $(".even").each(function () {
                var FeesCatHeadID = $(this).find('td.FeesCatHeadID').html();
                var FeesHeadID = $(this).find('td.FeesHeadID').html();
                var Jan = $(this).find('input.Jan').is(':checked');
                var Feb = $(this).find('input.Feb').is(':checked');
                var Mar = $(this).find('input.Mar').is(':checked');
                var Apr = $(this).find('input.Apr').is(':checked');
                var May = $(this).find('input.May').is(':checked');
                var Jun = $(this).find('input.Jun').is(':checked');
                var Jul = $(this).find('input.Jul').is(':checked');
                var Aug = $(this).find('input.Aug').is(':checked');
                var Sep = $(this).find('input.Sep').is(':checked');
                var Oct = $(this).find('input.Oct').is(':checked');
                var Nov = $(this).find('input.Nov').is(':checked');
                var Dec = $(this).find('input.Dec').is(':checked');
                var Amount = $(this).find('input.Amount').val();
                var months = xml.find("Months");
                MonthName = "";
                $.each(months, function () {
                    if (MonthName == "") {
                        MonthName = "|" + $(this).find("MonthName").text() + "|";
                    }
                    else {
                        MonthName = MonthName + "," + "|" + $(this).find("MonthName").text() + "|";
                    }
                });
                MonthName = MonthName + ",";

                if (Jan == false) {
                    MonthName = MonthName.replace("|Jan|,", "");
                }

                if (Feb == false) {
                    MonthName = MonthName.replace("|Feb|,", "");
                }
                if (Mar == false) {

                    MonthName = MonthName.replace("|Mar|,", "");
                }
                if (Apr == false) {

                    MonthName = MonthName.replace("|Apr|,", "");
                }
                if (May == false) {

                    MonthName = MonthName.replace("|May|,", "");
                }
                if (Jun == false) {

                    MonthName = MonthName.replace("|Jun|,", "");
                }
                if (Jul == false) {

                    MonthName = MonthName.replace("|Jul|,", "");
                }
                if (Aug == false) {

                    MonthName = MonthName.replace("|Aug|,", "");
                }
                if (Sep == false) {

                    MonthName = MonthName.replace("|Sep|,", "");
                }
                if (Oct == false) {

                    MonthName = MonthName.replace("|Oct|,", "");
                }
                if (Nov == false) {

                    MonthName = MonthName.replace("|Nov|,", "");
                }
                if (Dec == false) {

                    MonthName = MonthName.replace("|Dec|,", "");
                }
                MonthName = MonthName.slice(0, -1);
                var AcademicYearId = $("[id*=hfAcademicYear]").val();
                var SchoolTypeId = $("[id*=hfSchoolTypeId]").val();
                var ClassId = $("[id*=hfClassId]").val();
                var FeesCategoryId = $("[id*=hfFeesCategoryId]").val();
                var UserId = $("[id*=hfUserId]").val();
                //var FeesCatHeadID = $("[id*=hfFeesCatHeadId]").val();
                subQuery = "";
                if (Amount != "" && Amount != null && Amount != "0.00" && Amount != "0") {
                    if (MonthName != "" && MonthName != null) {
                        if (FeesCatHeadID == "" || FeesCatHeadID == "&nbsp;") {
                            subQuery = "insert into m_feescategoryhead ([AcademicId],[FeesCategoryId],[FeesHeadId],[SchoolTypeId],[ClassId],[ForMonth],[Amount],[IsActive],[UserId]) values('" + AcademicYearId + "','" + FeesCategoryId + "','" + FeesHeadID + "','" + SchoolTypeId + "','" + ClassId + "','" + MonthName + "','" + Amount + "','1','" + UserId + "');";

                        }
                        else if (FeesCatHeadID != "" && FeesCatHeadID != "&nbsp;") {

                            subQuery = "update m_feescategoryhead set [AcademicId]='" + AcademicYearId + "',[FeesCategoryId]='" + FeesCategoryId + "',[FeesHeadId]='" + FeesHeadID + "',[SchoolTypeId]='" + SchoolTypeId + "',[ClassId]='" + ClassId + "',[ForMonth]='" + MonthName + "',[Amount]='" + Amount + "',[IsActive]=1,[UserId]='" + UserId + "',modifieddate=getdate() where FeesCatHeadID='" + FeesCatHeadID + "'";
                        }
                        // sqlstr += subQuery;
                    }
                    else if (FeesCatHeadID != "" && FeesCatHeadID != "&nbsp;") {

                        subQuery = "update m_feescategoryhead set [AcademicId]='" + AcademicYearId + "',[FeesCategoryId]='" + FeesCategoryId + "',[FeesHeadId]='" + FeesHeadID + "',[SchoolTypeId]='" + SchoolTypeId + "',[ClassId]='" + ClassId + "',[Amount]='" + Amount + "',[IsActive]=0,[UserId]='" + UserId + "',modifieddate=getdate() where FeesCatHeadID='" + FeesCatHeadID + "'";
                    }

                }
                else {
                    if (FeesCatHeadID != "" && FeesCatHeadID != "&nbsp;") {

                        subQuery = "update m_feescategoryhead set [IsActive]=0,[UserId]='" + UserId + "',modifieddate=getdate() where FeesCatHeadID='" + FeesCatHeadID + "'";
                    }
                }
                sqlstr += subQuery;
            });
            var FeesCatHeadID = $("[id*=hfFeesCatHeadId]").val();

            if (FeesCatHeadID != "") {
                var type = "Update";
            }
            else {
                var type = "Insert";
            }
            var parameters = '{"query": "' + sqlstr + '","type": "' + type + '"}';

            $.ajax({
                type: "POST",
                url: "../Masters/GenerateFees.aspx/SaveFees",
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

        };

        function GetInsertQuery() {
            var startdate = $("[id*=hfStartDate]").val();
            var enddate = $("[id*=hfEndDate]").val(); ;
            $("#btnSubmit").attr("disabled", "true");
            var parameters = '{"startdate": "' + startdate + '","enddate": "' + enddate + '"}';
            $.ajax({
                type: "POST",
                url: "../Masters/GenerateFees.aspx/GetMonths",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetMonthsSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });

        };           
        
    </script>
</head>
<body style="background-color: transparent;">
    <form runat="server">
    <div style="width: 100%; overflow: auto; height: 550px" align="center">
        <table style="width: 100%;" align="center">
            <tr>
                <td align="center">
                    <h5>
                        <asp:Label ID="lblAcademicyear" Font-Bold="true" runat="server"></asp:Label></h5>
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td align="center">
                    <b><span class="sorting_mod">SCHOOL TYPE </span>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblSchoolTypeName"
                        runat="server"></asp:Label></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b><span class="sorting_mod">
                            CLASS </span>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblClassName" runat="server"></asp:Label></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <b><span class="sorting_mod">FEES TYPE </span>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblFeesType"
                        runat="server"></asp:Label></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b><span class="sorting_mod">
                            FEES CATEGORY </span>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblFeesCategoryName" runat="server"></asp:Label></b><br />
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" Width="100%"
                        AllowPaging="false" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                        AlternatingRowStyle-CssClass="even" EnableModelValidation="True" CssClass="display" />
                </td>
            </tr>
            <tr align="center">
                <td align="center">
                    <button id="btnSubmit" type="button" runat="server" class="btn-icon btn-orange btn-saving"
                        onclick="SaveFees();">
                        <span></span>
                        <div id="spSubmit">
                            Save</div>
                    </button>
                    <asp:HiddenField ID="hfAcademicYear" runat="server" />
                    <asp:HiddenField ID="hfSchoolTypeId" runat="server" />
                    <asp:HiddenField ID="hfClassId" runat="server" />
                    <asp:HiddenField ID="hfFeesCategoryId" runat="server" />
                    <asp:HiddenField ID="hfUserId" runat="server" />
                    <asp:HiddenField ID="hfFeesCatHeadId" runat="server" />
                    <asp:HiddenField ID="hfFeesHeadId" runat="server" />
                    <asp:HiddenField ID="hfStartDate" runat="server" />
                    <asp:HiddenField ID="hfEndDate" runat="server" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
