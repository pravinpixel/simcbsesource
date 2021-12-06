<%@ Page Language="C#" MasterPageFile="~/MasterPage/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Dashboard.aspx.cs" Inherits="Users_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="../css/reset.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="../css/text.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="../css/grid.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="../css/layout.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="../css/nav.css" media="screen" />
    <!--[if IE 6]><link rel="stylesheet" type="text/css" href="css/ie6.css" media="screen" /><![endif]-->
    <!--[if IE 7]><link rel="stylesheet" type="text/css" href="css/ie.css" media="screen" /><![endif]-->
    <!-- BEGIN: load jquery -->
    <script src="../js/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../js/jquery-ui/jquery.ui.core.min.js"></script>
    <script src="../js/jquery-ui/jquery.ui.widget.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui/jquery.ui.accordion.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui/jquery.effects.core.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui/jquery.effects.slide.min.js" type="text/javascript"></script>
    <!-- END: load jquery -->
    <!-- BEGIN: load jqplot -->
    <link rel="stylesheet" type="text/css" href="../css/jquery.jqplot.min.css" />
    <!--[if lt IE 9]><script language="javascript" type="text/javascript" src="js/jqPlot/excanvas.min.js"></script><![endif]-->
    <script language="javascript" type="text/javascript" src="../js/jqPlot/jquery.jqplot.min.js"></script>
    <script language="javascript" type="text/javascript" src="../js/jqPlot/plugins/jqplot.barRenderer.min.js"></script>
    <script language="javascript" type="text/javascript" src="../js/jqPlot/plugins/jqplot.pieRenderer.min.js"></script>
    <script language="javascript" type="text/javascript" src="../js/jqPlot/plugins/jqplot.categoryAxisRenderer.min.js"></script>
    <script language="javascript" type="text/javascript" src="../js/jqPlot/plugins/jqplot.highlighter.min.js"></script>
    <script language="javascript" type="text/javascript" src="../js/jqPlot/plugins/jqplot.pointLabels.min.js"></script>
    <!-- END: load jqplot -->
    <script src="../js/setup.js" type="text/javascript"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            //setupDashboardChart('chart1');
            setSidebarHeight();


        });
    </script>
    <script type="text/javascript">

        function tick() {
            $('#ticker_01 li:first').slideUp(function () { $(this).appendTo($('#ticker_01')).slideDown(); });
        }
        setInterval(function () { tick() }, 500000);

        /**
        * USE TWITTER DATA
        */
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="divdashboard" class="grid_10">
       
        <div class="box round first fullpage">
            <h2>
                DashBoard
            </h2>
            <div class="block john-accord content-wrapper2">
                <div class="grid_12">
                    <div class="alert info">
                        <span class="icon"></span>
                        <!--<strong>Information</strong>
