$('document').ready(function(){
  $('.user_error p').each(function(){
    selector = "#" + $(this).text();
    $(selector).parent().after("<span class='error-small' style='color:red;'>" + $(this).siblings('span').text() + "</span>");
    $(".error-small:contains('blank')").text("Required");
  });
});
