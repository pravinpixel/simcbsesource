<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ManageProfile.aspx.cs" Inherits="Staffs_ManageProfile" %>

<%@ MasterType VirtualPath="~/MasterPage/AdminMaster.master" %>
<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("[id*=ddlReligion]").attr("disabled", "disabled");
            $("[id*=ddlCommunity]").attr("disabled", "disabled");
            $("[id*=dpDownMaraital]").attr("disabled", "disabled");
            GetPersonalDetails();
        });
    </script>
    <script type="text/javascript">
        function CheckAll() {
            if ($("[id*=chkContact]").is(':checked')) {
                $("[id*=txtContactAddress]").val($("[id*=txtPermanentAddress]").val());
                $("[id*=txtContactAddress]").attr("disabled", true);
            }
            else {
                $("[id*=txtContactAddress]").attr("disabled", false);
                $("[id*=txtContactAddress]").val('');
            }
        }
    </script>
    <%--Get Personal Details--%>
    <script type="text/javascript">
        function GetPersonalDetails() {
            var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '"}';
            $.ajax({
                type: "POST",
                url: "../Staffs/ManageProfile.aspx/GetPersonalDetails",
                data: parameters,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnGetPersonalSuccess,
                failure: function (response) {
                    AlertMessage('info', response.d);
                },
                error: function (response) {
                    AlertMessage('info', response.d);
                }
            });
        }
        var formdata;
        function readURL(input) {
            if (window.FormData) {
                formdata = new FormData();
            }
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#img_prev').attr('src', e.target.result).width(114).height(114);

                };
                //                if (input.files[0].type == "image/jpeg" && input.files[0].type == "image/jpg"&&input.files[0].type == "image/jpg") {
                //                }
                reader.readAsDataURL(input.files[0]);
                if (formdata) {
                    formdata.append("StaffImage", input.files[0]);
                }
            }
        }
        function OnGetPersonalSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var menus = xml.find("Personal");
            $.each(menus, function () {

                $("[id*=hdnStaffId]").val($(this).find("StaffId").text());
                $("[id*=txtEmpCode]").val($(this).find("EmpCode").text());
                $("[id*=txtStaffName]").val($(this).find("StaffName").text());
                $("[id*=txtShortName]").val($(this).find("StaffShortName").text());
                $("[name*=rb1]").val($(this).find("Sex").text());
                $("[id*=datepicker]").val($(this).find("DOBFORMAT").text());
                $("[id*=txtPlaceOfBirth]").val($(this).find("PlaceOfBirth").text());
                $("[id*=txtMotherTongue]").val($(this).find("MotherTongue").text());
                $("[id*=txtNationality]").val($(this).find("Nationality").text());
                $("[id*=ddlReligion]").val($(this).find("ReligionId").text());
                $("[id*=ddlCommunity]").val($(this).find("CommunityId").text());
                $("[id*=txtCaste]").val($(this).find("Caste").text());
                $("[id*=txtPermanentAddress]").val($(this).find("PermAddress").text());
                $("[id*=txtContactAddress]").val($(this).find("ContactAddress").text());
                $("[id*=dpDownMaraital]").val($(this).find("MaritalStatus").text());
                $("[id*=txtPhoneNo]").val($(this).find("PhoneNo").text());
                $("[id*=txtEmailAddress]").val($(this).find("EmailId").text());
                $("[id*=txtMobileNo]").val($(this).find("MobileNo").text());
                $("[id*=txtPanCard]").val($(this).find("PanCardNo").text());
                $("[id*=txtAadhaar]").val($(this).find("AadhaarNo").text());
                $("[id*=txtDOR]").val($(this).find("DateOfRetirementFormat").text());

                var newSrc = '';
                if ($(this).find("PhotoFile").text() == "")
                    newSrc = "../img/photo.jpg";
                else
                    newSrc = "../Staffs/Uploads/ProfilePhotos/" + $(this).find("PhotoFile").text();
                $("[id*=img_prev]").attr('src', newSrc);
            });
        }

    </script>
    <%--Save Personal Details--%>
    <script type="text/javascript">
        function SavePersonalDetails() {
            if ($('#aspnetForm').valid()) {
                var parameters = '{"staffId": "' + $("[id*=hdnStaffId]").val() + '","staffName": "' + $("[id*=txtStaffName]").val() + '","staffShortName": "' + $("[id*=txtShortName]").val() + '","empCode": "' + $("[id*=txtEmpCode]").val() + '","sex": "' + $("[name*=rb1]").val() + '","dob": "' + $("[id*=datepicker]").val() + '","pob": "' + $("[id*=txtPlaceOfBirth]").val() + '","motherTongue": "' + $("[id*=txtMotherTongue]").val() + '","nationality": "' + $("[id*=txtNationality]").val() + '","religionId": "' + $("[id*=ddlReligion]").val() + '","communityId": "' + $("[id*=ddlCommunity]").val() + '","caste": "' + $("[id*=txtCaste]").val() + '","maritalStatus": "' + $("[id*=dpDownMaraital]").val() + '","permAddress": "' + $("[id*=txtPermanentAddress]").val() + '","contactAddress": "' + $("[id*=txtContactAddress]").val() + '","phoneNo": "' + $("[id*=txtPhoneNo]").val() + '","emailId": "' + $("[id*=txtEmailAddress]").val() + '","mobileNo": "' + $("[id*=txtMobileNo]").val() + '","panCard": "' + $("[id*=txtPanCard]").val() + '","aadhaarNo": "' + $("[id*=txtAadhaar]").val() + '","photoFile": "' + $("[id*=userPhoto]").val().replace(/C:\\fakepath\\/i, '') + '","dateOfRetirement": "' + $("[id*=txtDOR]").val() + '","userId": "' + $("[id*=hfuserid]").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "../Staffs/StaffInfo.aspx/InsertStaff",
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
        function OnSaveSuccess(response) {
            if (response.d.Status == "Updated") {
                AlertMessage('success', "Updated");
            }
            else if (response.d == "Update Failed") {
                AlertMessage('fail', "Update");
            }
            $("[id*=hdnStaffId]").val(response.d.StaffId);
            var staffId = $("[id*=hdnStaffId]").val();
            formdata.append("StaffId", staffId);
            if (formdata) {
                $.ajax({
                    url: "../Staffs/StaffInfo.aspx",
                    type: "POST",
                    data: formdata,
                    processData: false,
                    contentType: false,
                    success: function (res) {
                        formdata = new FormData();
                        // alert(res)
                    }
                });
            }
        }
        
    </script>
    <%--Cancel Control--%>
    <script type="text/javascript">
        function CancelPersonalPanel() {
            $("[id*=txtPermanentAddress]").val('');
            $("[id*=txtContactAddress]").val('');
            $("[id*=txtEmailAddress]").val('');
            $("[id*=txtMobileNo]").val('');
            $("[id*=txtPhoneNo]").val('');
            $("[id*=chkContact]").attr('checked', false);
        }
    </script>
</asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="grid_10">
        <div class="box round first fullpage" style="overflow: auto; height: 600px;">
            <h2>
                Manage Profile</h2>
            <div class="block content-wrapper2">
                <asp:HiddenField ID="hdnStaffId" runat="server" />
                <div class="frm-block" style="height: 540px;">
                    <div style="float: right; margin-top: 5px;">
                        <img id="img_prev" src="../img/photo.jpg" alt="Profile Photo" width="114" height="114" />
                    </div>
                    <div style="float: left; width: 80%;">
                        <table class="form">
                            <tr>
                                <td width="20%" class="col1">
                                    <label>
                                        Employee Code :</label>
                                </td>
                                <td width="26%" class="col2">
                                    <asp:TextBox ID="txtEmpCode" runat="server" ReadOnly="true"></asp:TextBox>
                                </td>
                                <td>
                                    <span class="col1"><span style="color: Red">*</span>
                                        <label>
                                            Name :</label>
                                    </span>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtStaffName" CssClass="jsrequired lettersforname" ReadOnly="true"
                                        runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td width="20%" class="col1">
                                    <span style="color: Red">*</span>
                                    <label>
                                        Staff Short Name :</label>
                                </td>
                                <td width="26%" class="col2">
                                    <asp:TextBox ID="txtShortName" CssClass="jsrequired letterswithspace" ReadOnly="true"
                                        runat="server"></asp:TextBox>
                                </td>
                                <td width="20%" class="col1">
                                    <label>
                                        <span style="color: Red">*</span> Date of Birth :</label>
                                </td>
                                <td width="26%" class="col2">
                                    <input id="datepicker" type="text" class="jsrequired" readonly="readonly" onblur="setAltDate()" />
                                </td>
                            </tr>
                            <tr>
                                <td width="14%" class="col2">
                                    <span class="col1">
                                        <label>
                                            Sex :</label>
                                    </span>
                                </td>
                                <td class="col2">
                                    <label>
                                        <input type="radio" name="rb1" id="rbtnMale" value="M" checked="checked" disabled="disabled" />
                                        Male</label>
                                    <label>
                                        <input type="radio" name="rb1" id="rbtnFemale" value="F" disabled="disabled" />
                                        Female</label>
                                </td>
                                <td>
                                    <label>
                                        Mother Tongue :
                                    </label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMotherTongue" CssClass="lettersonly" runat="server" ReadOnly="true"></asp:TextBox>
                                    <%--<asp:TextBox ID="txtDOB" CssClass="jsrequired dateNL date-picker" runat="server"></asp:TextBox>--%>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Place of Birth :</label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPlaceOfBirth" CssClass="lettersonly" runat="server" ReadOnly="true"></asp:TextBox>
                                </td>
                                <td>
                                    <label>
                                        Religion :</label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlReligion" CssClass="" runat="server" AppendDataBoundItems="True">
                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Nationality :</label>
                                </td>
                                <td>
                                    <input type="text" id="Text1" value="" style="display: none" />
                                    <asp:TextBox ID="txtNationality" CssClass="lettersonly" ReadOnly="true" runat="server"></asp:TextBox>
                                </td>
                                <td>
                                    <label>
                                        Caste :</label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtCaste" runat="server" ReadOnly="true"></asp:TextBox>
                                    <input type="text" id="testid" value="" style="display: none" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Community :</label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlCommunity" CssClass="" runat="server" AppendDataBoundItems="True">
                                        <asp:ListItem Selected="True" Value="">---Select---</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <label>
                                        Maraital Status :</label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="dpDownMaraital" runat="server">
                                        <asp:ListItem Value="" Text="---Select---" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="Single" Text="Single"></asp:ListItem>
                                        <asp:ListItem Value="Married" Text="Married"></asp:ListItem>
                                        <asp:ListItem Value="Widowed" Text="Widow"></asp:ListItem>
                                        <asp:ListItem Value="Divorced" Text="Divorced"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <label>
                                        Permanent Address :</label>
                                </td>
                                <td valign="top">
                                    <asp:TextBox ID="txtPermanentAddress" TextMode="MultiLine" runat="server" Columns="30"
                                        Rows="5" onchange="CheckAll();"></asp:TextBox>
                                </td>
                                <td valign="top">
                                    <label>
                                        Contact Address :</label>
                                </td>
                                <td valign="top">
                                    <asp:TextBox ID="txtContactAddress" TextMode="MultiLine" runat="server" Columns="30"
                                        Rows="5" onchange="CheckAll();"></asp:TextBox>
                                    <br />
                                    <label>
                                        <input type="checkbox" name="chkContact" id="chkContact" value="contact" onchange="CheckAll();" />
                                        <span class="sameas">Same as Permanent Address</span></label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Email Id :</label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEmailAddress" CssClass="email" runat="server"></asp:TextBox>
                                </td>
                                <td>
                                    <label>
                                        Phone No :</label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPhoneNo" CssClass="numbersonly" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Pan Card No :</label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPanCard" CssClass="bloodgroup" ReadOnly="true" runat="server"></asp:TextBox>
                                </td>
                                <td>
                                    <label>
                                        <span style="color: Red">*</span> Mobile No :</label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMobileNo" CssClass="jsrequired numbersonly" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Aadhaar No :</label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAadhaar" ReadOnly="true" CssClass="bloodgroup" runat="server"></asp:TextBox>
                                </td>
                                <td>
                                    <label>
                                        Date Of Retirement :</label>
                                </td>
                                <td>
                                    <input name="text" type="text" readonly="readonly" id="txtDOR" size="30" readonly="readonly" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Upload Image :</label>
                                </td>
                                <td>
                                    <input type='file' style="width: 180px;" id="userPhoto" onchange="readURL(this);" />
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    <%--<asp:TextBox ID="txtDOR"  runat="server"></asp:TextBox>--%>
                                </td>
                            </tr>
                            <tr>
                                <td height="40">
                                </td>
                                <td colspan="3">
                                    <br />
                                    <button id="btnPersonalSubmit" type="button" class="btn-icon btn-orange btn-saving" onclick="SavePersonalDetails();">
                                        <span></span>
                                        <div id="spSubmit">
                                            Save</div>
                                    </button>
                                    <button id="btnPersonalCancel" type="button" class="btn-icon btn-navy btn-cancel1"
                                        runat="server" onclick="return CancelPersonalPanel();">
                                        <span></span>Cancel</button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