Lorem ipsum dolor sit amet. -->
                        <asp:PlaceHolder ID="phTicker" runat="server">
                        
                        </asp:PlaceHolder>
                    </div>
                </div>
                <div class="clear">
                </div>
                <div class="grid_12">
                    <div class="isotope_holder indented_area">
                    <asp:PlaceHolder ID="phMenus" runat="server">
                    
                    </asp:PlaceHolder>
                        <%--<ul class="gallery feature_tiles clearfix isotope" style="">
                            <li class="isotope-item"><a class="features" href="#">
                                <img src="../img/user.png">
                                <span class="name sort_1">Profile</span> <span class="update sort_2">0</span>
                                <!--<div class="starred blue">58</div> -->
                            </a></li>
                            <li class=" isotope-item"><a class="features" href="#">
                                <img src="../img/approvals.png">
                                <span class="name sort_1">Approvals</span> <span class="update sort_2">1</span>
                                <div class="starred blue">
                                    58</div>
                            </a></li>
                            <li class="all isotope-item"><a class="features" href="#">
                                <img src="../img/manage-users.png">
                                <span class="name sort_1">Manage Users</span> <span class="update sort_2">0</span>
                            </a></li>
                            <li class="all isotope-item"><a class="features" href="#">
                                <img src="../img/leave-user.png">
                                <span class="name sort_1">Leaves</span> <span class="update sort_2">0</span> </a>
                            </li>
                            <li class=" isotope-item" s><a class="features" href="#">
                                <img src="../img/news.png">
                                <span class="name sort_1">Announcements</span> <span class="update sort_2">2</span>
                                <div class="starred blue">
                                    58</div>
                            </a></li>
                            <li class=" isotope-item"><a class="features" href="#">
                                <img src="../img/note.png">
                                <span class="name sort_1">Circulars</span> <span class="update sort_2">2</span>
                                <div class="starred blue">
                                    58</div>
                            </a></li>
                            <li class=" isotope-item"><a class="features" href="#">
                                <img src="../img/birthday.png">
                                <span class="name sort_1">Birthdays</span> <span class="update sort_2">2</span>
                                <div class="starred blue">
                                    58</div>
                            </a></li>
                            <li class=" isotope-item"><a class="features" href="#">
                                <img src="../img/student-report.png">
                                <span class="name sort_1">Student Attendance</span> <span class="update sort_2">2</span>
                                <!--<div class="starred blue">58</div> -->
                            </a></li>
                            <li class="isotope-item"><a class="features" href="#">
                                <img src="../img/staff-report.png">
                                <span class="name sort_1">Staff Attendance</span> <span class="update sort_2">0</span>
                                <!--<div class="starred blue">58</div> -->
                            </a></li>
                            <li class="isotope-item"><a class="features" href="#">
                                <img src="../img/mail_receive.png">
                                <span class="name sort_1">Messages</span> <span class="update sort_2">0</span>
                                <div class="starred blue">
                                    58</div>
                            </a></li>
                        </ul>--%>
                    </div>
                </div>
                <div class="clear">
                </div>
                <div class="grid_12">
                    <div class="box1">
                        <div class="header">
                            <h3>
                                Student info</h3>
                            <span></span>
                        </div>
                        <div class="content with-actions">
                            <ul class="stats-list">
                                <li><a href="#" >Total Students <span id="totalStudents" runat="server"></span></a> </li>
                                <li><a href="#" >Total Boys <span id="totalboys" runat="server"></span></a> </li>
                                <li><a href="#">Total Girls <span  id="totalgirls" runat="server"></span></a> </li>
                                <li><a href="#" >Today Present <span id="totalStudentPresent" runat="server"></span></a> </li>
                            </ul>
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                    <div class="box1">
                        <div class="header">
                            <h3>
                                Staff Info</h3>
                            <span></span>
                        </div>
                        <div class="content with-actions">
                            <ul class="stats-list">
                                <li><a href="#" >Total Staffs <span id="totalStaffs" runat="server"></span></a> </li>
                                <li><a href="#" >Total Male <span id="totalMale" runat="server"></span></a> </li>
                                <li><a href="#">Total Female <span  id="totalFemale" runat="server"></span></a> </li>
                                <li><a href="#" >Today Present <span id="totalStaffPresent" runat="server"></span></a> </li>
                            </ul>
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                    <div class="box1">
                        <div class="header">
                            <h3>
                                Hostel Info</h3>
                            <span></span>
                        </div>
                        <div class="content with-actions">
                            <ul class="stats-list">
                                <li><a href="#">Total Students <span id="totalHstudents" runat="server"></span></a> </li>
                                <li><a href="#">Total Boys <span id="totalHboys" runat="server"></span></a> </li>
                                <li><a href="#">Total Girls <span id="totalHgirls" runat="server"></span></a> </li>
                            </ul>
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                     <div class="box1">
                        <div class="header">
                            <h3>
                                Expiry Reminder Info</h3>
                            <span></span>
                        </div>
                        <div class="content with-actions">

                        <asp:PlaceHolder ID="plReminder" runat="server">                         
                        </asp:PlaceHolder>
                           
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
