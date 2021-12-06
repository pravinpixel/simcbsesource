<%@ Page Language="C#" AutoEventWireup="true" CodeFile="redirect.aspx.cs" Inherits="redirect" %>



<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>::Amalorpavam::</title>

    <style type="text/css">
    body
    {
     background: url(images/landing-page-bg.jpg) no-repeat center center fixed; 
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
    }
   
   
   .linebg{background: url(images/line-bg.png) no-repeat center center;}
   
   table
   {
       width:100%;
       height:100%;
   }
    
    </style>

    <%="<script src='" + ResolveUrl("~/js/jquery-1.7.2.min.js") + "'  type='text/javascript'></script>"%>

    <script type="text/javascript">
        $(document).ready(function () {            
            
        });
    
    </script>

</head>

<body>
    <table border="0">
<tr>
<td valign="middle" height="100%" class="linebg">

<table border="0" >
   <tr>
     <td align="center" width="50%" >
     <a href="http://192.168.1.102/SIMV8/"><img src="images/amalor-school-logo.png" alt="" /></a>
       <%--<a href="http://192.168.0.43/SIMV8/"><img src="images/amalor-school-logo.png" alt="" /></a>--%>
     </td>

     <td align="center">
      <a href="http://192.168.1.102/SIMCBSE/"><img src="images/amalor-school-cbse.png" alt="" /></a>
      <%-- <a href="http://192.168.0.43/Simcbsesource/"><img src="images/amalor-school-cbse.png" alt="" /></a>--%>
     </td>

   </tr>
  </table>


</td>
</tr>
  


 </table>
</body>
</html>
