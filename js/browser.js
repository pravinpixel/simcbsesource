var myWidth;
var myHeight;
if( typeof( window.innerWidth ) == 'number' ) 
{ 
	//Non-IE 
	myWidth = window.innerWidth;
	myHeight = window.innerHeight; 

} 
else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) 
{ 
//IE 6+ in 'standards compliant mode' 
myWidth = document.documentElement.clientWidth; 
myHeight = document.documentElement.clientHeight; 

} 
else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) 
{ 
//IE 4 compatible 
myWidth = document.body.clientWidth; 
myHeight = document.body.clientHeight; 
} 
hei = screen.height;
scht = myHeight-(144+36);
//$('.content-wrapper').css('height', ht+'px').css('overflow','scroll').css('overflow-x','hidden').css('-webkit-max-height',ht+'px');

document.writeln("<style>");
document.writeln(".content-wrapper {");
document.writeln("height:"+scht+"px;");
document.writeln("overflow:scroll;");
document.writeln("overflow-x:hidden;");
document.writeln("-webkit-max-height:"+scht+"px;");
document.writeln("}");
document.writeln("</style>");


$(window).resize(function() {
	var ht=$(this).height();
	ht = parseInt(ht)-156;	
	$('.content-wrapper').css('height', ht+'px').css('overflow','scroll').css('overflow-x','hidden').css('-webkit-max-height',ht+'px');
	
/*	document.writeln("<style>");
	document.writeln(".content-wrapper {");
	document.writeln("height:"+ht+"px;");
	document.writeln("overflow:scroll;");
	document.writeln("overflow-x:hidden;");
	document.writeln("-webkit-max-height:"+ht+"px;");
	document.writeln("}");
	document.writeln("</style>");*/
	
});



// Content Wrapper2



var myWidth;
var myHeight;
if( typeof( window.innerWidth ) == 'number' ) 
{ 
	//Non-IE 
	myWidth = window.innerWidth;
	myHeight = window.innerHeight; 

} 
else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) 
{ 
//IE 6+ in 'standards compliant mode' 
myWidth = document.documentElement.clientWidth; 
myHeight = document.documentElement.clientHeight; 

} 
else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) 
{ 
//IE 4 compatible 
myWidth = document.body.clientWidth; 
myHeight = document.body.clientHeight; 
} 
hei = screen.height;
scht = myHeight-(216+36);
//$('.content-wrapper').css('height', ht+'px').css('overflow','scroll').css('overflow-x','hidden').css('-webkit-max-height',ht+'px');

document.writeln("<style>");
document.writeln(".content-wrapper2 {");
document.writeln("height:"+scht+"px;");
document.writeln("overflow:scroll;");
document.writeln("overflow-x:hidden;");
document.writeln("-webkit-max-height:"+scht+"px;");
document.writeln("}");
document.writeln("</style>");


$(window).resize(function() {
	var ht=$(this).height();
	ht = parseInt(ht)-156;	
	$('.content-wrapper2').css('height', ht+'px').css('overflow','scroll').css('overflow-x','hidden').css('-webkit-max-height',ht+'px');
	
/*	document.writeln("<style>");
	document.writeln(".content-wrapper {");
	document.writeln("height:"+ht+"px;");
	document.writeln("overflow:scroll;");
	document.writeln("overflow-x:hidden;");
	document.writeln("-webkit-max-height:"+ht+"px;");
	document.writeln("}");
	document.writeln("</style>");*/
	
});


// Content Wrapper3



var myWidth;
var myHeight;
if( typeof( window.innerWidth ) == 'number' ) 
{ 
	//Non-IE 
	myWidth = window.innerWidth;
	myHeight = window.innerHeight; 

} 
else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) 
{ 
//IE 6+ in 'standards compliant mode' 
myWidth = document.documentElement.clientWidth; 
myHeight = document.documentElement.clientHeight; 

} 
else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) 
{ 
//IE 4 compatible 
myWidth = document.body.clientWidth; 
myHeight = document.body.clientHeight; 
} 
hei = screen.height;
scht = myHeight-(150+36);
//$('.content-wrapper').css('height', ht+'px').css('overflow','scroll').css('overflow-x','hidden').css('-webkit-max-height',ht+'px');

