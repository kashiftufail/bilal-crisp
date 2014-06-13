$(function() {

  // class name for form is 'suscribe' by designer
  $('form.suscribe').submit(function(eventObject) {
    var $input_field = $(this).find('.input');
    var input_value = $input_field.val();
    if(input_value == 'Enter your email address') {
      $(this).val('');
    }
    var regex = new RegExp(/\w+@\w+(\.\w)+/)
    if(!regex.test(input_value)) {
      return false;
    }
  });

  $('form.suscribe .input').blur(function(eventObject) {
    var input_value = $(this).val();
    if(input_value.length == 0) {
      $(this).val('Enter your email address');
    }
  });

  $('form.suscribe .input').focus(function(eventObject) {
    var input_value = $(this).val();
    if(input_value == 'Enter your email address') {
      $(this).val('');
    }
  });
});
