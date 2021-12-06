/**
* jQuery Validation Plugin 1.9.0
*
* http://bassistance.de/jquery-plugins/jquery-plugin-validation/
* http://docs.jquery.com/Plugins/Validation
*
* Copyright (c) 2006 - 2011 Jörn Zaefferer
*
* Dual licensed under the MIT and GPL licenses:
*   http://www.opensource.org/licenses/mit-license.php
*   http://www.gnu.org/licenses/gpl.html
*/

function AlertMessage(value, type) {

    if (value == "success") {
        jSuccess(
		'<strong>' + type + ' Successfully<strong>',
		{
		    autoHide: true, // added in v2.0
		    clickOverlay: false, // added in v2.0
		    MinWidth: 250,
		    TimeShown: 1000,
		    ShowTimeEffect: 200,
		    HideTimeEffect: 200,
		    LongTrip: 20,
		    HorizontalPosition: 'center',
		    VerticalPosition: 'top',
		    ShowOverlay: true,
		    ColorOverlay: '#000',
		    OpacityOverlay: 0.3
		});
    }
    else if (value == "fail") {
        jError(
		'<strong>' + type + ' Failed<strong>',
		{
		    autoHide: true, // added in v2.0
		    clickOverlay: false, // added in v2.0
		    MinWidth: 250,
		    TimeShown: 1000,
		    ShowTimeEffect: 200,
		    HideTimeEffect: 200,
		    LongTrip: 20,
		    HorizontalPosition: 'center',
		    VerticalPosition: 'top',
		    ShowOverlay: true,
		    ColorOverlay: '#000',
		    OpacityOverlay: 0.3
		});
    }
    else if (value == "info") {
        jNotify(
		'<strong>' + type + '<strong>',
		{
		    autoHide: true, // added in v2.0
		    clickOverlay: false, // added in v2.0
		    MinWidth: 250,
		    TimeShown: 1000,
		    ShowTimeEffect: 200,
		    HideTimeEffect: 200,
		    LongTrip: 20,
		    HorizontalPosition: 'center',
		    VerticalPosition: 'top',
		    ShowOverlay: true,
		    ColorOverlay: '#000',
		    OpacityOverlay: 0.3
		});
}
else if (value == "reference") {
    jError(
		'<strong>' + type + ' <strong>',
		{
		    autoHide: true, // added in v2.0
		    clickOverlay: false, // added in v2.0
		    MinWidth: 250,
		    TimeShown: 1000,
		    ShowTimeEffect: 200,
		    HideTimeEffect: 200,
		    LongTrip: 20,
		    HorizontalPosition: 'center',
		    VerticalPosition: 'top',
		    ShowOverlay: true,
		    ColorOverlay: '#000',
		    OpacityOverlay: 0.3
		});
}
}

