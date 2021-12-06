<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%="<link href='" + ResolveUrl("~/css/login.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
    <%="<link href='" + ResolveUrl("~/css/layout.css") + "' rel='stylesheet' type='text/css'  media='screen' />"%>
    <%="<script src='" + ResolveUrl("~/js/jquery-1.7.2.min.js") + "' type='text/javascript'></script>"%>
    <%="<script src='" + ResolveUrl("~/js/jquery.validate.js") + "' type='text/javascript'></script>"%>
    <%="<script src='" + ResolveUrl("~/js/additional-methods.js") + "' type='text/javascript'></script>"%>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#form1').validate();
        });
        function Cancel() {
            $("[id*=txtUserName]").val("");
            $("[id*=txtPassword]").val("");
            $("[id*=lblError]").html("");
            $('#form1').validate().resetForm();
        };
    </script>
</head>
<body id="login-bg">
    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td valign="middle">
                <form id="form1" runat="server">
                <div style="width: 100%; height: 100%;">
                    <div class="grid_12">
                        <div class="school-photo">
                            <div class="">
                                <img src="img/school1.jpg" alt="" width="233" height="167" /></div>
                            <div class="school-photo2">
                                <img src="img/school2.jpg" alt="" width="232" height="166" /></div>
                        </div>
                        <div class="login-area" align="ccenter">
                            <div class="loginblock">
                                <div class="logo-header">
                                    <img src="img/login-school-logo.png" alt="" width="457" height="80" /></div>
                                <h1>
                                    SIM V.8</h1>
                                <div class="login-field">
                                    <div class="login-name-area" style="padding-top: 14px;">
                                        Username</div>
                                    <div class="login-txt-area">
                                        <asp:TextBox ID="txtUserName" CssClass="jsrequired" runat="server"></asp:TextBox></div>
                                    <div class="clear">
                                    </div>
                                    <div class="login-name-area" style="padding-top: 14px;">
                                        Password</div>
                                    <div class="login-txt-area">
                                        <asp:TextBox ID="txtPassword" TextMode="Password" CssClass="jsrequired" runat="server"></asp:TextBox></div>
                                    <div class="clear">
                                    </div>
                                    <div class="login-name-area">
                                    </div>
                                    <div class="login-txt-area">
                                        <span class="login-txt-area">
                                            <asp:Button ID="btnSubmit" runat="server" Text="Login" CssClass="cButton cButton-Blue"
                                                OnClick="btnSubmit_Click" />
                                            <asp:Button ID="btnCancel" class="cButton cButton-Blue" UseSubmitBehavior="false"
                                                Text="Cancel" runat="server" OnClientClick="return Cancel();" />
                                        </span>
                                        <br />
                                        <asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label></div>
                                    <div class="clear">
                                    </div>
                                </div>
                                <!--/*login details*/-->
                                <div class="pixel" align="right">
                                    <img src="img/pixel-studios-logo.png" alt="" width="135" height="30" /></div>
                            </div>
                            <!--/*login block*/-->
                        </div>
                        <div class="lourd-photo">
                            <%--<img src="img/lourd-photo.png" alt="" width="200" height="250" />--%></div>
                    </div>
                    <div class="clear">
                    </div>
                </div>
                </form>
            </td>
        </tr>
    </table>
</body>
</html>