document.writeln("<style>");
document.writeln(".content-wrapper3 {");
document.writeln("height:"+scht+"px;");
document.writeln("overflow:scroll;");
document.writeln("overflow-x:hidden;");
document.writeln("-webkit-max-height:"+scht+"px;");
document.writeln("}");
document.writeln("</style>");


$(window).resize(function() {
	var ht=$(this).height();
	ht = parseInt(ht)-250;	
	$('.content-wrapper3').css('height', ht+'px').css('overflow','scroll').css('overflow-x','hidden').css('-webkit-max-height',ht+'px');
	
/*	document.writeln("<style>");
	document.writeln(".content-wrapper {");
	document.writeln("height:"+ht+"px;");
	document.writeln("overflow:scroll;");
	document.writeln("overflow-x:hidden;");
	document.writeln("-webkit-max-height:"+ht+"px;");
	document.writeln("}");
	document.writeln("</style>");*/
	
});

// Content Wrapper4



var myWidth;
var myHeight;
if (typeof (window.innerWidth) == 'number') {
    //Non-IE 
    myWidth = window.innerWidth;
    myHeight = window.innerHeight;

}
else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
    //IE 6+ in 'standards compliant mode' 
    myWidth = document.documentElement.clientWidth;
    myHeight = document.documentElement.clientHeight;

}
else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
    //IE 4 compatible 
    myWidth = document.body.clientWidth;
    myHeight = document.body.clientHeight;
}
hei = screen.height;
scht = myHeight - (266 + 36);
//$('.content-wrapper').css('height', ht+'px').css('overflow','scroll').css('overflow-x','hidden').css('-webkit-max-height',ht+'px');

document.writeln("<style>");
document.writeln(".content-wrapper4 {");
document.writeln("height:" + scht + "px;");
document.writeln("overflow:scroll;");
document.writeln("overflow-x:hidden;");
document.writeln("-webkit-max-height:" + scht + "px;");
document.writeln("}");
document.writeln("</style>");


$(window).resize(function () {
    var ht = $(this).height();
    ht = parseInt(ht) - 156;
    $('.content-wrapper2').css('height', ht + 'px').css('overflow', 'scroll').css('overflow-x', 'hidden').css('-webkit-max-height', ht + 'px');

    /*	document.writeln("<style>");
    document.writeln(".content-wrapper {");
    document.writeln("height:"+ht+"px;");
    document.writeln("overflow:scroll;");
    document.writeln("overflow-x:hidden;");
    document.writeln("-webkit-max-height:"+ht+"px;");
    document.writeln("}");
    document.writeln("</style>");*/

});

// Content Wrapper5



var myWidth;
var myHeight;
if (typeof (window.innerWidth) == 'number') {
    //Non-IE 
    myWidth = window.innerWidth;
    myHeight = window.innerHeight;

}
else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
    //IE 6+ in 'standards compliant mode' 
    myWidth = document.documentElement.clientWidth;
    myHeight = document.documentElement.clientHeight;

}
else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
    //IE 4 compatible 
    myWidth = document.body.clientWidth;
    myHeight = document.body.clientHeight;
}
hei = screen.height;
scht = myHeight - (320 + 36);
//$('.content-wrapper').css('height', ht+'px').css('overflow','scroll').css('overflow-x','hidden').css('-webkit-max-height',ht+'px');

document.writeln("<style>");
document.writeln(".content-wrapper5 {");
document.writeln("height:" + scht + "px;");
document.writeln("overflow:scroll;");
document.writeln("overflow-x:hidden;");
document.writeln("-webkit-max-height:" + scht + "px;");
document.writeln("}");
document.writeln("</style>");


$(window).resize(function () {
    var ht = $(this).height();
    ht = parseInt(ht) - 156;
    $('.content-wrapper2').css('height', ht + 'px').css('overflow', 'scroll').css('overflow-x', 'hidden').css('-webkit-max-height', ht + 'px');

    /*	document.writeln("<style>");
    document.writeln(".content-wrapper {");
    document.writeln("height:"+ht+"px;");
    document.writeln("overflow:scroll;");
    document.writeln("overflow-x:hidden;");
    document.writeln("-webkit-max-height:"+ht+"px;");
    document.writeln("}");
    document.writeln("</style>");*/

});