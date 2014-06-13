// Login Form
$('document').ready(function() {
    var button = $('#loginButton');
    $(button).click(function(){
      $("#loginBox").toggle();
    })
    $("#forgot_password").click(function(){
      $("#loginBox").html($("#forgot_password_form").html());
    });

});

