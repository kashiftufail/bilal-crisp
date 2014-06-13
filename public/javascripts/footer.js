 $('document').ready(function(){
  if ($.browser.webkit)        
    $('#footer_wrapper').css('min-height', ($(document).height() - window.screen.height) + 300);
  else
    $('#footer_wrapper').css('min-height', (window.screen.height - $(document).height()) + 200);
});
