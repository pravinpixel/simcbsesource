<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SIM_SMS Webservice</title>
    <link href="css/jquerysctipttop.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery-1.8.3.js" type="text/javascript"></script>

<style type="text/css">
body { background-color:#333}
</style>


<script type="text/javascript">
    $(function () {
        //smssend();
    });

    function smssend() {
        $.ajax({
            type: "POST",
            url: "Default.aspx/sms_send_to1message",          
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess
        });
    }

    function OnSuccess(response) {
        alert(response.d);
    }



</script>

</head>
<body>
    <form id="form1" runat="server">
   
    <div class="container" style="margin:150px auto; max-width:640px;">
       
        <button class="btn btn-primary btn-lg" type="button">
        <span class="timer-a badge"> SMS Sent Successfully
            &nbsp;</span>
        </button>
       
        <!-- <button class="btn btn-danger btn-lg" type="button">
        <span class="timer-b badge"> Out of: <asp:Label ID="lbl_totsms_cnt" runat="server" Text="100"></asp:Label></span>
        </button>-->

        <br />
               
    </div>


    </form>
</body>
</html>
