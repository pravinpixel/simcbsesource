<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="MarkListSMS.aspx.cs"
    Inherits="Performance_MarkEntry" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {

        });
    </script>
    <style type="text/css">
        .highlight
        {
            background: #A7A4A4;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript">

        $(function () {
            //        GetSMSCopy Function on page load
            MessageType();

        });

        function MessageType() {
            if ($("[id*=MsgText]").is(':checked')) {
                $("[id*=ddlTemplate]").attr('disabled', true);
                $("[id*=txtMessage]").val("");
            }
            else if ($("[id*=msgTemplate]").is(':checked')) {

                $("[id*=ddlTemplate]").attr('disabled', false);
                $("[id*=txtMessage]").val("");
            }
        }

        function GetMessageTemplate() {
            if ($("[id*=hfViewPrm]").val() == 'true') {
                var MessTempID = $("[id*=ddlTemplate]").val();
                if (MessTempID != "") {
                    $.ajax({
                        type: "POST",
                        url: "../SMS/MarkListSMS.aspx/GetMessageTemplate",
                        data: '{MessTempID: ' + MessTempID + '}',
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
                    $("[id*=txtMessage]").val("");
                    $("[id*=status1]").html("(0/160) Left(Max.160 Charactes only allowed)").addClass("status2");
                    return false;
                }
            }

        }

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var MessageTemplates = xml.find("GetMessageTemplate");           
            $.each(MessageTemplates, function () {
                var MessageTemplate = $(this);
                $("[id*=txtMessage]").val($(this).find("Message").text());
                var myLength = $(this).find("Message").text().length;
                if (myLength != "") {
                    if (myLength <= 160) {
                        $("[id*=status1]").html("(" + myLength + "/160) Left(Max.160 Charactes only allowed)").addClass("status2");
                    }
                }

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


//        function Cancel() {
//            $("[id*=ddlExamType]").val('');
//            $("[id*=ddlClass]").val('');
//            $("[id*=ddlSection]").val('');
//            $("[id*=ddlType]").val('');
//            $('#aspnetForm').validate().resetForm();
//            $(".grdList").attr("style", "display:none;");
//        }




        function GetStudents() {

//            var class_ID = $("[id*=ddlClass]").val();
//            var section_ID = $("[id*=ddlSection]").val();
//            var examname_ID = $("[id*=ddlExamName]").val();
//            var type_ID = $("[id*=ddlType]").val();
//            var subject_ID = $("[id*=ddlSubjects]").val();
//            var examtype_ID = $("[id*=ddlExamType]").val();
//            var acadamic_ID = $("[id*=hfAcademicYear]").val();

            var parameters = '{"classId": "' + $("[id*=ddlClass]").val() + '","sectionId": "' + $("[id*=ddlSection]").val() + '","ExamName": "' + $("[id*=ddlExamName]").val() + '","type": "' + $("[id*=ddlType]").val() + '","subject": "' + $("[id*=ddlSubjects]").val() + '","ExamTypeID": "' + $("[id*=ddlExamType]").val() + '","AcadmID": "' + $("[id*=hfAcademicYear]").val() + '","MarkFrom": "' + $("[id*=txtFrom]").val() + '","MarkTo": "' + $("[id*=txtTo]").val() + '"}';
                     
            $.ajax({
                type: "POST",
                url: "../SMS/MarkListSMS.aspx/GetStudents",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetStudentSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }

        
        function OnGetStudentSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var Sections = xml.find("StudentByResult");
            var row = $("[id*=dgStudentList] tr:last-child").clone(true);
            $("[id*=dgStudentList] tr").not($("[id*=dgStudentList] tr:first-child")).remove();
            row.addClass("even");
            if (Sections.length != 0) {
                $.each(Sections, function () {
                    var chkAdd = null;
                    var Smark = null;
                    chkAdd = "<input name=\"chkAdd\" value=\"" + $(this).find("RegNo").text() + "\" id=\"" + $(this).find("RegNo").text() + "\" type=\"checkbox\">";
                    Smark = "<input name=\"Smark\" value=\"" + $(this).find("Mark").text() + "\" id=\"" + $(this).find("Mark").text() + "\" type=\"label\" readonly=\"true\" width=\"50px\">";

                    $("td", row).eq(0).html(chkAdd);
                    $("td", row).eq(1).html($(this).find("RegNo").text());
                    $("td", row).eq(2).html($(this).find("StudentName").text());
                    $("td", row).eq(3).html(Smark);
                    $("[id*=dgStudentList]").append(row);
                    row = $("[id*=dgStudentList] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("");
                $("[id*=dgStudentList]").append(row);
                row = $("[id*=dgStudentList] tr:last-child").clone(true);
            }
        }



        function CheckAll(id) {
            $("[id*=dgStudentList]").find("input[name*='" + id + "']:checkbox").each(function () {
                if ($("[id*=" + id + "]").is(':checked')) {
                    $(this).attr('checked', true);
                }
                else {
                    $(this).attr('checked', false);
                }
            });
        }
        function SMSSelectAll() {

            $(".checkbox1").each(function () {
                if ($("[id*=chkSMSSelectAll]").is(':checked')) {

                    $(this).find('input.chkSmscopy').attr('checked', true);

                    //$(this).attr('checked', true);
                }
                else {
                    $(this).find('input.chkSmscopy').attr('checked', false);
                }
            });

        }
        function Cancel() {

            $("[id*=chkSMSSelectAll]").attr("checked", false);
            SMSSelectAll();

            $("[id*=ddlClass]").val("");
            $("[id*=ddlSection]").val("");
            $("[id*=ddlExamName]").val("");
            $("[id*=ddlType]").val("");
            $("[id*=ddlSubjects]").val("");
            $("[id*=ddlExamType]").val("");
            $("[id*=ddlResult]").val("");          

            $("[id*=txtMessage]").val("");          
            $("[id*=ddlTemplate]").attr('disabled', true);
            $("[id*=btnSubmit]").attr('disabled', false);
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Send");
            var row = $("[id*=dgStudentList] tr:last-child").clone(true);
            $("[id*=dgStudentList] tr").not($("[id*=dgStudentList] tr:first-child")).remove();
            $("[id*=status1]").html("(0/160) Left(Max.160 Charactes only allowed)").addClass("status2");
            $("td", row).eq(0).html("");
            $("td", row).eq(1).html("No Records Found").attr("align", "left");
            $("td", row).eq(2).html("");
            $("[id*=dgStudentList]").append(row);
            row = $("[id*=dgStudentList] tr:last-child").clone(true);
            if ($("[id*=hfAddPrm]").val() == 'false') {
                $("table.form :input").prop('disabled', true);
            }
            else
                $("table.form :input").prop('disabled', false);
        };



<%--Save SMS--%>
          // Save Module
        function SaveSMS() {
             
                    $("[id*=btnSubmit]").attr("disabled", "true");

                               
                    var studList = '';
                    var staffList='';
                    var Psendto =  $("[id*=ddlSendTo]").val();
                    var Message =  $("[id*=txtMessage]").val().replace("'", "\'\'");
                    var userID =   $("[id*=hfuserid]").val();
                    studList = GetQuery(); 
//                    staffList = GetQuery1();            
                    var parameters = '{"studlist": "' + studList + '","sendto": "' + Psendto + '","msg": "' + Message + '","userid": "' + userID + '","classId": "' + $("[id*=ddlClass]").val() + '","sectionId": "' + $("[id*=ddlSection]").val() + '","ExamName": "' + $("[id*=ddlExamName]").val() + '","type": "' + $("[id*=ddlType]").val() + '","subject": "' + $("[id*=ddlSubjects]").val() + '","ExamTypeID": "' + $("[id*=ddlExamType]").val() + '","AcadmID": "' + $("[id*=hfAcademicYear]").val() + '","MarkFrom": "' + $("[id*=txtFrom]").val() + '","MarkTo": "' + $("[id*=txtTo]").val() + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../SMS/MarkListSMS.aspx/SaveSMS",
                        data: parameters,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSavePermissionSuccess,
                        failure: function (response) {
                           AlertMessage('info', response.d);
                        },
                        error: function (response) {
                           AlertMessage('info', response.d);
                        }
                    });
                
        }

         function GetQuery() {
            var sqlstr = '';
            var userId = $("[id*=dpUsers]").val();
         
            $(".even").each(function () {
            
                var addPrm = $(this).find("input[name*='chkAdd']").is(':checked');
                if(addPrm == true)
                {
                var subQuery = $(this).find("input[name*='chkAdd']").val();
                
                if(sqlstr =='')
                    sqlstr = subQuery;
                
                else
                    sqlstr +=','+subQuery;
               
                }                
            });
           
            return sqlstr;
        }


      function GetQuery1() {
            var sqlstr1 = '';
            var subQuery;

            $(".checkbox1").each(function () {
                        var chk = $(this).find('input.chkSmscopy').is(':checked');
                        if (chk == true) {
                        subQuery = $(this).find('input.chkSmscopy').val();
                         if(sqlstr1 =='')
                          sqlstr1 = subQuery;
                         else
                          sqlstr1 +=','+subQuery;
                        }             
            });

            return sqlstr1;
        }


         // Save On Success
        function OnSavePermissionSuccess(response) {
       
            if (response.d == "success" || response.d == "Inserted") {
                AlertMessage('success', response.d);
                 Cancel();
                GetPermission();
               
            }
            else if (response.d == "UpdateFailed") {
                AlertMessage('fail', 'Update');
            }
            else if (response.d == "InsertFailed") {
                AlertMessage('fail', 'Insert');
            }   
            $("[id*=btnSubmit]").attr("disabled", false);

        }

                

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hfUserId" runat="server" />
    <div class="grid_10">
        <div class="box round first fullpage">
            <h2>
                Performance SMS
            </h2>
            <div class="block content-wrapper2">
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
                                                    <asp:DropDownList ID="ddlExamName" runat="server" AppendDataBoundItems="True" CssClass="jsrequired"
                                                        OnSelectedIndexChanged="ddlExamName_SelectedIndexChanged" AutoPostBack="True">
                                                        <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td width="15%">
                                                    <label>
                                                        ExamType :</label>
                                                    <asp:DropDownList ID="ddlExamType" runat="server" CssClass="jsrequired" onchange="BindClass(this.value);">
                                                        <asp:ListItem Selected="True" Value="">-----Select-----</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td width="25%">
                                                    <label>
                                                        Class &nbsp;&nbsp;&nbsp;&nbsp;:</label>
                                                    <asp:DropDownList ID="ddlClass" CssClass="jsrequired" runat="server" AppendDataBoundItems="True">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="40">
                                                    <label>
                                                        Section &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :</label>
                                                    <asp:DropDownList ID="ddlSection" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <label>
                                                        Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :</label>
                                                    <asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                        <asp:ListItem Value="General">General</asp:ListItem>
                                                        <asp:ListItem Value="Samacheer">Samacheer</asp:ListItem>
                                                         <asp:ListItem>Slip Test</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <label>
                                                        Subject :</label>
                                                    <asp:DropDownList ID="ddlSubjects" runat="server" AppendDataBoundItems="True" CssClass="jsrequired">
                                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <label>
                                                        Marks &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label>
                                                    <asp:TextBox ID="txtFrom" Width="50px" runat="server"></asp:TextBox>
                                                    <asp:TextBox ID="txtTo" Width="50px" runat="server"></asp:TextBox>
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <button id="btnSearch" type="button" class="btn-icon btn-navy btn-search" onclick="GetStudents();">
                                                        Search</button>
                                                    <%-- <button id="btnkCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                                        onclick="return Cancel();">
                                                        <span></span>Cancel</button>--%>
                                                </td>
                                                <td>
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
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table width="50%">
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td colspan="3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" colspan="4">
                                        <div style="overflow: auto; height: 300px">
                                            <b>Student Name List</b>
                                            <asp:GridView ID="dgStudentList" runat="server" Width="100%" AutoGenerateColumns="False"
                                                ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even" AlternatingRowStyle-CssClass="odd"
                                                EnableModelValidation="True" CssClass="display">
                                                <AlternatingRowStyle CssClass="odd"></AlternatingRowStyle>
                                                <Columns>
                                                    <asp:TemplateField HeaderText="CheckAll" HeaderStyle-CssClass="sorting_mod">
                                                        <HeaderTemplate>
                                                            <input id="chkAdd" type="checkbox" onchange="CheckAll(this.id);" />Select All
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkAddSelect" runat="server" AutoPostBack="false" />
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="RegNo" HeaderText="RegNo"
                                                        SortExpression="RegNo">
                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="StudentName" HeaderText="Student Name"
                                                        SortExpression="StudentName">
                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="Mark" HeaderText="Mark"
                                                        SortExpression="Mark" ReadOnly="True" Visible="False">
                                                        <HeaderStyle CssClass="sorting_mod"></HeaderStyle>
                                                        <ItemStyle Width="50px" />
                                                    </asp:BoundField>
                                                </Columns>
                                                <RowStyle CssClass="even"></RowStyle>
                                            </asp:GridView>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td colspan="3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Send To</b>
                                    </td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlSendTo" runat="server">
                                            <asp:ListItem Text="Priority" Selected="True" Value="P"></asp:ListItem>
                                            <asp:ListItem Text="Father" Value="F"></asp:ListItem>
                                            <asp:ListItem Text="Mother" Value="M"></asp:ListItem>
                                            <asp:ListItem Text="Gaurdian" Value="G"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td colspan="3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Message By</b>
                                    </td>
                                    <td>
                                        <input type="radio" checked="checked" class="Mess" id="MsgText" onclick="MessageType();"
                                            name="mes" />Entry
                                        <input type="radio" class="Mess" id="msgTemplate" name="mes" onclick="MessageType();" />Template
                                        <asp:DropDownList ID="ddlTemplate" onchange="GetMessageTemplate();" runat="server"
                                            AppendDataBoundItems="True">
                                            <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td colspan="3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <b>Message</b>
                                    </td>
                                    <td colspan="3">
                                        <textarea rows="6" cols="40" id="txtMessage" data-maxsize="160" data-output="status1"
                                            wrap="virtual"></textarea><br />
                                        <div id="status1" class="status1">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        &nbsp;
                                    </td>
                                    <td colspan="3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <%--  <tr>
                                  <td valign="top"><b>SMS Copy To</b></td>
                                  <td colspan="3"><input type="checkbox" id="chkSMSSelectAll" onclick="SMSSelectAll();" />
                                  <b>Select All</b></td>
                                </tr>
                                <tr>
                                  <td valign="top">&nbsp;</td>
                                  <td colspan="3">
                              
                                   </td>
                                            
                                </tr>--%>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td colspan="3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td id="buttonCss" colspan="3">
                                        <button id="btnSubmit" type="button" class="btn-icon btn-navy btn-send" onclick="SaveSMS();">
                                            <span></span>
                                            <div id="spSubmit">
                                                Send</div>
                                        </button>
                                        <%--   <asp:Button ID="btnSearch" runat="server" class="btn-icon btn-navy btn-save" 
                                              Text="Send" onclick="btnSearch_Click" />--%>
                                        <button id="btnCancel" type="button" class="btn-icon btn-navy btn-cancel1" runat="server"
                                            onclick="return Cancel();">
                                            <span></span>Cancel</button>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