(function () {

    function stripHtml(value) {
        // remove html tags and space chars
        return value.replace(/<.[^<>]*?>/g, ' ').replace(/&nbsp;|&#160;/gi, ' ')
        // remove numbers and punctuation
		.replace(/[0-9.(),;:!?%#$'"_+=\/-]*/g, '');
    }
    jQuery.validator.addMethod("maxWords", function (value, element, params) {
        return this.optional(element) || stripHtml(value).match(/\b\w+\b/g).length < params;
    }, jQuery.validator.format("Please enter {0} words or less."));

    jQuery.validator.addMethod("minWords", function (value, element, params) {
        return this.optional(element) || stripHtml(value).match(/\b\w+\b/g).length >= params;
    }, jQuery.validator.format("Please enter at least {0} words."));

    jQuery.validator.addMethod("rangeWords", function (value, element, params) {
        return this.optional(element) || stripHtml(value).match(/\b\w+\b/g).length >= params[0] && value.match(/bw+b/g).length < params[1];
    }, jQuery.validator.format("Please enter between {0} and {1} words."));

})();

jQuery.validator.addMethod("numericswithdecimals", function (value, element) {
    return this.optional(element) || /^[0-9.'\"]+$/i.test(value);
}, "Numbers only please");
jQuery.validator.addMethod("numbersonly", function (value, element) {
    return this.optional(element) || /^[0-9'\"]+$/i.test(value);
}, "Numbers only please");
jQuery.validator.addMethod("letterswithbasicpunc", function (value, element) {
    return this.optional(element) || /^[a-z-.,()'\"\s]+$/i.test(value);
}, "Letters or punctuation only please");

jQuery.validator.addMethod("lettersforcourse", function (value, element) {
    return this.optional(element) || /^[A-Za-z]+$/i.test(value);
}, "Please enter valid format course");

jQuery.validator.addMethod("lettersforname", function (value, element) {
    return this.optional(element) || /^[a-z.'\"\s]+$/i.test(value);
}, "Please enter valid name");

jQuery.validator.addMethod("bloodgroup", function (value, element) {
    return this.optional(element) || /^[a-z-+0-9.,_'\"\s]+$/i.test(value);
}, "Alphanumeric or (+) or (-) sign only please");

jQuery.validator.addMethod("letterswithspace", function (value, element) {
    return this.optional(element) || /^[a-z'\"\s]+$/i.test(value);
}, "Please enter only letters");

jQuery.validator.addMethod("lettersonly", function (value, element) {
    return this.optional(element) || /^[a-z]+$/i.test(value);
}, "Letters only please");

jQuery.validator.addMethod("postalcode", function (postalcode, element) {
    return this.optional(element) || postalcode.match(/(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXYabceghjklmnpstvxy]{1}\d{1}[A-Za-z]{1} ?\d{1}[A-Za-z]{1}\d{1})$/);
}, "Please specify a valid postal/zip code");


$.validator.addMethod("globalzip", function (value, element) {
    var isIN = $("#country").val() === "103";
    var isAUS = $("#country").val() === "18";

    if (isIN && value.length < 6) {
        return false;
    }
    else if (isIN && value.length > 6) {
        return false;
    }
    else if (isAUS && value.length < 4) {
        return false;
    }
    else if (isAUS && value.length > 4) {
        return false;
    }
    else if (!isIN && !isAUS && value.length < 5) {
        return false;
    }
    else if (!isIN && !isAUS && value.length > 5) {
        return false;
    }
    else
        return true;

}, "Australian Zip Code Must Be at least 4 Digits");

$.validator.addMethod("globalzipShip", function (value, element) {
    var isIN = $("#shipcountry").val() === "103";
    var isAUS = $("#shipcountry").val() === "18";

    if (isIN && value.length < 6) {
        return false;
    }
    else if (isIN && value.length > 6) {
        return false;
    }
    else if (isAUS && value.length < 4) {
        return false;
    }
    else if (isAUS && value.length > 4) {
        return false;
    }
    else if (!isIN && !isAUS && value.length < 5) {
        return false;
    }
    else if (!isIN && !isAUS && value.length > 5) {
        return false;
    }
    else
        return true;

}, "Australian Zip Code Must Be at least 4 Digits");


jQuery.validator.addMethod("countrycode1", function (value, element) {
    if (value.length < 2 || value.length > 3)
    { return false; }
    else
        return true;
}, "Please specify a valid country code number"
);
jQuery.validator.addMethod("areacode", function (value, element) {
    if (value.length < 2 || value.length > 6)
    { return false; }
    else {
        return this.optional(element);
        return true;
    }
}, "Please specify a valid area code"
);
jQuery.validator.addMethod("phonecode", function (value, element) {
    if (value.length < 9)
    { return false; }
    else {
        return this.optional(element);
        return true;
    }
}, "Please specify a valid Phone number"
);
jQuery.validator.addMethod("mobilecode", function (value, element) {
    if (value.length < 11)
    { return false; }
    else {
        return this.optional(element);
        return true;
    }
}, "Please specify a valid Phone number"
);

$.validator.addMethod("email_not_same", function (value, element) {
    var emailChk = $("#email").val();

    if (emailChk != value) {
        return false;
    }
    else
        return true;

}, "* Email did not match");


$.validator.addMethod("secondemail_not_same", function (value, element) {
    var emailChk = $("#email2").val();

    if (emailChk != value) {
        return false;
    }
    else
        return true;

}, "* Email did not match");

jQuery.validator.addMethod("alphanumericuserid", function (value, element) {
    return this.optional(element) && /^[a-zA-Z0-9]+$/i.test(value);
}, "This field should be only alphanumeric");

jQuery.validator.addMethod("pwdchk", function (value, element) {
    return this.optional(element) || /^.*(?=.{6,10})(?=.*[a-zA-Z0-9])(?=.*[\W_]).*$/.test(value);
}, "Password should >6 & <10 characters and should contain special characters");

$.validator.addMethod("pwd_not_same", function (value, element) {
    var pwdChk = $("[id*=txtNewPassword]").val();

    if (pwdChk != value) {
        return false;
    }
    else
        return true;

}, "Password did not match");

jQuery.validator.addMethod("phone_number", function (value, element) {
    return this.optional(element) || value.length > 10 &&
  value.match(/^(\(?(0|\+44)[1-9]{1}\d{1,4}?\)?\s?\d{3,4}\s?\d{3,4})$/);
}, "Please specify a valid phone number"
);

jQuery.validator.addMethod("countrycode", function (value, element) {

    if (value == "+91") {
        return true;
    }
    else {
        return this.optional(element);
        return false;
    }


}, "Please specify a country code"
);
jQuery.validator.addMethod("areacode1", function (value, element) {
    if (value.length < 2 || value.length > 6)
    { return false; }
    else {
        return this.optional(element);
        return true;
    }
}, "Please specify a valid area code"
);
jQuery.validator.addMethod("phonecode1", function (value, element) {
    if (value.length < 9)
    { return false; }
    else {
        return true;
    }
}, "Please specify a valid Phone number"
);
jQuery.validator.addMethod("mobilecode", function (value, element) {
    if (value.length < 10)
    { return false; }
    else {

        return true;
    }
}, "Please specify a valid Mobile number"
);


$.validator.addMethod("cb_selectone", function (value, element) {
    if ($("input[type=checkbox]").val("checked"))
        return true;
    else
        return false;
}, "Please select the checkbox terms and use and privacy policy");


jQuery.validator.addMethod("alphanumeric", function (value, element) {
    return this.optional(element) || /^([a-z]|\d|\s|-|\.|_|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+$/i;
}, "Letters, numbers, spaces or underscores only please");


jQuery.validator.addMethod("emailUsernameCheck", function (value, element) {
    var isSuccess = false;
    $("#msgbox1").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "emailUser_availability.php",
        data: "email=" + value + "&userid=" + document.getElementById('userid').value,
        async: false,
        success:
                function (msg) {
                    if (msg.match("false")) //if email not avaiable
                    {
                        $("#msgbox1").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This email address already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox1").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Email address available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });


    if (isSuccess.match("false"))
        return false;
    else
        return true;


}, "");

jQuery.validator.addMethod("emailUsernameCheckUI", function (value, element) {
    var isSuccess = false;
    $("#msgbox1").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "emailUser_availability.php",
        data: "email=" + value,
        async: false,
        success:
                function (msg) {
                    //alert(msg);
                    if (msg.match("false")) //if email not avaiable
                    {
                        $("#msgbox1").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This email address already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox1").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Email address available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });


    if (isSuccess.match("false"))
        return false;
    else
        return true;


}, "");


jQuery.validator.addMethod("usernameCheckUI", function (value, element) {
    var isSuccess = false;
    $("#msgbox").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "user_availability.php",
        data: "uname=" + value,
        async: false,
        success:
                function (msg) {

                    if (msg.match("false")) //if username not avaiable
                    {
                        $("#msgbox").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This username already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Username available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });


    if (isSuccess.match("false"))
        return false;
    else
        return true;


}, "");


jQuery.validator.addMethod("usernameCheck", function (value, element) {
    var isSuccess = false;
    $("#msgbox").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "user_availability.php",
        data: "uname=" + value + "&userid=" + document.getElementById('userid').value,
        async: false,
        success:
                function (msg) {

                    if (msg.match("false")) //if username not avaiable
                    {
                        $("#msgbox").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This username already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Username available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });


    if (isSuccess.match("false"))
        return false;
    else
        return true;


}, "");

jQuery.validator.addMethod("emailUsernameCheckVendor", function (value, element) {
    var isSuccess = false;
    $("#msgbox1").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "emailVendor_availability.php",
        data: "email=" + value + "&userid=" + document.getElementById('userid').value,
        async: false,
        success:
                function (msg) {


                    if (msg.match("false")) //if email not avaiable
                    {
                        $("#msgbox1").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This email address already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox1").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Email address available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });


    if (isSuccess.match("false"))
        return false;
    else
        return true;


}, "");



jQuery.validator.addMethod("usernameCheckVendor", function (value, element) {
    var isSuccess = false;

    $("#msgbox").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "vendor_availability.php",
        data: "uname=" + value + "&userid=" + document.getElementById('userid').value,
        async: false,
        success:
                function (msg) {
                    if (msg.match("false")) //if username not avaiable
                    {
                        $("#msgbox").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This username already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Username available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });

    if (isSuccess.match("false"))
        return false;
    else
        return true;
}, "");


jQuery.validator.addMethod("emailUsernameCheckSP", function (value, element) {
    var isSuccess = false;
    $("#msgbox1").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "emailSP_availability.php",
        data: "email=" + value + "&userid=" + document.getElementById('userid').value,
        async: false,
        success:
                function (msg) {

                    if (msg.match("false")) //if email not avaiable
                    {
                        $("#msgbox1").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This email address already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox1").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Email address available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });


    if (isSuccess.match("false"))
        return false;
    else
        return true;


}, "");


jQuery.validator.addMethod("emailUsernameCheckSPUI", function (value, element) {
    var isSuccess = false;
    $("#msgbox1").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "emailSP_availability.php",
        data: "email=" + value,
        async: false,
        success:
                function (msg) {

                    if (msg.match("false")) //if email not avaiable
                    {
                        $("#msgbox1").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This email address already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox1").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Email address available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });


    if (isSuccess.match("false"))
        return false;
    else
        return true;


}, "");



jQuery.validator.addMethod("usernameCheckSer", function (value, element) {
    var isSuccess = false;

    $("#msgbox").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "sp_availability.php",
        data: "uname=" + value + "&userid=" + document.getElementById('userid').value,
        async: false,
        success:
                function (msg) {
                    if (msg.match("false")) //if username not avaiable
                    {
                        $("#msgbox").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This username already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Username available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });

    if (isSuccess.match("false"))
        return false;
    else
        return true;
}, "");



jQuery.validator.addMethod("usernameCheckPSP", function (value, element) {
    var isSuccess = false;

    $("#msgbox").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "psp_user_availability.php",
        data: "uname=" + value + "&userid=" + document.getElementById('userid').value,
        async: false,
        success:
                function (msg) {
                    if (msg.match("false")) //if username not avaiable
                    {
                        $("#msgbox").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This username already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Username available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });

    if (isSuccess.match("false"))
        return false;
    else
        return true;
}, "");



jQuery.validator.addMethod("emailUsernameCheckPSP", function (value, element) {
    var isSuccess = false;
    $("#msgbox1").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "psp_emailUser_availability.php",
        data: "email=" + value + "&userid=" + document.getElementById('userid').value,
        async: false,
        success:
                function (msg) {

                    if (msg.match("false")) //if email not avaiable
                    {
                        $("#msgbox1").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This email address already exists").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox1").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Email address available to register").addClass("messageboxok").fadeTo(900, 1);
                        });
                    }


                    isSuccess = msg;
                }
    });


    if (isSuccess.match("false"))
        return false;
    else
        return true;


}, "");



jQuery.validator.addMethod("adCheck", function (value, element) {
    var isSuccess = false;

    $("#msgbox").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "ads_availability.php",
        data: "position=" + value,
        async: false,
        success:
                function (msg) {

                    if (msg.match("false")) //if username not avaiable
                    {
                        $("#msgbox").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This Ad positon is not available. Please select another one").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Ad position is available").addClass("messageboxok").fadeTo(900, 1);

                        });
                    }

                    //alert(isSuccess);
                    isSuccess = msg;
                }
    });

    if (isSuccess.match("false"))
        return false;
    else
        return true;
}, "");


jQuery.validator.addMethod("adCheckadmin", function (value, element) {
    var isSuccess = false;

    $("#msgbox").removeClass().addClass("messagebox").text('Checking...').fadeIn("slow");
    $.ajax({
        type: "POST",
        url: "ads_availability.php",
        data: "position=" + value + "&aid=" + document.getElementById('aid').value,
        async: false,
        success:
                function (msg) {

                    if (msg.match("false")) //if username not avaiable
                    {
                        $("#msgbox").fadeTo(200, 0.1, function () //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("This Ad positon is not available.").addClass("messageboxerror").fadeTo(900, 1);
                            return false;
                        });
                    }
                    else {
                        $("#msgbox").fadeTo(200, 0.1, function ()  //start fading the messagebox
                        {
                            //add message and change the class of the box and start fading
                            $(this).html("Ad position is available").addClass("messageboxok").fadeTo(900, 1);

                        });
                    }

                    //alert(isSuccess);
                    isSuccess = msg;
                }
    });

    if (isSuccess.match("false"))
        return false;
    else
        return true;
}, "");


jQuery.validator.addMethod("nowhitespace", function (value, element) {
    return this.optional(element) || /^\S+$/i.test(value);
}, "No white space please");

jQuery.validator.addMethod("ziprange", function (value, element) {
    return this.optional(element) || /^90[2-5]\d\{2}-\d{4}$/.test(value);
}, "Your ZIP-code must be in the range 902xx-xxxx to 905-xx-xxxx");

jQuery.validator.addMethod("zip", function (value, element) {
    return this.optional(element) || /^90[2-5]\d\{2}-\d{4}$/.test(value);
}, "Your ZIP-code must be in the range 902xx-xxxx to 905-xx-xxxx");

jQuery.validator.addMethod("integer", function (value, element) {
    return this.optional(element) || /^-?\d+$/.test(value);
}, "A positive or negative non-decimal number please");

/**
* Return true, if the value is a valid vehicle identification number (VIN).
*
* Works with all kind of text inputs.
*
* @example <input type="text" size="20" name="VehicleID" class="{required:true,vinUS:true}" />
* @desc Declares a required input element whose value must be a valid vehicle identification number.
*
* @name jQuery.validator.methods.vinUS
* @type Boolean
* @cat Plugins/Validate/Methods
*/
jQuery.validator.addMethod(
	"vinUS",
	function (v) {
	    if (v.length != 17)
	        return false;
	    var i, n, d, f, cd, cdv;
	    var LL = ["A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
	    var VL = [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 7, 9, 2, 3, 4, 5, 6, 7, 8, 9];
	    var FL = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2];
	    var rs = 0;
	    for (i = 0; i < 17; i++) {
	        f = FL[i];
	        d = v.slice(i, i + 1);
	        if (i == 8) {
	            cdv = d;
	        }
	        if (!isNaN(d)) {
	            d *= f;
	        }
	        else {
	            for (n = 0; n < LL.length; n++) {
	                if (d.toUpperCase() === LL[n]) {
	                    d = VL[n];
	                    d *= f;
	                    if (isNaN(cdv) && n == 8) {
	                        cdv = LL[n];
	                    }
	                    break;
	                }
	            }
	        }
	        rs += d;
	    }
	    cd = rs % 11;
	    if (cd == 10) { cd = "X"; }
	    if (cd == cdv) { return true; }
	    return false;
	},
	"The specified vehicle identification number (VIN) is invalid."
);

/**
* Return true, if the value is a valid date, also making this formal check dd/mm/yyyy.
*
* @example jQuery.validator.methods.date("01/01/1900")
* @result true
*
* @example jQuery.validator.methods.date("01/13/1990")
* @result false
*
* @example jQuery.validator.methods.date("01.01.1900")
* @result false
*
* @example <input name="pippo" class="{dateITA:true}" />
* @desc Declares an optional input element whose value must be a valid date.
*
* @name jQuery.validator.methods.dateITA
* @type Boolean
* @cat Plugins/Validate/Methods
*/
jQuery.validator.addMethod(
	"dateITA",
	function (value, element) {
	    var check = false;
	    var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
	    if (re.test(value)) {
	        var adata = value.split('/');
	        var gg = parseInt(adata[0], 10);
	        var mm = parseInt(adata[1], 10);
	        var aaaa = parseInt(adata[2], 10);
	        var xdata = new Date(aaaa, mm - 1, gg);
	        if ((xdata.getFullYear() == aaaa) && (xdata.getMonth() == mm - 1) && (xdata.getDate() == gg))
	            check = true;
	        else
	            check = false;
	    } else
	        check = false;
	    return this.optional(element) || check;
	},
	"Please enter a correct date"
);

jQuery.validator.addMethod("dateNL", function (value, element) {
    return this.optional(element) || /^\d\d?[\.\/-]\d\d?[\.\/-]\d\d\d?\d?$/.test(value);
}, "Please enter a correct date."
);

jQuery.validator.addMethod("time", function (value, element) {
    return this.optional(element) || /^([01]\d|2[0-3])(:[0-5]\d){0,2}$/.test(value);
}, "Please enter a valid time, between 00:00 and 23:59");
jQuery.validator.addMethod("time12h", function (value, element) {
    return this.optional(element) || /^((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))$/i.test(value);
}, "Please enter a valid time, between 00:00 am and 12:00 pm");

/**
* matches US phone number format
*
* where the area code may not start with 1 and the prefix may not start with 1
* allows '-' or ' ' as a separator and allows parens around area code
* some people may want to put a '1' in front of their number
*
* 1(212)-999-2345
* or
* 212 999 2344
* or
* 212-999-0983
*
* but not
* 111-123-5434
* and not
* 212 123 4567
*/
jQuery.validator.addMethod("phoneUS", function (phone_number, element) {
    phone_number = phone_number.replace(/\s+/g, "");
    return this.optional(element) || phone_number.length > 9 &&
		phone_number.match(/^(1-?)?(\([2-9]\d{2}\)|[2-9]\d{2})-?[2-9]\d{2}-?\d{4}$/);
}, "Please specify a valid phone number");

jQuery.validator.addMethod('phoneUK', function (phone_number, element) {
    return this.optional(element) || phone_number.length > 9 &&
phone_number.match(/^(\(?(0|\+44)[1-9]{1}\d{1,4}?\)?\s?\d{3,4}\s?\d{3,4})$/);
}, 'Please specify a valid phone number');

jQuery.validator.addMethod('mobileUK', function (phone_number, element) {
    return this.optional(element) || phone_number.length > 9 &&
phone_number.match(/^((0|\+44)7(5|6|7|8|9){1}\d{2}\s?\d{6})$/);
}, 'Please specify a valid mobile number');

// TODO check if value starts with <, otherwise don't try stripping anything
jQuery.validator.addMethod("strippedminlength", function (value, element, param) {
    return jQuery(value).text().length >= param;
}, jQuery.validator.format("Please enter at least {0} characters"));

// same as email, but TLD is optional
jQuery.validator.addMethod("email2", function (value, element, param) {
    return this.optional(element) || /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)*(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(value);
}, jQuery.validator.messages.email);

// same as url, but TLD is optional
jQuery.validator.addMethod("url2", function (value, element, param) {
    return this.optional(element) || /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)*(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(value);
}, jQuery.validator.messages.url);

// NOTICE: Modified version of Castle.Components.Validator.CreditCardValidator
// Redistributed under the the Apache License 2.0 at http://www.apache.org/licenses/LICENSE-2.0
// Valid Types: mastercard, visa, amex, dinersclub, enroute, discover, jcb, unknown, all (overrides all other settings)
jQuery.validator.addMethod("creditcardtypes", function (value, element, param) {

    if (/[^0-9-]+/.test(value))
        return false;

    value = value.replace(/\D/g, "");

    var validTypes = 0x0000;

    if (param.mastercard)
        validTypes |= 0x0001;
    if (param.visa)
        validTypes |= 0x0002;
    if (param.amex)
        validTypes |= 0x0004;
    if (param.dinersclub)
        validTypes |= 0x0008;
    if (param.enroute)
        validTypes |= 0x0010;
    if (param.discover)
        validTypes |= 0x0020;
    if (param.jcb)
        validTypes |= 0x0040;
    if (param.unknown)
        validTypes |= 0x0080;
    if (param.all)
        validTypes = 0x0001 | 0x0002 | 0x0004 | 0x0008 | 0x0010 | 0x0020 | 0x0040 | 0x0080;

    if (validTypes & 0x0001 && /^(51|52|53|54|55)/.test(value)) { //mastercard
        return value.length == 16;
    }
    if (validTypes & 0x0002 && /^(4)/.test(value)) { //visa
        return value.length == 16;
    }
    if (validTypes & 0x0004 && /^(34|37)/.test(value)) { //amex
        return value.length == 15;
    }
    if (validTypes & 0x0008 && /^(300|301|302|303|304|305|36|38)/.test(value)) { //dinersclub
        return value.length == 14;
    }
    if (validTypes & 0x0010 && /^(2014|2149)/.test(value)) { //enroute
        return value.length == 15;
    }
    if (validTypes & 0x0020 && /^(6011)/.test(value)) { //discover
        return value.length == 16;
    }
    if (validTypes & 0x0040 && /^(3)/.test(value)) { //jcb
        return value.length == 16;
    }
    if (validTypes & 0x0040 && /^(2131|1800)/.test(value)) { //jcb
        return value.length == 15;
    }
    if (validTypes & 0x0080) { //unknown
        return true;
    }
    return false;
}, "Please enter a valid credit card number.");

jQuery.validator.addMethod("ipv4", function (value, element, param) {
    return this.optional(element) || /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/i.test(value);
}, "Please enter a valid IP v4 address.");

jQuery.validator.addMethod("ipv6", function (value, element, param) {
    return this.optional(element) || /^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$/i.test(value);
}, "Please enter a valid IP v6 address.");

/**
* Return true if the field value matches the given format RegExp
*
* @example jQuery.validator.methods.pattern("AR1004",element,/^AR\d{4}$/)
* @result true
*
* @example jQuery.validator.methods.pattern("BR1004",element,/^AR\d{4}$/)
* @result false
*
* @name jQuery.validator.methods.pattern
* @type Boolean
* @cat Plugins/Validate/Methods
*/
jQuery.validator.addMethod("pattern", function (value, element, param) {
    return this.optional(element) || param.test(value);
}, "Invalid format.");

