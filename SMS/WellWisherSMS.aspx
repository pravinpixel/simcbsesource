<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master"
    AutoEventWireup="true" CodeFile="WellWisherSMS.aspx.cs" Inherits="WellWisherSMS" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" runat="Server">
    <script type="text/javascript" src="../js/maxlength.js"></script>
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
                        url: "../SMS/WellWisherSMS.aspx/GetMessageTemplate",
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

        function GetWellWishers(AddressType) {
            $.ajax({
                type: "POST",
                url: "../SMS/WellWisherSMS.aspx/GetWellWishers",
                contentType: "application/json; charset=utf-8",
                data: '{"AddressType": "' + AddressType + '"}',
                dataType: "json",
                success: OnGetWellWishersuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        function OnGetWellWishersuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var WellWisher = xml.find("WellWisher");
            var row = $("[id*=dgWellWisherList] tr:last-child").clone(true);
            $("[id*=dgWellWisherList] tr").not($("[id*=dgWellWisherList] tr:first-child")).remove();
            row.addClass("even");
            if (WellWisher.length != 0) {
                $.each(WellWisher, function () {
                    var chkAdd = null;
                    chkAdd = "<input name=\"chkAdd\" value=\"" + $(this).find("WellWisherID").text() + "\" id=\"" + $(this).find("WellWisherID").text() + "\" type=\"checkbox\">";
                    $("td", row).eq(0).html(chkAdd);
                    $("td", row).eq(1).html($(this).find("WellWisherID").text());
                    $("td", row).eq(2).html($(this).find("Name").text());
                    $("td", row).eq(3).html($(this).find("MobileNo").text());
                    $("[id*=dgWellWisherList]").append(row);
                    row = $("[id*=dgWellWisherList] tr:last-child").clone(true);
                });
            }
            else {
                $("td", row).eq(0).html("");
                $("td", row).eq(1).html("No Records Found").attr("align", "left");
                $("td", row).eq(2).html("");
                $("td", row).eq(3).html("");
                $("[id*=dgWellWisherList]").append(row);
                row = $("[id*=dgWellWisherList] tr:last-child").clone(true);
            }
        }

        function CheckAll(id) {
            $("[id*=dgWellWisherList]").find("input[name*='" + id + "']:checkbox").each(function () {
                if ($("[id*=" + id + "]").is(':checked')) {
                    $(this).attr('checked', true);
                }
                else {
                    $(this).attr('checked', false);
                }
            });
        }

        function Cancel() {
            $("[id*=txtMessage]").val("");
            $("[id*=ddlTemplate]").attr('disabled', true);
            $("[id*=btnSubmit]").attr('disabled', false);
            $('#aspnetForm').validate().resetForm();
            $("[id*=spSubmit]").html("Send");
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
                    var staffList='';
                    var Message =  $("[id*=txtMessage]").val().replace("'", "\'\'");
                    var userID =   $("[id*=hfuserid]").val();
                    staffList = GetQuery();                  
                            
                    var parameters = '{"stafflist": "' + staffList + '","msg": "' + Message + '","userid": "' + userID + '"}';
                    $.ajax({
                        type: "POST",
                        url: "../SMS/WellWisherSMS.aspx/SaveSMS",
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
    <div class="grid_10">
        <div class="box round first">
            <h2>
                WellWisher SMS</h2>
            <div class="block content-wrapper2">
                <table width="100%">
                    <tr valign="top">
                        <td valign="top">
                            <table width="50%">
                                <tr>
                                    <td width="2%">
                                        <b>Type</b>
                                    </td>
                                    <td width="10%">
                                        <asp:DropDownList ID="ddlAddressType" runat="server"
                                            onchange="GetWellWishers(this.value);">
                                            <asp:ListItem Selected="True">---Select---</asp:ListItem>
                                            <asp:ListItem Value="Alumni">Alumni</asp:ListItem>
                                            <asp:ListItem  Value="Banks">Banks</asp:ListItem>
                                            <asp:ListItem Value="Chief Guest">Chief Guest</asp:ListItem>
                                            <asp:ListItem Value="Colleges">Colleges</asp:ListItem>
                                            <asp:ListItem Value="Companies">Companies</asp:ListItem>
                                            <asp:ListItem Value="Doctors">Doctors</asp:ListItem>
                                            <asp:ListItem Value="Engineers">Engineers</asp:ListItem>
                                            <asp:ListItem Value="High School">High School</asp:ListItem>
                                            <asp:ListItem Value="Hr.Sec. School">Hr.Sec. School</asp:ListItem>
                                            <asp:ListItem Value="Govt Officials">Govt Officials</asp:ListItem>
                                            <asp:ListItem Value="Political Parties">Political Parties</asp:ListItem>
                                            <asp:ListItem Value="Press">Press</asp:ListItem>
                                            <asp:ListItem Value="Sports">Sports</asp:ListItem>
                                            <asp:ListItem Value="Student">Student</asp:ListItem>
                                            <asp:ListItem Value="Staff">Staff</asp:ListItem>
                                            <asp:ListItem Value="Relations">Relations</asp:ListItem>
                                            <asp:ListItem Value="Religious"></asp:ListItem>
                                            <asp:ListItem Value="Well-wisher">Well-wisher</asp:ListItem>
                                            <asp:ListItem Value="Others">Others</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" colspan="2">
                                        <div style="overflow: auto; height: 300px">
                                            <b>WellWishers List</b>
                                            <asp:GridView ID="dgWellWisherList" runat="server" Width="100%" AutoGenerateColumns="False"
                                                ShowFooter="True" HorizontalAlign="Center" RowStyle-CssClass="even" AlternatingRowStyle-CssClass="odd"
                                                EnableModelValidation="True" CssClass="display">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="CheckAll" HeaderStyle-CssClass="sorting_mod">
                                                        <HeaderTemplate>
                                                            <input id="chkAdd" type="checkbox" onchange="CheckAll(this.id);" />Select All
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkAddSelect" runat="server" AutoPostBack="false" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="WellWisherID" HeaderText="WellWisher ID"
                                                        SortExpression="WellWisherID" />
                                                    <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="WellWisherName" HeaderText="WellWisher Name"
                                                        SortExpression="WellWisherName" />
                                                    <asp:BoundField HeaderStyle-CssClass="sorting_mod" DataField="MobileNo" HeaderText="Mobile No"
                                                        SortExpression="MobileNo" />
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
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
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <b>Message</b>
                                    </td>
                                    <td>
                                        <textarea rows="6" cols="40" id="txtMessage" data-maxsize="160" data-output="status1"
                                            wrap="virtual"></textarea><br />
                                        <div id="status1" class="status1">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td id="buttonCss">
                                        <button id="btnSubmit" type="button" class="btn-icon btn-navy btn-send" onclick="SaveSMS();">
                                            <span></span>
                                            <div id="spSubmit">
                                                Send</div>
                                        </button>
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
