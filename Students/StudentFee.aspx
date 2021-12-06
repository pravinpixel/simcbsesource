<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="StudentFee.aspx.cs" Inherits="Students_StudentFee" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!--Autocomplete script starts here -->
    <%="<script src='" + ResolveUrl("~/js/bsn.AutoSuggest_2.1.3.js") + "' type='text/javascript'></script>"%>
    <%="<link href='" + ResolveUrl("~/css/autosuggest_inquisitor.css") + "' rel='stylesheet' type='text/css'/>"%>
    <!--Autocomplete script ends here -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript">

        $(function () {
            //        GetStudentInfos Function on page load
            var view = $("[id*=hfViewPrm]").val();
            if (view == 'true')


                GetModuleMenuID('Students/ManageFees.aspx');


            var add = $("[id*=hfAddPrm]").val();
            if (add == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);


        });


        function GetStudentsDetail(pageIndex) {

            if ($("[id*=hfViewPrm]").val() == 'true') {


               $.ajax({
                    type: "POST",
                    url: "../Students/StudentFee.aspx/GetStudList",
                    data: '{"pageIndex":"' + pageIndex + '","regNo":"' + $("[id*=txtRegNo]").val() + '","Class":"' + $("[id*=ddlClass]").val() + '","Section":"' + $("[id*=ddlSection]").val() + '","studentName":"' + $("[id*=txtStudentName]").val() + '","AcademicYearId":"' + $("[id*=hdnAcademicYearId]").val() + '","FeeType":"'+$("[name*=rdnFeeType]:checked").val()+'"}',
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
            var admissionStudList = xml.find("PayStudList");

            var optionHref = "";
            if (admissionStudList.find("regno").length > 0) {
                var row = $("[id*=grdPayStudList] tr:last-child").clone(true);
                $("[id*=grdPayStudList] tr").not($("[id*=grdPayStudList] tr:first-child")).remove();
                $.each(admissionStudList, function () {

                    if ($("[name*=rdnFeeType]:checked").val() == "1") {
                        optionHref = "<a href=\"../Students/ManageFees.aspx?menuId=" + $("[id*=hfAcdMenuId]").val() + "&activeIndex=0&moduleId=" + $("[id*=hfAcdModuleID]").val() + "&regno=" + $(this).find("regno").text() + "\">Fee Details</a>";
                    }
                    else if ($("[name*=rdnFeeType]:checked").val() == "2") {
                         optionHref = "<a href=\"../Fees/HostelFees.aspx?menuId=" + $("[id*=hfAcdMenuId]").val() + "&activeIndex=0&moduleId=" + $("[id*=hfAcdModuleID]").val() + "&regno=" + $(this).find("regno").text() + "\">Hostel Fee </a>";
                    }
                    
                  
                    var regno = $(this).find("regno").text();
                    var stname = $(this).find("stname").text();
                    var class1 = $(this).find("classname").text();
                    var classid = $(this).find("classid").text();
                    row.addClass("even");
                    $("td", row).eq(0).html($(this).find("regno").text());
                    $("td", row).eq(1).html($(this).find("stname").text());
                    $("td", row).eq(2).html($(this).find("classname").text());
                    $("td", row).eq(3).html($(this).find("sectionname").text());
                    $("td", row).eq(4).html(optionHref);
                    $("[id*=grdPayStudList]").append(row);
                    row = $("[id*=grdPayStudList] tr:last-child").clone(true);
                });

                var pager = xml.find("Pager");

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
            }
            else {
                var pager = xml.find("Pager");
                if (parseInt(pager.find("RecordCount").text()) > 0)
                    GetStudentsDetail(parseInt(pager.find("PageIndex").text()) - 1);
                else {
                    var row = $("[id*=grdPayStudList] tr:last-child").clone(true);
                    $("[id*=grdPayStudList] tr").not($("[id*=grdPayStudList] tr:first-child")).remove();
                    $("td", row).eq(0).html("");
                    $("td", row).eq(1).html("");
                    $("td", row).eq(2).html("No Result Found");
                    $("td", row).eq(3).html("");
                    $("td", row).eq(4).html("");
                    $("[id*=grdPayStudList]").append(row);
                }
            }

        };


        //        Pager Click Function
        $(".Pager .page").live("click", function (e) {
            GetStudentsDetail(parseInt($(this).attr('page')));
        });

  


    </script>
    <script type="text/javascript">

        function GetSectionByClass(ID) {
            $.ajax({
                type: "POST",
                url: "../Students/StudentFee.aspx/GetSectionByClassID",
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
                url: "../Students/StudentFee.aspx/GetModuleMenuId",
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
        $(document).ready(function () {
            $("input[name=rdnFeeType]").change(function () {
                if ($("[name*=rdnFeeType]:checked").val() == "1") {
                    GetModuleMenuID('Students/ManageFees.aspx');
                }
                else if ($("[name*=rdnFeeType]:checked").val() == "2") {
                    GetModuleMenuID('Fees/HostelFees.aspx');
                }
            });
        });
    
    
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="grid_10">
        <div class="box round first">
            <h2>
                STUDENT FEES</h2>
            <div class="block1 content-wrapper2">
                <table class="form">
                    <tr>
                        <td>
                            <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="10%">
                                        Fee Type :
                                    </td>
                                    <td width="5%">
                                        <input id="rdnFeeType" name="rdnFeeType" type="radio" value="1" checked />
                                    </td>
                                    <td width="10%">
                                        School
                                    </td>
                                    <td>
                                    </td>
                                    <td width="5%">
                                        <input  id="rdnFeeType" name="rdnFeeType" type="radio" value="2" />
                                    </td>
                                    <td>
                                        Hostel
                                    </td>
                                </tr>
                            </table>
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
                                            <asp:TextBox ID="txtRegNo" CssClass="numbersonly" runat="server"></asp:TextBox>
                                        </td>
                                        <td width="5%">
                                            <label>
                                                Class :</label>
                                        </td>
                                        <td width="20%">
                                            <asp:DropDownList ID="ddlClass" runat="server" on AppendDataBoundItems="True" onchange="GetSectionByClass(this.value);">
                                                <asp:ListItem Selected="True" Value="">-----Select----</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td width="5%">
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
                                            <asp:TextBox ID="txtStudentName" CssClass="letterswithbasicpunc" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            .
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
                        </td>
                    </tr>
                 
                    <tr valign="top">
                        <td valign="top">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top" width="12%">
                            <span>Academic Year Belong To : </span>
                        </td>
                        <td valign="top" width="15%">
                            <asp:RadioButtonList ID="radlAcademicYear" RepeatDirection="Horizontal" runat="server">
                            </asp:RadioButtonList>
                        </td>
                        <td valign="top" width="70%">
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <asp:GridView ID="grdPayStudList" runat="server" Width="100%" AutoGenerateColumns="False"
                                AllowPaging="True" ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even"
                                AlternatingRowStyle-CssClass="odd" EnableModelValidation="True" CssClass="display">
                                <Columns>
                                    <asp:BoundField HeaderText="Register No" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Student Name" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Class" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:BoundField HeaderText="Section" HeaderStyle-CssClass="sorting_mod" ReadOnly="True" />
                                    <asp:TemplateField HeaderText="Option" HeaderStyle-CssClass="sorting_mod" ItemStyle-HorizontalAlign="Center">
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
    <asp:HiddenField ID="hdnUserId" runat="server" />
    <asp:HiddenField ID="hdnAcademicYearId" runat="server" />
    <asp:HiddenField ID="hfAcdModuleID" runat="server" />
    <asp:HiddenField ID="hfAcdMenuId" runat="server" />
    <script type="text/javascript">

        var options_xml = {
            script: function (input) { return "../Handlers/GetPayStudent.ashx?input=" + input + "&regNo=" + $("[id*=txtRegNo]").val() + "&Class=" + $("[id*=ddlClass]").val() + "&Section=" + $("[id*=ddlSection]").val() + "&AcademicYearId=" + $("[id*=hdnAcademicYearId]").val() + "&FeeType=" + $("[name*=rdnFeeType]:checked").val() + "&testid=" + document.getElementById('testid').value; },
            varname: "input",
            maxentries: 15
        };


        var as_xml = new bsn.AutoSuggest('<%= txtStudentName.ClientID %>', options_xml);    

    </script>
</asp:Content>
